# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# google-cloud-vision (optional)
# unstructured-inference (optional)
# unstructured-pytesseract (optional)
# sacremoses (optional)

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit abseil-cpp distutils-r1 grpc protobuf pypi re2

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Unstructured-IO/unstructured.git"
	FALLBACK_COMMIT="55debafa8f89f42df5f5e35a686a4b4059e1221e" # Jan 29, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/Unstructured-IO/unstructured/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Open source libraries and APIs to build custom preprocessing pipelines for labeling, training, or production machine learning pipelines"
HOMEPAGE="
	https://github.com/Unstructured-IO/unstructured
	https://pypi.org/project/unstructured
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
DOCS_IUSE="
all-docs csv doc docx epub image md odt org pdf ppt pptx rst rtf tsv xlsx
ebuild_revision_1
"
LEGACY_IUSE="
huggingface local-inference paddleocr
"
IUSE+="
${DOCS_IUSE}
${LEGACY_IUSE}
-analytics
"
REQUIRED_USE="
	local-inference? (
		all-docs
	)
"
CONSTRAINTS_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/unstructured-client-0.23.0[${PYTHON_USEDEP}]
			<dev-python/unstructured-client-0.26.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/weaviate-client-3.26.7[${PYTHON_USEDEP}]
			<dev-python/weaviate-client-4.0.0[${PYTHON_USEDEP}]
		)
		<dev-python/botocore-1.34.132[${PYTHON_USEDEP}]
		<dev-python/urllib3-1.27[${PYTHON_USEDEP}]
		|| (
			dev-python/grpcio:5/1.71[${PYTHON_USEDEP}]
			dev-python/grpcio:6/1.75[${PYTHON_USEDEP}]
		)
		>=dev-python/grpcio-1.65.5[${PYTHON_USEDEP}]
		dev-python/grpcio:=
		>=dev-python/importlib-metadata-8.5.0[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/tokenizers-0.19[${PYTHON_SINGLE_USEDEP}]
		<sci-ml/tokenizers-0.20[${PYTHON_SINGLE_USEDEP}]
	)
