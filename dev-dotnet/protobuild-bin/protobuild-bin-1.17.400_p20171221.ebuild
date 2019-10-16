# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Protobuild is a Cross-platform project generation for C#"
HOMEPAGE="https://protobuild.org/"
LICENSE="MIT Apache-2.0 BSD"
KEYWORDS="~amd64 ~x86"
RDEPEND="dev-lang/mono"
inherit eutils
EGIT_COMMIT="f73848e43ee441c5db2670ce776a3be421815475"
SRC_URI=\
"https://github.com/Protobuild/Protobuild/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
MY_PN="Protobuild"
SLOT="0/${PV}"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

src_install() {
	exeinto /opt/${MY_PN}/bin
	doexe ${MY_PN}.exe
	exeinto /usr/bin
	doexe "${FILESDIR}/Protobuild"
	cp -a ThirdParty/FastJSON/{,FASTJSON_}LICENSE.txt
	cp -a ThirdParty/TAR/{,TAR_}LICENSE.txt
	dodoc LICENSE.md README.md \
		ThirdParty/FastJSON/FASTJSON_LICENSE.txt \
		ThirdParty/TAR/TAR_LICENSE.txt
}
