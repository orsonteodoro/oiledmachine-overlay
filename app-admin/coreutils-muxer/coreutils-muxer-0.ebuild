# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for coreutils implementations"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="
ebuild_revision_3
"

src_install() {
	exeinto "/"
	doexe "${FILESDIR}/switch-coreutils"
}

pkg_postinst() {
einfo
einfo "The switch-coreutils muxer has been installed."
einfo "You must use it to set up symlinks to uutils coreutils from either"
einfo "SystemRescue, Gentoo LiveUSB, or a rescue partition containing"
einfo "unpacked Gentoo stage3 tarball or SystemRescue.  See also"
einfo "https://wiki.gentoo.org/wiki/LiveUSB"
einfo "https://www.system-rescue.org/"
einfo
einfo
einfo "To switch, use one of the following with one of the boot disks:"
einfo
einfo "/mnt/gentoo/switch-coreutils gnu /mnt/gentoo"
einfo "/mnt/gentoo/switch-coreutils uutils /mnt/gentoo"
einfo "/mnt/gentoo/switch-coreutils uutils-bin /mnt/gentoo"
einfo
}
