# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_PV="20240722.0"

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
)

inherit meson-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="
	https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/
	https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/
"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
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
	# Backport
	"${FILESDIR}/${P}-gcc15-cstdint.patch"
	# Unmerged
	#"${FILESDIR}/${PN}-2.1-abseil-cpp-202508.patch"
)

DOCS=( "AUTHORS" "NEWS" "README.md" )

src_unpack() {
	unpack ${A}
}

multilib_src_configure() {
	export PKG_CONFIG_PATH="/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	local emesonargs=(
		$(meson_feature cpu_flags_arm_neon "neon")
		$(meson_use cpu_flags_x86_sse "inline-sse")
	)
	meson_src_configure
}

multilib_src_install_all() {
	fix_libs_abi() {
		IFS=$'\n'
		L=(
			"${ED}/usr/$(get_libdir)/libwebrtc-audio-processing-2.so.1"
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
