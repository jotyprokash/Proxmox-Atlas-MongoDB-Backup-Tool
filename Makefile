PREFIX ?= /usr/local
CONFDIR ?= /etc/atlas-backup
INITDIR ?= /etc/systemd/system

.PHONY: install uninstall

install:
	install -d $(PREFIX)/bin
	install -m 755 bin/atlas-backup $(PREFIX)/bin/atlas-backup
	install -m 755 bin/atlas-restore $(PREFIX)/bin/atlas-restore
	
	install -d $(CONFDIR)
	install -m 600 conf/backup.conf.example $(CONFDIR)/backup.conf.example
	@if [ ! -f $(CONFDIR)/backup.conf ]; then \
		install -m 600 conf/backup.conf.example $(CONFDIR)/backup.conf; \
		echo "Created default config at $(CONFDIR)/backup.conf. Please edit it."; \
	fi
	
	install -d $(INITDIR)
	install -m 644 init/atlas-backup.service $(INITDIR)/atlas-backup.service
	install -m 644 init/atlas-backup.timer $(INITDIR)/atlas-backup.timer
	
	systemctl daemon-reload
	systemctl enable atlas-backup.timer
	systemctl start atlas-backup.timer
	@echo "Installation complete. Timer is active."

uninstall:
	systemctl stop atlas-backup.timer || true
	systemctl disable atlas-backup.timer || true
	rm -f $(INITDIR)/atlas-backup.service
	rm -f $(INITDIR)/atlas-backup.timer
	systemctl daemon-reload
	rm -f $(PREFIX)/bin/atlas-backup
	rm -f $(PREFIX)/bin/atlas-restore
	@echo "Uninstallation complete. Configuration files in $(CONFDIR) were left intact."
