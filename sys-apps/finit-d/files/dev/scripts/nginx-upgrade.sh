#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Sampled from nginx.initd-r4 from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# Upgrade the nginx binary without losing connections.
p="/run/nginx.pid"
kill -SIGUSR2 $(cat ${p})
sleep 3
[[ -f ${p}.oldbin ]] || exit 1
[[ -f ${p} ]] || exit 1
sleep 3
kill -SIGWINCH $(cat ${p}.oldbin)
kill -SIGQUIT $(cat ${p}.oldbin)


