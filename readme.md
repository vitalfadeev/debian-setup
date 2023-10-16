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

```bash
systemctl enable autologin.service
```


Main line is:

```ini
ExecStart=/usr/bin/systemctl start user@1000.service
```

(1000 can be replaced with a custom uid)

_uid_ can be seen by command:
```bash
id
```

## X server

Auto start X at computer startup

/etc/systemd/system/xorg.service:

```ini
[Unit]
Description=Xorg server
After=plymouth-quit.service basic.target
PartOf=graphical-session.target

[Service]
Environment=XDG_SESSION_TYPE=x11
UnsetEnvironment=TERM
StandardOutput=journal
ExecStart=/usr/lib/xorg/Xorg.wrap -ac -s 0 -nolisten tcp :0 vt8
Restart=always
RestartSec=10

[Install]
WantedBy=graphical.target
Alias=display-manager.service
```

```bash
systemctl enable xorg.service
```
