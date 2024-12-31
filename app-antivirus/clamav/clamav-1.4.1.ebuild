# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The lockfile should be updated once a week for security reasons.

# Upstream are working on updating clamav's LLVM bytecode interpreter to work
# with later versions of LLVM, but it's not ready yet. See:
# https://github.com/Cisco-Talos/clamav/issues/581
# This does not impact the ability of the package to build with llvm/clang otherwise.

# LLVM 14 support is complete.
# LLVM 15 support is a Work In Progress (WIP)
# LLVM 16 support is a Work In Progress (WIP)

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.

# See CI for details.
# CI uses U 22.04
# OpenSSL-3 required for license compatibility
# The dev-libs/libmspack version has been lowered in this ebuild.

# rust-bin < 1.71 has an executable stack
# which is not supported on selinux #911589

GENERATE_LOCKFILE=0
MY_P="${P//_/-}"

declare -A GIT_CRATES=(
	[onenote_parser]="https://github.com/Cisco-Talos/onenote.rs;29c08532252b917543ff268284f926f30876bb79;onenote.rs-%commit%" # 0.3.1
)

# From "./convert-cargo-lock.sh 1.4.1 1.4.1"
CRATES="
adler2-2.0.0
adler32-1.2.0
aho-corasick-1.1.3
android-tzdata-0.1.1
android_system_properties-0.1.5
autocfg-1.4.0
base64-0.21.7
bindgen-0.65.1
bit_field-0.10.2
bitflags-1.3.2
bitflags-2.6.0
block-buffer-0.10.4
bumpalo-3.16.0
bytemuck-1.19.0
byteorder-1.5.0
bytes-1.8.0
bzip2-rs-0.1.2
cbindgen-0.25.0
cc-1.1.31
cexpr-0.6.0
cfg-if-1.0.0
chrono-0.4.38
clang-sys-1.8.1
color_quant-1.1.0
core-foundation-sys-0.8.7
cpufeatures-0.2.14
crc32fast-1.4.2
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.20
crunchy-0.2.2
crypto-common-0.1.6
delharc-0.6.1
digest-0.10.7
either-1.13.0
encoding_rs-0.8.35
enum-primitive-derive-0.2.2
errno-0.3.9
exr-1.73.0
fastrand-2.1.1
fdeflate-0.3.6
flate2-1.0.34
generic-array-0.14.7
gif-0.13.1
glob-0.3.1
half-2.4.1
hashbrown-0.12.3
heck-0.4.1
hex-0.4.3
hex-literal-0.4.1
home-0.5.9
iana-time-zone-0.1.61
iana-time-zone-haiku-0.1.2
image-0.24.9
indexmap-1.9.3
inflate-0.4.5
itertools-0.10.5
itoa-1.0.11
jpeg-decoder-0.3.1
js-sys-0.3.72
lazy_static-1.5.0
lazycell-1.3.0
lebe-0.5.2
libc-0.2.161
libloading-0.8.5
linux-raw-sys-0.4.14
log-0.4.22
memchr-2.7.4
minimal-lexical-0.2.1
miniz_oxide-0.8.0
nom-7.1.3
num-complex-0.4.6
num-integer-0.1.46
num-traits-0.2.19
once_cell-1.20.2
paste-1.0.15
peeking_take_while-0.1.2
png-0.17.14
prettyplease-0.2.25
primal-check-0.3.4
proc-macro2-1.0.89
qoi-0.4.1
quote-1.0.37
rayon-1.10.0
rayon-core-1.12.1
regex-1.11.1
regex-automata-0.4.8
regex-syntax-0.8.5
rustc-hash-1.1.0
rustdct-0.7.1
rustfft-6.2.0
rustix-0.38.38
ryu-1.0.18
serde-1.0.214
serde_derive-1.0.214
serde_json-1.0.132
sha1-0.10.6
sha2-0.10.8
shlex-1.3.0
simd-adler32-0.3.7
smallvec-1.13.2
strength_reduce-0.2.4
syn-1.0.109
syn-2.0.85
tempfile-3.13.0
thiserror-1.0.65
thiserror-impl-1.0.65
tiff-0.9.1
tinyvec-1.8.0
toml-0.5.11
transpose-0.2.3
typenum-1.17.0
unicode-ident-1.0.13
unicode-segmentation-1.12.0
uuid-1.11.0
version_check-0.9.5
wasm-bindgen-0.2.95
wasm-bindgen-backend-0.2.95
wasm-bindgen-macro-0.2.95
wasm-bindgen-macro-support-0.2.95
wasm-bindgen-shared-0.2.95
weezl-0.1.8
which-4.4.2
widestring-1.1.0
windows-core-0.52.0
windows-sys-0.52.0
windows-sys-0.59.0
windows-targets-0.52.6
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
zune-inflate-0.2.54
"
CURL_PV="7.68.0"
LLVM_MAX_SLOT=14
PYTEST_PV="7.2.0"
PYTHON_COMPAT=( python3_{10..12} ) # CI uses 3.8

