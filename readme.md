# System

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

# User 

## IceWM

~/.config/systemd/user/icewm.service:

```ini
[Unit]
Description=IceWm
After=xorg.service autologin.service

[Service]
ExecStart=/usr/bin/icewm-session  --nobg --notray
Slice=session.slice
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

## X resources (colors, fonts, sizes)

~/.config/systemd/user/xrdb.service:

```ini
[Unit]
Description=X resource setting
Documentation=man:xrdb(1)
After=xorg.service autologin.service

[Service]
Type=oneshot
ExecStart=/usr/bin/xrdb -merge %h/.Xresources

[Install]
WantedBy=default.target
```



## ROX desktop

~/.config/systemd/user/rox.service:

```ini
[Unit]
Description=ROX desktop
After=xorg.service autologin.service

[Service]
Type=forking
ExecStart=/usr/bin/rox -p Desktop
Slice=session.slice
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
```
