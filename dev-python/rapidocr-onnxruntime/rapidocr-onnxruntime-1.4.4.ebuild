# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RapidOCR"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
S_PROJ="${WORKDIR}/${MY_PN}-${PV}"
S_PYTHON="${WORKDIR}/${MY_PN}-${PV}/python"
S_RES="${WORKDIR}/required_for_whl_v1.3.0"
# For resources, see https://github.com/RapidAI/RapidOCR/blob/v1.4.4/.github/workflows/gen_whl_to_pypi_rapidocr_ort.yml#L15
SRC_URI="
https://github.com/RapidAI/RapidOCR/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/RapidAI/RapidOCR/releases/download/v1.1.0/required_for_whl_v1.3.0.zip
"

DESCRIPTION="A cross platform OCR Library based on OnnxRuntime"
HOMEPAGE="
	https://github.com/RapidAI/RapidOCR
	https://pypi.org/project/rapidocr-onnxruntime
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pyclipper-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19.5[${PYTHON_USEDEP}]
		>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/shapely-1.7.1[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=media-libs/opencv-4.5.1.48[${PYTHON_SINGLE_USEDEP},python]
	>=sci-ml/onnxruntime-1.7.0[${PYTHON_SINGLE_USEDEP}]

"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	cd "${S_PROJ}" || die
	eapply "${FILESDIR}/${PN}-1.4.4-decrapify-version.patch"
}

src_prepare() {
	default
	distutils-r1_src_prepare

	sed -i \
		-e "s|@VERSION_NUM@|${PV}|g" \
		"${S_PYTHON}/setup_openvino.py" \
		"${S_PYTHON}/setup_onnxruntime.py" \
		"${S_PYTHON}/setup_paddle.py" \
		|| die

	cp \
		"${S_RES}/resources/models/"*".onnx" \
		"${S_PROJ}/python/rapidocr_onnxruntime/models/" \
		|| die
	cd "${S_PYTHON}" || die
	mkdir "rapidocr_onnxruntime_t" || die
	mv "rapidocr_onnxruntime" "rapidocr_onnxruntime_t" || die
	mv "rapidocr_onnxruntime_t" "rapidocr_onnxruntime" || die
	cd "rapidocr_onnxruntime" || die
	echo "from .rapidocr_onnxruntime.main import RapidOCR, VisRes" > "__init__.py"
}

python_compile() {
	cd "${S_PYTHON}" || die
	"${EPYTHON}" \
		"setup_onnxruntime.py" \
		"bdist_wheel" \
		"v${PV}" \
		|| die

	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	mkdir -p "${d}"
	local wheel_path=$(realpath "${S}/python/dist/rapidocr_onnxruntime-${PV}-py3-none-any.whl")
einfo "Installing wheel for ${EPYTHON}"
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

python_install() {
	:
}

src_install() {
	distutils-r1_src_install
	# The distutils eclass is broken.
	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	multibuild_merge_root "${d}" "${D%/}"
	docinto "licenses"
	dodoc "${S_PROJ}/LICENSE"
	rm -rf "${ED}/usr/bin" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
