#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Configuration
REPO_NAME="Termuxrepo"
# Try to auto-detect github username if this is a git repository
GITHUB_USER="bauaasoni37-cpu" # Default backup username based on environment

# Paths
LOCAL_REPO_DIR="/data/data/com.termux/files/home/$REPO_NAME"
APT_SOURCES_DIR="/data/data/com.termux/files/usr/etc/apt/sources.list.d"
SOURCE_FILE="$APT_SOURCES_DIR/$REPO_NAME.list"

echo "=========================================="
echo "      Custom APT Repository Setup         "
echo "=========================================="

# Check if script is run locally inside the repository or remotely
if [ -d "$LOCAL_REPO_DIR" ]; then
    echo "[+] Local repository found at $LOCAL_REPO_DIR."
    echo "[+] Configuring local file-based repository..."
    mkdir -p "$APT_SOURCES_DIR"
    echo "deb [trusted=yes] file://$LOCAL_REPO_DIR ./" > "$SOURCE_FILE"
else
    echo "[-] Local repository directory not found."
    echo "[+] Configuring hosted repository from GitHub Pages..."
    
    # Allow passing custom github username as argument, e.g. curl ... | bash -s -- username
    if [ -n "$1" ]; then
        GITHUB_USER="$1"
    fi
    
    ONLINE_URL="https://$GITHUB_USER.github.io/$REPO_NAME"
    echo "[+] Using URL: $ONLINE_URL"
    mkdir -p "$APT_SOURCES_DIR"
    echo "deb [trusted=yes] $ONLINE_URL ./" > "$SOURCE_FILE"
fi

echo "[+] Repository list file created: $SOURCE_FILE"
echo "[+] Repository Source Line: $(cat "$SOURCE_FILE")"
echo "------------------------------------------"
echo "[+] Running 'pkg update' to refresh sources..."
pkg update

echo "------------------------------------------"
echo "[✔] Success! Repository successfully added!"
echo "[+] You can now install packages using:"
echo "    pkg install <package-name> -y"
echo "=========================================="
