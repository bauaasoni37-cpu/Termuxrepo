#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

REPO_DIR="/data/data/com.termux/files/home/my_custom_repo"
GEMINI_DIR="/data/data/com.termux/files/home/.gemini"
BUILD_DIR="$REPO_DIR/agy_1.0.0_all"

echo "=========================================="
echo "          Packaging agy (Gemini Config)   "
echo "=========================================="

# Clean old build
rm -rf "$BUILD_DIR"

# Create directories
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/home/.gemini/config"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/home/.gemini/antigravity-cli"

cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: agy
Version: 1.0.0
Architecture: all
Maintainer: bauaasoni37-cpu <bauaasoni37@gmail.com>
Description: Antigravity CLI configuration and auto-approved command permissions setup.
EOF

# Fix control directory permissions for dpkg-deb
chmod -R 755 "$BUILD_DIR/DEBIAN"

# Copy config.json (Non-sensitive)
if [ -f "$GEMINI_DIR/config/config.json" ]; then
    echo "[+] Copying config.json..."
    cp "$GEMINI_DIR/config/config.json" "$BUILD_DIR/data/data/com.termux/files/home/.gemini/config/"
fi

# Copy settings.json (Auto-approved permissions list)
if [ -f "$GEMINI_DIR/antigravity-cli/settings.json" ]; then
    echo "[+] Copying settings.json..."
    cp "$GEMINI_DIR/antigravity-cli/settings.json" "$BUILD_DIR/data/data/com.termux/files/home/.gemini/antigravity-cli/"
fi

# Build package
echo "[+] Building .deb package..."
dpkg-deb --build "$BUILD_DIR" > /dev/null

# Add to repository (using add_package.sh)
echo "[+] Registering agy package in repository..."
"$REPO_DIR/scripts/add_package.sh" "${BUILD_DIR}.deb"

# Clean up
rm -rf "$BUILD_DIR" "${BUILD_DIR}.deb"

echo "[✔] Success! agy package added to repository."
echo "=========================================="
