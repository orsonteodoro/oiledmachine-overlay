# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cross platform GUI framework for desktop and mobile applications in .NET"
HOMEPAGE="https://github.com/mono/xwt"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug developer +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
EGIT_COMMIT="cd710a42a895b05337047079b0ba16d081dd87ed"
inherit dotnet eutils mono
SRC_URI="https://github.com/mono/xwt/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
inherit gac
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	epatch "${FILESDIR}/${PN}-9999.20171206-linux-only-projects.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-val-never-used.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-suppress-value-assigned-never-used.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-disable-tests.patch"
}

src_compile() {
	cd "${S}/Source"
        exbuild /p:Configuration=$(usex debug "Debug" "Release") ${STRONG_ARGS_NETFX}"${S}/xwt.snk" 'Xwt.sln' || die
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Xwt.Gtk/bin/${mydebug}/Xwt.Gtk3.dll"
                egacinstall "${S}/Xwt.Gtk/bin/${mydebug}/Xwt.dll"
                egacinstall "${S}/Xwt.Gtk/bin/${mydebug}/Xwt.Gtk3.dll"
        done

	eend

	dotnet_multilib_comply
}

