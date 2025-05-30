# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22, U24

inherit autotools flag-o-matic

S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/troglobit/finit/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Fast init for Linux. Cookies included"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	MIT
"
KEYWORDS="~amd64"
RESTRICT="mirror strip test" # Test attempts to download
SLOT="0"
PLUGINS=(
	-alsa
	-dbus
	-hook-scripts
	+hotplug
	-modprobe
	-modules-load
	+netlink
	-resolvconf
	+rtc
	-testserv
	+tty
	+urandom
	-X
)
# auto's final value determined by CI
IUSE+="
${PLUGINS[@]}
+bash-completion dash +doc -kernel-cmdline -fastboot -fsckfix mdev -keventd
+logrotate +redirect +rescue -sulogin test udev -watchdog
"
REQUIRED_USE="
	?? (
		mdev
		udev
	)
	?? (
		hook-scripts
		netlink
	)
"
INIT_SYSTEMS_DEPENDS="
	!sys-apps/epoch
	!sys-apps/openrc
	!sys-apps/s6
	!sys-apps/s6-linux-init
	!sys-apps/s6-rc
	!sys-apps/systemd
	!sys-apps/sysvinit
	!sys-process/runit
"
# sys-apps/util-linux - for getty.conf contrib, swapoff
# sys-apps/kbd - for keymap.conf in contrib
LIBITE_PV="2.2.0"
LIBUEV_PV="2.2.0"
RDEPEND+="
	${INIT_SYSTEMS_DEPENDS}
	>=dev-libs/libite-${LIBITE_PV}
	>=dev-libs/libuev-${LIBUEV_PV}
	app-alternatives/sh
	sys-apps/kbd
	sys-apps/shadow
	sys-apps/util-linux
	sys-process/procps
	sys-apps/finit-d
	alsa? (
		media-sound/alsa-utils
	)
	bash-completion? (
		>=app-shells/bash-completion-2.0
	)
	dash? (
		app-shells/dash[libedit]
	)
	dbus? (
		sys-apps/dbus
	)
	mdev? (
		sys-apps/busybox[mdev]
	)
	modules-load? (
		sys-apps/kmod
	)
	udev? (
		sys-apps/systemd-utils[udev]
	)
"
DEPEND+="
	${RDEPEND}
	sys-kernel/linux-headers
"
BDEPEND+="
	>=dev-build/autoconf-2.71
	>=dev-build/automake-1.16.5
	>=sys-devel/gcc-11.2.0
	>=dev-build/make-4.3
	virtual/pkgconfig
	test? (
		>=app-misc/jq-1.6
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.12-override-bshell.patch"
)

pkg_setup() {
	if has_version "sys-apps/busybox[mdev]" && has_version "sys-apps/systemd-utils[udev]" ; then
ewarn
ewarn "mdev and udev should not be installed at the same time."
ewarn
ewarn "Conflicting packages:"
ewarn
ewarn "  sys-apps/busybox[mdev]"
ewarn "  sys-apps/systemd-utils[udev]"
ewarn
	fi
}

src_prepare() {
	default
	sed -i \
		-e "s|/sbin/sysctl|/usr/sbin/sysctl|g" \
		"plugins/procps.c" \
		|| die
	if [ -n "$FINIT_SHELL" ] ; then
ewarn "Using $FINIT_SHELL as the default init shell.  (EXPERIMENTAL)"
		if [ ! -e "$FINIT_SHELL" ] ; then
eerror "FINIT_SHELL=$FINIT_SHELL not found."
			die
		fi
		sed -i -e "s|__DISTRO_BSHELL__|$FINIT_SHELL|g" "src/finit.h" || die
	elif use dash ; then
ewarn "Using /bin/dash as the default init shell.  (EXPERIMENTAL)"
		sed -i -e "s|__DISTRO_BSHELL__|/bin/dash|g" "src/finit.h" || die
	else
einfo "Using /bin/sh as the default init shell."
		sed -i -e "s|__DISTRO_BSHELL__|/bin/sh|g" "src/finit.h" || die
	fi
}

