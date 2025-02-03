# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# SECURITY:  Check conan dependencies twice a month (1st/30th and 10th of the month)

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

MILVUS_COMMIT="15b78749a6fdc5258bf3d3824ea13477bc7c1f76"
MILVUS_PROTO_COMMIT="fb716450bed2ccac4dec2ab731ca888d39be8826"
MILVUS_STORAGE_COMMIT="c23ba736d7e6dcd21f7e6288525f706746329e8e"

inherit dep-prepare distutils-r1 pypi

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
RDEPEND+="
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-64.0[${PYTHON_USEDEP}]
	>=dev-util/conan-2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

check_network_sandbox_permissions() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download dependencies."
eerror
		die
	fi
}

pkg_setup() {
ewarn "The package manager may randomly delete tags."
ewarn "Report unresolved dependencies (or missing tagged versions) to repo."
	check_network_sandbox_permissions
}

_conan_setup_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export CONAN_SLOT="2" # Version 2
	if [[ -z "${CONAN_CACHE_FOLDER}" ]] ; then
		export CONAN_CACHE_FOLDER="${EDISTDIR}/conan-download-cache-${CONAN_SLOT}/${CATEGORY}/${P}"
	fi
einfo "DEBUG:  Default cache folder:  ${HOME}/.conan2"
einfo "CONAN_CACHE_FOLDER:  ${CONAN_CACHE_FOLDER}"
	ln -sf "${CONAN_CACHE_FOLDER}" "${HOME}/.conan2"
	addwrite "${EDISTDIR}"
	addwrite "${CONAN_CACHE_FOLDER}"
	mkdir -p "${CONAN_CACHE_FOLDER}"
}

src_unpack() {
	_conan_setup_offline_cache
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"1.8.2\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_prepare() {
	dep_prepare_mv "${WORKDIR}/milvus-${MILVUS_COMMIT}" "${S}/thirdparty/milvus"
	dep_prepare_mv "${WORKDIR}/milvus-proto-${MILVUS_PROTO_COMMIT}" "${S}/thirdparty/milvus-proto"
	dep_prepare_mv "${WORKDIR}/milvus-storage-${MILVUS_STORAGE_COMMIT}" "${S}/thirdparty/milvus-storage"

	default
	eapply "${FILESDIR}/${PN}-2.4.11-conan2.patch"
	export S="${S_PYTHON}"
	cd "${S_PYTHON}" || die
	distutils-r1_src_prepare
}

src_compile() {
	conan profile detect || die
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
