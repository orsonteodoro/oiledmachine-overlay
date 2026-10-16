# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is AI generated and partly edited by ebuild maintainer.

inherit acct-user

DESCRIPTION="User for Wazuh"
ACCT_USER_ID=-1          # pick a free ID
ACCT_USER_GROUPS=( wazuh )
acct-user_add_deps
