#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Repository directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGES_DIR="$REPO_DIR/packages"
INDEX_FILE="$REPO_DIR/packages.md"

# Ensure packages directory exists
mkdir -p "$PACKAGES_DIR"

# Print usage instructions
usage() {
    echo "Usage: $0 <path-to-deb-file>"
    exit 1
}

# Check if a file is provided
if [ -z "$1" ]; then
    echo "Error: Koi .deb file specify nahi ki gayi."
    usage
fi

DEB_FILE="$1"

# Check if the file exists
if [ ! -f "$DEB_FILE" ]; then
    echo "Error: File '$DEB_FILE' nahi mili."
    exit 1
fi

# Check if dpkg-deb tool is available
if ! command -v dpkg-deb &> /dev/null; then
    echo "Error: 'dpkg-deb' command nahi mila. Kripya isse install karein (e.g., pkg install dpkg)."
    exit 1
fi

echo "Processing package: $DEB_FILE..."

# Extract package metadata using dpkg-deb
PKG_NAME=$(dpkg-deb -f "$DEB_FILE" Package)
PKG_VER=$(dpkg-deb -f "$DEB_FILE" Version)
PKG_ARCH=$(dpkg-deb -f "$DEB_FILE" Architecture)
PKG_DESC=$(dpkg-deb -f "$DEB_FILE" Description | head -n 1) # Get first line of description

# Validate if we successfully read the package name
if [ -z "$PKG_NAME" ]; then
    echo "Error: File se package metadata extract nahi ho paya. Kya yeh ek valid .deb file hai?"
    exit 1
fi

# Define destination path
FILENAME=$(basename "$DEB_FILE")
DEST_FILE="$PACKAGES_DIR/$FILENAME"

# Copy the .deb file to packages directory
echo "Copying to repository..."
cp "$DEB_FILE" "$DEST_FILE"

# Initialize index file if it doesn't exist
if [ ! -f "$INDEX_FILE" ]; then
    cat << 'EOF' > "$INDEX_FILE"
# Packages List

Is repository mein added sabhi packages ki list niche di gayi hai:

| Package Name | Version | Architecture | Description | Filename |
|--------------|---------|--------------|-------------|----------|
EOF
fi

# Remove existing entry for the same package + version to prevent duplicates
# We use a temporary file for this
TEMP_FILE=$(mktemp)
grep -v "| $PKG_NAME | $PKG_VER |" "$INDEX_FILE" > "$TEMP_FILE" || true
mv "$TEMP_FILE" "$INDEX_FILE"

# Append new entry
echo "| $PKG_NAME | $PKG_VER | $PKG_ARCH | $PKG_DESC | [$FILENAME](packages/$FILENAME) |" >> "$INDEX_FILE"

# Rebuild APT repo index files
python3 "$SCRIPT_DIR/reindex.py"

echo "--------------------------------------------------"
echo "Success! Package successfully added to repository."
echo "Package:      $PKG_NAME"
echo "Version:      $PKG_VER"
echo "Architecture: $PKG_ARCH"
echo "Saved to:     packages/$FILENAME"
echo "Updated:      packages.md"
echo "--------------------------------------------------"
