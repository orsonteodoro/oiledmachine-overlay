# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Not to be confused with mono/GtkSharp (tfm=netstandard2.0 or tfm=net6.0)
# This one targets net3.5

EAPI=7

FRAMEWORK="3.5"
MY_PV=$(ver_cut 1-3 ${PV})
inherit autotools dotnet git-r3

DESCRIPTION="Gtk# is a Mono/.NET binding to the cross platform Gtk+ GUI toolkit \
and the foundation of most GUI apps built with Mono"
HOMEPAGE="https://github.com/mono/gtk-sharp"
LICENSE="LGPL-2 MIT GPL-2"
# GPL-2 - gtk/gui-thread-check/profiler/gui-thread-check.c
KEYWORDS="~amd64 ~x86 ~ppc"
ETFM="net35"
IUSE="${ETFM[@]} mono static-libs"
REQUIRED_USE="
	|| ( ${ETFM[@]} )
"
RDEPEND="
	!dev-dotnet/atk-sharp
	!dev-dotnet/gdk-sharp
	!dev-dotnet/glade-sharp
	!dev-dotnet/glib-sharp
	!dev-dotnet/gtk-dotnet-sharp
	!dev-dotnet/gtk-sharp-docs
	!dev-dotnet/gtk-sharp-gapi
	!dev-dotnet/pango-sharp
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3:3
	>=dev-lang/mono-3.2.8
	dev-libs/atk
	dev-perl/XML-LibXML
	gnome-base/libglade
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	virtual/libc
	virtual/pkgconfig
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-lang/mono-3.2.8
	sys-devel/gcc
"
SLOT="3"
SRC_URI=""
RESTRICT="test mirror"
S="${WORKDIR}/${P}"
EGIT_REPO_URI="https://github.com/mono/gtk-sharp.git"
EGIT_BRANCH="main"
EGIT_COMMIT="HEAD"

EXPECTED_BUILD_FILES="\
4216dd3b2b35acf1a3783e925bcbe9c286072c0e430908d334f38c5c503a7712\
0179a38028279be6083b6425438c834d552928fa716d7be8331bea1205df7d2a\
"
DOCS=( "NEWS" "README" "TODO" )

# Canonical / standard name
declare -A CTFM=(
	["net35"]="net3.5"
)

# Descriptive / marketing name
declare -A DTFM=(
	["net35"]=".NET 3.5 Framework"
)

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local
	dotnet_pkg_setup
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	local actual_build_files=$(cat \
		$(find "${S}" -name "configure.ac" -o -name "*.csproj" \
			| sort) \
		| sha512sum \
		| cut -f 1 -d " ")

	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "Version change detected for dependencies"
eerror
eerror "Actual build files:  ${actual_build_files}"
eerror "Expected build files:  ${EXPECTED_BUILD_FILES}"
eerror
		die
	fi

	local actual_pv=$(grep -r -e "AC_INIT" "${S}/configure.ac" \
		| grep -E -o -e  "[0-9]+\.[0-9]+\.[0-9]+")
	local expected_pv="${MY_PV}"
	if ver_test "${actual_pv}" -ne ${expected_pv} ; then
eerror
eerror "Bump the package version"
eerror
eerror "Actual PV:  ${actual_pv}"
eerror "Expected PV:  ${expected_pv}"
eerror
		die
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=()
	! use static-libs && myconf+=( --disable-static )
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}"
	find "${ED}" -type f -name '*.la' -delete || die
	dodoc AUTHORS COPYING
	einstalldocs
	# TODO: fix prefix for shebang, and abspaths
}

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
