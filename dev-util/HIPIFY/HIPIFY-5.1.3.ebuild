# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14

inherit cmake llvm

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
# https://github.com/ROCm-Developer-Tools/HIPIFY/tree/rocm-5.1.3#-hipify-clang-dependencies
CDEPEND="
	|| (
		(
			=dev-util/nvidia-cuda-toolkit-11.5*:=
			|| (
				$(gen_llvm_rdepend 13.0.1)
				$(gen_llvm_rdepend 13.0.0)
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
	>=dev-util/cmake-3.8
"
RESTRICT="
	test
"
PATCHES=(
	"${FILESDIR}/HIPIFY-5.1.3-llvm-dynlib-on.patch"
	"${FILESDIR}/HIPIFY-5.1.3-path-changes.patch"
)

pkg_setup() {
	if !use test ; then
		:;
	elif has_version "=dev-util/nvidia-cuda-toolkit-11.5*" && has_version "=sys-devel/clang-13*" && has_version "=sys-devel/llvm-13*" ; then
		LLVM_MAX_VERSION=13
	fi
	llvm_pkg_setup
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
