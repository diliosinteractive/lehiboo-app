#!/usr/bin/env python3
"""Validate release metadata and production mobile configuration.

This script intentionally uses only Python's standard library so it can run in
GitHub Actions, Xcode Cloud, and a developer checkout without extra packages.
It never prints environment values because mobile configuration can contain
credentials that must stay out of CI logs, even though they are extractable
from a shipped application binary.
"""

from __future__ import annotations

import argparse
import os
import plistlib
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import urlparse


VERSION_PATTERN = re.compile(
    r"^version:\s*['\"]?(?P<name>\d+\.\d+\.\d+)\+(?P<number>\d+)['\"]?\s*$",
    re.MULTILINE,
)
ENV_KEY_PATTERN = re.compile(r"^[A-Z][A-Z0-9_]*$")

REQUIRED_PRODUCTION_KEYS = (
    "ENVIRONMENT",
    "API_BASE_URL",
    "AI_BASE_URL",
    "PETIT_BOO_BASE_URL",
    "API_KEY",
    "WEBSITE_URL",
    "FIREBASE_PROJECT_ID",
    "FIREBASE_MESSAGING_SENDER_ID",
    "FIREBASE_APP_ID",
    "ONESIGNAL_APP_ID",
    "GOOGLE_MAPS_API_KEY",
    "ANALYTICS_ENABLED",
    "CRASHLYTICS_ENABLED",
    "PUSHER_APP_KEY",
    "PUSHER_APP_CLUSTER",
    "PUSHER_HOST",
    "PUSHER_PORT",
    "PUSHER_USE_TLS",
    "PUSHER_AUTH_ENDPOINT",
    "STRIPE_PUBLISHABLE_KEY",
)
HTTPS_KEYS = (
    "API_BASE_URL",
    "AI_BASE_URL",
    "PETIT_BOO_BASE_URL",
    "WEBSITE_URL",
    "PUSHER_AUTH_ENDPOINT",
)
NON_PRODUCTION_HOST_MARKERS = (
    "localhost",
    "127.0.0.1",
    "0.0.0.0",
    "example.com",
    "example.invalid",
    ".test",
    "staging",
    "preprod",
    "sandbox",
)


@dataclass(frozen=True)
class ReleaseVersion:
    name: str
    number: int


class ValidationFailure(Exception):
    def __init__(self, errors: list[str]) -> None:
        self.errors = errors
        super().__init__("; ".join(errors))


def read_release_version(pubspec_path: Path) -> ReleaseVersion:
    match = VERSION_PATTERN.search(pubspec_path.read_text(encoding="utf-8"))
    if match is None:
        raise ValueError(
            f"{pubspec_path}: version must use the release format x.y.z+integer"
        )
    return ReleaseVersion(match.group("name"), int(match.group("number")))


