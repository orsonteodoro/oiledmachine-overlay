# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cross platform GUI framework for desktop and mobile applications"
DESCRIPTION=+"in .NET"
HOMEPAGE="https://github.com/mono/xwt"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
EGIT_COMMIT="cd710a42a895b05337047079b0ba16d081dd87ed"
inherit dotnet
SRC_URI=\
"https://github.com/mono/xwt/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
inherit gac
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-9999.20171206-linux-only-projects.patch"
	  "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-val-never-used.patch"
	  "${FILESDIR}/${PN}-9999.20171206-AccessibleBackend-suppress-value-assigned-never-used.patch"
	  "${FILESDIR}/${PN}-9999.20171206-disable-tests.patch" )
DOCS=( README.markdown LICENSE.txt )

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd Source || die
	        exbuild ${STRONG_ARGS_NETFX}"${S}/xwt.snk" 'Xwt.sln' || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
                egacinstall "Xwt.Gtk/bin/${mydebug}/Xwt.dll"
                egacinstall "Xwt.Gtk/bin/${mydebug}/Xwt.Gtk3.dll"
		doins Xwt.Gtk/bin/${mydebug}/Xwt.dll
		doins Xwt.Gtk/bin/${mydebug}/Xwt.Gtk3.dll
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
