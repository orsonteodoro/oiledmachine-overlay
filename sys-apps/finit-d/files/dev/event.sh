#!/bin/sh
if [ -n "$FN" = "zap" ] && [ -e "$pidfile" ] ; then
	kill -SIGKILL $(cat "$pidfile")
elif [ -n "$FN" = "declare" ] ; then
	echo "declare() is not supported"
elif [ -n "$command" ] && [ "$FN" = "start" ] && ! declare -f start ; then
	default_start
elif [ -n "$FN" ] ; then
	declare -f "$FN" && "$FN"
fi
