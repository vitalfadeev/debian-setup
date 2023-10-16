# About

This is systemd configs for able:
* auto login (user with uid 1000)
* auto start X server
* auto start IceWm
* auto start rox
* auto load X resources


# Install

## Copy

* Copy system configs from `src/etc` in to `/etc'

* Copy user configs from `src/home/1000` in to to home folder

## Reload systemd

```sh
sudo systemctl daemon-reload
systemctl --user daemon-reload
```

# Description

## System

### Auto login

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

### X server

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

/etc/X11/Xwrapper.config:

```ini
allowed_users=anybody
needs_root_rights=yes
```

```bash
systemctl enable xorg.service
```

## User 

### IceWM

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


### ROX desktop

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

### X resources (colors, fonts, sizes)

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


~/.Xresources:

```
! no AA
Xft.antialias: false
Xft.hinting: 1
Xft.hintstyle: hintslight
Xft.rgba: rgb 

! COLORS
x-terminal-emulator*termName: xterm-256color
x-terminal-emulator*color15: rgb:e4/e4/e4
*foreground: rgb:b2/b2/b2
*background: rgb:08/08/08

! UTF-8
x-terminal-emulator*locale: false
x-terminal-emulator*utf8: true

! Alt, Ctrl, Win, BS
x-terminal-emulator*metaSendsEscape: true
x-terminal-emulator*backarrowKey: false
x-terminal-emulator*ttyModes: erase ^?

! SCROLLBAR
x-terminal-emulator*saveLines: 4096
x-terminal-emulator*scrollBar: true
x-terminal-emulator*scrollbar.width: 16
x-terminal-emulator*geometry: 112x32

! FONTS
x-terminal-emulator*faceName: Input Mono Condensed
x-terminal-emulator*faceSize: 16
x-terminal-emulator*renderFont: true

! VT Font Menu: Unreadable
x-terminal-emulator*faceSize1: 8
! VT font menu: Tiny
x-terminal-emulator*faceSize2: 10
! VT font menu: Medium
x-terminal-emulator*faceSize3: 12
! VT font menu: Large
x-terminal-emulator*faceSize4: 16
! VT font menu: Huge
x-terminal-emulator*faceSize5: 22

! SELECTION
x-terminal-emulator*selectToClipboard: true

! HOTKEYS
x-terminal-emulator*translations: #override \n\
  Shift <Key>Home: scroll-forw(10000000000) \n\
  Shift <Key>End: scroll-back(10000000000)

x-terminal-emulator*Translations: #override \n\
    Ctrl <Key>M: maximize() \n\
    Ctrl <Key>R: restore()

x-terminal-emulator*Translations: #override \n\
    Shift <KeyPress> Insert: insert-selection(CLIPBOARD) \n\
    Ctrl Shift <Key>V:       insert-selection(CLIPBOARD) \n\
    Ctrl Shift <Key>C:       copy-selection(CLIPBOARD) \n\
    Ctrl <Btn1Up>: exec-formatted("xdg-open '%t'", PRIMARY)

x-terminal-emulator*Translations: #override \n\
    Ctrl <Key> minus: smaller-vt-font() \n\
    Ctrl <Key> plus:  larger-vt-font() \n\
    Ctrl <Key> 0:     set-vt-font(d)
```

