# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Before fixing the paths any further, a reminder or warning for modders.
# There is a prebuilt binary that has a hardcoded path.  It is unknown if the
# path is relative or absolute.  All these ebuilds may need to use paths exactly
# like the binary release in order to reduce chances of breakage.
#
# See commit 52a3463 for details

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic grpc-ver rocm

GRPC_SLOTS=(
	"1.61"
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
)

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rdc/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/rdc/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="The ROCm™ Data Center Tool simplifies the administration and \
addresses key infrastructure challenges in AMD GPUs in cluster and datacenter \
environments."
HOMEPAGE="https://github.com/RadeonOpenCompute/rdc"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain All rights reserved.
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
# raslib is installed by default, but disabled for security.
IUSE="+compile-commands doc +raslib +standalone systemd test ebuild_revision_16"
REQUIRED_USE="
	raslib
	systemd? (
		standalone
	)
"
# abseil-cpp needs >=c++14
# Originally >=net-libs/grpc-1.44.0:= but relaxed
gen_standalone_rdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2=$(grpc_get_protobuf_slot "${s1}")
		echo "
			(
				=net-libs/grpc-${s1}*
				dev-libs/protobuf:0/${s2}
			)
		"
	done
}
RDEPEND="
	sys-libs/libcap
	~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	standalone? (
		|| (
			$(gen_standalone_rdepend)
		)
		dev-libs/protobuf:=
		net-libs/grpc:=
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
	${ROCM_GCC_DEPEND}
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
PATCHES=(
	"${FILESDIR}/${PN}-6.2.4-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
	if use standalone ; then
#/usr/include/absl/strings/string_view.h:52:21: note: 'std::string_view' is only available from C++17 onwards
#   52 | using string_view = std::string_view;
#      |                     ^~~
		sed -i -e "s|-std=c++11|-std=c++17|g" \
			$(grep -l -r -e "-std=c++11" ./)
		sed -i -e "s|CMAKE_CXX_STANDARD 11|CMAKE_CXX_STANDARD 17|g" \
			CMakeLists.txt
	fi
}

src_configure() {
	rocm_set_default_gcc

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
		-DBUILD_RASLIB=OFF # No repo
		-DBUILD_ROCPTEST=$(usex test ON OFF)
		-DBUILD_ROCRTEST=$(usex raslib ON OFF)
		-DBUILD_STANDALONE=$(usex standalone ON OFF)
		-DCMAKE_EXPORT_COMPILE_COMMANDS=$(usex compile-commands ON OFF)
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}${EROCM_PATH}"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DGRPC_ROOT="${ESYSROOT}/usr"
		-DINSTALL_RASLIB=$(usex raslib ON OFF)
		-DRDC_CLIENT_INSTALL_PREFIX="share/rdc"
		-DROCM_DIR="${ESYSROOT}/${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

pkg_postinst() {
	if \
		   has_version "~sys-kernel/rock-dkms-${PV}" \
		|| has_version "~sys-kernel/rocm-sources-${PV}" ; then
		:
	else
ewarn
ewarn "ONE following are required to use ${PN}:"
ewarn
ewarn "  ~sys-kernel/rock-dkms-${PV}"
ewarn "  ~sys-kernel/rocm-sources-${PV}"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
