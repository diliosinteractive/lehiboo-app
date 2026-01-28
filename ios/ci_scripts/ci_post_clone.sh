#!/bin/sh

# Fail this script if any subcommand fails.
set -e

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
# Using --repo-update to ensure we get the latest specs
pod install --repo-update

echo "Build setup complete!"

# Prepare Flutter iOS Build
# This step ensures that Generated.xcconfig and other Flutter build artifacts are present.
# We use --config-only to avoid a full build here, as Xcode will handle the archiving.
# We also use --no-codesign to avoid signing issues during this preparation phase.
echo "Preparing Flutter iOS build..."

# Use FLUTTER_ENV variable from Xcode Cloud (default to production for safety)
# Note: Xcode Cloud reserves CI_ prefix, so we use FLUTTER_ENV instead
APP_ENV="${FLUTTER_ENV:-production}"
echo "Building for environment: $APP_ENV"

flutter build ios --config-only --no-codesign --release --dart-define=ENV=$APP_ENV

# Note: Xcode Cloud will proceed to build the 'Runner' scheme after this script finishes.

