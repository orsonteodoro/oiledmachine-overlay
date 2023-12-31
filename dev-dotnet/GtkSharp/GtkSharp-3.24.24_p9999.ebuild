# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Not to be confused with mono/gtk-sharp (tfm=net3.5)
# This one targets netstandard2.0 or net6.0

EAPI=7

MY_PV=$(ver_cut 1-3 ${PV})
inherit dotnet git-r3

DESCRIPTION=".NET wrapper for Gtk and other related libraries"
HOMEPAGE="https://github.com/GtkSharp/GtkSharp"
LICENSE="LGPL-2 MIT GPL-2"
# GPL-2 - Source/OldStuff/parser/gapi-parser.cs
# GPL-2 - Source/Tools/GapiCodegen/CodeGenerator.cs
KEYWORDS="~amd64 ~x86 ~ppc"
ETFM="net60 netstandard20"
IUSE="${ETFM[@]} developer fsharp gtksourceview mono nupkg vbnet webkit-gtk"
REQUIRED_USE="
	|| ( ${ETFM[@]} )
	mono? ( netstandard20 )
"
# See also Source/Libs/Shared/GLibrary.cs
RDEPEND="
	!dev-dotnet/atk-sharp
	!dev-dotnet/gdk-sharp
	!dev-dotnet/glade-sharp
	!dev-dotnet/glib-sharp
	!dev-dotnet/gtk-dotnet-sharp
	!dev-dotnet/gtk-sharp-docs
	!dev-dotnet/gtk-sharp-gapi
	!dev-dotnet/pango-sharp
	>=dev-libs/glib-2:2
	dev-libs/atk
	virtual/libc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	x11-libs/gtk+:3
	gtksourceview? ( >=x11-libs/gtksourceview-4:4 )
	mono? ( >=dev-lang/mono-5.4 )
	net60? ( >=dev-dotnet/dotnet-sdk-bin-6:6 )
	webkit-gtk? ( net-libs/webkit-gtk:4 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	|| (
		>=dev-dotnet/dotnet-sdk-bin-6:6
		>=dev-dotnet/dotnet-sdk-bin-5:5
	)
	app-arch/unzip
"
SLOT="3"
SRC_URI=""
RESTRICT="test mirror"
S="${WORKDIR}/${P}"
EGIT_REPO_URI="https://github.com/GtkSharp/GtkSharp.git"
EGIT_BRANCH="develop"
EGIT_COMMIT="HEAD"

DOTNET_SDKS=(
	"dotnet-sdk-bin-6.0"
	"dotnet-sdk-bin-5.0"
)

EXPECTED_BUILD_FILES="\
a542602b254d2ecb6553b318113448e722fe9e3d9e5bc7b8c8d07d416ffc3f8b\
18c9b6c718749a1f7c8999a77fe2c8972a9a0e9891b4d9a686542ed7ae6cf52f\
"

# Canonical / standard name
declare -A CTFM=(
	["net60"]="net6.0"
	["netstandard20"]="netstandard2.0"
)

# Descriptive / marketing name
declare -A DTFM=(
	["net60"]=".NET 6.0"
	["netstandard20"]=".NET Standard 2.0"
)

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local found=0
	for sdk in ${DOTNET_SDKS[@]} ; do
		if [[ -e "${EPREFIX}/opt/${sdk}" ]] ; then
			export SDK="${sdk}"
			export PATH="${EPREFIX}/opt/${sdk}:${PATH}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "You need a dotnet SDK."
eerror
eerror "Supported SDK versions: 5, 6"
eerror
		die
	fi

	local
	for etfm in ${ETFM[@]} ; do
		if use "${etfm}" ; then
			einfo " -- USING ${DTFM[${etfm}]} -- "
		fi
	done
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	local actual_build_files=$(cat \
		$(find "${S}" -path "*/Source/Libs/Shared/GLibrary.cs" | sort) \
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

	local actual_pv=$(grep "Gtk\"" "${S}/Source/Libs/Shared/GLibrary.cs" | cut -f 4 -d '"')
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

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_ROOT="/opt/${SDK}"
	dotnet tool restore || die
	dotnet cake build.cake || die
}

NS=(
	"AtkSharp"
	"CairoSharp"
	"GLibSharp"
	"GdkSharp"
	"GioSharp"
	"GtkSharp.Template.CSharp"
	"GtkSharp.Template.FSharp"
	"GtkSharp.Template.VBNet"
	"GtkSharp"
	"GtkSourceSharp"
	"PangoSharp"
	"WebkitGtkSharp"
)

_install_unpacked() {
	local etfm="${1}"
	local tfm="${CTFM[${etfm}]}"
	local ns
	for ns in ${NS[@]} ; do
		! use fsharp && [[ "${ns}" =~ "FSharp" ]] && continue
		! use gtksourceview && [[ "${ns}" =~ "GtkSource" ]] && continue
		! use vbnet && [[ "${ns}" =~ "VBNet" ]] && continue
		! use webkit-gtk && [[ "${ns}" =~ "WebkitGTK" ]] && continue
		exeinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		insinto "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}"
		local f
		for f in $(find "BuildOutput/Release/${tfm}" \
			   -name "${ns}.dll" \
			-o -name "${ns}.pdb" \
			-o -name "${ns}.deps.json") ; do
			[[ "${f}" =~ ".dll" ]] && doins "${f}"
			if [[ "${f}" =~ ".dll" ]] ; then
				doexe "${f}"
				if use mono ; then
					dodir "/usr/lib/mono/4.5"
					dosym "/opt/${SDK}/shared/${ns}/${MY_PV}/${tfm}/${ns}.dll" \
						"/usr/lib/mono/4.5/${ns}.dll"
				fi
			fi
		done
	done
}

_install_nupkg() {
	local ns
	for ns in ${NS[@]} ; do
		local f
		for f in $(find BuildOutput/NugetPackages -name "${ns}*.nupkg") ; do
			! use fsharp && [[ "${f}" =~ "FSharp" ]] && continue
			! use gtksourceview && [[ "${f}" =~ "GtkSource" ]] && continue
			! use vbnet && [[ "${f}" =~ "VBNet" ]] && continue
			! use webkit-gtk && [[ "${f}" =~ "WebkitGTK" ]] && continue
			local is_any=1
			if use netstandard20 && unzip -l "${f}" | grep -q "netstandard2.0" ; then
				insinto "/opt/${SDK}/packs/${ns}/${MY_PV}/netstandard2.0"
				doins "${f}"
				is_any=0
			fi
			if use net60 &&  unzip -l "${f}" | grep -q "net6.0" ; then
				insinto "/opt/${SDK}/packs/${ns}/${MY_PV}/net6.0"
				doins "${f}"
				is_any=0
			fi
			if (( ${is_any} == 1 )) ; then
				insinto "/opt/${SDK}/packs/${ns}/${MY_PV}"
				doins "${f}"
			fi
		done
	done
}

src_install() {
	default
	local etfm # ebuild tfm
	for etfm in ${ETFM[@]} ; do
		use "${etfm}" && _install_unpacked "${etfm}"
	done

	use nupkg && _install_nupkg

	if ! use developer ; then
		find "${ED}" \( -name "*xml" -o -name "*.pdb" \) -delete
	fi
	dodoc LICENSE AUTHORS README.md
}
