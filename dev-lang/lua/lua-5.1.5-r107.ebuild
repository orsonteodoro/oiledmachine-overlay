# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal portability toolchain-funcs tpgo

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline"
IUSE+=" static-libs urho3d"

COMMON_DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( >=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}] )
	!dev-lang/lua:0"
# Cross-compiling note:
# Must use libtool from the target system (DEPEND) because
# libtool from the build system (BDEPEND) is for building
# native binaries.
DEPEND="
	${COMMON_DEPEND}
	sys-devel/libtool"
RDEPEND="${COMMON_DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/lua${SLOT}/luaconf.h
)

src_prepare() {
	PATCHES=(
		"${FILESDIR}/lua-5.1.5-make.patch"
		"${FILESDIR}/${PN}-$(ver_cut 1-2)-module_paths.patch"
	)
	if ! use deprecated ; then
		# patches from 5.1.4 still apply
		PATCHES+=(
			"${FILESDIR}"/${PN}-5.1.4-deprecated.patch
			"${FILESDIR}"/${PN}-5.1.4-test.patch
		)
	fi
	if ! use readline ; then
		PATCHES+=(
			"${FILESDIR}"/${PN}-$(ver_cut 1-2)-readline.patch
		)
	fi

	default

	# use glibtool on Darwin (versus Apple libtool)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/LIBTOOL = /s:libtool:glibtool:' \
			Makefile src/Makefile || die
	fi

	# correct lua versioning
	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\16:5:1/' src/Makefile

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries.

	# A slotted Lua uses different directories for headers & names for
	# libraries, and pkgconfig should reflect that.
	sed -r -i \
		-e "/^INSTALL_INC=/s,(/include)$,\1/lua${SLOT}," \
		-e "/^includedir=/s,(/include)$,\1/lua${SLOT}," \
		-e "/^Libs:/s,((-llua)($| )),\2${SLOT}\3," \
		"${S}"/etc/lua.pc

	if use urho3d ; then
		eapply "${FILESDIR}/lua-5.1.5-urho3d-lua_getmainthread.patch"
	fi

	# custom Makefiles
	multilib_copy_sources

	prepare_abi() {
		cd "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		# We want packages to find our things...
		sed -i \
			-e 's:/usr/local:'${EPREFIX}'/usr:' \
			-e "s:\([/\"]\)\<lib\>:\1$(get_libdir):g" \
			etc/lua.pc src/luaconf.h || die
		tpgo_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() { :; }

_src_configure() {
	tpgo_src_configure
}

_src_compile() {
	tc-export CC
	myflags=
	# what to link to liblua
	liblibs="-lm"
	[[ "${PGO_PHASE}" == "PGI" ]] && liblibs+=" -lc -lgcov"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	einfo "ABI=${ABI} $(get_libdir)"
	cd src
	emake CC="${CC} $(get_abi_CFLAGS ${ABI})" CFLAGS="-DLUA_USE_LINUX ${CFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			LIBTOOL="${ESYSROOT}/usr/bin/libtool" \
			gentoo_all

	mv lua_test ../test/lua.static
}

src_compile() {
	compile_abi() {
		cd "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		tpgo_src_compile
	}

	multilib_foreach_abi compile_abi
}

_src_pre_train() {
	_install
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	export PATH_BAK="${PATH}"
	export PATH="${ED}/usr/bin:${PATH}"
}

_src_post_train() {
	rm -rf "${ED}" || die
	unset LD_LIBRARY_PATH
	export PATH="${PATH_BAK}"
}

tpgo_trainer_list() {
	ls "${S}-${MULTILIB_ABI_FLAG}.${ABI}/test/"*".lua" || die
}

tpgo_get_trainer_exe() {
	realpath -e "${ED}/usr/bin/lua${SLOT}" || die
}

tpgo_get_trainer_args() {
	local trainer="${1}"
	echo "${trainer}"
}

_install() {
	cd "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	insinto /usr/$(get_libdir)/pkgconfig
	newins etc/lua.pc lua${SLOT}.pc
}

multilib_src_install() {
	_install
	tpgo_src_install
}

multilib_src_install_all() {
	DOCS="HISTORY README"
	HTML_DOCS="doc/*.html doc/*.png doc/*.css doc/*.gif"
	einstalldocs
	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name 'liblua*.a' -delete || die
	fi
}

multilib_src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${BUILD_DIR}" || die
	for test in ${positive}; do
		test/lua.static test/${test}.lua || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua && die "test $test failed"
	done
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	if has_version "app-editor/emacs"; then
		if ! has_version "app-emacs/lua-mode"; then
			einfo "Install app-emacs/lua-mode for lua support for emacs"
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  apply-urho3d-patch allow-static-libs, pgo
