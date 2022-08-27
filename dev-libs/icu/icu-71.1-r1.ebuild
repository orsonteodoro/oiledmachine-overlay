# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-libs/icu-layoutex

PYTHON_COMPAT=( python3_{8..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/icu.asc
inherit autotools flag-o-matic multilib-minimal python-any-r1 toolchain-funcs verify-sig
inherit llvm

DESCRIPTION="International Components for Unicode"
HOMEPAGE="https://icu.unicode.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz"
SRC_URI+=" verify-sig? ( https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz.asc )"
S="${WORKDIR}/${PN}/source"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="debug doc examples static-libs test"
RESTRICT="!test? ( test )"

BDEPEND+=" ${PYTHON_DEPS}
	sys-devel/autoconf-archive
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? ( app-doc/doxygen[dot] )
	verify-sig? ( sec-keys/openpgp-keys-icu )
"

S="${WORKDIR}/${PN}/source"
S_orig="${WORKDIR}/${PN}/source"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/icu-config
)

PATCHES=(
	"${FILESDIR}/${PN}-65.1-remove-bashisms.patch"
	"${FILESDIR}/${PN}-64.2-darwin.patch"
	"${FILESDIR}/${PN}-68.1-nonunicode.patch"
	"${FILESDIR}/${P}-CVE-2022-1638.patch" # bug 843731
	"${FILESDIR}/extra/${PN}-69.1-extra-so-flags.patch" # oiledmachine-overlay added
)

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

src_prepare() {
	default

	# Disable renaming as it assumes stable ABI and that consumers
	# won't use unofficial APIs. We need this despite the configure argument.
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		common/unicode/uconfig.h || die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		config/mh-linux || die

	# Append doxygen configuration to configure
	# oiledmachine-overlay:  Do not change or delete the line below.
	sed -i \
		-e 's:icudefs.mk :icudefs.mk Doxyfile:' \
		configure.ac || die

	eautoreconf

	prepare_abi() {
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			einfo "Copying to ${S}"
			cp -a "${S_orig}" "${S}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

src_configure() {
	# ICU tries to append -std=c++11 without this, so as of 71.1,
	# despite GCC 9+ using c++14 (or gnu++14) and GCC 11+ using gnu++17,
	# we still need this.
	append-cxxflags -std=c++14

	if tc-is-cross-compiler; then
		mkdir "${WORKDIR}"/host || die
		pushd "${WORKDIR}"/host >/dev/null || die

		CFLAGS="" CXXFLAGS="" ASFLAGS="" LDFLAGS="" \
		CC="$(tc-getBUILD_CC)" CXX="$(tc-getBUILD_CXX)" AR="$(tc-getBUILD_AR)" \
		RANLIB="$(tc-getBUILD_RANLIB)" LD="$(tc-getBUILD_LD)" \
		"${S}"/configure --disable-renaming --disable-debug \
			--disable-samples --enable-static || die
		emake

		popd >/dev/null || die
	fi

	configure_abi() {
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

_configure_abi() {
	filter-flags \
		"-Wno-unused-command-line-argument" \
		"-DDHAVE_DLOPEN=0" \
		"-DU_DISABLE_RENAMING=1" \
		"-DU_STATIC_IMPLEMENTATION"

	if [[ "${lib_type}" == "static" ]] ; then
		append_all -Wno-unused-command-line-argument
		append-cppflags -DDHAVE_DLOPEN=0 -DU_DISABLE_RENAMING=1 -DU_STATIC_IMPLEMENTATION
	fi

	# CFI Breaks building vte
	for value in cfi-vcall cfi-nvcall cfi-derived-cast cfi-unrelated-cast cfi ; do
		if is-flagq "-fsanitize=*${value}" ; then
			einfo "Removing ${value}"
			strip-flag-value "${value}"
		fi
	done
	filter-flag -fsanitize-cfi-cross-dso

	export ESHAREDLIBCFLAGS=""
	export ESHAREDLIBCXXFLAGS=""
	export ELD_SOOPTIONS=""

	local myeconfargs=(
		--disable-renaming
		--disable-samples
		--disable-layoutex
		$(use_enable debug)
		$(use_enable test tests)
		$(multilib_native_use_enable examples samples)
	)

	if [[ "${lib_type}" == "static" ]] ; then
		myeconfargs+=(
			--enable-static
			--disable-dyload
			--disable-shared
		)
	else
		myeconfargs+=(
			--disable-static
			--enable-shared
		)
	fi

	myeconfargs+=(
		--enable-extras
		--enable-tools
	)

	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}"/host
	)

	# Work around cross-endian testing failures with LTO #757681
	if tc-is-cross-compiler && is-flagq '-flto*' ; then
		myeconfargs+=( --disable-strict )
	fi

	# ICU tries to use clang by default
	tc-export CC CXX

	# Make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL="${EPREFIX}/bin/sh"
	# Probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL="${BASH}"

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	export VERBOSE=1
	compile_abi() {
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die

			default

			if multilib_is_native_abi && use doc; then
				doxygen -u Doxyfile || die
				doxygen Doxyfile || die
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			# INTLTEST_OPTS: intltest options
			#   -e: Exhaustive testing
			#   -l: Reporting of memory leaks
			#   -v: Increased verbosity
			# IOTEST_OPTS: iotest options
			#   -e: Exhaustive testing
			#   -v: Increased verbosity
			# CINTLTST_OPTS: cintltst options
			#   -e: Exhaustive testing
			#   -v: Increased verbosity
			emake -j1 VERBOSE="1" check
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			default
			if multilib_is_native_abi && use doc; then
				docinto html
				dodoc -r doc/html/*
			fi
		done
	}
	multilib_foreach_abi install_abi

	local HTML_DOCS=( ../readme.html )
	einstalldocs
}

pkg_postinst() {
	if use static-libs ; then
ewarn
ewarn "static-lib consumers require -DU_STATIC_IMPLEMENTATION"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  cfi patch
