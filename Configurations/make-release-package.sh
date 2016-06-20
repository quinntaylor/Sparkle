#!/bin/bash
set -e

if [ "$ACTION" = "" ] ; then
    rm -rf "$CONFIGURATION_BUILD_DIR/staging"
    rm -f "Sparkle-$CURRENT_PROJECT_VERSION.tar.bz2"

    mkdir -p "$CONFIGURATION_BUILD_DIR/staging"
    cp "$SRCROOT/CHANGELOG" "$SRCROOT/LICENSE" "$SRCROOT/INSTALL" "$SRCROOT/Resources/SampleAppcast.xml" "$CONFIGURATION_BUILD_DIR/staging"
    cp -R "$SRCROOT/bin" "$CONFIGURATION_BUILD_DIR/staging"
    cp "$CONFIGURATION_BUILD_DIR/BinaryDelta" "$CONFIGURATION_BUILD_DIR/staging/bin"
    cp -R "$CONFIGURATION_BUILD_DIR/Sparkle Test App.app" "$CONFIGURATION_BUILD_DIR/staging"
    cp -R "$CONFIGURATION_BUILD_DIR/Sparkle.framework" "$CONFIGURATION_BUILD_DIR/staging"

    mkdir -p "$CONFIGURATION_BUILD_DIR/staging/XPCServices"

    cp -R "$CONFIGURATION_BUILD_DIR/SparkleInstallerLauncher.xpc" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    cp -R "$CONFIGURATION_BUILD_DIR/SparklePersistentDownloader.xpc" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    cp -R "$CONFIGURATION_BUILD_DIR/SparkleTemporaryDownloader.xpc" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    cp -R "$CONFIGURATION_BUILD_DIR/SparkleLocalMessagePort.xpc" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    cp -R "$CONFIGURATION_BUILD_DIR/SparkleRemoteMessagePort.xpc" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"

    cp "$SRCROOT/TemporaryDownloader/SparkleTemporaryDownloader.entitlements" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    cp "$SRCROOT/PersistentDownloader/SparklePersistentDownloader.entitlements" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"

    # Only copy dSYMs for Release builds, but don't check for the presence of the actual files
    # because missing dSYMs in a release build SHOULD trigger a build failure
    if [ "$CONFIGURATION" = "Release" ] ; then
        cp -R "$CONFIGURATION_BUILD_DIR/BinaryDelta.dSYM" "$CONFIGURATION_BUILD_DIR/staging/bin"
        cp -R "$CONFIGURATION_BUILD_DIR/Sparkle Test App.app.dSYM" "$CONFIGURATION_BUILD_DIR/staging"
        cp -R "$CONFIGURATION_BUILD_DIR/Sparkle.framework.dSYM" "$CONFIGURATION_BUILD_DIR/staging"

        cp -R "$CONFIGURATION_BUILD_DIR/SparkleInstallerLauncher.xpc.dSYM" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
        cp -R "$CONFIGURATION_BUILD_DIR/SparklePersistentDownloader.xpc.dSYM" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
        cp -R "$CONFIGURATION_BUILD_DIR/SparkleTemporaryDownloader.xpc.dSYM" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
        cp -R "$CONFIGURATION_BUILD_DIR/SparkleLocalMessagePort.xpc.dSYM" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
        cp -R "$CONFIGURATION_BUILD_DIR/SparkleRemoteMessagePort.xpc.dSYM" "$CONFIGURATION_BUILD_DIR/staging/XPCServices"
    fi

    cd "$CONFIGURATION_BUILD_DIR/staging"
    # Sorted file list groups similar files together, which improves tar compression
    find . \! -type d | rev | sort | rev | tar cjvf "../Sparkle-$CURRENT_PROJECT_VERSION.tar.bz2" --files-from=-
    rm -rf "$CONFIGURATION_BUILD_DIR/staging"
fi
