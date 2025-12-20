#!/bin/bash
#
# create-app-bundle.sh - Create macOS .app bundle for Dust at L2 Simulator
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
APP_NAME="DustAtL2Simulator"
DISPLAY_NAME="Dust at L2 Simulator"
BUNDLE_ID="edu.princeton.vanderbei.dustatl2-sim"
VERSION="1.0.0"

echo "=== Creating macOS App Bundle ==="

if [ ! -f "$DIST_DIR/DustAtL2Sim.jar" ]; then
    echo "JAR not found. Running build first..."
    "$SCRIPT_DIR/build.sh"
fi

if [ "$1" == "--use-jpackage" ]; then
    echo "Using jpackage to create self-contained app..."
    if ! command -v jpackage &> /dev/null; then
        echo "Error: jpackage not found. Requires Java 14+."
        exit 1
    fi
    rm -rf "$DIST_DIR/$APP_NAME.app"
    jpackage \
        --type app-image \
        --name "$APP_NAME" \
        --input "$DIST_DIR" \
        --main-jar DustAtL2Sim.jar \
        --main-class astro.galaxy.DustAtL2 \
        --dest "$DIST_DIR" \
        --app-version "$VERSION" \
        --vendor "Vanderbei" \
        --mac-package-identifier "$BUNDLE_ID" \
        --mac-package-name "$DISPLAY_NAME" \
        --java-options "-Xmx512m"
    echo "Created: $DIST_DIR/$APP_NAME.app (with bundled JRE)"
else
    echo "Creating lightweight app bundle (requires system Java)..."
    APP_DIR="$DIST_DIR/$APP_NAME.app"
    CONTENTS_DIR="$APP_DIR/Contents"
    MACOS_DIR="$CONTENTS_DIR/MacOS"
    RESOURCES_DIR="$CONTENTS_DIR/Resources"
    rm -rf "$APP_DIR"
    mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
    cp "$DIST_DIR/DustAtL2Sim.jar" "$RESOURCES_DIR/"
    cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launcher</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$DISPLAY_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$DISPLAY_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
EOF
    cat > "$MACOS_DIR/launcher" << 'EOF'
#!/bin/bash
if [ -n "$JAVA_HOME" ]; then
    JAVA="$JAVA_HOME/bin/java"
elif /usr/libexec/java_home &> /dev/null; then
    JAVA="$(/usr/libexec/java_home)/bin/java"
else
    JAVA="java"
fi
if ! command -v "$JAVA" &> /dev/null; then
    osascript -e 'display dialog "Java is required but not installed.\n\nPlease install Java from https://adoptium.net" buttons {"OK"} default button "OK" with icon stop with title "Dust at L2 Simulator"'
    exit 1
fi
DIR="$(cd "$(dirname "$0")/../Resources" && pwd)"
exec "$JAVA" -Xmx512m -Dapple.awt.application.name="Dust at L2 Simulator" -Xdock:name="Dust at L2 Simulator" -jar "$DIR/DustAtL2Sim.jar"
EOF
    chmod +x "$MACOS_DIR/launcher"
    echo "Created: $APP_DIR"
fi
