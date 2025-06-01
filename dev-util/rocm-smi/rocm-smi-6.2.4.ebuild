# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic python-r1 rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz
	-> rocm-smi-${PV}.tar.gz
	"
fi

DESCRIPTION="ROCm System Management Interface Library"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
	NCSA-AMD
"
# all-rights-reserved MIT - License.txt
# MIT - third_party/shared_mutex/LICENSE
# NCSA-AMD - src/rocm_smi.cc
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" ebuild_revision_9"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
	|| (
		virtual/kfd-ub:6.2
		virtual/kfd:6.1
		virtual/kfd-lb:6.0
	)
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.16.8
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-i \
		-e "/find_program (GIT/d" \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DPKG_VERSION_STR="${PV}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl \
		python_newscript \
			"python_smi_tools/rocm_smi.py" \
			"rocm-smi"
	python_foreach_impl \
		python_domodule \
			"python_smi_tools/rsmiBindings.py"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
