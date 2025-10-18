# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
)

inherit check-compiler-switch cmake libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "99999999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/jketterl/sddc_connector.git"
	EGIT_BRANCH="master"
	FALLBACK_COMMIT="c39c26103c5412dbae27d8ce91c861cd6e1a3911" # Jul 4, 2023
	inherit git-r3
else
	EGIT_COMMIT="c39c26103c5412dbae27d8ce91c861cd6e1a3911" # Jul 4, 2023
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
	https://github.com/jketterl/sddc_connector/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on libsddc"
HOMEPAGE="https://github.com/jketterl/sddc_connector"
LICENSE="GPL-3"
# KEYWORDS="~amd64" # Not tagged or live snapshot
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
CUDA_TARGETS_COMPAT=(
	sm_60
)
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/+cuda_targets_}
ebuild_revision_5
"
REQUIRED_USE="
	${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
"
RDEPEND+="
	>=media-radio/csdr-0.19[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	media-radio/csdr:=
	>=media-radio/owrx_connector-0.7
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-8*:=
			=dev-util/nvidia-cuda-toolkit-9*:=
			=dev-util/nvidia-cuda-toolkit-10*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
			=dev-util/nvidia-cuda-toolkit-12*:=
		)
	)
	|| (
		media-radio/libsddc
		media-radio/ExtIO_sddc
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-0.19
	sys-devel/gcc
	virtual/pkgconfig
"
DOCS=( LICENSE )

pkg_setup() {
	check-compiler-switch_start
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		if use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
