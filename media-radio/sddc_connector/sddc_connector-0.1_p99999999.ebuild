# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

GCC_SLOT="11"

if [[ "${PV}" =~ "99999999" ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	EGIT_COMMIT="057e7c3ec0c027ca51d6113fc1bf326de2e107e1"
	SRC_URI="
	https://github.com/jketterl/sddc_connector/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi


DESCRIPTION="Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on llibsddc"
HOMEPAGE="https://github.com/jketterl/sddc_connector"
LICENSE="GPL-3"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Not tagged or live snapshot
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
CUDA_TARGETS_COMPAT=(
	sm_60
)
IUSE+="
	${CUDA_TARGETS_COMPAT[@]/#/+cuda_targets_}
"
REQUIRED_USE="
	${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
"
RDEPEND+="
	>=media-radio/csdr-0.19
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
	virtual/pkgconfig
	sys-devel/gcc:${GCC_SLOT}
"
DOCS=( LICENSE )

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		EGIT_REPO_URI="https://github.com/jketterl/sddc_connector.git"
		EGIT_BRANCH="master"
		if use fallback-commit ; then
			EGIT_COMMIT="c39c26103c5412dbae27d8ce91c861cd6e1a3911" # Jul 4, 2023
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	export CC="${CHOST}-gcc-11"
	export CXX="${CHOST}-g++-11"

	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${GCC_SLOT}" -ne "${gcc_current_profile_slot}" ; then
#
# Fixes:
#
#    132 | #error -- unsupported GNU version! gcc versions later than 11 are not
# supported! The nvcc flag '-allow-unsupported-compiler' can be used to override
# this version check; however, using an unsupported host compiler may cause
# compilation failure or incorrect run time execution. Use at your own risk.
#        |  ^~~~~
#
eerror
eerror "You must switch to == GCC ${GCC_SLOT}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${GCC_SLOT}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
