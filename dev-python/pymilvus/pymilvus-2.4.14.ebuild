# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# m2r
# sphinxcontrib-prettyspecialmethods

inherit grpc-ver

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_SLOTS_REL=(
	${GRPC_SLOTS[@]}
)
GRPC_SLOTS_DEV=(
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/milvus-io/pymilvus.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/milvus-io/pymilvus/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python SDK for Milvus"
HOMEPAGE="
	https://github.com/milvus-io/pymilvus
	https://pypi.org/project/pymilvus
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" bulk_writer dev model"
gen_grpcio_dev() {
	local s
	for s in ${GRPC_SLOTS_DEV[@]} ; do
		echo "
			(
				$(python_gen_cond_dep '
					=dev-python/grpcio-'${s}'*[${PYTHON_USEDEP}]
					=dev-python/grpcio-testing-'${s}'*[${PYTHON_USEDEP}]
					=dev-python/grpcio-tools-'${s}'*[${PYTHON_USEDEP}]
				')
			)
		"
	done
}
gen_grpcio_rel() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS_REL[@]} ; do
		s2=$(grpc_get_protobuf_slot "${s1}")
		echo "
			(
				$(python_gen_cond_dep '
					=dev-python/grpcio-'${s1}'*[${PYTHON_USEDEP}]
					dev-python/protobuf:0/'${s2}'[${PYTHON_USEDEP}]
				')
			)
		"
	done
}
RDEPEND+="
	$(python_gen_cond_dep '
		=dev-python/milvus-lite-bin-2.4*[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.2.4[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/ujson-2.0.0[${PYTHON_USEDEP}]
		>dev-python/setuptools-69[${PYTHON_USEDEP}]
		bulk_writer? (
			>=dev-python/minio-7.0.0[${PYTHON_USEDEP}]
			>=dev-python/pyarrow-12.0.0[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/azure-storage-blob[${PYTHON_USEDEP}]
		)
		dev-python/grpcio:=
		dev-python/protobuf:=
	')
	|| (
		$(gen_grpcio_rel)
	)
	model? (
		>=dev-python/milvus-model-0.1.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
REQUIREMENTS_PKGS="
	$(python_gen_cond_dep '
		>=dev-python/build-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/certifi-2024.7.4[${PYTHON_USEDEP}]
		>=dev-python/chardet-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/idna-2.10[${PYTHON_USEDEP}]
		>=dev-python/m2r-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/milvus-lite-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.1.5[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.9[${PYTHON_USEDEP}]
		>=dev-python/pep517-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/protobuf-4.25.2[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		>=dev-python/pyarrow-12.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.3.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.8.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.3.4[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.65.0[${PYTHON_USEDEP}]
		>=dev-python/ujson-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.19[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.2.0
		dev-python/azure-storage-blob[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/minio[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-applehelp[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-devhelp[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-htmlhelp[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-jsmath[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-napoleon[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-prettyspecialmethods[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-qthelp[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-serializinghtml[${PYTHON_USEDEP}]
		dev-python/grpcio:=
		dev-python/grpcio-testing:=
		dev-python/grpcio-tools:=
	')
	|| (
		$(gen_grpcio_dev)
	)
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-67[${PYTHON_USEDEP}]
		>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP},toml(+)]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/pytest-5.3.4[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-2.8.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-1.3.4[${PYTHON_USEDEP}]
			>dev-util/ruff-0.4.0
			dev-python/black[${PYTHON_USEDEP}]
		)
	')
	dev? (
		${REQUIREMENTS_PKGS}
		|| (
			$(gen_grpcio_dev)
		)
	)
"
DOCS=( "README.md" )

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
