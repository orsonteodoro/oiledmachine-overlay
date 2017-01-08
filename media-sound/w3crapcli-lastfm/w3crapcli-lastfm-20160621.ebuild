# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit eutils

DESCRIPTION="w3crapcli/last.fm: scrobbler for mpv"
HOMEPAGE="https://github.com/l29ah/w3crapcli"
SRC_URI=""
LICENSE="WTFPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="savedconfig"
REQUIRED_USE="savedconfig"

DEPEND="media-video/mpv[lua]
        dev-lang/lua
        dev-lang/perl
        dev-perl/XML-XPath
        dev-perl/MD5
        dev-perl/URI
        dev-perl/LWP-Protocol-https"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_setup() {
  if [[ ! -f /etc/portage/savedconfig/media-sound/${PN}-${PV} ]]; then
        einfo "You must fill out your own savedconfig before preceeding."
        einfo "Copy and edit ${FILESDIR}/${PN}.conf to /etc/portage/savedconfig/media-sound/${PN}-${PV} and try again."
        die ""
  fi
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/${PN}"
	cp "${FILESDIR}"/lastfm "${D}/usr/share/${PN}"
	cp "${FILESDIR}"/lastfm.pl "${D}/usr/share/${PN}"
	cp "${FILESDIR}"/mpv-lastfm.lua "${D}/usr/share/${PN}"
}

_set_settings() {
	mkdir -p "${USERFOLDER}/.config/mpv/scripts/"
	cp /usr/share/"${PN}"/lastfm "$USERFOLDER/.config/"
	cp /usr/share/"${PN}"/lastfm.pl "$USERFOLDER/"
	cp /usr/share/"${PN}"/mpv-lastfm.lua "$USERFOLDER/.config/mpv/scripts/"
	sed -i -r -e "s|LFM_PASS|$LFM_PASS|g" "$USERFOLDER/.config/lastfm"
	sed -i -r -e "s|LFM_NAME|$LFM_NAME|g" "$USERFOLDER/.config/lastfm"
	sed -i -r -e "s|APP_NAME|$APP_NAME|g" "$USERFOLDER/lastfm.pl"
	sed -i -r -e "s|APP_API_KEY|$APP_API_KEY|g" "$USERFOLDER/lastfm.pl"
	sed -i -r -e "s|APP_SHARED_SECRET|$APP_SHARED_SECRET|g" "$USERFOLDER/lastfm.pl"

	chown $USEROWNER:$USERGROUP "$USERFOLDER/lastfm.pl"
	chown $USEROWNER:$USERGROUP "$USERFOLDER/.config/lastfm"
	chown $USEROWNER:$USERGROUP "$USERFOLDER/.config/mpv/scripts/mpv-lastfm.lua"
	chmod 700 "$USERFOLDER/lastfm.pl"
	chmod 600 "$USERFOLDER/.config/lastfm"

	unset LFM_PASS
	unset APP_API_KEY
	unset APP_SHARED_SECRET
}

pkg_postinst() {
	elog "Obtain an API key from http://www.last.fm/api/accounts ."
	elog "You need to add the user home directory to the PATH environmental variable in ~/.bashrc ."
	if ! use savedconfig ; then
		elog "Do a \`emerge ${PN} --config\` to manually complete the installation."
	else
		source "/etc/portage/savedconfig/media-sound/${PN}-${PV}"
		_set_settings
	fi
}

pkg_config() {
	if ! use savedconfig ; then
		einfo "Enter the full path of the user home dir (/home/<username>)"
		read USERFOLDER
		einfo "Enter the file owner"
		read USEROWNER
		einfo "Enter the file group"
		read USERGROUP
	        einfo "Enter your last.fm username:"
	        read LFM_NAME
	        einfo "Enter your last.fm password:"
	        read LFM_PASS
	        einfo "Enter the app name:"
	        read APP_NAME
	        einfo "Enter the app api key:"
	        read APP_API_KEY
	        einfo "Enter the shared secret:"
	        read APP_SHARED_SECRET

		_set_settings
	fi
}

