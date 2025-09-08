# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# IMPORTANT:  The ${FILESDIR}/node-multiplexer-v* must be updated each time a new major version is introduced.
# For ebuild delayed removal safety track "security release" : https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V20.md

# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib

# Last deps commit date:  Jun 11, 2025

ACORN_PV="8.14.0"
AUTOCANNON_PV="7.4.0" # The following are locked for deterministic builds.  Bump if vulnerability encountered.
CFLAGS_HARDENED_PIE="1"
CFLAGS_HARDENED_USE_CASES="jit language-runtime network security-critical server untrusted-data web-server"
CFLAGS_HARDENED_VTABLE_VERIFY="0" # It may break during build.
TRAINER_TYPES=(
	abort_controller
	assert
	async_hooks
	blob
	buffers
	child_process
	cluster
	crypto
	custom
	dgram
	diagnostics_channel
	dns
	domain
	error
	es
	esm
	events
	fs
	http
	http2
	https
	mime
	misc
	module
	napi
	net
	os
	path
	perf_hooks
	permission
	policy
	process
	querystring
	readline
	streams
	string_decoder
	test_runner
	timers
	tls
	ts
	url
	util
	v8
	validators
	vm
	websocket
	webstreams
	worker
	zlib
)
COREPACK_PV="0.32.0"
LTO_TYPE="none" # Global var
MULTIPLEXER_VER="11"
NGHTTP2_PV="1.60.0"
NPM_PV="10.8.2" # See https://github.com/nodejs/node/blob/v20.19.4/deps/npm/package.json
PYTHON_COMPAT=( "python3_"{11..13} ) # See configure
PYTHON_REQ_USE="threads(+)"
TPGO_CONFIGURE_DONT_SET_FLAGS=1
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
WRK_PV="1.2.1" # The following are locked for deterministic builds.  Bump if vulnerability encountered.

inherit bash-completion-r1 cflags-hardened check-compiler-switch check-linker flag-o-matic
inherit flag-o-matic-om lcnr linux-info multiprocessing ninja-utils pax-utils
inherit python-any-r1 sandbox-changes toolchain-funcs uopts xdg-utils

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/node-v${PV}"
SRC_URI="
https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz
"

