# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_SLOT="20230125"

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

inherit abseil-cpp meson-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="
	https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/
	https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/
"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux"
IUSE="
${CPU_FLAGS_ARM[@]}
ebuild_revision_3
"

RDEPEND="
	>=dev-cpp/abseil-cpp-20230125.1:${ABSEIL_CPP_SLOT%.*}[${MULTILIB_USEDEP},cxx_standard_cxx17]
	dev-cpp/abseil-cpp:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3-Add-generic-byte-order-and-pointer-size-detection.patch"
	"${FILESDIR}/${PN}-1.3-big-endian-support.patch"
	"${FILESDIR}/${PN}-1.3-x86-no-sse.patch"
	"${FILESDIR}/${PN}-1.3-musl.patch"
	"${FILESDIR}/${PN}-1.3-gcc15-cstdint.patch"
)

DOCS=( "AUTHORS" "NEWS" "README.md" )

src_unpack() {
	unpack ${A}
}

multilib_src_configure() {
	abseil-cpp_src_configure
	if [[ "${ABI}" == "x86" ]] ; then
		# bug #921140
		local -x CPPFLAGS="${CPPFLAGS} -DPFFFT_SIMD_DISABLE"
	fi

	local emesonargs=(
		-Dneon=$(usex cpu_flags_arm_neon "yes" "no")
	)
	meson_src_configure
}
