# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The lockfile should be updated once a week for security reasons.

# Upstream are working on updating clamav's LLVM bytecode interpreter to work
# with later versions of LLVM, but it's not ready yet. See:
# https://github.com/Cisco-Talos/clamav/issues/581
# This does not impact the ability of the package to build with llvm/clang otherwise.

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{10..12} ) # CI uses 3.8

# LLVM 14 support is complete.
# LLVM 15 support is a Work In Progress (WIP)
# LLVM 16 support is a Work In Progress (WIP)

# From "./convert-cargo-lock.sh 1.2.1 1.2.1"
CRATES="
adler-1.0.2
aho-corasick-1.0.5
autocfg-1.1.0
base64-0.21.3
bindgen-0.65.1
bit_field-0.10.2
bitflags-1.3.2
bitflags-2.4.0
block-buffer-0.10.4
bumpalo-3.13.0
bytemuck-1.14.0
byteorder-1.4.3
cbindgen-0.25.0
cc-1.0.83
cexpr-0.6.0
cfg-if-1.0.0
clang-sys-1.6.1
color_quant-1.1.0
cpufeatures-0.2.9
crc32fast-1.3.2
crossbeam-channel-0.5.8
crossbeam-deque-0.8.3
crossbeam-epoch-0.9.15
crossbeam-utils-0.8.16
crunchy-0.2.2
crypto-common-0.1.6
digest-0.10.7
either-1.9.0
errno-0.3.3
errno-dragonfly-0.1.2
exr-1.7.0
fastrand-2.0.0
fdeflate-0.3.0
flate2-1.0.27
flume-0.10.14
futures-core-0.3.28
futures-sink-0.3.28
generic-array-0.14.7
getrandom-0.2.10
gif-0.12.0
glob-0.3.1
half-2.2.1
hashbrown-0.12.3
heck-0.4.1
hermit-abi-0.3.2
hex-0.4.3
home-0.5.5
image-0.24.7
indexmap-1.9.3
itoa-1.0.9
jpeg-decoder-0.3.0
js-sys-0.3.64
lazycell-1.3.0
lazy_static-1.4.0
lebe-0.5.2
libc-0.2.147
libloading-0.7.4
linux-raw-sys-0.4.5
lock_api-0.4.10
log-0.4.20
memchr-2.6.3
memoffset-0.9.0
minimal-lexical-0.2.1
miniz_oxide-0.7.1
nanorand-0.7.0
nom-7.1.3
num-complex-0.4.4
num_cpus-1.16.0
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.16
once_cell-1.18.0
peeking_take_while-0.1.2
pin-project-1.1.3
pin-project-internal-1.1.3
png-0.17.10
prettyplease-0.2.15
primal-check-0.3.3
proc-macro2-1.0.66
qoi-0.4.1
quote-1.0.33
rayon-1.7.0
rayon-core-1.11.0
redox_syscall-0.3.5
regex-1.9.5
regex-automata-0.3.8
regex-syntax-0.7.5
rustc-hash-1.1.0
rustdct-0.7.1
rustfft-6.1.0
rustix-0.38.11
ryu-1.0.15
scopeguard-1.2.0
serde-1.0.188
serde_derive-1.0.188
serde_json-1.0.105
sha1-0.10.5
sha2-0.10.7
shlex-1.2.0
simd-adler32-0.3.7
smallvec-1.11.0
spin-0.9.8
strength_reduce-0.2.4
syn-1.0.109
syn-2.0.31
tempfile-3.8.0
thiserror-1.0.48
thiserror-impl-1.0.48
tiff-0.9.0
toml-0.5.11
transpose-0.2.2
typenum-1.16.0
unicode-ident-1.0.11
unicode-segmentation-1.10.1
version_check-0.9.4
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.87
wasm-bindgen-backend-0.2.87
wasm-bindgen-macro-0.2.87
wasm-bindgen-macro-support-0.2.87
wasm-bindgen-shared-0.2.87
weezl-0.1.7
which-4.4.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.48.5
windows_aarch64_msvc-0.48.5
windows_i686_gnu-0.48.5
windows_i686_msvc-0.48.5
windows-sys-0.48.0
windows-targets-0.48.5
windows_x86_64_gnu-0.48.5
windows_x86_64_gnullvm-0.48.5
windows_x86_64_msvc-0.48.5
zune-inflate-0.2.54
"

