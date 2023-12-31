#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Sampled from nginx.initd-r4 from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# Run nginx' internal config check.

source /etc/finit.d/scripts/nginx-lib.sh

configtest
