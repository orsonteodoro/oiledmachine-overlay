# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..11} )
ROCM_VERSION="${PV}"

inherit cmake llvm prefix python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=" test"
# libhsa-runtime64.so.1.9.0: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
# This means it requires >= libstdc++ 12.
RDEPEND="
	>=sys-devel/gcc-12
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	~dev-util/hip-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
	')
	>=dev-util/cmake-3.18.0
	>=sys-devel/gcc-12
	sys-devel/gcc-config
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/roctracer-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-do-not-install-test-files.patch"
	"${FILESDIR}/${PN}-5.3.3-Werror.patch"
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)

python_check_deps() {
	python_has_version \
		"dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	hprefixify script/*.py
	rocm_src_prepare
}

src_configure() {
	local gcc_slot=12
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	if ver_test ${gcc_current_profile_slot} -lt ${gcc_slot} ; then
eerror
eerror "GCC ${gcc_slot}+ required.  Do"
eerror
eerror "  eselect set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
		die
	fi
	hipconfig --help >/dev/null || die
	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	export HIP_PLATFORM="amd"
	export ROCM_PATH="$(hipconfig -p)"
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
	)
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# If LD_LIBRARY_PATH not set, dlopen cannot find the correct lib.
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)" \
	bash run.sh || die
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
