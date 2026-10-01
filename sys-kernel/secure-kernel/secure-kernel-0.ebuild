# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is to preform kernel security updates.

# Security:  update every kernel version bump
# This ebuild uses AI inference to better inform the FAFO user of the risks of bypassing mitigation.

KERNEL_MIN_SLOT="5.10" # inclusive
KERNEL_MIN_LTS_SLOT="6.1" # inclusive
KERNEL_MAX_LTS_SLOT="6.18" # inclusive
KERNEL_LIVE_SLOT="7.3"

LTS_VERSIONS=("5.10" "5.15" "6.1" "6.6" "6.12" "6.18")
ACTIVE_VERSIONS=("5.10" "5.15" "6.1" "6.6" "6.12" "6.18" "7.2" "7.3")
STABLE_OR_MAINLINE_VERSIONS=("7.2" "7.3")

ALL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.10" "5.11" "5.12" "5.13" "5.14" "5.15" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.1" "6.2" "6.3" "6.4" "6.5" "6.6" "6.7" "6.8" "6.9" "6.11" "6.12" "6.13" "6.14" "6.15" "6.16" "6.17" "6.18" "6.19" "7.0" "7.1"
	"7.2" "7.3"
)

EOL_VERSIONS=(
	"0"
	"1"
	"2"
	"3"
	"4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "4.10" "4.11" "4.12" "4.13" "4.14" "4.15" "4.16" "4.17" "4.18" "4.19" "4.20"
	"5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "5.11" "5.12" "5.13" "5.14" "5.16" "5.17" "5.18" "5.19"
	"6.0" "6.2" "6.3" "6.4" "6.5" "6.7" "6.8" "6.9" "6.10" "6.11" "6.13" "6.14" "6.15" "6.16" "6.17" "6.19" "7.0" "7.1"
)

CHKL_TIMESTAMPS=(
	"sys-apps/util-linux-9999"
	"sys-kernel/linux-next-9999"
	"sys-kernel/ot-sources-7.3.9999"
	"sys-kernel/raspberrypi-image-9999"
	"sys-kernel/vanilla-kernel-6.1.9999"
	"sys-kernel/vanilla-kernel-6.6.9999"
	"sys-kernel/vanilla-kernel-6.12.9999"
	"sys-kernel/vanilla-kernel-6.18.9999"
)

KERNEL_FLAVORS=(
        "kernel_flavor_asahi-kernel"
        "kernel_flavor_asahi-sources"
        "kernel_flavor_cachyos-kernel"
        "kernel_flavor_cachyos-kernel-bin"
	"kernel_flavor_cachyos-sources"
        "kernel_flavor_gentoo-kernel"
        "kernel_flavor_gentoo-kernel-bin"
	"kernel_flavor_gentoo-sources"
        "kernel_flavor_git-sources"
        "kernel_flavor_hardened-sources"
        "kernel_flavor_linux-next"
        "kernel_flavor_liquorix-sources"
        "kernel_flavor_mips-sources"
        "kernel_flavor_ot-sources"
        "kernel_flavor_pf-sources"
        "kernel_flavor_raspberrypi-image"
        "kernel_flavor_raspberrypi-sources"
        "kernel_flavor_rt-sources"
        "kernel_flavor_surface-sources"
        "kernel_flavor_vanilla-kernel"
        "kernel_flavor_vanilla-sources"
        "kernel_flavor_xanmod-kernel"
        "kernel_flavor_xanmod-rt"
        "kernel_flavor_xanmod-sources"
        "kernel_flavor_xanmod-sources-rt"
        "kernel_flavor_zen-sources"
)

KERNEL_SLOTS=(
	"kernel_slot_5_10"
	"kernel_slot_5_15"
	"kernel_slot_6_1"
	"kernel_slot_6_1_live"
	"kernel_slot_6_6"
	"kernel_slot_6_6_live"
	"kernel_slot_6_12"
	"kernel_slot_6_12_live"
	"kernel_slot_6_18"
	"kernel_slot_6_18_live"
	"kernel_slot_7_2"
	"kernel_slot_rc"
	"kernel_slot_live"
)

inherit secure-version

MULTISLOT_LATEST_KERNEL_RELEASE=("${LINUX_KERNEL_5_10_PV}" "${LINUX_KERNEL_5_15_PV}" "${LINUX_KERNEL_6_1_PV}" "${LINUX_KERNEL_6_6_PV}" "${LINUX_KERNEL_6_12_PV}" "${LINUX_KERNEL_6_18_PV}" "${LINUX_KERNEL_7_2_PV}" "${LINUX_KERNEL_7_3_RC_PV}")

inherit chkl secure-kernel toolchain-funcs

S="${WORKDIR}"

DESCRIPTION="Enforce secure kernel updates"
SLOT="0"
KEYWORDS="~amd64 ~x86"
VIDEO_CARDS=(
	video_cards_nvidia
)
IUSE+="
${VIDEO_CARDS[@]}
ebuild_revision_0
"

RDEPEND="
	enforce? (
		!sys-kernel/rock-dkms
		!sys-kernel/rocm-sources
		!custom-kernel? (
			$(gen_render_kernels_list_v2)
		)
		intel-microcode? (
			>=sys-firmware/intel-microcode-${INTEL_MICROCODE_PV}
		)
		linux-firmware? (
			>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
		)
		video_cards_nvidia? (
			x11-drivers/nvidia-drivers:=
			!x11-drivers/nvidia-drivers:0/390
			!x11-drivers/nvidia-drivers:0/470
			|| (
				>=x11-drivers/nvidia-drivers-610.43.03:0/610
				>=x11-drivers/nvidia-drivers-595.84:0/595
				>=x11-drivers/nvidia-drivers-580.173.02:0/580
				>=x11-drivers/nvidia-drivers-535.309.01:0/535
			)
		)
	)
"
BDEPEND="
	>=sys-apps/util-linux-${UTIL_LINUX_PV}
"
PDEPEND="
	sys-kernel/mitigate-dos:*
	sys-kernel/mitigate-dt:*
	sys-kernel/mitigate-id:*
	dss? (
		sys-kernel/dss:*
	)
"

pkg_setup() {
	use enforce || return
	mitigate-dt_pkg_setup
}

src_configure() {
	use enforce || ewarn "The USE enforce flag is disabled."
	chkl_check_many_timestamps
}

src_compile() {
	:
}

pkg_postinst() {
	:
}
