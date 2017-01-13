# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="CppNet is a quick and dirty port of jcpp to .NET, with features to support Clang preprocessing."
HOMEPAGE=""
PROJECT_NAME="CppNet"
COMMIT="643098b5397d06336addec4b097066bcc2f489a8"
SRC_URI="https://github.com/xtravar/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/cppnet-9999.20150329-uninit.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} ${PROJECT_NAME}.csproj || die
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
                egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/${mydebug}/${PROJECT_NAME}.dll.mdb
	fi

	dotnet_multilib_comply
}
