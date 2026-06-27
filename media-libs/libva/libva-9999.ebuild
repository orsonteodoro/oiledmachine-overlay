# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-libs/wayland-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
)

inherit cflags-hardened chkl meson-multilib optfeature secure-version

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://github.com/intel/libva"

if [[ ${PV} = *9999 ]] ; then
	FALLBACK_COMMIT="ad64eb9b616d1b66afaf4cb9f0ea0b8e0ec1169c"
	inherit git-r3
	EGIT_BRANCH=master
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	EGIT_REPO_URI="https://github.com/intel/libva"
else
	SRC_URI="https://github.com/intel/libva/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
IUSE+=" glx wayland X"
REQUIRED_USE="glx? ( X )"

RDEPEND="
	>=x11-libs/libdrm-${LIBDRM_PV}:=[${MULTILIB_USEDEP}]
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=[${MULTILIB_USEDEP}]
	)
	X? (
		glx? (
			>=media-libs/libglvnd-${LIBGLVND_PV}:=[X?,${MULTILIB_USEDEP}]
		)
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-${LIBXFIXES_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-${LIBXCB_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	wayland? ( dev-util/wayland-scanner )
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/va/va_backend_glx.h
	/usr/include/va/va_x11.h
	/usr/include/va/va_dri2.h
	/usr/include/va/va_dricommon.h
	/usr/include/va/va_glx.h
)

src_unpack() {
	if [[ ${PV} = *9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Ddriverdir="${EPREFIX}/usr/$(get_libdir)/va/drivers"
		-Ddisable_drm=false
		-Dwith_x11=$(usex X)
		-Dwith_glx=$(usex X $(usex glx))
		-Dwith_wayland=$(usex wayland)
		-Denable_docs=false
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature_header
	optfeature "Older Intel GPU support up to Gen8" media-libs/libva-intel-driver
	optfeature "Newer Intel GPU support from Gen9+" media-libs/libva-intel-media-driver
}
