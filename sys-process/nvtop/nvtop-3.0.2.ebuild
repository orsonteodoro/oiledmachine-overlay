# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# *DEPENDS based on U 18.04

LINUX_KERNEL_AMDGPU_FDINFO_KV="5.14"
LINUX_KERNEL_INTEL_FDINFO_KV="5.19"
LINUX_KERNEL_MSM_FDINFO_KV="6.0"
VIDEO_CARDS=(
	amdgpu
	freedreno
	intel
	nvidia
)

inherit cmake linux-info xdg

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE="
		fallback-commit
	"
	EGIT_REPO_URI="https://github.com/Syllo/${PN}.git"
	FALLBACK_COMMIT="2b6d62aada9752b5229fbd83921c9da01aa427d3" # Jun 11, 2023
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
https://github.com/Syllo/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="GPU & Accelerator process monitoring"
HOMEPAGE="https://github.com/Syllo/nvtop"
LICENSE="GPL-3+"
SLOT="0"
IUSE+="
${VIDEO_CARDS[@]/#/video_cards_}
custom-kernel systemd udev unicode
ebuild_revision_1
"
REQUIRED_USE="
	video_cards_amdgpu? (
		^^ (
			udev
			systemd
		)
	)
	video_cards_intel? (
		^^ (
			udev
			systemd
		)
	)
	|| (
		${VIDEO_CARDS[@]/#/video_cards_}
	)
"
gen_kernel_repend() {
	local kv="${1}"
	echo "
		>=sys-kernel/ot-sources-${kv}
		>=sys-kernel/gentoo-sources-${kv}
		>=sys-kernel/git-sources-${kv}
		>=sys-kernel/pf-sources-${kv}
		>=sys-kernel/rt-sources-${kv}
		>=sys-kernel/zen-sources-${kv}
		>=sys-kernel/raspberrypi-sources-${kv}
		>=sys-kernel/gentoo-kernel-${kv}
		>=sys-kernel/gentoo-kernel-bin-${kv}
		>=sys-kernel/vanilla-sources-${kv}
		>=sys-kernel/vanilla-kernel-${kv}
	"
}
RDEPEND="
	>=sys-libs/ncurses-6.1:0=
	udev? (
		!systemd? (
			!sys-fs/eudev
			>=sys-apps/systemd-utils-237[udev]
		)
	)
	systemd? (
		>=sys-apps/systemd-237
	)
	video_cards_amdgpu? (
		!custom-kernel? (
			|| (
				$(gen_kernel_repend ${LINUX_KERNEL_AMDGPU_FDINFO_KV})
				(
					|| (
						$(gen_kernel_repend ${LINUX_KERNEL_AMDGPU_FDINFO_KV})
					)
					>=sys-kernel/rock-dkms-4.3.0
				)
			)
		)
		>=x11-libs/libdrm-2.4.99[video_cards_amdgpu]
	)
	video_cards_freedreno?  (
		!custom-kernel? (
			|| (
				$(gen_kernel_repend ${LINUX_KERNEL_MSM_FDINFO_KV})
			)
		)
		>=x11-libs/libdrm-2.4.99[video_cards_freedreno]
	)
	video_cards_intel?  (
		!custom-kernel? (
			|| (
				$(gen_kernel_repend ${LINUX_KERNEL_INTEL_FDINFO_KV})
			)
		)
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.10
	>=sys-devel/gcc-7.4.0
	virtual/pkgconfig
"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK=" ~PROC_FS"
	if use video_cards_amdgpu ; then
		CONFIG_CHECK+=" ~DRM_AMDGPU ~SYSFS"
		local kv=$(uname -r | cut -f 1 -d "-")
		if ver_test ${kv} -lt ${LINUX_KERNEL_AMDGPU_FDINFO_KV} ; then
ewarn
ewarn "Kernel version requirements is not met for the running kernel."
ewarn
ewarn "Detected kernel version:  $(uname -r)"
ewarn "Required kernel version:  ${LINUX_KERNEL_AMDGPU_FDINFO_KV} or later"
ewarn
		fi
	fi
	if use video_cards_intel ; then
		CONFIG_CHECK+=" ~DRM_I915"
		local kv=$(uname -r | cut -f 1 -d "-")
		if ver_test ${kv} -lt ${LINUX_KERNEL_INTEL_FDINFO_KV} ; then
ewarn
ewarn "Kernel version requirements is not met for the running kernel."
ewarn
ewarn "Detected kernel version:  $(uname -r)"
ewarn "Required kernel version:  ${LINUX_KERNEL_INTEL_FDINFO_KV} or later"
ewarn
		fi
	fi
	if use video_cards_freedreno ; then
		CONFIG_CHECK+=" ~DRM_MSM"
		local kv=$(uname -r | cut -f 1 -d "-")
		if ver_test ${kv} -lt ${LINUX_KERNEL_MSM_FDINFO_KV} ; then
ewarn
ewarn "Kernel version requirements is not met for the running kernel."
ewarn
ewarn "Detected kernel version:  $(uname -r)"
ewarn "Required kernel version:  ${LINUX_KERNEL_MSM_FDINFO_KV} or later"
ewarn
		fi
	fi
	if use video_cards_nvidia ; then
		if [[ -e "${EROOT}/usr/"*"/libnvidia-ml.so"  ]] ; then
			:;
		elif [[ -e "${EROOT}/usr/"*"/libnvidia-ml.so.1"  ]] ; then
			:;
		else
ewarn
ewarn "Missing NVML library.  emerge x11-drivers/nvidia-drivers."
ewarn
		fi
	fi
	check_extra_config
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DAMDGPU_SUPPORT=$(usex video_cards_amdgpu)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCURSES_NEED_WIDE=$(usex unicode)
		-DINTEL_SUPPORT=$(usex video_cards_intel)
		-DMSM_SUPPORT=$(usex video_cards_freedreno)
		-DNVIDIA_SUPPORT=$(usex video_cards_nvidia)
		-DUSE_LIBUDEV_OVER_LIBSYSTEMD=$(usex udev)
	)
	cmake_src_configure
}
