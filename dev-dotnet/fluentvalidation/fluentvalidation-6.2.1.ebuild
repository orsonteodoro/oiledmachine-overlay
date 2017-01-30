# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="A small validation library for .NET that uses a fluent interface and lambda expressions for building validation rules."
HOMEPAGE=""
PROJECT_NAME="FluentValidation"
SRC_URI="https://github.com/JeremySkinner/FluentValidation/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4"

RESTRICT=""

S="${WORKDIR}/${PROJECT_NAME}-${PV}/src/FluentValidation"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
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
        exbuild_strong /p:Configuration=${mydebug} FluentValidation.csproj || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET}
	do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/${mydebug}/FluentValidation.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		if use developer ; then
	                doins "${S}/bin/${mydebug}/FluentValidation.dll.mdb"
	                doins "${S}/bin/${mydebug}/FluentValidation.XML"
		fi
        done

	eend

	cd "${S}/bin/${mydebug}"
       	insinto "/usr/$(get_libdir)/mono/${PN}"
	for d in "da" "de" "es" "fa" "fi" "fr" "it" "ko" "mk" "nl" "pl" "pt" "ru" "sv" "tr" "zh-CN"
	do
		einfo "Installing folder $d..."
		cp -a "$d" "${D}/usr/$(get_libdir)/mono/${PN}/"
	done

	dotnet_multilib_comply
}

