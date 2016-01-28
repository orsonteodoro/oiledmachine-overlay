# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3 mono

DESCRIPTION="lidgren-network-gen3"
HOMEPAGE="https://github.com/lidgren/lidgren-network-gen3"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

FEATURES="nofetch"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/lidgren/lidgren-network-gen3.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="8c7b5fb7754af3a283040e56656762f73b0a943e"
        git-r3_fetch
        git-r3_checkout

}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	xbuild Lidgren.Network.sln /p:Configuration=${mydebug}
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	cd "${S}"
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	strong_sign "${S}/${PN}-keypair.snk" "${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll"
        gacutil -i "${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll" -root "${D}/usr/$(get_libdir)" \
                -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"
	monodocer -assembly:"${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll" -path:en -pretty

	mkdir -p "${D}"$(dirname /usr/lib64/mono/gac/Lidgren.Network/*/Lidgren.Network.dll)
	cp *.xml "${D}"$(dirname /usr/lib64/mono/gac/Lidgren.Network/*/Lidgren.Network.dll)
	die
	eend

	dodoc README.md "LICENSE"

        mono_multilib_comply
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" || die "ilasm failed"
	popd
}
