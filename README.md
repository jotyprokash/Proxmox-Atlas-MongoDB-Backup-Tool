# Proxmox Atlas Backup Utility

[![Proxmox](https://img.shields.io/badge/Proxmox-E74C3C?style=flat-square&logo=proxmox&logoColor=white)](https://proxmox.com)
[![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-47A248?style=flat-square&logo=mongodb&logoColor=white)](https://mongodb.com/atlas)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Systemd](https://img.shields.io/badge/Systemd-000000?style=flat-square&logo=linux&logoColor=white)](https://systemd.io)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Implementation Journey](https://img.shields.io/badge/Docs-Implementation_Journey-blueviolet?style=flat-square&logo=gitbook)](./implementation.md)

A production-grade, automated backup solution designed to safely pull MongoDB Atlas clusters to local Proxmox LXC infrastructure. Engineered for reliability, observability, and minimal overhead using a **Full + Incremental (Oplog-based)** strategy.

![Architecture Diagram](./assets/screenshots/architecture_diagram.png?v=2)

## 🚀 Key Features
- **Incremental Pipeline**: Smart Full + Incremental backups to minimize bandwidth and storage.
- **Automated Lifecycle**: 6-hour interval backups managed via `systemd` timers.
- **Observability**: Integrated logging and Discord/Slack webhook notifications.
- **Smart Restore**: Automatic "stitching" of the latest full base and all subsequent incremental slices.
- **Production Hardened**: Designed to run in unprivileged LXC containers with restricted permissions.

## 🛠 Prerequisites

Before installation, ensure you have:
1.  **Backup Host**: A Proxmox LXC container (Ubuntu/Debian recommended) with internet access.
2.  **Atlas Access**: 
    *   The backup server's Public IP must be added to the **Atlas IP Access List**.
    *   A MongoDB User with `readAnyDatabase` and `clusterMonitor` roles (the latter is required to read the `local.oplog.rs` collection).
3.  **Port**: Outgoing traffic allowed on port `27017`.

## 📦 Quick Start

### 1. Automated Installation
Deploy directly to your container using the interactive onboarding script:
```bash
git clone https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool.git
cd Proxmox-Atlas-MongoDB-Backup-Tool
sudo ./onboard.sh
```

### 2. Manual Configuration
The installer creates a secure configuration file at `/etc/atlas-backup/backup.conf`. You can fine-tune your strategy there:
```bash
sudo nano /etc/atlas-backup/backup.conf
```
| Variable | Description |
| :--- | :--- |
| `ATLAS_URI` | Your MongoDB Atlas connection string. |
| `BACKUP_DIR` | Local path to store the `.archive.gz` and `.oplog.bson.gz` files. |
| `RETENTION_DAYS` | Number of days to keep backup files before rotation. |
| `FULL_BACKUP_DAY` | Day of the week (0-6) to trigger a new Full Base backup. |

## 🔍 Verification & Operations

### Trigger Manual Backup
```bash
sudo atlas-backup
```

### Monitor Automation
```bash
# Check scheduled timer status
systemctl list-timers atlas-backup.timer

# View real-time logs
journalctl -u atlas-backup.service -f
```

### Disaster Recovery
To restore your database (Full Base + all Incremental Slices):
```bash
sudo atlas-restore [TARGET_URI]
```

## 📖 Implementation Journey
For a comprehensive walkthrough of the architectural decisions, Proxmox LXC hardening, and the incremental logic development, see the **[Implementation Journey](./implementation.md)**.
