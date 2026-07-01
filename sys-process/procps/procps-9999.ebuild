# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/craigsmall.asc

CHKL_TIMESTAMPS=(
	"sys-apps/systemd-9999"
	"sys-auth/elogind-257.9999"
	"sys-libs/libselinux-9999"
)

inherit autotools chkl flag-o-matic multilib-minimal verify-sig secure-version toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="cbe5f3fe3d5a3409666b067c89b16b3c692380d8"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-ng-${PV}"
	EGIT_REPO_URI="https://gitlab.com/procps-ng/procps.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
https://downloads.sourceforge.net/${PN}-ng/${PN}-ng-${PV}.tar.xz
	verify-sig? (
https://downloads.sourceforge.net/${PN}-ng/${PN}-ng-${PV}.tar.xz.asc
	)
	"
fi

DESCRIPTION="Standard informational utilities and process-handling tools"
HOMEPAGE="https://gitlab.com/procps-ng/procps"
# Per e.g. https://gitlab.com/procps-ng/procps/-/releases/v4.0.5, the dist tarballs
# are still hosted on SF.
S="${WORKDIR}"/${PN}-ng-${PV}

# See bug #913210
LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/1-ng"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE+=" elogind +kill modern-top +ncurses nls selinux static-libs skill systemd test unicode"
RESTRICT="!test? ( test )"

DEPEND="
	elogind? ( >=sys-auth/elogind-${ELOGIND_PV}:= )
	elibc_musl? ( sys-libs/error-standalone:= )
	ncurses? ( >=sys-libs/ncurses-${NCURSES_PV}:=[unicode(+)?] )
	selinux? ( >=sys-libs/libselinux-${LIBSELINUX_PV}:=[${MULTILIB_USEDEP}] )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	!<app-i18n/man-pages-l10n-4.2.0-r1
	!<app-i18n/man-pages-zh_CN-1.6.4.2
	kill? (
		!sys-apps/coreutils[kill]
		!sys-apps/util-linux[kill]
	)
"
BDEPEND="
	elogind? ( virtual/pkgconfig )
	elibc_musl? ( virtual/pkgconfig )
	ncurses? ( virtual/pkgconfig )
	systemd? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )
	verify-sig? ( sec-keys/openpgp-keys-craigsmall )
"

# bug #898830
QA_CONFIG_IMPL_DECL_SKIP=( makedev )

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.5-sysctl-manpage.patch # bug #565304
	"${FILESDIR}"/${PN}-4.0.6-hurd.patch
)

src_prepare() {
	default

	# Only needed for fix-tests-multilib.patch and pgrep-old-linux-headers.patch
	eautoreconf
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

src_prepare() {
	default
	./autogen.sh || die
}

multilib_src_configure() {
	chkl_check_many_timestamps

	export MAKEOPTS="-j1"

	# http://www.freelists.org/post/procps/PATCH-enable-transparent-large-file-support
	# bug #471102
	append-lfs-flags

	# Workaround for bug 969592
	if use elibc_musl ; then
		append-cflags "$($(tc-getPKG_CONFIG) --cflags error-standalone)"
		append-libs "$($(tc-getPKG_CONFIG) --libs error-standalone)"
	fi

	local myeconfargs=(
		# No elogind multilib support
		$(multilib_native_use_with elogind)
		$(multilib_native_use_enable kill)
		$(multilib_native_use_enable modern-top)
		$(multilib_native_enable pidof)
		$(multilib_native_enable pidwait)
		$(multilib_native_use_with ncurses)
		# bug #794997
		$(multilib_native_use_enable !elibc_musl w)
		$(use_enable nls)
		$(use_enable selinux libselinux)
		$(use_enable static-libs static)
		$(use_with systemd)
		$(use_enable skill)
	)

	if use ncurses; then
		# Only pass whis when we are building the 'watch' command
		myeconfargs+=( $(multilib_native_use_enable unicode watch8bit) )
	fi

	# Needs epoll
	if ! use kernel_linux ; then
		myeconfargs+=(
			--disable-pidwait
		)
	fi

	if use kernel_Hurd ; then
		# Provided by sys-kernel/hurd
		myeconfargs+=(
			--disable-w
		)
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	local ps="${BUILD_DIR}/src/ps/pscommand"
	if [[ $("${ps}" --no-headers -o cls -q $$) == IDL ]]; then
		# bug #708230
		ewarn "Skipping tests due to SCHED_IDLE"
	else
		# bug #461302
		emake check </dev/null
	fi
}

multilib_src_install() {
	default

	dodoc "${S}"/sysctl.conf

	if multilib_is_native_abi; then
		# We keep ps and kill in /bin per bug #565304.
		dodir /bin
		mv "${ED}"/usr/bin/ps "${ED}"/bin/ || die
		if use kill; then
			mv "${ED}"/usr/bin/kill "${ED}"/bin/ || die
		fi
	fi

	if use kernel_Hurd ; then
		# Provided by sys-kernel/hurd
		rm "${ED}"/usr/bin/{uptime,vmstat} || die
		rm "${ED}"/bin/ps || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
