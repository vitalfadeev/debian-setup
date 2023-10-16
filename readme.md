
```cat /etc/systemd/system/autologin.service```

```ini
[Unit]
Description=Auto-login for user 1000
After=systemd-user-sessions.service

[Service]
ExecStart=/usr/bin/systemctl start user@1000.service
Restart=always
RestartSec=10

[Install]
WantedBy=graphical.target
```