DESCRIPTION="A JavaScript runtime built on the V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="
	Apache-1.1
	Apache-2.0
	Artistic-2
	BSD
	BSD-2
	icu-71.1
	ISC
	MIT
	Unicode-DFS-2016
	ZLIB
	ssl? (
		Apache-2.0
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
gen_iuse_pgo() {
	local t
	for t in ${TRAINER_TYPES[@]} ; do
		echo " ${PN}_trainers_${t}"
	done
}

IUSE+="
$(gen_iuse_pgo)
acorn +asm +corepack cpu_flags_x86_sse2 debug doc fips +icu
inspector +npm man mold pax-kernel pgo +snapshot +ssl system-icu +system-ssl
test
ebuild_revision_46
"

gen_required_use_pgo() {
	local t
	for t in ${TRAINER_TYPES[@]} ; do
		echo " ${PN}_trainers_${t}? ( pgo )"
	done
}
REQUIRED_USE+="
	$(gen_required_use_pgo)
	${PN}_trainers_module? (
		inspector
	)
	corepack
	inspector? (
		icu
		ssl
	)
	npm? (
		corepack
	)
	system-icu? (
		icu
	)
	system-ssl? (
		ssl
	)
"
RDEPEND+="
	!net-libs/nodejs:0
	>=app-arch/brotli-1.1.0
	>=app-eselect/eselect-nodejs-20230521
	>=dev-libs/libuv-1.47.0:=
	>=net-dns/c-ares-1.34.5
	>=net-libs/nghttp2-${NGHTTP2_PV}
	>=sys-libs/zlib-1.3
	sys-kernel/mitigate-id
	system-icu? (
		>=dev-libs/icu-77.1:=
	)
	system-ssl? (
		>=dev-libs/openssl-3.0.15:0[asm?,fips?]
		dev-libs/openssl:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-build/ninja
	sys-apps/coreutils
	virtual/pkgconfig
	mold? (
		>=sys-devel/mold-2.0
	)
	pax-kernel? (
		sys-apps/elfix
	)
	pgo? (
		${PN}_trainers_http2? (
			>=net-libs/nghttp2-${NGHTTP2_PV}[utils]
		)
	)
	test? (
		net-misc/curl
	)
"
PDEPEND+="
	sys-apps/npm:3
	acorn? (
		>=dev-nodejs/acorn-$(ver_cut 1-2 ${ACORN_PV})
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-12.22.5-shared_c-ares_nameser_h.patch"
	"${FILESDIR}/${PN}-22.2.0-global-npm-config.patch"
	"${FILESDIR}/${PN}-20.18.0-lto-update.patch"
	"${FILESDIR}/${PN}-20.1.0-support-clang-pgo.patch"
	"${FILESDIR}/${PN}-19.3.0-v8-oflags.patch"
	"${FILESDIR}/${PN}-23.5.0-split-pointer-compression-and-v8-sandbox-options.patch"
	"${FILESDIR}/${PN}-20.18.1-add-v8-jit-fine-grained-options.patch"
)

_count_useflag_slots() {
	local useflag="${1}"
	local tot=0
	local x
	for x in $(seq 14 20) ; do
		has_version "net-libs/nodejs:${x}[${useflag}]" \
			&& tot=$(( ${tot} + 1 ))
	done
	echo "${tot}"
}

_print_merge_useflag_conflicts() {
	local useflag="${1}"
	local x
	for x in $(seq 14 20) ; do
		has_version "net-libs/nodejs:${x}[${useflag}]" \
			&& eerror "net-libs/nodejs:${x}[${useflag}]"
	done
}

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."
	# Already applied 6ca785b
}

check_kernel_config() {
	use kernel_linux || return
	linux-info_pkg_setup
	CONFIG_CHECK="~ADVISE_SYSCALLS"
	WARNING_ADVISE_SYSCALLS="CONFIG_ADVISE_SYSCALLS is required for madvise() support."
	check_extra_config

	CONFIG_CHECK="
		~TRANSPARENT_HUGEPAGE
	"
	WARNING_TRANSPARENT_HUGEPAGE="CONFIG_TRANSPARENT_HUGEPAGE could be enabled for V8 [JavaScript engine] memory access time reduction.  For webservers, music production, realtime; it should be kept disabled."

	if use fips ; then
		CONFIG_CHECK+="
			~CRYPTO_FIPS
		"
		WARNING_CRYPTO_FIPS="CONFIG_CRYPTO_FIPS needs to be enabled for FIPS compliance."
	fi

	check_extra_config
}

pkg_setup() {
einfo "FEATURES:  ${FEATURES}"
	check-compiler-switch_start
	python-any-r1_pkg_setup
	check_kernel_config

# See https://github.com/nodejs/release#release-schedule
# See https://github.com/nodejs/release#end-of-life-releases
einfo "The ${SLOT_MAJOR}.x series will be End Of Life (EOL) on 2026-04-30."

	# Prevent merge conflicts
	if use man && (( $(_count_useflag_slots "man") > 1 ))
	then
eerror
eerror "You need to disable man on all except one of the following:"
eerror
		_print_merge_useflag_conflicts "man"
eerror
		die
	fi

	local u
	for u in ${PN}_trainers_http ${PN}_trainers_https ; do
                if use "${u}" && has network-sandbox $FEATURES ; then
			sandbox-changes_no_network_sandbox "For USE=${u} to download and to generate PGO profile"
                fi
	done

	if [[ -n "${NODEJS_EXCLUDED_BENCHMARKS}" ]] ; then
eerror
eerror "NODEJS_EXCLUDED_BENCHMARKS has been renamed to NODEJS_EXCLUDED_TRAINERS."
eerror "Please update your /etc/portage/make.conf or package.env."
eerror
		die
	fi

	if use ${PN}_trainers_string_decoder \
		&& [[ ! ( "${NODEJS_EXCLUDED_TRAINERS}" =~ \
			"benchmark/string_decoder/string-decoder.js" ) ]] ; then
ewarn
ewarn "The benchmark/string_decoder/string-decoder.js may take hours to"
ewarn "complete.  Consider adding it to the NODEJS_EXCLUDED_TRAINERS"
ewarn "per-package envvar set."
ewarn
	fi

	if use ${PN}_trainers_path ; then
ewarn
ewarn "The benchmark/path/resolve-win32.js may not reflect typical usage."
ewarn "Consider adding it to the NODEJS_EXCLUDED_TRAINERS."
ewarn
	fi
	uopts_setup
}

src_prepare() {
	default
	tc-export AR CC CXX PKG_CONFIG
	export V=1
	export CONFIGURATION="Release"

	# Fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i \
		-e "/append('-arch/d" \
		"tools/gyp/pylib/gyp/xcode_emulation.py" \
		|| die

	# Proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i \
		-e "s|lib/|${LIBDIR}/|g" \
		"tools/install.py" \
		|| die
	sed -i \
		-e "s/'lib'/'${LIBDIR}'/" \
		"deps/npm/lib/npm.js" \
		|| die

	# Avoid writing a depfile, not useful
	sed -i \
		-e "/DEPFLAGS =/d" \
		"tools/gyp/pylib/gyp/generator/make.py" \
		|| die

	local FP=(
		$(grep -l -r -e "-O3" \
			$(find "deps/openssl" \
				\( \
					-name "*.gn*" \
					-o \
					-name "*.gyp" \
				\) \
			) \
		)
		"common.gypi"
		"deps/llhttp/common.gypi"
		"deps/uv/common.gypi"
		"node.gypi"
	)

# With -O1:
#../../deps/ada/ada.cpp:10664:34: error: inlining failed in call to 'always_inline' 'constexpr bool ada::unicode::is_alnum_plus(char) noexcept': indirect function call with a yet undetermined callee
#10664 | ada_really_inline constexpr bool is_alnum_plus(const char c) noexcept {
#      |                                  ^~~~~~~~~~~~~
	#
	# Limit to -O2 to prevent the 2.3x performance penalty when adding
	# -fno-* flags to unbreak -D_FORTIFY_SOURCE checks at -O3. When using
	# -O2 with -fno-* set, the performance penalty is 1.16x.
	#
	# Upstream does not like -O3 when running sanitizers (aka fuzz-testing)
	#

	# Similar to replace-flags F2 F1 in sanitizers off case:
	local f1="-O2"
	local f2="-O3"

	# Similar to replace-flags F4 F3 in sanitizer on case:
	local f3="-O2"
	local f4="-O3"

	replace-flags '-Ofast' '-O2'
	replace-flags '-O4' '-O2'
	replace-flags '-O3' '-O2'
	replace-flags '-O2' '-O2'
	replace-flags '-Os' '-O2'
	replace-flags '-Oz' '-O2'
	replace-flags '-O1' '-O2'
	replace-flags '-O0' '-O2'
	if ! is-flagq "-O2" ; then
	# Add fallback flag.
	# Default to performance.
	# GCC/Clang default to -O0
		append-flags '-O2'
	fi
	local oflag
	if use debug ; then
		oflag="-O0"
		replace-flags '-O*' '-O0'
		append-flags -ggdb3
		append-cppflags -DDEBUG
	else
		oflag="-O2"
	fi
	f1="${oflag}"
	f3="${oflag}"
	sed -i -e "s|-O3|${oflag}|g" ${FP[@]} || die
	sed -i -e "s|-O3|${oflag}|g" "common.gypi" || die
	sed -i \
		-e "s|__OFLAGS_F1__|${f1}|g" \
		-e "s|__OFLAGS_F2__|${f2}|g" \
		-e "s|__OFLAGS_F3__|${f3}|g" \
		-e "s|__OFLAGS_F4__|${f4}|g" \
		"tools/v8_gypfiles/toolchain.gypi" \
		|| die

	# For debug builds, change install path; remove optimisations and override CONFIGURATION.
	if use debug ; then
		sed -i \
			-e "s|out/Release|out/Debug|g" \
			"tools/install.py" \
			|| die
		CONFIGURATION="Debug"
	fi

	# We need to disable mprotect on two files when it builds Bug 694100.
	use pax-kernel && PATCHES+=( "${FILESDIR}/${PN}-13.8.0-paxmarking.patch" )

	# All this test does is check if the npm CLI produces warnings of any sort,
	# failing if it does. Overkill, much? Especially given one possible warning
	# is that there is a newer version of npm available upstream (yes, it does
	# use the network if available), thus making it a real possibility for this
	# test to begin failing one day even though it was fine before.
	rm -f "test/parallel/test-release-npm.js"

	if [[ "${NM}" == "llvm-nm" ]] ; then
		# llvm-nm: error: : --format value should be one of
		# bsd, posix, sysv, darwin, just-symbols
einfo "Detected llvm-nm: -f p -> -f posix"
		sed -i -e "s|nm -gD -f p |nm -gD -f posix |g" \
			"deps/npm/node_modules/node-gyp/gyp/pylib/gyp/generator/ninja.py" \
			|| die
		sed -i -e "s|nm -gD -f p |nm -gD -f posix |g" \
			"tools/gyp/pylib/gyp/generator/ninja.py" \
			|| die
	fi

	# Save before using filter-flag
	export LTO_TYPE=$(check-linker_get_lto_type)

	uopts_src_prepare
	export PATH_ORIG="${PATH}"
}

src_configure() { :; }

__pgo_configure() {
	if [[ "${CC}" =~ "clang" ]] ; then
ewarn
ewarn "PGO clang support is experimental"
ewarn
	fi
	export PGO_PROFILE_DIR="${T}/pgo-${ABI}"
	export PGO_PROFILE_PROFDATA="${PGO_PROFILE_DIR}/pgo-custom.profdata"
	mkdir -p "${PGO_PROFILE_DIR}" || die
	if [[ "${PGO_PHASE}" == "PGO" && "${CC}" =~ "clang" ]] ; then
# The "counter overflow" is either a discared result or a saturated max value.
einfo "Converting .profraw -> .profdata"
		PATH="/usr/lib/llvm/$(clang-major-version)/bin:${PATH}" \
		llvm-profdata merge \
			-output="${PGO_PROFILE_DIR}/pgo-custom.profdata" \
			"${PGO_PROFILE_DIR}" || die
	fi
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		myconf+=( --enable-pgo-generate )
	elif [[ "${PGO_PHASE}" == "PGO" ]] ; then
		myconf+=( --enable-pgo-use )
	fi
}

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

get_olast() {
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
	echo "${olast}"
}

enable_gdb() {
	if use debug && has_version "dev-debug/gdb" ; then
		echo "--gdb"
	fi
}

# Scale the jit level based on the Oflag.
set_jit_level() {
	_jit_level_0() {
		# ~20%/~50% performance similar to light swap, but a feeling of less progress (20-25%)
		#myconf+=( --disable-gdb )
		#myconf+=( --v8-disable-maglev )
		#myconf+=( --v8-disable-sparkplug )
		#myconf+=( --v8-disable-turbofan )
		myconf+=( --v8-enable-lite-mode )
	}

	_jit_level_1() {
		# 28%/71% performance similar to light swap, but a feeling of more progress (33%)
		myconf+=( $(enable_gdb) )
		#myconf+=( --v8-disable-maglev ) # Requires turbofan
		myconf+=( --v8-enable-sparkplug )
		#myconf+=( --v8-disable-turbofan )
		#myconf+=( --v8-disable-lite-mode )
	}

	_jit_level_2() {
		# > 75% performance
		myconf+=( $(enable_gdb) )
		#myconf+=( --v8-disable-maglev )
		#myconf+=( --v8-disable-sparkplug )
		myconf+=( --v8-enable-turbofan )
		#myconf+=( --v8-disable-lite-mode )
	}

	_jit_level_5() {
		# > 90% performance
		myconf+=( $(enable_gdb) )
		#myconf+=( --v8-disable-maglev )
		myconf+=( --v8-enable-sparkplug )
		myconf+=( --v8-enable-turbofan )
		#myconf+=( --v8-disable-lite-mode )
	}

	_jit_level_6() {
		# 100% performance
		myconf+=( $(enable_gdb) )
	# https://github.com/nodejs/node/blob/v20.18.1/deps/v8/BUILD.gn#L485
		#myconf+=( --v8-disable-maglev ) # %5 runtime benefit; disabled because of pointer-compression conditional
		myconf+=( --v8-enable-sparkplug ) # 5% benefit
		myconf+=( --v8-enable-turbofan ) # Subset of -O1, -O2, -O3; 100% performance
		#myconf+=( --v8-disable-lite-mode )
	}

	local olast=$(get_olast)
	if [[ "${olast}" =~ "-Ofast" ]] ; then
		jit_level=7
	elif [[ "${olast}" =~ "-O3" ]] ; then
		jit_level=6
	elif [[ "${olast}" =~ "-O2" ]] ; then
		jit_level=5
	elif [[ "${olast}" =~ "-Os" ]] ; then
		jit_level=4
	elif [[ "${olast}" =~ "-Oz" ]] ; then
		jit_level=3
	elif [[ "${olast}" =~ "-O1" ]] ; then
		jit_level=2
	elif [[ "${olast}" =~ "-O0" ]] ; then
		jit_level=1
	elif [[ "${olast}" =~ "-O0" ]] ; then
		jit_level=0
	fi

	if [[ -n "${JIT_LEVEL_OVERRIDE}" ]] ; then
		jit_level=${JIT_LEVEL_OVERRIDE}
	fi

	if (( ${jit_level} < 2 )) ; then
einfo "Changing jit_level=${jit_level} to jit_level=2 for WebAssembly."
		jit_level=2
	fi

	local jit_level_desc
	if (( ${jit_level} == 7 )) ; then
		jit_level_desc="fast" # 100%
	elif (( ${jit_level} == 6 )) ; then
		jit_level_desc="3" # 95%
	elif (( ${jit_level} == 5 )) ; then
		jit_level_desc="2" # 90%
	elif (( ${jit_level} == 4 )) ; then
		jit_level_desc="s" # 75%
	elif (( ${jit_level} == 3 )) ; then
		jit_level_desc="z"
	elif (( ${jit_level} == 2 )) ; then
		jit_level_desc="1" # 60 %
	elif (( ${jit_level} == 1 )) ; then
		jit_level_desc="0"
	elif (( ${jit_level} == 0 )) ; then
		jit_level_desc="0" # 5%
	fi

	if (( ${jit_level} >= 6 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
		_jit_level_6
	elif (( ${jit_level} >= 3 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
		_jit_level_5
	elif (( ${jit_level} >= 2 )) ; then
einfo "JIT is similar to -O${jit_level_desc}."
		_jit_level_2
	elif (( ${jit_level} >= 1 )) ; then
einfo "JIT is similar to -O${jit_level_desc} best case."
		_jit_level_1
	else
einfo "JIT off is similar to -O${jit_level_desc} worst case."
		_jit_level_0
	fi
}

_src_configure() {
	local configuration=$(usex debug "Debug" "Release")
	export ENINJA_BUILD_DIR="out/${configuration}"
	uopts_src_configure
	xdg_environment_reset

	local myconf=(
		--ninja
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	else
		[[ "${LTO_TYPE}" =~ "lto"     ]] && myconf+=( --enable-lto )
		[[ "${LTO_TYPE}" =~ "thinlto" ]] && myconf+=( --with-thinlto )
		[[ "${LTO_TYPE}" =~ "goldlto" ]] && myconf+=( --with-goldlto )
		[[ "${LTO_TYPE}" =~ "moldlto" ]] && myconf+=( --with-moldlto )
	fi

	if tc-is-gcc && [[ "${LTO_TYPE}" =~ "moldlto" ]] ; then
ewarn "If moldlto fails for gcc, try clang."
	fi

	# LTO compiler flags are handled by configure.py itself
	filter-flags \
		'-flto*' \
		'-fprofile*' \
		'-fuse-ld*'

	if use mold && [[ "${LTO_TYPE}" == "none" || -z "${LTO_TYPE}" ]] ; then
		append-ldflags -fuse-ld=mold
	fi

	if ! use mold && is-flagq '-fuse-ld=mold' && has_version "sys-devel/mold" ; then
eerror "To use mold, enable the mold USE flag."
		die
	fi

	cflags-hardened_append

	if ! use asm && ! use system-ssl ; then
		myconf+=( --openssl-no-asm )
	fi

	use debug && myconf+=( --debug )
	if use system-icu; then
		myconf+=( --with-intl=system-icu )
	elif use icu; then
		myconf+=( --with-intl=full-icu )
	else
		myconf+=( --with-intl=none )
	fi
	use inspector || myconf+=( --without-inspector )
	myconf+=( --without-npm )
	use pgo && __pgo_configure

	autofix_flags

	use snapshot || myconf+=( --without-node-snapshot )
	if use ssl; then
		if use system-ssl ; then
			myconf+=( --shared-openssl --openssl-use-def-ca-store )
		fi
	else
		myconf+=( --without-ssl )
	fi
	if use fips ; then
		myconf+=( --openssl-is-fips )
	fi
	if [[ -n "${NODEJS_OPENSSL_DEFAULT_LIST_CORE}" ]] ; then
		myconf+=( --openssl-default-cipher-list=${NODEJS_OPENSSL_DEFAULT_LIST_CORE} )
	fi

ewarn "Disabling pointer compression."

ewarn
ewarn "Use --max-old-space-size=4096 or --max-old-space-size=8192 to"
ewarn "NODE_OPTIONS environment variable if out of memory (OOM)."
ewarn
	if use kernel_linux && linux_chkconfig_present "TRANSPARENT_HUGEPAGE" && ! use debug ; then
		myconf+=( --v8-enable-hugepage )
	fi
	set_jit_level

	# Already set in src_prepare()
	filter-flags '-O*'

	local myarch
	myarch="${ABI/amd64/x64}"
	myarch="${myarch/x86/ia32}"
	[[ "${ARCH}:${ABI}" =~ "loong:lp64" ]] && myarch="loong64"
	[[ "${ARCH}:${ABI}" =~ "riscv:lp64" ]] && myarch="riscv64"

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}/usr" \
		--dest-cpu="${myarch}" \
		${myconf[@]} || die

	# Prevent double build on install.
	sed -i -e "s|^install: all|install: |g" "Makefile" || die

	# Prevent build failure
#/usr/bin/*-ld:
# libclang_rt.cfi-*.a(cfi.cpp.o): .preinit_array section is not allowed in DSO
# failed to set dynamic section sizes: nonrepresentable section on output
	if [[ -e "${S}/out/Release/obj/test_crypto_engine.ninja" ]] ; then
einfo "Removing CFI Cross-DSO from test_crypto_engine"
		sed -i \
			-e "s|-fsanitize-cfi-cross-dso||g" \
			"${S}/out/Release/obj/test_crypto_engine.ninja" \
			|| die
		sed -i \
			-e "s|-fsanitize-cfi-cross-dso||g" \
			"${S}/out/Debug/obj/test_crypto_engine.ninja" \
			|| die
	fi
}

_src_compile() {
	eninja -C "${ENINJA_BUILD_DIR}"
}

init_local_npm() {
	if use "${PN}_trainers_http" || use "${PN}_trainers_https" ; then
		DEFAULT_BENCHMARKER="autocannon" # \
		# Upstream uses wrk by default but autocannon does typical npm downloads.
		if [[ "${DEFAULT_BENCHMARKER}" == "wrk" ]] ; then
			# FIXME:  Problems with benchmark script when using wrk.
			mkdir -p "${S}/node_modules/wrk" || die
			cd "${S}/node_modules/wrk" || die
			npm install "wrk@${WRK_PV}" || die
			mkdir -p "${S}/node_modules/.bin" || die
			cat > "${S}/node_modules/.bin/wrk" <<EOF
#!${EPREFIX}/bin/bash
node "${S}/node_modules/wrk/index.js" "\${@}"
EOF
			chmod +x "${S}/node_modules/.bin/wrk" || die
		elif [[ "${DEFAULT_BENCHMARKER}" == "autocannon" ]] ; then
			mkdir -p "${S}/node_modules/autocannon" || die
			cd "${S}/node_modules/autocannon" || die
			npm install "autocannon@${AUTOCANNON_PV}" || die
		fi
	fi
}

train_trainer_custom() {
	local benchmark=(
		$(grep -l -r -e "createBenchmark" "benchmark" \
			| sort)
	)
	unset accepted_trainers
	declare -A accepted_trainers
	local t
	local b
	for t in ${TRAINER_TYPES[@]} ; do
		for b in ${benchmark[@]} ; do
			if use "${PN}_trainers_${t}" \
				&& [[ "${b}" =~ ^"benchmark/${t}/" ]] ; then
				accepted_trainers["${b//\//_}"]="${b}"
			fi
		done
	done

	[[ ! -e "${S}/out/Release/node" ]] && die "Missing node"

	NODE_PATH="${S}/node_modules/wrk"
	NODE_PATH+=":${ED}/usr/$(get_libdir)/node_modules"
	export NODE_PATH
	local _PATH
	_PATH="${ED}/usr/bin"
	_PATH+=":${ED}/usr/$(get_libdir)/node_modules/npm/bin"
	_PATH+=":${S}/node_modules/.bin"
	PATH="${_PATH}:${PATH_ORIG}"
	export PATH

	# This needs additional args.
	NODEJS_EXCLUDED_TRAINERS+=" benchmark/http/_chunky_http_client.js"

	# Unhandled exception error node:events:371
	NODEJS_EXCLUDED_TRAINERS+=" benchmark/http2/write.js"

	# benchmark/common.js:238 throw new Error('called end() with operation count <= 0');
	NODEJS_EXCLUDED_TRAINERS+=" benchmark/net/net-pipe.js"

	if ! use "${PN}_trainers_module" ; then
		NODEJS_EXCLUDED_TRAINERS+=" benchmark/module/module-loader.js"
	fi
einfo "NODEJS_EXCLUDED_TRAINERS=${NODEJS_EXCLUDED_TRAINERS}"
	init_local_npm
	cd "${S}" || die # Ensure PGO profiles are from this dir.
	local b
	for b in $(echo ${accepted_trainers[@]} | tr " " "\n" | sort) ; do
		if [[ "${NODEJS_EXCLUDED_TRAINERS}" =~ "${b}" ]] ; then
einfo "Skipping ${b}"
			continue
		fi
einfo "Running benchmark ${b}"
		benchmark_failed_message() {
eerror
eerror "A possibly broken or incomplete support for the ${b} script was"
eerror "encountered.  Add NODEJS_EXCLUDED_TRAINERS=\"${b}\" as a space"
eerror "separated list.  See metadata.xml for details."
eerror
			die
		}
		# autocannon likes to fail randomly
		local tries=1
		local fail=0
		while (( ${tries} <= 3 && ( ${fail} == 1 || ${tries} == 1 ) )) ; do
			fail=0
			if [[ "${b}" =~ ^"benchmark/http/" \
				|| "${b}" =~ ^"benchmark/https/" ]] ; then
				if which autocannon >/dev/null 2>&1 ; then
					node "${b}" benchmarker="autocannon" \
						|| fail=1
				else
					node "${b}" benchmarker="wrk" \
						|| fail=1
				fi
			elif [[ "${b}" =~ ^"benchmark/http2/" ]] ; then
				node "${b}" benchmarker="h2load" \
					|| fail=1
			else
				node "${b}" \
					|| fail=1
			fi
			if (( ${fail} == 1 && ${tries} < 3 )) ; then
einfo "Benchmark failed.  Trying again."
			fi
			tries=$(( ${tries} + 1 ))
		done
		if (( ${fail} == 1 )) ; then
			benchmark_failed_message
		fi
	done
	if [[ -e "pgo-custom-trainer.sh" ]] ; then
		chown "portage:portage" "pgo-custom-trainer.sh" || die
		chmod +x "pgo-custom-trainer.sh" || die
		./pgo-custom-trainer.sh || die
	fi

	local nlines
	nlines=$(find "${S}/out" -name "*.gcda" | wc -l)
	if [[ -z "${CC}" || "${CC}" =~ "gcc" ]] && (( ${nlines} == 0 )) ; then
		die "No PGO data produced."
	fi
	export PGO_PROFILE_DIR="${T}/pgo-${ABI}"
	nlines=$(find "${PGO_PROFILE_DIR}" -name "*.profraw" | wc -l)
	if [[ "${CC}" =~ "clang" ]] && (( ${nlines} == 0 )) ; then
		die "No PGO data produced."
	fi
}

_src_pre_train() {
einfo "Installing sandboxed PGI image"
	src_install
}

_src_post_train() {
	rm -rf "${ED}" || die
}

src_compile() {
	uopts_src_compile
}

src_install() {
	if use debug && [[ "${FEATURES}" =~ "splitdebug" ]] ; then
		export STRIP="/bin/true"
	fi
	LCNR_SOURCE="${S}"
	lcnr_install_files

	local REL_D_BASE="usr/$(get_libdir)"
	local D_BASE="/${REL_D_BASE}"
	local ED_BASE="${ED}/${REL_D_BASE}"

	${EPYTHON} "tools/install.py" install \
		--dest-dir "${D}" \
		--prefix "${EPREFIX}/usr" \
		|| die

	mv "${ED}/usr/bin/node"{"","${SLOT_MAJOR}"} || die
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		dosym "node${SLOT_MAJOR}" "/usr/bin/node"
	fi
	pax-mark -m "${ED}/usr/bin/node${SLOT_MAJOR}"

	# set up a symlink structure that node-gyp expects..
	local D_INCLUDE_BASE="/usr/include/node${SLOT_MAJOR}"
	dodir "${D_INCLUDE_BASE}/deps/"{"v8","uv"}
	dosym "." "${D_INCLUDE_BASE}/src"
	local var
	for var in "deps/"{"uv","v8"}"/include" ; do
		dosym "../.." "${D_INCLUDE_BASE}/${var}"
	done

	# Avoid merge conflict
	mv "${ED}/usr/include/node/"* "${ED}${D_INCLUDE_BASE}" || die
	rm -rf "${ED}/usr/include/node" || die

	if use doc; then
		docinto html
		dodoc -r "${S}/doc/"*
	fi

	if ! use man ; then
		rm -rf "${ED}//usr/share/man/man1/node.1"* || die
	fi

	# Use tarball instead.
	rm -rf "${ED}/usr/$(get_libdir)/node_modules/npm"
	rm -rf "${ED}/usr/bin/npm"
	rm -rf "${ED}/usr/bin/npx"

	mv \
		"${ED}/usr/share/doc/node" \
		"${ED}/usr/share/doc/${PF}" \
		|| die

	# Let eselect-nodejs handle switching corepack
	dodir "/usr/$(get_libdir)/corepack"
	mv \
		"${ED}/usr/$(get_libdir)/node_modules/corepack" \
		"${ED}/usr/$(get_libdir)/corepack/node${SLOT_MAJOR}" \
		|| die
	rm -rf "${ED}/usr/bin/corepack"

	uopts_src_install
	if use debug && [[ "${FEATURES}" =~ "splitdebug" ]] ; then
		objcopy --only-keep-debug "out/Debug/node" "${T}/node${SLOT_MAJOR}.debug" || die
		exeinto "/usr/lib/debug/usr/bin"
		doexe "${T}/node${SLOT_MAJOR}.debug"
		strip --strip-unneeded "${ED}/usr/bin/node${SLOT_MAJOR}" || die
	fi
}

src_test() {
	if has usersandbox ${FEATURES}; then
		rm -f "${S}/test/parallel/test-fs-mkdir.js"
ewarn
ewarn "You are emerging ${PN} with 'usersandbox' enabled. Excluding tests known"
ewarn "to fail in this mode.  For full test coverage, emerge =${CATEGORY}/${PF}"
ewarn "with 'FEATURES=-usersandbox'."
ewarn
	fi

	"out/${CONFIGURATION}/cctest" || die
	"${EPYTHON}" \
		"tools/test.py" \
		--mode="${CONFIGURATION,,}" \
		--flaky-tests="dontcare" \
		-J \
		message \
		parallel \
		sequential \
		|| die
}

pkg_postinst() {
	if has_version ">=net-libs/nodejs-${PV}" ; then
einfo "Found higher slots, manually change the headers with \`eselect nodejs\`."
	else
		eselect nodejs set "node${SLOT_MAJOR}"
	fi
	cp \
		"${FILESDIR}/node-multiplexer-v${MULTIPLEXER_VER}" \
		"${EROOT}/usr/bin/node" \
		|| die
	sed -i \
		-e "s|__EPREFIX__|${EPREFIX}|g" \
		"${EROOT}/usr/bin/node" \
		|| die
	chmod 0755 "/usr/bin/node" || die
	chown "root:root" "/usr/bin/node" || die
	grep -q -F "NODE_VERSION" "${EROOT}/usr/bin/node" || die "Wrapper did not copy."
einfo
einfo "When compiling with nodejs multislot, you to switch via"
einfo "\`eselect nodejs\` in order to compile against the headers matching the"
einfo "corresponding SLOT.  This means that you cannot compile with different"
einfo "SLOTS simultaneously."
einfo
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot, pgo
