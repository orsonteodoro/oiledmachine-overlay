# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=17
PYTHON_COMPAT=( python3_{9..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib"
	EGIT_BRANCH="master"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz
	-> rocm-smi-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
fi

DESCRIPTION="ROCm System Management Interface Library"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
LICENSE="
	MIT
	NCSA-AMD
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" r1"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
"
BDEPEND="
	>=dev-util/cmake-3.16.8
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-i \
		-e "/LICENSE.txt/d" \
		"CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "/find_program (GIT/d" \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DPKG_VERSION_STR="${PV}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl \
		python_newscript \
			python_smi_tools/rocm_smi.py rocm-smi
	python_foreach_impl \
		python_domodule \
			python_smi_tools/rsmiBindings.py
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
