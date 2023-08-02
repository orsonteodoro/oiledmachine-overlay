# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit cmake python-any-r1

SRC_URI="
https://github.com/ROCm-Developer-Tools/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocprofiler.git"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	~dev-util/roctracer-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	')
	>=dev-util/cmake-3.18.0
"
RESTRICT="test"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-no-aqlprofile.patch"
	"${FILESDIR}/${PN}-5.6.0-gentoo-location.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-aql-in-cmake.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare
	sed \
		-e "s,@LIB_DIR@,$(get_libdir),g" \
		-i \
		bin/rpl_run.sh \
		|| die
}

src_configure() {
	export CMAKE_BUILD_TYPE="debug"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
		-DCMAKE_SKIP_RPATH=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DPROF_API_HEADER_PATH="${EPREFIX}/usr/include/roctracer/ext"
		-DUSE_PROF_API=1
	)
	cmake_src_configure
}
