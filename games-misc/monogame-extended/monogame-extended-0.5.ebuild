# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="MonoGame.Extended are classes and extensions to make MonoGame more awesome "
HOMEPAGE=""
PROJECT_NAME="MonoGame.Extended"
SRC_URI="https://github.com/craftworkgames/${PROJECT_NAME}/archive/v${PV}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac static"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         games-engines/monogame
         dev-dotnet/nsubstitute
	 media-libs/freeimage[tiff,openexr,raw,png]"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/monogame-extended-0.5-linux-fixes.patch"
	eapply "${FILESDIR}/monogame-extended-0.5-no-demos.patch"

	egenkey

	eapply_user
}

src_compile() {
	cd "${S}/Source"

	exbuild_strong ${PROJECT_NAME}.sln

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
                egacinstall "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.dll"
                egacinstall "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
                doins "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.dll.mdb"
	        doins "${S}/Source/MonoGame.Extended.Content.Pipeline/bin/MonoGame.Extended.Content.Pipeline.dll.mdb"
	fi

	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "Currently MonoGame doesn't support shaders in Linux on the stable branch.  This means some of the features in monogame-extended will not work."
}
