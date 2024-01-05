#!/bin/sh
. /etc/finit.d/lib.sh
pidfile="/run/clamd.pid"

start_pre() {
  # This exists to support the (disabled) default LocalSocket setting
  # within clamd.conf. The "clamav" user and group agree with the
  # (disabled) default "User" and "LocalSocketGroup" settings in
  # clamd.conf. And everything here agrees with the
  # clamav-daemon.socket systemd service.
  #
  # Creating this directory is harmless even when a local socket is
  # not used.
  checkpath "d" "clamav:clamav" "0755" "/run/clamav"
}

start_pre
