# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Before fixing the paths any further, a reminder or warning for modders.
# There is a prebuilt binary that has a hardcoded path.  It is unknown if the
# path is relative or absolute.  All these ebuilds may need to use paths exactly
# like the binary release in order to reduce chances of breakage.
#
# See commit 52a3463 for details

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rdc/"
	inherit git-r3
else
	SRC_URI="
https://github.com/RadeonOpenCompute/rdc/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="The ROCm™ Data Center Tool simplifies the administration and \
addresses key infrastructure challenges in AMD GPUs in cluster and datacenter \
environments."
HOMEPAGE="https://github.com/RadeonOpenCompute/rdc"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
# raslib is installed by default, but disabled for security.
IUSE="+compile-commands doc +raslib +standalone systemd test r6"
REQUIRED_USE="
	raslib
	systemd? (
		standalone
	)
"
# abseil-cpp needs >=c++11
RDEPEND="
	sys-libs/libcap
	~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	raslib? (
		~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
	)
	standalone? (
		>=net-libs/grpc-1.28.1:=
		>=dev-libs/protobuf-3.11.2:0/3.21
	)
	systemd? (
		sys-apps/systemd
	)
"
#	|| (
#		~sys-kernel/rock-dkms-${PV}:${ROCM_SLOT}
#		~sys-kernel/rocm-sources-${PV}:${ROCM_SLOT}
#	)
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16.8
	doc? (
		>=app-text/doxygen-1.8.11
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
		virtual/latex-base
	)
	test? (
		>=dev-cpp/gtest-1.11.0
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		~dev-util/rocprofiler-${PV}:${ROCM_SLOT}
	)
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/rdc-5.2.3-raslib-install.patch"
	"${FILESDIR}/rdc-5.2.3-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_RASLIB=OFF # No repo
		-DBUILD_ROCPTEST=$(usex test ON OFF)
		-DBUILD_ROCRTEST=$(usex raslib ON OFF)
		-DBUILD_STANDALONE=$(usex standalone ON OFF)
		-DCMAKE_EXPORT_COMPILE_COMMANDS=$(usex compile-commands ON OFF)
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DGRPC_ROOT="${ESYSROOT}/usr"
		-DINSTALL_RASLIB=$(usex raslib ON OFF)
		-DRDC_CLIENT_INSTALL_PREFIX="${EROCM_PATH#*/}"
		-DROCM_DIR="${ESYSROOT}/${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
	patchelf \
		--add-rpath "${EPREFIX}${EROCM_PATH}/rdc/$(get_libdir)" \
		"${ED}${EROCM_PATH}/rdc/$(get_libdir)/librdc.so.1.0" \
		|| die
	patchelf \
		--add-rpath "${EPREFIX}${EROCM_PATH}/rdc/$(get_libdir)" \
		"${ED}${EROCM_PATH}/rdc/$(get_libdir)/librdc_rocr.so.1.0" \
		|| die
}

pkg_postinst() {
	if has_version "~sys-kernel/rock-dkms-${PV}" \
		|| has_version "~sys-kernel/rocm-sources-${PV}" ; then
		:;
	else
ewarn
ewarn "ONE following are required to use ${PN}:"
ewarn
ewarn "  ~sys-kernel/rock-dkms-${PV}"
ewarn "  ~sys-kernel/rocm-sources-${PV}"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
