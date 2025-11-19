# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_PV="20230125.1"

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

inherit meson-multilib

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
ebuild_revision_2
"

RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%.*}[${MULTILIB_USEDEP},cxx_standard_cxx17]
	dev-cpp/abseil-cpp:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/patchelf
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
	export PKG_CONFIG_PATH="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	if [[ "${ABI}" == "x86" ]] ; then
		# bug #921140
		local -x CPPFLAGS="${CPPFLAGS} -DPFFFT_SIMD_DISABLE"
	fi

	local emesonargs=(
		-Dneon=$(usex cpu_flags_arm_neon "yes" "no")
	)
	meson_src_configure
}

multilib_src_install_all() {
	fix_libs_abi() {
		IFS=$'\n'
		L=(
			"${ED}/usr/$(get_libdir)/libwebrtc-audio-coding-1.so.3"
			"${ED}/usr/$(get_libdir)/libwebrtc-audio-processing-1.so.3"
		)
		IFS=$' \t\n'
		d="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)"
		for x in ${L[@]} ; do
			[[ -L "${x}" ]] && continue
einfo "Adding ${d} to RPATH for ${x}"
			patchelf \
				--add-rpath "${d}" \
				"${x}" \
				|| die
		done

	}

	multilib_foreach_abi fix_libs_abi
}
