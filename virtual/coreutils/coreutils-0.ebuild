# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This file is mostly AI generated.

#
# Prompt:
#
_PROMPT="
what would the meta package for gentoo for gnu coreutils and uutils coreutils
look like? I need to create two separate installs for gnu-coreutils,
uutils-coreutils, uutils-coreutils-bin (prebuilt) with modified ebuilds.
gnu-coreutils-alt will install in
/usr/lib/gnu-coreutils/{bin,usr/bin,usr/libexec,etc,usr/share}.
uutils-coreutils-alt installs to
/usr/lib/uucore-utils/{bin,usr/bin,usr/libexec,etc,usr/share}.
uutils-coreutils-bin will install to
/usr/lib/uutils-coreutils-bin/{bin,usr/bin,usr/libexec,etc,usr/share}. then i
will switch using a muxer to either uutils-coreutils prebuilt or source based
uutils core utils. i want to use a muxer installed at /switch-coreutils in the
gentoo root partition controlled from systemrescuecd to control the symlinks
and the system mounted in /mnt/gentoo. if a package requires gnu-coreutils will
it be easy to just do a path change? do i need to uninstall the
sys-apps/coreutils before using the muxer or should a separate script be used to
save and restore sys-apps/coreutils install? for the muxer script, it will
assume the ln command will be used from liveusb or systemrescuecd. should i
change the path to /lib/gnu coreutils, /lib/uutils-coreutils instead? i am
using split-usr but the script and configs need to also accomodate merge-usr
cases. the current uutils-coreutils-alt ebuild assumes only merged-usr and
uu- prefix. The current gnu-coreutils handles both merged-usr, split-usr. the
muxer needs to correct the issue for uutils-coreutils-alt. should i modify the
uutils-coreutils-alt, uutils-coreutils-bin, gnu-coreutils ebuild to assume
merged-usr and the muxer is responsible for split-usr conversion? The coreutils
package will save a copy of /bin and /usr/bin to /lib/coreutils-backup. the
uutils-coreutils-alt, gnu-coreutils, uutils-coreutils-bin will assume split-usr
but the muxer will convert the split-usr staging copies to merged-usr if
necessary.
"
unset _PROMPT

#
# sys-apps/coreutils            - Installed in /bin, /usr/bin, /etc, /usr/share
# sys-apps/gnu-coreutils        - Installed in /lib/gnu-coreutils/{bin,usr/bin,usr/libexec,etc,usr/share} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
# sys-apps/uutils-coreutils-alt - Installed in /lib/uucore-utils/{bin,usr/bin,usr/libexec,etc,usr/share} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
# sys-apps/uutils-coreutils-bin - Installed in /lib/uutils-coreutils-bin/{bin,sbin} then symlinked to /bin, /usr/bin, /etc, /usr/share via a muxer.
#
# sys-apps/gnu-coreutils, sys-apps/uutils-coreutils-alt,
# sys-apps/uutils-coreutils-bin assume split-usr in prefixed directories.
#
# The coreutils-muxer will handle the split-usr to merge-usr conversion.
#
# The uutils-coreutils-bin uses prebuilts from uutils-coreutils repo as an
# alternative or recovery for GNU coreutils stage3 tarball prebuilt.
#
# Using multislot can increase the attack surface.  The multislot can be
# used for compatibility but uses the rust based as fallback for mitigation.
# The decoupling allows for mitigation against hardcoded paths.  The hard
# coded paths get redirected to compatibility-critical or security-critical
# coreutils depending on what the user selects with the muxer.  The
# user can decide to switch to compatibility for @world update then switch
# to hardened, or use stupid PATH tricks to switch to compatibility but use
# predominantly the security-critical coreutils.
#
# For packages that require gnu coreutils, you can use
# PATH="/lib/gnu-coreutils/bin:/lib/gnu-coreutils/usr/bin:${PATH}"
#
# To switch, use one of the following from one of the boot disks:
#
# /mnt/gentoo/switch-coreutils gnu /mnt/gentoo
# /mnt/gentoo/switch-coreutils uutils /mnt/gentoo
# /mnt/gentoo/switch-coreutils uutils-bin /mnt/gentoo
#

CHKL_TIMESTAMPS=(
	"sys-apps/coreutils-9999"
	"sys-apps/gnu-coreutils-9999"
	"sys-apps/uutils-coreutils-alt-9999"
	"sys-apps/uutils-coreutils-bin-9999"
)

inherit chkl secure-version

S="${WORKDIR}"

DESCRIPTION="Virtual for coreutils implementations"
SLOT="0"
IUSE+="
+backup gnu hostname kill +legacy uutils uutils-bin
ebuild_revision_1
" # Bump the ebuild revision when live timestamp check (chkl, secure-timestamp) is bumped.
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
		>=sys-apps/gnu-coreutils-${COREUTILS_PV}[hostname?,kill?]
	)
	legacy? (
		>=sys-apps/coreutils-${COREUTILS_PV}[backup?,hostname?,kill?]
	)
	uutils? (
		>=sys-apps/uutils-coreutils-alt-${UUTILS_COREUTILS_PV}[hostname?,kill?]
	)
	uutils-bin? (
		>=sys-apps/uutils-coreutils-bin-${UUTILS_COREUTILS_PV}[hostname?,kill?]
	)
"

src_configure() {
	chkl_check_many_timestamps
}
