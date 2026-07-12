# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# F40 - Python 3.12

#
# Re-emerge twice for pgo/testing
#
# 1.  1st emerge will emerge testing depends/pgo out of order to break the
#     circular depends chain.
#
# 2.  2nd emerge will do actual PGO or testing.
#

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan"
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO IO NPD OOBR OOBW UAF"
PYTHON_COMPAT=( "python3_"{11..12} )
TRAIN_NO_X_DEPENDS=1
TRAIN_USE_X=0
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=1

CHKL_TIMESTAMPS=(
	"app-text/ghostscript-gpl-9999"
	"app-text/poppler-9999"
	"gnome-base/librsvg-9999"
	"media-libs/fontconfig-9999"
	"media-libs/freetype-9999"
	"media-libs/libpng-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/pixman-9999"
)

inherit meson
inherit check-compiler-switch cflags-hardened chkl flag-o-matic multilib-minimal python-any-r1 secure-version toolchain-funcs uopts virtualx

if [[ "${PV}" == *"9999"* ]] ; then
	FALLBACK_COMMIT="8e3ac5e404f45b92ea186ad7a776b5e5160f38ac"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/cairo/cairo.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://gitlab.freedesktop.org/cairo/cairo/-/archive/${PV}/cairo-${PV}.tar.bz2"
fi

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="https://www.cairographics.org/ https://gitlab.freedesktop.org/cairo/cairo"
LICENSE="
	|| (
		LGPL-2.1
		MPL-1.1
	)
"
# Requires poppler-glib, which isn't available in multilib \
#RESTRICT="
#	!test? (
#		test
#	)
#	test
#"
SLOT="0"
IUSE+="
X aqua debug gles2-only gles3 +glib gtk-doc lzo opengl spectre test
ebuild_revision_18
"
REQUIRED_USE="
	gles2-only? (
		!opengl
	)
	gles3? (
		gles2-only
	)
