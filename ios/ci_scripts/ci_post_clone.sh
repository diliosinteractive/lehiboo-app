#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
# Traverse up to reach the root of the repository.
cd "$(dirname "$0")/../.."

echo "Repository Root: $(pwd)"

# Install Flutter
# Clone Flutter SDK to a temporary location in the home directory
echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Run flutter doctor to download Dart SDK and tools
echo "Running flutter doctor..."
flutter doctor -v

# Install Flutter dependencies
echo "Running flutter pub get..."
flutter pub get

# Install CocoaPods dependencies
echo "Installing CocoaPods dependencies..."
cd ios
pod install --repo-update

echo "Build setup complete!"
