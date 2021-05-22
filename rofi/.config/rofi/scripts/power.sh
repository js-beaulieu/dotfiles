#!/usr/bin/env bash

case "$@" in
    "Lock")
        slock
	;;
    "Log off")
        systemctl --user exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff -i
        ;;
    *)
        ;;
esac

echo -e "Lock\nLog off\nReboot\nShutdown"

