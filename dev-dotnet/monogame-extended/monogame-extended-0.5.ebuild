# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="MonoGame.Extended are classes and extensions to make MonoGame more"
DESCRIPTION+=" awesome"
HOMEPAGE="http://www.monogameextended.net/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="MonoGame.Extended"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac static"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND="dev-dotnet/monogame
         dev-dotnet/nsubstitute
	 media-libs/freeimage[tiff,openexr,raw,png]"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="https://github.com/craftworkgames/${PROJECT_NAME}/archive/v${PV}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/monogame-extended-0.5-linux-fixes.patch"
	eapply "${FILESDIR}/monogame-extended-0.5-no-demos.patch"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd Source
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln
	}
	dotnet_foreach_impl compile_impl
}

# @FUNCTION: _mydoins
# @DESCRIPTION:  Combines both egacinstall, regular, and developer meta
_mydoins() {
	local path="$1"
	if dotnet_is_netfx ; then
		egacinstall "${path}"
	fi
	doins "${path}"
	if use developer ; then
		doins "${path}.mdb"
		dotnet_distribute_file_matching_dll_in_gac \
			"${path}"
			"${path}.mdb"
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		_mydoins \
"Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.dll"
		_mydoins \
"Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "Currently MonoGame doesn't support shaders in Linux on the "
	einfo "stable branch.  This means some of the features in"
	einfo "monogame-extended will not work."
}
