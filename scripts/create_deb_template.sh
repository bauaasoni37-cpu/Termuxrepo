#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "    Termux .deb Package Template Creator  "
echo "=========================================="

# Prompt for Package details
read -p "Package Name (lowercase, no spaces, e.g., mytool): " PKG_NAME
read -p "Version (e.g., 1.0.0): " PKG_VER
read -p "Description: " PKG_DESC
read -p "Maintainer Name <email>: " PKG_MAINT

# Validate inputs
if [ -z "$PKG_NAME" ] || [ -z "$PKG_VER" ]; then
    echo "Error: Package Name aur Version zaroori hain!"
    exit 1
fi

# Directory name for build template
BUILD_DIR="${PKG_NAME}_${PKG_VER}_all"

echo "[+] Creating directory structure for $BUILD_DIR..."
# Create DEBIAN and Termux binary path
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/data/data/com.termux/files/usr/bin"

# Create control file
echo "[+] Writing DEBIAN/control file..."
cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: $PKG_NAME
Version: $PKG_VER
Architecture: all
Maintainer: ${PKG_MAINT:-Termux User <user@termux.org>}
Description: ${PKG_DESC:-My custom tool for Termux}
EOF

# Create a sample shell script binary
echo "[+] Creating sample script at $BUILD_DIR/data/data/com.termux/files/usr/bin/$PKG_NAME..."
cat << EOF > "$BUILD_DIR/data/data/com.termux/files/usr/bin/$PKG_NAME"
#!/data/data/com.termux/files/usr/bin/bash
echo "Hello from $PKG_NAME!"
echo "Aapka custom script successfully install aur run ho chuka hai."
EOF

# Make the sample script executable
chmod +x "$BUILD_DIR/data/data/com.termux/files/usr/bin/$PKG_NAME"

echo "------------------------------------------"
echo "[✔] Template Successfully Created!"
echo "------------------------------------------"
echo "Aapka workspace directory tayyar hai: $BUILD_DIR"
echo ""
echo "Ab aage kya karein:"
echo "1. Apni actual binary/script ko is location par copy karein:"
echo "   $BUILD_DIR/data/data/com.termux/files/usr/bin/$PKG_NAME"
echo ""
echo "2. .deb package file build karne ke liye ye command chalayein:"
echo "   dpkg-deb --build $BUILD_DIR"
echo ""
echo "3. Bani hui .deb file ko repository me add karein:"
echo "   ./scripts/add_package.sh ${BUILD_DIR}.deb"
echo "=========================================="
