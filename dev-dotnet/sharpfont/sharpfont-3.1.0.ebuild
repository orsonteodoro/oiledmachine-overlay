# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils mono

DESCRIPTION="SharpFont"
HOMEPAGE="https://github.com/Robmaister/SharpFont"
SRC_URI="https://github.com/Robmaister/SharpFont/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/SharpFont-${PV}"

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/Source/SharpFont"
	xbuild SharpFont.csproj /p:Configuration=${mydebug}
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	cd "${S}"
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	cd "${S}/Source/SharpFont"
	#strong_sign "${S}/${PN}-keypair.snk" "${S}/Source/SharpFont/obj/${mydebug}/SharpFont.dll"
        gacutil -i "${S}/Source/SharpFont/obj/${mydebug}/SharpFont.dll" -root "${D}/usr/$(get_libdir)" \
                -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"
	eend

	cd "${S}"
	dodoc README.md "LICENSE"

        mono_multilib_comply
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" || die "ilasm failed"
	popd
}
