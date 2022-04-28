# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a live snapshot based on version in Cargo.toml and date of latest commit in master branch.

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils flag-o-matic llvm meson multilib-minimal

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
ZLIB"
LICENSE="Apache-2.0 MIT LGPL-2.1+
	MPL-2.0
	${CARGO_THIRD_PARTY_PACKAGES}"
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
	rav1e
	regex
	reqwest
	rspng
	rusoto
	spotify
	sodium
	test
	textwrap
	threadshare
	togglerecord
	uriplaylistbin
	videofx
	webp
)
IUSE+=" ${MODULES[@]}"
REQUIRED_USE+=" || ( ${MODULES[@]} )"
RUST_V="1.52"
CARGO_V="1.40"
# grep -e "requires_private" "${WORKDIR}" for external dependencies
# See "Run-time dependency" in CI
# Assumes D11
GST_V="1.14" # upstream uses in CI 1.21.0.1
RDEPEND+="
	  dev-libs/glib:2[${MULTILIB_USEDEP}]
	!=dev-libs/libgit2-1.4*
	 =dev-libs/libgit2-1.3*
	>=media-plugins/gst-plugins-meta-${GST_V}:1.0[${MULTILIB_USEDEP}]
	closedcaption? (
		>=x11-libs/pango-1.46.2[${MULTILIB_USEDEP}]
	)
	csound? ( >=media-sound/csound-6.14[${MULTILIB_USEDEP}] )
	dav1d? ( >=media-libs/dav1d-0.9.2[${MULTILIB_USEDEP}] )
	gtk4? (
		>=gui-libs/gtk-4.6.2:4[gstreamer]
	)
	rusoto? ( >=dev-libs/openssl-1.1.1n[${MULTILIB_USEDEP}] )
	videofx? ( >=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}] )
	sodium? ( >=dev-libs/libsodium-1.0.18[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
# Update while keeping track of versions of virtual/rust.
# Expanded here because the virtual system is broken for multilib.
LLVM_SLOTS=(13 12 11) # For clang-sys
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
BDEPEND+=" ${BDEPEND}
	|| ( $(gen_llvm_bdepend) )
	>=dev-util/cargo-c-0.9.3
	>=dev-util/meson-0.56
	>=dev-util/pkgconf-0.29.2[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gcc-11
	>=virtual/rust-${RUST_V}[${MULTILIB_USEDEP}]
"
SRC_URI="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${PV}/gst-plugins-rs-${PV}.tar.bz2
	-> ${P}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"
PATCHES=(
	"${FILESDIR}/gst-plugins-rs-0.8.4-modular-build.patch"
	"${FILESDIR}/gst-plugins-rs-0.6.0_p20210607-rename-csound-ref.patch"
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
	LLVM_MAX_SLOT=13
	if has_version 'media-libs/mesa' ; then
		LLVM_MAX_SLOT=$(bzcat "${ESYSROOT}"/var/db/pkg/media-libs/mesa-*/environment.bz2 \
			| grep -e "LLVM_MAX_SLOT" | head -n 1 | grep -E -o -e "[0-9]+")
		llvm_pkg_setup
	elif has_version 'sys-devel/clang:13' \
		&& has_version 'sys-devel/llvm:13' ; then
		LLVM_MAX_SLOT=13
		llvm_pkg_setup
	elif has_version 'sys-devel/clang:12' \
		&& has_version 'sys-devel/llvm:12' ; then
		LLVM_MAX_SLOT=12
		llvm_pkg_setup
	elif has_version 'sys-devel/clang:11' \
		&& has_version 'sys-devel/llvm:11' ; then
		LLVM_MAX_SLOT=11
		llvm_pkg_setup
	else
eerror
eerror "The LLVM/clang version is not supported.  Send a issue request to"
eerror "update the ebuild maintainer."
eerror
		die
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

_install_header_license() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local length="${3}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	head -n ${length} "${S}/${d}/${file_name}" > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

_install_header_license_mid() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local start="${3}"
	local length="${4}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	tail -n +${start} "${S}/${d}/${file_name}" \
		| head -n ${length} > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

# @FUNCTION: _install_licenses
# @DESCRIPTION:
# Installs licenses and copyright notices from third party rust cargo
# packages and other internal packages.
_install_licenses() {
	local tag="${1}"
	local license_path_prefix="${2}"
	[[ -f "${T}/.copied_licenses_${tag}" ]] && return

	einfo "Copying third party licenses and copyright notices for ${tag}"
	export IFS=$'\n'
	for f in $(find "${license_path_prefix}" \
	  -iname "*licens*" -type f \
	  -o -iname "*licenc*" \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  -o -iname "*author*" \
	  -o -iname "*CONTRIBUTORS*" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licens" \
		-e "licenc" \
		-e "warrant" \
		$(find "${license_path_prefix}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${license_path_prefix}||")
		else
			d=$(echo "${f}" | sed -e "s|^${license_path_prefix}||")
		fi
		docinto "licenses/${tag}/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'

	touch "${T}/.copied_licenses_${tag}"
}

multilib_src_install() {
	meson_src_install
	_install_licenses "third_party_cargo" "${HOME}/.cargo"
	_install_licenses "sources" "${S}"
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install_all() {
	einstalldocs
}
