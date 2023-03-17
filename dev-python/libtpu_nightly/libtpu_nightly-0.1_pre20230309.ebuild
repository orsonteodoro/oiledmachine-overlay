# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="libtpu-nightly"
MY_PV="${PV/_pre/.dev}"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A small example package"
HOMEPAGE="
https://pypi.org/project/libtpu-nightly
https://github.com/pypa/sampleproject
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
"
# See also
# https://storage.googleapis.com/jax-releases/libtpu_releases.html
SRC_URI="
https://storage.googleapis.com/cloud-tpu-tpuvm-artifacts/wheels/libtpu-nightly/libtpu_nightly-${MY_PV}-py3-none-any.whl
"
S="${WORKDIR}/libtpu-${PV}"
RESTRICT="mirror"
DOCS=( README.md )

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/libtpu_nightly-${MY_PV}-py3-none-any.whl"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
