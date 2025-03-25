# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# apache-beam
# conllu
# crepe
# envlogger
# gcld3
# gcsfs
# imagecodecs
# mwxml
# pretty_midi
# pytest-shard
# tensorflow-data-validation

MY_PN="datasets"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/tensorflow/datasets.git"
	FALLBACK_COMMIT="7eeb2004bca47b83fabb477019d081d67c4a3c06" # Jun 5, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/tensorflow/datasets/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="TFDS is a collection of datasets ready to use with TensorFlow, Jax, ..."
HOMEPAGE="
	https://github.com/tensorflow/datasets
	https://pypi.org/project/tensorflow-datasets
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
aflw2k3d beir ble_wind_field c4 c4_wsrs cats_vs_dogs colorectal_histology
common_voice duke_ultrasound eurosat groove gtzan huggingface librispeech
imagenet2012_corrupted locomotion lsun matplotlib nsynth ogbg_molpcba pet_finder
qm9 robonet robosuite_panda_pick_place_can smartwatch_gestures svhn tensorflow
tensorflow-data-validation test the300w_lp wider_face wiki_dialog wikipedia
wsc273 youtube_vis
"

# Same as RDEPEND without conditionals and apache-beam
HUGGINGFACE_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/etils-1.6.0[${PYTHON_USEDEP},enp,epath,epy,etree]
	' python3_10)
	$(python_gen_cond_dep '
		>=dev-python/etils-1.9.1[${PYTHON_USEDEP},enp,epath,epy,etree]
	' python3_{11,12})
	$(python_gen_cond_dep '
		dev-python/envlogger[${PYTHON_USEDEP}]
	' python3_10)
	>=dev-python/array-record-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	>=dev-python/requests-2.19.0[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-0.20.3[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/crepe[${PYTHON_USEDEP}]
	dev-python/gcsfs[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/imagecodecs[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	dev-python/langdetect[${PYTHON_USEDEP}]
	dev-python/librosa[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/mwparserfromhell[${PYTHON_USEDEP}]
	dev-python/mwxml[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/nltk[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pretty_midi[${PYTHON_USEDEP}]
	dev-python/promise[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyarrow[${PYTHON_USEDEP}]
	dev-python/pycocotools[${PYTHON_USEDEP}]
	dev-python/pydub[${PYTHON_USEDEP}]
	dev-python/scikit-image[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/simple-parsing[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/tifffile[${PYTHON_USEDEP}]
	dev-python/tldextract[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
	dev-python/dm-tree[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},python]
	sci-libs/gcld3[${PYTHON_USEDEP}]
	sci-ml/tensorflow[${PYTHON_USEDEP}]
	sci-ml/tensorflow-data-validation[${PYTHON_USEDEP}]
	sci-ml/tensorflow-io[${PYTHON_USEDEP}]
	sci-ml/tensorflow-metadata[${PYTHON_USEDEP}]
	virtual/pillow[${PYTHON_USEDEP}]

	sci-ml/datasets[${PYTHON_USEDEP}]
"

RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/etils-1.6.0[${PYTHON_USEDEP},enp,epath,epy,etree]
	' python3_10)
	$(python_gen_cond_dep '
		>=dev-python/etils-1.9.1[${PYTHON_USEDEP},enp,epath,epy,etree]
	' python3_{11,12})
	>=dev-python/array-record-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	>=dev-python/requests-2.19.0[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/promise[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyarrow[${PYTHON_USEDEP}]
	dev-python/simple-parsing[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/dm-tree[${PYTHON_USEDEP}]
	sci-ml/tensorflow-metadata[${PYTHON_USEDEP}]
	aflw2k3d? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	beir? (
		dev-db/apache-beam[${PYTHON_USEDEP}]
	)
	ble_wind_field? (
		dev-python/gcsfs[${PYTHON_USEDEP}]
		dev-python/zarr[${PYTHON_USEDEP}]
	)
	c4? (
		dev-db/apache-beam[${PYTHON_USEDEP}]
		dev-python/langdetect[${PYTHON_USEDEP}]
		dev-python/nltk[${PYTHON_USEDEP}]
		dev-python/tldextract[${PYTHON_USEDEP}]
		sci-libs/gcld3[${PYTHON_USEDEP}]
	)
	c4_wsrs? (
		dev-db/apache-beam[${PYTHON_USEDEP}]
	)
	cats_vs_dogs? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
	colorectal_histology? (
		virtual/pillow[${PYTHON_USEDEP}]
	)
	common_voice? (
		dev-python/pydub[${PYTHON_USEDEP}]
	)
	duke_ultrasound? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	eurosat? (
		dev-python/imagecodecs[${PYTHON_USEDEP}]
		dev-python/scikit-image[${PYTHON_USEDEP}]
		dev-python/tifffile[${PYTHON_USEDEP}]
	)
	groove? (
		dev-python/pretty_midi[${PYTHON_USEDEP}]
		dev-python/pydub[${PYTHON_USEDEP}]
	)
	gtzan? (
		dev-python/pydub[${PYTHON_USEDEP}]
	)
	huggingface? (
		${HUGGINGFACE_RDEPEND}
	)
	librispeech? (
		dev-python/pydub[${PYTHON_USEDEP}]
	)
	imagenet2012_corrupted? (
		dev-python/scikit-image[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},python]
	)
	locomotion? (
		$(python_gen_cond_dep '
			dev-python/envlogger[${PYTHON_USEDEP}]
		' python3_10)
	)
	lsun? (
		sci-ml/tensorflow-io[${PYTHON_USEDEP}]
	)
	matplotlib? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
	nsynth? (
		>=dev-python/scikit-learn-0.20.3[${PYTHON_USEDEP}]
		dev-python/crepe[${PYTHON_USEDEP}]
		dev-python/librosa[${PYTHON_USEDEP}]
	)
	ogbg_molpcba? (
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
	pet_finder? (
		dev-python/pandas[${PYTHON_USEDEP}]
	)
	qm9? (
		dev-python/pandas[${PYTHON_USEDEP}]
	)
	robonet? (
		dev-python/h5py[${PYTHON_USEDEP}]
	)
	robosuite_panda_pick_place_can? (
		$(python_gen_cond_dep '
			dev-python/envlogger[${PYTHON_USEDEP}]
		' python3_10)
	)
	smartwatch_gestures? (
		dev-python/pandas[${PYTHON_USEDEP}]
	)
	svhn? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	tensorflow? (
		sci-ml/tensorflow[${PYTHON_USEDEP}]
	)
	tensorflow-data-validation? (
		sci-ml/tensorflow-data-validation[${PYTHON_USEDEP}]
	)
	the300w_lp? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	wider_face? (
		virtual/pillow[${PYTHON_USEDEP}]
	)
	wiki_dialog? (
		dev-db/apache-beam[${PYTHON_USEDEP}]
	)
	wikipedia? (
		dev-db/apache-beam[${PYTHON_USEDEP}]
		dev-python/mwparserfromhell[${PYTHON_USEDEP}]
		dev-python/mwxml[${PYTHON_USEDEP}]
	)
	wsc273? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
	youtube_vis? (
		dev-python/pycocotools[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			sci-ml/tensorflow-io[${PYTHON_USEDEP}]
		' python3_{10,11})
		dev-db/apache-beam[${PYTHON_USEDEP}]
		dev-python/conllu[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-shard[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pydub[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/jax[${PYTHON_USEDEP},cpu]

		>=dev-python/pylint-2.6.0[${PYTHON_USEDEP}]
		dev-python/yapf[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS" "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "_MAJOR_VERSION = '4'" "${S}/tensorflow_datasets/version.py" || die "QA:  Bump version"
		grep -q -e "_MINOR_VERSION = '9'" "${S}/tensorflow_datasets/version.py" || die "QA:  Bump version"
		grep -q -e "_PATCH_VERSION = '6'" "${S}/tensorflow_datasets/version.py" || die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