inherit cargo cmake flag-o-matic lcnr llvm python-any-r1 systemd tmpfiles

MY_P=${P//_/-}

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
"
S="${WORKDIR}/clamav-${MY_P}"

THIRD_PARTY_LICENSES+="
	0BSD
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	BZIP2
	CC-BY-3.0
	curl
	GPL-2
	ISC
	LGPL-2.1
	MIT
	MPL-2.0
	public-domain
	unRAR
	Unlicense
	UoI-NCSA
	ZLIB
	Unicode-DFS-2016
	|| ( Unlicense MIT )
	|| ( MIT Apache-2.0 )
"

LICENSE="
	${THIRD_PARTY_LICENSES}
	GPL-2
	LGPL-2.1
"

# 0BSD - cargo_home/gentoo/adler-1.0.2/LICENSE-0BSD
# Apache-2.0 - cargo_home/gentoo/glob-0.3.0/LICENSE-APACHE
# Boost-1.0 - cargo_home/gentoo/ryu-1.0.11/LICENSE-BOOST
# BSD - cargo_home/gentoo/instant-0.1.12/LICENSE
# BSD-2 - COPYING/COPYING.file
# BZIP2 - COPYING/COPYING.bzip2
# CC-BY-3.0 - cargo_home/gentoo/crossbeam-channel-0.5.6/LICENSE-THIRD-PARTY
# curl - COPYING/COPYING.curl
# GPL-2 - unit_tests/input/COPYING
# ISC - cargo_home/gentoo/libloading-0.7.4/LICENSE
# LGPL-2.1 - libclammspack/COPYING.LIB
# MIT - clamonacc/c-thread-pool/LICENSE
# MPL-2.0 - cargo_home/gentoo/cbindgen-0.20.0/LICENSE
# public-domain - libclamav/tomsfastmath/LICENSE
# public-domain - COPYING/COPYING.lzma
# unRAR - libclamunrar/license.txt
# Unlicense - cargo_home/gentoo/byteorder-1.4.3/UNLICENSE
# UoI-NCSA - COPYING/COPYING.llvm
# ZLIB - cargo_home/gentoo/miniz_oxide-0.6.2/LICENSE-ZLIB.md
# Unicode-DFS-2016 - cargo_home/gentoo/regex-syntax-0.6.28/src/unicode_tables/LICENSE-UNICODE
# || ( Unlicense MIT ) - cargo_home/gentoo/byteorder-1.4.3/COPYING
# || ( MIT Apache-2.0 ) - cargo_home/gentoo/half-2.1.0/LICENSE

SLOT="0/sts"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi
IUSE="
doc clamonacc +clamapp custom-cflags experimental jit libclamav-only man milter rar
selinux +system-mspack systemd test valgrind r1
"

REQUIRED_USE="
	clamonacc? (
		clamapp
	)
	libclamav-only? (
		!clamapp
		!clamonacc
		!milter
	)
	milter? (
		clamapp
	)
	test? (
		!libclamav-only
	)
"

#RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.

# See CI for details.
# CI uses U 22.04
# OpenSSL-3 required for license compatibility
CURL_PV="7.68.0"
PYTEST_PV="7.2.0"
# The dev-libs/libmspack version has been lowered in this ebuild.
CDEPEND="
	!libclamav-only? (
		>=net-misc/curl-${CURL_PV}
	)
	>=app-arch/bzip2-1.0.8
	>=dev-libs/openssl-1.1.1f:=
	>=dev-libs/json-c-0.13.1:=
	>=dev-libs/libltdl-2.4.6
	>=dev-libs/libpcre2-8.39:=
	>=dev-libs/libxml2-2.9.10
	>=sys-libs/zlib-1.2.1:=
	acct-group/clamav
	acct-user/clamav
	virtual/libiconv
	clamapp? (
		>=net-misc/curl-${CURL_PV}
		>=sys-libs/ncurses-6.2:=
	)
	elibc_glibc? (
		>=sys-libs/glibc-2.31
	)
	elibc_musl? (
		sys-libs/fts-standalone
	)
	jit? (
		<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=
		>=sys-devel/llvm-14:=
	)
	milter? (
		>=mail-filter/libmilter-8.15.2:=
	)
	rar? (
		>=app-arch/unrar-6.1.5
	)
	system-mspack? (
		>=dev-libs/libmspack-0.10.1_alpha
	)
	test? (
		$(python_gen_any_dep ">=dev-python/pytest-${PYTEST_PV}"'[${PYTHON_USEDEP}]')
	)
"

# rust-bin < 1.71 has an executable stack
# which is not supported on selinux #911589
BDEPEND="
	>=virtual/rust-1.71.0
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.9.1
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep ">=dev-python/pytest-${PYTEST_PV}"'[${PYTHON_USEDEP}]')
		valgrind? (
			>=dev-util/valgrind-3.15.0
		)
	)
