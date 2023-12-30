# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

SRC_URI="
https://github.com/troglobit/finit/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Fast init for Linux. Cookies included"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	MIT
"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Needs test
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
+bash-completion +contrib +doc -kernel-cmdline -fastboot -fsckfix mdev -keventd
+logrotate +redirect +rescue -sulogin test udev -watchdog
"
REQUIRED_USE="
	?? (
		mdev
		udev
	)
	contrib
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
# U 22.04
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
	alsa? (
		media-sound/alsa-utils
	)
	bash-completion? (
		>=app-shells/bash-completion-2.0
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
	${DEPEND}
"
BDEPEND+="
	>=sys-devel/autoconf-2.71
	>=sys-devel/automake-1.16.5
	>=sys-devel/gcc-11.2.0
	>=sys-devel/make-4.3
	virtual/pkgconfig
	test? (
		>=app-misc/jq-1.6
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.6-gentoo-contrib.patch"
	"${FILESDIR}/${PN}-4.6-scripts-typo.patch"
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
		-e "s|alpine||g" \
		-e "s|debian||g" \
		-e "s|void||g" \
		"contrib/Makefile.am" \
		|| die
	local libdir=$(get_libdir)
	sed -i \
		-e "s|lib64|${libdir}|g" \
		"contrib/gentoo/finit.d/available/elogind.conf" \
		|| die
	# Avoid install time compression
	sed -i \
		-e "s|/usr/share/doc/finit/|/usr/share/${P}/|g" \
		"contrib/gentoo/install.sh" \
		|| die
	sed -i \
		-e "s|/sbin/sysctl|/usr/sbin/sysctl|g" \
		"plugins/procps.c" \
		|| die
}

src_configure() {
	eautoreconf

	replace-flags '-O*' '-O3' # It's still slow.

	local myconf=(
		$(use_enable alsa alsa-utils-plugin)
		$(use_enable dbus dbus-plugin)
		$(use_enable doc)
		$(use_enable contrib)
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
		--disable-static # Breaks X startup.
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
		--with-runlevel=3
	)
	econf ${myconf[@]}
}

src_install_contrib() {
einfo "Installing contrib"
	emake DESTDIR="${D}" -C contrib/gentoo install
	pushd "contrib/gentoo" || die
		insinto /etc
		doins finit.conf
		doins rc.local
		doins -r finit.d
	popd || die
	insinto /usr/share/${P}
	doins -r contrib/patches
	dodir /etc/finit.d/enabled
	local L
	pushd contrib/gentoo/finit.d/available || die
		L=(
			$(ls *.conf)
		)
	popd
	for fn in ${L[@]} ; do
		dosym \
			"/etc/finit.d/available/${fn}" \
			"/etc/finit.d/enabled/${fn}"
	done
	find "${ED}/etc" -name "Makefile*" -delete
# Dedupe
	rm -rf "${ED}/usr/share/${P}/contrib/gentoo" || die
	rm -rf "${ED}/usr/share/${P}/contrib/finit.conf" || die
	rm -rf "${ED}/usr/share/${P}/finit.conf" || die
}

src_install() {
	emake DESTDIR="${D}" install
	use contrib && src_install_contrib
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (4.6, 20231230)
# build - passed
# urandom save/restore service - passes after it saves seed
# NetworkManager - passed
# getty - passed
# sound - passed if driver loaded with /tmp/xdg-runtime-$(id -u) ownership correction.  It's a bug in elogind in connection with XDG_RUNTIME_DIR, but the ownership bug doesn't exist in systemd.
# performance note:  finit is very fast when few services run.
