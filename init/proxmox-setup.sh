#!/usr/bin/env bash
# Proxmox Host-Side Hardware Provisioner
# This script MUST be run on the Proxmox Host Shell (root@proxmox)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   Proxmox Atlas - Hardware Provisioner      ${NC}"
echo -e "${BLUE}==============================================${NC}"

# 1. Get Container ID
read -p "Enter your Backup Container ID (e.g., 100): " CTID
if ! pct status "$CTID" >/dev/null 2>&1; then
    echo "Error: Container $CTID not found on this host."
    exit 1
fi

# 2. Get Physical Storage Path
echo -e "\n${YELLOW}Current Mounts on Proxmox:${NC}"
df -h | grep "/mnt/pve" || echo "No PVE mounts found."

echo -e "\nExample: /mnt/pve/your-disk/backups"
read -p "Enter the PHYSICAL path on Proxmox to store backups: " PHYS_PATH

if [ ! -d "$PHYS_PATH" ]; then
    echo "Creating directory $PHYS_PATH..."
    mkdir -p "$PHYS_PATH"
fi

# 3. Apply Mount Point
echo -e "\n${GREEN}Applying Hardware Mapping...${NC}"
# mp0 is standard for the first data mount
pct set "$CTID" -mp0 "$PHYS_PATH,mp=/var/lib/atlas-backup"

# 4. Handle Permissions
# Since LXC containers use shifted UIDs, we need to ensure the container can write to this host folder.
# We set it to 770 or adjust ownership if it's an unprivileged container.
chmod 775 "$PHYS_PATH"
chown -R 100000:100000 "$PHYS_PATH" 2>/dev/null || echo "Note: Could not set UID 100000 (usually fine for unprivileged containers)."

echo -e "\n${BLUE}==============================================${NC}"
echo -e "${GREEN}SUCCESS! Hardware Decoupling Complete.${NC}"
echo -e "Container $CTID is now mapped to $PHYS_PATH"
echo -e "Path inside container: /var/lib/atlas-backup"
echo -e "${BLUE}==============================================${NC}"
echo -e "Now go back to your container and run: ${YELLOW}atlas-backup${NC}"
echo -e "${BLUE}==============================================${NC}"
