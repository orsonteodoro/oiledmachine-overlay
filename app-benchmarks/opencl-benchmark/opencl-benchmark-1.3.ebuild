# Copyright 2012-2024 Gentoo Authors
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
IUSE=""
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
	addpredict "/dev/dri/card0"
}

src_compile() {
	"./make.sh"
}

src_install() {
	dobin "bin/${MY_PN}"
	docinto "/usr/share/${PN}/licenses"
	doins "LICENSE.md"
}
