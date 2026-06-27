# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package containing deps on all xorg drivers"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
else
	PROPERTIES+=" live"
fi

IUSE_INPUT_DEVICES="
	input_devices_elographics
	input_devices_evdev
	input_devices_joystick
	input_devices_libinput
	input_devices_vmmouse
	input_devices_void
	input_devices_synaptics
	input_devices_wacom
"
IUSE_VIDEO_CARDS="
	video_cards_amdgpu
	video_cards_ast
	video_cards_dummy
	video_cards_fbdev
	video_cards_freedreno
	video_cards_geode
	video_cards_i915
	video_cards_intel
	video_cards_mga
	video_cards_nouveau
	video_cards_qxl
	video_cards_r128
	video_cards_radeon
	video_cards_radeonsi
	video_cards_siliconmotion
	video_cards_tegra
	video_cards_vc4
	video_cards_vesa
	video_cards_nvidia
"

IUSE="${IUSE_VIDEO_CARDS} ${IUSE_INPUT_DEVICES}"

PDEPEND="
	input_devices_elographics? ( >=x11-drivers/xf86-input-elographics-${PV} )
	input_devices_evdev?       (
								 >=x11-base/xorg-server-${PV}[udev]
								 >=x11-drivers/xf86-input-evdev-${PV}
							   )
	input_devices_joystick?    ( >=x11-drivers/xf86-input-joystick-1.6.3 )
	input_devices_libinput?    (
								 >=x11-base/xorg-server-${PV}[udev]
								 >=x11-drivers/xf86-input-libinput-${PV}
							   )
	input_devices_vmmouse?     ( >=x11-drivers/xf86-input-vmmouse-${PV} )
	input_devices_void?        ( >=x11-drivers/xf86-input-void-${PV} )
	input_devices_synaptics?   ( >=x11-drivers/xf86-input-synaptics-${PV} )
	input_devices_wacom?       ( >=x11-drivers/xf86-input-wacom-${PV} )

	video_cards_amdgpu?        ( >=x11-drivers/xf86-video-amdgpu-${PV} )
	video_cards_ast?           ( >=x11-drivers/xf86-video-ast-${PV} )
	video_cards_dummy?         ( >=x11-drivers/xf86-video-dummy-${PV} )
	video_cards_fbdev?         ( >=x11-drivers/xf86-video-fbdev-${PV} )
	video_cards_freedreno?     ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_geode?         ( >=x11-drivers/xf86-video-geode-${PV} )
	video_cards_i915?          ( >=x11-drivers/xf86-video-intel-${PV} )
	video_cards_intel?         ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_mga?           ( >=x11-drivers/xf86-video-mga-${PV} )
	video_cards_nouveau?       ( >=x11-drivers/xf86-video-nouveau-${PV} )
	video_cards_qxl?           ( >=x11-drivers/xf86-video-qxl-${PV} )
	video_cards_nvidia?        ( x11-drivers/nvidia-drivers )
	video_cards_r128?          ( >=x11-drivers/xf86-video-r128-${PV} )
	video_cards_radeon?        ( >=x11-drivers/xf86-video-ati-${PV} )
	video_cards_radeonsi?      ( >=x11-drivers/xf86-video-ati-${PV} )
	video_cards_siliconmotion? ( >=x11-drivers/xf86-video-siliconmotion-${PV} )
	video_cards_tegra?         ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_vc4?           ( >=x11-base/xorg-server-${PV}[-minimal] )
	video_cards_vesa?          ( >=x11-drivers/xf86-video-vesa-${PV} )
"
