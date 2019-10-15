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
SRC_URI="https://github.com/craftworkgames/${PROJECT_NAME}/archive/${PV}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-1.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-no-demos.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-no-portable-1.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-no-portable-2.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-2.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-3.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-4.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-5.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-6.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-7.patch"
	eapply "${FILESDIR}/monogame-extended-0.6.359-linux-fixes-8.patch"

	estrong_assembly_info2 "MonoGame.Extended.Content.Pipeline.Tiled" \
		"${DISTDIR}/mono.snk" \
		"Source/MonoGame.Extended.Tiled/Properties/AssemblyInfo.cs"
	estrong_assembly_info2 "MonoGame.Extended.Tests" \
		"${DISTDIR}/mono.snk" \
		"Source/MonoGame.Extended/Properties/AssemblyInfo.cs"
	estrong_assembly_info2 "MonoGame.Extended.Graphics" \
		"${DISTDIR}/mono.snk" \
		"Source/MonoGame.Extended/Properties/AssemblyInfo.cs"
	estrong_assembly_info2 "MonoGame.Extended.Tiled" \
		"${DISTDIR}/mono.snk" \
		"Source/MonoGame.Extended/Properties/AssemblyInfo.cs"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd Source
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln
	}
	dotnet_foreach_impl install_impl
}
# Path Generator for modules
_pgm() {
	local assembly_name="$1"
	echo "Source/${assembly_name}/bin/${mydebug}/${assembly_name}.dll"
}

# Path Generator for pipeline
_pgp() {
	local assembly_name="$1"
	echo "Source/${assembly_name}/bin/${assembly_name}.dll"
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
		_mydoins $(_pgm MonoGame.Extended)
		_mydoins $(_pgm MonoGame.Extended.Animations)
		_mydoins $(_pgm MonoGame.Extended.Collisions)
		_mydoins $(_pgp MonoGame.Extended.Content.Pipeline)
		_mydoins $(_pgp MonoGame.Extended.Content.Pipeline.Animations)
		_mydoins $(_pgp MonoGame.Extended.Content.Pipeline.Tiled)
		_mydoins $(_pgm MonoGame.Extended.Entities)
		_mydoins $(_pgm MonoGame.Extended.Graphics)
		_mydoins $(_pgm MonoGame.Extended.Gui)
		_mydoins $(_pgm MonoGame.Extended.Input)
		_mydoins $(_pgm MonoGame.Extended.NuclexGui)
		_mydoins $(_pgm MonoGame.Extended.Particles)
		_mydoins $(_pgm MonoGame.Extended.Tiled)
		_mydoins $(_pgm MonoGame.Extended.Tweening)
		_mydoins $(_pgm MonoGame.Extended.SceneGraphs)
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "Currently MonoGame doesn't support shaders in Linux on the "
	einfo "stable branch.  This means some of the features in"
	einfo "monogame-extended will not work."
}
