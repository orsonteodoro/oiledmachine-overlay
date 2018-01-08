# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 linux-info

DESCRIPTION="Capture sound from your soundcard and identify it."
HOMEPAGE="https://github.com/Lahorde/shazam-on-linux"
COMMIT="055bc3299036998408f4e2de43246aabaf829e6a"
SRC_URI="https://github.com/Lahorde/shazam-on-linux/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extras doc examples"
RESTRICT=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
        media-sound/alsa-utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

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
	sed -i "1i #!/usr/bin/env python" identify_sound.py || die
	epatch "${FILESDIR}/${PN}-9999.20170330-config.patch"
	sed -i -e 's|Usage: python2 ./identify_sound.py|Usage: python2 /usr/bin/identify_sound.py|g' identify_sound.py || die
	sed -i -e 's|python2 ${DIR}/identify_sound.py|python2 ${DIR}/identify_sound.py|g' shazam.sh || die

	eapply_user
}

src_compile() {
	true
}

src_install() {
	SITEDIR="/usr/$(get_libdir)/${EPYTHON}/site-packages"
	mkdir -p "${D}/${SITEDIR}/${PN}"
	cp -a {shazam.sh,identify_sound.py} "${D}/${SITEDIR}/${PN}"
	chmod +x "${D}/${SITEDIR}/${PN}/identify_sound.py"
	mkdir -p "${D}/usr/share/${PN}"
	use doc && cp -a README.md "${D}/usr/share/${PN}"
	use examples && cp -a {shazam_on_linux.conf,alsa} "${D}/usr/share/${PN}"

	mkdir -p "${D}/usr/lib/python-exec/${EPYTHON}"
	ln -s "${SITEDIR}/${PN}/identify_sound.py" "${D}/usr/lib/python-exec/${EPYTHON}/identify_sound.py"

	mkdir -p "${D}/usr/bin/"
	ln -s "${D}/${SITEDIR}/${PN}/shazam.sh" "${D}/usr/bin/shazam-on-linux"
	ln -s "${D}/usr/lib/python-exec/python-exec2" "${D}/usr/bin/identify_sound.py"

	if use extras ; then
		mkdir -p "${D}/usr/share/${PN}"
		cp -a "${FILESDIR}"/asoundrc-example "${D}/usr/share/${PN}"
	fi

	mkdir -p "${D}/etc"
	cp -a shazam_on_linux.conf "${D}/etc/"
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