inherit cargo cmake flag-o-matic lcnr llvm python-any-r1 systemd tmpfiles

if ! [[ "${PV}" =~ "_rc" ]] ; then
	KEYWORDS="~amd64 ~arm64 ~arm64-macos"
fi
S="${WORKDIR}/clamav-${MY_P}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
"

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
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
	Unicode-DFS-2016
	Unlicense
	UoI-NCSA
	ZLIB
	|| (
		MIT
		Unlicense
	)
	|| (
		Apache-2.0
		MIT
	)
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

#
#RESTRICT="
#	!test? (
#		test
#	)
#"
SLOT="0/sts"
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
CDEPEND="
	!libclamav-only? (
		>=net-misc/curl-${CURL_PV}
	)
	>=app-arch/bzip2-1.0.8
	>=dev-libs/openssl-1.1.1f:=
	>=dev-libs/json-c-0.15:=
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
		|| (
			llvm-core/llvm:14
		)
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
BDEPEND="
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.9.1
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep ">=dev-python/pytest-${PYTEST_PV}"'[${PYTHON_USEDEP}]')
		valgrind? (
			>=dev-debug/valgrind-3.15.0
		)
	)
	|| (
		(
			>=dev-lang/rust-1.71.0
			dev-lang/rust:=
		)
		(
			>=dev-lang/rust-bin-1.71.0
			dev-lang/rust-bin:=
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
	"${FILESDIR}/extra-patches/${PN}-1.0.0-CMakeLists-allow-llvm16.patch"
	"${FILESDIR}/extra-patches/${PN}-1.0.0-llvm14-noreturn.patch"
	"${FILESDIR}/extra-patches/${PN}-1.0.0-llvm14.patch"
	"${FILESDIR}/extra-patches/${PN}-1.0.0-llvm15.patch"
	"${FILESDIR}/${PN}-1.4.1-pointer-types.patch"
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

	# Uncomment before running convert-cargo-lock.sh
	# Readd comment when done generating cargo list.
	#die

	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
}

src_prepare() {
	cmake_src_prepare
	if ver_test "${LLVM_SLOT}" -ge "16" ; then
einfo "LLVM_SLOT:\t${LLVM_SLOT}"
		eapply "${FILESDIR}/extra-patches/${PN}-1.0.0-llvm16.patch"
		ewarn "JIT is still broken for LLVM 16"
	fi
	if ver_test "${LLVM_SLOT}" -ge "15" ; then
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
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}/etc/clamav"
		-DBYTECODE_RUNTIME=$(usex jit llvm interpreter)
		-DCLAMAV_GROUP="clamav"
		-DCLAMAV_USER="clamav"
		-DDATABASE_DIRECTORY="${EPREFIX}/var/lib/clamav"
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
			-DLLVM_FIND_VERSION="$(best_version llvm-core/llvm:${LLVM_MAX_SLOT} | cut -c 16-)"
		)
	fi

	cmake_src_configure
}

src_test() {
	use valgrind && ewarn "Testing with valgrind may likely fail."
	cd "${BUILD_DIR}" || die
	use jit && "unit_tests/check_clamav" || die
	cmake_src_test
}

