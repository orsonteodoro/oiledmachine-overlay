# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-libs/icu-layoutex

MY_PV="${PV/_rc/-rc}"
MY_PV="${MY_PV//./_}"

CFLAGS_HARDENED_CI_SANITIZERS="asan cfi lsan tsan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18" # U24
CFLAGS_HARDENED_LANGS="c-lang cxx"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF DOS HO IO MC OOBR OOBW SO UAF UM"
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)
MULTILIB_CHOST_TOOLS=(
	"/usr/bin/icu-config"
)
PYTHON_COMPAT=( "python3_"{10..13} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/icu.asc"

inherit autotools cflags-hardened check-compiler-switch flag-o-matic flag-o-matic-om libstdcxx-slot llvm
inherit multilib-minimal python-any-r1 toolchain-funcs verify-sig

if [[ "${PV}" =~ "_rc" ]] ; then
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86

~arm64-macos ~ppc-macos ~x86-macos

~x64-solaris
	" # Based on the Linux kernel KEYWORDS and icu4c/source/runConfigureICU
fi
S="${WORKDIR}/${PN}/source"
S_ORIG="${WORKDIR}/${PN}/source"
SRC_URI="
https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-src.tgz
verify-sig? (
	https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-src.tgz.asc
)
"

DESCRIPTION="International Components for Unicode"
HOMEPAGE="https://icu.unicode.org/"
LICENSE="
	icu-73.1
	BSD
	HPND
	GPL-2+
	GPL-3+
	Unicode-DFS-2016
"
# GPL-2+ - icu/source/aclocal.m4
# GPL-3+ - icu/source/config.guess
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${PV%.*}"
IUSE="
debug doc examples static-libs test
ebuild_revision_18
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	dev-build/autoconf-archive
	doc? (
		app-text/doxygen[dot]
	)
	verify-sig? (
		>=sec-keys/openpgp-keys-icu-20241110
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-76.1-remove-bashisms.patch"
	"${FILESDIR}/${PN}-64.2-darwin.patch"
	"${FILESDIR}/${PN}-68.1-nonunicode.patch"
	# Undo change for now which exposes underlinking in consumers;
	# revisit when things are a bit quieter and tinderbox its removal.
	"${FILESDIR}/${PN}-76.1-undo-pkgconfig-change-for-now.patch"

	# https://unicode-org.atlassian.net/browse/ICU-23120
	"${FILESDIR}/${PN}-77.1-invalid-malloc.patch"

	"${FILESDIR}/extra/${PN}-69.1-extra-so-flags.patch" # oiledmachine-overlay added
)
HTML_DOCS=( "../readme.html" )

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	default

	# TODO: switch uconfig.h hacks to use uconfig_local
	#
	# Disable renaming as it assumes stable ABI and that consumers
	# won't use unofficial APIs. We need this despite the configure argument.
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		"common/unicode/uconfig.h" \
		|| die

	# ODR violations, experimental API
	sed -i \
		-e "s/#   define UCONFIG_NO_MF2 0/#define UCONFIG_NO_MF2 1/" \
		"common/unicode/uconfig.h" \
		|| die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		"config/mh-linux" \
		|| die

	# Append doxygen configuration to configure
	# oiledmachine-overlay:  Do not change or delete the line below.
	sed -i \
		-e 's:icudefs.mk :icudefs.mk Doxyfile:' \
		"configure.ac" \
		|| die

	eautoreconf

	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			einfo "Copying to ${S}"
			cp -a "${S_ORIG}" "${S}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

_configure_abi() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	filter-flags \
		"-DDHAVE_DLOPEN=0" \
		"-DU_DISABLE_RENAMING=1" \
		"-DU_STATIC_IMPLEMENTATION" \
		"-Wno-unused-command-line-argument"

	if [[ "${lib_type}" == "static" ]] ; then
		append_all \
			"-Wno-unused-command-line-argument"
		append-cppflags \
			"-DDHAVE_DLOPEN=0" \
			"-DU_DISABLE_RENAMING=1" \
			"-DU_STATIC_IMPLEMENTATION"
	fi

	# CFI Breaks building vte
	local L=(
		"cfi-vcall"
		"cfi-nvcall"
		"cfi-derived-cast"
		"cfi-unrelated-cast"
		"cfi"
	)
	local value
	for value in ${L[@]} ; do
		if is-flagq "-fsanitize=*${value}" ; then
			einfo "Removing ${value}"
			strip-flag-value "${value}"
		fi
	done
	filter-flags -fsanitize-cfi-cross-dso
	cflags-hardened_append

	export ESHAREDLIBCFLAGS=""
	export ESHAREDLIBCXXFLAGS=""
	export ELD_SOOPTIONS=""

	local myeconfargs=(
		--disable-renaming
		--disable-samples
		# TODO: Merge with dev-libs/icu-layoutex
		# Planned to do this w/ 73.2 but seem to get test failures
		# only with --enable-layoutex.
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

#	myeconfargs+=(
#		--enable-extras
#		--enable-tools
#	)

	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}/host"
	)

	# Work around cross-endian testing failures with LTO, bug #757681
	if tc-is-cross-compiler && tc-is-lto ; then
		myeconfargs+=(
			--disable-strict
		)
	fi

	# ICU tries to use clang by default
	tc-export CC CXX

	# Make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL="${EPREFIX}/bin/sh"
	# Probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL="${BASH}"

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

src_configure() {
	if tc-is-cross-compiler ; then
		mkdir "${WORKDIR}/host" || die
		pushd "${WORKDIR}/host" >/dev/null || die

		CFLAGS="" \
		CXXFLAGS="" \
		ASFLAGS="" \
		LDFLAGS="" \
		CC="$(tc-getBUILD_CC)" \
		CXX="$(tc-getBUILD_CXX)" \
		AR="$(tc-getBUILD_AR)" \
		RANLIB="$(tc-getBUILD_RANLIB)" \
		LD="$(tc-getBUILD_LD)" \
		"${S}/configure" \
			--disable-renaming \
			--disable-debug \
			--disable-samples \
			--enable-static \
			|| die
		emake

		popd >/dev/null || die
	fi

	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	export VERBOSE=1
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die

			default

			if multilib_is_native_abi && use doc ; then
				doxygen -u "Doxyfile" || die
				doxygen "Doxyfile" || die

				HTML_DOCS+=( "${BUILD_DIR}/doc/html/." )
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
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
			emake VERBOSE="1" check
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_ORIG}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			default
			if multilib_is_native_abi && use doc; then
				docinto "html"
				dodoc -r "doc/html/"*
			fi
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	local HTML_DOCS=( "../readme.html" )
	einstalldocs
}

pkg_postinst() {
	if use static-libs ; then
ewarn "static-lib consumers require -DU_STATIC_IMPLEMENTATION"
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  cfi patch
