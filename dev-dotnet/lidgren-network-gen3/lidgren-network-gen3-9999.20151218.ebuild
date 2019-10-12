# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Lidgren Network Library"
HOMEPAGE="https://github.com/lidgren/lidgren-network-gen3"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils git-r3 mono
SRC_URI=""
inherit gac
RESTRICT="fetch"
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
	exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" Lidgren.Network.sln
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

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
