# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="tensorboardX"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit abseil-cpp distutils-r1 protobuf pypi

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
	local impl
	for impl in "${PYTHON_COMPAT[@]}" ; do
		echo "
			python_single_target_${impl}? (
				|| (
					dev-python/protobuf:4.21[python_targets_${impl}(-)]
					dev-python/protobuf:5.29[python_targets_${impl}(-)]
				)
			)
		"
	done
}
gen_protobuf_bdepends() {
	local impl
	for impl in "${PYTHON_COMPAT[@]}" ; do
		echo "
			python_single_target_${impl}? (
				|| (
					dev-python/protobuf:4.21[python_targets_${impl}(-)]
					dev-python/protobuf:5.29[python_targets_${impl}(-)]
				)
			)
		"
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
	touch "dummy" || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add "dummy" || die
	git commit -m "Dummy" || die
	git tag "v${PV}" || die
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

python_configure() {
	if has_version "dev-libs/protobuf:5/5.29" ; then
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:3/3.21" ; then
	# Align with TensorFlow 2.17
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	else
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
