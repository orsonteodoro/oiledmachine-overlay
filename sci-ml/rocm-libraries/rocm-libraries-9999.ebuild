# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Live is only supported on oiledmachine-overlay.  Reasons:
# For miscompilation mitigation and version alignment with ROCm/llvm-project
# For ROCm/amdgpu version alignment and for security mitigation.
# Monolithic is used to speed up and simplify packaging.

# The following commit is chosen if all are true:
# "TheRock Multi-Arch CI ASAN Nightly" passed
# "hipBLASLt ASAN CI" passed
# >= 160/210 checks passed

CXX_STANDARD=20
LLVM_SLOT=24
PYTHON_COMPAT=( "python3_"{11..15} )
ROCM_SLOT=$(ver_cut "1-2" "${PV}")

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]}"
)

inherit check-compiler-switch cmake flag-o-matic git-r3 libcxx-slot libstdcxx-slot python-r1 rocm-r1

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/ROCm/rocm-systems"
	FALLBACK_COMMIT="1702865a2f3950fba359989c74ca90263d245003" # Nov 6, 2026
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	FFTS_COMMIT="b22d839b61c5bd8a993e24ae3e01f39d9b5084fb"
	GOOGLETEST_COMMIT="e2239ee6043f73722e7aa812a459f54a28552929"
	MIFIN_COMMIT="06650bddfe40c47294b0414e4262691333b788dd"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/MIFin/archive/${MIFIN_COMMIT}.tar.gz
	-> MIFin-${MIFIN_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT:0:7}.tar.gz
https://github.com/anthonix/ffts/archive/${FFTS_COMMIT}.tar.gz
	-> ffts-${FFTS_COMMIT:0:7}.tar.gz
https://github.com/ROCm/rocm-libraries/archive/refs/tags/therock-${PV}.tar.gz
	-> rocm-libraries-${PV}.tar.gz
	"
fi

DESCRIPTION="Super repo for ROCm libraries"
HOMEPAGE="https://github.com/ROCm/rocm-libraries"
LICENSE="
	MIT
"
SLOT="0/${ROCM_SLOT}"
IUSE+=" ebuild_revision_0"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
BANNED_RDEPEND="
	!sci-libs/composable-kernel
	!sci-libs/hipBLAS
	!sci-libs/hipBLASLt
	!sci-libs/hipCUB
	!sci-libs/hipFFT
	!sci-libs/hipRAND
	!sci-libs/hipSOLVER
	!sci-libs/hipSPARSE
	!sci-libs/hipSPARSELt
	!sci-libs/hipTensor
	!sci-libs/miopen
	!sci-libs/rocALUTION
	!sci-libs/rocBLAS
	!sci-libs/rocFFT
	!sci-libs/rocPRIM
	!sci-libs/rocRAND
	!sci-libs/rocSOLVER
	!sci-libs/rocSPARSE
	!sci-libs/rocThrust
	!sci-libs/rocWMMA
	!sci-libs/rpp
"
RDEPEND="
	${BANNED_RDEPEND}
	${PYTHON_DEPS}
	sys-apps/hwdata:=
	virtual/kfd:=
	|| (
		>=virtual/kfd-10:0/10
	)
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	=sys-devel/hip-clang-9999
	>=dev-build/cmake-3.16.8
	virtual/pkgconfig
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	sed \
		-i \
		-e "/find_program (GIT/d" \
		"CMakeLists.txt" \
		|| die
	cmake_src_prepare
}

src_configure() {
	rocm-r1_set_default_gcc

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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${ROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DPKG_VERSION_STR="${PV}"
	)
	cmake_src_configure
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
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
