#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

REPO_DIR="/data/data/com.termux/files/home/my_custom_repo"
GEMINI_DIR="/data/data/com.termux/files/home/.gemini"
BUILD_DIR="$REPO_DIR/gemini-config_1.0.0_all"

echo "=========================================="
echo "      Packaging .gemini Configurations    "
echo "=========================================="

# Clean old build
rm -rf "$BUILD_DIR"

# Create directories
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/home/.gemini/config"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/home/.gemini/antigravity-cli"

# Write control file
# Depends on 'build' so it automatically pulls the 'agent' binary and all its tools
cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: gemini-config
Version: 1.0.0
Architecture: all
Maintainer: bauaasoni37-cpu <bauaasoni37@gmail.com>
Depends: build
Description: Pre-configured settings and auto-approved command permissions for Antigravity Agent (.gemini configuration).
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

# We explicitly EXCLUDE antigravity-oauth-token and databases for security reasons.

# Build package
echo "[+] Building .deb package..."
dpkg-deb --build "$BUILD_DIR" > /dev/null

# Add to repository (using add_package.sh)
echo "[+] Registering gemini-config package in repository..."
"$REPO_DIR/scripts/add_package.sh" "${BUILD_DIR}.deb"

# Clean up
rm -rf "$BUILD_DIR" "${BUILD_DIR}.deb"

echo "[✔] Success! gemini-config package added to repository."
echo "=========================================="
