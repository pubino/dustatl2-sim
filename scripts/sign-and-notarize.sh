#!/bin/bash
#
# sign-and-notarize.sh - Sign and notarize Janus-Epimetheus Simulator for macOS distribution
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_DIR/dist"
APP_NAME="JanusSimulator"
APP_PATH="$DIST_DIR/$APP_NAME.app"
DMG_PATH="$DIST_DIR/JanusSim.dmg"
ZIP_PATH="$DIST_DIR/JanusSim.zip"

DEVELOPER_ID_APP="${DEVELOPER_ID_APP:-Developer ID Application: Your Name (TEAM_ID)}"
KEYCHAIN_PROFILE="${KEYCHAIN_PROFILE:-JanusSim-notarize}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Janus-Epimetheus Simulator Signing & Notarization ==="

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}Error: App bundle not found at $APP_PATH${NC}"
    echo "Run create-app-bundle.sh first."
    exit 1
fi

echo "Available signing identities:"
security find-identity -v -p codesigning | grep "Developer ID Application" || true

if ! security find-identity -v -p codesigning | grep -q "Developer ID Application"; then
    echo -e "${RED}Error: No 'Developer ID Application' certificate found in Keychain.${NC}"
    exit 1
fi

echo -e "${YELLOW}Signing application...${NC}"
ENTITLEMENTS="$DIST_DIR/entitlements.plist"
cat > "$ENTITLEMENTS" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
</dict>
</plist>
EOF

codesign --force --deep --options runtime --timestamp \
    --sign "$DEVELOPER_ID_APP" \
    --entitlements "$ENTITLEMENTS" \
    "$APP_PATH"

codesign --verify --deep --strict --verbose=2 "$APP_PATH"
echo -e "${GREEN}Signing complete!${NC}"

if [ "$1" == "--skip-notarize" ]; then
    echo "Skipping notarization"
    exit 0
fi

echo -e "${YELLOW}Creating ZIP for notarization...${NC}"
rm -f "$ZIP_PATH"
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo -e "${YELLOW}Submitting for notarization...${NC}"
xcrun notarytool submit "$ZIP_PATH" --keychain-profile "$KEYCHAIN_PROFILE" --wait

echo -e "${YELLOW}Stapling ticket...${NC}"
xcrun stapler staple "$APP_PATH"

echo -e "${GREEN}Complete!${NC}"
