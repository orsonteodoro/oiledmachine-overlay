# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# IMPORTANT:  The ${FILESDIR}/node-multiplexer-v* must be updated each time a new major version is introduced.
# For ebuild delayed removal safety track "security release" : https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V16.md

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit bash-completion-r1 flag-o-matic ninja-utils pax-utils python-any-r1 \
	toolchain-funcs xdg-utils
DESCRIPTION="A JavaScript runtime built on the V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SRC_URI="https://github.com/nodejs/node/archive/refs/tags/v${PV}.tar.gz
	-> node-v${PV}.tar.gz"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE+=" corepack cpu_flags_x86_sse2 -custom-optimization debug doc +icu inspector lto npm
pax-kernel +snapshot +ssl system-icu +system-ssl systemtap test"
IUSE+=" man pgo"

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
	for t in ${BENCHMARK_TYPES[@]} ; do
		echo " ${PN}_pgo_trainers_${t}"
	done
}
IUSE+=" "$(gen_iuse_pgo)

gen_required_use_pgo() {
	for t in ${BENCHMARK_TYPES[@]} ; do
		echo " ${PN}_pgo_trainers_${t}? ( pgo )"
	done
}
REQUIRED_USE+=" "$(gen_required_use_pgo)
REQUIRED_USE+=" pgo? ( || ( $(gen_iuse_pgo) ) )"

REQUIRED_USE+=" inspector? ( icu ssl )
		npm? ( ssl )
		system-icu? ( icu )
		system-ssl? ( ssl )
		${PN}_pgo_trainers_module? ( inspector )
"
RESTRICT="!test? ( test ) mirror"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date:  May 31, 2022
NGHTTP2_V="1.47.0"
RDEPEND+=" !net-libs/nodejs:0
	app-eselect/eselect-nodejs
	>=app-arch/brotli-1.0.9
	>=dev-libs/libuv-1.43.0:=
	>=net-dns/c-ares-1.18.1
	>=net-libs/nghttp2-${NGHTTP2_V}
	>=sys-libs/zlib-1.2.11
	system-icu? ( >=dev-libs/icu-70.1:= )
	system-ssl? ( >=dev-libs/openssl-1.1.1o:0= )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-util/ninja
	sys-apps/coreutils
	virtual/pkgconfig
	pgo? ( ${PN}_pgo_trainers_http2? ( >=net-libs/nghttp2-${NGHTTP2_V}[utils] ) )
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )
	pax-kernel? ( sys-apps/elfix )"
PATCHES=( "${FILESDIR}"/${PN}-16.12.0-jinja_collections_abc.patch
	  "${FILESDIR}"/${PN}-12.22.5-shared_c-ares_nameser_h.patch
	  "${FILESDIR}"/${PN}-15.2.0-global-npm-config.patch
	  "${FILESDIR}"/${PN}-16.13.2-use-thinlto.patch
	  "${FILESDIR}"/${PN}-16.13.2-support-clang-pgo.patch )
if [[ -d "${WORKDIR}/node-v${PV}" ]] ; then
S="${WORKDIR}/node-v${PV}"
else
S="${WORKDIR}/node-${PV}"
fi
NPM_V="8.11.0" # See https://github.com/nodejs/node/blob/v16.15.1/deps/npm/package.json

# The following are locked for deterministic builds.  Bump if vulnerability encountered.
AUTOCANNON_V="7.4.0"
WRK_V="1.2.1"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."
	# Already applied 6ca785b
}

pkg_setup() {
	python-any-r1_pkg_setup

	einfo "The ${SLOT_MAJOR}.x series will be End Of Life (EOL) on 2024-04-30."

	# For man page reasons
	for s in 12 14 18 ; do
		if use corepack && has_version "net-libs/nodejs:${s}[corepack]" ; then
eerror
eerror "You need to disable corepack on net-libs/nodejs:${s}[corepack].  Only enable"
eerror "corepack on the highest slot."
eerror
			die
		fi
		if use npm && has_version "net-libs/nodejs:${s}[npm]" ; then
eerror
eerror "You need to disable npm on net-libs/nodejs:${s}[npm].  Only enable"
eerror "npm on the highest slot."
eerror
			die
		fi
		if use man && has_version "net-libs/nodejs:${s}[man]" ; then
eerror
eerror "You need to disable npm on net-libs/nodejs:${s}[man].  Only enable"
eerror "man on the highest slot."
eerror
		fi
	done

	for u in ${PN}_pgo_trainers_http ${PN}_pgo_trainers_https ; do
                if use "${u}" && has network-sandbox $FEATURES ; then
eerror
eerror "The ${u} USE flag requires FEATURES=\"-network-sandbox\" to be able to"
eerror "download wrk to generate PGO profiles for that USE flag."
eerror
                        die
                fi
	done

	if use ${PN}_pgo_trainers_string_decoder \
		&& [[ ! ( "${NODEJS_EXCLUDED_BENCHMARKS}" =~ "benchmark/string_decoder/string-decoder.js" ) ]] ; then
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
}

