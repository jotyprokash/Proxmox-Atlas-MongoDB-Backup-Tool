# Proxmox Atlas Backup Utility

[![Implementation Journey](https://img.shields.io/badge/Detailed-Implementation_Journey-blueviolet?style=for-the-badge&logo=gitbook)](./implementation.md)
![Linux](https://img.shields.io/badge/Platform-Linux-lightgrey?style=for-the-badge&logo=linux)
![MongoDB](https://img.shields.io/badge/Database-MongoDB_Atlas-green?style=for-the-badge&logo=mongodb)

A production-grade, automated backup solution designed to safely pull MongoDB Atlas clusters to local Proxmox LXC infrastructure. Engineered for reliability, observability, and minimal overhead.

##  Key Features
- **Automated Lifecycle**: Daily backups via `systemd` timers with built-in retention management.
- **Observability**: Integrated logging and webhook support (Discord/Slack/Healthchecks).
- **Hardened Security**: Principle of least privilege applied to unprivileged LXC and restricted config permissions.
- **Idempotent Deployment**: Simple `make` based installation and uninstallation logic.



##  Quick Start

### 1. Installation
Deploy directly to your Proxmox LXC (Ubuntu/Debian):
```bash
git clone https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool.git
cd Proxmox-Atlas-MongoDB-Backup-Tool
sudo make install
```

### 2. Configuration
Define your Atlas credentials in the restricted configuration file:
```bash
sudo nano /etc/atlas-backup/backup.conf
```

### 3. Verification
Trigger a manual backup and check logs:
```bash
sudo atlas-backup
sudo journalctl -u atlas-backup.service -f
```



##  Deep Dive
For a comprehensive, step-by-step walkthrough of the architectural decisions, Proxmox setup, and verification evidence, please refer to the:

 **[Implementation Journey](./implementation.md)**



##  Operations
- **Manual Trigger**: `sudo systemctl start atlas-backup.service`
- **Timer Status**: `systemctl list-timers --all | grep atlas`
- **Restore**: `sudo atlas-restore /path/to/backup.archive.gz`

