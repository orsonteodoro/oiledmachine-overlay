# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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
SLOT="0/$(ver_cut 1-2 ${PV})"
# raslib is installed by default, but disabled for security.
IUSE="+compile-commands doc -raslib +standalone systemd test"
RDEPEND="
	sys-libs/libcap
	~dev-util/rocm-smi-${PV}:${SLOT}
	raslib? (
		~dev-libs/roct-thunk-interface-${PV}:${SLOT}
	)
	standalone? (
		>=net-libs/grpc-1.44.0
		dev-libs/protobuf:0/32
	)
	systemd? (
		sys-apps/systemd
	)
"
#	|| (
#		~sys-kernel/rock-dkms-${PV}:${SLOT}
#		~sys-kernel/rocm-sources-${PV}:${SLOT}
#	)
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16.8
	doc? (
		>=app-doc/doxygen-1.8.11
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
		virtual/latex-base
	)
	test? (
		>=dev-cpp/gtest-1.11.0
		~dev-libs/rocr-runtime-${PV}:${SLOT}
		~dev-util/rocprofiler-${PV}:${SLOT}
	)
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/rdc-5.3.3-raslib-install.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_RASLIB=OFF # No repo
		-DBUILD_ROCPTEST=$(usex test ON OFF)
		-DBUILD_ROCRTEST=$(usex test ON OFF)
		-DBUILD_STANDALONE=$(usex standalone ON OFF)
		-DCMAKE_EXPORT_COMPILE_COMMANDS=$(usex compile-commands ON OFF)
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DGRPC_ROOT="${ESYSROOT}/usr"
		-DINSTALL_RASLIB=$(usex raslib ON OFF)
	)
	cmake_src_configure
}

pkg_postinst() {
	if has_version "~sys-kernel/rock-dkms-${PV}" \
		|| has_version "~sys-kernel/rocm-sources-${PV}" ; then
		:;
	else
ewarn
ewarn "The ONE following are required to use ${PN}:"
ewarn
ewarn "  ~sys-kernel/rock-dkms-${PV}"
ewarn "  ~sys-kernel/rocm-sources-${PV}"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
