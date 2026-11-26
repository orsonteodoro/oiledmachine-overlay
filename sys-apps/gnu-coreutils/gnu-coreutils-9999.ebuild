# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild fork contains AI fixes.

# This ebuild is for coreutils-muxer, to decouple coreutils from tight integration.

# Try to keep an eye on Fedora's packaging: https://src.fedoraproject.org/rpms/coreutils
# The upstream coreutils maintainers also maintain the package in Fedora and may
# backport fixes which we want to pick up.
#
# Also recommend subscribing to the coreutils and bug-coreutils MLs.

# See also:
# https://gitweb.git.savannah.gnu.org/gitweb/?p=coreutils.git;a=shortlog

MY_P="coreutils-${PV}"
MY_PN="coreutils"

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH BUR DOS ID HO PE SO SYM"

#
# /bin assets for FHS (FSSTND 1.0 -> Filesystem Hierarchy Standard, 1994):
# cat chgrp chmod chown cp date dd df echo false ln ls
# mkdir mknod mv pwd rm rmdir stty sync true uname
#
# /bin common assets for booting:
# basename chroot cut dir dirname du env expr head mkfifo
# mktemp readlink seq sleep sort tail touch tr tty vdir wc yes
#

BIN_ESSENTIAL=(
	"basename"
	"cat"
	"chgrp"
	"chmod"
	"chown"
	"chroot"
	"cp"
	"cut"
	"date"
	"dd"
	"df"
	"dir"
	"dirname"
	"du"
	"echo"
	"env"
	"expr"
	"false"
	"head"
	"ln"
	"ls"
	"mkdir"
	"mkfifo"
	"mknod"
	"mktemp"
	"mv"
	"pwd"
	"readlink"
	"rm"
	"rmdir"
	"seq"
	"sleep"
	"sort"
	"stty"
	"sync"
	"tail"
	"touch"
	"tr"
	"true"
	"tty"
	"uname"
	"vdir"
	"wc"
	"yes"
)

BIN_NON_ESSENTIAL=(
	"["
	"arch"
	"b2sum"
	"base32"
	"base64"
	"basename"
	"basenc"
	"chroot"
	"cksum"
	"comm"
	"csplit"
	"cut"
	"dir"
	"dircolors"
	"dirname"
	"du"
	"env"
	"expand"
	"expr"
	"factor"
	"fmt"
	"fold"
	"groups"
	"head"
	"hostid"
	"id"
	"install"
	"join"
	"link"
	"logname"
	"md5sum"
	"mkfifo"
	"mktemp"
	"nice"
	"nl"
	"nohup"
	"nproc"
	"numfmt"
	"od"
	"paste"
	"pathchk"
	"pinky"
	"pr"
	"printenv"
	"printf"
	"ptx"
	"readlink"
	"realpath"
	"seq"
	"sha1sum"
	"sha224sum"
	"sha256sum"
	"sha384sum"
	"sha512sum"
	"shred"
	"shuf"
	"sleep"
	"sort"
	"split"
	"stat"
	"stdbuf"
	"sum"
	"tac"
	"tail"
	"tee"
	"test"
	"timeout"
	"touch"
	"tr"
	"truncate"
	"tsort"
	"tty"
	"uname"
	"unexpand"
	"uniq"
	"unlink"
	"users"
	"vdir"
	"wc"
	"who"
	"whoami"
	"yes"
)

CHKL_TIMESTAMPS=(
	"app-arch/xz-utils-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"sys-apps/acl-9999"
	"sys-apps/attr-9999"
	"sys-libs/libcap-9999"
	"sys-libs/libselinux-9999"
)

