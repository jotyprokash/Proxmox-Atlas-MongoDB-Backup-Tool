# Proxmox Atlas Backup Utility

[![Proxmox](https://img.shields.io/badge/Proxmox-E74C3C?style=flat-square&logo=proxmox&logoColor=white)](https://proxmox.com)
[![MongoDB Atlas](https://img.shields.io/badge/MongoDB_Atlas-47A248?style=flat-square&logo=mongodb&logoColor=white)](https://mongodb.com/atlas)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Systemd](https://img.shields.io/badge/Systemd-000000?style=flat-square&logo=linux&logoColor=white)](https://systemd.io)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![GNU Make](https://img.shields.io/badge/GNU_Make-000000?style=flat-square&logo=gnu&logoColor=white)](https://www.gnu.org/software/make/)
[![Engine: local.oplog.rs](https://img.shields.io/badge/Engine-local.oplog.rs-blueviolet?style=flat-square)](https://www.mongodb.com/docs/manual/core/replica-set-oplog/)
[![Security: TLS](https://img.shields.io/badge/Security-TLS-blue?style=flat-square&logo=openssl&logoColor=white)](https://www.openssl.org/)
[![Strategy: Full + Incremental](https://img.shields.io/badge/Strategy-Full_%2B_Incremental-success?style=flat-square)](https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool)
[![DR: Point-in-Time Recovery](https://img.shields.io/badge/DR-Point--in--Time_Recovery-important?style=flat-square)](https://github.com/jotyprokash/Proxmox-Atlas-MongoDB-Backup-Tool)

An enterprise-grade, automated backup solution engineered to synchronize MongoDB Atlas clusters with local Proxmox LXC infrastructure. Implements a high-performance **Forever Incremental (Oplog-based)** strategy for maximum data durability and zero-waste bandwidth.

![Architecture Diagram](./assets/screenshots/architecture_diagram.png?v=2)

## Key Features
- **Hardware Decoupling**: Designed for Proxmox Mount Points to ensure data lives on physical hardware, independent of the LXC lifetime.
- **Hardware-Aware Safety**: Automated detection of mount points with critical alerting if backups are stored on virtual/unsafe storage.
- **Two-Tier Provisioning**: Automated setup scripts for both the LXC container and the Proxmox Host.

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
cd Proxmox-Atlas-MongoDB-Backup-Tool
sudo ./onboard.sh
```

### 2. Hardware Decoupling (Proxmox Host)
To ensure your backups survive if the container is deleted, you must run the provisioner on your **Proxmox Host Shell**:
```bash
# Copy init/proxmox-setup.sh to your Proxmox Host
# Run as root on the host
bash proxmox-setup.sh
```

### 3. Configuration Management
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

### Hardware Health Checks
The tool automatically validates your storage environment before every backup.
- **Green**: `HEALTH_CHECK: Hardware decoupling verified` -> Backups are safe on physical disks.
- **Red**: `CRITICAL_WARNING: Hardware decoupling NOT DETECTED!` -> Backups are at risk on virtual storage. An alert is sent to the configured Webhook.

### Disaster Recovery
Perform a full cluster restoration:
```bash
sudo atlas-restore [TARGET_URI]
```

## Implementation Journey
For detailed technical documentation on architectural decisions and infrastructure hardening, refer to the **[Implementation Journey](./implementation.md)**.
