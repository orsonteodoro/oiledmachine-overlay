# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="io"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Dataset, streaming, and file system extensions maintained by \
TensorFlow SIG-IO"
HOMEPAGE="
https://github.com/tensorflow/io
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc tensorflow-io-gcs-filesystem test"
#IUSE+=" aarch64 doc cpu gpu rocm tensorflow-io-gcs-filesystem test"
DISABLED_DEPEND="
	aarch64? (
		/tensorflow-aarch64[${PYTHON_USEDEP}]
	)
	cpu? (
		/tensorflow-cpu[${PYTHON_USEDEP}]
	)
	gpu? (
		/tensorflow-gpu[${PYTHON_USEDEP}]
	)
	rocm? (
		/tensorflow-rocm[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	=sci-libs/tensorflow-2.11*[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-util/bazel
"
SRC_URI="
https://github.com/tensorflow/io/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror test"
DOCS=( README.md RELEASE.md )
HTML_DOCS=( docs )

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
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
