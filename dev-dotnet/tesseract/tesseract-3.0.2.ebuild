# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A .Net wrapper for tesseract-ocr"
HOMEPAGE="https://github.com/charlesw/tesseract"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
RDEPEND="=app-text/tesseract-3.0.2*
         =media-libs/leptonica-1.72*"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="https://github.com/charlesw/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

src_prepare() {
	eapply "${FILESDIR}/tesseract-3.0.2-refs.patch"

	eapply_user
}

src_compile() {
	cd "${S}/src"

	cp "AssemblyVersionInfo.template.cs" "AssemblyVersionInfo.cs" || die
	sed -i -r -e "s|[\$]\(Version\)|${PV}|g" AssemblyVersionInfo.cs || die

        einfo "Building solution"
        exbuild /p:Configuration=$(usex debug "Debug45" "Release45") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" "Tesseract.sln" || die
}

src_install() {
	mydebug="Release45"
	if use debug; then
		mydebug="Debug45"
	fi

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
