#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Repository directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
HOME_DIR="/data/data/com.termux/files/home"

echo "=========================================="
echo "      Auto .deb Repository Packager       "
echo "=========================================="

# 1. Ask for Package Name
read -p "[?] Enter Package Name (e.g. mytool): " PKG_NAME
if [ -z "$PKG_NAME" ]; then
    echo "Error: Package name cannot be empty."
    exit 1
fi
# Standardize package name: lowercase and strip spaces/special characters
PKG_NAME=$(echo "$PKG_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')

# 2. Ask for File Name
read -p "[?] Enter script file name to search (e.g. nandu.sh): " FILE_NAME
if [ -z "$FILE_NAME" ]; then
    echo "Error: File name cannot be empty."
    exit 1
fi

# 3. Find the File
echo "[+] Searching for file '$FILE_NAME' in home directory..."
FOUND_PATH=$(find "$HOME_DIR" -name "$FILE_NAME" -type f -print -quit 2>/dev/null)

if [ -z "$FOUND_PATH" ]; then
    echo "[-] File '$FILE_NAME' not found automatically."
    read -p "[?] Please enter the absolute path of the file manually: " MANUAL_PATH
    if [ -f "$MANUAL_PATH" ]; then
        FOUND_PATH="$MANUAL_PATH"
    else
        echo "Error: File not found at manual path '$MANUAL_PATH'."
        exit 1
    fi
else
    echo "[+] Found file at: $FOUND_PATH"
fi

# 4. Ask for basic metadata (with defaults)
read -p "[?] Enter Version [1.0.0]: " PKG_VER
PKG_VER="${PKG_VER:-1.0.0}"

read -p "[?] Enter Description [Auto-packaged script: $PKG_NAME]: " PKG_DESC
PKG_DESC="${PKG_DESC:-Auto-packaged script: $PKG_NAME}"

# 5. Create temporary packaging directory
BUILD_DIR="${REPO_DIR}/${PKG_NAME}_${PKG_VER}_all"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/usr/bin"

# Write control metadata
cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: $PKG_NAME
Version: $PKG_VER
Architecture: all
Maintainer: bauaasoni37-cpu <bauaasoni37@gmail.com>
Description: $PKG_DESC
EOF

# Copy file as package binary and make executable
DEST_BIN="$BUILD_DIR/data/data/com.termux/files/usr/bin/$PKG_NAME"
cp "$FOUND_PATH" "$DEST_BIN"
chmod +x "$DEST_BIN"

# 6. Build the debian package
echo "[+] Compiling .deb package..."
dpkg-deb --build "$BUILD_DIR" > /dev/null

DEB_FILE="${BUILD_DIR}.deb"

# 7. Add package to repository (using add_package.sh)
echo "[+] Registering package in the repository..."
"$SCRIPT_DIR/add_package.sh" "$DEB_FILE"

# Clean up build files
rm -rf "$BUILD_DIR" "$DEB_FILE"

echo "[✔] Local packaging complete!"
echo "------------------------------------------"

# 8. Ask if user wants to push to GitHub
read -p "[?] Do you want to push this update to GitHub now? (y/n) [y]: " PUSH_CHOICE
PUSH_CHOICE="${PUSH_CHOICE:-y}"

if [[ "$PUSH_CHOICE" =~ ^[Yy]$ ]]; then
    echo "[+] Staging files for Git..."
    cd "$REPO_DIR"
    git add .
    
    # Try to make a descriptive commit
    git commit -m "Auto-added package: $PKG_NAME (v$PKG_VER)"
    
    echo "[+] Pushing update to GitHub..."
    git push origin main
    echo "[✔] Success! Everything pushed to GitHub."
else
    echo "[+] Changes saved locally. (Not pushed to GitHub)"
fi
echo "=========================================="
