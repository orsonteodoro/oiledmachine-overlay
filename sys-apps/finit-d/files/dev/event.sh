#!/bin/sh
if [ "$FN" = "zap" ] && [ -e "$pidfile" ] ; then
	kill -SIGKILL $(cat "$pidfile")
elif [ "$FN" = "declare" ] ; then
	echo "declare() is not supported"
elif [ -n "$command" ] && [ "$FN" = "start" ] && [ "${missing_start_fn}" = "1" ] ; then
	default_start
elif [ -n "$FN" ] ; then
	"$FN"
fi
