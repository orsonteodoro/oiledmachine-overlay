# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic multilib multilib-minimal portability toolchain-funcs

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline static-libs"
IUSE+=" urho3d"

COMMON_DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( >=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}] )
	!dev-lang/lua:0"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="sys-devel/libtool"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/lua${SLOT}/luaconf.h
)

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

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
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

_configure() {
	if use urho3d ; then
		append-cppflags -DURHO3D
	fi
	# We want packages to find our things...
	sed -i \
		-e 's:/usr/local:'${EPREFIX}'/usr:' \
		-e "s:\([/\"]\)\<lib\>:\1$(get_libdir):g" \
		etc/lua.pc src/luaconf.h || die
}

src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			_configure
		done
	}
	multilib_foreach_abi configure_abi
}

_compile() {
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	cd "${BUILD_DIR}" || die
	tc-export CC
	myflags=
	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CC="${CC}" CFLAGS="-DLUA_USE_LINUX ${CFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			gentoo_all

	mv lua_test ../test/lua.static

}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			_compile
		done
	}
	multilib_foreach_abi compile_abi
}

_install() {
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	cd "${BUILD_DIR}" || die
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
		V=${SLOT} gentoo_install

	insinto /usr/$(get_libdir)/pkgconfig
	newins etc/lua.pc lua${SLOT}.pc
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			_install
		done
	}
	multilib_foreach_abi install_abi
	src_install_all
}

src_install_all() {
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

_test() {
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	cd "${BUILD_DIR}" || die
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	for test in ${positive}; do
		test/lua.static test/${test}.lua || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua && die "test $test failed"
	done
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			_test
		done
	}
	multilib_foreach_abi test_abi
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	if has_version "app-editor/emacs"; then
		if ! has_version "app-emacs/lua-mode"; then
			einfo "Install app-emacs/lua-mode for lua support for emacs"
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  apply-urho3d-patch
