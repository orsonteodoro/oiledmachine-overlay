# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a live snapshot based on version in Cargo.toml and date of latest commit in master branch.

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils flag-o-matic llvm meson multilib-minimal

DESCRIPTION="Various GStreamer plugins written in Rust"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
LICENSE="Apache-2.0 MIT LGPL-2.1+"

# Live ebuilds or live snapshot don't get KEYWORDs

SLOT="1.0/${PV}"
IUSE+="	audiofx
	cdg
	claxon
	closedcaption
	csound
	dav1d
	fallbackswitch
	file
	flavors
	gif
	hsv
	json
	lewton
	rav1e
	regex
	reqwest
	rspng
	rusoto
	sodium
	test
	textwrap
	threadshare
	togglerecord
	tutorial
	webp
	version-helper"
# TODO add/package gst-plugins-csound
#RUST_V="1.52" upstrem requirement
RUST_DEPEND="
	|| (
		(
			~dev-lang/rust-1.52.1[${MULTILIB_USEDEP}]
			~dev-lang/rust-bin-1.52.1[${MULTILIB_USEDEP}]
		)
	)"
RDEPEND+=" ${RUST_DEPEND}
	>=media-libs/gstreamer-1.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.0:1.0[${MULTILIB_USEDEP}]
	dav1d? ( >=media-libs/dav1d-0.8.2[${MULTILIB_USEDEP}] )
	sodium? ( dev-libs/libsodium[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
# Update while keeping track of versions of virtual/rust.
# Expanded here because the virtual system is broken for multilib.
BDEPEND+=" ${BDEPEND}
	${RUST_DEPEND}
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
                >=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
        )
	|| (
		(
			sys-devel/llvm:11[${MULTILIB_USEDEP}]
			sys-devel/clang:11[${MULTILIB_USEDEP}]
		)
		(
			sys-devel/llvm:12[${MULTILIB_USEDEP}]
			sys-devel/clang:12[${MULTILIB_USEDEP}]
		)
		(
			sys-devel/llvm:13[${MULTILIB_USEDEP}]
			sys-devel/clang:13[${MULTILIB_USEDEP}]
		)
	)
	dev-util/cargo-c
	>=dev-util/meson-0.56"
EGIT_COMMIT="ada328df010e31487afd8c6b56756e40f099b6d6"
SRC_URI="
https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/${EGIT_COMMIT}/gst-plugins-rs-${EGIT_COMMIT}.tar.bz2
	-> gst-plugins-rs-${EGIT_COMMIT:0:7}.tar.bz2
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
PATCHES=( "${FILESDIR}/gst-plugins-rs-0.6.0_p20210607-modular-build.patch" )

pkg_setup() {
	if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download the internal dependencies."
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
		die \
"The LLVM/clang version is not supported.  Send a issue request to update the \
ebuild."
	fi
	einfo "LLVM=${LLVM_MAX_SLOT}"

	emesonargs+=(
		$(meson_feature audiofx)
		$(meson_feature cdg)
		$(meson_feature claxon)
		$(meson_feature closedcaption)
		$(meson_feature csound)
		$(meson_feature dav1d)
		$(meson_feature fallbackswitch)
		$(meson_feature file)
		$(meson_feature flavors)
		$(meson_feature gif)
		$(meson_feature hsv)
		$(meson_feature json)
		$(meson_feature lewton)
		$(meson_feature rav1e)
		$(meson_feature regex)
		$(meson_feature reqwest)
		$(meson_feature rspng)
		$(meson_feature rusoto)
		$(meson_feature threadshare)
		$(meson_feature togglerecord)
		$(meson_feature webp)
		$(meson_feature textwrap)
		$(usex sodium -Dsodium=system -Dsodium=disabled)
	)

	pushd "${S}" || die
	if ! use tutorial ; then
		sed -i -e "/tutorial/d" \
			Cargo.toml || die
	fi

	if ! use audiofx ; then
		sed -i -e "/audiofx/d" \
			Cargo.toml || die
	fi

	if ! use cdg ; then
		sed -i -e "/cdg/d" \
			Cargo.toml || die
	fi

	if ! use claxon ; then
		sed -i -e "/claxon/d" \
			Cargo.toml || die
	fi

	if ! use closedcaption ; then
		sed -i -e "/closedcaption/d" \
			Cargo.toml || die
	fi

	if ! use csound ; then
		sed -i -e "/csound/d" \
			Cargo.toml || die
	fi

	if ! use dav1d ; then
		sed -i -e "/dav1d/d" \
			Cargo.toml || die
	fi

	if ! use fallbackswitch ; then
		sed -i -e "/fallbackswitch/d" \
			Cargo.toml || die
	fi

	if ! use file ; then
		sed -i -e "/generic\/file/d" \
			Cargo.toml || die
	fi

	if ! use flavors ; then
		sed -i -e "/flavors/d" \
			Cargo.toml || die
	fi

	if ! use gif ; then
		sed -i -e "/gif/d" \
			Cargo.toml || die
	fi

	if ! use hsv ; then
		sed -i -e "/hsv/d" \
			Cargo.toml || die
	fi

	if ! use json ; then
		sed -i -e "/json/d" \
			Cargo.toml || die
	fi

	if ! use lewton ; then
		sed -i -e "/lewton/d" \
			Cargo.toml || die
	fi

	if ! use rav1e ; then
		sed -i -e "/rav1e/d" \
			Cargo.toml || die
	fi

	if ! use regex ; then
		sed -i -e "/regex/d" \
			Cargo.toml || die
	fi

	if ! use reqwest ; then
		sed -i -e "/reqwest/d" \
			Cargo.toml || die
	fi

	if ! use rspng ; then
		sed -i -e "/rspng/d" \
			Cargo.toml || die
	fi

	if ! use rusoto ; then
		sed -i -e "/rusoto/d" \
			Cargo.toml || die
	fi

	if ! use textwrap ; then
		sed -i -e "/wrap/d" \
			Cargo.toml || die
	fi

	if ! use threadshare ; then
		sed -i -e "/threadshare/d" \
			Cargo.toml || die
	fi

	if ! use togglerecord ; then
		sed -i -e "/togglerecord/d" \
			Cargo.toml || die
	fi

	if ! use sodium ; then
		sed -i -e "/sodium/d" \
			Cargo.toml || die
	fi

	if ! use version-helper ; then
		sed -i -e "/version-helper/d" \
			Cargo.toml || die
	fi

	if ! use webp ; then
		sed -i -e "/webp/d" \
			Cargo.toml || die
	fi

	popd

	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install_all() {
	einstalldocs
}
