# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit eutils linux-info python-single-r1

DESCRIPTION="Capture sound from your soundcard and identify it."
HOMEPAGE="https://github.com/Lahorde/shazam-on-linux"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
EGIT_COMMIT="055bc3299036998408f4e2de43246aabaf829e6a"
SRC_URI="https://github.com/Lahorde/shazam-on-linux/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
SLOT="0"
IUSE="doc examples extras"
RESTRICT="mirror"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}
        media-sound/alsa-utils"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists ; then
		eerror "You are missing a .config file in your kernel source."
		die
	fi

	if ! linux_chkconfig_present SND_ALOOP ; then
		eerror "You need CONFIG_SND_ALOOP=y or CONFIG_SND_ALOOP=m for this to work."
		die
	fi

	python_setup
}

src_prepare() {
	default
	sed -i "1i #!/usr/bin/env python" identify_sound.py || die
	epatch "${FILESDIR}/${PN}-9999.20170330-config.patch"
	sed -i -e 's|Usage: python2 ./identify_sound.py|Usage: python2 /usr/bin/identify_sound.py|g' identify_sound.py || die
	sed -i -e 's|python2 ${DIR}/identify_sound.py|python2 ${DIR}/identify_sound.py|g' shazam.sh || die
}

src_compile() {
	:;
}

src_install() {
	exeinto /usr/$(get_libdir)/${EPYTHON}/site-packages/${PN}
	doexe shazam.sh identify_sound.py
	insinto /usr/share/${PN}
	use doc && dodoc README.md
	use examples && doins shazam_on_linux.conf alsa

	dodir /usr/$(get_libdir)/python-exec
	exeinto /usr/bin
	dosym /usr/$(get_libdir)/${EPYTHON}/site-packages/${PN}/identify_sound.py /usr/$(get_libdir)/python-exec/${EPYTHON}/identify_sound.py
	dosym /usr/$(get_libdir)/${EPYTHON}/site-packages/${PN}/shazam.sh /usr/bin/shazam-on-linux
	dosym /usr/$(get_libdir)/python-exec/python-exec2 /usr/bin/identify_sound.py

	if use extras ; then
		insinto /usr/share/${PN}
		doins "${FILESDIR}"/asoundrc-example
	fi

	insinto /etc
	doins shazam_on_linux.conf
}

pkg_postinst() {
	einfo "You need an account from ACRCLoud for details see https://github.com/Lahorde/shazam-on-linux ."
	einfo "You need to edit /etc/shazam_on_linux.conf or make a copy of it in your /home/_username_/.config/${PN}/shazam_on_linux.conf and edit accordingly."
	if use examples ; then
		einfo "An example of the conf file can be found at /usr/share/${PN}/shazam_on_linux.conf"
	fi

	if use extras ; then
		einfo "Examples of .asoundrc can be found in /usr/share/${PN}"
	else
		einfo "It is recommended you check out the sample asoundrc-example by enabling the extra USE flag or you will have difficulty using this product."
	fi
}
