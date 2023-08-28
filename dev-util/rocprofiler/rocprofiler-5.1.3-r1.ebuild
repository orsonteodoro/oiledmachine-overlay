# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{9..10} )

inherit cmake llvm python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="
	MIT
	BSD
"
# BSD - src/util/hsa_rsrc_factory.cpp
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=" +aqlprofile r2"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${SLOT}
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
	>=dev-util/cmake-2.8.12
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-nostrip.patch"
	"${FILESDIR}/${PN}-5.1.3-remove-Werror.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		CMakeLists.txt \
		|| die

	cmake_src_prepare

	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-4.3.0-no-aqlprofile.patch"
	fi

	rocm_src_prepare
}

src_configure() {
	if use aqlprofile ; then
		[[ -e "${ESYSROOT}/opt/rocm-${PV}/lib/libhsa-amd-aqlprofile64.so" ]] || die "Missing" # For 071379b
	fi
	local gpu_targets=$(get_amdgpu_flags \
		| tr ";" " ")
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/hip"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
		-DGPU_TARGETS="${gpu_targets}"
		-DPROF_API_HEADER_PATH="${EPREFIX}/usr/include/roctracer/ext"
		-DUSE_PROF_API=1
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
