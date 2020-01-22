# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Virtual keyboard-like emoji picker for Linux"
HOMEPAGE="https://github.com/OzymandiasTheGreat/emoji-keyboard"
LICENSE="GPL-3+ CC-BY-SA-4.0 CC-BY-4.0 SIL Apache-2.0"
# Emojitwo is CC-BY-SA-4.0
# NotoColorEmoji is SIL and Apache 2.0
# Twitter Emoji is CC-BY-4.0
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="wayland X"
REQUIRED_USE="|| ( X wayland )"
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
RDEPEND="dev-libs/gobject-introspection[${PYTHON_USEDEP}]
	dev-libs/libappindicator[introspection]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/python-evdev[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	X? ( >=dev-python/python-xlib-0.19[${PYTHON_USEDEP}] )
	wayland? ( sys-apps/systemd )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# gobject-introspection complains about multiple implementations
CHECKREQS_DISK_BUILD="1024M"
CHECKREQS_DISK_USR="75M"
inherit check-reqs eutils linux-info user
EMOJITWO_COMMIT="b851e2070faf5c707d2e74988d425d4956c17187"
NOTOEMOJI_COMMIT="09d8fd121a6d35081fdc31a540735c4a2f924356"
TWEMOJI_COMMIT="2f786b03d0bc0944eb3b66850a805dcadd5f853d"
EGIT_COMMIT="afe17aa0577db78f119f5595d0582e805365db4b"
SRC_URI=\
"https://github.com/OzymandiasTheGreat/emoji-keyboard/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz
https://github.com/EmojiTwo/emojitwo/archive/${EMOJITWO_COMMIT}.tar.gz \
	-> emoji-keyboard-deps-emojitwo-2.3.0_p20171213.tar.gz
https://github.com/googlei18n/noto-emoji/archive/${NOTOEMOJI_COMMIT}.tar.gz \
	-> emoji-keyboard-deps-noto-emoji-1.22_p20171216.tar.gz
https://github.com/twitter/twemoji/archive/${TWEMOJI_COMMIT}.tar.gz \
	-> emoji-keyboard-deps-twemoji-2.4.0_p20171208.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists ; then
		ewarn \
"You are missing a .config file in your kernel source."
	fi

	if ! linux_chkconfig_present INPUT_EVDEV ; then
		ewarn \
"You may need CONFIG_INPUT_EVDEV=y or CONFIG_INPUT_EVDEV=m for this to work."
	fi

	if use wayland ; then
		if ! linux_chkconfig_present INPUT_UINPUT ; then
			ewarn \
"You may need CONFIG_INPUT_UINPUT=y or CONFIG_INPUT_UINPUT=m for this to work."
		fi
	fi
	python_setup
	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/emojitwo" "${S}/noto-emoji" "${S}/twemoji"
	ln -s "${WORKDIR}/emojitwo-${EMOJITWO_COMMIT}" \
		"${S}/emojitwo" || die
	ln -s "${WORKDIR}/noto-emoji-${NOTOEMOJI_COMMIT}" \
		"${S}/noto-emoji" || die
	ln -s "${WORKDIR}/twemoji-${TWEMOJI_COMMIT}" \
		"${S}/twemoji" || die
}

python_prepare_all() {
	if ! use wayland ; then
		eapply "${FILESDIR}/emoji-keyboard-9999.20190314.patch"
	fi
	einfo "Updating emojis please wait..."
	${EPYTHON} update-resources.py

	# prevent sandbox error:
	# AttributeError: 'NoneType' object has no attribute 'get_entries_for_keyval'
	sed -i -e "s|keycode = get_keycode()|#keycode = get_keycode()|" \
		lib/emoji_shared.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	einfo "running A"
	distutils-r1_python_compile

	find "${WORKDIR}" -name "emoji_shared.py" -exec \
	sed -i -e "s|#keycode = get_keycode()|keycode = get_keycode()|" \
		"{}" \;
}

pkg_preinst() {
	if use wayland ; then
		enewgroup uinput
		insinto /etc/udev/rules.d/
		echo 'KERNEL=="uinput", GROUP="uinput", MODE="0660"' \
			> "${T}/uinput.rules"
		doins "${T}/uinput.rules"
	fi
}

pkg_postinst() {
	if ! use X ; then
		ewarn \
"You are not installing X support and is highly recommended.  Settings > On \
selecting emoji > Type will not work without X USE flag if you are using X11 \
instead of Wayland."
	fi
	if use wayland ; then
		ewarn \
"You need to add yourself to the uinput group for Type mode pasting on \
Wayland to work."
	fi
}
