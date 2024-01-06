#!/bin/sh
if [ -n "$FN" = "zap" ] ; then
	kill -SIGKILL $(cat "$pidfile")
elif [ -n "$FN" = "declare" ] ; then
	echo "declare() is not supported"
elif [ -n "$FN" ] ; then
	declare -f "$FN" && "$FN"
fi
