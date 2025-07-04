# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
NIFTI_TEST_DATA_PV="3.0.2"

inherit cflags-hardened cmake-multilib xdg multilib-minimal

if [[ "${PV}" == *"9999"* ]] ; then
	FALLBACK_COMMIT="96b9954fafcf3bd69a4ee2091b0d707ed2077697"
	EGIT_REPO_URI="https://github.com/NIFTI-Imaging/nifti_clib.git"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
		https://github.com/NIFTI-Imaging/nifti_clib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/NIFTI-Imaging/nifti-test-data/archive/v${NIFTI_TEST_DATA_PV}.tar.gz -> nifti-test-data-${NIFTI_TEST_DATA_PV}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="C libraries for NIFTI support"
HOMEPAGE="https://github.com/NIFTI-Imaging/nifti_clib"
LICENSE="public-domain"
RESTRICT="!test" # Untested
SLOT="0/$(ver_cut 1-2)"
IUSE+="
fsliolib test
"
REQUIRED_USE="
"
RDEPEND="
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.10.2
"

src_unpack() {
	if [[ "${PV}" == *"9999"* ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		_src_unpack_abi() {
			einfo "MULTILIB_ABI_FLAG:  ${MULTILIB_ABI_FLAG}"
			einfo "ABI:  ${ABI}"
			mkdir -p "${WORKDIR}/nifti_clib-${PV}_build-${MULTILIB_ABI_FLAG}.${ABI}/_deps/fetch_testing_data-subbuild/fetch_testing_data-populate-prefix/src"
			cat \
				"${DISTDIR}/nifti-test-data-${NIFTI_TEST_DATA_PV}.tar.gz" \
				> \
				"${WORKDIR}/nifti_clib-${PV}_build-${MULTILIB_ABI_FLAG}.${ABI}/_deps/fetch_testing_data-subbuild/fetch_testing_data-populate-prefix/src/v3.0.2.tar.gz" \
				|| die
		}
		multilib_foreach_abi _src_unpack_abi
	fi
}

multilib_src_compile() {
	cflags-hardened_append
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
		-DDOWNLOAD_TEST_DATA=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DNIFTI_BUILD_APPLICATIONS=ON
		-DNIFTI_INSTALL_ARCHIVE_DIR=$(get_libdir)
		-DNIFTI_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DUSE_FSL_CODE=$(usex fsliolib)
	)
	cmake_src_configure
}
