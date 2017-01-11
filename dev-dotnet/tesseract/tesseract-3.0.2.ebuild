# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="A .Net wrapper for tesseract-ocr"
HOMEPAGE=""
PROJECT_NAME="tesseract"
SRC_URI="https://github.com/charlesw/${PROJECT_NAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         =app-text/tesseract-3.0.2*
         =media-libs/leptonica-1.72*"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/tesseract-3.0.2-refs.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release45"
	if use debug; then
		mydebug="Debug45"
	fi
	cd "${S}/src"

	cp "AssemblyVersionInfo.template.cs" "AssemblyVersionInfo.cs" || die
	sed -i -r -e "s|[$]\(Version\)|${PV}|g" AssemblyVersionInfo.cs || die

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} "Tesseract.sln" || die
}

src_install() {
	mydebug="Release45"
	if use debug; then
		mydebug="Debug45"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
		egacinstall src/Tesseract/bin/${mydebug}/Net${EBF}/Tesseract.dll
		if use developer; then
			doins src/Tesseract/bin/${mydebug}/Net${EBF}/{Tesseract.dll.mdb,Tesseract.xml}
		fi
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "src/Tesseract.snk"

	fi

	dotnet_multilib_comply
}
