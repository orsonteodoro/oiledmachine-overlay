# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenCL-Benchmark"

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/ProjectPhysX/OpenCL-Benchmark/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A small OpenCL benchmark program to measure peak GPU/CPU performance."
HOMEPAGE="https://github.com/ProjectPhysX/OpenCL-Benchmark"
LICENSE="ZLIB"
SLOT="0"
IUSE="ebuild_revision_1"
RDEPEND="
	virtual/opencl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
DOCS=( "CITATION.cff" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.3-disable-eager-test.patch"
)

src_configure() {
	:
}

src_compile() {
	"./make.sh"
}

src_install() {
	dobin "bin/${MY_PN}"
	docinto "licenses"
	dodoc "LICENSE.md"
}
