# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is AI generated.

# Prompt:
# what would the meta package for gentoo for gnu coreutils and uutils coreutils
# look like? I need to create two separate installs for gnu-coreutils-alt,
# uutils-coreutils-alt, uutils-coreutils-bin (prebuilt) with modified ebuilds.
# gnu-coreutils-alt will install in /usr/lib/gnu-coreutils/{bin,sbin}.
# uutils-coreutils-alt installs to /usr/lib/uucore-utils/{bin,sbin}.
# uutils-coreutils-bin will install to /usr/lib/uutils-coreutils-bin/{bin,sbin}.
# then i will switch using a muxer to either uutils-coreutils prebuilt or source
# based uutils core utils. i want to use a muxer installed at
# /usr/bin/switch-coreutils controlled from systemrescuecd to control the symlinks
# and the system mounted in /mnt/gentoo. if a package requires gnu-coreutils will
# it be easy to just do a path change? do i need to uninstall the
# sys-apps/coreutils before using the muxer or should a separate script be used to
# save and restore sys-apps/coreutils install? for the muxer script, it needs to
# add the PATH before using ln if sys-apps/coreutils is uninstalled. is the script
# split-usr compatible? should i change the path to /lib/gnu-coreutils,
# /lib/uutils-coreutils instead? i am using split-usr.

# sys-apps/coreutils            - Installed in /bin, /sbin
# sys-apps/gnu-coreutils-alt    - Installed in /lib/gnu-coreutils/{bin,sbin}
# sys-apps/uutils-coreutils-alt - Installed in /lib/uucore-utils/{bin,sbin}
# sys-apps/uutils-coreutils-bin - Installed in /lib/uutils-coreutils-bin/{bin,sbin};  prebuilt from uutils-coreutils repo as an alternative/recovery for GNU Coreutils stage3 tarball prebuilt.
# Using multislot can increase the attack surface.  The multislot can be used for compatibility but uses the rust based as fallback for mitigation.

EAPI=8

DESCRIPTION="Virtual for coreutils implementations"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	|| (
		sys-apps/gnu-coreutils-alt
		sys-apps/uutils-coreutils-alt
		sys-apps/uutils-coreutils-bin
		sys-apps/coreutils
	)
"
