# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for Risuai"
ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/risuai"
ACCT_USER_HOME_PERMS=0700
ACCT_USER_GROUPS=( risuai )

IUSE=""

acct-user_add_deps
