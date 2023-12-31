# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# IMPORTANT:  The ${FILESDIR}/node-multiplexer-v* must be updated each time a new major version is introduced.
# For ebuild delayed removal safety track "security release" : https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V16.md

EAPI=8

CONFIG_CHECK="~ADVISE_SYSCALLS"
TPGO_CONFIGURE_DONT_SET_FLAGS=1
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="threads(+)"
inherit bash-completion-r1 flag-o-matic flag-o-matic-om linux-info ninja-utils
inherit pax-utils python-any-r1 check-linker lcnr toolchain-funcs uopts
inherit xdg-utils
DESCRIPTION="A JavaScript runtime built on the V8 JavaScript engine"
LICENSE="
	Apache-1.1
	Apache-2.0
	Artistic-2
	BSD
	BSD-2
	icu-70.1
	ISC
	MIT
	Unicode-DFS-2016
	ZLIB
	ssl? (
		openssl
	)
"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos"
HOMEPAGE="https://nodejs.org/"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"

BENCHMARK_TYPES=(
	assert
	async_hooks
	buffers
	child_process
	cluster
	custom
	crypto
	dgram
	diagnostics_channel
	dns
	domain
	error
	es
	esm
	es
	events
	fs
	http
	http2
	https
	misc
	module
	net
	os
	path
	perf_hooks
	policy
	process
	querystring
	streams
	string_decoder
	timers
	tls
	url
	util
	v8
	vm
	worker
	zlib
)

gen_iuse_pgo() {
	local t
	for t in ${BENCHMARK_TYPES[@]} ; do
		echo " ${PN}_pgo_trainers_${t}"
	done
}

IUSE+="
acorn +corepack cpu_flags_x86_sse2 -custom-optimization debug doc +icu inspector
npm mold pax-kernel +snapshot +ssl system-icu +system-ssl systemtap test

$(gen_iuse_pgo)
man pgo r9
"

