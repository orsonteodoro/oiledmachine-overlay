# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
MY_P="libnice-${PV}"

inherit cflags-hardened meson-multilib

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://libnice.freedesktop.org/releases/${MY_P}.tar.gz"

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="https://libnice.freedesktop.org/"
LICENSE="
	|| (
		LGPL-2.1
		MPL-1.1
	)
"
SLOT="1.0"
IUSE="
ebuild_revision_10
"
RDEPEND="
	media-libs/gstreamer:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP}]
	~net-libs/libnice-${PV}[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-0.1.21-use-installed-libnice.patch"
)

multilib_src_configure() {
	cflags-hardened_append
	# gnutls versus openssl is left intentionally automagic here.  The
	# chosen USE flag configuration of libnice will ensure one of them is
	# present.  Configure will be happy, but gstreamer bits don't use it, so
	# it doesn't matter.  gupnp is not used in the gst plugin.
	local emesonargs=(
		-Dcrypto-library=auto
		-Dgstreamer=enabled
		-Dgupnp=disabled
		-Dintrospection=disabled
	)
	meson_src_configure
}
