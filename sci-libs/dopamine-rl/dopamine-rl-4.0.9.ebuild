# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Up to 3.8 listed

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/dopamine.git"
	FALLBACK_COMMIT="4552f69af4763053d87ee4ce6d3da59ca3232f3c" # May 6, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="4552f69af4763053d87ee4ce6d3da59ca3232f3c" # May 6, 2024
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/dopamine-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/google/dopamine/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Dopamine is a research framework for fast prototyping of \
reinforcement learning algorithms. "
HOMEPAGE="
	https://github.com/google/dopamine
	https://pypi.org/project/dopamine-rl
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" +keras2"
REQUIREMENTS_RDEPEND="
	<dev-python/gym-0.25.3[${PYTHON_USEDEP},atari,accept-rom-license]
	>=dev-python/absl-py-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/astunparse-1.6.3[${PYTHON_USEDEP}]
	>=dev-python/cachetools-4.1.1[${PYTHON_USEDEP}]
	>=dev-python/certifi-2020.6.20[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/cycler-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/flax-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/future-0.18.2[${PYTHON_USEDEP}]
	>=dev-python/gast-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/gin-config-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.19.2[${PYTHON_USEDEP}]
	>=dev-python/google-auth-oauthlib-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/google-pasta-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1.30.0[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.10[${PYTHON_USEDEP}]
	>=dev-python/jax-0.3.16[${PYTHON_USEDEP}]
	>=dev-python/jaxlib-0.3.15[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.5[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/opt-einsum-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.0.5[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.12.2[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.2.8[${PYTHON_USEDEP}]
	>=dev-python/pygame-1.9.6[${PYTHON_USEDEP}]
	>=dev-python/pyglet-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/rsa-4.6[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools-49.2.01[${PYTHON_USEDEP}]
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.10[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.12.1[${PYTHON_USEDEP}]
	>=media-libs/opencv-4.3.0.36[${PYTHON_USEDEP}]
	>=sci-libs/tensorflow-probability-0.13.0[${PYTHON_USEDEP}]
	>=sci-libs/tf_slim-1.1.0[${PYTHON_USEDEP}]
	sci-libs/tensorflow-estimator[${PYTHON_USEDEP}]
	sci-libs/tensorflow[${PYTHON_USEDEP}]
	sci-visualization/tensorboard[${PYTHON_USEDEP}]
	sci-visualization/tensorboard-plugin-wit[${PYTHON_USEDEP}]
	keras2? (
		<sci-libs/tensorflow-2.16[${PYTHON_USEDEP}]
		=sci-libs/keras-2*
		>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${REQUIREMENTS_RDEPEND}
	<dev-python/gym-0.25.3[${PYTHON_USEDEP}]
	>=dev-python/absl-py-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/gin-config-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/flax-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/jax-0.1.72[${PYTHON_USEDEP}]
	>=dev-python/jaxlib-0.1.51[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.4[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.24.2[${PYTHON_USEDEP}]
	>=dev-python/pygame-1.9.2[${PYTHON_USEDEP}]
	>=dev-python/tensorflow-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/tensorflow-probability-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/tf_slim-1.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
	>=media-libs/opencv-3.4.8.29[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "AUTHORS" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version='4.0.9'," "${S}/setup.py" \
			|| die "QA:  Bump version"
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
