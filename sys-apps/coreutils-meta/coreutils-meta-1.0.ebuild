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
# /usr/bin/switch-coreutils controlled from systemrescuecd to control the
# symlinks and the system mounted in /mnt/gentoo.

# sys-apps/uutils-coreutils-bin is prebuilt from uutils-coreutils repo.

DESCRIPTION="Meta-package for switching between GNU and uutils coreutils"
HOMEPAGE="https://gentoo.org"

LICENSE="metapackage"
SLOT="0"
#KEYWORDS="~amd64 ~arm64" # Untested

IUSE="+gnu uutils uutils-bin"
REQUIRED_USE="|| ( gnu uutils uutils-bin )"

RDEPEND="
	sys-apps/coreutils-muxer
	gnu? ( sys-apps/gnu-coreutils-alt )
	uutils? ( sys-apps/uutils-coreutils-alt )
	uutils-bin? ( sys-apps/uutils-coreutils-bin )
"

S="${WORKDIR}"

pkg_setup() {
ewarn "This script is a draft and untested.  Use at your own risk."
	sleep 1
}

pkg_postinst() {
	if [[ -z "${ROOT}" ]]; then
		ebegin "Initializing coreutils symlinks if unset"
		/usr/bin/switch-coreutils --init
		eend $?
	fi
}
