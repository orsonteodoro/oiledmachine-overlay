# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="gstreamer-1.21.1"

LLVM_SLOTS=(13 12 11) # For clang-sys
LLVM_MAX_SLOT=13

PYTHON_COMPAT=( python3_{8..11} )
inherit flag-o-matic lcnr llvm meson multilib-minimal

DESCRIPTION="Various GStreamer plugins written in Rust"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
CARGO_THIRD_PARTY_PACKAGES="
	0BSD
	Apache-2.0
	BSD
	ISC
	MIT
	Unlicense
	unicode
	ZLIB
"
LICENSE="
	Apache-2.0
	MIT
	LGPL-2.1+
	MPL-2.0
	${CARGO_THIRD_PARTY_PACKAGES}
"
# Apache-2.0 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/futures-channel-0.3.15/LICENSE-APACHE
# 0BSD ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/adler-0.2.2/LICENSE-0BSD
# BSD ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/bindgen-0.54.1/LICENSE
# BSD ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/subtle-1.0.0/LICENSE
# BSD-2 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/crossbeam-queue-0.2.3/LICENSE-THIRD-PARTY
# BSD-2 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/rav1e-0.3.3/LICENSE
# BSD-2 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/futures-channel-0.3.15/src/mpsc/queue.rs
# ISC ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/libloading-0.5.2/LICENSE
# MIT ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/futures-channel-0.3.15/LICENSE-MIT
# Unlicense ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/termcolor-1.1.0/UNLICENSE
# Unlicense ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/aho-corasick-0.7.13/UNLICENSE
# unicode ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/regex-syntax-0.6.25/src/unicode_tables/LICENSE-UNICODE
# ZLIB ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/adler32-1.1.0/LICENSE
# ZLIB ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/bytemuck-1.2.0/LICENSE-ZLIB.md

# Live ebuilds or live snapshot don't get KEYWORDs

SLOT="1.0/${PV}"
MODULES=(
	ahead
	audiofx
	aws
	cdg
	claxon
	closedcaption
	csound
	dav1d
	fallbackswitch
	ffv1
	file
	flavors
	fmp4
	gif
	gtk4
	hlssink3
	hsv
	json
	lewton
	onvif
	raptorq
	rav1e
	regex
	reqwest
	rspng
	rtpav1
	spotify
	sodium
	test
	textwrap
	threadshare
	togglerecord
	tracers
	uriplaylistbin
	videofx
	webp
	webrtchttp
)
IUSE+=" ${MODULES[@]}"
REQUIRED_USE+="
	|| ( ${MODULES[@]} )
	webrtchttp? ( reqwest )
"
RUST_V="1.64"
CARGO_V="1.64"
# grep -e "requires_private" "${WORKDIR}" for external dependencies
# See "Run-time dependency" in CI
# Assumes D11
GST_PV="1.18" # upstream uses in CI 1.21.0.1
PANGO_PV="1.50.10"
RDEPEND+="
	>=dev-libs/glib-2.66.8:2[${MULTILIB_USEDEP}]
	!=dev-libs/libgit2-1.4*
	 =dev-libs/libgit2-1.3*
	>=media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	aws? (
		>=dev-libs/openssl-1.1.1n[${MULTILIB_USEDEP}]
	)
	closedcaption? (
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}]
	)
	csound? (
		>=media-sound/csound-6.14[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-1.0.0[${MULTILIB_USEDEP}]
	)
	gtk4? (
		>=gui-libs/gtk-4.8.1:4[gstreamer]
	)
	onvif? (
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
	)
	sodium? (
		>=dev-libs/libsodium-1.0.18[${MULTILIB_USEDEP}]
	)
	videofx? (
		>=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}]
	)
	webp? (
		>=media-libs/libwebp-0.6.1[${MULTILIB_USEDEP}]
	)
	webrtchttp? (
		media-plugins/gst-plugins-webrtc[${MULTILIB_USEDEP}]
	)
"
DEPEND+=" ${RDEPEND}"
# Update while keeping track of versions of virtual/rust.
# Expanded here because the virtual system is broken for multilib.
gen_llvm_bdepend() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/llvm:${s}[${MULTILIB_USEDEP}]
				sys-devel/clang:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}
