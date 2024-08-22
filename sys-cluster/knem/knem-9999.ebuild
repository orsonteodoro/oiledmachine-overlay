# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MODULE_NAMES="knem(misc:${S}/driver/linux)"
BUILD_PARAMS="KDIR=${KERNEL_DIR}"
BUILD_TARGETS="all"

inherit autotools linux-mod linux-info toolchain-funcs udev

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.inria.fr/knem/knem.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://gitlab.inria.fr/knem/knem/uploads/4a43e3eb860cda2bbd5bf5c7c04a24b6/${P}.tar.gz"
fi

DESCRIPTION="High-Performance Intra-Node MPI Communication"
HOMEPAGE="https://knem.gforge.inria.fr/"
LICENSE="
	LGPL-2
	GPL-2
"
SLOT="0"
IUSE="debug modules"
DEPEND="
	sys-apps/hwloc:=
	virtual/linux-sources
"
RDEPEND="
	sys-apps/hwloc:=
	sys-apps/kmod[tools]
"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="DMA_ENGINE"
	check_extra_config
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	sed 's:driver/linux::g' -i "Makefile.am" || die
	eautoreconf
	default
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		--enable-hwloc
		--with-linux="${KERNEL_DIR}"
		--with-linux-release=${KV_FULL}
	)
	econf ${myconf[@]}
}

src_compile() {
	default
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_compile || die "failed to build driver"
	fi
}

src_install() {
	default
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_install || die "failed to install driver"
	fi
	# Drop funny unneded stuff \
	rm "${ED}/usr/sbin/knem_local_install" || die
	rmdir "${ED}/usr/sbin" || die
	udev_dorules "${FILESDIR}/45-knem.rules"
	rm "${ED}/etc/10-knem.rules" || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
