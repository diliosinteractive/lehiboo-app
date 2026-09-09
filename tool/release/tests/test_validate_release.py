from __future__ import annotations

import plistlib
import tempfile
import unittest
from pathlib import Path

from tool.release.validate_release import (
    ValidationFailure,
    parse_env_file,
    validate_repository,
)


GOOD_ANDROID = """
val hasReleaseKeystore = true
val isReleaseBuildRequested = true
if (isReleaseBuildRequested && !hasReleaseKeystore) { error("missing") }
android {
    defaultConfig {
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
"""

GOOD_XCODE_SCRIPT = """
XCODE_BUILD_NUMBER="${CI_BUILD_NUMBER:-$PUBSPEC_BUILD_NUMBER}"
python3 tool/release/validate_release.py --env-file "$ENV_FILE"
xcrun agvtool new-marketing-version "$PUBSPEC_MARKETING_VERSION"
xcrun agvtool new-version -all "$XCODE_BUILD_NUMBER"
"""

GOOD_ENV = """\
ENVIRONMENT=production
API_BASE_URL=https://api.lehiboo.com/api/v1
AI_BASE_URL=https://api.lehiboo.com/api-planner
PETIT_BOO_BASE_URL=https://petitboo.lehiboo.com
API_KEY=mobile-api-key
WEBSITE_URL=https://lehiboo.com
FIREBASE_PROJECT_ID=lehiboo-production
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:ios:abcdef
ONESIGNAL_APP_ID=11111111-2222-3333-4444-555555555555
GOOGLE_MAPS_API_KEY=maps-key
ANALYTICS_ENABLED=true
CRASHLYTICS_ENABLED=true
PUSHER_APP_KEY=pusher-key
PUSHER_APP_CLUSTER=eu
PUSHER_HOST=reverb.lehiboo.com
PUSHER_PORT=443
PUSHER_USE_TLS=true
PUSHER_AUTH_ENDPOINT=https://api.lehiboo.com/broadcasting/auth
STRIPE_PUBLISHABLE_KEY=pk_live_fixture
"""


class ReleaseRepositoryFixture:
    def __init__(self, root: Path) -> None:
        self.root = root
        (root / "android/app").mkdir(parents=True)
        (root / "ios/Runner").mkdir(parents=True)
        (root / "ios/ci_scripts").mkdir(parents=True)
        (root / "pubspec.yaml").write_text("version: 1.2.3+45\n", encoding="utf-8")
        (root / "android/app/build.gradle.kts").write_text(
            GOOD_ANDROID, encoding="utf-8"
        )
        with (root / "ios/Runner/Info.plist").open("wb") as plist_file:
            plistlib.dump(
                {
                    "CFBundleShortVersionString": "$(FLUTTER_BUILD_NAME)",
                    "CFBundleVersion": "$(FLUTTER_BUILD_NUMBER)",
                },
                plist_file,
            )
        (root / "ios/ci_scripts/ci_post_clone.sh").write_text(
            GOOD_XCODE_SCRIPT, encoding="utf-8"
        )
        (root / ".env.production").write_text(GOOD_ENV, encoding="utf-8")


class ValidateReleaseTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary_directory.name)
        self.fixture = ReleaseRepositoryFixture(self.root)

    def tearDown(self) -> None:
        self.temporary_directory.cleanup()

    def assert_validation_error(self, expected: str, **overrides: object) -> None:
        arguments: dict[str, object] = {
            "expected_version": "1.2.3",
            "expected_build_number": 45,
            "ref": "refs/heads/release/1.2.3",
            "env_file": self.root / ".env.production",
        }
        arguments.update(overrides)
        with self.assertRaises(ValidationFailure) as context:
            validate_repository(self.root, **arguments)  # type: ignore[arg-type]
        self.assertIn(expected, "\n".join(context.exception.errors))

    def test_valid_release_configuration_passes(self) -> None:
        version = validate_repository(
            self.root,
            expected_version="1.2.3",
            expected_build_number=45,
            ref="refs/heads/release/1.2.3",
            env_file=self.root / ".env.production",
        )
        self.assertEqual(version.name, "1.2.3")
        self.assertEqual(version.number, 45)

    def test_version_input_must_match_pubspec(self) -> None:
        self.assert_validation_error(
            "pubspec version is 1.2.3, expected 1.2.4",
            expected_version="1.2.4",
        )

    def test_release_branch_must_match_marketing_version(self) -> None:
        self.assert_validation_error(
            "does not match version 1.2.3",
            ref="refs/heads/release/1.2.4",
        )

    def test_production_environment_requires_stripe(self) -> None:
        env_path = self.root / ".env.production"
        env_path.write_text(
            GOOD_ENV.replace("STRIPE_PUBLISHABLE_KEY=pk_live_fixture\n", ""),
            encoding="utf-8",
        )
        self.assert_validation_error("STRIPE_PUBLISHABLE_KEY")

    def test_production_environment_rejects_staging_host(self) -> None:
        env_path = self.root / ".env.production"
        env_path.write_text(
            GOOD_ENV.replace("api.lehiboo.com", "staging-api.lehiboo.com"),
            encoding="utf-8",
        )
        self.assert_validation_error("non-production or placeholder host")

    def test_production_environment_requires_live_stripe_key(self) -> None:
        env_path = self.root / ".env.production"
        env_path.write_text(
            GOOD_ENV.replace("pk_live_fixture", "pk_test_fixture"),
            encoding="utf-8",
        )
        self.assert_validation_error("must be a live publishable key")

    def test_android_release_must_not_fall_back_to_debug_signing(self) -> None:
        gradle_path = self.root / "android/app/build.gradle.kts"
        gradle_path.write_text(
            GOOD_ANDROID.replace(
                'signingConfigs.getByName("release")',
                'signingConfigs.getByName("debug")',
            ),
            encoding="utf-8",
        )
        self.assert_validation_error("must never fall back to debug signing")

    def test_ios_uses_flutter_version_macros(self) -> None:
        with (self.root / "ios/Runner/Info.plist").open("wb") as plist_file:
            plistlib.dump(
                {
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "$(FLUTTER_BUILD_NUMBER)",
                },
                plist_file,
            )
        self.assert_validation_error("must use FLUTTER_BUILD_NAME")

    def test_xcode_cloud_validates_templates_before_agvtool_mutates_them(self) -> None:
        script_path = self.root / "ios/ci_scripts/ci_post_clone.sh"
        script_path.write_text(
            GOOD_XCODE_SCRIPT.replace(
                'python3 tool/release/validate_release.py --env-file "$ENV_FILE"\n',
                "",
            )
            + 'python3 tool/release/validate_release.py --env-file "$ENV_FILE"\n',
            encoding="utf-8",
        )
        self.assert_validation_error("must validate iOS templates before agvtool")

    def test_duplicate_environment_key_is_rejected(self) -> None:
        env_path = self.root / ".env.production"
        env_path.write_text(GOOD_ENV + "API_KEY=duplicate\n", encoding="utf-8")
        with self.assertRaises(ValidationFailure) as context:
            parse_env_file(env_path)
        self.assertIn("duplicate key API_KEY", "\n".join(context.exception.errors))


if __name__ == "__main__":
    unittest.main()
