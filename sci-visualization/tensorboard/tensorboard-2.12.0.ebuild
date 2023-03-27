# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-r1

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="
https://www.tensorflow.org/
https://github.com/tensorflow/tensorboard
"
SRC_URI="
https://github.com/tensorflow/tensorboard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
#https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P}-py3-none-any.whl

LICENSE="
	all-rights-reserved
	Apache-2.0
" # The distro Apache-2.0 template doesn't have all-rights-reserved
SLOT="0"
#KEYWORDS="~amd64" # Missing dependencies
IUSE+=" test testing-tensorflow"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# See https://github.com/tensorflow/tensorboard/blob/2.12.0/tensorboard/pip_package/requirements.txt
# Not used:
#	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
# TODO: create packages:
# tensorboard-data-server
DISABLED_DEPEND="
	(
		<sci-visualization/tensorboard-data-server-0.8.0
		>=sci-visualization/tensorboard-data-server-0.7.0
	)
"
RDEPEND="
	${PYTHON_DEPS}
	(
		<dev-python/google-auth-3[${PYTHON_USEDEP}]
		>=dev-python/google-auth-1.6.3[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/google-auth-oauthlib-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/google-auth-oauthlib-0.5[${PYTHON_USEDEP}]
	)
	(
		<dev-python/requests-2.21.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
	)
	>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1.48.2[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.6.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.6[${PYTHON_USEDEP}]
	>=dev-python/tensorboard-plugin-wit-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-1.0.1[${PYTHON_USEDEP}]

	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]

	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.26[${PYTHON_USEDEP}]
	>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
	>=dev-python/flake8-3.7.8[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.31[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.17.0[${PYTHON_USEDEP}]
	app-arch/unzip
	test? (
		>=dev-python/boto3-1.9.86[${PYTHON_USEDEP}]
		>=dev-python/fsspec-0.7.4[${PYTHON_USEDEP}]
		>=dev-python/grpcio-testing-1.24.3[${PYTHON_USEDEP}]
		>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.0[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	sci-libs/tensorflow[${PYTHON_USEDEP},python]
"

S="${WORKDIR}/${P}"

# Those prefixed with pypi_ are for the pypi tarball
pypi_src_prepare() {
	eapply_user

	sed -i -e '/_vendor.__init__/d' -e '/_vendor.bleach/d' -e '/_vendor.html5lib/d' -e '/_vendor.webencodings/d' \
		"${S}/${P}.dist-info/RECORD" || die "failed to unvendor"
	grep -q "_vendor" "${S}/${P}.dist-info/RECORD" && die "More vendored deps found"

	find "${S}/${PN}" -name '*.py' -exec sed -i \
		-e 's/^from tensorboard\._vendor import /import /' \
		-e 's/^from tensorboard\._vendor\./from /' \
		{} + || die "failed to unvendor"

	rm -rf "${S}/${PN}/_vendor" || die

	sed -i -e '/tensorboard-plugin-/d' "${S}/${P}.dist-info/METADATA" || die "failed to remove plugin deps"
	sed -i -e '/tensorboard-data-server/d' "${S}/${P}.dist-info/METADATA" || die "failed to remove data-server deps"
	sed -i -e 's/google-auth-oauthlib.*$/google-auth-oauthlib/' "${S}/${P}.dist-info/METADATA" \
		|| die "failed to relax oauth deps"
	sed -i -e 's/protobuf.*$/protobuf/' "${S}/${P}.dist-info/METADATA" \
		|| die "failed to relax protobuf deps"
}

pypi_src_install() {
	do_install() {
		python_domodule "${PN}"
		python_domodule "${P}.dist-info"
	}
	python_foreach_impl do_install
}
