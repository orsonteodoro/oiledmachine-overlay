EAPI=5
inherit eutils

DESCRIPTION="MTPz crypto private key for libmtp and the Zune device"
HOMEPAGE=""
LICENSE="GPL-2"
SLOT="3"
KEYWORDS="amd64"
RDEPEND="media-libs/libmtp
"
IUSE=""
REQUIRED_USE=""
SRC_URI=""
S="${WORKDIR}"
src_install() {
	mkdir -p "${D}/usr/share/libmtp/privatekeys"
	cp "${FILESDIR}/mtpz-data" "${D}/usr/share/libmtp/privatekeys"
}
pkg_config() {
	einfo "Enter the name of the user to copy key:"
	read LOCATION
	cp "/usr/share/libmtp/privatekeys/mtpz-data" "/home/${LOCATION}/.mtpz-data"
	chown ${LOCATION}:${LOCATION} /home/${LOCATION}/.mtpz-data
	einfo "The file .mtpz-data has been copied to /home/${LOCATION}"
}
pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to install the Zune crypto key."
	einfo ""
	einfo "In some jurisdictions, this key is illegal to copy, posess, or re-transmit."
	einfo ""
}
