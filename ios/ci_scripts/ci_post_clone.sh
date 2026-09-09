#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# Enable verbose mode for debugging
set -x

# The default execution directory of this script is the ci_scripts directory.
# Traverse up to reach the root of the repository.
cd "$(dirname "$0")/../.."

echo "Repository Root: $(pwd)"

# Install Flutter
# Check if Flutter is already installed/cached
if [ -d "$HOME/flutter" ]; then
    echo "Flutter directory found at $HOME/flutter. Removing to ensure clean install."
    rm -rf "$HOME/flutter"
fi

# `.fvmrc` is the single source of truth for the Flutter SDK used locally and
# by Xcode Cloud. Cloning `-b stable` would pull whatever stable is *today* and
# make release builds non-reproducible.
if [ ! -f .fvmrc ]; then
    echo "error: Missing .fvmrc Flutter version pin"
    exit 1
fi

FLUTTER_VERSION=$(awk -F'"' '/"flutter"[[:space:]]*:/ { print $4; exit }' .fvmrc)
if [ -z "$FLUTTER_VERSION" ]; then
    echo "error: Unable to read the Flutter version from .fvmrc"
    exit 1
fi

echo "Installing Flutter SDK $FLUTTER_VERSION..."
git clone https://github.com/flutter/flutter.git --depth 1 -b "$FLUTTER_VERSION" $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Disable Swift Package Manager integration.
# Project uses CocoaPods exclusively (see Podfile + Podfile.lock). Xcode Cloud has
# automatic SPM dependency resolution disabled, and no Package.resolved is committed,
# so leaving SPM enabled causes xcodebuild to fail when Flutter injects SPM-backed
# transitive deps (e.g. DKImagePickerController from file_picker).
flutter config --no-enable-swift-package-manager

# Run flutter doctor to download Dart SDK and tools
echo "Running flutter doctor..."
flutter doctor -v

# Precache iOS artifacts (optional but recommended)
echo "Precaching iOS artifacts..."
flutter precache --ios

# Install Flutter dependencies
echo "Running flutter pub get..."
flutter pub get

# Install CocoaPods dependencies
echo "Installing CocoaPods dependencies..."
cd ios

# Ensure we have a Gemfile for reproducible builds if possible, but for now rely on system pod
# Check if pod is available
if ! command -v pod > /dev/null 2>&1; then
    echo "CocoaPods not found. Installing..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
else
    echo "CocoaPods is installed. Version: $(pod --version)"
fi

# Run pod install
pod install

echo "Build setup complete!"

# Return to project root for Flutter build
cd ..
echo "Current directory: $(pwd)"

# Prepare Flutter iOS Build
# This step ensures that Generated.xcconfig and other Flutter build artifacts are present.
# We use --config-only to avoid a full build here, as Xcode will handle the archiving.
# We also use --no-codesign to avoid signing issues during this preparation phase.
echo "Preparing Flutter iOS build..."

# Use FLUTTER_ENV variable from Xcode Cloud (default to production for safety)
# Note: Xcode Cloud reserves CI_ prefix, so we use FLUTTER_ENV instead
APP_ENV="${FLUTTER_ENV:-production}"
echo "Building for environment: $APP_ENV"

# Keep iOS App Store marketing version in sync with pubspec.yaml for ALL workflows.
# pubspec uses x.y.z+build; iOS marketing version (CFBundleShortVersionString) is the x.y.z part.
# Build number (CFBundleVersion) is left to Xcode Cloud's auto-increment.
PUBSPEC_VERSION=$(awk '/^[[:space:]]*version:[[:space:]]*/ { version=$2; gsub(/"/, "", version); print version; exit }' pubspec.yaml)
PUBSPEC_MARKETING_VERSION="${PUBSPEC_VERSION%%+*}"
PUBSPEC_BUILD_NUMBER="${PUBSPEC_VERSION#*+}"

if [ -z "$PUBSPEC_MARKETING_VERSION" ]; then
    echo "error: Unable to extract marketing version from pubspec.yaml version '$PUBSPEC_VERSION'"
    exit 1
fi
case "$PUBSPEC_MARKETING_VERSION" in
    *[!0-9.]*|.*|*.|*..*|"")
        echo "error: Invalid iOS marketing version '$PUBSPEC_MARKETING_VERSION' extracted from pubspec.yaml"
        exit 1
        ;;
esac

if [ "$PUBSPEC_BUILD_NUMBER" = "$PUBSPEC_VERSION" ]; then
    echo "error: pubspec.yaml version must include an integer build number"
    exit 1
fi

# Xcode Cloud owns the monotonically increasing iOS build number. Local/manual
# executions fall back to the build number in pubspec.yaml.
XCODE_BUILD_NUMBER="${CI_BUILD_NUMBER:-$PUBSPEC_BUILD_NUMBER}"
case "$XCODE_BUILD_NUMBER" in
    *[!0-9]*|""|0)
        echo "error: Invalid iOS build number '$XCODE_BUILD_NUMBER'"
        exit 1
        ;;