"
RDEPEND="
	>=dev-libs/lzo-${LZO_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-${FREETYPE_PV}:=[${MULTILIB_USEDEP},png]
	>=media-libs/libpng-${LIBPNG_PV}:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-${PIXMAN_PV}:=[${MULTILIB_USEDEP}]
	debug? (
		sys-libs/binutils-libs:=[${MULTILIB_USEDEP}]
	)
	glib? (
		>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	)
	lzo? (
		>=dev-libs/lzo-${LZO_PV}:=[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-${LIBXCB_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-${LIBXRENDER_PV}:=[${MULTILIB_USEDEP}]
	)
"
TEST_DEPEND="
	>=app-text/poppler-${POPPLER_PV}
	>=app-text/ghostscript-gpl-${GHOSTSCRIPT_GPL_PV}
	>=gnome-base/librsvg-${LIBRSVG_PV}
	spectre? (
		>=app-text/libspectre-${LIBSPECTRE_PV}
	)
"
DEPEND="
	${RDEPEND}
	X? (
		>=x11-base/xorg-proto-2024.1:=
	)
"
PDEPEND="
	pgo? (
		${TEST_DEPEND}
	)
	test? (
		${TEST_DEPEND}
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.4.1
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-respect-fontconfig.patch"
)

TEST_READY="1"
check_test_depends() {
	einfo "The following are required to use ${CATEGORY}/${PN}[test?,pgo?]:"
	setup_abi() {
		if ! has_version "app-text/poppler[${MULTILIB_ABI_FLAG}]" ; then
# The qtbase:6 ebuild doesn't support abi_x86_32.
ewarn
ewarn "Re-emerge app-text/poppler[${MULTILIB_ABI_FLAG}] to perform PGO training"
ewarn "or testing on non-native ABIs or disable the ABI on this ebuild."
ewarn
			TEST_READY=0
		fi
		if ! has_version "gnome-base/librsvg[${MULTILIB_ABI_FLAG}]" ; then
ewarn
ewarn "Re-emerge gnome-base/librsvg[${MULTILIB_ABI_FLAG}] to perform PGO"
ewarn "training or testing with non-native ABIs or disable the ABI on this"
ewarn "ebuild."
ewarn
			TEST_READY=0
		fi
	}
	multilib_foreach_abi setup_abi
ewarn "The pgo profile may need to be deleted if it produces artifacts or missing tiles."
}

pkg_setup() {
	check-compiler-switch_start
	uopts_setup
	if use pgo || use test ; then
		check_test_depends
	fi
}

src_unpack() {
	if [[ "${PV}" == *"9999"* ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	prepare_abi() {
		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		uopts_src_prepare
	}

	multilib_foreach_abi prepare_abi
}

src_configure() { :; }

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

_src_configure() {
	cd "${EMESON_SOURCE}" || die

	uopts_src_configure

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
	cflags-hardened_append

        if tc-is-gcc && [[ "${PGO_PHASE}" == "PGO" ]] ; then
                append-flags -Wno-error=coverage-mismatch
		append-ldflags -Wno-error=coverage-mismatch
        fi

        export PKG_CONFIG="$(tc-getPKG_CONFIG)"
        export PKG_CONFIG_LIBDIR="${ESYSROOT}/usr/$(get_libdir)/pkgconfig"
        export PKG_CONFIG_PATH="${ESYSROOT}/usr/share/pkgconfig"

	local emesonargs=(
		$(meson_feature aqua quartz)
		$(meson_feature debug symbol-lookup)
		$(meson_feature glib)
		$(meson_feature lzo)
		$(meson_feature test tests)
		$(meson_feature X tee)
		$(meson_feature X xcb)
		$(meson_feature X xlib)
		$(meson_use gtk-doc gtk_doc)
		-Ddwrite=disabled
		-Dfontconfig=enabled
		-Dfreetype=enabled
		-Dgtk2-utils=disabled
		-Dpng=enabled
		-Dxlib-xcb=disabled
		-Dzlib=enabled
	)

	if use test && use spectre ; then
		emesonargs+=(
			-Dspectre=enabled
		)
	else
		emesonargs+=(
			-Dspectre=disabled
		)
	fi

	if [[ "${TEST_READY}" == "0" ]] ; then
ewarn
ewarn "Skipping building tests due to missing ${ABI} DEPENDs"
ewarn
		emesonargs+=(
			-Dtests=disabled
		)
	elif ( use test || use pgo ) ; then
		emesonargs+=(
			-Dtests=enabled
		)
	else
		emesonargs+=(
			-Dtests=disabled
		)
	fi

	meson_src_configure
}

_src_compile() {
	cd "${BUILD_DIR}" || die
	meson_src_compile
}

src_compile() {
	compile_abi() {
		export EMESON_SOURCE="${S}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

train_trainer_custom() {
#	! multilib_is_native_abi && return
#	sed -r -i -e "s|am__EXEEXT_([0-9]) = any2ppm|am__EXEEXT_\1 = |g" test/Makefile || die
        local mesontestargs=(
                --print-errorlogs
                -C "${BUILD_DIR}"
                --num-processes "$(makeopts_jobs "${MAKEOPTS}")"
        )
	set meson test "${mesontestargs[@]}"
        echo "$@" >&2
        "$@" || true
}

_tpgo_custom_clean() {
	# Still not deterministic
	einfo "Cleaning copy"
	rm -rf "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build" || die
}

src_test() {
	if [[ "${TEST_READY}" == "0" ]] ; then
ewarn
ewarn "Skipping running tests due to missing ${ABI} DEPENDs"
ewarn
		return
	fi
	test_abi() {
		export EMESON_SOURCE="${S}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
		cd "${BUILD_DIR}" || die
		meson_src_test
	}
	multilib_foreach_abi test_abi
}

multilib_src_install() {
	export EMESON_SOURCE="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${BUILD_DIR}" || die
	meson_src_install
	uopts_src_install
}

multilib_src_install_all() {
	einfo "Called multilib_src_install_all"
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}/usr/share/gtk-doc/cairo" || die
		mv "${ED}/usr/share/gtk-doc/"{"html/cairo","cairo/html"} || die
		rmdir "${ED}/usr/share/gtk-doc/html" || die
	fi
}

pkg_postinst() {
	uopts_pkg_postinst
	if ( use pgo || use test ) && [[ "${TEST_READY}" == "0" ]] ; then
ewarn
ewarn "Measures have been taken to avoid a circular depends."
ewarn
ewarn "Re-emerge the package again for working pgo/testing"
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  apply-patch-bugfix, pgo
