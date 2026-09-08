# Mobile release-candidate CI

This runbook describes the release path shared by Android and iOS. A single
`release/<version>` branch identifies the exact source commit, while each
platform keeps the distribution system already used by the project:

- GitHub Actions validates the release commit and produces the signed Android
  App Bundle (`.aab`). It does **not** upload to Google Play.
- Xcode Cloud listens to the same `release/*` branch, creates the signed iOS
  archive, and can distribute it to TestFlight through its configured
  post-action.

Keeping Apple signing in Xcode Cloud avoids maintaining a second set of Apple
certificates and provisioning profiles in GitHub.

## Release identity

`pubspec.yaml` is the source of truth and must contain:

```yaml
version: <marketing-version>+<android-build-number>
```

For example, `version: 1.0.6+7` maps as follows:

| Platform | Store field | Value source |
| --- | --- | --- |
| Android | `versionName` | `1.0.6` from `pubspec.yaml` |
| Android | `versionCode` | `7` from `pubspec.yaml` |
| iOS | `CFBundleShortVersionString` | `1.0.6` from `pubspec.yaml` |
| iOS | `CFBundleVersion` | Xcode Cloud's unique `CI_BUILD_NUMBER` |

The iOS build number is intentionally independent from Android's build number.
Xcode Cloud owns and increments it. The post-clone script applies that number
to both the Runner app and the OneSignal notification extension.

The branch name must match the marketing version exactly. Version `1.0.6`
therefore uses `release/1.0.6`.

## One-time GitHub setup

