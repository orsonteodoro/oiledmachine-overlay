#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files
# Run nginx' internal config check.

. /etc/finit.d/scripts/nginx-lib.sh

configtest
