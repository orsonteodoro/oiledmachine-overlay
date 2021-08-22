# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# IMPORTANT:  The node-multiplexer-v2 must be updated each time a new major version is introduced.

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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE+=" cpu_flags_x86_sse2 debug doc +icu inspector lto npm pax-kernel +snapshot
+ssl system-icu +system-ssl systemtap test"
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
REQUIRED_USE+=" || ( $(gen_iuse_pgo) )"

REQUIRED_USE+=" inspector? ( icu ssl )
		npm? ( ssl )
		system-icu? ( icu )
		system-ssl? ( ssl )"
RESTRICT="!test? ( test )"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date:  Aug 10, 2021
NGHTTP2_V="1.42.0"
RDEPEND+=" !net-libs/nodejs:0
	app-eselect/eselect-nodejs
	>=app-arch/brotli-1.0.9
	>=dev-libs/libuv-1.42.0:=
	>=net-dns/c-ares-1.17.2
	>=net-libs/nghttp2-${NGHTTP2_V}
	>=sys-libs/zlib-1.2.11
	system-icu? ( >=dev-libs/icu-69.1:= )
	system-ssl? (
		>=dev-libs/openssl-1.1.1k:0=
		<dev-libs/openssl-3.0.0_beta1:0=
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	sys-apps/coreutils
	pgo? ( ${PN}_pgo_trainers_http2? ( >=net-libs/nghttp2-${NGHTTP2_V}[utils] ) )
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )
	pax-kernel? ( sys-apps/elfix )"
PATCHES=( "${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
	  "${FILESDIR}"/${PN}-12.22.1-jinja_collections_abc.patch
	  "${FILESDIR}"/${PN}-12.22.1-uvwasi_shared_libuv.patch
	  "${FILESDIR}"/${PN}-12.22.5-shared_c-ares_nameser_h.patch
	  "${FILESDIR}"/${PN}-14.15.0-fix_ppc64_crashes.patch )
S="${WORKDIR}/node-v${PV}"
NPM_V="6.14.14" # See https://github.com/nodejs/node/blob/v14.17.5/deps/npm/package.json

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

	einfo "The ${SLOT_MAJOR}.x series will be End Of Life (EOL) on 2023-04-30."

	# For man page reasons
	for v in 12 16 ; do
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

	for u in ${PN}_pgo_trainers_http ${PN}_pgo_trainers_https ; do
                if use "${u}" && has network-sandbox $FEATURES ; then
eerror
eerror "The ${u} USE flag requires FEATURES=\"-network-sandbox\" to be able to"
eerror "download wrk to generate PGO profiles for that USE flag."
eerror
                        die
                fi
	done

	use pgo && ewarn "The pgo USE flag is a Work In Progress (WIP)."
}

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

	sed -i -e "/'-O3'/d" common.gypi node.gypi || die

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

	default
}

src_configure() { :; }

configure_pgx() {
	emake clean
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*'

	local myconf=(
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)
	use debug && myconf+=( --debug )
	use lto && myconf+=( --enable-lto )
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
		einfo "Forcing GCC for PGO"
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		LD=ld.bfd
		if [[ "${PGO_PHASE}" == "pgi" ]] ; then
			myconf+=( --enable-pgo-generate )
		elif [[ "${PGO_PHASE}" == "pgo" ]] ; then
			myconf+=( --enable-pgo-use )
		fi
	fi
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

	if use pgo ; then
		# Force a deterministic location.
		sed -i -e "s|fprofile-generate|fprofile-generate=${S}|g" \
			-e "s|fprofile-use|fprofile-use=${S}|g" \
			common.gypi || die
	fi

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		$(use_with systemtap dtrace) \
		"${myconf[@]}" || die
}

build_pgx() {
	emake -C out
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

	init_pgo
	init_local_npm
	for b in ${accepted[@]} ; do
		einfo "Running benchmark ${b}"
		if [[ "${b}" =~ ^benchmark/http/ \
			|| "${b}" =~ ^benchmark/https/ ]] ; then
			if which autocannon ; then
				node "${b}" benchmarker=h2load || die
			else
				node "${b}" benchmarker=wrk || die
			fi
		elif [[ "${b}" =~ ^benchmark/http2/ ]] ; then
			node "${b}" benchmarker=h2load || die
		else
			node "${b}" || die
		fi
	done
}

init_pgo() {
	export NODE_PATH="${S}/opt/Release"
	export PATH="${S}/out/Release:${S}/deps/npm/bin:${HOME}/.npm-global/bin:${PATH}"
}

init_local_npm() {
	mkdir -p "${HOME}/.npm-global" || die
	npm config set prefix "${HOME}/.npm-global" || die
	source "${HOME}/.profile" || die
	ln -fs "${S}/deps" "${S}/out/Release" || die
	if use ${PN}_pgo_trainers_http || use ${PN}_pgo_trainers_https ; then
		mkdir -p "${S}/out/Release/wrk" || die
		cd "${S}/out/Release/wrk" || die
		npm install wrk || die
	fi
}

src_compile() {
	if use pgo ; then
		PGO_PHASE="pgi"
		configure_pgx
		build_pgx
		run_trainers
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
	default

	mv "${ED}"/usr/bin/node{,${SLOT_MAJOR}} || die
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
	if has '>=net-libs/nodejs-${PV}' ; then
		einfo \
"Found higher slots, manually change the headers with \`eselect nodejs\`."
	else
		eselect nodejs set node${SLOT_MAJOR}
	fi
	cp "${FILESDIR}/node-multiplexer-v3" "${EROOT}/usr/bin/node" || die
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
