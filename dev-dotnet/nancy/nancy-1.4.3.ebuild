# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"


inherit dotnet multilib gac


DESCRIPTION="Nancy is a lightweight, low-ceremony, framework for building HTTP based services on .NET Framework/Core and Mono."
HOMEPAGE=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
PROJECT_NAME="Nancy"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
SRC_URI="https://github.com/NancyFx/Nancy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

COMMON_DEP=">=dev-lang/mono-4"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
        "
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/nancy-1.4.3-disable-wcf.patch"

	egenkey

	eapply_user
}

src_compile() {
	cd "${S}/src"

        einfo "Building solution"
        exbuild_strong "${PROJECT_NAME}.sln" || die
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
                egacinstall "${S}/wrappers/csharp/bin/freenectdotnet.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/wrappers/csharp/bin/freenectdotnet.dll.mdb"
        done

	eend

	dotnet_multilib_comply
}
