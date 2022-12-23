# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT_FALLBACK="ca17c9bc4f5a7146685097934f97cd50bd458053" # Dec 22, 2022

MY_PV="9999"

LLVM_SLOTS=(13 12 11) # For clang-sys
LLVM_MAX_SLOT=13

# We cannot use the cargo.eclass because it doesn't support git crates.

PYTHON_COMPAT=( python3_{8..11} )
inherit flag-o-matic git-r3 lcnr llvm meson multilib-minimal

DESCRIPTION="Various GStreamer plugins written in Rust"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
CARGO_THIRD_PARTY_PACKAGES="
	Apache-2.0
	MIT
	Unicode-DFS-2016
"
LICENSE="
	Apache-2.0
	MIT
	LGPL-2.1+
	MPL-2.0
	${CARGO_THIRD_PARTY_PACKAGES}
"
# Unicode-DFS-2016 ${HOME}/.cargo/registry/src/github.com-1ecc6299db9ec823/unicode-ident-1.0.5/LICENSE-UNICODE

# Live ebuilds or live snapshot don't get KEYWORDs

SLOT="1.0/${PV}"
MODULES=(
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
	livesync
	mp4
	ndi
	onvif
	png
	raptorq
	rav1e
	regex
	reqwest
	rtp
	spotify
	sodium
	test
	textahead
	textwrap
	threadshare
	togglerecord
	tracers
	uriplaylistbin
	videofx
	webp
	webrtc
	webrtchttp
)
IUSE+=" ${MODULES[@]} doc fallback-commit"
REQUIRED_USE+="
	|| ( ${MODULES[@]} )
	webrtchttp? ( reqwest )
"
RUST_V="1.65"
CARGO_V="1.65"
# grep -e "requires_private" "${WORKDIR}" for external dependencies
# See "Run-time dependency" in CI
# Assumes D11
CAIRO_PV="1.16.0"
GST_PV="1.20" # Upstream uses in CI 1.21.2.1, distro only provides 1.20.x
PANGO_PV="1.50.12" # Upstream uses 1.50.13 on meson-shared test CI
RDEPEND+="
	>=dev-libs/glib-2.66.8:2[${MULTILIB_USEDEP}]
	>=dev-libs/libgit2-1.5
	>=media-plugins/gst-plugins-meta-${GST_PV}:1.0[${MULTILIB_USEDEP}]
	aws? (
		>=dev-libs/openssl-1.1.1n[${MULTILIB_USEDEP}]
	)
	closedcaption? (
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
		>=x11-libs/cairo-${CAIRO_PV}[${MULTILIB_USEDEP}]
	)
	csound? (
		>=media-sound/csound-6.14[${MULTILIB_USEDEP}]
	)
	dav1d? (
		>=media-libs/dav1d-1.0.0:=[${MULTILIB_USEDEP}]
	)
	gtk4? (
		>=gui-libs/gtk-4.8.2:4[gstreamer]
	)
	onvif? (
		>=x11-libs/pango-${PANGO_PV}[${MULTILIB_USEDEP}]
	)
	sodium? (
		>=dev-libs/libsodium-1.0.18[${MULTILIB_USEDEP}]
	)
	videofx? (
		>=x11-libs/cairo-${CAIRO_PV}[${MULTILIB_USEDEP}]
	)
	webp? (
		>=media-libs/libwebp-0.6.1[${MULTILIB_USEDEP}]
	)
	webrtchttp? (
		>=media-plugins/gst-plugins-webrtc-${GST_PV}[${MULTILIB_USEDEP}]
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
	>=dev-util/cargo-c-0.9.14
	>=dev-util/meson-0.62.2
	>=dev-util/pkgconf-0.29.2[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gcc-11
	>=virtual/rust-${RUST_V}[${MULTILIB_USEDEP}]
	doc? ( dev-python/hotdoc )
"

if [[ ${PV} =~ 9999 ]] ; then
	EGIT_COMMIT="HEAD"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git"
else
	SRC_URI="
	https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${MY_PV}/gst-plugins-rs-${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
fi
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${MY_PV}"
PATCHES=(
	"${FILESDIR}/${PN}-9999-modular-build.patch"
	"${FILESDIR}/${PN}-0.6.0_p20210607-rename-csound-ref.patch"
)
EXPECTED_BUILD_FILES_FINGERPRINT="\
5a5c61d9ed5a36ad620b7d3cbc5dab1b2bfe47fbe719f8711b086bdf75a047b4\
8c3070dda8d9fa9971f9d856a66cb0c97445e722ed631e021b6be9136799377f\
"

pkg_setup() {
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
			if [[ "${m}" == "webrtchttp" ]] ; then
				# Ambigious lines
				sed -i -e "/net\/webrtchttp$/d" \
					Cargo.toml || die
			elif [[ "${m}" == "webrtc" ]] ; then
				# Ambigious lines
				sed -i \
					-e "/net\/webrtc$/d" \
					-e "/net\/webrtc\/protocol$/d" \
					-e "/net\/webrtc\/signalling$/d" \
					Cargo.toml || die
			elif [[ "${m}" == "textahead" ]] ; then
				# Different name
				sed -i -e "/text\/ahead/d" \
					Cargo.toml || die
			elif [[ "${m}" == "textwrap" ]] ; then
				# Ambigious lines
				sed -i -e "/text\/wrap/d" \
					Cargo.toml || die
			elif [[ "${m}" == "fmp4" ]] ; then
				# Ambigious lines
				sed -i -e "/mux\/fmp4/d" \
					Cargo.toml || die
			elif [[ "${m}" == "mp4" ]] ; then
				# Ambigious lines
				sed -i -e "/mux\/mp4/d" \
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

src_unpack() {
	if use fallback-commit ; then
		export EGIT_COMMIT="${EGIT_COMMIT_FALLBACK}"
		export EGIT_OVERRIDE_COMMIT_GSTREAMER_GST_PLUGINS_RS="${EGIT_COMMIT_FALLBACK}"
	fi
	if [[ ${PV} =~ 9999 ]] ; then
		git-r3_fetch
		git-r3_checkout
		local actual_build_files_fingerprint=$(cat \
			$(find "${S}" \
				-name "*.toml" \
				-o -name "Cargo.lock" \
				-o -name "meson.build" \
				| sort) \
			| sha512sum \
			| cut -f 1 -d " ")
		if [[ "${EXPECTED_BUILD_FILES_FINGERPRINT}" != "${actual_build_files_fingerprint}" ]] ; then
eerror
eerror "A change to the build scripts was detected."
eerror "Notify the ebuild maintainer for an update."
eerror
eerror "Expected build files fingerprint:\t${EXPECTED_BUILD_FILES_FINGERPRINT}"
eerror "Actual build files fingerprint:\t${actual_build_files_fingerprint}"
eerror
			die
		fi
	else
		unpack ${A}
	fi
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
