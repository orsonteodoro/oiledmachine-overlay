# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils mono

DESCRIPTION="NDesk.Options"
HOMEPAGE="http://www.ndesk.org/Options"
SRC_URI="http://www.ndesk.org/archive/ndesk-options/ndesk-options-0.2.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/ndesk-options-${PV}"

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
        ebegin "Installing dlls into the GAC"

	cd "${S}"
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	cd "${S}"/lib/ndesk-options

	strong_sign "${S}/${PN}-keypair.snk" "${S}/lib/ndesk-options/NDesk.Options.dll"
        gacutil -i "${S}//lib/ndesk-options/NDesk.Options.dll" -root "${D}/usr/$(get_libdir)" \
                -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"
	monodocer -assembly:"${S}/Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll" -path:en -pretty

	eend

	cd "${S}"
	dodoc AUTHORS ChangeLog README COPYING
	dodoc -r doc

        mono_multilib_comply
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	grep -r -e "permissionset" "${2}.il" #permissionset not supported
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|.permissionset.*\n.*\}\}||g' "${2}.il"
	fi
	grep -e "\[opt\] bool public" "${2}.il" #broken mangling
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|\[opt\] bool public|[opt] bool \'public\'|g" "${2}.il"
	fi

	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" #|| die "ilasm failed"
	#rm "${2}.orig"
	#rm "${2}.il"
	popd
}
