PREFIX ?= /usr/local
CONFDIR ?= /etc/atlas-backup
INITDIR ?= /etc/systemd/system

.PHONY: install uninstall deps onboard

deps:
	apt update && apt install -y curl make git gnupg
	curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
	echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
	apt update && apt install -y mongodb-database-tools mongodb-mongosh

install:
	install -d $(PREFIX)/bin
	install -m 755 bin/atlas-backup $(PREFIX)/bin/atlas-backup
	install -m 755 bin/atlas-restore $(PREFIX)/bin/atlas-restore
	
	install -d $(CONFDIR)
	install -m 600 conf/backup.conf.example $(CONFDIR)/backup.conf.example
	@if [ ! -f $(CONFDIR)/backup.conf ]; then \
		install -m 600 conf/backup.conf.example $(CONFDIR)/backup.conf; \
		if [ -n "$(ATLAS_URI)" ]; then \
			sed -i 's|ATLAS_URI=.*|ATLAS_URI="$(ATLAS_URI)"|' $(CONFDIR)/backup.conf; \
			echo "Configured ATLAS_URI from environment."; \
		fi; \
		echo "Created default config at $(CONFDIR)/backup.conf."; \
	fi
	
	install -d $(INITDIR)
	install -m 644 init/atlas-backup.service $(INITDIR)/atlas-backup.service
	install -m 644 init/atlas-backup.timer $(INITDIR)/atlas-backup.timer
	
	systemctl daemon-reload
	systemctl enable atlas-backup.timer
	systemctl start atlas-backup.timer
	@echo "Installation complete. Timer is active."

onboard: deps install
	@echo "Onboarding complete. Please ensure /etc/atlas-backup/backup.conf is configured."

uninstall:
	systemctl stop atlas-backup.timer || true
	systemctl disable atlas-backup.timer || true
	rm -f $(INITDIR)/atlas-backup.service
	rm -f $(INITDIR)/atlas-backup.timer
	systemctl daemon-reload
	rm -f $(PREFIX)/bin/atlas-backup
	rm -f $(PREFIX)/bin/atlas-restore
	@echo "Uninstallation complete."
