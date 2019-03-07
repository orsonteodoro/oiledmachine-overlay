# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils flag-o-matic toolchain-funcs

DESCRIPTION="A fast JSON parser/generator for C++ with both SAX/DOM style API"
HOMEPAGE="http://rapidjson.org/"
COMMIT="3cf4f7c5a030e9a65b842d2e160ffee90df7613d"
SRC_URI="https://github.com/Tencent/rapidjson/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT BSD JSON"
SLOT="${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+doc +examples +debug"
REQUIRED_USE=""

RDEPEND="dev-cpp/gtest"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
"

S="${WORKDIR}/rapidjson-${COMMIT}"

src_prepare() {
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
        local mycmakeargs=(
                -DRAPIDJSON_BUILD_DOC=$(usex doc)
                -DRAPIDJSON_BUILD_EXAMPLES=$(usex examples)
                -DRAPIDJSON_BUILD_TESTS=$(usex debug)
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
