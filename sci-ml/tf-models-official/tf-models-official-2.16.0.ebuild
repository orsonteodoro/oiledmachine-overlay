# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A snapshot of the TensorFlow Model Garden

# TODO package:
# tf-keras		rdep

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI="https://github.com/tensorflow/models.git"
	FALLBACK_COMMIT="47177eb11128d7f75f165530ab472fc36904e07a" # Mar 12, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/models-${PV}"
	SRC_URI="
https://github.com/tensorflow/models/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Models and examples built with TensorFlow"
HOMEPAGE="
	https://github.com/tensorflow/models
	https://pypi.org/project/tf-models-official/
"
LICENSE="Apache-2.0"
RESTRICT="
	test
"
SLOT="0/${PV%.*}"
IUSE+=" doc nlp test"
if [[ "${PV}" =~ "9999" ]] ; then
	RDEPEND+="
		$(python_gen_cond_dep '
			>=dev-python/wrapt-1.15[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
		')
		>=dev-python/tf-keras-9999[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-hub-9999[${PYTHON_SINGLE_USEDEP}]
		media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	"
else
	RDEPEND+="
		$(python_gen_cond_dep '
			>=dev-python/pyyaml-6.0.0[${PYTHON_USEDEP}]
		')
		>=dev-python/tf-keras-2.16.0[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-hub-0.6.0[${PYTHON_SINGLE_USEDEP}]
		media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	"
fi
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/google-api-python-client-1.6.7[${PYTHON_USEDEP}]
		>=dev-python/kaggle-1.3.9[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
		>=dev-python/pandas-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.4.3[${PYTHON_USEDEP}]
		>=dev-python/py-cpuinfo-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-0.19.1[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/immutabledict[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/oauth2client[${PYTHON_USEDEP}]
		dev-python/pycocotools[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
		nlp? (
			dev-python/sacrebleu[${PYTHON_USEDEP}]
			sci-ml/sentencepiece[${PYTHON_USEDEP},python]
			sci-ml/seqeval[${PYTHON_USEDEP}]
		)
	')
	>=sci-ml/tensorflow-model-optimization-0.4.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/tf-slim-1.1.0[${PYTHON_SINGLE_USEDEP}]
	sci-ml/tensorflow-datasets[${PYTHON_SINGLE_USEDEP}]
	nlp? (
		sci-ml/tensorflow-text:0/${PV%.*}[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
"

src_unpack() {
einfo "To get the research models use the live (9999) version."
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_configure() {
	cython_set_cython_slot
	cython_python_configure
}

python_compile() {
	cd "${S}/official/pip_package" || die
	distutils-r1_python_compile
	mkdir -p "${S}-${EPYTHON/./_}/install/usr/bin"
}

python_install() {
	distutils-r1_python_install
	cd "${S}" || die
	local MODULES=(
		"official"
		"orbit"
		"tensorflow_models"
	)
	python_domodule ${MODULES[@]}
	rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/"{"pip_package","benchmark","colab","recommendation.ranking.data.preprocessing"}
	dodoc \
		"LICENSE"
}