LTO_TYPE="none"
src_prepare() {
	tc-export AR CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	# -O3 removal breaks _FORITIFY_SOURCE
	if use custom-optimization ; then
		if is-flag -O0; then
			ewarn "Using -O0 may disable _FORITIFY_SOURCE lowering security"
			use pgo && ewarn "Using -O0 with PGO is uncommon"
			sed -i -e "s|'-O3'|'-O0'|g" common.gypi node.gypi || die
		elif is-flag -O1; then
			use pgo && ewarn "Using -O1 with PGO is uncommon"
			sed -i -e "s|'-O3'|'-O1'|g" common.gypi node.gypi || die
		elif is-flag -O2; then
			use pgo && ewarn "Using -O2 with PGO is uncommon"
			sed -i -e "s|'-O3'|'-O2'|g" common.gypi node.gypi || die
		elif is-flag -O3; then
			sed -i -e "s|'-O3'|'-O3'|g" common.gypi node.gypi || die
		elif is-flag -O4; then
			sed -i -e "s|'-O3'|'-O4'|g" common.gypi node.gypi || die
		elif is-flag -Ofast; then
			sed -i -e "s|'-O3'|'-Ofast'|g" common.gypi node.gypi || die
		elif is-flag -Os; then
			use pgo && ewarn "Using -Os with PGO is uncommon"
			sed -i -e "s|'-O3'|'-Os'|g" common.gypi node.gypi || die
		elif is-flag -Oz; then
			use pgo && ewarn "Using -Oz with PGO is uncommon"
			sed -i -e "s|'-O3'|'-Oz'|g" common.gypi node.gypi || die
		fi
	fi

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
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
		# llvm-nm: error: : --format value should be one of: bsd, posix, sysv, darwin, just-symbols
		einfo "Detected llvm-nm: -f p -> -f posix"
		sed -i -e "s|nm -gD -f p |nm -gD -f posix |g" "deps/npm/node_modules/node-gyp/gyp/pylib/gyp/generator/ninja.py" || die
		sed -i -e "s|nm -gD -f p |nm -gD -f posix |g" "tools/gyp/pylib/gyp/generator/ninja.py" || die
	fi

	# Save before using filter-flag
	if is-flag -flto=thin; then
		LTO_TYPE="thin"
	elif is-flag -flto; then
		LTO_TYPE="full"
	fi

	default
}

src_configure() { :; }

configure_pgx() {
	export ENINJA_BUILD_DIR="out/"$(usex debug "Debug" "Release")
	[[ "${PGO_PHASE}" == "pgo" ]] && eninja -C ${ENINJA_BUILD_DIR} -t clean
	xdg_environment_reset

	local myconf=(
		--ninja
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)
	use lto && myconf+=( --enable-lto )
	if use lto && [[ "${LTO_TYPE}" =~ "thin" ]] ; then
		myconf+=( --with-thinlto )
	elif use lto && [[ "${LTO_TYPE}" =~ "full" ]] && has_version "sys-devel/binutils[gold,plugins]" ; then
		myconf+=( --with-goldlto )
	fi

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
	use npm || myconf+=( --without-npm )
	if use pgo ; then
		if [[ "${CC}" =~ "clang" ]] ; then
			ewarn "PGO clang support is experimental"
		fi
		export PGO_PROFILE_DIR="${T}/pgo-${ABI}"
		export PGO_PROFILE_PROFDATA="${T}/pgo-${ABI}/pgo-custom.profdata"
		mkdir -p "${PGO_PROFILE_DIR}" || die
		if [[ "${PGO_PHASE}" == "pgo" && "${CC}" =~ "clang" ]] ; then
			# The "counter overflow" is either a discared result or a saturated max value.
			einfo "Converting .profraw -> .profdata"
			llvm-profdata merge -output="${T}/pgo-${ABI}/pgo-custom.profdata" \
				"${T}/pgo-${ABI}" || die
		fi
		if [[ "${PGO_PHASE}" == "pgi" ]] ; then
			myconf+=( --enable-pgo-generate )
		elif [[ "${PGO_PHASE}" == "pgo" ]] ; then
			myconf+=( --enable-pgo-use )
		fi
	fi

	autofix_flags

	use snapshot || myconf+=( --without-node-snapshot )
	if use ssl; then
		use system-ssl && myconf+=( --shared-openssl --openssl-use-def-ca-store )
	else
		myconf+=( --without-ssl )
	fi

	local myarch=""
	case ${ABI} in
		amd64) myarch="x64";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		ppc64) myarch="ppc64";;
		x32) myarch="x32";;
		x86) myarch="ia32";;
		*) myarch="${ABI}";;
	esac

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		$(use_with systemtap dtrace) \
		"${myconf[@]}" || die

	# Prevent double build on install.
	sed -i -e "s|^install: all|install: |g" \
		Makefile || die

	# Prevent build failure
