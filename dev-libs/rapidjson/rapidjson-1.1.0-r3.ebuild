# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on rapidjson-1.1.0-r2 from the gentoo-overlay.

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO PE"

inherit cflags-hardened cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/miloyip/rapidjson.git"
	inherit git-r3
else
	SRC_URI="https://github.com/miloyip/rapidjson/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/rapidjson-${PV}"
fi

DESCRIPTION="A fast JSON parser/generator for C++ with both SAX/DOM style API"
HOMEPAGE="https://rapidjson.org/"
LICENSE="MIT"
IUSE="
doc examples test
ebuild_revision_7
"
RESTRICT="!test? ( test )"
SLOT="0/$(ver_cut 1-2 ${PV})"
DEPEND="
	doc? (
		app-text/doxygen
	)
	test? (
		dev-cpp/gtest
		dev-debug/valgrind
	)"
RDEPEND="
"
# Header only use shared folders like glm
PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-gcc-7.patch"
	"${FILESDIR}/${PN}-1.1.0-r2-shared-dest.patch"
)

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e 's|-Werror||g' \
		"CMakeLists.txt" \
		|| die
	sed -i \
		-e 's|-Werror||g' \
		"example/CMakeLists.txt" \
		|| die
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DRAPIDJSON_BUILD_DOC="$(usex doc)"
		-DRAPIDJSON_BUILD_EXAMPLES="$(usex examples)"
		-DRAPIDJSON_BUILD_TESTS="$(usex test)"
		-DRAPIDJSON_BUILD_THIRDPARTY_GTEST="OFF"
		-DSHARE_INSTALL_DIR="${EPREFIX}/usr/share"
	)
	cmake_src_configure
}