gen_required_use_pgo() {
	local t
	for t in ${BENCHMARK_TYPES[@]} ; do
		echo " ${PN}_pgo_trainers_${t}? ( pgo )"
	done
}
REQUIRED_USE+="
	$(gen_required_use_pgo)
	${PN}_pgo_trainers_module? (
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
RESTRICT="!test? ( test )"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date:  Aug 8, 2023
ACORN_PV="8.8.0"
COREPACK_PV="0.17.0"
NGHTTP2_PV="1.47.0"
RDEPEND+="
	!net-libs/nodejs:0
	>=app-arch/brotli-1.0.9
	>=app-eselect/eselect-nodejs-20230521
	>=dev-libs/libuv-1.44.0:=
	>=net-dns/c-ares-1.19.1
	>=net-libs/nghttp2-${NGHTTP2_PV}
	>=sys-libs/zlib-1.2.11
	system-icu? (
		>=dev-libs/icu-71.1:=
	)
	system-ssl? (
		>=dev-libs/openssl-1.1.1v:0=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/ninja
	sys-apps/coreutils
	virtual/pkgconfig
	pax-kernel? (
		sys-apps/elfix
	)
	pgo? (
		${PN}_pgo_trainers_http2? (
			>=net-libs/nghttp2-${NGHTTP2_PV}[utils]
		)
	)
	systemtap? (
		dev-util/systemtap
	)
	test? (
		net-misc/curl
	)
"
SRC_URI="
https://github.com/nodejs/node/archive/refs/tags/v${PV}.tar.gz
	-> node-v${PV}.tar.gz
"
PDEPEND+="
	sys-apps/npm:2
	acorn? (
		=dev-nodejs/acorn-$(ver_cut 1-2 ${ACORN_PV})*
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-16.12.0-jinja_collections_abc.patch"
	"${FILESDIR}/${PN}-12.22.5-shared_c-ares_nameser_h.patch"
	"${FILESDIR}/${PN}-15.2.0-global-npm-config.patch"
	"${FILESDIR}/${PN}-16.13.2-lto-update.patch"
	"${FILESDIR}/${PN}-16.13.2-support-clang-pgo.patch"
	"${FILESDIR}/${PN}-19.3.0-v8-oflags.patch"
)
if [[ -d "${WORKDIR}/node-v${PV}" ]] ; then
	S="${WORKDIR}/node-v${PV}"
else
	S="${WORKDIR}/node-${PV}"
fi
NPM_PV="8.19.3" # See https://github.com/nodejs/node/blob/v16.20.2/deps/npm/package.json

# The following are locked for deterministic builds.  Bump if vulnerability encountered.
AUTOCANNON_PV="7.4.0"
WRK_PV="1.2.1"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."
	# Already applied 6ca785b
}

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

pkg_setup() {
	python-any-r1_pkg_setup
	linux-info_pkg_setup

# See https://github.com/nodejs/release#release-schedule
# See https://github.com/nodejs/release#end-of-life-releases
einfo
einfo "The ${SLOT_MAJOR}.x series will be End Of Life (EOL) on 2023-09-11."
einfo

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
	for u in ${PN}_pgo_trainers_http ${PN}_pgo_trainers_https ; do
                if use "${u}" && has network-sandbox $FEATURES ; then
eerror
eerror "The ${u} USE flag requires FEATURES=\"\${FEATURES} -network-sandbox\""
eerror "to be able to download to generate PGO profiles for that USE flag."
eerror
                        die
                fi
	done

	if use ${PN}_pgo_trainers_string_decoder \
		&& [[ ! ( "${NODEJS_EXCLUDED_BENCHMARKS}" =~ \
			"benchmark/string_decoder/string-decoder.js" ) ]] ; then
ewarn
ewarn "The benchmark/string_decoder/string-decoder.js may take hours to"
ewarn "complete.  Consider adding it to the NODEJS_EXCLUDED_BENCHMARKS"
ewarn "per-package envvar set."
ewarn
	fi

	if use ${PN}_pgo_trainers_path ; then
ewarn
ewarn "The benchmark/path/resolve-win32.js may not reflect typical usage."
ewarn "Consider adding it to the NODEJS_EXCLUDED_BENCHMARKS."
ewarn
	fi
	uopts_setup
}

is_flagq_last() {
	local flag="${1}"
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|g|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
einfo "CFLAGS:\t${CFLAGS}"
einfo "olast:\t${olast}"
	[[ "${flag}" == "${olast}" ]] && return 0
	return 1
}

LTO_TYPE="none"
src_prepare() {
	default
	tc-export AR CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# Fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# Less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# Proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	local FP=(
		$(grep -l -r -e "-O3" $(find deps/openssl -name "*.gn*" -o -name "*gyp*"))
		common.gypi
		deps/llhttp/common.gypi
		deps/uv/common.gypi
		node.gypi
	)

	# -O3 removal breaks _FORITIFY_SOURCE
	local a1="-O3"
	local r1="-O2"
	local a2="-O2"
	local r2="-O3"
	if use custom-optimization ; then
		local oflag="-O3"
		if is_flagq_last '-O0'; then
			ewarn "Using -O0 may disable _FORITIFY_SOURCE lowering security"
			oflag="-O0"
		elif is_flagq_last '-Og'; then
			use pgo && ewarn "Using -Og with PGO is uncommon"
			oflag="-Og"
		elif is_flagq_last '-O1'; then
			use pgo && ewarn "Using -O1 with PGO is uncommon"
			oflag="-O1"
		elif is_flagq_last '-O2'; then
			use pgo && ewarn "Using -O2 with PGO is uncommon"
			oflag="-O2"
		elif is_flagq_last '-O3'; then
			oflag="-O3"
		elif is_flagq_last '-O4'; then
			oflag="-O4"
		elif is_flagq_last '-Ofast'; then
			oflag="-Ofast"
		elif is_flagq_last '-Os'; then
			use pgo && ewarn "Using -Os with PGO is uncommon"
			oflag="-Os"
		elif is_flagq_last '-Oz'; then
			use pgo && ewarn "Using -Oz with PGO is uncommon"
			oflag="-Oz"
		#else
		#	-O3 is the upstream default
		fi
		sed -i -e "s|-O3|${oflag}|g" ${FP[@]} || die
		a1="${oflag}"
		a2="${oflag}"
	fi
	sed -i \
		-e "s|__OFLAGS_A1__|${a1}|g" \
		-e "s|__OFLAGS_R1__|${r1}|g" \
		-e "s|__OFLAGS_A2__|${a2}|g" \
		-e "s|__OFLAGS_R2__|${r2}|g" \
		tools/v8_gypfiles/toolchain.gypi \
		|| die

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" \
			tools/install.py \
			|| die
		BUILDTYPE=Debug
	fi

	# We need to disable mprotect on two files when it builds Bug 694100.
	use pax-kernel && PATCHES+=( "${FILESDIR}"/${PN}-13.8.0-paxmarking.patch )

	# All this test does is check if the npm CLI produces warnings of any sort,
	# failing if it does. Overkill, much? Especially given one possible warning
	# is that there is a newer version of npm available upstream (yes, it does
	# use the network if available), thus making it a real possibility for this
	# test to begin failing one day even though it was fine before.
	rm -f test/parallel/test-release-npm.js

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
einfo
einfo "Converting .profraw -> .profdata"
einfo
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

_src_configure() {
	export ENINJA_BUILD_DIR="out/"$(usex debug "Debug" "Release")
	uopts_src_configure
	xdg_environment_reset

	# Ban only for this slot for license compatibility reasons.
	filter-flags "-fuse-ld=mold"

	local myconf=(
		--ninja
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)

	[[ "${LTO_TYPE}" =~ "lto" ]] && myconf+=( --enable-lto )
	[[ "${LTO_TYPE}" =~ "thinlto" ]] && myconf+=( --with-thinlto )
	[[ "${LTO_TYPE}" =~ "goldlto" ]] && myconf+=( --with-goldlto )

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*' \
		'-fuse-ld*' \
		'-fprofile*'

	filter-flags '-O*'
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
		use system-ssl && \
		myconf+=( --shared-openssl --openssl-use-def-ca-store )
	else
		myconf+=( --without-ssl )
	fi

	local myarch
	myarch="${ABI/amd64/x64}"
	myarch="${myarch/x86/ia32}"
	[[ "${ARCH}:${ABI}" =~ "riscv:lp64" ]] && myarch="riscv64"

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		$(use_with systemtap dtrace) \
		"${myconf[@]}" || die

	# Prevent double build on install.
	sed -i -e "s|^install: all|install: |g" Makefile || die

	# Prevent build failure
#/usr/bin/*-ld:
# libclang_rt.cfi-*.a(cfi.cpp.o): .preinit_array section is not allowed in DSO
# failed to set dynamic section sizes: nonrepresentable section on output
	if [[ -e "${S}/out/Release/obj/test_crypto_engine.ninja" ]] ; then
		einfo "Removing CFI Cross-DSO from test_crypto_engine"
		sed -i -e "s|-fsanitize-cfi-cross-dso||g" \
			"${S}/out/Release/obj/test_crypto_engine.ninja" || die
		sed -i -e "s|-fsanitize-cfi-cross-dso||g" \
			"${S}/out/Debug/obj/test_crypto_engine.ninja" || die
	fi
}

_src_compile() {
	eninja -C ${ENINJA_BUILD_DIR}
}

init_local_npm() {
	if use ${PN}_pgo_trainers_http || use ${PN}_pgo_trainers_https ; then
		DEFAULT_BENCHMARKER="autocannon" # \
		# Upstream uses wrk by default but autocannon does typical npm downloads.
		if [[ "${DEFAULT_BENCHMARKER}" == "wrk" ]] ; then
			# FIXME:  Problems with benchmark script when using wrk.
			mkdir -p "${S}/node_modules/wrk" || die
			cd "${S}/node_modules/wrk" || die
			npm install wrk@${WRK_PV} || die
			mkdir -p "${S}/node_modules/.bin" || die
			cat > "${S}/node_modules/.bin/wrk" <<EOF
#!${EPREFIX}/bin/bash
node "${S}/node_modules/wrk/index.js" "\${@}"
EOF
			chmod +x "${S}/node_modules/.bin/wrk" || die
		elif [[ "${DEFAULT_BENCHMARKER}" == "autocannon" ]] ; then
			mkdir -p "${S}/node_modules/autocannon" || die
			cd "${S}/node_modules/autocannon" || die
			npm install autocannon@${AUTOCANNON_PV} || die
		fi
	fi
}

train_trainer_custom() {
	local benchmark=( $(grep -l -r -e "createBenchmark" "benchmark" | sort) )
	unset accepted
	declare -A accepted
	local t
	local b
	for t in ${BENCHMARK_TYPES[@]} ; do
		for b in ${benchmark[@]} ; do
			if use "${PN}_pgo_trainers_${t}" \
				&& [[ "${b}" =~ ^benchmark/${t}/ ]] ; then
				accepted["${b//\//_}"]="${b}"
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
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/http/_chunky_http_client.js"

	# Unhandled exception error node:events:371
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/http2/write.js"

	# benchmark/common.js:238 throw new Error('called end() with operation count <= 0');
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/net/net-pipe.js"

	use ${PN}_pgo_trainers_module \
		|| NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/module/module-loader.js"
	einfo "NODEJS_EXCLUDED_BENCHMARKS=${NODEJS_EXCLUDED_BENCHMARKS}"
	init_local_npm
	cd "${S}" || die # Ensure PGO profiles are from this dir.
	local b
	for b in $(echo ${accepted[@]} | tr " " "\n" | sort) ; do
		if [[ "${NODEJS_EXCLUDED_BENCHMARKS}" =~ "${b}" ]] ; then
			einfo "Skipping ${b}"
			continue
		fi
		einfo "Running benchmark ${b}"
		benchmark_failed_message() {
eerror
eerror "A possibly broken or incomplete support for the ${b} script was"
eerror "encountered.  Add NODEJS_EXCLUDED_BENCHMARKS=\"${b}\" as a space"
eerror "separated list.  See metadata.xml for details."
eerror
			die
		}
		# autocannon likes to fail randomly
		local tries=1
		local fail=0
		while (( ${tries} <= 3 && ( ${fail} == 1 || ${tries} == 1 ) )) ; do
			fail=0
			if [[ "${b}" =~ ^benchmark/http/ \
				|| "${b}" =~ ^benchmark/https/ ]] ; then
				if which autocannon 2>/dev/null 1>/dev/null ; then
					node "${b}" benchmarker=autocannon \
						|| fail=1
				else
					node "${b}" benchmarker=wrk \
						|| fail=1
				fi
			elif [[ "${b}" =~ ^benchmark/http2/ ]] ; then
				node "${b}" benchmarker=h2load \
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
		chown portage:portage pgo-custom-trainer.sh || die
		chmod +x pgo-custom-trainer.sh || die
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
	LCNR_SOURCE="${S}"
	lcnr_install_files

	local REL_D_BASE="usr/$(get_libdir)"
	local D_BASE="/${REL_D_BASE}"
	local ED_BASE="${ED}/${REL_D_BASE}"

	${EPYTHON} tools/install.py install "${D}" "${EPREFIX}/usr" || die

	mv "${ED}"/usr/bin/node{,${SLOT_MAJOR}} || die
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		dosym node${SLOT_MAJOR} /usr/bin/node
	fi
	pax-mark -m "${ED}"/usr/bin/node${SLOT_MAJOR}

	# set up a symlink structure that node-gyp expects..
	local D_INCLUDE_BASE="/usr/include/node${SLOT_MAJOR}"
	dodir ${D_INCLUDE_BASE}/deps/{v8,uv}
	dosym . ${D_INCLUDE_BASE}/src
	local var
	for var in deps/{uv,v8}/include; do
		dosym ../.. ${D_INCLUDE_BASE}/${var}
	done

	# Avoid merge conflict
	mv "${ED}/usr/include/node/"* "${ED}${D_INCLUDE_BASE}" || die
	rm -rf "${ED}/usr/include/node" || die

	if use doc; then
		docinto html
		dodoc -r "${S}"/doc/*
	fi

	if ! use man ; then
		rm -rf "${ED}//usr/share/man/man1/node.1"* || die
	fi

	# Use tarball instead.
	rm -rf "${ED}/usr/$(get_libdir)/node_modules/npm"
	rm -rf "${ED}/usr/bin/npm"
	rm -rf "${ED}/usr/bin/npx"

	mv "${ED}"/usr/share/doc/node "${ED}"/usr/share/doc/${PF} || die

	if use systemtap ; then
		# Move tapset to avoid conflict
		mv "${ED}/usr/share/systemtap/tapset/"node${,${SLOT_MAJOR}}.stp || die
	else
		rm "${ED}/usr/share/systemtap/tapset/node.stp" || die
	fi

	# Let eselect-nodejs handle switching corepack
	dodir /usr/$(get_libdir)/corepack
	mv \
		"${ED}/usr/$(get_libdir)/node_modules/corepack" \
		"${ED}/usr/$(get_libdir)/corepack/node${SLOT_MAJOR}" \
		|| die
	rm -rf "${ED}/usr/bin/corepack"

	uopts_src_install
}

src_test() {
	if has usersandbox ${FEATURES}; then
		rm -f "${S}"/test/parallel/test-fs-mkdir.js
ewarn
ewarn "You are emerging ${PN} with 'usersandbox' enabled. Excluding tests known"
ewarn "to fail in this mode.  For full test coverage, emerge =${CATEGORY}/${PF}"
ewarn "with 'FEATURES=-usersandbox'."
ewarn
	fi

	out/${BUILDTYPE}/cctest || die
	"${EPYTHON}" \
		tools/test.py \
		--mode=${BUILDTYPE,,} \
		--flaky-tests=dontcare \
		-J \
		message \
		parallel \
		sequential \
		|| die
}

pkg_postinst() {
	if has_version ">=net-libs/nodejs-${PV}" ; then
einfo
einfo "Found higher slots, manually change the headers with \`eselect nodejs\`."
einfo
	else
		eselect nodejs set node${SLOT_MAJOR}
	fi
	cp "${FILESDIR}/node-multiplexer-v8" "${EROOT}/usr/bin/node" || die
	sed -i -e "s|__EPREFIX__|${EPREFIX}|g" "${EROOT}/usr/bin/node" || die
	chmod 0755 /usr/bin/node || die
	chown root:root /usr/bin/node || die
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
