# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="MonoGame.Extended are classes and extensions to make MonoGame more awesome "
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

        #inject public key into assembly
        public_key=$(sn -tp "${DISTDIR}/mono.snk" | tail -n 7 | head -n 5 | tr -d '\n')
        echo "pk is: ${public_key}"

	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Extended.Content.Pipeline.Tiled\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Extended.Content.Pipeline.Tiled, PublicKey=${public_key}\")\]|" "Source/MonoGame.Extended.Tiled/Properties/AssemblyInfo.cs"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Extended.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Extended.Tests, PublicKey=${public_key}\")\]|" "Source/MonoGame.Extended/Properties/AssemblyInfo.cs"
	sed -i -r -e "s|\[assembly\: InternalsVisibleToAttribute\(\"MonoGame.Extended.Graphics\"\)\]|\[assembly: InternalsVisibleToAttribute(\"MonoGame.Extended.Graphics, PublicKey=${public_key}\")\]|" "Source/MonoGame.Extended/Properties/AssemblyInfo.cs"
	sed -i -r -e "s|\[assembly\: InternalsVisibleToAttribute\(\"MonoGame.Extended.Tiled\"\)\]|\[assembly: InternalsVisibleToAttribute(\"MonoGame.Extended.Tiled, PublicKey=${public_key}\")\]|" "Source/MonoGame.Extended/Properties/AssemblyInfo.cs"

	eapply_user
}

src_compile() {
	cd "${S}/Source"

	exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Source/MonoGame.Extended/bin/Release/MonoGame.Extended.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Animations/bin/Release/MonoGame.Extended.Animations.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Collisions/bin/Release/MonoGame.Extended.Collisions.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Content.Pipeline.Animations/bin/MonoGame.Extended.Content.Pipeline.Animations.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Content.Pipeline.Tiled/bin/MonoGame.Extended.Content.Pipeline.Tiled.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Entities/bin/Release/MonoGame.Extended.Entities.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Graphics/bin/Release/MonoGame.Extended.Graphics.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Gui/bin/Release/MonoGame.Extended.Gui.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Input/bin/Release/MonoGame.Extended.Input.dll"
                egacinstall "${S}/Source/MonoGame.Extended.NuclexGui/bin/Release/MonoGame.Extended.NuclexGui.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Particles/bin/Release/MonoGame.Extended.Particles.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Tiled/bin/Release/MonoGame.Extended.Tiled.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Tweening/bin/Release/MonoGame.Extended.Tweening.dll"
                egacinstall "${S}/Source/MonoGame.Extended.SceneGraphs/bin/Release/MonoGame.Extended.SceneGraphs.dll"
        done

	eend

	if use developer ; then
                insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${S}/Source/MonoGame.Extended/bin/Release/MonoGame.Extended.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Animations/bin/Release/MonoGame.Extended.Animations.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Collisions/bin/Release/MonoGame.Extended.Collisions.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Content.Pipeline.Animations/bin/MonoGame.Extended.Content.Pipeline.Animations.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Content.Pipeline.Tiled/bin/MonoGame.Extended.Content.Pipeline.Tiled.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Entities/bin/Release/MonoGame.Extended.Entities.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Graphics/bin/Release/MonoGame.Extended.Graphics.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Gui/bin/Release/MonoGame.Extended.Gui.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Input/bin/Release/MonoGame.Extended.Input.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.NuclexGui/bin/Release/MonoGame.Extended.NuclexGui.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Particles/bin/Release/MonoGame.Extended.Particles.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Tiled/bin/Release/MonoGame.Extended.Tiled.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.Tweening/bin/Release/MonoGame.Extended.Tweening.dll.mdb"
		doins "${S}/Source/MonoGame.Extended.SceneGraphs/bin/Release/MonoGame.Extended.SceneGraphs.dll.mdb"
	fi

	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "Currently MonoGame doesn't support shaders in Linux on the stable branch.  This means some of the features in monogame-extended will not work."
}