def parse_env_file(env_path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    errors: list[str] = []

    for line_number, raw_line in enumerate(
        env_path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line.removeprefix("export ").lstrip()
        if "=" not in line:
            errors.append(f"{env_path}:{line_number}: expected KEY=value")
            continue

        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip()
        if not ENV_KEY_PATTERN.fullmatch(key):
            errors.append(f"{env_path}:{line_number}: invalid environment key {key!r}")
            continue
        if key in values:
            errors.append(f"{env_path}:{line_number}: duplicate key {key}")
            continue
        if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
            value = value[1:-1]
        values[key] = value

    if errors:
        raise ValidationFailure(errors)
    return values


def _validate_https_url(key: str, value: str) -> list[str]:
    parsed = urlparse(value)
    errors: list[str] = []
    if parsed.scheme != "https" or not parsed.hostname:
        errors.append(f"{key} must be an absolute HTTPS URL")
        return errors
    if parsed.username or parsed.password:
        errors.append(f"{key} must not contain inline credentials")
    hostname = parsed.hostname.lower()
    if any(marker in hostname for marker in NON_PRODUCTION_HOST_MARKERS):
        errors.append(f"{key} points to a non-production or placeholder host")
    return errors


def validate_production_environment(env_path: Path) -> list[str]:
    try:
        values = parse_env_file(env_path)
    except ValidationFailure as failure:
        return failure.errors

    errors: list[str] = []
    for key in REQUIRED_PRODUCTION_KEYS:
        if not values.get(key, "").strip():
            errors.append(f"{env_path}: missing required production value {key}")

    if values.get("ENVIRONMENT", "").lower() != "production":
        errors.append(f"{env_path}: ENVIRONMENT must be production")

    for key in HTTPS_KEYS:
        value = values.get(key, "").strip()
        if value:
            errors.extend(_validate_https_url(key, value))

    pusher_host = values.get("PUSHER_HOST", "").strip().lower()
    if pusher_host:
        if "://" in pusher_host or "/" in pusher_host:
            errors.append("PUSHER_HOST must be a hostname without a scheme or path")
        if any(marker in pusher_host for marker in NON_PRODUCTION_HOST_MARKERS):
            errors.append("PUSHER_HOST points to a non-production or placeholder host")

    pusher_port = values.get("PUSHER_PORT", "").strip()
    if pusher_port and (not pusher_port.isdigit() or not 1 <= int(pusher_port) <= 65535):
        errors.append("PUSHER_PORT must be an integer between 1 and 65535")
    if values.get("PUSHER_USE_TLS", "").lower() != "true":
        errors.append("PUSHER_USE_TLS must be true for production")

    for key in ("ANALYTICS_ENABLED", "CRASHLYTICS_ENABLED"):
        value = values.get(key, "").lower()
        if value and value not in ("true", "false"):
            errors.append(f"{key} must be true or false")

    stripe_key = values.get("STRIPE_PUBLISHABLE_KEY", "").strip()
    if stripe_key and not stripe_key.startswith("pk_live_"):
        errors.append("STRIPE_PUBLISHABLE_KEY must be a live publishable key in production")

    return errors


def _validate_release_ref(ref: str, version: ReleaseVersion) -> list[str]:
    accepted = {
        f"release/{version.name}",
        f"refs/heads/release/{version.name}",
        f"v{version.name}",
        f"refs/tags/v{version.name}",
    }
    if ref not in accepted:
        return [
            f"release ref {ref!r} does not match version {version.name}; "
            f"use release/{version.name} or tag v{version.name}"
        ]
    return []


def _validate_android(android_gradle_path: Path) -> list[str]:
    content = android_gradle_path.read_text(encoding="utf-8")
    errors: list[str] = []
    required_fragments = {
        "versionCode = flutter.versionCode": "Android versionCode must come from pubspec.yaml",
        "versionName = flutter.versionName": "Android versionName must come from pubspec.yaml",
        'signingConfig = signingConfigs.getByName("release")': (
            "Android release builds must use the release signing config"
        ),
        "isReleaseBuildRequested && !hasReleaseKeystore": (
            "Android release builds must fail when release signing is unavailable"
        ),
    }
    for fragment, message in required_fragments.items():
        if fragment not in content:
            errors.append(message)
    if 'signingConfigs.getByName("debug")' in content:
        errors.append("Android release configuration must never fall back to debug signing")
    return errors


def _validate_ios(info_plist_path: Path, xcode_cloud_script_path: Path) -> list[str]:
    errors: list[str] = []
    with info_plist_path.open("rb") as plist_file:
        info = plistlib.load(plist_file)
    if info.get("CFBundleShortVersionString") != "$(FLUTTER_BUILD_NAME)":
        errors.append("iOS CFBundleShortVersionString must use FLUTTER_BUILD_NAME")
    if info.get("CFBundleVersion") != "$(FLUTTER_BUILD_NUMBER)":
        errors.append("iOS CFBundleVersion must use FLUTTER_BUILD_NUMBER")

    script = xcode_cloud_script_path.read_text(encoding="utf-8")
    required_fragments = {
        "CI_BUILD_NUMBER": "Xcode Cloud must use its unique CI build number",
        'agvtool new-marketing-version "$PUBSPEC_MARKETING_VERSION"': (
            "Xcode Cloud must synchronize the iOS marketing version"
        ),
        'agvtool new-version -all "$XCODE_BUILD_NUMBER"': (
            "Xcode Cloud must synchronize build numbers across the app and extensions"
        ),
        "validate_release.py": "Xcode Cloud must run the shared release validator",
    }
    for fragment, message in required_fragments.items():
        if fragment not in script:
            errors.append(message)
    return errors


def validate_repository(
    root: Path,
    *,
    expected_version: str | None = None,
    expected_build_number: int | None = None,
    ref: str | None = None,
    env_file: Path | None = None,
) -> ReleaseVersion:
    errors: list[str] = []
    try:
        version = read_release_version(root / "pubspec.yaml")
    except (OSError, ValueError) as error:
        raise ValidationFailure([str(error)]) from error

    if expected_version and version.name != expected_version:
        errors.append(
            f"pubspec version is {version.name}, expected {expected_version}"
        )
    if expected_build_number is not None and version.number != expected_build_number:
        errors.append(
            f"pubspec build number is {version.number}, expected {expected_build_number}"
        )
    if ref:
        errors.extend(_validate_release_ref(ref, version))

    try:
        errors.extend(_validate_android(root / "android/app/build.gradle.kts"))
    except OSError as error:
        errors.append(str(error))
    try:
        errors.extend(
            _validate_ios(
                root / "ios/Runner/Info.plist",
                root / "ios/ci_scripts/ci_post_clone.sh",
            )
        )
    except (OSError, plistlib.InvalidFileException) as error:
        errors.append(str(error))

    if env_file is not None:
        try:
            errors.extend(validate_production_environment(env_file))
        except OSError as error:
            errors.append(str(error))

    if errors:
        raise ValidationFailure(errors)
    return version


def _positive_integer(raw_value: str) -> int:
    value = int(raw_value)
    if value < 1:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return value


def _write_github_output(path: Path, version: ReleaseVersion) -> None:
    with path.open("a", encoding="utf-8") as output:
        output.write(f"release_version={version.name}\n")
        output.write(f"release_build_number={version.number}\n")
        output.write(f"release_label={version.name}+{version.number}\n")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--expected-version")
    parser.add_argument("--expected-build-number", type=_positive_integer)
    parser.add_argument("--ref", help="Git ref or release branch to validate")
    parser.add_argument("--env-file", type=Path)
    parser.add_argument("--github-output", type=Path)
    args = parser.parse_args(argv)

    try:
        version = validate_repository(
            args.root.resolve(),
            expected_version=args.expected_version,
            expected_build_number=args.expected_build_number,
            ref=args.ref,
            env_file=args.env_file.resolve() if args.env_file else None,
        )
    except ValidationFailure as failure:
        prefix = "::error::" if os.environ.get("GITHUB_ACTIONS") == "true" else "error: "
        for error in failure.errors:
            print(f"{prefix}{error}", file=sys.stderr)
        return 1

    if args.github_output:
        _write_github_output(args.github_output, version)
    print(f"Release validation passed for {version.name}+{version.number}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
