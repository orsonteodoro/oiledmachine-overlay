# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="weaviate-python-client"

# TODO package:
# pytest-profiling
# types-urllib3

DISTUTILS_USE_PEP517="setuptools"
GRPC_SLOTS=(
	"1.57"
	"1.58"
	"1.59"
	"1.60"
	"1.61"
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
	# < 2.0
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/weaviate/weaviate-python-client.git"
	FALLBACK_COMMIT="3a37407ed2fd00b526e37bbf9374d170fe4a34d8" # Aug 15, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/weaviate/weaviate-python-client/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A python native client for easy interaction with a Weaviate instance"
HOMEPAGE="
	https://github.com/weaviate/weaviate-python-client
	https://pypi.org/project/weaviate-client
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev grpc"
REQUIRED_USE="
	dev? (
		grpc
	)
"
gen_grpcio_rdepend() {
	local s
	for s in ${GRPC_SLOTS[@]} ; do
		echo "
			=dev-python/grpcio-${s}*[${PYTHON_USEDEP}]
			=dev-python/grpcio-tools-${s}*[${PYTHON_USEDEP}]
		"
	done
}
RDEPEND+="
	>=dev-python/Authlib-1.3.1
	>=dev-python/requests-2.32.2
	>=dev-python/validators-0.21.2
	grpc? (
		|| (
			$(gen_grpcio_rdepend)
		)
		dev-python/grpcio:=
		dev-python/grpcio-tools:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-65[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.38.1[${PYTHON_USEDEP}]
	>dev-python/setuptools-scm-6.2[${PYTHON_USEDEP},toml(+)]
	dev? (
		>=dev-python/requests-2.32.2[${PYTHON_USEDEP}]
		>=dev-python/validators-0.21.2[${PYTHON_USEDEP}]
		>=dev-python/Authlib-1.3.1[${PYTHON_USEDEP}]

		dev-python/build[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.0.0[${PYTHON_USEDEP}]

		>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-profiling-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.4.1[${PYTHON_USEDEP}]
		>=dev-python/werkzeug-2.3.7[${PYTHON_USEDEP}]
		>=dev-python/pytest-httpserver-1.0.8[${PYTHON_USEDEP}]

		>=dev-python/mypy-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/mypy-extensions-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/types-protobuf-4.24.0.1[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.31.0.2[${PYTHON_USEDEP}]
		>=dev-python/types-urllib3-1.26.25.14[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.7.1[${PYTHON_USEDEP}]

		dev-vcs/pre-commit[${PYTHON_USEDEP}]

		dev-python/flake8[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-24.1.17[${PYTHON_USEDEP}]
		>=dev-python/flake8-comprehensions-3.14.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-builtins-2.2.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		gen_git_tag "${S}" "v${PV}"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
