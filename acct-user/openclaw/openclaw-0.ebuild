# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for OpenClaw"
ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/openclaw"
ACCT_USER_HOME_PERMS=0700
ACCT_USER_GROUPS=( openclaw )
ACCT_USER_SHELL="/bin/false"		# No login shell needed

IUSE="ebuild_revision_1"

acct-user_add_deps
