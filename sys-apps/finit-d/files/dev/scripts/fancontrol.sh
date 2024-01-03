#!/bin/sh
. /etc/conf.d/fancontrol
FANCONTROL_CONFIGFILE=${FANCONTROL_CONFIGFILE:-"/etc/fancontrol"}
exec fancontrol ${FANCONTROL_CONFIGFILE}
