# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for nghttpx"
ACCT_USER_ID=-1
ACCT_USER_NAME="nghttpx"
ACCT_USER_GROUPS=( "nghttpx" )
ACCT_USER_HOME="/var/empty"
ACCT_USER_SHELL="/sbin/nologin"
ACCT_USER_DESKTOP_COMMENT="Unprivileged user for nghttpx neverbleed engine"

IUSE="ebuild_revision_1"

acct-user_add_deps
