# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="C# library for parsing and importing TMX and TSX files generated"
DESCRIPTION+=" by Tiled, a tile map generation tool."
HOMEPAGE="https://github.com/marshallward/TiledSharp"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
USE_DOTNET="net35 net40 net45 netstandard20 netcoreapp20 netcoreapp21 test"
IUSE="${USE_DOTNET} debug gac doc"
REQUIRED_USE="|| ( ${USE_DOTNET} )
		gac? ( || ( net40 net45 ) )
		test? ( || ( netcoreapp20 netcoreapp21 net35 net40 net45 ) )"
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )"
SLOT="0/${PV}"
inherit dotnet eutils mono
EGIT_COMMIT="f29fb71591200093fa159f53094b8b8d7fab1d17"
PROJECT_NAME="TiledSharp"
SRC_URI="https://github.com/marshallward/TiledSharp/archive/${EGIT_COMMIT}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
TOOLS_VERSION="Current"
RESTRICT="mirror"

src_unpack() {
	if use netcoreapp20 || use netcoreapp21 ; then
		ewarn "The netcoreapp20 or netcoreapp21 USE flags are only for"
		ewarn "unit testing.  They will not be creating the dlls for"
		ewarn "TiledSharp."
	fi
	unpack ${A}
	cd "${S}"
	erestore
}

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		if [[ ! ( "${EDOTNET}" =~ netcoreapp ) ]] ; then
			exbuild TiledSharp/TiledSharp.csproj \
				${STRONG_ARGS_NETCORE}"${DISTDIR}/mono.snk" || die
		fi
		if use test ; then
			exbuild TiledSharp.Test/TiledSharp.Test.csproj \
				${STRONG_ARGS_NETCORE}"${DISTDIR}/mono.snk" || die
		fi
	}
	dotnet_foreach_impl compile_impl
	if use doc ; then
		cd docs
		doxygen Doxyfile
	fi
}

src_install() {
	local mydebug=$(usex "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		local p=\
"TiledSharp/bin/${mydebug}/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})"
		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			doins ${p}/{TiledSharp.dll,TiledSharp.deps.json}
			if use developer ; then
				doins ${p}/TiledSharp.pdb
			fi
		elif dotnet_is_netfx "${EDOTNET}" ; then
			estrong_resign "${p}/TiledSharp.dll" \
				"${DISTDIR}/mono.snk" || die
	                egacinstall "${p}/TiledSharp.dll"
			doins ${p}/TiledSharp.dll
			if use developer ; then
				doins ${p}/TiledSharp.pdb
				dotnet_distribute_file_matching_dll_in_gac \
					"${p}/TiledSharp.dll"
					"${p}/TiledSharp.pdb"
			fi
		fi
	}
	dotnet_foreach_impl install_impl
	use doc && dodoc -r docs/html
	dotnet_multilib_comply
}

src_test() {
	test_impl() {
		#todo
		true
	}
	dotnet_foreach_impl test_impl
}
