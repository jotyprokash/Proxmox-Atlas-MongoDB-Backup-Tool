#!/usr/bin/env bash
set -e

# Colors for better UX
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   Proxmox Atlas Backup - Developer Onboarding ${NC}"
echo -e "${BLUE}==============================================${NC}"

# 1. Check for Sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo."
  exit 1
fi

# 2. Install System Dependencies
echo -e "\n${GREEN}[1/3] Checking system dependencies...${NC}"
make deps

# 3. Interactive Configuration
echo -e "\n${GREEN}[2/3] Configuring Atlas Connection...${NC}"
read -p "Enter your MongoDB Atlas URI: " USER_URI

if [ -z "$USER_URI" ]; then
    echo "No URI provided. We will use the default example.conf."
    make install
else
    # Install with the provided URI
    ATLAS_URI="$USER_URI" make install
fi

# 4. Finalize
echo -e "\n${GREEN}[3/3] Finalizing Installation...${NC}"
echo -e "${BLUE}Success! The backup service is now active.${NC}"
echo -e "Logs: journalctl -u atlas-backup.service -f"
echo -e "Config: /etc/atlas-backup/backup.conf"
echo -e "${BLUE}==============================================${NC}"
