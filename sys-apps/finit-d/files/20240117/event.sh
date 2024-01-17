#!/bin/sh
# A compatibility footer script that runs some openrc-run(8) commands.
if [ "$FN" = "zap" ] && [ -e "$pidfile" ] ; then
	kill -SIGKILL $(cat "$pidfile")
elif [ "$FN" = "declare" ] ; then
	echo "declare() is not supported"
elif [ -n "$command" ] && [ "$FN" = "start" ] && [ "${call_default_start}" = "1" ] ; then
	default_start
elif [ -n "$FN" ] ; then
	"$FN"
	if [ "$FN" = "stop" ] ; then
		clear_kv_store
	fi
fi
