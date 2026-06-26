# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AW CRSH CE DOS PE RL SB UAF UB SYM"

# Be careful with packaging odd-version-number branches!
# We should at the very least keep stable as an upstream stable branch,
# possibly even ~arch too, given the note about security releases on their website.
# See https://www.freedesktop.org/wiki/Software/dbus/#download.

PYTHON_COMPAT=( python3_{10..14} )
TMPFILES_OPTIONAL=1

CHKL_TIMESTAMPS=(
	"dev-libs/expat-9999"
	"dev-libs/glib-2.89.9999"
	"sys-apps/systemd-9999"
	"sys-auth/elogind-257.9999"
	"sys-libs/libselinux-9999"
	"sys-process/audit-9999"
	"x11-libs/libX11-9999"
)

inherit chkl cflags-hardened linux-info meson-multilib python-any-r1 readme.gentoo-r1 systemd tmpfiles secure-version virtualx

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="4f5796a37dd303b6030127d20cba52c72523df79"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/dbus/dbus.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://dbus.freedesktop.org/releases/dbus/${P}.tar.xz"
fi

DESCRIPTION="A message bus system, a simple way for applications to talk to each other"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/dbus/"

LICENSE="|| ( AFL-2.1 GPL-2+ ) Apache-2.0 BSD GPL-2+ LGPL-2.1+ MIT tcltk"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
# TODO: USE=daemon
IUSE+=" apparmor audit debug doc elogind selinux static-libs systemd test valgrind X"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	app-text/xmlto
	app-text/docbook-xml-dtd:4.4
	acct-user/messagebus
	dev-build/autoconf-archive
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
COMMON_DEPEND="
	>=dev-libs/expat-${EXPAT_PV}:=
	apparmor? (
		sys-libs/libapparmor:=
		|| (
			~sys-libs/libapparmor-${LIBAPPARMOR_5_0_PV}
			~sys-libs/libapparmor-${LIBAPPARMOR_4_1_PV}
		)
	)
	audit? ( >=sys-process/audit-${AUDIT_PV}:= )
	elogind? ( >=sys-auth/elogind-${ELOGIND_PV}:= )
	selinux? (
		>=sys-libs/libselinux-${LIBSELINUX_PV}:=
	)
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=
		>=x11-libs/libXt-${LIBXT_PV}:=
	)
"
DEPEND="
	${COMMON_DEPEND}
	test? ( >=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}] )
	valgrind? ( >=dev-debug/valgrind-3.6:= )
	X? ( x11-base/xorg-proto:= )
"
RDEPEND="
	${COMMON_DEPEND}
	acct-user/messagebus:*
	selinux? ( sec-policy/selinux-dbus:* )
	systemd? ( virtual/tmpfiles:* )
"

