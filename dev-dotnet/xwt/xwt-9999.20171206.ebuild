# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Cross platform GUI framework for desktop and mobile applications in .NET"
HOMEPAGE=""
COMMIT="cd710a42a895b05337047079b0ba16d081dd87ed"
SRC_URI="https://github.com/mono/xwt/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
        "
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PN}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	epatch "${FILESDIR}/${PN}-9999.20171206-linux-only-projects.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-val-never-used.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-suppress-value-assigned-never-used.patch"
	epatch "${FILESDIR}/${PN}-9999.20171206-disable-tests.patch"

	egenkey

	eapply_user
}

src_configure() {
	default
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/Source"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} 'Xwt.sln' || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

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

