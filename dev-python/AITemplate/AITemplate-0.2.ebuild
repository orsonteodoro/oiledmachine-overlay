# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMPOSABLE_KERNEL_COMMIT="d8b41e1c96d864569a2f2b59a3fbf14912a4e317"
CUB_COMMIT="dcd5b06a417bdfdc2699678bddf7dd7ee38be466"
CUTLASS_COMMIT="5d7be1ac1b0dae1e9b8ccbe98d494ccaa437ddc0"
DISTUTILS_USE_PEP517="setuptools"
PICOJSON_COMMIT="111c9be5188f7350c2eac9ddaedd8cca3d7bf394"
PYTHON_COMPAT=( "python3_"{10..12} )
inherit hip-versions
ROCM_VERSIONS=(
	"${HIP_5_6_VERSION}" # Same same major.minor version used in Composable Kernel, similar range to PyTorch 2.1, 2.2
)

inherit dep-prepare distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/facebookincubator/AITemplate.git"
	FALLBACK_COMMIT="f711356346c115f980604fd9381a745b95a80abd" # Dec 4, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}/python"
	SRC_URI="
https://github.com/facebookincubator/AITemplate/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/ROCm/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> composable_kernel-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
https://github.com/AITemplate/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
https://github.com/kazuho/picojson/archive/${PICOJSON_COMMIT}.tar.gz
	-> picojson-${PICOJSON_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A Python framework rendering neural network into high performance CUDA/HIP C++ code"
HOMEPAGE="
	https://github.com/facebookincubator/AITemplate
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	BSD
	BSD-2
	MIT
"
# BSD - cub
# BSD - cutlas
# BSD-2 - picojson
# MIT all-rights-reserved - composable_kernel
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda dev doc rocm"
REQUIRED_USE="
	|| (
		cuda
		rocm
	)
"
# The dependencies for GPUs are old.  Upstream uses CUDA 11.6.2 and ROCm 5.2.3
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_VERSIONS} ; do
		local s="${pv%.*}"
		echo "
			(
				~dev-build/rocm-cmake-${pv}:${s}
				~dev-libs/rocm-device-libs-${pv}:${s}
				~dev-util/hip-${pv}:${s}[numa,rocm]
				~sys-devel/llvm-roc-${pv}:${s}[llvm_targets_AMDGPU,llvm_targets_X86,runtime]
			)
		"
	done
}
RDEPEND+="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	cuda? (
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
		dev-build/rocm-cmake:=
		dev-libs/rocm-device-libs:=
		dev-util/hip:=
		sys-devel/llvm-roc:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=()

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/composable_kernel-${COMPOSABLE_KERNEL_COMMIT}" "${S}/3rdparty/composable_kernel"
		dep_prepare_mv "${WORKDIR}/cub-${CUB_COMMIT}" "${S}/3rdparty/cub"
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT}" "${S}/3rdparty/cutlass"
		dep_prepare_mv "${WORKDIR}/picojson-${PICOJSON_COMMIT}" "${S}/3rdparty/picojson"
	fi
}

src_install() {
	distutils-r1_src_install
	cd "${WORKDIR}/${PN}-${PV}" || die
	docinto "licenses"
	dodoc "LICENSE"
	if use doc ; then
		dodoc "README.md"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