#/usr/bin/*-ld: /usr/lib/llvm/14/bin/../../../../lib/clang/14.0.0/lib/linux/libclang_rt.cfi-*.a(cfi.cpp.o): .preinit_array section is not allowed in DSO
#/usr/bin/*-ld: failed to set dynamic section sizes: nonrepresentable section on output
	if [[ -e "${S}/out/Release/obj/test_crypto_engine.ninja" ]] ; then
		einfo "Removing CFI Cross-DSO from test_crypto_engine"
		sed -i -e "s|-fsanitize-cfi-cross-dso||g" "${S}/out/Release/obj/test_crypto_engine.ninja" || die
		sed -i -e "s|-fsanitize-cfi-cross-dso||g" "${S}/out/Debug/obj/test_crypto_engine.ninja" || die
	fi
}

build_pgx() {
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
			npm install wrk@${WRK_V} || die
			mkdir -p "${S}/node_modules/.bin" || die
			cat > "${S}/node_modules/.bin/wrk" <<EOF
#!/bin/bash
node "${S}/node_modules/wrk/index.js" "\${@}"
EOF
			chmod +x "${S}/node_modules/.bin/wrk" || die
		elif [[ "${DEFAULT_BENCHMARKER}" == "autocannon" ]] ; then
			mkdir -p "${S}/node_modules/autocannon" || die
			cd "${S}/node_modules/autocannon" || die
			npm install autocannon@${AUTOCANNON_V} || die
		fi
	fi
}

run_trainers() {
	local benchmark=( $(grep -l -r -e "createBenchmark" "benchmark" | sort) )
	unset accepted
	declare -A accepted
	for t in ${BENCHMARK_TYPES[@]} ; do
		for b in ${benchmark[@]} ; do
			if use "${PN}_pgo_trainers_${t}" \
				&& [[ "${b}" =~ ^benchmark/${t}/ ]] ; then
				accepted["${b//\//_}"]="${b}"
			fi
		done
	done

	[[ ! -e "${S}/out/Release/node" ]] && die "Missing node"

	export NODE_PATH="${S}/node_modules/wrk:${ED}/usr/$(get_libdir)/node_modules"
	export PATH="${ED}/usr/bin:${ED}/usr/$(get_libdir)/node_modules/npm/bin:${S}/node_modules/.bin:${PATH}"
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/http/_chunky_http_client.js" # This needs additional args.
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/http2/write.js" # Unhandled exception error node:events:371
	NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/net/net-pipe.js" # benchmark/common.js:238 throw new Error('called end() with operation count <= 0');
	use ${PN}_pgo_trainers_module \
		|| NODEJS_EXCLUDED_BENCHMARKS+=" benchmark/module/module-loader.js"
	einfo "NODEJS_EXCLUDED_BENCHMARKS=${NODEJS_EXCLUDED_BENCHMARKS}"
	init_local_npm
	cd "${S}" || die # Ensure PGO profiles are from this dir.
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

	if [[ -z "${CC}" || "${CC}" =~ "gcc" ]] \
		&& (( $(find "${S}/out" -name "*.gcda" | wc -l) == 0 )) ; then
		die "No PGO data produced."
	fi
	if [[ "${CC}" =~ "clang" ]] \
		&& (( $(find "${T}/pgo-${ABI}" -name "*.profraw" | wc -l) == 0 )) ; then
		die "No PGO data produced."
	fi
}

pgi_wipe() {
	rm -rf "${ED}" || die
}

pgi_install() {
	einfo "Installing sandboxed PGI image"
	src_install
}

