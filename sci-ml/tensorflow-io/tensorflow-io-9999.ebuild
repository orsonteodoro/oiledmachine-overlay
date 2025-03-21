# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="io" # TensorFlow I/O

BAZEL_PV="6.5.0"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/tensorflow/io.git"
	EGIT_BRANCH="master"
	FALLBACK_COMMIT="9b82afb442d69f9bd14b079be109082967afaf09" # Apr 23, 2024
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/tensorflow/io/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Dataset, streaming, and file system extensions maintained by \
TensorFlow SIG-IO"
HOMEPAGE="
https://github.com/tensorflow/io
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc tensorflow-io-gcs-filesystem test"
# See https://github.com/tensorflow/io/blob/master/README.md#tensorflow-version-compatibility
RDEPEND+="
	>=sci-ml/tensorflow-2.15[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
"
DOCS=( "README.md" "RELEASE.md" )
HTML_DOCS=( "docs" )

src_unpack() {
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"

	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_compile() {
	distutils-r1_python_compile
	if use tensorflow-io-gcs-filesystem ; then
		${EPYTHON} setup.py \
			-q bdist_wheel \
			$(usex tensorflow-io-gcs-filesystem "--project tensorflow_io_gcs_filesystem" "") \
			|| die
		local pypv="${EPYTHON}"
		pypv="${pypv/./}"
		pypv="${pypv/python/}"
		local wheel_path=$(realpath "dist/tensorflow_io_gcs_filesystem-${PV}-cp${pypv}-cp${pypv}-"*".whl")
		einfo "wheel_path=${wheel_path}"
		distutils_wheel_install "${BUILD_DIR}/install" \
			"${wheel_path}"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
