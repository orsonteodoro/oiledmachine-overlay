# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit flag-o-matic linux-info python-single-r1 toolchain-funcs virtualx

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/netblue30/${PN}/releases/download/${PV}/${P}.tar.xz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
LICENSE="GPL-2"
SLOT="0"
IUSE+=" X apparmor +chroot contrib +dbusproxy +file-transfer +globalcfg +network
+private-home selinux +suid test test-profiles test-x11 +userns +whitelist xpra"
RDEPEND="!sys-apps/firejail-lts
	apparmor? ( >=sys-libs/libapparmor-2.13.3 )
	contrib? ( ${PYTHON_DEPS} )
	dbusproxy? ( >=sys-apps/xdg-dbus-proxy-0.1.2 )
	selinux? ( >=sys-libs/libselinux-8.1.0 )
	xpra? ( >=x11-wm/xpra-3.0.6[firejail] )"
DEPEND="${RDEPEND}
	>=sys-libs/libseccomp-2.4.3"
BDEPEND+="
	|| (
		>=sys-devel/gcc-11
		(
			sys-devel/clang:11
			sys-devel/llvm:11
		)
		(
			sys-devel/clang:12
			sys-devel/llvm:12
		)
		(
			sys-devel/clang:13
			sys-devel/llvm:13
		)
	)
	test? (
		>=dev-tcltk/expect-5.45.4
		>=app-arch/xz-utils-5.2.4
	)"
REQUIRED_USE="
	contrib? ( ${PYTHON_REQUIRED_USE} )
	test-x11? ( test )
	test-profiles? ( test )"
# Needs a lot of work to function within sandbox/portage
# bug #769731
# oteodoro - testing still broken outside of emerge
RESTRICT="test"
PATCHES=( "${FILESDIR}/${PN}-0.9.66-test-return-non-zero-on-testing-error.patch" )
EFIREJAIL_MAX_ENVS=${EFIREJAIL_MAX_ENVS:=512}

pkg_setup() {
	python-single-r1_pkg_setup
	CONFIG_CHECK="~SQUASHFS"
	local WARNING_SQUASHFS="CONFIG_SQUASHFS: required for firejail --appimage mode"
	check_extra_config
	if use test ; then
		if has userpriv $FEATURES ; then
			die \
"You need to add FEATURES=-userpriv to complete testing in your per-package\n\
envvars"
		fi
	fi
}

src_prepare() {
	default

	if use xpra ; then
		eapply "${FILESDIR}/${PN}-0.9.64-xpra-speaker-override.patch"
	fi

	find -type f -name Makefile.in \
		-exec sed -i -r -e \
'/^\tinstall .*COPYING /d; '\
'/CFLAGS/s: (-O2|-ggdb) : :g' {} + \
			|| die

	sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die

	# remove compression of man pages
	sed -i -r -e \
'/rm -f \$\$man.gz; \\/d; '\
'/gzip -9n \$\$man; \\/d; '\
's|\*\.([[:digit:]])\) install -m 0644 \$\$man\.gz|\*\.\1\) install -m 0644 \$\$man|g' \
		Makefile.in || die

	if use contrib; then
		python_fix_shebang -f contrib/*.py
	fi
}

src_configure() {
	local test_opts=()
	if use test ; then
		sed -i -e "s|MAX_ENVS 256|MAX_ENVS ${EFIREJAIL_MAX_ENVS}|g" \
			"src/firejail/firejail.h" || die
		grep -q -r -e "MAX_ENVS ${EFIREJAIL_MAX_ENVS}" "src/firejail/firejail.h" \
			|| die
		ewarn "Max envvars lifted to ${EFIREJAIL_MAX_ENVS}.  Disable test for the production build."
		ewarn "Setting changable by setting per-package envvar EFIREJAIL_MAX_ENVS"
		einfo "Current envvar count: "$(env | wc -l)

		# firejail deprecated --profile-dir= so must be hardwired this way
		sed -i -e "s|\$(sysconfdir)|${D}/etc|g" ./src/common.mk.in || die
	fi

	econf \
		--disable-firetunnel \
		$(use_enable apparmor) \
		$(use_enable chroot) \
		$(use_enable dbusproxy) \
		$(use_enable file-transfer) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable private-home) \
		$(use_enable suid) \
		$(use_enable userns) \
		$(use_enable whitelist) \
		$(use_enable X x11) \
		$(use_enable selinux)
}

src_compile() {
	emake CC="$(tc-getCC)"
	if use test ; then
		# install now into D so we can use this image for testing
		emake install DESTDIR="${D}"
	fi
}

src_test()
{
	# Setting these to test against the to be installed version not the one to be replaced.
	export PATH="${D}/usr/bin:${PATH}"
	export LD_LIBRARY_PATH="${D}/usr/$(get_libdir)/firejail:${LD_LIBRARY_PATH}"

	export SANDBOX_ON=0

	# Upstream uses `make test-github` for CI
	local x11_tests=()
	local profile_tests=()
	local misc_tests=()
	use test-profiles && profile_tests+=(test-profiles)
#	misc_tests=(test-fs) # FIXME: does not work inside ebuild when a lot of
	#  FEATURES=*sandbox options are disabled.
	# Mixes test-github and test-noprofiles with exclusions.
	local basic_tests=(
		test-private-lib
		test-fnetfilter
		test-fs test-utils
		test-sysutils
		test-environment
	)

	# Temporary (broken even outside of portage)
	sed -i -e "s|eog||" test/private-lib/private-lib.sh || die

	for x in ${profile_tests[@]} ${basic_tests[@]} ${misc_tests[@]} ; do
#	for x in ${misc_tests[@]} ; do
		einfo "Testing ${x}"
		make ${x} 2>&1 >"${T}/test.log"
		if (( $? == 0 )) ; then
			einfo "${x} passed"
		else
			die "Test failed for ${x}.  Return code: $?.  For details see ${T}/test.log"
		fi
		grep -q -E -e "Error [0-9]+" "${T}/test.log" && die "Test failed for ${x}.  For details see ${T}/test.log"
	done
	if use test-x11 ; then
		x11_tests+=(
			test-apps
			test-apps-x11
			test-apps-x11-xorg
			test-filters
		)
		for x in ${x11_tests[@]} ; do
			einfo "Testing ${x}"
			cat <<EOF > "${S}/run.sh"
#!/bin/bash
cat /dev/null > "${T}/test-retcode.log"
make ${x} 2&>1 >"${T}/test.log"
echo -n "$?" > "${T}/test-retcode.log"
exit \$(cat "${T}/test-retcode.log")
EOF
			chmod +x "${S}/run.sh"
			virtx "${S}/run.sh"
			grep -q -E -e "Error [0-9]+" "${T}/test.log" && die "Test failed for ${x}.  For details see ${T}/test.log"
			[[ -f "${T}/test-retcode.log" ]] || die "Missing retcode for ${x}"
			local test_retcode=$(cat "${T}/test-retcode.log")
			if [[ "${test_retcode}" != "0" ]] ; then
				die "Test failed for ${x}.  Return code: ${test_retcode}.  For details see ${T}/test.log"
			fi
		done
	fi
	export SANDBOX_ON=1

	die "Tests passed.  Remove the test USE flag."
}

src_install() {
	default

	if use contrib; then
		python_scriptinto /usr/$(get_libdir)/firejail
		python_doscript contrib/*.py
		insinto /usr/$(get_libdir)/firejail
		dobin contrib/*.sh
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
