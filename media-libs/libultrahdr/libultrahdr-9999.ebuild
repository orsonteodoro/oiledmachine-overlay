# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17

LIBSMPTE2094_50_PV="0.1.4"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"media-libs/libjpeg-turbo-9999"
	"media-libs/mesa-9999"
)

inherit cflags-hardened chkl cmake-multilib libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="ad4a92eea0d2f39f18b5ecae3165fdd56c6a478b"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/libultrahdr.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/google/libultrahdr/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	smpte2094-50? (
https://github.com/webmproject/libsmpte2094-50/archive/refs/tags/v${LIBSMPTE2094_50_PV}.tar.gz
	-> smpte2094-50-${LIBSMPTE2094_50_PV}.tar.gz
	)
	"
fi

DESCRIPTION="An image compression library that uses gain map technology to store and distribute HDR images"
HOMEPAGE="
	https://github.com/google/libultrahdr
"
LICENSE="
	Apache-2.0
	MIT
"
RESTRICT="mirror"
SOVER="1"
SLOT="0/${SOVER}"
# examples is enabled on upstream but disabled by default in this ebuild.
IUSE+="
-benchmark -examples -gles +intrinsics -smpte2094-50 -test
ebuild_revision_1
"
RDEPEND+="
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	gles? (
		>=media-libs/mesa-${MESA_PV}:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

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
	local actual_sover=$(grep -r -e "UHDR_MAJOR_VERSION" "${S}/CMakeLists.txt" | cut -f 2 -d " " | sed -e "s|)||g")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		-DUHDR_BUILD_BENCHMARK=$(usex benchmark)
		-DUHDR_BUILD_EXAMPLES=$(usex examples)
		-DUHDR_BUILD_JAVA=OFF
		-DUHDR_BUILD_TESTS=$(usex test)
		-DUHDR_ENABLE_GLES=$(usex gles)
		-DUHDR_ENABLE_INTRINSICS=$(usex intrinsics)
		-DUHDR_ENABLE_LOGS=OFF
		-DUHDR_ENABLE_SMPTE2094_50=$(usex smpte2094-50)
	)

	if ! [[ "${PV}" =~ "9999" ]] ; then
		mycmakeargs+=(
			-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		)
		if use smpte2094-50 ; then
			mycmakeargs+=(
				-DFETCHCONTENT_SOURCE_DIR_LIBSMPTE2094_50="${WORKDIR}/libsmpte2094-50-${LIBSMPTE2094_50_PV}"
			)
		fi
	fi

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "LICENSE-APACHE"
	dodoc "LICENSE-MIT"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
