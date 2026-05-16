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

echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

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
if ! command -v pod &> /dev/null; then
    echo "CocoaPods not found. Installing..."
    sudo gem install cocoapods
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

# Keep release App Store marketing version in sync with pubspec.yaml.
# Flutter commonly uses x.y.z+build; iOS marketing version is the x.y.z part.
PUBSPEC_VERSION=$(awk '/^[[:space:]]*version:[[:space:]]*/ { version=$2; gsub(/"/, "", version); print version; exit }' pubspec.yaml)
PUBSPEC_MARKETING_VERSION="${PUBSPEC_VERSION%%+*}"
IS_RELEASE_WORKFLOW=false
case "${CI_WORKFLOW:-}" in
    "Release Workflow")
        IS_RELEASE_WORKFLOW=true
        ;;
esac
case "${CI_BRANCH:-}" in
    release/*|refs/heads/release/*)
        IS_RELEASE_WORKFLOW=true
        ;;
esac

if [ "$IS_RELEASE_WORKFLOW" = true ]; then
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

    echo "Release workflow detected (${CI_WORKFLOW:-unknown workflow}, branch ${CI_BRANCH:-unknown branch})"
    echo "Using marketing version $PUBSPEC_MARKETING_VERSION from pubspec.yaml"

    cd ios
    xcrun agvtool new-marketing-version "$PUBSPEC_MARKETING_VERSION"
    cd ..
else
    echo "Non-release workflow detected (${CI_WORKFLOW:-unknown workflow}, branch ${CI_BRANCH:-unknown branch}); using default Flutter versioning"
fi

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
EOF

# Validate that critical secrets were actually provided by the workflow
missing=""
for var in API_KEY GOOGLE_MAPS_API_KEY ONESIGNAL_APP_ID PUSHER_APP_KEY; do
    eval value=\$$var
    [ -z "$value" ] && missing="$missing $var"
done
if [ -n "$missing" ]; then
    echo "⚠️  Missing Xcode Cloud workflow secrets:$missing"
    echo "    Add them in App Store Connect → Xcode Cloud → Workflow → Environment (toggle 🔒 for secrets)"
fi

echo "Generated $ENV_FILE ($(wc -l < "$ENV_FILE") lines)"

# Re-enable verbose tracing for the rest of the build
set -x

if [ "$IS_RELEASE_WORKFLOW" = true ]; then
    flutter build ios --config-only --no-codesign --release --build-name="$PUBSPEC_MARKETING_VERSION" --dart-define=ENV=$APP_ENV
else
    flutter build ios --config-only --no-codesign --release --dart-define=ENV=$APP_ENV
fi

# Note: Xcode Cloud will proceed to build the 'Runner' scheme after this script finishes.