DOC_CONTENTS="
	Some applications require a session bus in addition to the system
	bus. Please see \`man dbus-launch\` for more information.
"

PATCHES=(
)

pkg_setup() {
	# Python interpreter required unconditionally (bug #932517)
	python-any-r1_pkg_setup

	if use kernel_linux; then
		CONFIG_CHECK="~EPOLL"
		linux-info_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	local rundir=$(usex kernel_linux /run /var/run)

	sed -e "s;@rundir@;${EPREFIX}${rundir};g" "${FILESDIR}"/dbus.initd.in \
		> "${T}"/dbus.initd || die

	meson-multilib_src_configure
}

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		--localstatedir="${EPREFIX}/var"
		-Druntime_dir="${EPREFIX}${rundir}"

		-Ddefault_library=$(multilib_native_usex static-libs both shared)

		-Dasserts=false # TODO
		-Dchecks=false # TODO
		$(meson_use debug stats)
		$(meson_use debug verbose_mode)
		-Ddbus_user=messagebus
		-Dkqueue=disabled
		$(meson_feature kernel_linux inotify)
		$(meson_native_use_feature doc doxygen_docs)
		$(meson_native_enabled xml_docs) # Controls man pages

		-Dinstalled_tests=false
		$(meson_native_true message_bus) # TODO: USE=daemon?
		$(meson_feature test modular_tests)
		-Dqt_help=disabled

		$(meson_native_true tools)

		$(meson_native_use_feature elogind)
		$(meson_native_use_feature systemd)
		$(meson_use systemd user_session)
		$(meson_native_use_feature X x11_autolaunch)
		$(meson_native_use_feature valgrind)

		$(meson_native_use_feature apparmor)
		$(meson_native_use_feature audit libaudit)
		$(meson_native_use_feature selinux)

		-Dsession_socket_dir="${EPREFIX}"/tmp
		-Dsystem_pid_file="${EPREFIX}${rundir}"/dbus.pid
		-Dsystem_socket="${EPREFIX}${rundir}"/dbus/system_bus_socket
		-Dsystemd_system_unitdir="$(systemd_get_systemunitdir)"
		-Dsystemd_user_unitdir="$(systemd_get_userunitdir)"
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		emesonargs+=(
			-Dlaunchd=enabled
			-Dlaunchd_agent_dir="${EPREFIX}"/Library/LaunchAgents
		)
	fi

	meson_src_configure
}

multilib_src_compile() {
	# After the compile, it uses a selinuxfs interface to
	# check if the SELinux policy has the right support
	use selinux && addwrite /selinux/access

	meson_src_compile
}

multilib_src_test() {
	# DBUS_TEST_MALLOC_FAILURES=0 to avoid huge test logs
	# https://gitlab.freedesktop.org/dbus/dbus/-/blob/master/CONTRIBUTING.md#L231
	DBUS_TEST_MALLOC_FAILURES=0 DBUS_VERBOSE=1 virtx meson_src_test
}

multilib_src_install_all() {
	newinitd "${T}"/dbus.initd dbus
	exeinto /etc/user/init.d
	newexe "${FILESDIR}/dbus.user.initd" dbus

	if use X; then
		# dbus X session script (bug #77504)
		# turns out to only work for GDM (and startx). has been merged into
		# other desktop (kdm and such scripts)
		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/80-dbus-r1 80-dbus
	fi

	# Needs to exist for dbus sessions to launch
	keepdir /usr/share/dbus-1/services
	keepdir /etc/dbus-1/{session,system}.d
	# machine-id symlink from pkg_postinst()
	keepdir /var/lib/dbus
	# Let the init script create the /var/run/dbus directory
	rm -rf "${ED}"/{,var/}run

	# bug #761763
	rm -rf "${ED}"/usr/lib/sysusers.d

	dodoc AUTHORS NEWS README doc/TODO
	readme.gentoo_create_doc

	mv "${ED}"/usr/share/doc/dbus/* "${ED}"/usr/share/doc/${PF}/ || die
	rm -rf "${ED}"/usr/share/doc/dbus || die
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use systemd; then
		tmpfiles_process dbus.conf
	fi

	# Ensure unique id is generated and put it in /etc wrt bug #370451 but symlink
	# for DBUS_MACHINE_UUID_FILE (see tools/dbus-launch.c) and reverse
	# dependencies with hardcoded paths (although the known ones got fixed already)
	# TODO: should be safe to remove at least the ln because of the above tmpfiles_process?
	dbus-uuidgen --ensure="${EROOT}"/etc/machine-id
	ln -sf "${EPREFIX}"/etc/machine-id "${EROOT}"/var/lib/dbus/machine-id

	if [[ ${CHOST} == *-darwin* ]]; then
		local plist="org.freedesktop.dbus-session.plist"
		elog
		elog "For MacOS/Darwin we now ship launchd support for dbus."
		elog "This enables autolaunch of dbus at session login and makes"
		elog "dbus usable under MacOS/Darwin."
		elog
		elog "The launchd plist file ${plist} has been"
		elog "installed in ${EPREFIX}/Library/LaunchAgents."
		elog "For it to be used, you will have to do all of the following:"
		elog " + cd ~/Library/LaunchAgents"
		elog " + ln -s ${EPREFIX}/Library/LaunchAgents/${plist}"
		elog " + logout and log back in"
		elog
		elog "If your application needs a proper DBUS_SESSION_BUS_ADDRESS"
		elog "specified and refused to start otherwise, then export the"
		elog "the following to your environment:"
		elog " DBUS_SESSION_BUS_ADDRESS=\"launchd:env=DBUS_LAUNCHD_SESSION_BUS_SOCKET\""
	fi
}
