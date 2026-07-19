#!/data/data/com.termux/files/usr/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BG_GREEN='\033[42m'
TEXT_BLACK='\033[30m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="Termuxrepo"
GITHUB_USER="bauaasoni37-cpu"

# Paths
LOCAL_REPO_DIR="/data/data/com.termux/files/home/$REPO_NAME"
APT_SOURCES_DIR="/data/data/com.termux/files/usr/etc/apt/sources.list.d"
SOURCE_FILE="$APT_SOURCES_DIR/$REPO_NAME.list"

# Styling Helpers
print_header() {
    clear
    echo -e "${PURPLE}${BOLD}==================================================${NC}"
    echo -e "${CYAN}${BOLD}       🚀 Termux Custom APT Repository Setup       ${NC}"
    echo -e "${PURPLE}${BOLD}==================================================${NC}"
    echo ""
}

print_status() {
    echo -e "${CYAN}[*]${NC} $1"
}

print_success_step() {
    echo -e "${GREEN}[✔]${NC} $1"
}

print_error() {
    echo -e "${RED}[✘] Error:${NC} $1"
}

# Start installer
print_header

# Step 1: Detect repository type
print_status "Detecting repository source environment..."
sleep 0.5

if [ -d "$LOCAL_REPO_DIR" ]; then
    echo -e "    ${YELLOW}➔ Local repository found at:${NC} $LOCAL_REPO_DIR"
    echo -e "    ${YELLOW}➔ Configuring file-based repository setup...${NC}"
    mkdir -p "$APT_SOURCES_DIR"
    echo "deb [trusted=yes] file://$LOCAL_REPO_DIR ./" > "$SOURCE_FILE"
    print_success_step "Configured local APT source entry."
else
    echo -e "    ${YELLOW}➔ Local directory not found. Using GitHub hosting...${NC}"
    
    # Custom username via parameter check
    if [ -n "$1" ]; then
        GITHUB_USER="$1"
    fi
    
    ONLINE_URL="https://$GITHUB_USER.github.io/$REPO_NAME"
    echo -e "    ${CYAN}➔ GitHub Pages URL:${NC} $ONLINE_URL"
    mkdir -p "$APT_SOURCES_DIR"
    echo "deb [trusted=yes] $ONLINE_URL ./" > "$SOURCE_FILE"
    print_success_step "Configured remote APT source entry."
fi

# Step 2: Database Sync
echo ""
print_status "Syncing repository database with 'pkg update'..."
echo -e "${BLUE}--------------------------------------------------${NC}"

# Run update but mask some noisy outputs if needed, keeping error status
pkg update

echo -e "${BLUE}--------------------------------------------------${NC}"
print_success_step "APT Package database synced successfully."

# Step 3: Success Banner
echo ""
echo -e "${GREEN}${BOLD}==================================================${NC}"
echo -e "${BG_GREEN}${TEXT_BLACK}${BOLD}   ✔  SUCCESS: APT REPOSITORY SUCCESSFULLY ADDED   ${NC}"
echo -e "${GREEN}${BOLD}==================================================${NC}"
echo ""
echo -e "${BOLD}Aap is repository ke packages ko direct install kar sakte hain:${NC}"
echo -e "    ➔ ${YELLOW}pkg install agy -y${NC}      (Install CLI permission tool)"
echo -e "    ➔ ${YELLOW}pkg install build -y${NC}    (Install build environment)"
echo ""
echo -e "${CYAN}${BOLD}Happy Auditing & Coding! 💻🔥${NC}"
echo -e "${GREEN}${BOLD}==================================================${NC}"
