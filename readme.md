## Auto login

Auto login for user with uid 1000 
(in Debian 12 first created user has uid 1000)

/etc/systemd/system/autologin.service:

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

Main line is:

```ini
ExecStart=/usr/bin/systemctl start user@1000.service
```

(can to replace 1000 to custom uid)

_uid_ can be seen by command:
```bash
id
```

