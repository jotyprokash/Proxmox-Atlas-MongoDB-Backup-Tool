# Proxmox Atlas Backup

A robust, production-grade utility to safely and automatically backup a MongoDB Atlas (Free Tier) cluster to a local Linux system (like a Proxmox LXC container).

## Features
- **Idempotent:** Safe to run repeatedly.
- **Automated Retention:** Automatically deletes backups older than `N` days.
- **Notifications:** Built-in support for Discord, Slack, and Healthchecks.io webhooks.
- **Secure:** Stores credentials in restricted permissions configuration file.
- **Automated Scheduling:** Leverages `systemd` timers (more resilient than `cron`).

## Requirements
- `mongodb-database-tools` (provides `mongodump` and `mongorestore`)
- `curl` (for webhooks)
- `make` (for installation)

## Installation

1. Clone the repository and install:
   ```bash
   git clone https://github.com/yourusername/proxmox-atlas-backup.git
   cd proxmox-atlas-backup
   sudo make install
   ```

2. Edit the configuration file with your MongoDB Atlas URI:
   ```bash
   sudo nano /etc/atlas-backup/backup.conf
   ```
   *Make sure your Atlas Network Access allows connections from your Proxmox public IP.*

3. The systemd timer is automatically enabled and started during `make install`. By default, it runs at 2:00 AM daily.

## Usage

You can trigger a backup manually at any time:
```bash
sudo systemctl start atlas-backup.service
```

Or run the script directly to see immediate output:
```bash
sudo atlas-backup
```

To restore a backup:
```bash
sudo atlas-restore /var/lib/atlas-backup/atlas_backup_20260419_020000.archive.gz
```

## Logs
To view the execution logs of the systemd service:
```bash
sudo journalctl -u atlas-backup.service -f
```
