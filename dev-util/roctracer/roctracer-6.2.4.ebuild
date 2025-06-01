# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-compiler-switch cmake flag-o-matic prefix python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/roctracer-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" test ebuild_revision_9"
CDEPEND="
	${ROCM_CLANG_DEPEND}
"
RDEPEND="
	${CDEPEND}
	!dev-util/roctracer:0
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}
	$(python_gen_any_dep '
		dev-python/cppheaderparser[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-3.18.0
"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-do-not-install-test-files.patch"
	"${FILESDIR}/${PN}-5.7.0-Werror.patch"
)

python_check_deps() {
	python_has_version \
		"dev-python/cppheaderparser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	pushd "${S}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/roctracer-5.6.1-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	hprefixify "script/"*".py"
	rocm_src_prepare

}

src_configure() {
	addpredict "/dev/kfd"

	rocm_set_default_clang

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

	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DPython3_EXECUTABLE="/usr/bin/${EPYTHON}"
	)
	rocm_src_configure
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
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
