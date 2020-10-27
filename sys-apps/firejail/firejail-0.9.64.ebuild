# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/netblue30/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="apparmor +chroot contrib dbusproxy debug +file-transfer +globalcfg +network +overlayfs +private-home +seccomp selinux +suid test +userns vim-syntax +whitelist x11 xpra"

DEPEND="!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )
	dbusproxy? ( sys-apps/xdg-dbus-proxy )
	test? ( dev-tcltk/expect )
	xpra? ( x11-wm/xpra[firejail] )"

RDEPEND="apparmor? ( sys-libs/libapparmor )"

# TODO: enable tests
RESTRICT="mirror test"

PATCHES=( "${FILESDIR}/${PN}-0.9.64-compressed-manpages.patch" )

src_prepare() {
	default

	if use xpra ; then
		eapply "${FILESDIR}/${PN}-0.9.64-xpra-speaker-override.patch"
	fi

	find ./contrib -type f -name '*.py' | xargs sed --in-place 's-#!/usr/bin/python3-#!/usr/bin/env python3-g' || die

	find -type f -name Makefile.in | xargs sed --in-place --regexp-extended \
			--expression='/^\tinstall .*COPYING /d' \
			--expression='/CFLAGS/s: (-O2|-ggdb) : :g' || die

	sed --in-place --regexp-extended '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die

	# remove compression of man pages
	sed --in-place '/gzip -9n $$man; \\/d' Makefile.in || die
	sed --in-place '/rm -f $$man.gz; \\/d' Makefile.in || die
	sed --in-place --regexp-extended 's|\*\.([[:digit:]])\) install -c -m 0644 \$\$man\.gz|\*\.\1\) install -c -m 0644 \$\$man|g' Makefile.in || die
}

src_configure() {
	econf \
		--disable-firetunnel \
		$(use_enable apparmor) \
		$(use_enable chroot) \
		$(use_enable contrib contrib-install) \
		$(use_enable dbusproxy) \
		$(use_enable file-transfer) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable overlayfs) \
		$(use_enable private-home) \
		$(use_enable seccomp) \
		$(use_enable selinux) \
		$(use_enable suid) \
		$(use_enable userns) \
		$(use_enable whitelist) \
		$(use_enable x11)
}

src_install() {
	default

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins contrib/vim/ftdetect/firejail.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins contrib/vim/syntax/firejail.vim
	fi
}

pkg_postinst() {
	if use xpra ; then
		einfo
		einfo "A new custom args have been added to improve performance."
		einfo "To lessen shuddering/skipping some apps may benefit by"
		einfo "disabiling sound sound input and output forwarding."
		einfo
		einfo
		einfo "New args (must be placed before --x11=xpra)"
		einfo "  --xpra-speaker=0  # disables sound forwarding for xpra"
		einfo "  --xpra-speaker=1  # enables sound forwarding for xpra"
		einfo
		einfo
		einfo "Profile additions"
		einfo
		einfo "  xpra_speaker_off  # disables sound forwarding for xpra"
		einfo "  xpra_speaker_on  # enables sound forwarding for xpra"
		einfo
	fi
	ewarn "Files marked chmod uo+r permissions and filenames containing"
	ewarn "sensitive info contained in the root directory are exposed."
	ewarn "to an attacker in the sandbox.  They should be moved in"
	ewarn "either another disk, or in folder with parent folder and"
	ewarn "descendants with uo-r chmod permissions or explicitly added"
	ewarn "as a blacklist rule in /etc/firejail/globals.local."
	ewarn
	ewarn "Always check your sandbox profile in the shell to see if it"
	ewarn "meets your privacy requirements."
}
