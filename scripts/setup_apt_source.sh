#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define paths
REPO_DIR="/data/data/com.termux/files/home/my_custom_repo"
APT_SOURCES_DIR="/data/data/com.termux/files/usr/etc/apt/sources.list.d"
SOURCE_FILE="$APT_SOURCES_DIR/my_custom_repo.list"

echo "Configuring local APT repository..."

# Ensure target directory exists
mkdir -p "$APT_SOURCES_DIR"

# Write the source list entry
echo "deb [trusted=yes] file://$REPO_DIR ./" > "$SOURCE_FILE"

echo "Repository source file created at: $SOURCE_FILE"
echo "Content: $(cat "$SOURCE_FILE")"
echo "--------------------------------------------------"
echo "Running 'pkg update' to register the new repository..."
pkg update

echo "--------------------------------------------------"
echo "Success! Aapka local APT repository register ho chuka hai."
echo "Ab aap directly 'pkg install build -y' run kar sakte hain!"
echo "--------------------------------------------------"
