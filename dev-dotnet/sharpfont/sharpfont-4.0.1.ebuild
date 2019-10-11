# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cross-platform FreeType bindings for .NET"
HOMEPAGE="https://github.com/Robmaister/SharpFont"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
SLOT="0"
inherit dotnet eutils mono
SRC_URI="https://github.com/Robmaister/SharpFont/archive/v${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/SharpFont-${PV}"

src_compile() {
	cd "${S}/Source/SharpFont"
	exbuild_raw SharpFont.csproj /p:Configuration=$(usex debug "Debug" "Release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins Source/SharpFont/SharpFont.snk
	fi

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Binaries/SharpFont/${mydebug}/SharpFont.dll"
		insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/Binaries/SharpFont/${mydebug}/SharpFont.dll.mdb"
        done

	eend

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins Binaries/SharpFont/${mydebug}/SharpFont.dll.config

	cd "${S}"
	dodoc README.md "LICENSE"

	dotnet_multilib_comply
}
