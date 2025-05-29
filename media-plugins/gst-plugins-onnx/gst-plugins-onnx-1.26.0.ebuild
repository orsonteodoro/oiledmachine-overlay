# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened flag-o-matic gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="ONNX neural network plugin for GStreamer"
IUSE+="
ebuild_revision_13
"
RDEPEND="
	$(python_gen_any_dep '
		>=sci-ml/onnxruntime-1.16.1[${PYTHON_SINGLE_USEDEP}]
	')
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="
	${REPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	append-cppflags -I/usr/include/onnxruntime/core/session
	append-libs -lonnxruntime
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
