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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE+=" cpu_flags_x86_sse2 debug doc icu inspector lto npm +snapshot +ssl
+system-ssl systemtap test"
IUSE+=" man"
REQUIRED_USE+=" inspector? ( icu ssl )
		npm? ( ssl )
		system-ssl? ( ssl )"
RESTRICT="!test? ( test )"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date: Aug 10, 2021
RDEPEND+=" !net-libs/nodejs:0
	app-eselect/eselect-nodejs
	>=app-arch/brotli-1.0.9
	>=dev-libs/libuv-1.42.0:=
	>=net-dns/c-ares-1.17.2
	>=net-libs/http-parser-2.9.4:=
	>=net-libs/nghttp2-1.41.0
	>=sys-libs/zlib-1.2.11
	icu? ( >=dev-libs/icu-67.1:= )
	system-ssl? (
		>=dev-libs/openssl-1.1.1k:0=
		<dev-libs/openssl-3.0.0_beta1:0=
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	sys-apps/coreutils
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )"
PATCHES=( "${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
	  "${FILESDIR}"/${PN}-12.20.1-fix_ppc64_crashes.patch
	  "${FILESDIR}"/${PN}-12.22.1-jinja_collections_abc.patch
	  "${FILESDIR}"/${PN}-12.22.1-uvwasi_shared_libuv.patch
	  "${FILESDIR}"/${PN}-12.22.5-shared_c-ares_nameser_h.patch
	  "${FILESDIR}"/${PN}-99999999-llhttp.patch )
S="${WORKDIR}/node-v${PV}"
NPM_V="6.14.14" # See https://github.com/nodejs/node/blob/v12.22.5/deps/npm/package.json

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
		if has_version "net-libs/nodejs:${v}[npm]" ; then
			die \
"You need to disable npm on net-libs/nodejs:${v}[npm].  Only enable\n\
npm on the highest slot."
		fi
		if has_version "net-libs/nodejs:${v}[man]" ; then
			die \
"You need to disable npm on net-libs/nodejs:${v}[man].  Only enable\n\
man on the highest slot."
		fi
	done
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

src_configure() {
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*'

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
}

src_compile() {
	emake -C out mksnapshot
	pax-mark m "out/${BUILDTYPE}/mksnapshot"
	emake -C out
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
	# parallel/test-fs-mkdir is known to fail with FEATURES=usersandbox
	if has usersandbox ${FEATURES}; then
		ewarn "You are emerging ${P} with 'usersandbox' enabled." \
			"Expect some test failures or emerge with 'FEATURES=-usersandbox'!"
	fi

	out/${BUILDTYPE}/cctest || die
	"${PYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
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
