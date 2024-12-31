# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODEL_VER="3.4"
DISTUTILS_USE_PEP517="setuptools"
DOWNLOAD_URI="https://github.com/notAI-tech/NudeNet/releases/tag/v3.4-weights"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1
# The pypi eclass looks bugged for fetch restrictions.  So it been dropped.

SRC_URI+="
fetch+https://files.pythonhosted.org/packages/source/${PN}/${PN}/${P}.tar.gz -> ${P}.tar.gz
https://github.com/notAI-tech/NudeNet/releases/download/v3.4-weights/320n.onnx -> ${PN}-model-${MODEL_VER}-320n.onnx
https://github.com/notAI-tech/NudeNet/releases/download/v3.4-weights/320n.pt -> ${PN}-model-${MODEL_VER}-320n.pt
https://github.com/notAI-tech/NudeNet/releases/download/v3.4-weights/640m.onnx -> ${PN}-model-${MODEL_VER}-640m.onnx
https://github.com/notAI-tech/NudeNet/releases/download/v3.4-weights/640m.pt -> ${PN}-model-${MODEL_VER}-640m.pt
"

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Lightweight nudity detection"
HOMEPAGE="
	https://nudenet.notai.tech/
	https://github.com/notAI-tech/NudeNet
	https://pypi.org/project/nudenet
"
LICENSE="
	AGPL-3
	MIT
"
RESTRICT="fetch mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

CHECKSUMS=(
	# Name ; Renamed ; size ; blake2b ; sha512
	"320n.onnx;${PN}-model-${MODEL_VER}-320n.onnx;11.6 MB;8dc40657facf95107f777eb2f5d2b5573679ea5a52c3ff23ad012657f94e3fcdc0b91a40e7d1b656f8c9147552c276eb59c6683e812aaa3a6f57df0ec165d947;dd4f90666106fed7ad1550867e39cc4ed49e2b377d7cb47bfbc63b0a7537f6735745989360706471c949a9e847c791f4c95415f3d1fcb55dabc9029840b58603"
	"320n.pt;${PN}-model-${MODEL_VER}-320n.pt;5.93 MB;dde1b09199514ca1ac1b4d2239359222d5fdc06c16b1d6bad2d8d99b753d8907f1479c1dd043adad8acf07f907965dd76f60c74c4cc528beea72ce1e751d6fd5;8e22124f7f73a3d7aa28d288b0f3ea178411220ca2be58e495aee71840182af07cba72d2583961528d5ed348a18377e25f359b2550eb164cd0907de74f11c45a"
	"640m.onnx;${PN}-model-${MODEL_VER}-640m.onnx;98.7 MB;1ca7b0691003c7d4f39d3fbfb33fba923807c9384030dcb7c12103419b1e33e797b364cce966073a901d33db02fe9e9f547c2c223704c0471deb46100b9c34eb;f233aa1858985453d4a1f22d4697c7aa063c98991ed8f4f92aeb37365129b3cf4f74b35d72c3730d7cee20eff379bb8c45ffc6f34221d5ba0f316bb9f1df956c"
	"640m.pt;${PN}-model-${MODEL_VER}-640m.pt;49.6 MB;997f2fc67d2568be97bb5bb11b17edd6272a2a92764506a014a58201d83c439014819fb745c29e88ce6dc555dc5ce3a3f14131e125df1f3415b8be5d57b1e537;4082a1f66c4976354f32cfa5a2b451eb83e8d9b54f55377aee671e375e5389c6967d09132fc902d4c9182e784740b50d30f41853b04e4914b31df4ac0c3cabba"
)

pkg_nofetch() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "You need to download the models from GitHub while logged in through the web browser."
einfo
einfo "Download URI:  ${DOWNLOAD_URI}"
einfo "Model version:  ${MODEL_VER}"
einfo "Copy renamed files to:  ${EDISTDIR}"
einfo
printf "%15s | %30s | %10s | %10s | %10s\n" "File name" "Rename to" "Size" "blake2b" "sha512"
	IFS=$'\n'
	local row
	for row in ${CHECKSUMS[@]} ; do
		local name=$(echo "${row}" | cut -f 1 -d ";")
		local rname=$(echo "${row}" | cut -f 2 -d ";")
		local size=$(echo "${row}" | cut -f 3 -d ";")
		local blake2b=$(echo "${row}" | cut -f 4 -d ";")
		local sha512=$(echo "${row}" | cut -f 5 -d ";")
printf "%15s | %30s | %10s | %10s | %10s\n" "${name}" "${rname}" "${size}" "${blake2b:0:7}" "${sha512:0:7}"
	done
	IFS=$' \t\n'
einfo
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"

	IFS=$'\n'
	local row
	for row in ${CHECKSUMS[@]} ; do
		local name=$(echo "${row}" | cut -f 1 -d ";")
		local rname=$(echo "${row}" | cut -f 2 -d ";")
		local size=$(echo "${row}" | cut -f 3 -d ";")
		local blake2b=$(echo "${row}" | cut -f 4 -d ";")
		local sha512=$(echo "${row}" | cut -f 5 -d ";")
		insinto "/usr/share/${PN}/models"
		newins \
			$(realpath "${DISTDIR}/${rname}") \
			"${name}" \
			|| die
	done
	IFS=$' \t\n'
	rm -rf "${ED}/usr/bin" || die
	rm -rf "${ED}/usr/lib/python-exec" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
