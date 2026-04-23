# Proxmox Atlas Backup Utility

[![Proxmox](https://img.shields.io/badge/Proxmox-E74C3C?style=flat-square&logo=proxmox&logoColor=white)](https://proxmox.com)
[![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-47A248?style=flat-square&logo=mongodb&logoColor=white)](https://mongodb.com/atlas)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Systemd](https://img.shields.io/badge/Systemd-000000?style=flat-square&logo=linux&logoColor=white)](https://systemd.io)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![GNU Make](https://img.shields.io/badge/GNU_Make-000000?style=flat-square&logo=gnu&logoColor=white)](https://www.gnu.org/software/make/)
[![LXC](https://img.shields.io/badge/LXC-gray?style=flat-square&logo=linux&logoColor=white)](https://linuxcontainers.org/)
[![Security: TLS](https://img.shields.io/badge/Security-TLS-blue?style=flat-square&logo=openssl&logoColor=white)](https://www.openssl.org/)
[![Strategy: Full + Incremental](https://img.shields.io/badge/Strategy-Full_%2B_Incremental-success?style=flat-square)](https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool)

An enterprise-grade, automated backup solution engineered to synchronize MongoDB Atlas clusters with local Proxmox LXC infrastructure. Implements a high-performance **Full + Incremental (Oplog-based)** strategy for data durability and minimal network overhead.

![Architecture Diagram](./assets/screenshots/architecture_diagram.png?v=2)

## Key Features
- **Incremental Pipeline**: Optimized Full + Incremental backups to reduce bandwidth and storage I/O.
- **Automated Lifecycle**: 6-hour interval automated execution via `systemd` timers.
- **Advanced Observability**: Integrated logging and webhook support for real-time alerting.
- **Reliable Recovery**: Automated "stitching" of latest full base and subsequent BSON oplog slices.
- **Infrastructure Hardening**: Designed for unprivileged LXC environments with strict permission scoping.

## Prerequisites

Deployment requirements:
1.  **Backup Host**: Proxmox LXC container (Ubuntu/Debian) with standard network egress.
2.  **Atlas Configuration**: 
    *   Backup server Public IP authorized in **Atlas IP Access List**.
    *   Database user provisioned with `readAnyDatabase` and `clusterMonitor` roles.
3.  **Network**: Outbound connectivity enabled on port `27017`.

## Installation & Setup

### 1. Automated Deployment
Clone the repository and execute the interactive onboarding script:
```bash
git clone https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool.git
cd Proxmox-Atlas-MongoDB-Backup-Tool
sudo ./onboard.sh
```

### 2. Configuration Management
System configuration is centralized in `/etc/atlas-backup/backup.conf`:
```bash
sudo nano /etc/atlas-backup/backup.conf
```
| Variable | Description |
| :--- | :--- |
| `ATLAS_URI` | MongoDB Atlas connection string. |
| `BACKUP_DIR` | Local target path for storage of backup archives and slices. |
| `RETENTION_DAYS` | Data retention policy (automated file rotation). |
| `FULL_BACKUP_DAY` | Scheduled day for Full Base backup generation (0-6). |

## Operations & Verification

### Manual Execution
```bash
sudo atlas-backup
```

### Automation Monitoring
```bash
# Verify timer status
systemctl list-timers atlas-backup.timer

# Inspect service logs
journalctl -u atlas-backup.service -f
```

### Disaster Recovery
Perform a full cluster restoration:
```bash
sudo atlas-restore [TARGET_URI]
```

## Implementation Journey
For detailed technical documentation on architectural decisions and infrastructure hardening, refer to the **[Implementation Journey](./implementation.md)**.