src_compile() {
	if use pgo ; then
		PGO_PHASE="pgi"
		configure_pgx
		build_pgx
		pgi_install
		run_trainers
		pgi_wipe
		PGO_PHASE="pgo"
		configure_pgx
		build_pgx
	else
		configure_pgx
		build_pgx
	fi
}

src_install() {
	local REL_D_BASE="usr/$(get_libdir)"
	local D_BASE="/${REL_D_BASE}"
	local ED_BASE="${ED}/${REL_D_BASE}"

	${EPYTHON} tools/install.py install "${D}" "${EPREFIX}/usr" || die

	mv "${ED}"/usr/bin/node{,${SLOT_MAJOR}} || die
	if [[ "${PGO_PHASE}" == "pgi" ]] ; then
		dosym node${SLOT_MAJOR} /usr/bin/node
	fi
	pax-mark -m "${ED}"/usr/bin/node${SLOT_MAJOR}

	# set up a symlink structure that node-gyp expects..
	local D_INCLUDE_BASE="/usr/include/node${SLOT_MAJOR}"
	dodir ${D_INCLUDE_BASE}/deps/{v8,uv}
	dosym . ${D_INCLUDE_BASE}/src
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

	if use npm; then
		keepdir /etc/npm

		# Install bash completion for `npm`
		local tmp_npm_completion_file="$(TMPDIR="${T}" mktemp -t npm.XXXXXXXXXX)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm

		if use man ; then
			# Move man pages
			doman "${D_BASE}"/node_modules/npm/man/man{1,5,7}/*
		fi

		# Clean up
		for f in \
			"${ED_BASE}"/node_modules/npm/{.mailmap,.npmignore,Makefile} \
			"${ED_BASE}"/node_modules/npm/{doc,html,man} ; do
			if [[ -e "${f}" ]] ; then
				rm -vrf "${f}" || die
			fi
		done

		local find_exp="-or -name"
		local find_name=()
		for match in "AUTHORS*" "CHANGELOG*" "CONTRIBUT*" "README*" \
			".travis.yml" ".eslint*" ".wercker.yml" ".npmignore" \
			"*.md" "*.markdown" "*.bat" "*.cmd"; do
			find_name+=( ${find_exp} "${match}" )
		done

		# Remove various development and/or inappropriate files and
		# useless docs of dependend packages.
		find "${ED_BASE}"/node_modules \
			\( -type d -name examples \) -or \( -type f \( \
				-iname "LICEN?E*" \
				"${find_name[@]}" \
			\) \) -exec rm -rf "{}" \;
	fi

	mv "${ED}"/usr/share/doc/node "${ED}"/usr/share/doc/${PF} || die

	if use systemtap ; then
		# Move tapset to avoid conflict
		mv "${ED}/usr/share/systemtap/tapset/"node${,${SLOT_MAJOR}}.stp || die
	else
		rm "${ED}/usr/share/systemtap/tapset/node.stp" || die
	fi

	if ! use corepack ; then
		# Prevent collisions
		rm -rf "${ED}/usr/$(get_libdir)/node_modules/corepack" || die
		rm -rf "${ED}/usr/bin/corepack" || die
	fi
}

src_test() {
	if has usersandbox ${FEATURES}; then
		rm -f "${S}"/test/parallel/test-fs-mkdir.js
		ewarn "You are emerging ${PN} with 'usersandbox' enabled. Excluding tests known to fail in this mode." \
			"For full test coverage, emerge =${CATEGORY}/${PF} with 'FEATURES=-usersandbox'."
	fi

	out/${BUILDTYPE}/cctest || die
	"${EPYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
}

pkg_postinst() {
	if has_version ">=net-libs/nodejs-${PV}" ; then
		einfo \
"Found higher slots, manually change the headers with \`eselect nodejs\`."
	else
		eselect nodejs set node${SLOT_MAJOR}
	fi
	cp "${FILESDIR}/node-multiplexer-v5" "${EROOT}/usr/bin/node" || die
	chmod 0755 /usr/bin/node || die
	chown root:root /usr/bin/node || die
	grep -q -F "NODE_VERSION" "${EROOT}/usr/bin/node" || die "Wrapper did not copy."
	einfo
	einfo "When compiling with nodejs multislot, you to switch via"
	einfo "\`eselect nodejs\` in order to compile against the headers"
	einfo "matching the corresponding SLOT.  This means that you cannot"
	einfo "compile with different SLOTS simultaneously."
	einfo
}
