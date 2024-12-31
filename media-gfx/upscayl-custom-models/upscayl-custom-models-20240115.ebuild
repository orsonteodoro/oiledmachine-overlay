# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"

MODELS=(
	"4xHFA2k"
	"4xLSDIR"
	"4xLSDIRCompactC3"
	"4xLSDIRplusC"
	"4xNomos8kSC"
	"4x_NMKD-Siax_200k"
	"4x_NMKD-Superscale-SP_178000_G"
	"RealESRGAN_General_WDN_x4_v3"
	"RealESRGAN_General_x4_v3"
	"realesr-animevideov3-x2"
	"realesr-animevideov3-x3"
	"realesr-animevideov3-x4"
	"uniscale_restore"
	"unknown-2_0_1"
)

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/upscayl/custom-models.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	FALLBACK_COMMIT="4b6d2cfa59c7442af115dfc6e50fd8d7d40b96ef" # Jan 15, 2024
	S="${WORKDIR}/${PN}-${PV}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="4b6d2cfa59c7442af115dfc6e50fd8d7d40b96ef" # Jan 15, 2024
	S="${WORKDIR}/custom-models-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/upscayl/custom-models/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT}.tar.gz
https://github.com/xinntao/Real-ESRGAN/blob/5ca1078535923d485892caee7d7804380bfc87fd/LICENSE
	-> Real-ESRGAN-LICENSE-5ca1078
	"
#
# The Real-ESRGAN repo release section contains the animevideov3,
# realesr-general* models not Real-ESRGAN-ncnn-vulkan.
#
fi

DESCRIPTION="Extra custom models for Upscayl."
HOMEPAGE="https://github.com/upscayl/custom-models"
LICENSE="
	4xHFA2k? (
		CC-BY-4.0
	)
	4xLSDIR? (
		CC-BY-4.0
	)
	4xLSDIRCompactC3? (
                CC-BY-4.0
	)
	4xLSDIRplusC? (
		CC-BY-4.0
	)
	4xNomos8kSC? (
		CC-BY-4.0
	)
	4x_NMKD-Siax_200k? (
		WTFPL
	)
	4x_NMKD-Superscale-SP_178000_G? (
		WTFPL
	)
	realesr-animevideov3-x2? (
		BSD
	)
	realesr-animevideov3-x3? (
		BSD
	)
	realesr-animevideov3-x4? (
		BSD
	)
	RealESRGAN_General_WDN_x4_v3? (
		BSD
	)
	RealESRGAN_General_x4_v3? (
		BSD
	)
	uniscale_restore? (
		CC-BY-NC-SA-4.0
	)
	unknown-2_0_1? (
		AGPL-3
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ${MODELS[@]}"
REQUIRED_USE="
	|| (
		${MODELS[@]}
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
PDEPEND+="
	>=media-gfx/upscayl-2.5
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	insinto "/usr/share/${PN}"
	local m
	for m in ${MODELS[@]} ; do
		if [[ "${m}" == "unknown-2_0_1" ]] ; then
			m="unknown-2.0.1"
		fi
		doins "models/${m}"{".bin",".param"}
	done
	insinto "/usr/share/doc/${P}"

	if \
		   use realesr-animevideov3-x2 \
		|| use realesr-animevideov3-x3 \
		|| use realesr-animevideov3-x4 \
		|| use RealESRGAN_General_WDN_x4_v3 \
		|| use RealESRGAN_General_x4_v3 \
	; then
		newins \
			"${DISTDIR}/Real-ESRGAN-LICENSE-5ca1078" \
			"Real-ESRGAN-LICENSE"
	fi
	einstalldocs
}

pkg_postinst() {
	einfo "To install, see https://github.com/upscayl/custom-models?tab=readme-ov-file#instructions"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
