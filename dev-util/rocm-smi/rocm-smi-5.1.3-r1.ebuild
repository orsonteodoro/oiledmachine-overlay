# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{9..10} )

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
SLOT="0/$(ver_cut 1-2)"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
"
BDEPEND="
	>=dev-util/cmake-3.6.3
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-gcc12-memcpy.patch"
	"${FILESDIR}/${PN}-5.1.3-detect-builtin-amdgpu.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "/DESTINATION/s,\${OAM_NAME}/lib,$(get_libdir)," \
		-e "/DESTINATION/s,oam/include/oam,include/oam," \
		-i \
		oam/CMakeLists.txt \
		|| die
	sed \
		-e "/link DESTINATION/,+1d" \
		-e "/DESTINATION/s,\${ROCM_SMI}/lib,$(get_libdir)," \
		-e "/bindings_link/,+3d" \
		-e "/rsmiBindings.py/,+1d" \
		-e "/DESTINATION/s,rocm_smi/include/rocm_smi,include/rocm_smi," \
		-i \
		rocm_smi/CMakeLists.txt \
		|| die
	sed \
		-e "/LICENSE.txt/d" \
		-e "s,\${ROCM_SMI}/lib/cmake,$(get_libdir)/cmake,g" \
		-i \
		CMakeLists.txt \
		|| die
	sed \
		-e "/^path_librocm = /c\path_librocm = '${EPREFIX}/usr/lib64/librocm_smi64.so'" \
		-i \
		python_smi_tools/rsmiBindings.py \
		|| die
	IFS=$'\n'
		sed \
			-i \
			-e "s|{ROCM_DIR}/lib|{ROCM_DIR}/$(get_libdir)|g" \
			$(grep -r -l -F -e "{ROCM_DIR}/lib" "${WORKDIR}") \
			|| die
		sed \
			-i \
			-e "s|{PROJECT_BINARY_DIR}/lib|{PROJECT_BINARY_DIR}/$(get_libdir)|g" \
			$(grep -r -l -F -e "{PROJECT_BINARY_DIR}/lib" "${WORKDIR}") \
			|| die
		sed \
			-i \
			-e "s|{OAM_TARGET_NAME}/lib|{OAM_TARGET_NAME}/$(get_libdir)|g" \
			$(grep -r -l -F -e "{OAM_TARGET_NAME}/lib" "${WORKDIR}") \
			|| die
		sed \
			-i \
			-e "s|{ROCM_SMI}/lib|{ROCM_SMI}/$(get_libdir)|g" \
			$(grep -r -l -F -e "{ROCM_SMI}/lib" "${WORKDIR}") \
			|| die
		sed \
			-i \
			-e "s|{CMAKE_BINARY_DIR}/lib|{CMAKE_BINARY_DIR}/$(get_libdir)|g" \
			$(grep -r -l -F -e "{CMAKE_BINARY_DIR}/lib" "${WORKDIR}") \
			|| die
		sed \
			-i \
			-e "s| lib/| $(get_libdir)/|g" \
			$(grep -r -l -F -e " lib/" "README.md") \
			|| die
	IFS=$' \t\n'
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-D_VERSION_MAJOR=$(ver_cut 1 ${PV})
		-D_VERSION_MINOR=$(ver_cut 2 ${PV})
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl \
		python_newscript \
			python_smi_tools/rocm_smi.py \
			rocm-smi
	python_foreach_impl \
		python_domodule \
			python_smi_tools/rsmiBindings.py
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
