# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild has been created with the help of AI inference.

CXX_STANDARD=11
LIBOPENCL_STUB="c34834a65f89ca5e7115395d6e86892eaf2bba38"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

inherit cmake dep-prepare libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/krrishnarraj/clpeak.git"
	FALLBACK_COMMIT="f846511fe2c99a5fa255c85cb4b40091b9e63bb0" # May 8, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/krrishnarraj/clpeak/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/krrishnarraj/libopencl-stub/archive/${LIBOPENCL_STUB}.tar.gz
	-> libopencl-stub-${LIBOPENCL_STUB:0:7}.tar.gz
	"
fi

DESCRIPTION="A synthetic micro-benchmark that measures the peak achievable performance of GPU compute devices"
HOMEPAGE="
	https://github.com/krrishnarraj/clpeak
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cuda metal opencl vulkan
ebuild_revision_2
"
REQUIRED_USE="
	opencl
	!kernel_Darwin? (
		!metal
	)

	|| (
		cuda
		metal
		opencl
		vulkan
	)
"
CUDA_3_2="
	(
		=dev-util/nvidia-cuda-toolkit-13.2*
		>=x11-drivers/nvidia-drivers-595.45.04
	)
"
RDEPEND+="
	opencl? (
		virtual/opencl[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	cuda? (
		|| (
			${CUDA_3_2}
		)
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers:=
	)
	vulkan? (
		virtual/vulkan[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	opencl? (
		dev-cpp/clhpp:=
	)
	vulkan? (
		dev-util/vulkan-headers:=
	)
"
BDEPEND+="
	>=dev-build/cmake-3.20
"
DOCS=( "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	dep_prepare_mv "${WORKDIR}/libopencl-stub-${LIBOPENCL_STUB}" "${S}/android/app/src/main/cpp/libopencl-stub"
}

src_configure() {
	local mycmakeargs=()

	mycmakeargs+=(
		-DCLPEAK_ENABLE_CUDA=$(usex cuda)
		-DCLPEAK_ENABLE_METAL=$(usex metal)
		-DCLPEAK_ENABLE_VULKAN=$(usex vulkan)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.0.3 (20260508)