PYTHON_COMPAT=( python3_{10..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/coreutils.asc
inherit branding cflags-hardened chkl edo flag-o-matic python-any-r1 secure-version toolchain-funcs verify-sig

MY_PATCH="${MY_PN}-9.6-patches"
DESCRIPTION="Standard GNU utilities (chmod, cp, dd, ls, sort, tr, head, wc, who,...)"
HOMEPAGE="https://www.gnu.org/software/coreutils/"

if [[ ${PV} == 9999 ]] ; then
	FALLBACK_COMMIT="7da6f665217ec8238fa231c93806f3ea967df167"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/coreutils.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	# Note: could put this in devspace, but if it's gone, we don't want
	# it in tree anyway. It's just for testing.
	MY_SNAPSHOT="$(ver_cut 1-2).299-27a7c"
	SRC_URI="https://www.pixelbeat.org/cu/coreutils-${MY_SNAPSHOT}.tar.xz -> ${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://www.pixelbeat.org/cu/coreutils-${MY_SNAPSHOT}.tar.xz.sig -> ${MY_P}.tar.xz.sig )"
	S="${WORKDIR}"/${MY_PN}-${MY_SNAPSHOT}
else
	SRC_URI="
		mirror://gnu/${MY_PN}/${MY_P}.tar.xz
		verify-sig? ( mirror://gnu/${MY_PN}/${MY_P}.tar.xz.sig )
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

SRC_URI+=" !vanilla? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${MY_PN}/${MY_PATCH}.tar.xz )"

LICENSE="GPL-3+"
SLOT="0"
IUSE+="
acl caps gmp hostname kill multicall nls +openssl selinux static test test-full vanilla xattr
ebuild_revision_6
"
RESTRICT="!test? ( test )"

# Sync !static and static section, removing [static-libs] in !static section.
RDEPEND="
	!static? (
		acl? ( >=sys-apps/acl-${ACL_PV}:= )
		caps? ( >=sys-libs/libcap-${LIBCAP_PV}:= )
		gmp? ( >=dev-libs/gmp-${GMP_PV}:= )
		openssl? (
			$(secure-version_gen_openssl_depends)
		)
		xattr? ( >=sys-apps/attr-${ATTR_PV}:= )
	)
	selinux? ( >=sys-libs/libselinux-${LIBSELINUX_PV}:= )
	nls? ( virtual/libintl:* )
"
DEPEND="
	${RDEPEND}
	static? (
		acl? ( >=sys-apps/acl-${ACL_PV}:=[static-libs] )
		caps? ( >=sys-libs/libcap-${LIBCAP_PV}:= )
		gmp? ( >=dev-libs/gmp-${GMP_PV}:=[static-libs] )
		openssl? (
			$(secure-version_gen_openssl_depends '' '[static-libs]')
		)
		xattr? ( >=sys-apps/attr-${ATTR_PV}:=[static-libs] )
	)
"
BDEPEND="
	$(secure-version_gen_perl_depends)
	>=app-arch/xz-utils-${XZ_UTILS_PV}
	test? (
		$(secure-version_gen_perl_depends)
		dev-debug/strace
		dev-perl/Expect
		${PYTHON_DEPS}
	)
	verify-sig? ( sec-keys/openpgp-keys-coreutils:* )
"
RDEPEND+="
	hostname? ( !sys-apps/net-tools[hostname] )
	kill? (
		!sys-apps/util-linux[kill]
		!sys-process/procps[kill]
	)
	!<sys-apps/util-linux-2.13
	!<sys-apps/sandbox-2.10-r4
	!sys-apps/stat
	!net-mail/base64
	!sys-apps/mktemp
	!<app-forensics/tct-1.18-r1
	!<net-fs/netatalk-2.0.3-r4
	!<sys-apps/shadow-4.19.0_rc1
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# gnulib FPs (bug #898370)
	unreachable MIN alignof static_assert
)

pkg_setup() {
	if use test ; then
		python-any-r1_pkg_setup
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack

		cd "${S}" || die
		edo ./bootstrap $(usex nls "" "--skip-po")

		sed -i -e "s:submodule-checks ?= no-submodule-changes public-submodule-commit:submodule-checks ?= no-submodule-changes:" gnulib/top/maint.mk || die
	else
		if use verify-sig ; then
			# Needed for downloaded patch (which is unsigned, which is fine)
			verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.sig}
		fi
	fi

	default
}

src_prepare() {
	# TODO: past 2025, we may need to add our own hack for bug #907474.
	local PATCHES=(
		"${FILESDIR}"/${MY_PN}-9502f05-skip-readutmp-test.patch
		# Upstream patches

		# oiledmachine-overlay-fixes:
		"${FILESDIR}"/${MY_PN}-9705481-init-destdir_fd.patch
	)

	if ! use vanilla && [[ -d "${WORKDIR}"/${MY_PATCH} ]] ; then
		PATCHES+=( "${WORKDIR}"/${MY_PATCH} )
	fi

	default

	# Breaks with GCC 13
	sed -i -e "/-Wuseless-cast/d" "configure" || die
	sed -i -e "/-Wzero-as-null-pointer-constant/d" "configure" || die

	# Since we've patched many .c files, the make process will try to
	# re-build the manpages by running `./bin --help`.  When doing a
	# cross-compile, we can't do that since 'bin' isn't a native bin.
	#
	# Also, it's not like we changed the usage on any of these things,
	# so let's just update the timestamps and skip the help2man step.
	set -- man/*.x
	touch ${@/%x/1} || die

	# Avoid perl dep for compiled in dircolors default (bug #348642)
	if ! has_version dev-lang/perl ; then
		touch src/dircolors.h || die
		touch ${@/%x/1} || die
	fi
}

get_prefix() {
	echo "/usr/lib/${PN}"
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Running Valgrind in an ebuild is too unreliable. Skip such tests.
	cat <<-EOF >> init.cfg || die
	require_valgrind_()
	{
		skip_ "requires a working valgrind"
	}
	EOF

	# TODO: in future (>9.4?), we may want to wire up USE=systemd:
	# still experimental at the moment, but:
	# https://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=85edb4afbd119fb69a0d53e1beb71f46c9525dd0
	local prefix=$(get_prefix)
	local myconf=(
		--prefix=${prefix}
		--bindir=${prefix}/usr/bin
		--libexecdir=${prefix}/usr/libexec
		--sysconfdir=/etc/${PN}
		--sharedstatedir=/var/lib/${PN}
		--localstatedir=/var/lib/${PN}
		--datadir=${prefix}/usr/share
		--infodir=${prefix}/usr/share/info
		--mandir=${prefix}/usr/share/man
		--datarootdir=${prefix}/usr/share

		--with-packager-version="${PVR} (p${PATCH_VER:-0})"
		# kill/uptime - procps
		# hostname    - net-tools
		--enable-install-program="arch,$(usev hostname),$(usev kill)"
		--enable-no-install-program="$(usev !hostname),$(usev !kill),su,uptime"
		$(usev !caps --disable-libcap)
		$(use_enable nls)
		$(use_enable acl)
		$(use_enable multicall single-binary)
		$(use_enable xattr)
		$(use_with gmp libgmp)
		$(use_with openssl)
		$(use_with selinux)
	)

	if use gmp ; then
		myconf+=( --with-libgmp-prefix="${ESYSROOT}"/usr )
	fi

	# https://savannah.gnu.org/support/?111394
	# This can be removed when we patch dev-build/autoconf, though
	# packages w/o eautoreconf will still need it.
	[[ ${enable_year2038} == "no" ]] && myconf+=( --disable-year2038 )

	if tc-is-cross-compiler && [[ ${CHOST} == *linux* ]] ; then
		# bug #311569
		export fu_cv_sys_stat_statfs2_bsize=yes
		# bug #416629
		export gl_cv_func_realpath_works=yes
	fi

	# bug #409919
	export gl_cv_func_mknod_works=yes

	if use static ; then
		append-ldflags -static
		# bug #321821
		sed -i '/elf_sys=yes/s:yes:no:' configure || die
	fi

	econf "${myconf[@]}"
}

src_test() {
	# Non-root tests will fail if the full path isn't
	# accessible to non-root users
	chmod -R go-w "${WORKDIR}" || die
	chmod a+rx "${WORKDIR}" || die

	# coreutils tests like to do `mount` and such with temp dirs,
	# so make sure:
	# - /etc/mtab is writable (bug #265725)
	# - /dev/loop* can be mounted (bug #269758)
	mkdir -p "${T}"/mount-wrappers || die
	mkwrap() {
		local w ww
		for w in "${@}" ; do
			ww="${T}/mount-wrappers/${w}"
			cat <<-EOF > "${ww}"
				#!${EPREFIX}/bin/sh
				exec env SANDBOX_WRITE="\${SANDBOX_WRITE}:/etc/mtab:/dev/loop" $(type -P ${w}) "\$@"
			EOF
			chmod a+rx "${ww}" || die
		done
	}
	mkwrap mount umount

	addwrite /dev/full

	local -x RUN_{VERY_,}EXPENSIVE_TESTS=$(usex test-full yes no)
	#local -x COREUTILS_GROUPS="portage wheel"
	local -x PATH="${T}/mount-wrappers:${PATH}"
	local -x gl_public_submodule_commit=

	local xfail_tests=()

	if [[ -n ${SANDBOX_ACTIVE} ]]; then
		xfail_tests+=(
			# bug #629660
			# Commented out again in 9.6 as it XPASSes on linux-6.12.10
			# with sandbox-2.43 on tmpfs. Let's see if it lasts..
			#tests/dd/no-allocate.sh

			# bug #675802
			tests/env/env-S
			tests/env/env-S.pl

			# We have a patch which fixes this (bug #259876)
			#tests/touch/not-owner
			#tests/touch/not-owner.sh
		)
	fi

	[[ ${enable_year2038} == "no" ]] && xfail_tests+=( test-year2038 )

	# This test is flaky (bug #910640).
	cat > tests/tty/tty-eof.pl <<-EOF || die
	#!/usr/bin/perl
	exit 77;
	EOF

	# We set DISABLE_HARD_ERRORS because some of the tests hard error-out
	# because of sandbox. They're skipped above but DISABLE_HARD_ERRORS is needed
	# to downgrade them to FAIL.
	emake -k check \
		VERBOSE=yes \
		DISABLE_HARD_ERRORS=yes \
		XFAIL_TESTS="${xfail_tests[*]}"
}

src_install() {
	default

	local prefix=$(get_prefix)

	# Prevent merge collision
	mv \
		"${ED}/usr/share/doc/${P}" \
		"${ED}${prefix}/usr/share/doc/" \
		|| die


	# Prevent merge collision
	insinto "${prefix}/etc"
	newins src/dircolors.hin DIR_COLORS

	# The muxer handles split-usr.
	# Install rules:
	# 1.  Install package into /usr/<pkg-name>
	# 2.  remove any prefix
	# 3.  standard layout
	#     /lib/<provider>/
	#     ├── bin/          # Essential boot/POSIX utilities (cat, cp, dd, ln, ls, mkdir, mv, rm, etc.)
	#     ├── usr/
	#     │   ├── bin/      # Non-essential utilities (sha256sum, factor, pinky, etc.)
	#     │   ├── libexec/
	#     │   └── share/    # man pages, locales, info
	#     └── etc/

	local prefix=$(get_prefix)
	dodir "${prefix}/bin"
	for x in "${BIN_ESSENTIAL[@]}" ; do
		mv "${ED}${prefix}/usr/bin/${x}" "${ED}${prefix}/bin/" || die
	done
	if ! use hostname ; then
		rm "${ED}${prefix}/usr/bin/hostname" || true
	fi
	if ! use kill ; then
		rm "${ED}${prefix}/usr/bin/kill" || true
	fi
}

pkg_postinst() {
ewarn
ewarn "Make sure you run 'hash -r' in your active shells."
ewarn "You should also re-source your shell settings for LS_COLORS"
ewarn "  changes, such as: source /etc/profile"
ewarn
einfo
einfo "To switch, use the following with one of the boot disks:"
einfo
einfo "/mnt/gentoo/switch-coreutils gnu /mnt/gentoo"
einfo
}
