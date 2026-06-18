# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO ID NPD OOBR OOBW"

CHKL_TIMESTAMPS=(
	"media-libs/libjpeg-turbo-9999;Wed, 3 Jun 2026 09:43:18 -0400"
	"media-libs/tiff-9999;Sat, 6 Jun 2026 18:02:16 +0545"
)

inherit cflags-hardened meson-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="76ffc49448b8bd6aa6a36c1f5869ab318831abb9"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/mm2/Little-CMS.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/lcms2-${PV/_}"
	SRC_URI="https://github.com/mm2/Little-CMS/releases/download/lcms${PV/_}/${PN}2-${PV/_}.tar.gz"
fi

DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="https://www.littlecms.com/"

# GPL-3 for the threaded & fastfloat plugins, see meson_options.txt
LICENSE="GPL-3 MIT"
SLOT="2"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE="
doc jpeg static-libs test tiff
ebuild_revision_1
"
RESTRICT="!test? ( test )"

RDEPEND="
	jpeg? (
		>=media-libs/libjpeg-turbo-9999:=[${MULTILIB_USEDEP}]
	)
	tiff? (
		>=media-libs/tiff-9999:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		-Dthreaded=true
		-Dfastfloat=true
		$(meson_feature jpeg)
		$(meson_feature test tests)
		$(meson_feature tiff)
		$(meson_native_true utils)
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
