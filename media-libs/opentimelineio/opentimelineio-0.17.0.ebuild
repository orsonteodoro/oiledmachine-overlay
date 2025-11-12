# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

MY_PN="OpenTimelineIO"
MY_PV="${PV/_pre/.dev}"

CXX_STANDARD=17
IMATH_COMMIT="b90cc01bc7fafeaa507d3b94689367478ab67807"
PYBIND11_COMMIT="8a099e44b3d5f85b20f05828d919d2332a8de841"
RAPIDJSON_COMMIT="06d58b9e848c650114556a23294d0b6440078c61"

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cmake dep-prepare libcxx-slot libstdcxx-slot

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/OpenTimelineIO.git"
	EGIT_SUBMODULES=( '*' )
	FALLBACK_COMMIT="4440afaa27b16f81cdf81215ce4d0b08e1424148" # Jun 24, 2024
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64 ~arm64-macos ~x64-macos"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenTimelineIO/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/AcademySoftwareFoundation/Imath/archive/${IMATH_COMMIT}.tar.gz
	-> imath-${IMATH_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.tar.gz
	-> pybind11-${PYBIND11_COMMIT:0:7}.tar.gz
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="An interchange format for editorial timeline information"
HOMEPAGE="
	https://opentimeline.io
	https://github.com/AcademySoftwareFoundation/OpenTimelineIO
"
LICENSE="
	(
		BSD
		JSON
		MIT
	)
	Apache-2.0
	BSD
"
# BSD - imath
# BSD - pybind11
# BSD, JSON, MIT - rapidjson
SLOT="0"
IUSE+=" doc"
RDEPEND="
	>=dev-libs/imath-3.1.4[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.18.2
	doc? (
		>=app-text/doxygen-1.9.1
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.17.0-libdir.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/Imath-${IMATH_COMMIT}" "${S}/src/deps/Imath"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT}" "${S}/src/deps/pybind11"
		dep_prepare_mv "${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}" "${S}/src/deps/rapidjson"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DOTIO_AUTOMATIC_SUBMODULES=OFF
		-DOTIO_CXX_COVERAGE=OFF
		-DOTIO_CXX_EXAMPLES=OFF
		-DOTIO_CXX_INSTALL=ON
		-DOTIO_DEPENDENCIES_INSTALL=ON
		-DOTIO_FIND_IMATH=ON
		-DOTIO_INSTALL_COMMANDLINE_TOOLS=ON
		-DOTIO_INSTALL_CONTRIB=OFF
		-DOTIO_PYTHON_INSTALL=OFF
		-DOTIO_SHARED_LIBS=ON
	)
	cmake_src_configure
}
