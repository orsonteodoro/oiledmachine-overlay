# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils flag-o-matic toolchain-funcs

DESCRIPTION="rapidjson"
HOMEPAGE="http://rapidjson.org/"
SRC_URI="https://github.com/miloyip/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT BSD JSON"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+doc +examples +debug"
REQUIRED_USE=""

RDEPEND="dev-cpp/gtest"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"

S="${WORKDIR}/rapidjson-${PV}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
        local mycmakeargs=(
                $(cmake-utils_use doc RAPIDJSON_BUILD_DOC)
                $(cmake-utils_use examples RAPIDJSON_BUILD_EXAMPLES)
                $(cmake-utils_use debug RAPIDJSON_BUILD_TESTS)
		-DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF
		-DRAPIDJSON_HAS_CXX11_RVALUE_REFS=ON
        )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
