# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"
inherit bash-completion-r1 eutils flag-o-matic pax-utils python-any-r1 toolchain-funcs xdg-utils

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"
SLOT_MAJOR="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJOR}/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE="cpu_flags_x86_sse2 debug doc icu inspector npm +snapshot +ssl +system-ssl systemtap test"
IUSE+=" man"
REQUIRED_USE="
	inspector? ( icu ssl )
	npm? ( ssl )
	system-ssl? ( ssl )"
CDEPEND="!net-libs/nodejs:0
	app-eselect/eselect-nodejs"
# Keep versions in sync with deps folder
RDEPEND="${CDEPEND}
	>=dev-libs/libuv-1.39.0:=
	>=net-dns/c-ares-1.15.0
	>=net-libs/http-parser-2.9.3:=
	>=net-libs/nghttp2-1.41.0
	>=sys-libs/zlib-1.2.11
	icu? ( >=dev-libs/icu-64.2:= )
	system-ssl? ( >=dev-libs/openssl-1.1.1g:0= )"
DEPEND="${CDEPEND}
	${RDEPEND}
	${PYTHON_DEPS}
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )"
PATCHES=(
	"${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
)
RESTRICT="test"
S="${WORKDIR}/node-v${PV}"
NPM_V="6.14.8" # See https://github.com/nodejs/node/blob/v10.23.0/deps/npm/package.json

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	( [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11 ) && \
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
}

pkg_setup() {
	python-any-r1_pkg_setup
	# For man page reasons
	if has 'net-libs/nodejs[npm]:multislot/12' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:multislot/12.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[npm]:multislot/14' ; then
		die \
"You need to disable npm on net-libs/nodejs[npm]:multislot/14.  Only enable\n\
npm on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:multislot/12' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:multislot/12.  Only enable\n\
man on the highest slot."
	fi
	if has 'net-libs/nodejs[man]:multislot/14' ; then
		die \
"You need to disable npm on net-libs/nodejs[man]:multislot/14.  Only enable\n\
man on the highest slot."
	fi
}

src_prepare() {
	tc-export CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# make sure we use python2.* while using gyp
	sed -i -e "s/python/${EPYTHON}/" deps/npm/node_modules/node-gyp/gyp/gyp || die
	sed -i -e "s/|| 'python2'/|| '${EPYTHON}'/" deps/npm/node_modules/node-gyp/lib/configure.js || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	sed -i -e "/'-O3'/d" common.gypi deps/v8/gypfiles/toolchain.gypi || die

	# Avoid a test that I've only been able to reproduce from emerge. It doesnt
	# seem sandbox related either (invoking it from a sandbox works fine).
	# The issue is that no stdin handle is openened when asked for one.
	# It doesn't really belong upstream , so it'll just be removed until someone
	# with more gentoo-knowledge than me (jbergstroem) figures it out.
	rm test/parallel/test-stdout-close-unref.js || die

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi

	default
}

src_configure() {
	xdg_environment_reset

	local myconf=( --shared-cares --shared-http-parser --shared-libuv --shared-nghttp2 --shared-zlib )
	use debug && myconf+=( --debug )
	use icu && myconf+=( --with-intl=system-icu ) || myconf+=( --with-intl=none )
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	use snapshot && myconf+=( --with-snapshot )
	if use ssl; then
		use system-ssl && myconf+=( --shared-openssl )
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
	"${PYTHON}" configure \
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
	emake install DESTDIR="${ED}"
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
		local tmp_npm_completion_file="$(emktemp)"
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
	out/${BUILDTYPE}/cctest || die
	"${PYTHON}" tools/test.py --mode=${BUILDTYPE,,} -J message parallel sequential || die
}

pkg_postinst() {
	einfo "The global npm config lives in /etc/npm. This deviates slightly"
	einfo "from upstream which otherwise would have it live in /usr/etc/."
	einfo ""
	einfo "Protip: When using node-gyp to install native modules, you can"
	einfo "avoid having to download extras by doing the following:"
	einfo "$ node-gyp --nodedir /usr/include/node <command>"

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
	einfo "The global npm config lives in /etc/npm. This deviates slightly"
	einfo "from upstream which otherwise would have it live in /usr/etc/."
	einfo ""
	einfo "Protip: When using node-gyp to install native modules, you can"
	einfo "avoid having to download extras by doing the following:"
	einfo "$ node-gyp --nodedir /usr/include/node <command>"

	einfo
	einfo "When compiling with nodejs multislot, you to switch via"
	einfo "\`eselect nodejs\` in order to compile against the headers"
	einfo "matching the corresponding SLOT.  This means that you cannot"
	einfo "compile with different SLOTS simultaneously."
	einfo
}