Open the repository's
[Environments settings](https://github.com/diliosinteractive/lehiboo-app/settings/environments)
and create an environment named exactly `production`.

Required baseline protection:

1. Limit deployment branches to `release/*`.
2. Keep all Android release values in environment secrets so they are not
   exposed to preflight or pull-request jobs.

If the organization plan exposes required reviewers for this private
repository, also add at least one reviewer who understands the mobile release
and disable self-approval. Do not rely on this control without checking the
environment settings: GitHub limits required reviewers for private repositories
on some plans. When review protection is unavailable, pushing the correctly
versioned release branch is the release authorization, just as it is for the
existing Xcode Cloud trigger.

Add these **environment secrets**, not repository variables:

| Secret | Content |
| --- | --- |
| `MOBILE_PRODUCTION_ENV` | Complete multiline production `.env` content |
| `ANDROID_UPLOAD_KEYSTORE_BASE64` | Existing Android/Play upload keystore encoded as base64 |
| `ANDROID_UPLOAD_STORE_PASSWORD` | Keystore password |
| `ANDROID_UPLOAD_KEY_ALIAS` | Upload-key alias inside the keystore |
| `ANDROID_UPLOAD_KEY_PASSWORD` | Upload-key password |

Do not generate a replacement key if LeHiboo already has an upload key in
Google Play Console. Use the existing upload keystore or complete Google's
upload-key reset procedure first.

Encode the existing keystore without line wrapping:

```bash
base64 < /absolute/path/to/upload-keystore.jks | tr -d '\n'
```

Paste the output into `ANDROID_UPLOAD_KEYSTORE_BASE64`. Do not save the encoded
value in this repository, a ticket, or a release document.

### `MOBILE_PRODUCTION_ENV` format

Store one `KEY=value` per line. Quotes are optional. Duplicate keys, empty
critical values, non-HTTPS endpoints, placeholder/staging hosts, disabled TLS,
and a Stripe test key make the release fail before compilation.

Use this as a key-name template only; replace every placeholder in GitHub's
secret editor:

```dotenv
ENVIRONMENT=production
API_BASE_URL=https://<production-api>/api/v1
AI_BASE_URL=https://<production-api>/api-planner
PETIT_BOO_BASE_URL=https://<production-petit-boo-host>
API_KEY=<mobile-api-key>
WEBSITE_URL=https://<production-web-host>
FIREBASE_PROJECT_ID=<firebase-project-id>
FIREBASE_MESSAGING_SENDER_ID=<firebase-sender-id>
FIREBASE_APP_ID=<firebase-app-id>
ONESIGNAL_APP_ID=<onesignal-app-id>
GOOGLE_MAPS_API_KEY=<restricted-mobile-maps-key>
ANALYTICS_ENABLED=true
CRASHLYTICS_ENABLED=true
HT_USERNAME=
HT_PASSWORD=
SECURITY_HEADER_NAME=Authorization
PUSHER_APP_KEY=<reverb-or-pusher-public-key>
PUSHER_APP_CLUSTER=eu
PUSHER_HOST=<production-websocket-host-without-scheme>
PUSHER_PORT=443
PUSHER_USE_TLS=true
PUSHER_AUTH_ENDPOINT=https://<production-api>/broadcasting/auth
STRIPE_PUBLISHABLE_KEY=pk_live_<redacted>
```

These values are packaged in the mobile binary and can be extracted by an end
user. Only put mobile-safe configuration and publishable/restricted client keys
in this file. Never put a Stripe secret key, backend database credential,
Firebase service-account key, or other server credential in it.

## One-time Xcode Cloud check

The existing Xcode Cloud release workflow remains responsible for iOS. In App
Store Connect or Xcode, verify that the workflow:

1. Triggers on changes to `release/*` branches.
2. Archives the `Runner` scheme for iOS.
3. Uses `FLUTTER_ENV=production`.
4. Has a TestFlight distribution post-action if automatic beta distribution is
   desired.
5. Has the production variables listed below. Mark credentials and API keys as
   secret values so Xcode Cloud masks them in logs.

The post-clone script reads:

```text
API_BASE_URL
AI_BASE_URL
PETIT_BOO_BASE_URL
API_KEY
WEBSITE_URL
FIREBASE_PROJECT_ID
FIREBASE_MESSAGING_SENDER_ID
FIREBASE_APP_ID
ONESIGNAL_APP_ID
GOOGLE_MAPS_API_KEY
ANALYTICS_ENABLED
CRASHLYTICS_ENABLED
HT_USERNAME
HT_PASSWORD
SECURITY_HEADER_NAME
PUSHER_APP_KEY
PUSHER_APP_CLUSTER
PUSHER_HOST
PUSHER_PORT
PUSHER_USE_TLS
PUSHER_AUTH_ENDPOINT
STRIPE_PUBLISHABLE_KEY
```

Production archives now fail if release validation or critical configuration
fails. `CI_BUILD_NUMBER` is supplied automatically by Xcode Cloud; do not add it
as a custom variable.

## Creating a release candidate

Prepare the version before the branch is first pushed. Pushing an unversioned
release branch would start both CI systems with the wrong identity.

```bash
git fetch origin
git switch develop
git pull --ff-only origin develop
git switch -c release/1.0.6
```

Update the single `version:` line in `pubspec.yaml`. The Android Gradle project
now reads both values from Flutter, and the Xcode Cloud post-clone script applies
the iOS values, so no manual version edit in Gradle or Xcode is required.

Before the first push, run:

```bash
python3 -m unittest discover -s tool/release/tests -p 'test_*.py' -v
python3 tool/release/validate_release.py \
  --root . \
  --expected-version 1.0.6 \
  --expected-build-number 7 \
  --ref release/1.0.6
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings
flutter test --no-pub
```

Commit the version change and all intended release changes, then push once:

```bash
git push -u origin release/1.0.6
```

That push starts:

1. GitHub preflight: release metadata validation, analyzer, and all Flutter
   tests against the exact release commit.
2. GitHub Android build: applies any protection configured on the `production`
   environment, validates the real production environment, verifies the upload
   keystore, builds an obfuscated signed AAB, and verifies its signature.
3. Xcode Cloud iOS build: independently prepares the pinned Flutter SDK,
   validates production configuration, synchronizes the app and extension
   versions, archives, and follows the workflow's TestFlight policy.

Because GitHub Actions and Xcode Cloud are separate systems, a GitHub approval
gate, when available, does not pause Xcode Cloud. Treat the branch push itself
as authorization to start the iOS release candidate.

## Android outputs

The successful GitHub run retains one artifact for 90 days:

```text
android-production-<version>+<build-number>
```

It contains:

- `lehiboo-<version>+<build-number>.aab`
- Dart obfuscation/symbol files as a compressed archive
- `release-metadata.json` containing the platform, version, commit, ref, and CI
  run URL
- `SHA256SUMS` covering all three files

After downloading it, verify integrity from inside the artifact directory:

```bash
sha256sum -c SHA256SUMS
```

Upload the AAB to Google Play's internal testing track first. Keep the symbol
archive with the release; it is required to interpret obfuscated Dart stack
traces.

## Manual rerun and optional GitHub draft

The workflow can also be started with **Actions → Mobile Release Candidate →
Run workflow**. Select the matching `release/<version>` branch and enter the
exact version and Android build number. The values are checked against
`pubspec.yaml`; they do not override it.

Select **Create a draft GitHub release** only if a repository release record is
wanted. It creates `v<version>` as a draft at the exact tested commit and
attaches the Android artifacts. It refuses to replace an existing tag or
release.

GitHub only exposes `workflow_dispatch` in the Actions UI after this workflow
file also exists on the repository's default branch. The automatic
`release/*` push trigger works from release branches that contain the workflow.

## Final release verification

Before promoting either candidate to production, confirm:

- GitHub preflight and signed Android jobs are green for the same commit SHA.
- The AAB metadata shows the expected Android `versionName` and `versionCode`.
- The checksum and signature verification completed successfully.
- Google Play accepts the AAB on the internal track without a reused build-code
  error.
- Xcode Cloud archived the same commit and shows the expected marketing
  version.
- TestFlight accepted Xcode Cloud's build number and the OneSignal extension.
- A short smoke test passes on both internal Android and TestFlight builds,
  especially login, paid booking, Stripe checkout return, ticket display,
  push notification, deep link, and logout.

If a release candidate changes after either artifact is produced, increment the
appropriate build counter and rebuild both platforms from the new commit. Never
reuse an already-uploaded Android version code or iOS build number.

## Common failures

| Failure | Meaning / fix |
| --- | --- |
| Branch does not match version | Rename/recreate it as `release/<pubspec marketing version>` |
| Missing `MOBILE_PRODUCTION_ENV` | Add it to the GitHub `production` environment, not as a plain variable |
| Placeholder or staging host | Replace the affected URL/host with production configuration |
| Stripe key is not `pk_live_…` | Supply the production publishable key; never use `sk_live_…` in mobile |
| Android release signing is not configured | Restore all four Android signing secrets and the existing upload keystore |
| `keytool` cannot open the keystore | Correct the base64 content, store password, or alias |
| Xcode Cloud reports missing values | Complete the release workflow's environment in App Store Connect/Xcode |
| Existing GitHub tag | Do not overwrite it; bump the version or investigate the prior release |