BDEPEND+="
	|| ( $(gen_llvm_bdepend) )
	>=dev-util/cargo-c-0.9.12
	>=dev-util/meson-0.63.2
	>=dev-util/pkgconf-0.29.2[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gcc-11
	>=virtual/rust-${RUST_V}[${MULTILIB_USEDEP}]
"

SRC_URI="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${MY_PV}/gst-plugins-rs-${MY_PV}.tar.bz2
	-> ${P}.tar.bz2
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${MY_PV}"
PATCHES=(
	"${FILESDIR}/${PN}-0.9.4_alpha1-modular-build.patch"
	"${FILESDIR}/${PN}-0.6.0_p20210607-rename-csound-ref.patch"
)

pkg_setup() {
	if ldd /usr/bin/cargo-cbuild | grep -q -e "libgit2.so.1.4" ; then
# Segfaults
eerror
eerror "dev-util/cargo-c must not be built against =dev-libs/libgit2-1.4*."
eerror "Re-emerge =dev-libs/libgit2-1.3* and dev-util/cargo-c."
eerror
		die
	fi
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to download the internal dependencies."
eerror
		die
	fi

	# The file name version does not match the --version.
	local x_cargo_v=$(cargo --version | cut -f 2 -d " ")
	if ver_test ${x_cargo_v} -le ${CARGO_V} ; then
		die "cargo must be >=${CARGO_V}"
	else
		einfo "cargo version: ${x_cargo_v}"
	fi
}

multilib_src_configure() {
	if has_version 'media-libs/mesa' ; then
		LLVM_MAX_SLOT=$(bzcat "${ESYSROOT}"/var/db/pkg/media-libs/mesa-*/environment.bz2 \
			| grep -e "LLVM_MAX_SLOT" | head -n 1 | grep -E -o -e "[0-9]+")
		llvm_pkg_setup
	else
		local found=0
		for s in ${LLVM_SLOTS[@]} ; do
			if has_version "sys-devel/clang:${s}" \
				&& has_version "sys-devel/llvm:${s}" ; then
				found=1
				break
			fi
		done
		if (( ${found} == 1 )) ; then
			LLVM_MAX_SLOT=${s}
			llvm_pkg_setup
		else
eerror
eerror "The LLVM/clang version is not supported.  Send a issue request to"
eerror "update the ebuild maintainer."
eerror
			die
		fi
	fi
einfo "LLVM=${LLVM_MAX_SLOT}"

	export CSOUND_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)"

	for m in ${MODULES[@]} ; do
		[[ "${m}" == "test" ]] && continue
		emesonargs+=( $(meson_feature ${m}) )
	done

	pushd "${S}" || die
#	if ! use tutorial ; then
		# Pruned because it's not built in meson.build.
		sed -i -e "/tutorial/d" \
			Cargo.toml || die
#	fi

	local keep=0
	for m in ${MODULES[@]} ; do
		[[ "${m}" == "test" ]] && continue
		if ! use "${m}" ; then
			einfo "Removed ${m}"
			if [[ "${m}" == "textwrap" ]] ; then
				# Ambigious lines
				sed -i -e "/text\/wrap/d" \
					Cargo.toml || die
			elif [[ "${m}" == "file" ]] ; then
				# Ambigious lines
				sed -i -e "/generic\/file/d" \
					Cargo.toml || die
			else
				sed -i -e "/${m}/d" \
					Cargo.toml || die
			fi
		else
			einfo "Kept ${m}"
			keep=1
		fi
	done

	# A dependency for those listed below
	if (( ${keep} == 1 )) ; then
		# also tutorial plugin in || conditional
		einfo "Using version-helper"
	else
		einfo "Pruning version-helper"
		sed -i -e "/version-helper/d" \
			Cargo.toml || die
	fi

	popd

	meson_src_configure
}

multilib_src_compile() {
# DO NOT REMOVE
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	LCNR_SOURCE="${HOME}/.cargo"
	LCNR_TAG="third_party_cargo"
	lcnr_install_files

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install_all() {
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
