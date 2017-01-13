# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="BulletSharp .NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE=""
PROJECT_NAME="BulletSharpPInvoke"
SRC_URI="https://github.com/AndresTraks/${PROJECT_NAME}/archive/0.9.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac ${PACKAGE_FEATURES_L}"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac || ( ${PACKAGE_FEATURES_L} )"
BULLET_VERSION="2.85"

RDEPEND=">=dev-lang/mono-4
         sci-physics/bullet
         dev-dotnet/clangsharp
         =sci-physics/libbulletc-${BULLET_VERSION}"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/bulletsharppinvoke-0.9-clangsharp-ref.patch"

	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" BulletSharpPInvoke/Native.cs

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/BulletSharpPInvoke"

        einfo "Building solution"
	myplatform="Any CPU"
        exbuild_strong /p:Configuration="${mydebug}" /p:Platform="$myplatform" ${PROJECT_NAME}.sln || die
	#cd "${S}/BulletSharpGen"
        #exbuild_strong /p:Configuration="${mydebug}" /p:Platform="$myplatform" BulletSharpGen.sln || die
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
                egacinstall "${S}/BulletSharpPInvoke/bin/${mydebug}/BulletSharp.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins BulletSharpPInvoke/bin/${mydebug}/BulletSharp.dll.mdb
	fi

        FILES=$(find "${D}" -name "BulletSharp.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/BulletSharp.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
