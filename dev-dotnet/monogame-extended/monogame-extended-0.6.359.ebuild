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
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
RDEPEND="dev-dotnet/monogame
         dev-dotnet/nsubstitute
	 media-libs/freeimage[tiff,openexr,raw,png]"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="https://github.com/craftworkgames/${PROJECT_NAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"
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
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		_mydoins Source/MonoGame.Extended/bin/Release/MonoGame.Extended.dll
		_mydoins Source/MonoGame.Extended.Animations/bin/Release/MonoGame.Extended.Animations.dll
		_mydoins Source/MonoGame.Extended.Collisions/bin/Release/MonoGame.Extended.Collisions.dll
		_mydoins Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll
		_mydoins Source/MonoGame.Extended.Content.Pipeline.Animations/bin/MonoGame.Extended.Content.Pipeline.Animations.dll
		_mydoins Source/MonoGame.Extended.Content.Pipeline.Tiled/bin/MonoGame.Extended.Content.Pipeline.Tiled.dll
		_mydoins Source/MonoGame.Extended.Entities/bin/Release/MonoGame.Extended.Entities.dll
		_mydoins Source/MonoGame.Extended.Graphics/bin/Release/MonoGame.Extended.Graphics.dll
		_mydoins Source/MonoGame.Extended.Gui/bin/Release/MonoGame.Extended.Gui.dll
		_mydoins Source/MonoGame.Extended.Input/bin/Release/MonoGame.Extended.Input.dll
		_mydoins Source/MonoGame.Extended.NuclexGui/bin/Release/MonoGame.Extended.NuclexGui.dll
		_mydoins Source/MonoGame.Extended.Particles/bin/Release/MonoGame.Extended.Particles.dll
		_mydoins Source/MonoGame.Extended.Tiled/bin/Release/MonoGame.Extended.Tiled.dll
		_mydoins Source/MonoGame.Extended.Tweening/bin/Release/MonoGame.Extended.Tweening.dll
		_mydoins Source/MonoGame.Extended.SceneGraphs/bin/Release/MonoGame.Extended.SceneGraphs.dll
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "Currently MonoGame doesn't support shaders in Linux on the "
	einfo "stable branch.  This means some of the features in"
	einfo "monogame-extended will not work."
}