"
BASE_RDEPEND="
	${CONSTRAINTS_RDEPEND}
	$(python_gen_cond_dep '
		<dev-python/numpy-2[${PYTHON_USEDEP}]
		dev-python/backoff[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/dataclasses-json[${PYTHON_USEDEP}]
		dev-python/emoji[${PYTHON_USEDEP}]
		dev-python/filetype[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/langdetect[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/nltk[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/python-iso639[${PYTHON_USEDEP}]
		dev-python/python-magic[${PYTHON_USEDEP}]
		dev-python/python-oxmsg[${PYTHON_USEDEP}]
		dev-python/rapidfuzz[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/unstructured-client[${PYTHON_USEDEP}]
		dev-python/wrapt[${PYTHON_USEDEP}]
	')
"
CSV_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pandas[${PYTHON_USEDEP}]
	')
"
DOC_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/python-docx-1.1.2[${PYTHON_USEDEP}]
	')
"
DOCX_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/python-docx-1.1.2[${PYTHON_USEDEP}]
	')
"
EPUB_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pypandoc[${PYTHON_USEDEP}]
	')
"
HUGGINGFACE_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/langdetect[${PYTHON_USEDEP}]
		dev-python/sacremoses[${PYTHON_USEDEP}]
		sci-ml/sentencepiece[${PYTHON_USEDEP}]
	')
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
"
IMAGE_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/unstructured-inference-0.8.6[${PYTHON_USEDEP}]
		>=dev-python/unstructured-pytesseract-0.3.12[${PYTHON_USEDEP}]
		dev-python/google-cloud-vision[${PYTHON_USEDEP}]
		dev-python/pdf2image[${PYTHON_USEDEP}]
		dev-python/pdfminer-six[${PYTHON_USEDEP}]
		dev-python/pikepdf[${PYTHON_USEDEP}]
		dev-python/pi_heif[${PYTHON_USEDEP}]
		dev-python/pypdf[${PYTHON_USEDEP}]
		sci-ml/onnx[${PYTHON_USEDEP}]
	')
	dev-python/effdet[${PYTHON_SINGLE_USEDEP}]
"
MARKDOWN_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/markdown[${PYTHON_USEDEP}]
	')
"
ODT_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/python-docx-1.1.2[${PYTHON_USEDEP}]
		dev-python/pypandoc[${PYTHON_USEDEP}]
	')
"
ORG_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pypandoc[${PYTHON_USEDEP}]
	')
"
PADDLEOCR_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/paddlepaddle-3.0.0_beta1[${PYTHON_USEDEP}]
		>=dev-python/unstructured-paddleocr-2.8.1.0[${PYTHON_USEDEP}]
	')
"
# pdfminer.six is app-text/pdfminer
PDF_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/unstructured-inference-0.8.6[${PYTHON_USEDEP}]
		>=dev-python/unstructured-pytesseract-0.3.12[${PYTHON_USEDEP}]
		dev-python/google-cloud-vision[${PYTHON_USEDEP}]
		dev-python/onnx[${PYTHON_USEDEP}]
		dev-python/pdf2image[${PYTHON_USEDEP}]
		dev-python/pdfminer[${PYTHON_USEDEP}]
		dev-python/pikepdf[${PYTHON_USEDEP}]
		dev-python/pi-heif[${PYTHON_USEDEP}]
		dev-python/pypdf[${PYTHON_USEDEP}]
	')
	dev-python/effdet[${PYTHON_SINGLE_USEDEP}]
"
PPT_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/python-pptx-1.0.1[${PYTHON_USEDEP}]
	')
"
PPTX_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/python-pptx-1.0.1[${PYTHON_USEDEP}]
	')
"
RST_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pypandoc[${PYTHON_USEDEP}]
	')
"
RTF_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pypandoc[${PYTHON_USEDEP}]
	')
"
TSV_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pandas[${PYTHON_USEDEP}]
	')
"
XLSX_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/xlrd[${PYTHON_USEDEP}]
	')
"

RDEPEND+="
	${BASE_RDEPEND}
	${CONSTRAINTS_RDEPEND}
	all-docs? (
		${CSV_RDEPEND}
		${DOC_RDEPEND}
		${DOCX_RDEPEND}
		${EPUB_RDEPEND}
		${IMAGE_RDEPEND}
		${MARKDOWN_RDEPEND}
		${ODT_RDEPEND}
		${ORG_RDEPEND}
		${PDF_RDEPEND}
		${PPT_RDEPEND}
		${PPTX_RDEPEND}
		${RST_RDEPEND}
		${RTF_RDEPEND}
		${TSV_RDEPEND}
		${XLSX_RDEPEND}
	)
	csv? (
		${CSV_RDEPEND}
	)
	doc? (
		${DOC_RDEPEND}
	)
	docx? (
		${DOCX_RDEPEND}
	)
	epub? (
		${EPUB_RDEPEND}
	)
	huggingface? (
		${HUGGINGFACE_RDEPEND}
	)
	image? (
		${IMAGE_RDEPEND}
	)
	md? (
		${MARKDOWN_RDEPEND}
	)
	odt? (
		${ODT_RDEPEND}
	)
	org? (
		${ORG_RDEPEND}
	)
	paddleocr? (
		${PADDLEOCR_RDEPEND}
	)
	pdf? (
		${PDF_RDEPEND}
	)
	ppt? (
		${PPT_RDEPEND}
	)
	pptx? (
		${PPTX_RDEPEND}
	)
	rst? (
		${RST_RDEPEND}
	)
	rtf? (
		${RTF_RDEPEND}
	)
	tsv? (
		${TSV_RDEPEND}
	)
	xlsx? (
		${XLSX_RDEPEND}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	if ! use analytics ; then
		eapply "${FILESDIR}/${PN}-0.16.17-remove-analytics.patch"
	fi
}

src_prepare() {
	default
	distutils-r1_src_prepare
}

python_configure() {
	if has_version "dev-python/grpcio:5/1.71" ; then
		ABSEIL_CPP_SLOT="20240722"
		GRPC_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
		RE2_SLOT="20240116"
	elif has_version "dev-python/grpcio:6/1.75" ; then
		ABSEIL_CPP_SLOT="20250512"
		GRPC_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
		RE2_SLOT="20240116"
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
	re2_python_configure
	grpc_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