src_configure() {
	eautoreconf

	replace-flags '-O*' '-O3'

	local myconf=(
		$(use_enable alsa alsa-utils-plugin)
		$(use_enable dbus dbus-plugin)
		$(use_enable doc)
		$(use_enable hook-scripts hook-scripts-plugin)
		$(use_enable fastboot)
		$(use_enable fsckfix)
		$(use_enable hotplug hotplug-plugin)
		$(use_enable kernel-cmdline)
		$(use_enable logrotate)
		$(use_enable modprobe modprobe-plugin)
		$(use_enable modules-load modules-load-plugin)
		$(use_enable netlink netlink-plugin)
		$(use_enable redirect)
		$(use_enable rescue)
		$(use_enable resolvconf resolvconf-plugin)
		$(use_enable rtc rtc-plugin)
		$(use_enable tty tty-plugin)
		$(use_enable testserv testserv-plugin)
		$(use_enable urandom urandom-plugin)
		$(use_enable X x11-common-plugin)
		$(use_with keventd)
		$(use_with sulogin)
		$(use_with watchdog)
		--disable-auto-reload # Breaks emerge update of the same package.
		--disable-static # Breaks X
		--disable-contrib # For service script
		--docdir="/usr/share/${P}"
		--bindir="/bin"
		--sbindir="/sbin"
		--with-hostname="${FINIT_HOSTNAME:-localhost}"
	# See
	# https://wiki.gentoo.org/wiki/Handbook:X86/Working/Initscripts#Booting_the_system
	# https://en.wikipedia.org/wiki/Runlevel#Gentoo_Linux
	# https://github.com/troglobit/finit/tree/master/doc#runlevels
	#
	# si internal, sys init (mount all)				Same as pre S [hidden] in finit defined in src/finit.c.  No cryptsetup support (Issue #74)
	# rc boot, run everything in /etc/runlevels/boot/		Same as S in finit
	# 0 internal, shutdown
	# 1 user defined, single (aka recovery)
	# 2 user defined, nonetwork
	# 3 user defined, default
	# 4 user defined, default
	# 5 user defined, default
	# 6 internal, reboot
	#
	# Run sequence:
	# si -> rc -> 3 for 99% of the time when operating normally
	# si -> rc -> 1 for 1% of the time when broken
	# ctrl-alt-delete -> s6 -> s0
		--with-runlevel=3
	)
	econf ${myconf[@]}
}

src_install_contrib() {
einfo "Installing contrib"
	exeinto /bin
	doexe contrib/service
	insinto /usr/share/${P}
	doins -r contrib/patches
}

src_install() {
	emake DESTDIR="${D}" install
	src_install_contrib
}

src_test() {
	emake check
}

pkg_postinst() {
ewarn
ewarn "linux-4.9-inotify-in-mask-create.patch should be applied to kernel versions <= 4.18.x "
ewarn
ewarn "You should almost always enable getty.conf"
ewarn
ewarn "This init system is still in testing."
ewarn
ewarn
ewarn "SECURITY NOTICE"
ewarn
ewarn "Changing user/group with @user:group may be broken/inconsistent for both"
ewarn "script or direct executable cases which may result in users coerced into"
ewarn "running a daemon as root:root or user:root."
ewarn
ewarn "Use openrc/systemd if that is an issue."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (4.6, 20231230)
# build - passed
# dash - passed
# urandom save/restore service - passes after it saves seed
# NetworkManager - passed
# getty - passed
# sound - passed if driver loaded with /tmp/xdg-runtime-$(id -u) ownership
#   correction.  It's a bug in elogind in connection with XDG_RUNTIME_DIR, but
#   the ownership bug doesn't exist in systemd.
#
#   workaround1:  user_id=$(id -u in limited user) ; sudo chown -R name:name /tmp/xdg-runtime-${user_id} ; sudo chown -R name:name /run/users/${user_id}
#   workaround2:  https://www.alsa-project.org/wiki/Setting_the_default_device
#
# performance note:  finit is very fast when few services run.
