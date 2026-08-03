# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"dev-libs/utfcpp-9999"
)

inherit chkl cmake-multilib secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="2ada48a77f9b5158f6a4313ed7a90de8efc4eb75"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/taglib/taglib.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.org"

LICENSE="LGPL-2.1 MPL-1.1"
SOVER="2"
SLOT="0/${SOVER}"
IUSE+=" doc examples test"

RESTRICT="!test? ( test )"

RDEPEND=">=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-libs/utfcpp-${UTFCPP_PV}:=
	test? ( dev-util/cppunit:=[${MULTILIB_USEDEP}] )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
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
	local actual_sover=$(grep -r -e "TAGLIB_SOVERSION_MAJOR" | head -n 1 | cut -f 2 -d " " | sed -e "s|)||")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump the SOVER in the ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi && use doc; then
		cmake_build docs
	fi
}

multilib_src_test() {
	eninja -C "${BUILD_DIR}" check
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
	cmake_src_install
}
