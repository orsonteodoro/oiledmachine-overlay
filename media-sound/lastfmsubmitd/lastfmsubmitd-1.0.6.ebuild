# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.5:2.7"

inherit distutils eutils user

DESCRIPTION="lastfmsubmitd is a daemon meant to be used by Last.fm player plugins."
HOMEPAGE="http://www.red-bean.com/decklin/${P}"
SRC_URI="http://www.red-bean.com/decklin/${PN}/${P}.tar.gz"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="doc mpd"

DEPEND="!media-sound/lastfm
        mpd? ( dev-python/py-libmpdclient2 )"
RDEPEND="${DEPEND}"

pkg_setup() {

	enewgroup lastfm
	enewuser lastfm -1 -1 -1 lastfm
}

src_prepare() {
	sed -i -e "s|lib\/lastfmsubmitd|$(get_libdir)\/lastfmsubmitd|" \
		"${S}/"setup.py || die "sed failed"
	epatch "${FILESDIR}"/lastfmsubmitd-1.0.6-use-2.0-api.patch
}

src_install() {
	distutils_src_install

	insinto /etc
	doins "${FILESDIR}"/${PN}.conf
        if use mpd; then
            doins "${FILESDIR}"/lastmp.conf
        fi

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	use doc && dodoc INSTALL

	diropts "-o lastfm -g lastfm -m 0775"
	dodir /var/{log,run,spool}/lastfm

        if use mpd; then
            mkdir -p "${D}/usr/bin"
            cp "${S}/contrib/lastmp" "${D}/usr/bin"
        fi
}

pkg_postinst() {
	elog
	ewarn "Please update /etc/lastfmsubmitd.conf with your lastfm user"
	ewarn "info before starting the daemon."
        if use mpd; then
	    ewarn "Please update /etc/lastmp.conf with your mpd user"
	    ewarn "info before starting the daemon."
        fi
	ewarn "Please edit lastfmsubmitd with your own API_KEY and SHARED_SECRET registered from last.fm."
	elog
}

