# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SSL_CERT_MANDATORY=1
inherit ssl-cert user-info

DESCRIPTION="A self-signed certificate required by some *.deb packages or projects"
KEYWORDS="~amd64 ~x86"
IUSE="
	+cert-only-pem
"
BDEPEND="
	dev-libs/openssl
"
SLOT="0/$(ver_cut 1-2 ${PV})"
S="${T}"

pkg_setup() {
	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	dosym "/etc/${PN}/certs/${PN}.pem" "/etc/ssl/certs/${PN}.pem" || die
	dosym "/etc/${PN}/certs/${PN}.key" "/etc/ssl/private/${PN}.key" || die
}

pkg_postinst() {
	if [ ! -f "${EROOT}/etc/${PN}/certs/${PN}.key" ]; then
einfo "Installing ${PN}"
		SSL_BITS=2048
		install_cert "/etc/${PN}/certs/${PN}"
		if use cert-only-pem ; then
			cat "${EROOT}/etc/${PN}/certs/${PN}.csr" \
				> "${EROOT}/etc/${PN}/certs/${PN}.pem" || die
		else
ewarn
ewarn "Detected cert-only-pem USE flag OFF."
ewarn
ewarn "This cert is for testing purposes."
ewarn "It is unsafe to use it in production."
ewarn "It contains an assumed private key in the pem cert file."
ewarn
		fi
		chown ${PN}:${PN} "${EROOT}/etc/${PN}/certs/${PN}."{crt,csr,key,pem}
		chmod 0644 "${EROOT}/etc/${PN}/certs/${PN}.pem"
		chmod 0640 "${EROOT}/etc/${PN}/certs/${PN}.key"
	fi
}

pkg_prerm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
einfo "Uninstalling ${PN}"
		rm -rf "${EROOT}/etc/${PN}/certs"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
