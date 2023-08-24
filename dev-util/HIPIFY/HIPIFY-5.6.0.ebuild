# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16

inherit cmake llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/HIPIFY/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCm-Developer-Tools/HIPIFY/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="HIPIFY: Convert CUDA to Portable C++ Code"
HOMEPAGE="https://github.com/RadeonOpenCompute/HIPIFY"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
gen_llvm_rdepend() {
	local s="${1}"
	echo "
		(
			~sys-devel/llvm-${s}
			~sys-devel/clang-${s}
		)
	"
}
# https://github.com/ROCm-Developer-Tools/HIPIFY/blob/rocm-5.6.0/docs/hipify-clang.md#hipify-clang-dependencies
CDEPEND="
	|| (
		(
			=dev-util/nvidia-cuda-toolkit-12.1*:=
			|| (
				$(gen_llvm_rdepend 17.0.0.9999)
				$(gen_llvm_rdepend 16.0.3)
				$(gen_llvm_rdepend 16.0.2)
				$(gen_llvm_rdepend 16.0.1)
				$(gen_llvm_rdepend 16.0.0)
			)
		)
		(
			=dev-util/nvidia-cuda-toolkit-11.8*:=
			|| (
				$(gen_llvm_rdepend 15.0.7)
				$(gen_llvm_rdepend 15.0.6)
				$(gen_llvm_rdepend 15.0.5)
				$(gen_llvm_rdepend 15.0.4)
				$(gen_llvm_rdepend 15.0.3)
				$(gen_llvm_rdepend 15.0.2)
				$(gen_llvm_rdepend 15.0.1)
				$(gen_llvm_rdepend 15.0.0)
				$(gen_llvm_rdepend 14.0.6)
				$(gen_llvm_rdepend 14.0.5)
			)
		)
	)
"
RDEPEND="
	!test? (
		sys-devel/llvm:${LLVM_MAX_SLOT}
		sys-devel/clang:${LLVM_MAX_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	!test? (
		sys-devel/llvm:${LLVM_MAX_SLOT}
		sys-devel/clang:${LLVM_MAX_SLOT}
	)
	test? (
		${CDEPEND}
	)
	>=dev-util/cmake-3.16.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/HIPIFY-5.6.0-llvm-dynlib-on.patch"
	"${FILESDIR}/HIPIFY-5.6.0-path-changes.patch"
)

pkg_setup() {
	if ! use test ; then
		:;
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.1*" && has_version "=sys-devel/clang-17*" && has_version "=sys-devel/llvm-17*" ; then
		LLVM_MAX_VERSION=17
	elif has_version "=dev-util/nvidia-cuda-toolkit-12.1*" && has_version "=sys-devel/clang-16*" && has_version "=sys-devel/llvm-16*" ; then
		LLVM_MAX_VERSION=16
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-15*" && has_version "=sys-devel/llvm-15*" ; then
		LLVM_MAX_VERSION=15
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/clang-14*" && has_version "=sys-devel/llvm-14*" ; then
		LLVM_MAX_VERSION=14
	fi
	llvm_pkg_setup
	if has_version "=dev-util/nvidia-cuda-toolkit-12.1*" ; then
ewarn "CUDA 12 is experimental."
	fi
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	einfo "PATH=${PATH} (after)"

	export CC="${CHOST}-clang-${LLVM_SLOT}"
	export CXX="${CHOST}-clang++-${LLVM_SLOT}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
