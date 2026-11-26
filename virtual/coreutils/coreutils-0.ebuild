# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is mostly AI generated.

#
# Prompt:
#
# what would the meta package for gentoo for gnu coreutils and uutils coreutils
# look like? I need to create two separate installs for gnu-coreutils,
# uutils-coreutils, uutils-coreutils-bin (prebuilt) with modified ebuilds.
# gnu-coreutils-alt will install in
# /usr/lib/gnu-coreutils/{bin,usr/bin,usr/libexec,etc,usr/share}.
# uutils-coreutils-alt installs to
# /usr/lib/uucore-utils/{bin,usr/bin,usr/libexec,etc,usr/share}.
# uutils-coreutils-bin will install to
# /usr/lib/uutils-coreutils-bin/{bin,usr/bin,usr/libexec,etc,usr/share}. then i
# will switch using a muxer to either uutils-coreutils prebuilt or source based
# uutils core utils. i want to use a muxer installed at /switch-coreutils in
# the gentoo root partition controlled from systemrescuecd to control the
# symlinks and the system mounted in /mnt/gentoo. if a package requires
# gnu-coreutils will it be easy to just do a path change? do i need to uninstall
# the sys-apps/coreutils before using the muxer or should a separate script be
# used to save and restore sys-apps/coreutils install? for the muxer script, it
# will assume the ln command will be used from liveusb or systemrescuecd. should
# i change the path to /lib/gnu-coreutils, /lib/uutils-coreutils instead? i am
# using split-usr but the script and configs need to also accomodate merge-usr
# cases.
#

# sys-apps/coreutils            - Installed in /bin, /usr/bin, /etc, /usr/share
# sys-apps/gnu-coreutils    - Installed in /lib/gnu-coreutils/{bin,usr/bin,usr/libexec,etc,usr/share} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
# sys-apps/uutils-coreutils - Installed in /lib/uucore-utils/{bin,usr/bin,usr/libexec,etc,usr/share} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
# sys-apps/uutils-coreutils-bin - Installed in /lib/uutils-coreutils-bin/{bin,sbin} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
#
# The uutils-coreutils-bin uses prebuilts from uutils-coreutils repo as an
# alternative or recovery for GNU coreutils stage3 tarball prebuilt.
#
# Using multislot can increase the attack surface.  The multislot can be
# used for compatibility but uses the rust based as fallback for mitigation.
#

DESCRIPTION="Virtual for coreutils implementations"
SLOT="0"
IUSE+=" gnu +legacy uutils uutils-bin"
REQUIRED_USE="
	legacy? (
		!gnu
		!uutils
		!uutils-bin
	)
	|| (
		gnu
		legacy
		uutils
		uutils-bin
	)
"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	app-admin/coreutils-muxer
	gnu? (
		sys-apps/gnu-coreutils
	)
	legacy? (
		sys-apps/coreutils
	)
	uutils? (
		sys-apps/uutils-coreutils
	)
	uutils-bin? (
		sys-apps/uutils-coreutils-bin
	)
"
