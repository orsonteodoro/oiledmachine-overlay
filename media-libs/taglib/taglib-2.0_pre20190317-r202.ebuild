# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
LICENSE="LGPL-2.1 MPL-1.1"

# Untagged / live snapshots do not get KEYWORDs

SLOT="taglib2-preview/${PV}" # _pre suffix added to avoid future conflicts with official release
IUSE+=" debug examples test"
RESTRICT="mirror !test? ( test )"
RDEPEND+=" >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
EGIT_COMMIT="65a6a4e225fff1288148de92721418e1c634713b"
SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
PATCHES=(
	"${FILESDIR}/${PN}-${PV}-merge-conflict-avoidance.patch"
	"${FILESDIR}/${PN}-2.0_pre20190317-install-examples.patch"
	"${FILESDIR}/${PN}-2.0_pre20190317-link-tag2-for-tagwriter.patch"
	"${FILESDIR}/${PN}-2.0_pre20190317-link-tag2-for-tag2_c.patch"
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib2-config
)

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	cmake_src_prepare

	sed -e "s/BUILD_TESTS AND NOT BUILD_SHARED_LIBS/BUILD_TESTS/" \
		-i CMakeLists.txt \
		-i ConfigureChecks.cmake || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