src_install() {
	cmake_src_install
	# Init scripts
	newinitd "${FILESDIR}/clamd.initd" "clamd"
	newinitd "${FILESDIR}/freshclam.initd" "freshclam"
	use clamonacc \
		&& newinitd "${FILESDIR}/clamonacc.initd" "clamonacc"
	use milter \
		&& newinitd "${FILESDIR}/clamav-milter.initd" "clamav-milter"

	if ! use libclamav-only ; then
		if use systemd ; then
	# OpenRC services ensure their own permissions, so we can avoid a"
	# dependency on sys-apps/systemd-utils[tmpfiles] here, though we can"
	# change our minds and use it if we want to.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav-r1.conf"
		fi

		if use clamapp ; then
	# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/clamd.pid:" \
				-e "s/^#\(LocalSocket .*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
				-e "s:^\#\(LogTime\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}/etc/clamav/clamd.conf.sample" > \
				"${ED}/etc/clamav/clamd.conf" || die

			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/freshclam.pid:" \
				-e "s/^#\(DatabaseOwner .*\)/\1/" \
				-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:" \
				-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}/etc/clamav/freshclam.conf.sample" > \
				"${ED}/etc/clamav/freshclam.conf" || die

			if use milter ; then
	# Note: only keep the "unix" ClamdSocket and MilterSocket!
				sed -e "s:^\(Example\):\# \1:" \
					-e "s:^\#\(PidFile\) .*:\1 ${EPREFIX}/run/clamav-milter.pid:" \
					-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
					-e "s/^#\(User .*\)/\1/" \
					-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
					"${ED}/etc/clamav/clamav-milter.conf.sample" > \
					"${ED}/etc/clamav/clamav-milter.conf" || die

				systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" "clamav-milter.service"
			fi

			local i
			for i in "clamd" "freshclam" "clamav-milter"
			do
				if [[ -f "${ED}/etc/${i}.conf.sample" ]] ; then
					mv "${ED}/etc/${i}.conf"{".sample",""} || die
				fi
			done

	# These both need to be writable by the clamav user
	# TODO: use syslog by default; that's what it's for.
			diropts -o "clamav" -g "clamav"
			keepdir "/var/lib/clamav"
			keepdir "/var/log/clamav"
		fi
	fi

	if use doc ; then
		local HTML_DOCS=( "docs/html/." )
		einstalldocs
	fi

	# Don't install man pages for utilities we didn't install
	if use libclamav-only ; then
		rm -r "${ED}/usr/share/man" || die
	fi

	find "${ED}" -name '*.la' -delete || die

	# Some rustc/rustfft references in libclamav.so.11.0.0
	LCNR_TAG="cargo_third_party"
	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	lcnr_install_files

	# ecompress/unxz is being stupid
	mv "${S}/COPYING/COPYING.lzma"{"","_"} || die

	LCNR_TAG="${PN}"
	LCNR_SOURCE="${S}"
	lcnr_install_files
}

pkg_postinst() {
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process "clamav-r1.conf"
		fi
	fi
	if use milter ; then
einfo
einfo "For simple instructions how to setup the clamav-milter read the"
einfo "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
einfo
	fi
	local databases=( "${EROOT}/var/lib/clamav/main.c"[lv]"d" )
	if [[ ! -f "${databases}" ]] ; then
einfo
ewarn "You must run freshclam manually to populate the virus database before"
ewarn "starting clamav for the first time."
einfo
	fi

	 if ! systemd_is_booted ; then
ewarn
ewarn "This version of ClamAV provides separate OpenRC services for clamd,"
ewarn "freshclam, clamav-milter, and clamonacc. The clamd service now starts"
ewarn "only the clamd daemon itself. You should add freshclam (and perhaps"
ewarn "clamav-milter) to any runlevels that previously contained clamd."
ewarn
	else
		if [[ -n "${REPLACING_VERSIONS}" ]] && ver_test "${REPLACING_VERSIONS}" -le "1.3.1" ; then
ewarn
ewarn "From 1.3.1-r1 the Gentoo-provided systemd services have been retired in"
ewarn "favour of using the units shipped by upstream.  Ensure that any required"
ewarn "services are configured and started.  clamd@.service has been retired as"
ewarn "part of this transition."
ewarn
		fi
	fi

	if [[ -z ${REPLACING_VERSIONS} ]] && use clamonacc; then
einfo
einfo "'clamonacc' requires additional configuration before it can be enabled,"
einfo "and may not produce any output if not properly configured. Read the"
ewarn "appropriate man page if clamonacc is desired."
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  LICENSE-variable-changes, update-jit-for-llvm-14-to-15
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.1.0 (20230610)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.3.0 (20240305) USE="clamapp jit test -clamonacc -custom-cflags (-debug) -doc -experimental -libclamav-only -man -milter -r1 -rar (-selinux) -system-mspack -systemd -valgrind"

#ctest -j 4 --test-load 4
#Test project /var/tmp/portage/app-antivirus/clamav-1.3.0/work/clamav-clamav-1.3.0_build
#    Start 1: libclamav
#1/6 Test #1: libclamav ........................   Passed   23.50 sec
#    Start 2: libclamav_rust
#2/6 Test #2: libclamav_rust ...................   Passed   37.19 sec
#    Start 3: clamscan
#3/6 Test #3: clamscan .........................   Passed   13.88 sec
#    Start 4: clamd
#4/6 Test #4: clamd ............................   Passed   16.29 sec
#    Start 5: freshclam
#5/6 Test #5: freshclam ........................   Passed   44.84 sec
#    Start 6: sigtool
#6/6 Test #6: sigtool ..........................   Passed    2.49 sec
#
#100% tests passed, 0 tests failed out of 6
#
#Total Test time (real) = 267.33 sec
# * Tests succeeded.
