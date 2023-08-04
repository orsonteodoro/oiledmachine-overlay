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
IUSE=" -aqlprofile"
RDEPEND="
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	~dev-util/hip-${PV}:${SLOT}
	~dev-util/roctracer-${PV}:${SLOT}
	aqlprofile? (
		~dev-libs/hsa-amd-aqlprofile-${PV}:${SLOT}
		~dev-libs/rocr-runtime-${PV}:${SLOT}
	)
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
	"${FILESDIR}/${PN}-5.6.0-gentoo-location.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-4.3.0-no-aqlprofile.patch"
		eapply "${FILESDIR}/${PN}-5.3.3-remove-aql-in-cmake.patch"
	fi

	sed \
		-e "s,@LIB_DIR@,$(get_libdir),g" \
		-i \
		bin/rpl_run.sh \
		|| die

	# Caused by commit e80f7cb
	sed \
		-i \
		-e "s|NOT AQLPROFILE_LIB|FALSE|g" \
		"src/api/CMakeLists.txt" \
		|| die

	# Caused by commit e80f7cb
	sed \
		-i \
		-e "s|NOT AQLPROFILE_LIB|FALSE|g" \
		"src/tools/rocprofv2/CMakeLists.txt" \
		|| die

	# Caused by commit 071379b
	sed \
		-i \
		-e "s|NOT FIND_AQL_PROFILE_LIB|FALSE|g" \
		"cmake_modules/env.cmake" \
		|| die
}

src_configure() {
	if use aqlprofile ; then
		[[ -e "${ESYSROOT}/opt/rocm-${PV}/lib/hsa-amd-aqlprofile/librocprofv2_att.so" ]] || die "Missing" # For e80f7cb
		[[ -e "${ESYSROOT}/opt/rocm-${PV}/lib/libhsa-amd-aqlprofile64.so" ]] || die "Missing" # For 071379b
	fi
	export CMAKE_BUILD_TYPE="debug"
	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
		-DCMAKE_SKIP_RPATH=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DGPU_TARGETS="${gpu_targets}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DPROF_API_HEADER_PATH="${EPREFIX}/usr/include/roctracer/ext"
		-DUSE_PROF_API=1
	)
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}
