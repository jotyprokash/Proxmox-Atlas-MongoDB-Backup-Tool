# Proxmox Atlas Backup Utility

[![Proxmox](https://img.shields.io/badge/Proxmox-E74C3C?style=flat-square&logo=proxmox&logoColor=white)](https://proxmox.com)
[![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-47A248?style=flat-square&logo=mongodb&logoColor=white)](https://mongodb.com/atlas)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Systemd](https://img.shields.io/badge/Systemd-000000?style=flat-square&logo=linux&logoColor=white)](https://systemd.io)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Discord](https://img.shields.io/badge/Discord-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.com)
[![Implementation Journey](https://img.shields.io/badge/Docs-Implementation_Journey-blueviolet?style=flat-square&logo=gitbook)](./implementation.md)

A production-grade, automated backup solution designed to safely pull MongoDB Atlas clusters to local Proxmox LXC infrastructure. Engineered for reliability, observability, and minimal overhead.


![Architecture Diagram](./assets/screenshots/architecture_diagram.png)

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

