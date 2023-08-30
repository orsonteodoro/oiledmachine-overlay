# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517="setuptools"
LLVM_MAX_SLOT=15
ROCM_VERSION="${PV}"
inherit cmake distutils-r1 llvm prefix rocm toolchain-funcs

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz
	-> rocm-Tensile-${PV}.tar.gz
"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="client openmp r4"
REQUIRED_USE="
	client? (
		${ROCM_REQUIRED_USE}
		openmp
	)
"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/msgpack-cxx-6.0.0
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-devel/clang:${LLVM_MAX_SLOT}
	sys-devel/gcc:11
	~dev-util/hip-${PV}:${SLOT}
	client? (
		dev-libs/boost
		~dev-util/rocm-smi-${PV}:${SLOT}
	)
	openmp? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		=sys-devel/gcc-11*
		sys-devel/lld:${LLVM_MAX_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.13
	sys-devel/gcc:11
	sys-devel/gcc-config
"
# Not compatible with recent versions of pytest
RESTRICT="test"
S="${WORKDIR}/${PN}-rocm-${PV}"
_PATCHES=(
	"${FILESDIR}/${PN}-change-cmake-name-for-msgpack-cxx-6-release.patch"
	"${FILESDIR}/${PN}-4.3.0-output-commands.patch"
	"${FILESDIR}/${PN}-5.4.2-gfx1031.patch"
	"${FILESDIR}/${PN}-5.4.2-fix-arch-parse.patch"
	"${FILESDIR}/${PN}-5.0.2-use-ninja.patch"
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)
CMAKE_USE_DIR="${S}/${PN}/Source"

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	eapply "${_PATCHES[@]}"
	distutils-r1_src_prepare
	sed \
		-e "s,\@LLVM_PATH\@,$(get_llvm_prefix ${LLVM_MAX_SLOT}),g" \
		"${FILESDIR}/${PN}-5.3.3-gentoopath.patch" \
		> \
		"${S}/gentoopath.patch" \
		|| die

	eapply $(prefixify_ro "${S}/gentoopath.patch")

	pushd "${PN}" || die

	sed \
		-e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i \
		"Source/cmake/FindROCmSMI.cmake" \
		|| die
	sed \
		-r \
		-e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i \
		"Source/CMakeLists.txt" \
		|| die
	sed \
		-e "/chmod 755/d" \
		-i \
		"Source/TensileCreateLibrary.cmake" \
		|| die # remove chmod 755 on

	# ${Tensile_ROOT}/bin does not exists; call command directly
	sed \
		-e "s,\${Tensile_ROOT}/bin/,,g" \
		-i \
		"Source/TensileCreateLibrary.cmake" \
		"cmake/TensileConfig.cmake" \
		|| die

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	hipconfig --help >/dev/null || die
	sed \
		-e "/HipClangVersion/s/0.0.0/$(hipconfig -v)/" \
		-i \
		"Common.py" \
		|| die

	sed \
		-e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" \
		-i \
		"ReplacementKernels.py" \
		"Common.py" \
		"${PN}.py" \
		|| die

	sed \
		-e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile/Source\", end='')|" \
		-i \
		"__init__.py" \
		|| die

	popd || die

	sed \
		-e "/package_data/d" \
		-e "/data_files/d" \
		-i \
		"setup.py" \
		|| die

einfo "PWD: ${PWD}"
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	if use openmp ; then
		has_version "sys-devel/gcc:11" || die "Reinstall gcc-11"
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		local gcc_slot=11
		local gcc_current_profile=$(gcc-config -c)
		local gcc_current_profile_slot=${gcc_current_profile##*-}
		if [[ "${gcc_current_profile_slot}" != "${gcc_slot}" ]] ; then
eerror
eerror "GCC ${gcc_slot} required for OpenMP.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "to change to gcc-${gcc_slot}"
eerror
			die
		fi
		append-flags -fuse-ld=lld
	fi

	export TENSILE_ROCM_ASSEMBLER_PATH="${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin/clang++"
	export TENSILE_ROCM_OFFLOAD_BUNDLER_PATH="${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin/clang-offload-bundler"

	distutils-r1_src_configure

	if use client; then
		local mycmakeargs=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DCMAKE_SKIP_RPATH=ON
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DTENSILE_BUILD_CLIENT=$(usex client ON OFF)
			-DTENSILE_USE_LLVM=ON
			-DTENSILE_USE_MSGPACK=ON
			-DTENSILE_USE_OPENMP=$(usex openmp ON OFF)
			-DTensile_LIBRARY_FORMAT="msgpack"
		)
		CXX="hipcc" \
		cmake_src_configure
	fi
}

src_compile() {
	distutils-r1_src_compile
	use client && cmake_src_compile
}

python_install() {
	distutils-r1_python_install
	python_moduleinto "Tensile"
	cd "Tensile" || die
	python_domodule "Components"
	python_newexe "Utilities/merge.py" "${PN}-merge"
}

src_install() {
	distutils-r1_src_install
	cd "${PN}" || die
	insinto "/usr/share/${PN}"
	doins -r \
		"Configs" \
		"CustomKernels" \
		"Perf" \
		"ReplacementKernels" \
		"ReplacementKernels-cov3" \
		"Source"
	insinto "/usr/$(get_libdir)/cmake/${PN}"
	doins "cmake/"*".cmake"
	if use client; then
		pushd "${BUILD_DIR}" || die
		dobin "client/tensile_client"
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
