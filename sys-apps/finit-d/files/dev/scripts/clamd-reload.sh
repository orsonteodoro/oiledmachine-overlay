#!/bin/sh
. /etc/finit.d/lib.sh
SVCNAME="clamd"
RC_SVCNAME="${SVCNAME}"

reload() {
  ebegin "Reloading ${RC_SVCNAME}"
  "/usr/bin/clamdscan" --reload
  eend $?
}

reload
