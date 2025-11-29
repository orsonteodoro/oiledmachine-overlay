# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit autotools libcxx-slot libstdcxx-slot

KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
SRC_URI="https://github.com/thestk/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="A set of cross-platform C++ classes for realtime audio I/O"
HOMEPAGE="https://www.music.mcgill.ca/~gary/rtaudio/"
LICENSE="MIT"
SLOT="0/7"
IUSE="+alsa doc jack pulseaudio static-libs"
REQUIRED_USE="
	|| (
		alsa
		jack
		pulseaudio
	)
"

RDEPEND="
	alsa? (
		media-libs/alsa-lib
	)
	jack? (
		media-libs/alsa-lib
		virtual/jack
	)
	pulseaudio? (
		media-libs/libpulse
	)
	"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? (
		app-text/doxygen
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.0-cflags.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	default

	# don't rebuild docs
	export ac_cv_prog_DOXYGEN=

	eautoreconf
}

src_configure() {
	# OSS support requires OSSv4
	local myconf=(
		$(use_enable static-libs static)
		$(use_with jack)
		$(use_with alsa)
		$(use_with pulseaudio pulse)
		--without-oss
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake

	if use doc; then
		pushd doc
		doxygen || die
		popd
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc "README.md" "doc/release.txt"
	if use doc; then
		dodoc -r "doc/html"
		dodoc -r "doc/images"
	fi

	find "${D}" -name "*.la" -delete
}
