# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="tensorboardX"

inherit protobuf-ver

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_SLOTS_REL=(
	${PROTOBUF_SLOTS[@]}
)
PROTOBUF_SLOTS_DEV=(
	${PROTOBUF_4_SLOTS[@]}
	${PROTOBUF_5_SLOTS[@]}
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lanpa/tensorboardX.git"
	FALLBACK_COMMIT="d4386c1a917fdc7f0f23ecee2bea0abfe5d7bec6" # Aug 20, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/lanpa/tensorboardX/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="TensorBoardX lets you watch tensors flow without TensorFlow"
HOMEPAGE="
	https://github.com/lanpa/tensorboardX
	https://pypi.org/project/tensorboardX
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
gen_protobuf_rdepends() {
	local s
	for s in ${PROTOBUF_SLOTS_REL[@]} ; do
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo "
				python_single_target_${impl}? (
					dev-python/protobuf:0/${s}[python_targets_${impl}(-)]
				)
			"
		done
	done
}
gen_protobuf_bdepends() {
	local s
	for s in ${PROTOBUF_SLOTS_DEV[@]} ; do
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo "
				python_single_target_${impl}? (
					dev-python/protobuf:0/${s}[python_targets_${impl}(-)]
				)
			"
		done
	done
}
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	')
	|| (
		$(gen_protobuf_rdepends)
	)
	dev-python/protobuf:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		doc? (
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/imageio-2.27[${PYTHON_USEDEP}]
			dev-python/boto3[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/tensorboard[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/moto[${PYTHON_USEDEP}]
			dev-python/onnx[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]
			dev-python/visdom[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
		|| (
			$(gen_protobuf_bdepends)
		)
		dev-python/protobuf:=
	)
"
DOCS=( "HISTORY.rst" "README.md" )

# For dev-python/setuptools-scm
init_repo() {
	git init || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		cd "${S}" || die
		init_repo
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
