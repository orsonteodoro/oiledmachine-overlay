# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils git-r3 mono gac

DESCRIPTION="lidgren-network-gen3"
HOMEPAGE="https://github.com/lidgren/lidgren-network-gen3"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/lidgren/lidgren-network-gen3.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="8c7b5fb7754af3a283040e56656762f73b0a943e"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	exbuild_strong Lidgren.Network.sln
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	esavekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll.mdb
        done

	monodocer -assembly:"${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll" -path:en -pretty

	#mkdir -p "${D}"$(dirname /usr/lib64/mono/gac/Lidgren.Network/*/Lidgren.Network.dll)
	#cp *.xml "${D}"$(dirname /usr/lib64/mono/gac/Lidgren.Network/*/Lidgren.Network.dll)
	#die
	eend

	dodoc README.md "LICENSE"

        mono_multilib_comply
}