"

DEPEND="
	${CDEPEND}
	test? (
		>=dev-libs/check-0.10.0
	)
"

RDEPEND="
	${CDEPEND}
	selinux? (
		sec-policy/selinux-clamav
	)
"

python_check_deps() {
	python_has_version -b ">=dev-python/pytest-${PYTEST_PV}[${PYTHON_USEDEP}]"
}

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to update lockfile."
eerror
		die
	fi
}

pkg_setup() {
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		check_network_sandbox
	fi
	use jit && llvm_pkg_setup
	use test && python-any-r1_pkg_setup
einfo
einfo "To hard unmask the jit USE flag, do:"
einfo
echo
echo "mkdir -p /etc/portage/profile/package.use.mask"
echo "echo \"app-antivirus/clamav -jit\" >> /etc/portage/profile/package.use.mask"
echo
}

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-CMakeLists-allow-llvm16.patch"
	"${FILESDIR}/${PN}-1.0.0-llvm14-noreturn.patch"
	"${FILESDIR}/${PN}-1.0.0-llvm14.patch"
	"${FILESDIR}/${PN}-1.0.0-llvm15.patch"
)

_lockfile_gen_unpack() {
	unpack "${MY_P}.tar.gz"
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"
	die
}

_production_unpack() {
	unpack "${MY_P}.tar.gz"
	if [[ -e "${FILESDIR}/${PV}/Cargo.lock" ]] ; then
einfo "Replacing with updated Cargo.lock"
		cp -a "${FILESDIR}/${PV}/Cargo.lock" "${S}" || die
	fi
	cargo_src_unpack
}

src_unpack() {
	default
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
}

src_prepare() {
	cmake_src_prepare
	if ver_test ${LLVM_SLOT} -ge 16 ; then
einfo "LLVM_SLOT:\t${LLVM_SLOT}"
		eapply "${FILESDIR}/${PN}-1.0.0-llvm16.patch"
		ewarn "JIT is still broken for LLVM 16"
	fi
	if ver_test ${LLVM_SLOT} -ge 15 ; then
einfo "LLVM_SLOT:\t${LLVM_SLOT}"
		ewarn "JIT is still broken for LLVM 15"
	fi

	sed -i -e 's|base64 = "0.21.0"|base64 = "0.21.2"|g' \
		"libclamav_rust/Cargo.toml" \
		|| die
}

