# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

KNOWHERE_PV="2.3.1"
MILVUS_COMMIT="15b78749a6fdc5258bf3d3824ea13477bc7c1f76"
MILVUS_PROTO_COMMIT="fb716450bed2ccac4dec2ab731ca888d39be8826"
MILVUS_STORAGE_COMMIT="9d1ad9c4359fb287fc3f1f0893bd314c8c45760a"
SIMDJSON_PV="3.1.7"

inherit dep-prepare distutils-r1 edo pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/milvus-io/milvus-lite.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	S_PROJ="${WORKDIR}/${P}"
	S_PYTHON="${WORKDIR}/${P}/python"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	S_PROJ="${WORKDIR}/${PN}-${PV}"
	S_PYTHON="${WORKDIR}/${PN}-${PV}/python"
	SRC_URI="
https://github.com/milvus-io/milvus-lite/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/milvus-io/milvus/archive/${MILVUS_COMMIT}.tar.gz
	-> milvus-${MILVUS_COMMIT:0:7}.tar.gz
https://github.com/milvus-io/milvus-proto/archive/${MILVUS_PROTO_COMMIT}.tar.gz
	-> milvus-proto-${MILVUS_PROTO_COMMIT:0:7}.tar.gz
https://github.com/milvus-io/milvus-storage/archive/${MILVUS_STORAGE_COMMIT}.tar.gz
	-> milvus-storage-${MILVUS_STORAGE_COMMIT:0:7}.tar.gz
https://github.com/zilliztech/knowhere/archive/refs/tags/v${KNOWHERE_PV}.tar.gz
	-> knowhere-${KNOWHERE_PV}.tar.gz
https://github.com/simdjson/simdjson/archive/refs/tags/v${SIMDJSON_PV}.tar.gz
	-> simdjson-${SIMDJSON_PV}.tar.gz
	"
fi

DESCRIPTION="A lightweight version of Milvus"
HOMEPAGE="
	https://github.com/milvus-io/milvus-lite
	https://pypi.org/project/milvus-lite
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
# Both grpc and opentelemetry-cpp are limited to avoid:
# !!! Multiple package instances within a single package slot have been pulled
# !!! into the dependency graph, resulting in a slot conflict:
RDEPEND+="
	(
		>=dev-libs/boost-1.82.0
		dev-libs/boost:=
	)
	(
		>=dev-cpp/opentelemetry-cpp-1.8.1.1[jaeger,otlp-grpc,otlp-http]
		<dev-cpp/opentelemetry-cpp-1.10.0[jaeger,otlp-grpc,otlp-http]
	)
	<net-libs/grpc-1.55
	>=dev-cpp/antlr4-4.13.1
	>=dev-cpp/folly-2023.10.30.09
	>=dev-cpp/glog-0.6.0
	>=dev-cpp/nlohmann_json-3.11.2
	>=dev-cpp/prometheus-cpp-1.1.0
	>=dev-cpp/sqlitecpp-3.3.1
	>=dev-cpp/tbb-2021.9.0:0
	>=dev-cpp/yaml-cpp-0.7.0
	>=dev-libs/apache-arrow-12.0.1
	>=dev-libs/double-conversion-3.2.1
	>=dev-libs/libfmt-9.1.0
	>=dev-libs/marisa-0.2.6
	>=dev-libs/re2-0.2023.03.01:0/10
	>=dev-libs/simdjson-3.1.7
	dev-cpp/gflags
	dev-libs/protobuf:0/3.21
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-64.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-vcs/git
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
		grep -q -e "version = \"1.8.2\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		gen_git_tag "${S}" "v${PV}"
	fi
}

src_prepare() {
	dep_prepare_mv "${WORKDIR}/milvus-${MILVUS_COMMIT}" "${S}/thirdparty/milvus"
	dep_prepare_mv "${WORKDIR}/milvus-proto-${MILVUS_PROTO_COMMIT}" "${S}/thirdparty/milvus-proto"
	dep_prepare_mv "${WORKDIR}/milvus-storage-${MILVUS_STORAGE_COMMIT}" "${S}/thirdparty/milvus-storage"
	dep_prepare_mv "${WORKDIR}/knowhere-${KNOWHERE_PV}" "${S}/thirdparty/knowhere"
	dep_prepare_mv "${WORKDIR}/simdjson-${SIMDJSON_PV}" "${S}/thirdparty/simdjson"

	default
	eapply "${FILESDIR}/${PN}-2.4.11-conan2.patch"
	eapply "${FILESDIR}/${PN}-2.4.11-conan-changes.patch"
	eapply "${FILESDIR}/${PN}-2.4.11-package-checks.patch"
	eapply "${FILESDIR}/${PN}-2.4.11-offline-simdjson.patch"
	eapply "${FILESDIR}/${PN}-2.4.11-offline-knowhere.patch"
	eapply "${FILESDIR}/${PN}-2.4.11-knowhere.patch"
	export S="${S_PYTHON}"
	cd "${S_PYTHON}" || die
	distutils-r1_src_prepare
}

src_compile() {
	export OFFLINE=1
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
