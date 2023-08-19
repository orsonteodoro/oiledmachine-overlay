# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{9..10} )

inherit cmake llvm python-any-r1

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
IUSE=" +aqlprofile"
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
	"${FILESDIR}/${PN}-5.0.2-gentoo-location.patch"
	"${FILESDIR}/${PN}-5.1.3-remove-Werror.patch"
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	sed \
		-e "s,\${DEST_NAME}/lib,$(get_libdir),g" \
		-e "s,\${DEST_NAME}/include,include/\${DEST_NAME},g" \
		-e "s,\${DEST_NAME}/bin,bin,g" \
		-e "/ctrl DESTINATION/s,\${DEST_NAME}/tool,bin,g" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-e "/libtool.so DESTINATION/s,\${DEST_NAME}/tool,$(get_libdir),g" \
		-i \
		CMakeLists.txt \
		|| die

	sed \
		-i \
		-e "s|@EPREFIX@|${EPREFIX}|g" \
		"bin/build_kernel.sh" \
		|| die
	sed \
		-i \
		-e "s|@LLVM_SLOT@|${LLVM_SLOT}|g" \
		"bin/build_kernel.sh" \
		|| die

	cmake_src_prepare

	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-4.3.0-no-aqlprofile.patch"
	fi

	sed \
		-e "s,@LIB_DIR@,$(get_libdir),g" \
		-i \
		bin/rpl_run.sh \
		|| die
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