print_glibc_required_flags() {
eerror
eerror "Did not find ${1}"
eerror
eerror "sys-libs/glibc must be built with:"
eerror
eerror
eerror "/etc/portage/env/ggdb3.conf:"
eerror
eerror "  CFLAGS=\"\${CFLAGS} -ggdb3\""
eerror "  CXXFLAGS=\"\${CXXFLAGS} -ggdb3\""
eerror
eerror "/etc/portage/env/splitdebug.conf:"
eerror
eerror "  FEATURES=\"\${FEATURES} splitdebug\""
eerror
eerror "/etc/portage/env/compressdebug.conf (optional):"
eerror
eerror "  FEATURES=\"\${FEATURES} splitdebug\""
eerror
eerror "/etc/portage/env/nostrip.conf:"
eerror
eerror "  FEATURES=\"\${FEATURES} nostrip\""
eerror
eerror "/etc/portage/package.env:"
eerror
eerror "  sys-libs/glibc ggdb3.conf splitdebug.conf compressdebug.conf nostrip.conf"
eerror
}

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	if ! use custom-cflags ; then
		# Upstream default in CI is just -O3.
		strip-flags
		filter-flags \
			'-march=*' \
			'-mtune=*'
		replace-flags '-O*' '-O3'
	fi

	clang --version
	local mycmakeargs=(
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DBYTECODE_RUNTIME=$(usex jit llvm interpreter)
		-DCLAMAV_GROUP="clamav"
		-DCLAMAV_USER="clamav"
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_EXPERIMENTAL=$(usex experimental ON OFF)
		-DENABLE_EXTERNAL_MSPACK=$(usex system-mspack ON OFF)
		-DENABLE_JSON_SHARED=ON
		-DENABLE_MAN_PAGES=$(usex man ON OFF)
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_SHARED_LIB=ON
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DOPTIMIZE=ON
	)

	if use test ; then
		# https://bugs.gentoo.org/818673
		# Used to enable some more tests but doesn't behave well in
		# sandbox necessarily(?) + needs certain debug symbols present
		# in e.g. glibc.
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Valgrind=$(usex valgrind OFF ON)
			-DPYTHON_FIND_VERSION="${EPYTHON#python}"
		)

		unset VALGRIND # Let build scripts decide
		if use valgrind && use elibc_glibc ; then
			if ! grep -q -e "-ggdb3" \
				"${ESYSROOT}"/var/db/pkg/sys-libs/glibc-*/CFLAGS ; then
				print_glibc_required_flags "-ggdb3"
				die
			fi
			if ! grep -q -e "splitdebug" \
				"${ESYSROOT}"/var/db/pkg/sys-libs/glibc-*/FEATURES ; then
				print_glibc_required_flags "splitdebug"
				die
			fi
			if ! grep -q -e "nostrip" \
				"${ESYSROOT}"/var/db/pkg/sys-libs/glibc-*/FEATURES ; then
				print_glibc_required_flags "nostrip"
				die
			fi
		fi
	fi

	if use jit ; then
		# Suppress CMake warnings that variables aren't consumed if we aren't using LLVM
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#llvm-optional-see-bytecode-runtime-section
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#bytecode-runtime
		mycmakeargs+=(
			-DLLVM_ROOT_DIR="$(get_llvm_prefix -d ${LLVM_MAX_SLOT})"
			-DLLVM_FIND_VERSION="$(best_version sys-devel/llvm:${LLVM_MAX_SLOT} | cut -c 16-)"
		)
	fi

	cmake_src_configure
}

src_test() {
	use valgrind && ewarn "Testing with valgrind may likely fail."
	cd "${BUILD_DIR}" || die
	use jit && unit_tests/check_clamav || die
	cmake_src_test
}

