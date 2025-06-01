# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# F40

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
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS HO IO NPD OOBR OOBW UAF"
TRAIN_NO_X_DEPENDS=1
TRAIN_USE_X=0
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=1

inherit meson
inherit check-compiler-switch cflags-hardened flag-o-matic multilib-minimal toolchain-funcs uopts virtualx

if [[ "${PV}" == *"9999"* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/cairo/cairo.git"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~amd64-linux ~arm64 ~x64-macos ~x86 ~x86-linux"
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
IUSE="
X aqua debug gles2-only gles3 +glib gtk-doc opengl spectre test
ebuild_revision_11
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
	>=dev-libs/lzo-2.10:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.15.0[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13.2:2[${MULTILIB_USEDEP},png]
	>=media-libs/libpng-1.6.40:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.13[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.43.4[${MULTILIB_USEDEP}]
	debug? (
		sys-libs/binutils-libs:0=[${MULTILIB_USEDEP}]
	)
	glib? (
		>=dev-libs/glib-2.80.3:2[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.8.10[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.17.0:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.6[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.11[${MULTILIB_USEDEP}]
	)
"
TEST_DEPEND="
	>=app-text/poppler-24.02.0
	>=app-text/ghostscript-gpl-10.02.1
	>=gnome-base/librsvg-2.57.1
	spectre? (
		>=app-text/libspectre-0.2.12
	)
"
DEPEND="
	${RDEPEND}
	X? (
		>=x11-base/xorg-proto-2024.1
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
	>=dev-build/meson-1.4.1
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-respect-fontconfig.patch"
	"${FILESDIR}/${P}-cups.patch"
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
