# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
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
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517="setuptools"
LLVM_MAX_SLOT=14
inherit distutils-r1 llvm prefix

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz
	-> rocm-Tensile-${PV}.tar.gz
https://github.com/littlewu2508/littlewu2508.github.io/raw/main/gentoo-distfiles/${PN}-5.0.2-PR1419.patch.gz
"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="client"
REQUIRED_USE="
	client? (
		${ROCM_REQUIRED_USE}
	)
"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/msgpack-cxx-6.0.0
	>=sys-libs/libomp-${LLVM_MAX_SLOT}
	dev-libs/boost
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/hip-${PV}:${SLOT}
	~dev-util/rocm-smi-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.13
"
# Not compatible with recent versions of pytest
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-change-cmake-name-for-msgpack-cxx-6-release.patch"
	"${FILESDIR}/${PN}-4.3.0-output-commands.patch"
	"${FILESDIR}/${PN}-5.0.2-gfx1031.patch"
	"${FILESDIR}/${PN}-5.0.2-fix-arch-parse.patch"
	"${FILESDIR}/${PN}-5.0.2-use-ninja.patch"
)
S="${WORKDIR}/${PN}-rocm-${PV}"
CMAKE_USE_DIR="${WORKDIR}/Source"

src_prepare() {
	distutils-r1_src_prepare
	sed \
		-e "s,\@LLVM_PATH\@,$(get_llvm_prefix ${LLVM_MAX_SLOT}),g" \
		"${FILESDIR}/${PN}-5.1.3-gentoopath.patch" \
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
	sed \
		-e "s,\${Tensile_ROOT}/bin/,,g" \
		-i \
		"Source/TensileCreateLibrary.cmake" \
		"cmake/TensileConfig.cmake" \
		|| die # ${Tensile_ROOT}/bin does not exists; call command directly

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	hipconfig --help >/dev/null || die
	sed \
		-e "/HipClangVersion/s/0,0,0/$(hipconfig -v)/" \
		-i \
		"Common.py" \
		|| die

	sed \
		-e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" \
		-i "ReplacementKernels.py" \
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
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
