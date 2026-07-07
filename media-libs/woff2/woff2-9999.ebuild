# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
)

inherit cflags-hardened chkl cmake

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="fb9c3379f2605b10f3e8f1d9636664ab5576775c"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/google/woff2.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE+="
ebuild_revision_10
"

RDEPEND=">=app-arch/brotli-9999:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-gcc15.patch
	"${FILESDIR}"/${PN}-cmake-minimum-ver-3.10.patch #951837
)

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

src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dobin "${BUILD_DIR}"/woff2_compress
	dobin "${BUILD_DIR}"/woff2_decompress
	dobin "${BUILD_DIR}"/woff2_info

	einstalldocs
}
