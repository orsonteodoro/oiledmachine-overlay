# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# fastembed
# fastembed-gpu
# qdrant-sphinx-theme

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit abseil-cpp distutils-r1 grpc protobuf pypi re2

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/qdrant/qdrant-client.git"
	FALLBACK_COMMIT="64311d3a19b644647f73f2ac143902f4203a3d77" # Jan 22, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/qdrant/qdrant-client/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Python client for Qdrant vector search engine"
HOMEPAGE="
	https://github.com/qdrant/qdrant-client
	https://pypi.org/project/qdrant-client
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev doc fastembed fastembed-gpu test types
ebuild_revision_1
"
REQUIRED_USE="
	test? (
		dev
	)
"
gen_grpcio_rdepend() {
	echo "
		(
			dev-python/grpcio:3/1.30[${PYTHON_USEDEP}]
			dev-python/grpcio-tools:3/1.30[${PYTHON_USEDEP}]
		)
		(
			dev-python/grpcio:3/1.51[${PYTHON_USEDEP}]
			dev-python/grpcio-tools:3/1.51[${PYTHON_USEDEP}]
		)
		(
			dev-python/grpcio:4/1.62[${PYTHON_USEDEP}]
			dev-python/grpcio-tools:4/1.62[${PYTHON_USEDEP}]
		)
		(
			dev-python/grpcio:5/1.71[${PYTHON_USEDEP}]
			dev-python/grpcio-tools:5/1.71[${PYTHON_USEDEP}]
		)
		(
			dev-python/grpcio:6/1.75[${PYTHON_USEDEP}]
			dev-python/grpcio-tools:6/1.75[${PYTHON_USEDEP}]
		)
	"
}
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.21[${PYTHON_USEDEP}]
	' python3_{10,11})
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.26[${PYTHON_USEDEP}]
	' python3_12)
	$(python_gen_cond_dep '
		>=dev-python/numpy-2.1.0[${PYTHON_USEDEP}]
	' python3_13)
	>=dev-python/httpx-0.20.0[http2(+)]
	>=dev-python/pydantic-1.10.8[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.14[${PYTHON_USEDEP}]
	>=dev-python/portalocker-2.7.0[${PYTHON_USEDEP}]
	fastembed? (
		>=dev-python/fastembed-0.5.1[${PYTHON_USEDEP}]
	)
	fastembed-gpu? (
		>=dev-python/fastembed-gpu-0.5.1[${PYTHON_USEDEP}]
	)
	|| (
		$(gen_grpcio_rdepend)
	)
	dev-python/grpcio:=
	dev-python/grpcio-tools:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/autoflake-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.3.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.4.3
	)
	doc? (
		>=dev-python/nbsphinx-0.9.3[${PYTHON_USEDEP}]
		>=dev-python/ipython-8[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.16.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.0.0[${PYTHON_USEDEP}]
		dev-python/qdrant-sphinx-theme[${PYTHON_USEDEP}]
	)
	types? (
		>=dev-python/mypy-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyright-1.1.293[${PYTHON_USEDEP}]
		>=dev-python/types-protobuf-4.21.0.5[${PYTHON_USEDEP}]
	)

"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_configure() {
	if has_version "dev-libs/protobuf:6/6.33" ; then
		ABSEIL_CPP_SLOT="20250512"
		GRPC_SLOT="6"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
		RE2_SLOT="20250512"
	elif has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		GRPC_SLOT="5"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
		RE2_SLOT="20250512"
	elif has_version "dev-libs/protobuf:4/4.25" ; then
		ABSEIL_CPP_SLOT="20240116"
		GRPC_SLOT="4"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
		RE2_SLOT="20220623"
	elif has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
		RE2_SLOT="20220623"
	elif has_version "dev-libs/protobuf:3/3.12" ; then
		ABSEIL_CPP_SLOT="20200225"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
		RE2_SLOT="20220623"
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
	re2_python_configure
	grpc_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
