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
SRC_URI="https://github.com/craftworkgames/${PROJECT_NAME}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
RESTRICT="mirror"

src_prepare() {
	eapply "${FILESDIR}/monogame-extended-0.5-linux-fixes.patch"
	eapply "${FILESDIR}/monogame-extended-0.5-no-demos.patch"

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
