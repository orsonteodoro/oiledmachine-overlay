# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# IMPORTANT:  The ${FILESDIR}/node-multiplexer-v* must be updated each time a new major version is introduced.

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit bash-completion-r1 flag-o-matic pax-utils python-any-r1 \
	toolchain-funcs xdg-utils
DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE+=" cpu_flags_x86_sse2 debug doc icu inspector lto npm +snapshot +ssl
+system-ssl systemtap test"
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
	dns
	domain
	es
	esm
	es
	events
	fs
	http
	http2
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
		system-ssl? ( ssl )
		${PN}_pgo_trainers_module? ( inspector )
"
RESTRICT="!test? ( test )"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date: Oct 11, 2021
NGHTTP2_V="1.41.0"
RDEPEND+=" !net-libs/nodejs:0
	app-eselect/eselect-nodejs
	>=app-arch/brotli-1.0.9
	>=dev-libs/libuv-1.42.0:=
	>=net-dns/c-ares-1.17.2
	>=net-libs/http-parser-2.9.4:=
	>=net-libs/nghttp2-${NGHTTP2_V}
	>=sys-libs/zlib-1.2.11
	icu? ( >=dev-libs/icu-67.1:= )
	system-ssl? (
		>=dev-libs/openssl-1.1.1l:0=
		<dev-libs/openssl-3.0.0_beta1:0=
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	sys-apps/coreutils
	pgo? ( ${PN}_pgo_trainers_http2? ( >=net-libs/nghttp2-${NGHTTP2_V}[utils] ) )
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )"
PATCHES=( "${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
	  "${FILESDIR}"/${PN}-12.20.1-fix_ppc64_crashes.patch
	  "${FILESDIR}"/${PN}-12.22.1-jinja_collections_abc.patch
	  "${FILESDIR}"/${PN}-12.22.1-uvwasi_shared_libuv.patch
	  "${FILESDIR}"/${PN}-12.22.5-shared_c-ares_nameser_h.patch
	  "${FILESDIR}"/${PN}-99999999-llhttp.patch )
S="${WORKDIR}/node-v${PV}"
NPM_V="6.14.15" # See https://github.com/nodejs/node/blob/v12.22.6/deps/npm/package.json

# The following are locked for deterministic builds.  Bump if vulnerability encountered.
AUTOCANNON_V="7.4.0"
WRK_V="1.2.1"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if use lto; then
			if tc-is-gcc; then
				if [[ $(gcc-major-version) -ge 11 ]]; then
					# Bug #787158
					die "LTO builds of ${PN} using gcc-11+ currently fail tests and produce runtime errors. Either switch to gcc-10 or unset USE=lto for this ebuild"
				fi
			else
				# configure.py will abort on this later if we do not
				die "${PN} only supports LTO for gcc"
			fi
		fi
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup

	einfo "The ${SLOT_MAJOR}.x series will be End Of Life (EOL) on 2022-04-30."

	# For man page reasons
	for v in 14 16 ; do
		if use npm && has_version "net-libs/nodejs:${v}[npm]" ; then
			die \
"You need to disable npm on net-libs/nodejs:${v}[npm].  Only enable\n\
npm on the highest slot."
		fi
		if use man && has_version "net-libs/nodejs:${v}[man]" ; then
			die \
"You need to disable npm on net-libs/nodejs:${v}[man].  Only enable\n\
man on the highest slot."
		fi
	done

	for u in ${PN}_pgo_trainers_http ; do
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

src_prepare() {
	tc-export CC CXX PKG_CONFIG
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

	sed -i -e "/'-O3'/d" common.gypi node.gypi || die

	# Known-to-fail test of a deprecated, legacy HTTP parser. Just don't bother.
	rm -f test/parallel/test-http-transfer-encoding-smuggling-legacy.js

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi

	default
}

src_configure() { :; }

configure_pgx() {
	emake clean
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*' \
		'-fprofile*'

	local myconf=(
		--shared-brotli
		--shared-cares
		--shared-http-parser
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)
	use debug && myconf+=( --debug )
	use lto && myconf+=( --enable-lto )
	use icu && myconf+=( --with-intl=system-icu ) || myconf+=( --with-intl=none )
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	if use pgo ; then
		einfo "Forcing GCC for PGO"
		export CC=${CHOST}-gcc
		export CXX=${CHOST}-g++
		export LD=ld.bfd
		export AR=ar
		export NM=nm
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
}

build_pgx() {
	emake -C out mksnapshot
	pax-mark m "out/${BUILDTYPE}/mksnapshot"
	emake -C out
}

init_local_npm() {
	if use ${PN}_pgo_trainers_http ; then
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

	if (( $(find "${S}/out" -name "*.gcda" | wc -l) == 0 )) ; then
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
	if [[ "${PGO_PHASE}" == "pgi" ]] ; then
		emake DESTDIR="${D}" install
	else
		default
	fi

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
		dodir /etc/npm

		# Install bash completion for `npm`
		# We need to temporarily replace default config path since
		# npm otherwise tries to write outside of the sandbox
		local npm_config="${REL_D_BASE}/node_modules/npm/lib/config/core.js"
		sed -i -e "s|'/etc'|'${ED}/etc'|g" "${ED}/${npm_config}" || die
		local tmp_npm_completion_file="$(TMPDIR="${T}" mktemp -t npm.XXXXXXXXXX)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm
		sed -i -e "s|'${ED}/etc'|'/etc'|g" "${ED}/${npm_config}" || die

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
	elog "The global npm config lives in /etc/npm. This deviates slightly"
	elog "from upstream which otherwise would have it live in /usr/etc/."
	elog ""
	elog "Protip: When using node-gyp to install native modules, you can"
	elog "avoid having to download extras by doing the following:"
	elog "$ node-gyp --nodedir /usr/include/node <command>"

	if has '>=net-libs/nodejs-${PV}' ; then
		einfo \
"Found higher slots, manually change the headers with \`eselect nodejs\`."
	else
		eselect nodejs set node${SLOT_MAJOR}
	fi
	cp "${FILESDIR}/node-multiplexer-v4" "${EROOT}/usr/bin/node" || die
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
