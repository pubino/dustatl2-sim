#!/bin/bash
#
# setup-notarization.sh - Interactive setup for Apple notarization credentials
#
set -e

KEYCHAIN_PROFILE="${KEYCHAIN_PROFILE:-JanusSim-notarize}"

echo "=== Apple Notarization Setup ==="
echo ""
echo "This script will store your Apple Developer credentials securely"
echo "in the macOS Keychain for notarization."
echo ""
echo "You will need:"
echo "  1. Your Apple ID (email)"
echo "  2. Your Team ID (from developer.apple.com/account)"
echo "  3. An app-specific password (from appleid.apple.com)"
echo ""

if xcrun notarytool history --keychain-profile "$KEYCHAIN_PROFILE" &>/dev/null 2>&1; then
    echo "Existing credentials found for profile: $KEYCHAIN_PROFILE"
    read -p "Do you want to replace them? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing credentials."
        exit 0
    fi
fi

read -p "Apple ID: " APPLE_ID
read -p "Team ID: " TEAM_ID
read -s -p "App-Specific Password: " APP_PASSWORD
echo ""

xcrun notarytool store-credentials "$KEYCHAIN_PROFILE" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_PASSWORD"

echo "Credentials stored successfully!"
