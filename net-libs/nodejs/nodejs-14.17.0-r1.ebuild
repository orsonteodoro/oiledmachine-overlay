# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
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
IUSE+=" cpu_flags_x86_sse2 debug doc +icu inspector lto npm pax_kernel +snapshot \
+ssl system-icu +system-ssl systemtap test"
IUSE+=" man"
REQUIRED_USE+=" inspector? ( icu ssl )
		npm? ( ssl )
		system-icu? ( icu )
		system-ssl? ( ssl )"
RESTRICT="test"
# Keep versions in sync with deps folder
# nodejs uses Chromium's zlib not vanilla zlib
# Last deps commit date: May 8, 2021
RDEPEND+=" !net-libs/nodejs:0
	app-eselect/eselect-nodejs
	>=app-arch/brotli-1.0.9
	>=dev-libs/libuv-1.41.0:=
	>=net-dns/c-ares-1.17.1
	>=net-libs/nghttp2-1.42.0
	>=sys-libs/zlib-1.2.11
	system-icu? ( >=dev-libs/icu-68.2:= )
	system-ssl? ( >=dev-libs/openssl-1.1.1k:0= )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	sys-apps/coreutils
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )
	pax_kernel? ( sys-apps/elfix )"
PATCHES=( "${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
	  "${FILESDIR}"/${PN}-12.22.1-jinja_collections_abc.patch
	  "${FILESDIR}"/${PN}-12.22.1-uvwasi_shared_libuv.patch
	  "${FILESDIR}"/${PN}-14.15.0-fix_ppc64_crashes.patch
	  "${FILESDIR}"/${PN}-14.16.1-v8_icu69.patch )
S="${WORKDIR}/node-v${PV}"
NPM_V="6.14.13" # See https://github.com/nodejs/node/blob/v14.16.1/deps/npm/package.json

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

	einfo "This ebuild is End Of Life (EOL) as of 2023-04-30."

	# For man page reasons
	if has 'net-libs/nodejs[npm]:10' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:10.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[npm]:12' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:12.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[npm]:15' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:15.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[npm]:16' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:16.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:10' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:10.  Only enable\n\
man on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:12' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:12.  Only enable\n\
man on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:15' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:15.  Only enable\n\
man on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:16' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:16.  Only enable\n\
man on the highest slot."
	fi
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
	use pax_kernel && PATCHES+=( "${FILESDIR}"/${PN}-13.8.0-paxmarking.patch )

	# All this test does is check if the npm CLI produces warnings of any sort,
	# failing if it does. Overkill, much? Especially given one possible warning
	# is that there is a newer version of npm available upstream (yes, it does
	# use the network if available), thus making it a real possibility for this
	# test to begin failing one day even though it was fine before.
	rm -f test/parallel/test-release-npm.js

	default
}

src_configure() {
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
		rm "${ED_BASE}"/node_modules/npm/{.mailmap,.npmignore,Makefile} || die
		rm -rf "${ED_BASE}"/node_modules/npm/{doc,html,man} || die

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
	"${EPYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
}

pkg_postinst() {
	if has '>=net-libs/nodejs-${PV}' ; then
		einfo \
"Found higher slots, manually change the headers with \`eselect nodejs\`."
	else
		eselect nodejs set node${SLOT_MAJOR}
	fi
	cp "${FILESDIR}/node-multiplexer-v2" "${EROOT}/usr/bin/node" || die
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
