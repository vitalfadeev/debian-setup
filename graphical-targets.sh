#!/bin/sh
sudo systemctl set-default graphical.target
systemctl --user set-default graphical-session.target
