# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3 eutils

DESCRIPTION="Skype API PLugin for Pidgin"
HOMEPAGE="https://code.google.com/p/skype4pidgin/"
EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"
EGIT_COMMIT="9dcb0c112b94050603b6e46c19a6fa0c2ddd61d5"
LICENSE="GPL-2 CCPL-Attribution-ShareAlike-NonCommercial-3.0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"
SLOT="0"
SRC_URI=""

RDEPEND="net-im/pidgin
		 dbus? ( >sys-apps/dbus-1.0 )
		 net-im/skype"

DEPEND="${RDEPEND}
		>dev-libs/glib-2.0"


src_prepare() {
	eapply "${FILESDIR}/skype4pidgin.patch"

	eapply_user
}

src_compile() {
	emake libskype.so libskype64.so || die 'Error compiling library!'
	emake libskypenet.so libskypenet64.so || die 'Error compiling library!'

	if use dbus; then
		emake libskype_dbus.so libskype_dbus64.so || die 'Error compiling library!'
	fi
}

src_install() {
	insinto /usr/lib/purple-2
	doins "libskype.so"
	doins "libskype64.so"
	doins "libskypenet.so"
	doins "libskypenet64.so"
	if use dbus; then
		doins "libskype_dbus.so"
		doins "libskype_dbus64.so"
	fi

	insinto /usr/share/pixmaps/pidgin/emotes/default-skype
	doins "theme"

	cd icons
	insinto /usr/share/pixmaps/pidgin/protocols/
	doins -r ??
}