esac

echo "Workflow: ${CI_WORKFLOW:-unknown workflow} on branch ${CI_BRANCH:-unknown branch}"
echo "Using marketing version $PUBSPEC_MARKETING_VERSION from pubspec.yaml"
echo "Using Xcode build number $XCODE_BUILD_NUMBER"

# Generate .env.$APP_ENV from Xcode Cloud workflow environment variables.
# These are configured in App Store Connect → Xcode Cloud → Workflow → Environment.
# Mark sensitive values (API_KEY, GOOGLE_MAPS_API_KEY, HT_*, PUSHER_APP_KEY...) as secrets (🔒).
# The .env files are gitignored, so they MUST be reconstructed here for flutter_dotenv to find them.
ENV_FILE=".env.$APP_ENV"
echo "Generating $ENV_FILE from Xcode Cloud environment variables..."

# Disable verbose tracing to keep secret values out of build logs
set +x

cat > ".env.development" <<EOF
ENVIRONMENT=development
EOF

cat > ".env.staging" <<EOF
ENVIRONMENT=staging
EOF

cat > ".env.production" <<EOF
ENVIRONMENT=production
EOF

cat > ".env" <<EOF
ENVIRONMENT=production
EOF


cat > "$ENV_FILE" <<EOF
ENVIRONMENT=$APP_ENV
API_BASE_URL=${API_BASE_URL}
AI_BASE_URL=${AI_BASE_URL}
PETIT_BOO_BASE_URL=${PETIT_BOO_BASE_URL}
API_KEY=${API_KEY}
WEBSITE_URL=${WEBSITE_URL}
FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}
FIREBASE_MESSAGING_SENDER_ID=${FIREBASE_MESSAGING_SENDER_ID}
FIREBASE_APP_ID=${FIREBASE_APP_ID}
ONESIGNAL_APP_ID=${ONESIGNAL_APP_ID}
GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}
ANALYTICS_ENABLED=${ANALYTICS_ENABLED}
CRASHLYTICS_ENABLED=${CRASHLYTICS_ENABLED}
HT_USERNAME=${HT_USERNAME}
HT_PASSWORD=${HT_PASSWORD}
SECURITY_HEADER_NAME=${SECURITY_HEADER_NAME}
PUSHER_APP_KEY=${PUSHER_APP_KEY}
PUSHER_APP_CLUSTER=${PUSHER_APP_CLUSTER}
PUSHER_HOST=${PUSHER_HOST}
PUSHER_PORT=${PUSHER_PORT}
PUSHER_USE_TLS=${PUSHER_USE_TLS}
PUSHER_AUTH_ENDPOINT=${PUSHER_AUTH_ENDPOINT}
STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY}
EOF

# Validate that critical configuration was actually provided by the workflow.
# A production archive must never succeed with payment, maps, push, or realtime
# silently disabled.
missing=""
for var in API_KEY GOOGLE_MAPS_API_KEY ONESIGNAL_APP_ID PUSHER_APP_KEY STRIPE_PUBLISHABLE_KEY; do
    value=$(printenv "$var" 2> /dev/null || true)
    [ -z "$value" ] && missing="$missing $var"
done
if [ -n "$missing" ]; then
    if [ "$APP_ENV" = "production" ]; then
        echo "error: Missing Xcode Cloud workflow values:$missing"
        echo "Add them in App Store Connect → Xcode Cloud → Workflow → Environment."
        exit 1
    fi
    echo "warning: Missing non-production Xcode Cloud workflow values:$missing"
fi

echo "Generated $ENV_FILE ($(wc -l < "$ENV_FILE") lines)"
cp "$ENV_FILE" .env

# Run the same version checks used by the Android release workflow, adding the
# strict environment gate for production archives.
if [ "$APP_ENV" = "production" ]; then
    python3 tool/release/validate_release.py --root . --env-file "$ENV_FILE"
else
    python3 tool/release/validate_release.py --root .
fi

# Re-enable verbose tracing for the rest of the build
set -x

# Validate the committed Info.plist templates before agvtool replaces their
# Flutter version macros with concrete values in Xcode Cloud's temporary checkout.
cd ios
xcrun agvtool new-marketing-version "$PUBSPEC_MARKETING_VERSION"
xcrun agvtool new-version -all "$XCODE_BUILD_NUMBER"
cd ..

flutter build ios --config-only --no-codesign --release \
    --build-name="$PUBSPEC_MARKETING_VERSION" \
    --build-number="$XCODE_BUILD_NUMBER" \
    --dart-define=ENV="$APP_ENV"

# Note: Xcode Cloud will proceed to build the 'Runner' scheme after this script finishes.
