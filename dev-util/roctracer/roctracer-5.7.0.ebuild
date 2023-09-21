# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=17
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic llvm prefix python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
IUSE=" system-llvm test"
# libhsa-runtime64.so.1.9.0: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
# This means it requires >= libstdc++ 12.
RDEPEND="
	!dev-util/roctracer:0
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
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
	test? (
		dev-util/rocm-compiler[system-llvm=]
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/roctracer-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-do-not-install-test-files.patch"
	"${FILESDIR}/${PN}-5.7.0-Werror.patch"
	"${FILESDIR}/${PN}-5.7.0-path-changes.patch"
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
	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

	if [[ "${CXX}" =~ "hipcc" ]] ; then
		append-flags --rocm-path="${ESYSROOT}${EROCM_PATH}"
	fi

	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
	)
	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# If LD_LIBRARY_PATH not set, dlopen cannot find the correct lib.
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)" \
	bash run.sh || die
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
