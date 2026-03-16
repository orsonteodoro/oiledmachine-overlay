# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO ID NPD OOBR OOBW"

inherit cflags-hardened meson-multilib

DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="https://www.littlecms.com/"
SRC_URI="https://github.com/mm2/Little-CMS/releases/download/lcms${PV/_}/${PN}2-${PV/_}.tar.gz"
S="${WORKDIR}/lcms2-${PV/_}"

# GPL-3 for the threaded & fastfloat plugins, see meson_options.txt
LICENSE="GPL-3 MIT"
SLOT="2"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE="doc jpeg static-libs tiff"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.15-meson-big-endian.patch
	"${FILESDIR}"/${PN}-2.15-meson-samples.patch
	"${FILESDIR}"/${PN}-2.15-meson-psicc-man-page.patch
	"${FILESDIR}"/${PN}-2.15-pthread-linking.patch
)

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		-Dthreaded=true
		-Dfastfloat=true
		$(meson_feature jpeg)
		$(meson_feature tiff)
	)

	meson_src_configure
}

multilib_src_test() {
	# fast_float_testbed on hppa -> 1458s from default timeout of 600, #913067
	meson_src_test --timeout-multiplier=3
}

multilib_src_install_all() {
	use doc && dodoc doc/*.pdf
}