src_install() {
	cmake_src_install
	# init scripts
	newinitd "${FILESDIR}/clamd.initd" clamd
	newinitd "${FILESDIR}/freshclam.initd" freshclam
	use clamonacc \
		&& newinitd "${FILESDIR}/clamonacc.initd" clamonacc
	use milter \
		&& newinitd "${FILESDIR}/clamav-milter.initd" clamav-milter

	if ! use libclamav-only ; then
		if use systemd ; then
			# The tmpfiles entry is behind USE=systemd because the
			# upstream OpenRC service files should (and do) ensure that
			# the directories they need exist and have the correct
			# permissions without the help of opentmpfiles. There are
			# years-old root exploits in opentmpfiles, the design is
			# fundamentally flawed, and the maintainer is not up to
			# the task of fixing it.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav.conf"
			systemd_newunit "${FILESDIR}/clamd_at.service-0.104.0" "clamd@.service"
			systemd_dounit "${FILESDIR}/clamd.service"
			systemd_newunit "${FILESDIR}/freshclamd.service-r1" \
				"freshclamd.service"
		fi

		if use clamapp ; then
			# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
			sed \
				-e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(LocalSocket .*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
				-e "s:^\#\(LogTime\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/clamd.conf.sample > \
				"${ED}"/etc/clamav/clamd.conf || die

			sed \
				-e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(DatabaseOwner .*\)/\1/" \
				-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:" \
				-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/freshclam.conf.sample > \
				"${ED}"/etc/clamav/freshclam.conf || die

			if use milter ; then
				# Note: only keep the "unix" ClamdSocket and MilterSocket!
				sed \
					-e "s:^\(Example\):\# \1:" \
					-e "s/^#\(PidFile .*\)/\1/" \
					-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
					-e "s/^#\(User .*\)/\1/" \
					-e "s/^#\(MilterSocket unix:.*\)/\1/" \
					-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
					"${ED}"/etc/clamav/clamav-milter.conf.sample > \
					"${ED}"/etc/clamav/clamav-milter.conf || die

				systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" clamav-milter.service
			fi

			local i
			for i in clamd freshclam clamav-milter
			do
				if [[ -f "${ED}"/etc/"${i}".conf.sample ]] ; then
					mv "${ED}"/etc/"${i}".conf{.sample,} || die
				fi
			done

			# These both need to be writable by the clamav user.
			# TODO: use syslog by default; that's what it's for.
			diropts -o clamav -g clamav
			keepdir /var/lib/clamav
			keepdir /var/log/clamav
		fi
	fi

	if use doc ; then
		local HTML_DOCS=( docs/html/. )
		einstalldocs
	fi

	# Don't install man pages for utilities we didn't install
	if use libclamav-only ; then
		rm -r "${ED}"/usr/share/man || die
	fi

	find "${ED}" -name '*.la' -delete || die

	# Some rustc/rustfft references in libclamav.so.11.0.0
	LCNR_TAG="cargo_third_party"
	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	lcnr_install_files

	# ecompress/unxz is being stupid
	mv "${S}/COPYING/COPYING.lzma"{,_} || die

	LCNR_TAG="${PN}"
	LCNR_SOURCE="${S}"
	lcnr_install_files
}

pkg_postinst() {
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process clamav.conf
		fi
	fi
	if use milter ; then
einfo
einfo "For simple instructions how to setup the clamav-milter read the"
einfo "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
einfo
	fi
	local databases=( "${EROOT}"/var/lib/clamav/main.c[lv]d )
	if [[ ! -f "${databases}" ]] ; then
ewarn
ewarn "You must run freshclam manually to populate the virus database before"
ewarn "starting clamav for the first time."
ewarn
	fi
	if ! systemd_is_booted ; then
ewarn
ewarn "This version of ClamAV provides separate OpenRC services for clamd,"
ewarn "freshclam, clamav-milter, and clamonacc. The clamd service now starts"
ewarn "only the clamd daemon itself. You should add freshclam (and perhaps"
ewarn "clamav-milter) to any runlevels that previously contained clamd."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  LICENSE-variable-changes, update-jit-for-llvm-14-to-15
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.1.0 (20230610)
# USE="clamapp jit test -clamonacc -custom-cflags (-debug) -doc -experimental
# -libclamav-only -man -milter -r1 -rar (-selinux) -systemd -valgrind"
#    Start 1: libclamav
#    Start 2: libclamav_rust
#    Start 3: clamscan
#    Start 4: clamd
#1/6 Test #3: clamscan .........................   Passed   28.09 sec
#    Start 5: freshclam
#2/6 Test #4: clamd ............................   Passed   30.49 sec
#    Start 6: sigtool
#3/6 Test #6: sigtool ..........................   Passed    4.70 sec
#4/6 Test #1: libclamav ........................   Passed   38.91 sec
#5/6 Test #2: libclamav_rust ...................   Passed   48.10 sec
#6/6 Test #5: freshclam ........................   Passed   37.72 sec
#
#100% tests passed, 0 tests failed out of 6
#
#Total Test time (real) =  65.85 sec
