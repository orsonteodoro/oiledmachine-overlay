# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-driver-bundle.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for bundled driver installation
# @DESCRIPTION:
# The ot-kernel-bundles eclass contains per decade or per platform
# computer configurations.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${OT_KERNEL_DRIVER_BUNDLE_ECLASS}" ]] ; then

inherit toolchain-funcs ot-kernel-kutils

# TODO:
# Review xpad for wooting keyboards changes
# Review/verify DVB-T for CONFIG_MEDIA_TUNER_MT2060 sections

#
# Rollover rules:
#
# For mobo components, they can rollover a year forward (e.g. 1999 can roll over to 2000s profile; early decade [2004] can roll over to late decade [2005]) but not backward.
# For accessories or cards, they can rollover backwards or forward decades if compatible.
# If an older edition card or older accessory has been observed during that time period, it can be placed in that time period.
#

ot-kernel-driver-bundle_check_name_changes() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics:rv670"($|" ") ]] ; then
eerror "The graphics:rv670 profile has been removed.  Use graphics:terascale1 or graphics:r600."
		die
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "haptic-devices:"($|" ") ]] ; then
eerror "The haptic-devices prefix has been renamed to haptic-device."
		die
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1900"($|" ") ]] ; then
eerror "The sound:1900 profile has been renamed to sound:1990s."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1990"($|" ") ]] ; then
eerror "The sound:1990 profile has been renamed to sound:1990s."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2000"($|" ") ]] ; then
eerror "The sound:2000 profile has been renamed to sound:2000s."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2010"($|" ") ]] ; then
eerror "The sound:2010 profile has been renamed to sound:2010s."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2020"($|" ") ]] ; then
eerror "The sound:2020 profile has been renamed to sound:2020s."
		die
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-1990s-pc-gamer" ]] ; then
eerror "The early-1990s-pc-gamer profile has been removed.  Use the early-1990s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-pc-gamer" ]] ; then
eerror "The late-1990s-pc-gamer profile has been removed.  Use the late-1990s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-musician" ]] ; then
eerror "The late-1990s-musician profile has been removed.  Use the late-1990s-desktop-pc with sound:1990s-musician profiles instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "1990s-cgi-artist" ]] ; then
eerror "The 1990s-cgi-artist profile has been removed.  Use the early-1990s-desktop-pc or late-1990s-desktop-pc with 3d-mouse:6dof profiles instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "1990s-drafter" ]] ; then
eerror "The 1990s-drafter profile has been removed.  Use the early-1990s-desktop-pc or late-1990s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-2000s-pc-gamer" ]] ; then
eerror "The early-2000s-pc-gamer profile has been renamed.  Use the early-2000s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-2000s-pc-gamer" ]] ; then
eerror "The late-2000s-pc-gamer profile has been renamed.  Use the late-2000s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-pc-gamer" ]] ; then
eerror "The 2010s-pc-gamer profile has been renamed.  Use the 2010s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-cgi-artist" ]] ; then
eerror "The 2010s-cgi-artist profile has been renamed.  Use the 2010s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-video-game-artist" ]] ; then
eerror "The 2010s-video-game-artist profile has been renamed.  Use the 2010s-desktop-pc profile instead."
		die
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2020s-pc-gamer" ]] ; then
eerror "The 2020s-pc-gamer profile has been renamed.  Use the 2020s-desktop-pc profile instead."
		die
	fi
	if declare -f ot-kernel-driver-bundle_add_custom_bundle_drivers ; then
eerror "ot-kernel-driver-bundle_add_custom_bundle_drivers has been renamed to ot-kernel-driver-bundle_add_custom_driver_bundle"
		die
	fi
}

# @FUNCTION: ot-kernel-driver-bundle_add_drivers
# @DESCRIPTION:
# Main routine for installing drivers in bundles
ot-kernel-driver-bundle_add_drivers() {
	local disable_xpad=0
	if \
		   has_version "games-util/xone" \
		|| has_version "games-util/xpadneo" \
		|| has_version "games-util/xboxdrv" \
	; then
ewarn "Disabling xpad driver"
		disable_xpad=1
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD"
		ot-kernel_unset_configopt "CONFIG_JOYSTICK_XPAD_FF"
	fi

	# /dev nodes
	ot-kernel_y_configopt "CONFIG_DEVTMPFS"

	# Internet
	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_IPV6"
	ot-kernel_y_configopt "CONFIG_NET"

	# Disabled to reduce build times.
	# Used by TV tuner cards with a lot of revisions.
	ot-kernel_unset_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT"

	ot-kernel-driver-bundle_check_name_changes

	# The memory and processing speed in earlier decades was very limited.
	# This is why the decades were split.
	ot-kernel-driver-bundle_add_early_1990s_desktop_pc_drivers
	ot-kernel-driver-bundle_add_late_1990s_desktop_pc_drivers
	ot-kernel-driver-bundle_add_early_2000s_desktop_pc_drivers
	ot-kernel-driver-bundle_add_late_2000s_desktop_pc_drivers
	ot-kernel-driver-bundle_add_vpceb25fx_drivers
	ot-kernel-driver-bundle_add_2010s_desktop_pc_drivers
	ot-kernel-driver-bundle_add_15_da0086nr_drivers
	ot-kernel-driver-bundle_add_2020s_desktop_pc_drivers
	if declare -f ot-kernel-driver-bundle_add_custom_driver_bundle ; then
einfo "Adding a custom driver bundle"
		ot-kernel-driver-bundle_add_custom_driver_bundle
	fi
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_1990s_desktop_pc_drivers
# @DESCRIPTION:
# An early 1990s x86 gamer driver bundle
# At least Pentium is available for this ebuild
ot-kernel-driver-bundle_add_early_1990s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-1990s-desktop-pc" ]] || return
ewarn "The early-1990s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "isa pci"
	ot-kernel-driver-bundle_add_graphics "isa pci" # vlb is not suppored
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_keyboard "ps2"
	ot-kernel-driver-bundle_add_mouse "ps2 serial"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_sound "early-1990 isa"

	# Ethernet
	# Most computers were 32-bit, even though 64-bit was released.
	# The 64-bit config option needs to be disabled in order to access the ISA option to enable ISA drivers.
	#ot-kernel_unset_configopt "CONFIG_64BIT"
	ot-kernel_y_configopt "CONFIG_ISA"
	ot-kernel_y_configopt "CONFIG_EISA"
	ot-kernel_y_configopt "CONFIG_EL3" # 1992
	ot-kernel_y_configopt "CONFIG_NE2000" # 1988
	ot-kernel_y_configopt "CONFIG_WD80x3" # 1987

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_6dof "serial"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_1990s_desktop_pc_drivers
# @DESCRIPTION:
# A late 1990s x86 gamer driver bundle
ot-kernel-driver-bundle_add_late_1990s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-desktop-pc" ]] || return
ewarn "The late-1990s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_watchdog "late-1990"
	ot-kernel-driver-bundle_add_expansion_slots "isa pci agp"
	ot-kernel-driver-bundle_add_graphics "agp pci"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 serial usb"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd-rw"
	ot-kernel-driver-bundle_add_sound "late-1990 isa pci"

	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_SFF"
	ot-kernel_y_configopt "CONFIG_ATA_BMDMA"
	ot-kernel_y_configopt "CONFIG_ATA_PIIX" # 1995-2007 (PATA)
	ot-kernel_y_configopt "CONFIG_PATA_AMD" # 1999-2004
	ot-kernel_y_configopt "CONFIG_PATA_ALI" # 1997
	ot-kernel_y_configopt "CONFIG_PATA_HPT366" # 1999
	ot-kernel_y_configopt "CONFIG_PATA_OLDPIIX" # 1995
	ot-kernel_y_configopt "CONFIG_PATA_SIS" # 1999
	ot-kernel_y_configopt "CONFIG_PATA_VIA" # 1995
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_ALI15X3" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_ALI1535" # 1999
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_SIS5595" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_VIA" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_VIAPRO" # 1998, 1999, 2000, 2002, 2004, 2006, 2008, 2009, 2010
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_AD7414" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_AD7418" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1025" # 1999, 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM9240" # 1999, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999-2019
	ot-kernel_y_configopt "CONFIG_SENSORS_LM77" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_LM78" # 1999, 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_LM80" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_LM83" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_PC87360" # 1998, 1999, 2000/2001
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47M1" # 1998, 2002, 2005, 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_VT8231" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_W83627HF" # 1998
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007

	# Ethernet
	ot-kernel_y_configopt "CONFIG_8139TOO" # 1997
	ot-kernel_y_configopt "CONFIG_E100" # 1997
	ot-kernel_y_configopt "CONFIG_EISA"
	ot-kernel_y_configopt "CONFIG_EL3" # 1992
	ot-kernel_y_configopt "CONFIG_EPIC100" # 1996
	ot-kernel_y_configopt "CONFIG_NE2K_PCI" # 1998
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NET_TULIP" # 1994
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_3COM"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_AMD"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_DEC"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_VIA"
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCNET32" # 1996
	ot-kernel_y_configopt "CONFIG_VIA_RHINE" # 1995
	ot-kernel_y_configopt "CONFIG_VORTEX" # 1995

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_graphics_tablet "serial usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet"
	ot-kernel-driver-bundle_add_6dof "serial usb-1.1"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
	ot-kernel-driver-bundle_add_tv_tuner "pci" # For the USB 1.1, it still require a year 2000 CPU for consistent 30 FPS.
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_2000s_desktop_pc_drivers
# @DESCRIPTION:
# An early 2000s x86 music production driver bundle
ot-kernel-driver-bundle_add_early_2000s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-2000s-desktop-pc" ]] || return
ewarn "The early-2000s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_watchdog "early-2000"
	ot-kernel-driver-bundle_add_expansion_slots "isa pci agp"
	ot-kernel-driver-bundle_add_graphics "agp pci"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 usb"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram"
	ot-kernel-driver-bundle_add_external_storage "ide parport scsi"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_data_storage_interfaces "sata"
	ot-kernel-driver-bundle_add_sound "early-2000 isa pci pcie"

	# For HDD
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_SFF"
	ot-kernel_y_configopt "CONFIG_ATA_BMDMA"
	ot-kernel_y_configopt "CONFIG_ATA_PIIX" # 1995-2007 (PATA), 2003-2006 (SATA)
	ot-kernel_y_configopt "CONFIG_PATA_AMD" # 1999-2004
	ot-kernel_y_configopt "CONFIG_PATA_HPT366" # 1999
	ot-kernel_y_configopt "CONFIG_PATA_HPT37X" # 2001
	ot-kernel_y_configopt "CONFIG_PATA_HPT3X2N" # 2003
	ot-kernel_y_configopt "CONFIG_PATA_HPT3X3" # ?
	ot-kernel_y_configopt "CONFIG_PATA_VIA" # 1995
	ot-kernel_y_configopt "CONFIG_SATA_NV" # 2004
	ot-kernel_y_configopt "CONFIG_SATA_VIA" # 2003
	ot-kernel_y_configopt "CONFIG_SATA_VITESSE" # 2002
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SOUND"

	# CPU sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_K8TEMP" # 2003

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_DMI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_ALI1563" # 2002
	ot-kernel_y_configopt "CONFIG_I2C_ALI1535" # 1999
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_NFORCE2" # 2002, 2003, 2004
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_SIS630" # 2000, 2003
	ot-kernel_y_configopt "CONFIG_I2C_SIS96X" # 2001, 2002
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_VIAPRO" # 1998, 1999, 2000, 2002, 2004, 2006, 2008, 2009, 2010
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_AD7414" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_AD7418" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1025" # 1999, 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM9240" # 1999, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7470" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7411" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1031" # 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_ASB100" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_DME1737" # 2004, 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_F71805F" # 2004, 2006, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_F75375S" # 2002, 2005, 2014
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999-2019
	ot-kernel_y_configopt "CONFIG_SENSORS_LM63" # 2002, 2008
	ot-kernel_y_configopt "CONFIG_SENSORS_LM75" # 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_LM77" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_LM78" # 1999, 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_LM80" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_LM83" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_LM85" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_LM90" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_LM92" # 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_LM93" # 2003
	ot-kernel_y_configopt "CONFIG_SENSORS_PC87360" # 1998, 1999, 2000/2001
	ot-kernel_y_configopt "CONFIG_SENSORS_PC87427" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47M1" # 1998, 2002, 2005, 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47M192" # 2001, 2005, 2006, 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47B397" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_VT1211" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_VT8231" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_VIA686A" # 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83791D" # 2001
	ot-kernel_y_configopt "CONFIG_SENSORS_W83L785TS" # 2002

	# Ethernet
	ot-kernel_y_configopt "CONFIG_8139CP" # 2003
	ot-kernel_y_configopt "CONFIG_8139TOO" # 2000
	ot-kernel_y_configopt "CONFIG_E100" # 1997
	ot-kernel_y_configopt "CONFIG_E1000" # 2000
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_3COM"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_AMD"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_VIA"
	ot-kernel_y_configopt "CONFIG_PCNET32" # 1996
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_VIA_RHINE" # 1995
	ot-kernel_y_configopt "CONFIG_VORTEX" # 1995

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "serial usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet"
	ot-kernel-driver-bundle_add_6dof "serial usb-1.1 usb-2.0"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pci usb-1.1 usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_2000s_desktop_pc_drivers
# @DESCRIPTION:
# A late 2000s x86 desktop PC driver bundle
ot-kernel-driver-bundle_add_late_2000s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-2000s-desktop-pc" ]] || return
ewarn "The late-2000s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_watchdog "late-2000"
	ot-kernel-driver-bundle_add_expansion_slots "agp pci pcie"
	ot-kernel-driver-bundle_add_graphics "agp pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 usb"
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd+rw dvd-rw dvd+rw dvd-ram"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_data_storage_interfaces "sata"
	ot-kernel-driver-bundle_add_sound "late-2000 pci"

	# For HDD
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_SFF"
	ot-kernel_y_configopt "CONFIG_ATA_BMDMA"
	ot-kernel_y_configopt "CONFIG_ATA_PIIX" # 1995-2007 (PATA), 2003-2006 (SATA)
	ot-kernel_y_configopt "CONFIG_PATA_AMD" # 1999-2004
	ot-kernel_y_configopt "CONFIG_PATA_ATIIXP" # 2007
	ot-kernel_y_configopt "CONFIG_PATA_VIA" # 1995
	ot-kernel_y_configopt "CONFIG_SATA_NV" # 2004
	ot-kernel_y_configopt "CONFIG_SATA_VIA" # 2003
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# CPU temp sensors
	ot-kernel_y_configopt "CONFIG_AMD_NB"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_K10TEMP" # 2007-2014
	ot-kernel_y_configopt "CONFIG_SENSORS_VIA_CPUTEMP" # 2005/2008

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_NFORCE2" # 2002, 2003, 2004
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_VIAPRO" # 1998, 1999, 2000, 2002, 2004, 2006, 2008, 2009, 2010
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU3" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1025" # 1999, 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1026" # <=2008
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1177" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7410" # 2009, 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7462" # 2008
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7470" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7475" # 2007, 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ATK0110" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_DME1737" # 2004, 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_EMC1403" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_EMC2305" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_EMC6W201" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999-2019
	ot-kernel_y_configopt "CONFIG_SENSORS_F71805F" # 2004, 2006, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_F71882FG" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_F75375S" # 2002, 2005, 2014
	ot-kernel_y_configopt "CONFIG_SENSORS_I5500" # 2008-2009
	ot-kernel_y_configopt "CONFIG_SENSORS_LM63" # 2002, 2008
	ot-kernel_y_configopt "CONFIG_SENSORS_LM73" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_LM87" # 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_LM90" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_LM95234" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_LM95241" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_LM95245" # 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47B397" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_SMSC47M192" # 2001, 2005, 2006, 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83627EHF" # 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83792D" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_W83793" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_W83795" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_W83L786NG" # 2006

	# Ethernet
	ot-kernel_y_configopt "CONFIG_8139TOO" # 1999
	ot-kernel_y_configopt "CONFIG_BNX2" # 2008
	ot-kernel_y_configopt "CONFIG_E1000" # 2000
	ot-kernel_y_configopt "CONFIG_E1000E" # 2005
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_IGB" # 2008
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_3COM"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_AMD"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_BROADCOM"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_MARVELL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_VIA"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCNET32" # 1996
	ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK_OPTIONAL"
	ot-kernel_y_configopt "CONFIG_R8169" # 2003
	ot-kernel_y_configopt "CONFIG_SKGE" # 1999
	ot-kernel_y_configopt "CONFIG_SKY2" # 2004 (architecture), 2007 (specific model)
	ot-kernel_y_configopt "CONFIG_TIGON3" # 2001
	ot-kernel_y_configopt "CONFIG_VIA_RHINE" # 1995
	ot-kernel_y_configopt "CONFIG_VORTEX" # 1995

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "serial usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet"
	ot-kernel-driver-bundle_add_6dof "serial usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pci pcie usb-1.1 usb-2.0 usb-3.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_vpceb25fx_drivers
# @DESCRIPTION:
# Driver bundle for vpceb25fx (2010)
ot-kernel-driver-bundle_add_vpceb25fx_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "vpceb25fx" ]] || return
ewarn "The vpceb25fx driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_watchdog "2010 mei"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_mouse "usb"
	# No USB 3.0
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram"

	# For backlight, Fn keys
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_VIDEO"
	ot-kernel_y_configopt "CONFIG_BACKLIGHT_CLASS_DEVICE"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_RFKILL"
	ot-kernel_y_configopt "CONFIG_SONY_LAPTOP" # Adding a platform driver example
	ot-kernel_y_configopt "CONFIG_X86_PLATFORM_DEVICES"

	# For touchpad
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2_ALPS"
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_HID_ALPS"

	# For HDD
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_BMDMA"
	ot-kernel_y_configopt "CONFIG_ATA_PIIX" # 2003-2006 (SATA)
	ot-kernel_y_configopt "CONFIG_ATA_SFF"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	# For graphics
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_DRM_I915"

	# For Wi-Fi
	ot-kernel_y_configopt "CONFIG_CFG80211"
	ot-kernel_y_configopt "CONFIG_IWLWIFI" # 2001, 2002, 2003, 2004, 2008, 2009, 2011, 2013, 2014, 2015, 2019
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_WLAN"
	ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_INTEL"

	# For physical Wi-Fi switch
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_RFKILL"

	# Ethernet
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_MARVELL"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SKY2" # 2004 (architecture), 2007 (specific model)

	# Use power efficient algorithm
	ot-kernel_y_configopt "CONFIG_DEFAULT_BBR"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_BBR"

	# Only SD reader supported
	ot-kernel_y_configopt "CONFIG_MMC"
	ot-kernel_y_configopt "CONFIG_MMC_SDHCI"
	ot-kernel_y_configopt "CONFIG_MMC_SDHCI_PCI" # 2006
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# MemoryStick does not work, checked several years ago
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_MEMSTICK"
	ot-kernel_y_configopt "CONFIG_MSPRO_BLOCK"
	ot-kernel_y_configopt "CONFIG_MS_BLOCK"

	# For battery management
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_AC"
	ot-kernel_y_configopt "CONFIG_ACPI_BATTERY"
	ot-kernel_y_configopt "CONFIG_ACPI_BUTTON"
	ot-kernel_y_configopt "CONFIG_ACPI_FAN"
	ot-kernel_y_configopt "CONFIG_ACPI_PROCESSOR"
	ot-kernel_y_configopt "CONFIG_ACPI_THERMAL"
	ot-kernel_y_configopt "CONFIG_ACPI_VIDEO"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_BACKLIGHT_CLASS_DEVICE"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_THERMAL"

	# CPU temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_PCI"

	# Sound support
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # Audio only
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel-driver-bundle_add_midi_playback_support

	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet usb"
	ot-kernel-driver-bundle_add_6dof "usb-1.1 usb-2.0"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "usb-1.1 usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_desktop_pc_drivers
# @DESCRIPTION:
# A 2010s x86 desktop PC driver bundle
ot-kernel-driver-bundle_add_2010s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-desktop-pc" ]] || return
ewarn "The 2010s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_watchdog "2010"
	ot-kernel-driver-bundle_add_expansion_slots "pci pcie"
	ot-kernel-driver-bundle_add_graphics "pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram 4k-blu-ray"
	ot-kernel-driver-bundle_add_data_storage_interfaces "nvme sata"
	ot-kernel-driver-bundle_add_sound "2010 pcie"

	# CPU temp sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_CPU_SUP_AMD"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_K10TEMP" # 2007-2014
	ot-kernel_y_configopt "CONFIG_SENSORS_FAM15H_POWER" # 2011-2015

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_VIAPRO" # 1998, 1999, 2000, 2002, 2004, 2006, 2008, 2009, 2010
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1029" # 2012
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM9240" # 1999, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7410" # 2009, 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_ADT7475" # 2007, 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ASUS_WMI" # 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_ATK0110" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_EMC2103" # 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_EMC2305" # 2009, 2011
	ot-kernel_y_configopt "CONFIG_SENSORS_I5500" # 2008-2009
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999-2019
	ot-kernel_y_configopt "CONFIG_SENSORS_F71805F" # 2004, 2006, 2010
	ot-kernel_y_configopt "CONFIG_SENSORS_F71882FG" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_F75375S" # 2002, 2005, 2014
	ot-kernel_y_configopt "CONFIG_SENSORS_LTC2991" # 2015
	ot-kernel_y_configopt "CONFIG_SENSORS_LTC4282" # 2015
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT6683" # 2013
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT7802" # 2012
	ot-kernel_y_configopt "CONFIG_USB_HID" # Dependency of CONFIG_SENSORS_NZXT_KRAKEN2

	# Temp, Fan control
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_CPRO" # 2017

	# PSU temp
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_PSU" # 2013

	# Water cooler sensors
	ot-kernel_y_configopt "CONFIG_SENSORS_AQUACOMPUTER_D5NEXT" # 2018
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_KRAKEN2" # 2016

	# Ethernet
	ot-kernel_y_configopt "CONFIG_ALX" # 2011
	ot-kernel_y_configopt "CONFIG_E1000" # 2000
	ot-kernel_y_configopt "CONFIG_E1000E" # 2005
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_IGB" # 2008
	ot-kernel_y_configopt "CONFIG_IXGBE" # 2003
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_ATHEROS"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_BROADCOM"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_MARVELL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK_OPTIONAL"
	ot-kernel_y_configopt "CONFIG_R8169" # 2003
	ot-kernel_y_configopt "CONFIG_TIGON3" # 2001
	ot-kernel_y_configopt "CONFIG_SKY2" # 2004 (architecture), 2007 (specific model)

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "usb serial"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet usb"
	ot-kernel-driver-bundle_add_6dof "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_bluetooth
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-1.1 usb-2.0 usb-3.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_15_da0086nr_drivers
# @DESCRIPTION:
# Driver bundle for 15-da0086nr (2019)
ot-kernel-driver-bundle_add_15_da0086nr_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "15-da0086nr" ]] || return
ewarn "The 15-da0086nr driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_watchdog "2010 mei"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel_y_configopt "CONFIG_USB_XHCI_PLATFORM"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram"

	# Keyboard
	#ot-kernel_y_configopt "CONFIG_ACPI_PROCFS_POWER" # Debug
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD"
	ot-kernel_y_configopt "CONFIG_SERIO"
	ot-kernel_y_configopt "CONFIG_SERIO_I8042"

	# Multimedia keys
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_HP_WMI"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_X86_PLATFORM_DEVICES"
	ot-kernel_y_configopt "CONFIG_X86_PLATFORM_DRIVERS_HP"

	# Touchpad
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2_SYNAPTICS"

	# Touchscreen on LED screen
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_TOUCHSCREEN"
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HID_GENERIC"
	ot-kernel_y_configopt "CONFIG_HID_MULTITOUCH"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"

	# PCIe
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCIE_ASPM"
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"

	# Graphics
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_DRM_I915"
	ot-kernel_y_configopt "CONFIG_DRM_I915_GVT_KVMGT"
	ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"
	ot-kernel_y_configopt "CONFIG_FIRMWARE_EDID"
	ot-kernel_y_configopt "CONFIG_PCI"

	# HDMI sound for TV output
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_DRM_DISPLAY_HDMI_HELPER"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # Audio, audio only

	# SATA
	ot-kernel_y_configopt "CONFIG_AHCI_PLATFORM" # SATA
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_ATA_GENERIC"
	ot-kernel_y_configopt "CONFIG_ATA_PIIX"
	ot-kernel_y_configopt "CONFIG_LIBATA"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"
	ot-kernel_y_configopt "CONFIG_SCSI_SATA"
	ot-kernel_y_configopt "CONFIG_SCSI_MOD"

	# RAID
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_INTEL_ISH_AHCI"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	# Sensors
	ot-kernel_y_configopt "CONFIG_ACPI_PROCESSOR"
	ot-kernel_y_configopt "CONFIG_ACPI_THERMAL"
	ot-kernel_y_configopt "CONFIG_HID_SENSOR_HUB"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CORE"
	ot-kernel_y_configopt "CONFIG_I2C_HID"
	ot-kernel_y_configopt "CONFIG_I2C_I801"
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_INTEL_ISH_FIRMWARE"
	ot-kernel_y_configopt "CONFIG_INTEL_ISH_HID"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP"
	ot-kernel_y_configopt "CONFIG_THERMAL_INTEL"

	# Fan
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_HP_WMI_SENSORS"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_THERMAL"

	# Audio
	ot-kernel_y_configopt "CONFIG_COMMON_CLK"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # Audio only
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_SOC"
	ot-kernel_y_configopt "CONFIG_SND_SOC_INTEL_AVS"
	ot-kernel_y_configopt "CONFIG_SND_SOC_INTEL_MACH"
	ot-kernel_y_configopt "CONFIG_SND_SOC_INTEL_SKL"
	ot-kernel_y_configopt "CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC"
	ot-kernel_y_configopt "CONFIG_SND_SOC_SOF_PCI"
	ot-kernel_y_configopt "CONFIG_SND_SOC_SOF_INTEL_SKL"
	ot-kernel_y_configopt "CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL"

	# Bluetooth
	ot-kernel_y_configopt "CONFIG_BT"
	ot-kernel_y_configopt "CONFIG_BT_CORE"
	ot-kernel_y_configopt "CONFIG_BT_HCIBTUSB"
	ot-kernel_y_configopt "CONFIG_BT_HCIUART"
	ot-kernel_y_configopt "CONFIG_BT_HCIUART_3WIRE"
	ot-kernel_y_configopt "CONFIG_BT_HCIUART_H4"
	ot-kernel_y_configopt "CONFIG_BT_HCIUART_RTL"
	ot-kernel_y_configopt "CONFIG_BT_HCIUART_SERDEV"
	ot-kernel_y_configopt "CONFIG_GPIOLIB"
	ot-kernel_y_configopt "CONFIG_NET"

	# Ethernet
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_R8169"

	# WiFi
	ot-kernel_y_configopt "CONFIG_FW_LOADER"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_RTW88"
	ot-kernel_y_configopt "CONFIG_RTW88_CORE"
	ot-kernel_y_configopt "CONFIG_RTW88_8723DE"
	ot-kernel_y_configopt "CONFIG_WLAN"
	ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"

	# Webcam
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_V4L2_MEM2MEM_DRIVERS" # Webcam
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"

	# Card reader
	ot-kernel_y_configopt "CONFIG_MMC"
	ot-kernel_y_configopt "CONFIG_MMC_BLOCK"
	ot-kernel_y_configopt "CONFIG_MMC_REALTEK_PCI"
	ot-kernel_y_configopt "CONFIG_MMC_SDHCI"
	ot-kernel_y_configopt "CONFIG_MMC_SDHCI_ACPI"
	ot-kernel_y_configopt "CONFIG_MMC_SDHCI_PCI"

	# CPU
	ot-kernel_y_configopt "CONFIG_X86"
	ot-kernel_y_configopt "CONFIG_MICROCODE_INTEL"

	# Use power efficient algorithm
	ot-kernel_y_configopt "CONFIG_DEFAULT_BBR"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_ADVANCED"
	ot-kernel_y_configopt "CONFIG_TCP_CONG_BBR"

	# Power management
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_CPU_FREQ"
	ot-kernel_y_configopt "CONFIG_INT340X_THERMAL"
	ot-kernel_y_configopt "CONFIG_INTEL_LPSS_PCI"
	ot-kernel_y_configopt "CONFIG_INTEL_PMC_CORE"
	ot-kernel_y_configopt "CONFIG_INTEL_PCH_THERMAL"
	ot-kernel_y_configopt "CONFIG_INTEL_PMT_TELEMETRY"
	ot-kernel_y_configopt "CONFIG_INTEL_PSTATE"
	ot-kernel_y_configopt "CONFIG_INTEL_RAPL"
	ot-kernel_y_configopt "CONFIG_INTEL_UNCORE_FREQ_CONTROL"
	ot-kernel_unset_configopt "CONFIG_INTEL_VSEC"
	ot-kernel_y_configopt "CONFIG_MFD_INTEL_LPSS_PCI"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS"
	ot-kernel_y_configopt "CONFIG_PM"
	ot-kernel_y_configopt "CONFIG_POWERCAP"
	ot-kernel_y_configopt "CONFIG_PCIE_PME"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI_PLATFORM"
	ot-kernel_y_configopt "CONFIG_THERMAL"
	ot-kernel_y_configopt "CONFIG_THERMAL_INTEL_CPU"
	ot-kernel_y_configopt "CONFIG_X86_PLATFORM_DEVICES"

	# Support legacy devices
	ot-kernel_y_configopt "CONFIG_INTEL_LPC"

	# Virtualization
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_DRM_I915_GVT"
	ot-kernel_y_configopt "CONFIG_INTEL_IOMMU"
	ot-kernel_y_configopt "CONFIG_IOMMU_SUPPORT"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCI_MSI"

	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "usb serial"
	ot-kernel-driver-bundle_add_haptic_devices "usb"
	ot-kernel-driver-bundle_add_6dof "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-1.1 usb-2.0 usb-3.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2020s_desktop_pc_drivers
# @DESCRIPTION:
# A 2020s x86 desktop PC driver bundle
ot-kernel-driver-bundle_add_2020s_desktop_pc_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2020s-desktop-pc" ]] || return
ewarn "The 2020s-desktop-pc driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_rtc_cmos
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_watchdog "2020"
	ot-kernel-driver-bundle_add_expansion_slots "pcie"
	ot-kernel-driver-bundle_add_graphics "pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram 4k-blu-ray"
	ot-kernel-driver-bundle_add_data_storage_interfaces "nvme sata"
	ot-kernel-driver-bundle_add_sound "2020 pcie"

	# CPU temp sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ASUS_EC"

	# CPU cooler sensors
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_SENSORS_ASUS_ROG_RYUJIN" # 2021
	ot-kernel_y_configopt "CONFIG_SENSORS_GIGABYTE_WATERFORCE" # 2021
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_KRAKEN3" # 2020

	# Fan or lighting control
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_SMART2" # 2020

	# Ethernet
	ot-kernel_y_configopt "CONFIG_AQTION"
	ot-kernel_y_configopt "CONFIG_E1000E" # 2005
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_I40E" # 2020
	ot-kernel_y_configopt "CONFIG_ICE" # 2020
	ot-kernel_y_configopt "CONFIG_IGB" # 2007
	ot-kernel_y_configopt "CONFIG_IXGBE" # 2003
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_AQUANTIA"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCI_MSI"
	ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK_OPTIONAL"
	ot-kernel_y_configopt "CONFIG_R8169" # 2003

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "usb serial"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet usb"
	ot-kernel-driver-bundle_add_6dof "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_bluetooth
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-1.1 usb-2.0 usb-3.0"

	if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
		# For AI support
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_ACCEL"
		ot-kernel_y_configopt "CONFIG_DRM_ACCEL_IVPU"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
}

ot-kernel-driver-bundle_add_rtc_cmos() {
	ot-kernel_y_configopt "CONFIG_RTC_CLASS"
	ot-kernel_y_configopt "CONFIG_RTC_DRV_CMOS"
}

ot-kernel-driver-bundle_add_data_storage_interfaces() {
	local tags="${1}"
	if [[ "${tags}" =~ "nvme" ]] ; then
	# 2011
	# For NVMe SSD
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_NVME" # 2011
	fi

	if [[ "${tags}" =~ "sata" ]] ; then
	# 2004
	# For SATA HDD/SSD
		ot-kernel_y_configopt "CONFIG_ATA"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_SATA_AHCI"
	fi
}

ot-kernel-driver-bundle_add_midi_playback_support() {
	# To play MIDI music
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_SEQUENCER"
	ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"
	ot-kernel_y_configopt "CONFIG_SOUND"
}

ot-kernel-driver-bundle_add_optical_drive() {
	local tags="${1}"
	# CD-ROM (1985, PC version)
	# CD-R (1995)
	# CD-RW (1997)
	# DVD-ROM (1996)
	# DVD-R (1997)
	# DVD+R (2002)
	# DVD-RW (1999)
	# DVD-RAM (1998)
	# DVD+RW (2001)
	# Blu-ray (2006)
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_SCSI"
	if [[ "${tags}" =~ "cd" ]] ; then
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_ISO9660_FS" # 1998, 4 GiB limit
		ot-kernel_y_configopt "CONFIG_JOLIET" # 1995, 8 GiB limit total, 4 GiB files
	fi
	if [[ "${tags}" =~ "dvd" ]] ; then
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_ISO9660_FS" # 1998, 4 GiB limit
		ot-kernel_y_configopt "CONFIG_JOLIET" # 1995, 8 GiB limit total, 4 GiB files
		ot-kernel_y_configopt "CONFIG_UDF_FS" # 1995, 16 EiB limit
	fi

	if [[ "${tags}" =~ ("cd-rw"($|" ")|"dvd-rw"($|" ")|"dvd+rw"($|" ")|"dvd-ram"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_BLK_DEV"
		ot-kernel_y_configopt "CONFIG_SCSI"
		ot-kernel_y_configopt "CONFIG_CDROM_PKTCDVD"
	fi

	if [[ "${tags}" =~ "4k-blu-ray" ]] && [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
	# Blu-ray 4K support (2016)
		ot-kernel_y_configopt "CONFIG_CPU_SUP_INTEL"
		ot-kernel_y_configopt "CONFIG_CRYPTO"
		ot-kernel_y_configopt "CONFIG_CRYPTO_SHA256"
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_PROCESSOR_SELECT"
		ot-kernel_y_configopt "CONFIG_X86_SGX"
		ot-kernel_y_configopt "CONFIG_X86_X2APIC"
# CE, DoS, DT, ID, PE
ewarn "If you do not update the BIOS, please disable SGX after 4K Blu-ray use."
ewarn "SGX is known to have vulnerabilities and may be exploited over network."
	else
	# The AI said that kernel disablement is not the best way to neutralize the vulnerabilities.
	# The best way it to disable it -- it claims is through the BIOS.
		ot-kernel_unset_configopt "CONFIG_X86_SGX"
	fi
}

ot-kernel-driver-bundle_add_usb_storage_support() {
	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000
}

ot-kernel-driver-bundle_add_floppy_drive() {
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	ot-kernel_y_configopt "CONFIG_BLOCK"
}

ot-kernel-driver-bundle_add_printer() {
	local tags="${1}"
	if [[ "${tags}" =~ "parport" ]] ; then
		ot-kernel_y_configopt "CONFIG_PARPORT" # For printer
		ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
		ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
		ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_PRINTER"
	fi
}

ot-kernel-driver-bundle_add_webcam_by_vendor_name() {
	# See https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/media/gspca-cardlist.rst
	local is_gspca=0

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:benq") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_BENQ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:conexant"|"webcam:creative") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_CONEX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:cpia1"|"webcam:stmicroelectronics") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_CPIA1"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dtcs033") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_DTCS033"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:endpoints") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_EP800"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:etoms") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ETOMS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:finepix"|"webcam:fujifilm") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_FINEPIX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:jeilinj") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_JEILINJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:jl2005bcd") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_JL2005BCD"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:microsoft") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KINECT" # 2010
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:konica"|"webcam:intel") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KONICA"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:mars") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_MARS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:mars"|"webcam:mars-semi"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_MR97310A"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:divio"|"webcam:logitech"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_NW80X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:d-link"|"webcam:microsoft"|"webcam:omnivision"|"webcam:sony"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:hercules"|"webcam:guillemot"|"webcam:omnivision"|"webcam:sony") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:hercules"|"webcam:guillemot"|"webcam:omnivision") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534_9"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:d-link"|"webcam:genius"|"webcam:hp"($|" ")|"webcam:hewlett-packard"|"webcam:labtec"|"webcam:pixart"|"webcam:philips"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:genius"|"webcam:hercules"|"webcam:guillemot"|"webcam:labtec"|"webcam:pixart"|"webcam:philips"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pixart"|"webcam:philips"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7311"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:aox"|"webcam:endpoints"|"webcam:kensington"|"webcam:philips") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SE401"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:genius"|"webcam:sonix") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C2028"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:genius"|"webcam:microsoft"|"webcam:sonix"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C20X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:genius"|"webcam:sonix") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXB"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:genius"|"webcam:hercules"|"webcam:guillemot"|"webcam:microsoft"|"webcam:philips"|"webcam:sonix") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA1528"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:agfa"|"webcam:benq"|"webcam:creative"|"webcam:d-link"|"webcam:intel"|"webcam:kodak"|"webcam:logitech"|"webcam:mustek"|"webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:3com"|"webcam:arowana"|"webcam:intel"|"webcam:kodak"|"webcam:smile-international"|"webcam:sunplus"|"webcam:viewqwest") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA501"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:intel"|"webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA505"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA506"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:intel"|"webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA508"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:genius"|"webcam:labtec"|"webcam:logitech"|"webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sq-technologies") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ905"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:lego"|"webcam:sq-technologies") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ905C"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:sq-technologies"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ930X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:syntek") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STK014"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:asus"|"webcam:syntek") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STK1135"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:stmicroelectronics") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STV0680"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:benq"|"webcam:creative"|"webcam:fujifilm"|"webcam:genius"|"webcam:jvc"|"webcam:logitech"|"webcam:medion"|"webcam:mustek"|"webcam:philips"|"webcam:polaroid"|"webcam:sunplus"|"webcam:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:t613") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_T613"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:topro") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TOPRO"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:touptek") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TOUPTEK"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:labtec"|"webcam:logitech") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TV8532"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:a4tech"|"webcam:creative"|"webcam:hp"($|" ")|"webcam:hewlett-packard"|"webcam:logitech"|"webcam:samsung"|"webcam:vimicro"|"webcam:z-star") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:3com"|"webcam:vicam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VICAM"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:xirlink_cit") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_XIRLINK_CIT"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:creative"|"webcam:genius"|"webcam:hp"($|" ")|"webcam:hewlett-packard"|"webcam:labtec"|"webcam:logitech"|"webcam:mustek"|"webcam:philips"|"webcam:vimicro"|"webcam:z-star") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:gl860") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GL860"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ali"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_M5602"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:lego"|"webcam:logitech"|"webcam:stmicroelectronics") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_STV06XX"
		is_gspca=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:ame"\
|"webcam:askey"\
|"webcam:creative"\
|"webcam:logitech"\
|"webcam:philips"\
|"webcam:samsung"\
|"webcam:sotec"\
|"webcam:visionite"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_PWC" # 2000, 2001, 2002, 2003, 2006
	fi

	if (( ${is_gspca} == 1 )) ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:acer"\
|"webcam:actions-microelectronics"\
|"webcam:alcor-micro"\
|"webcam:alienware"\
|"webcam:apple"\
|"webcam:arkmicro"\
|"webcam:asus"\
|"webcam:aveo-technology"\
|"webcam:bodelin"\
|"webcam:chicony"\
|"webcam:cisco"\
|"webcam:dell"\
|"webcam:ecamm"\
|"webcam:foxlink"\
|"webcam:jmicron"\
|"webcam:generic-brand"
|"webcam:genesys-logic"\
|"webcam:generalplus-technology"\
|"webcam:genius"\
|"webcam:geo-semiconductor"\
|"webcam:guillemot"\
|"webcam:fujitsu"\
|"webcam:hp"($|" ")\
|"webcam:hewlett-packard"\
|"webcam:imc-networks"\
|"webcam:insta360"\
|"webcam:jaotech"\
|"webcam:kurokesu"
|"webcam:lenovo"\
|"webcam:logilink"\
|"webcam:logitech"\
|"webcam:medion"\
|"webcam:microsoft"\
|"webcam:msi"\
|"webcam:nanotech"\
|"webcam:nxp"($|" ")\
|"webcam:nxp-semiconductors"\
|"webcam:oculus"($|" ")\
|"webcam:oculus-vr"\
|"webcam:omnivision"\
|"webcam:ophir-optronics"\
|"webcam:packard-bell"\
|"webcam:quanta"\
|"webcam:quanta-computer"\
|"webcam:samsung"\
|"webcam:shenzen"\
|"webcam:sigma-micro"\
|"webcam:syntek"\
|"webcam:tasco"\
|"webcam:the-imaging-source"\
|"webcam:thermoteknix"\
|"webcam:vimicro"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
	fi
}

# Currently the 90s and 2000s major brands are triaged first in this list before
# the UVC era, then the ones with multiple architectures under one driver
# Only the model name, not the vendor name or not brand should be keyworded.
ot-kernel-driver-bundle_add_webcam_by_model_name() {
	# See https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/media/gspca-cardlist.rst
	local is_gspca=0

	# 3Com
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:homeconnect-lite") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA501"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:homeconnect-usb-camera"|"webcam:homeconnect-webcam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VICAM"
		is_gspca=1
	fi

	# A4Tech
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pk-130mg") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi

	# Agfa
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:cl20"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi

	# ALi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:video-camera-controller") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_M5602"
		is_gspca=1
	fi

	# ASUS
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:a8j-laptop-webcam"\
|"webcam:f3s-laptop-webcam"\
|"webcam:f5r-laptop-webcam"\
|"webcam:v1s-laptop-webcam"\
|"webcam:vx2s-laptop-webcam"\
)\
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STK1135"
		is_gspca=1
	fi

	# BenQ
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dc-1300"|"webcam:dc-1500"|"webcam:dc-3410") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dc-1016") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dc-e300") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_BENQ"
		is_gspca=1
	fi

	# Creative
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:notebook-cx11646") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_CONEX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:live-cam-video-im-vf0350"\
|"webcam:live-vista-im"\
|"webcam:live-vista-vf0330"\
|"webcam:live-vista-vf0350"\
|"webcam:live-vista-vf0400"\
|"webcam:live-vista-vf0420"\
|"webcam:live-vista-vf0470"\
|"webcam:video-blaster-webcam-go-plus"\
|"webcam:webcam"($|" ")\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-vista-plus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:qmax") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TOPRO"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pc-cam-300") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-nx-ultra") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA505"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-vista-pd1100") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA508"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-vista-pd1100"|"webcam:webcam-vista-vf0010") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:go-mini") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STV0680"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:joy-it"|"webcam:live-ultra"|"webcam:live-ultra-for-notebooks"|"webcam:live-motion") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ930X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pc-cam-350"|"webcam:pc-cam-600"|"webcam:pc-cam-750") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:live-cam-notebook-ultra-vc0130") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:live"($|" ")\
|"webcam:live-cam-notebook-pro-vf0250"\
|"webcam:live-cam-video-im"\
|"webcam:nx"($|" ")\
|"webcam:nx-pro"($|" ")\
|"webcam:nx-pro2"($|" ")\
|"webcam:instant-p0620"\
|"webcam:instant-p0620d"\
|"webcam:webcam-live"($|" ")\
|"webcam:webcam-mobile-pd1090"\
|"webcam:webcam-notebook-pd1171"\
|"webcam:webcam-nx-pro"\
|"webcam:webcam-vista-pro"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi

	# D-Link
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dsb-c310-webcam"|"webcam:usb-digital-video-cam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dsb-c120") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dsc-350") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi

	# Endpoints
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ep800"|"webcam:se401"|"webcam:se402") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_EP800"
		is_gspca=1
	fi

	# Genius
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:e-messenger-112"|"webcam:gf112"|"webcam:ilook-111"|"webcam:videocam-ge110"|"webcam:videocam-ge111") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:eye-312"|"webcam:facecam-300"|"webcam:ilook-300"|"webcam:islim-300"|"webcam:islim-310") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:smart-300-version-2"|"webcam:videocam-live-v2") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C2028"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:i-look-1321"|"webcam:look-320s"|"webcam:look-1320-v2"|"webcam:slim-1320") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C20X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:geniuseye-310"|"webcam:videocam-look"|"webcam:videocam-messenger"|"webcam:videocam-nb") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXB"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:eye-311q"|"webcam:slim-310-nb") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:videocam-express-v2") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dsc-1.3-smart") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:videocam-v2"|"webcam:videocam-v3"|"webcam:videocam-web-v2") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi

	# Hercules (Guillemot)
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:classic-silver"|"webcam:deluxe-optical-glass") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:blog-webcam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:classic-link"|"webcam:link"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dualpix-hd-weblog") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534_9"
		is_gspca=1
	fi

	# HP
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:2.0-megapixel"|"webcam:2.0-megapixel-rz406aa") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:premium-starter-cam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi

	# Fujifilm
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:mv-1") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:finepix"\
|"webcam:finepix-4800"\
|"webcam:finepix-a202"\
|"webcam:finepix-a203"\
|"webcam:finepix-a204"\
|"webcam:finepix-a205"\
|"webcam:finepix-a210"\
|"webcam:finepix-a303"\
|"webcam:finepix-a310"\
|"webcam:finepix-f401"\
|"webcam:finepix-f402"\
|"webcam:finepix-f410"\
|"webcam:finepix-f420"\
|"webcam:finepix-f601"\
|"webcam:finepix-f700"\
|"webcam:finepix-m603"\
|"webcam:finepix-s300"\
|"webcam:finepix-s304"\
|"webcam:finepix-s500"\
|"webcam:finepix-s602"\
|"webcam:finepix-s700"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_FINEPIX"
		is_gspca=1
	fi

	# Kensington
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:67014"|"webcam:67015"|"webcam:67016"|"webcam:67017") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SE401"
		is_gspca=1
	fi

	# Labtec
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-1200") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:2200"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-elch2"|"webcam:webcam-plus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TV8532"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:webcam-notebook"|"webcam:webcam-pro") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi

	# Logitech
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:quickcam-pro-dark-focus-ring") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_NW80X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:quickcam-traveler"|"webcam:clicksmart-310"|"webcam:clicksmart-510") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:qc-chat-elch2"\
|"webcam:qc-elch2"\
|"webcam:qc-express-etch2"\
|"webcam:qc-for-notebook"\
|"webcam:quickcam-express-plus"\
	) ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:clicksmart-420"|"webcam:clicksmart-820") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:quickcam-express") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TV8532"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:orbicam"|"webcam:quickcam-for-dell-notebooks") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:notebook-deluxe"\
|"webcam:qc-im"\
|"webcam:qc-chat"\
|"webcam:qcam-stx"\
|"webcam:qcim"\
|"webcam:qccommunicate-stx"\
|"webcam:quickcam-e2500"\
|"webcam:quickcam-cool"\
|"webcam:quickcam-express"\
|"webcam:quickcam-for-notebooks"\
|"webcam:quickcam-image"\
|"webcam:quickcam-im/connect"\
|"webcam:quickcam-messenger"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:quickcam-communicate"|"webcam:quickcam-express"|"webcam:quickcam-messenger"|"webcam:quickcam-messenger"|"webcam:quickcam-web") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_STV06XX"
		is_gspca=1
	fi

	# Intel
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pocket-pc-camera") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:create-and-share") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA501"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pc-camera-pro") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA505"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:easy-pc-camera") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA508"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:yc76") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KONICA"
		is_gspca=1
	fi

	# JVC
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:gc-a50") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi

	# Kodak
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dvc-325") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA501"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ez200") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi

	# LEGO
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:bionicle") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ905C"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:legocam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_STV06XX"
		is_gspca=1
	fi

	# Microsoft
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:kinect") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KINECT" # 2010
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:vx1000"|"webcam:vx3000") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:xbox-cam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:lifecam-vx6000") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C20X"
		is_gspca=1
	fi

	# Mustek
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:gsmart-300") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:digicam-300k"\
|"webcam:dv-3000"\
|"webcam:dv4000-mpeg4"\
|"webcam:gsmart-lcd-2"\
|"webcam:gsmart-lcd-3"\
|"webcam:gsmart-mini-2"\
|"webcam:gsmart-mini-3"\
|"webcam:gsmart-d30"\
|"webcam:mdc3500"\
|"webcam:mdc4000"\
|"webcam:mdc5500z"\
)\
	 ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:wcam300a"|"webcam:wcam300-an") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi

	# Medion
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:md-41437") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi

	# OmniVision
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov511"|"webcam:ov518"|"webcam:ov519"|"webcam:ovfx2"|"webcam:supercam"|"webcam:w9967cf"|"webcam:w9968cf") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov534"|"webcam:veho-filmscanner") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534_9"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov534"|"webcam:ov722x") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534"
		is_gspca=1
	fi

	# Philips
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spc-600-nc"|"webcam:spc-700-nc"|"webcam:spc-710-nc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pcvc665k") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SE401"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dmvc1300k") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spc-200-nc"|"webcam:spc-300-nc"|"webcam:spc-210-nc"|"webcam:spc-315-nc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spc-220-nc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spc-230-nc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spc-500-nc"|"webcam:spc-610-nc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7311"
		is_gspca=1
	fi

	# Polaroid
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ion-80"|"webcam:pdc2030"|"webcam:pdc3070") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi

	# Samsung
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:q1-ultra-premium") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi

	# Sony
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:eyetoy") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:playstation-eye") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534"
		is_gspca=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:zc3xx"|"webcam:vc3xx"|"webcam:zc0301"|"webcam:zc0302"|"webcam:zc0303") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi

	# Trust
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spyc@m-100") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_MR97310A"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spacecam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_NW80X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:380-usb2-spacec@m") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:wb-1300n") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:wb-3300p"|"webcam:wb-3350p") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7311"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:wb-3600r") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C20X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:wb-3500t") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ930X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:610-lcd-powerc@m-zoom") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:commmunicate-stx"|"webcam:lifecam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
	fi

	if (( ${is_gspca} == 1 )) ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
	fi

# Only the model name, not the vendor name or not brand should be keyworded.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:292a-ipc-ar0330"\
|"webcam:2k-fhd-camera"\
|"webcam:808-camera"\
|"webcam:au3820"\
|"webcam:built-in-isight"($|" ")\
|"webcam:built-in-isight-via-ibridge"\
|"webcam:c1-pro"\
|"webcam:cnf7129"\
|"webcam:commmunicate-stx"\
|"webcam:display-capture-uvc05"\
|"webcam:easynote-mx52"\
|"webcam:eee-100he"\
|"webcam:eface-2025"\
|"webcam:f9sg"\
|"webcam:facetime-hd-camera"\
|"webcam:fsc-webcam-v30s"\
|"webcam:gc6500"\
|"webcam:hd-pro-webcam-c920"\
|"webcam:hd-pro-webcam-c922"\
|"webcam:hd-user-facing"\
|"webcam:classic-silver"\
|"webcam:hp-spartan"\
|"webcam:hp-webcam"($|" ")\
|"webcam:hp-webcam-hd-2300"\
|"webcam:lifecam-nx-6000"\
|"webcam:lifecam-nx-3000"\
|"webcam:lifecam-vx-7000"\
|"webcam:link"($|" ")\
|"webcam:ir-video"\
|"webcam:manta-mm-353-plako"\
|"webcam:medion-akoya"\
|"webcam:minoru3d"\
|"webcam:miricle-307k"\
|"webcam:mt6227"\
|"webcam:notebook"($|" ")\
|"webcam:ov7670"\
|"webcam:pc-usb-webcam"\
|"webcam:pico-image"\
|"webcam:positional-tracker-dk2"\
|"webcam:proscope-hr"\
|"webcam:q310"\
|"webcam:quickcam"($|" ")\
|"webcam:quickcam-fusion"\
|"webcam:quickcam-orbit-mp"\
|"webcam:quickcam-pro-5000"\
|"webcam:quickcam-pro-for-notebook"($|" ")\
|"webcam:rally-bar"($|" ")\
|"webcam:rally-bar-huddle"\
|"webcam:rally-bar-mini"\
|"webcam:realsense-d4m"\
|"webcam:realsense-depth-camera-d405"\
|"webcam:realsense-depth-camera-d410"\
|"webcam:realsense-depth-camera-d415"\
|"webcam:realsense-depth-camera-d430"\
|"webcam:realsense-depth-camera-d435"\
|"webcam:realsense-depth-camera-d435i"\
|"webcam:realsense-depth-camera-d455"\
|"webcam:realsense-depth-module-d421"\
|"webcam:rift-sensor"\
|"webcam:smart-terminal"\
|"webcam:sp2008wfp"\
|"webcam:spcam-620u"\
|"webcam:starcam-370i"\
|"webcam:studio-hybrid-140g"\
|"webcam:thinkpad-sl400"\
|"webcam:thinkpad-sl500"\
|"webcam:thinkpad-sl400"\
|"webcam:thinkpad-sl500"\
|"webcam:u3s"\
|"webcam:usb-2.0-camera"\
|"webcam:usb-2.0-pc-camera"\
|"webcam:usb2.0-xga-webcam"\
|"webcam:usb-ccd-cameras"\
|"webcam:usb-microscope"\
|"webcam:usb-web-camera"\
|"webcam:vega"\
|"webcam:vt-camera-ii"\
|"webcam:venus"\
|"webcam:webcam($|" ")"\
|"webcam:webcam-c910"\
|"webcam:webcam-b910"\
|"webcam:wireless-webcam"($|" ")\
|"webcam:x51"\
|"webcam:xps-m1530"\
|"webcam:xps-m1330"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
	fi
}

ot-kernel-driver-bundle_add_gspca_webcam_by_driver_name() {
	local is_gspca=0

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:benq") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_BENQ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:conex") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_CONEX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:cpia1") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_CPIA1"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:dtcs033") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_DTCS033"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ep800") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_EP800"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:etoms") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ETOMS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:finepix") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_FINEPIX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:jeilinj") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_JEILINJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:jl2005bcd") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_JL2005BCD"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:kinect") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KINECT" # 2010
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:konica") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_KONICA"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:mars") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_MARS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:mr97310a") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_MR97310A"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:nw80x") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_NW80X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov519") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV519" # 1998, 2000, 2002
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov534") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:ov534_9") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_OV534_9"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pac207") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC207"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pac7302") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7302"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pac7311") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_PAC7311"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:se401") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SE401"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sn9c2028") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C2028"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sn9c20x") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SN9C20X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sonixb") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXB"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sonixj") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SONIXJ"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca1528") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA1528"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca500") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA500"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca501") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA501"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca505") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA505"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca506") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA506"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca508") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA508"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:spca561") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SPCA561"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sq905") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ905"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sq905c") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ905C"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sq930x") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SQ930X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:stk014") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STK014"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:stk1135") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STK1135"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:stv0680") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_STV0680"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:sunplus") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_SUNPLUS"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:t613") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_T613"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:topro") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TOPRO"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:touptek") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TOUPTEK"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:tv8532") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_TV8532"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:vc032x") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VC032X"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:vicam") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_VICAM"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:xirlink_cit") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_XIRLINK_CIT"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:zc3xx") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GSPCA_ZC3XX"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:gl860") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_GL860"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:m5602") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_M5602"
		is_gspca=1
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:svt06xx") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_STV06XX"
		is_gspca=1
	fi

	if (( ${is_gspca} == 1 )) ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_GSPCA"
	fi
}

ot-kernel-driver-bundle_add_pwc_webcam_by_driver_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:pwc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_PWC" # 2000, 2001, 2002, 2003, 2006
	fi
}

ot-kernel-driver-bundle_add_pwc_webcam_by_model_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"webcam:afina-eye"\
|"webcam:cu-001"\
|"webcam:mpc-c10"\
|"webcam:mpc-c30"\
|"webcam:notebook-pro"\
|"webcam:pca645"\
|"webcam:pca646"\
|"webcam:pcvc675"\
|"webcam:pcvc680"\
|"webcam:pcvc690"\
|"webcam:pcvc720"\
|"webcam:pcvc730"\
|"webcam:pcvc740"\
|"webcam:pcvc750"\
|"webcam:quickcam-pro-3000"\
|"webcam:quickcam-pro-4000"\
|"webcam:quickcam-orbit"\
|"webcam:quickcam-sphere"\
|"webcam:spc900nc"\
|"webcam:vc010"
|"webcam:vcs-uc300"\
|"webcam:vcs-um100"\
|"webcam:webcam-5"\
|"webcam:webcam-pro-ex"\
|"webcam:zoom"($|" ")\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_USB_PWC" # 2000, 2001, 2002, 2003, 2006
	fi
}

ot-kernel-driver-bundle_add_uvc_webcam_by_driver_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:uvc") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV"
	fi
}

ot-kernel-driver-bundle_add_s2255_webcam() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:s2255drv"|"webcam:2255-usb-device"|"webcam:sensoray") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_USB_S2255"
	fi
}

ot-kernel-driver-bundle_add_usbtv007_webcam() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("webcam:usbtv007") ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_USBTV"
	fi
}

ot-kernel-driver-bundle_add_webcam() {
	ot-kernel_unset_configopt "CONFIG_MEDIA_SUPPORT_FILTER"
	ot-kernel-driver-bundle_add_webcam_by_vendor_name
	ot-kernel-driver-bundle_add_webcam_by_model_name
	ot-kernel-driver-bundle_add_gspca_webcam_by_driver_name
	ot-kernel-driver-bundle_add_pwc_webcam_by_driver_name
	ot-kernel-driver-bundle_add_pwc_webcam_by_model_name
	ot-kernel-driver-bundle_add_uvc_webcam_by_driver_name
	ot-kernel-driver-bundle_add_s2255_webcam
	ot-kernel-driver-bundle_add_usbtv007_webcam
	if grep -q -E -e "^CONFIG_USB_GSPCA_" "${path_config}" ; then
ewarn "You are likely using a 30 FPS camera, considered obsolete by today's video streaming standards."
ewarn "For gaming or sports, use a camera produced >= 2016 with 720p @ 60 FPS capability instead."
ewarn "For non-action, use a camera produced >= 2009 with 720p capability instead."
	fi
}

ot-kernel-driver-bundle_add_pc_speaker() {
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"
	ot-kernel_unset_configopt "CONFIG_SND_PCSP"
}

ot-kernel-driver-bundle_add_bluetooth() {
	# For speakers
	ot-kernel_y_configopt "CONFIG_BT"
	ot-kernel_y_configopt "CONFIG_BT_BNEP"
	ot-kernel_y_configopt "CONFIG_BT_BNEP_MC_FILTER"
	ot-kernel_y_configopt "CONFIG_BT_BNEP_PROTO_FILTER"
	ot-kernel_y_configopt "CONFIG_BT_BREDR"
	ot-kernel_y_configopt "CONFIG_BT_HIDP"
	ot-kernel_y_configopt "CONFIG_BT_RFCOMM"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_NET"
}

ot-kernel-driver-bundle_add_mouse() {
	local tags="${1}"
	if [[ "${tags}" =~ "ps2" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
		ot-kernel_y_configopt "CONFIG_MOUSE_PS2" # 1987
	fi
	if [[ "${tags}" =~ "serial" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
		ot-kernel_y_configopt "CONFIG_MOUSE_SERIAL" # 1985
		ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for mouse, modems, TTY console
		ot-kernel_y_configopt "CONFIG_SERIO" # Abstraction layer
		ot-kernel_y_configopt "CONFIG_SERIO_SERPORT" # Interface to the abstraction layer for RS-242 input devices
		ot-kernel_y_configopt "CONFIG_TTY"
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		# For optical mouse (USB 1.1)
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
}

# 6dof (aka 3D mouse) support for drafters and graphic CGI artists.
ot-kernel-driver-bundle_add_6dof() {
	local tags="${1}"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	if [[ "${tags}" =~ "serial" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:magellan") ]] ; then
		ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for trackball mouse
		ot-kernel_y_configopt "CONFIG_JOYSTICK_MAGELLAN" # 1993, serial
	fi
	if [[ "${tags}" =~ "serial" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:spaceball-2003"|"3d-mouse:spaceball-3003"|"3d-mouse:spaceball-4000"|"3d-mouse:spaceball-4004-flx") ]] ; then
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEBALL" # 1991, 1995, 1999
	fi
	if [[ "${tags}" =~ ("usb-1.1"|"usb-2.0") && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:spaceball-4000-usb") ]] ; then
	# Assumes with an adapter
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEBALL" # 1991, 1995, 1999
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL_GENERIC"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_TTY"

	# Common USB-to-serial chipsets found in adapters
		if [[ "${tags}" =~ ("usb-1.1"|"usb-2.0") ]] ; then
			ot-kernel_y_configopt "CONFIG_USB_SERIAL_CH341" # 2013, usb-1.1, usb-2.0
			ot-kernel_y_configopt "CONFIG_USB_SERIAL_FTDI_SIO" # 2007, usb-1.1, usb-2.0
			ot-kernel_y_configopt "CONFIG_USB_SERIAL_PL2303" # 2002, usb-1.1, usb-2.0
		fi
		if [[ "${tags}" =~ ("usb-2.0") ]] ; then
			ot-kernel_y_configopt "CONFIG_USB_SERIAL_CP210X" # 2004, usb-2.0
		fi
	fi
	if [[ "${tags}" =~ ("usb-1.1"|"usb-2.0") && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:spaceball-5000") ]] ; then
	# It can work in usb-3.0 but run at slower speeds.
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEBALL" # 1991, 1995, 1999
	fi
	if [[ "${tags}" =~ "serial" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:spaceorb-360"|"3d-mouse:spaceorb-avenger") ]] ; then
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEORB" # 1996
	fi
	if [[ "${tags}" =~ ("usb-1.1"|"usb-2.0") && "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("3d-mouse:6dof"|"3d-mouse:spacenavigator") ]] ; then
	# SpaceNavigator (2006)
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_PID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
}

ot-kernel-driver-bundle_add_keyboard() {
	local tags="${1}"
	if [[ "${tags}" =~ "ps2" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
		ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_HID_GENERIC"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
}

ot-kernel-driver-bundle_add_expansion_slots() {
	local tags="${1}"
	if [[ "${tags}" =~ (^|" ")"isa"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_ISA_BUS" # 8-bit (1981)
		ot-kernel_y_configopt "CONFIG_ISA_DMA_API" # 16-bit with DMA (1984), for consumers
	fi
	if [[ "${tags}" =~ (^|" ")"eisa"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_EISA" # 32-bit 1988, for server
	fi
	if [[ "${tags}" =~ "pci"($|" ") ]] ; then
	# PCI 1.1 () - IOV
	# PCI 2.2 (1998) - Message Signal Interrupts
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi
	if [[ "${tags}" =~ "pcie"($|" ") ]] ; then
	# PCIe 1.0 (2003)
	# PCIe 1.1 (2005) - AER
	# PCIe 2.0 (2007) - IOV, ASPM
	# PCIe 3.0 (2010) - PASID, PTM (PCI Express Precision Time Measurement)
	# PCIe 4.0 (2017) - DPC
	# PCIe 5.0 (2019)
	# PCIe 6.0 (2022)
	# PCIe 7.0 (2025)
	# P2PDMA - Not universal
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003
	fi
	if [[ "${tags}" =~ "pcie-aer" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIEAER"
	fi
	if [[ "${tags}" =~ "pcie-aspm" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIEASPM"
	fi
	if [[ "${tags}" =~ "pcie-ptm" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCIE_PTM" # Requires PCIe card with support
	fi
	if [[ "${tags}" =~ "pcie-iov" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI_IOV"
	fi
	if [[ "${tags}" =~ "pci-pri" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI_PRI" # For ARM
	fi
	if [[ "${tags}" =~ "pcie-pasid" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI_PASID"
	fi
	if [[ "${tags}" =~ "agp"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_y_configopt "CONFIG_AGP" # 1997
	fi
	if [[ "${tags}" =~ "vlb"($|" ") ]] ; then
ewarn "VLB is not supported"
	fi
}

ot-kernel-driver-bundle_add_usb() {
	local tags="${1}"
	if [[ "${tags}" =~ "usb-3.0" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008
	fi
	if [[ "${tags}" =~ "usb-2.0" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000
	fi
	if [[ "${tags}" =~ "usb-1.1" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_USB_UHCI_HCD" # 1996 (controller), 1998 (standard)
		elif [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999
		fi
	fi
}

ot-kernel-driver-bundle_add_console() {
	local tags="${1}"

	if [[ "${tags}" =~ ("hga-tty"|"hercules-tty"|"mono-tty") ]] ; then
	# Hercules/HGA (1982), monocrome
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_CORE"
		ot-kernel_y_configopt "CONFIG_FB_HGA"
		ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_VT"

		# Not all TTY features enabled for RAM limitations
	fi

	if [[ "${tags}" =~ ("cga-tty"|"ega-tty"|(^|" ")"vga-tty") ]] ; then
	# CGA (1981)
	# EGA (1984)
	# VGA (1987)
	# Hardware vga required
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_VT"
		ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

		# Not all TTY features enabled for RAM limitations
	fi

	if [[ "${tags}" =~ ("tty"($|" ")|"svga-tta") ]] ; then
	# Modern tty with resolutions and background
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_CORE"
		ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_VT"
		ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	fi

	# Currently the kernels/ebuild support use case where it is for gaming use.
	# It is possible to have the machine repurposed as a server.

	if [[ "${tags}" =~ ($|" ")"serial" ]] ; then
	# For headless servers
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SERIAL_8250"
		ot-kernel_y_configopt "CONFIG_SERIAL_8250_CONSOLE"
		ot-kernel_y_configopt "CONFIG_TTY"
	fi
	if [[ "${tags}" =~ "usb-serial" ]] ; then
	# For headless servers
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_TTY"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_SERIAL_CONSOLE"
	fi

	if grep -q -E -e "CONFIG_TTY=y" "${path_config}" ; then
	#
	# This option can be turned off you don't use emulators or access legacy systems.
	#
	# Use cases for LCD legacy displays, emulators, or serial connections that only support
	# the following code pages:
	#
	# Central European / Slavic (II) - 852 (1991)
	# Cyrillic - 866 (1986), 855 (1988), 866 (1986)
	# Greek - 737 (1996), 851 (1986)
	# Portugese - 860 (1986)
	# Nordic - 865 (1986)
	# Turkish - 857 (1989)
	# Japanese - 932 (1988)
	# The original IBM PC charset - 437 (1981)
	# Multilinual (Latin I) - 850 (1987)
	# Non UTF-8 encodings
	#
		ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default

		if [[ "${tags}" =~ ("tty"($|" ")|"svga-tta") ]] ; then
	# For switching graphics drivers without reboot
			ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
		else
			ot-kernel_unset_configopt "CONFIG_VT_HW_CONSOLE_BINDING"
		fi

	# For graphical terminals or SSH servers
		ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
	fi
}

ot-kernel-driver-bundle_add_external_storage() {
	local tags="${1}"

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tags}" =~ "ide" ]] ; then
	# 1995
		ot-kernel_y_configopt "CONFIG_ATA"
		ot-kernel_y_configopt "CONFIG_ATA_SFF"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
		ot-kernel_y_configopt "CONFIG_SCSI"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tags}" =~ "scsi" ]] ; then
	# 1995
		ot-kernel_y_configopt "CONFIG_SCSI"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
		# TODO add controller
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tags}" =~ "parport" ]] ; then
	# 1995
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_PARPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT_PC"
		ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
		ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_SCSI"
		ot-kernel_y_configopt "CONFIG_SCSI_LOWLEVEL"
		ot-kernel_y_configopt "CONFIG_SCSI_PPA"
		ot-kernel_y_configopt "CONFIG_SCSI_IMM"
	fi
}

# Do this to speed up build times
ot-kernel-driver-bundle_add_graphics() {
	local tags="${1}"

	if [[ "${tags}" =~ "isa" ]] ; then
		ot-kernel_y_configopt "CONFIG_FB_VGA16" # 1987
		ot-kernel_unset_configopt "CONFIG_FB_EFI" # unaccelerated, efifb is to see early boot for UEFI (2006)
	fi
	if [[ "${tags}" =~ "agp" ]] ; then
		ot-kernel_y_configopt "CONFIG_AGP" # 1997
		ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
		ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
		ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	fi

	if [[ "${tags}" =~ "pci"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ "${tags}" =~ "pcie" ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003
	fi

	ot-kernel-driver-bundle_add_graphics_drm_by_driver_name
	ot-kernel-driver-bundle_add_graphics_fb_by_driver_name

	ot-kernel-driver-bundle_add_hdcp_support
}

# KMS
# If efifb [non-accelerated] and amdgpu [accelerated] are both built, efifb runs
# first then amdgpu replaces it during runtime.
ot-kernel-driver-bundle_add_graphics_drm_by_driver_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:mgag200"\
|"graphics:millennium"($|" ")\
|"graphics:millennium-ii"\
|"graphics:mystique"($|" ")\
|"graphics:mystique-g220"\
|"graphics:productiva-g100"\
|"graphics:millennium-g200"\
|"graphics:marvel-g200"\
|"graphics:g400"($|" ")\
|"graphics:g450"($|" ")\
|"graphics:g550"($|" ")\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_MGAG200" # 1998
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics:nouveau" ]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_NOUVEAU"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ \
		"${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:radeon"($|" ")\
|"graphics:r100"\
|"graphics:r200"\
|"graphics:r300"\
|"graphics:r400"\
|"graphics:r500"\
|"graphics:r600"\
|"graphics:r700"\
|"graphics:evergreen"\
|"graphics:northern-islands"\
|"graphics:southern-islands"($|" ")\
|"graphics:sea-islands"($|" ")\
|"graphics:terascale1"($|" ")\
|"graphics:terascale2"($|" ")\
|"graphics:terascale3"($|" ")\
|"graphics:gcn1"($|" ")\
|"graphics:gcn2"($|" ")\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_RADEON" # 2000
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ \
		"${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:amdgpu"\
|"graphics:southern-islands-experimental"\
|"graphics:gcn1-experimental"\
|"graphics:gfx600"\
|"graphics:gfx601"\
|"graphics:gfx602"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_SI"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_unset_pat_kconfig_kernel_cmdline "radeon.si_support=[01]"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.si_support=[01]"
		ot-kernel_set_kconfig_kernel_cmdline "radeon.si_support=0"
		ot-kernel_set_kconfig_kernel_cmdline "amdgpu.si_support=1"
	fi

	if [[ \
		"${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:amdgpu"\
|"graphics:sea-islands-experimental"\
|"graphics:gcn2-experimental"\
|"graphics:gfx700"\
|"graphics:gfx701"\
|"graphics:gfx702"\
|"graphics:gfx703"\
|"graphics:gfx704"\
|"graphics:gfx705"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU_CIK"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_unset_pat_kconfig_kernel_cmdline "radeon.cik_support=[01]"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "amdgpu.cik_support=[01]"
		ot-kernel_set_kconfig_kernel_cmdline "radeon.cik_support=0"
		ot-kernel_set_kconfig_kernel_cmdline "amdgpu.cik_support=1"
	fi

	if [[ \
		"${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:amdgpu"\
|"graphics:volcanic-islands"\
|"graphics:artic-islands"\
|"graphics:polaris"\
|"graphics:vega"\
|"graphics:navi-1x"\
|"graphics:navi-2x"\
|"graphics:navi-3x"\
|"graphics:navi-4x"\
|"graphics:gcn3"\
|"graphics:gcn4"\
|"graphics:gcn5"\
|"graphics:cdna1"\
|"graphics:cdna2"\
|"graphics:cdna3"\
|"graphics:rdna"($|" ")\
|"graphics:rdna1"\
|"graphics:rdna2"\
|"graphics:rdna3"\
|"graphics:rdna4"\
|"graphics:gfx801"\
|"graphics:gfx802"\
|"graphics:gfx803"\
|"graphics:gfx805"\
|"graphics:gfx810"\
|"graphics:gfx900"\
|"graphics:gfx902"\
|"graphics:gfx904"\
|"graphics:gfx906"\
|"graphics:gfx908"\
|"graphics:gfx909"\
|"graphics:gfx90a"\
|"graphics:gfx90c"\
|"graphics:gfx942"\
|"graphics:gfx950"\
|"graphics:gfx1010"\
|"graphics:gfx1011"\
|"graphics:gfx1012"\
|"graphics:gfx1013"\
|"graphics:gfx1030"\
|"graphics:gfx1031"\
|"graphics:gfx1032"\
|"graphics:gfx1033"\
|"graphics:gfx1034"\
|"graphics:gfx1035"\
|"graphics:gfx1036"\
|"graphics:gfx1100"\
|"graphics:gfx1101"\
|"graphics:gfx1102"\
|"graphics:gfx1103"\
|"graphics:gfx1150"\
|"graphics:gfx1151"\
|"graphics:gfx1152"\
|"graphics:gfx1153"\
|"graphics:gfx1200"\
|"graphics:gfx1201"\
|"graphics:gfx1250"\
|"graphics:gfx1251"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:i915"\
|"graphics:830m"\
|"graphics:845g"\
|"graphics:852gm"\
|"graphics:855gm"\
|"graphics:865g"\
|"graphics:915g"\
|"graphics:945g"\
|"graphics:965g"\
|"graphics:g35"($|" ")\
|"graphics:g41"($|" ")\
|"graphics:g43"($|" ")\
|"graphics:g45"($|" ")\
|"graphics:hd-graphics"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_I915"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi


	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:xe") ]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_XE"
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics:simpledrm" ]] ; then
	# An alternative framebuffer driver to replace fbdev
	# Needs either UEFI GOP or VESA
		ot-kernel_y_configopt "CONFIG_DRM_SIMPLEDRM"
	fi

	# If efifb and simpledrm are built, simpledrm is used.
	# If simpledrm and simplefb are built, simpledrm is used.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics:efifb" ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_EFI"
		ot-kernel_y_configopt "CONFIG_FB_EFI"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"graphics:nvidia-drm"\
|"graphics:nvidia-drivers"\
|"graphics:tesla"\
|"graphics:fermi"\
|"graphics:kepler"\
|"graphics:maxwell"\
|"graphics:pascal"\
|"graphics:volta"\
|"graphics:turing"\
|"graphics:ampere"\
|"graphics:ada-lovelace"\
|"graphics:hopper"\
|"graphics:blackwell"\
|"graphics:sm_20"\
|"graphics:sm_21"\
|"graphics:sm_30"\
|"graphics:sm_32"\
|"graphics:sm_35"\
|"graphics:sm_37"\
|"graphics:sm_50"\
|"graphics:sm_52"\
|"graphics:sm_53"\
|"graphics:sm_60"\
|"graphics:sm_61"\
|"graphics:sm_62"\
|"graphics:sm_70"\
|"graphics:sm_72"\
|"graphics:sm_75"\
|"graphics:sm_80"\
|"graphics:sm_86"\
|"graphics:sm_87"\
|"graphics:sm_89"\
|"graphics:sm_90"\
|"graphics:sm_90a"\
|"graphics:sm_100"\
|"graphics:sm_100a"\
|"graphics:sm_101"\
|"graphics:sm_101a"\
|"graphics:sm_120"\
|"graphics:sm_120a"\
) ]] ; then
	# Only the graphical framebuffer will be repeated for completeness and consistency.
	# For the full config see ot-kernel-pkgflags.
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_KMS_HELPER"

	# The nvidia-drivers can only use the TTY framebuffer with either efifb
	# or nvidia-drm (the proprietary KMS driver) with the two settings
	# below.

	# When both kernel command line options are enabled, the framebuffer is
	# using accelerated KMS.
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nvidia-drm.modeset=1"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "nvidia-drm.fbdev=1"
		if ! [[ "${work_profile}" =~ ("vm-guest"|"vm-host") ]] ; then
			ot-kernel_set_kconfig_kernel_cmdline "nvidia-drm.modeset=1"
			ot-kernel_set_kconfig_kernel_cmdline "nvidia-drm.fbdev=1"
		fi

	# Disable all graphical framebuffer drivers for TTY
		ot-kernel_unset_configopt "CONFIG_DRM_NOUVEAU"
		ot-kernel_unset_configopt "CONFIG_DRM_SIMPLEDRM"
		ot-kernel_unset_configopt "CONFIG_FB_EFI" # This is unaccelerated
		ot-kernel_unset_configopt "CONFIG_FB_NVIDIA"
		ot-kernel_unset_configopt "CONFIG_FB_SIMPLE"
		ot-kernel_unset_configopt "CONFIG_FB_UVESA"
		ot-kernel_unset_configopt "CONFIG_FB_VESA"
		ot-kernel_unset_configopt "CONFIG_FB_VGA16"
		ot-kernel_unset_configopt "CONFIG_VGA_CONSOLE" # This will conflict
ewarn "It is assumed that you will use a bootdisk to fix driver issues with nvidia-drivers package."

	# Provide framebuffer console on boot
		if [[ "${work_profile}" =~ ("vm-guest"|"vm-host") ]] ; then
			ot-kernel_unset_configopt "CONFIG_DRM_FBDEV_EMULATION"
		else
			ot-kernel_y_configopt "CONFIG_DRM_FBDEV_EMULATION"
		fi

	# Allow only text based TTY driver for host as the fallback to fix broken driver versions
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_FB_CORE"
		ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE" # Graphics support >  Console display driver support > Framebuffer Console support
		ot-kernel_y_configopt "CONFIG_TTY" # Character devices > Enable TTY
		ot-kernel_y_configopt "CONFIG_VT"

	# Add temp sensor
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_NVIDIA_GPU" # 2018
		ot-kernel_y_configopt "CONFIG_PCI"

	# Available drivers on the distro:
		local consistency_failed=0
		if has_version "=x11-drivers/nvidia-drivers-575*" && ver_test "${KV_MAJOR_MINOR}" -ge "4.15" && ver_test "${KV_MAJOR_MINOR}" -le "6.13" ; then
			if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"maxwell"|\
"pascal"|\
"volta"|\
"turing"|\
"ampere"|\
"ada-lovelace"|\
"hopper"|\
"blackwell"|\
"sm_50"|\
"sm_52"|\
"sm_53"|\
"sm_60"|\
"sm_61"|\
"sm_62"|\
"sm_70"|\
"sm_72"|\
"sm_75"|\
"sm_80"|\
"sm_86"|\
"sm_87"|\
"sm_89"|\
"sm_90"|\
"sm_90a"|\
"sm_100"|\
"sm_100a"|\
"sm_101"|\
"sm_101a"|\
"sm_120"|\
"sm_120a") \
			]] ; then
einfo "CUDA microarchitecture check:  PASSED"
			else
ewarn "CUDA microarchitecture check:  FAILED"
				consistency_failed=1
			fi
		elif has_version "=x11-drivers/nvidia-drivers-570*" && ver_test "${KV_MAJOR_MINOR}" -ge "4.15" && ver_test "${KV_MAJOR_MINOR}" -le "6.13" ; then
			if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"maxwell"|\
"pascal"|\
"volta"|\
"turing"|\
"ampere"|\
"ada-lovelace"|\
"hopper"|\
"blackwell"|\
"sm_50"|\
"sm_52"|\
"sm_53"|\
"sm_60"|\
"sm_61"|\
"sm_62"|\
"sm_70"|\
"sm_72"|\
"sm_75"|\
"sm_80"|\
"sm_86"|\
"sm_87"|\
"sm_89"|\
"sm_90"|\
"sm_90a"|\
"sm_100"|\
"sm_100a"|\
"sm_101"|\
"sm_101a"|\
"sm_120"|\
"sm_120a") \
			]] ; then
einfo "CUDA microarchitecture check:  PASSED"
			else
ewarn "CUDA microarchitecture check:  FAILED"
				consistency_failed=1
			fi
		elif has_version "=x11-drivers/nvidia-drivers-535*" && ver_test "${KV_MAJOR_MINOR}" -ge "4.15" && ver_test "${KV_MAJOR_MINOR}" -le "6.8" ; then
			if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"maxwell"|\
"pascal"|\
"volta"|\
"turing"|\
"ampere"|\
"ada-lovelace"|\
"sm_50"|\
"sm_52"|\
"sm_53"|\
"sm_60"|\
"sm_61"|\
"sm_62"|\
"sm_70"|\
"sm_72"|\
"sm_75"|\
"sm_80"|\
"sm_86"|\
"sm_87"|\
"sm_89")\
			]] ; then
einfo "CUDA microarchitecture check:  PASSED"
			else
ewarn "CUDA microarchitecture check:  FAILED"
				consistency_failed=1
			fi
		elif has_version "=x11-drivers/nvidia-drivers-470*" && ver_test "${KV_MAJOR_MINOR}" -ge "4.15" && ver_test "${KV_MAJOR_MINOR}" -le "6.8" ; then
			if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"kepler"|\
"maxwell"|\
"pascal"|\
"volta"|\
"turing"|\
"ampere"|\
"sm_30"|\
"sm_32"|\
"sm_35"|\
"sm_37"|\
"sm_50"|\
"sm_52"|\
"sm_53"|\
"sm_60"|\
"sm_61"|\
"sm_62"|\
"sm_70"|\
"sm_72"|\
"sm_75"|\
"sm_80"|\
"sm_86"|\
"sm_87")\
			]] ; then
einfo "CUDA microarchitecture check:  PASSED"
			else
ewarn "CUDA microarchitecture check:  FAILED"
				consistency_failed=1
			fi
		elif has_version "=x11-drivers/nvidia-drivers-390*" && ver_test "${KV_MAJOR_MINOR}" -ge "3.10" && ver_test "${KV_MAJOR_MINOR}" -le "5.19" ; then
			if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"fermi"|\
"kepler"|\
"maxwell"|\
"pascal"|\
"sm_20"|\
"sm_21"|\
"sm_30"|\
"sm_32"|\
"sm_35"|\
"sm_37"|\
"sm_50"|\
"sm_52"|\
"sm_53"|\
"sm_60"|\
"sm_61"|\
"sm_62") \
			]] ; then
einfo "CUDA microarchitecture check:  PASSED"
			else
ewarn "CUDA microarchitecture check:  FAILED"
				consistency_failed=1
			fi
		else
			consistency_failed=1
		fi

		if (( ${consistency_failed} == 1 )) ; then
			local pv_actual="NOT FOUND"
			if has_version "x11-drivers/nvidia-drivers" ; then
				pv_actual=$(best_version "x11-drivers/nvidia-drivers" | sed -e "s|x11-drivers/nvidia-drivers-||g")
			fi

			local sm_arch="UNKNOWN"
			local sm_arches=(
				"fermi"
				"kepler"
				"maxwell"
				"pascal"
				"volta"
				"turing"
				"ampere"
				"ada-lovelace"
				"hopper"
				"blackwell"
				"sm_20"
				"sm_21"
				"sm_30"
				"sm_32"
				"sm_35"
				"sm_37"
				"sm_50"
				"sm_52"
				"sm_53"
				"sm_60"
				"sm_61"
				"sm_62"
				"sm_70"
				"sm_72"
				"sm_75"
				"sm_80"
				"sm_86"
				"sm_87"
				"sm_89"
				"sm_90"
				"sm_90a"
				"sm_100"
				"sm_100a"
				"sm_101"
				"sm_101a"
				"sm_120"
				"sm_120a"
			)

			local a
			for a in ${sm_arches[@]} ; do
				[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "${a}"($|" ") ]] && sm_arch="${a}"
			done

ewarn
ewarn "Driver consistency checks failed"
ewarn
ewarn "You need to downgrade or upgrade the kernel version or"
ewarn "x11-drivers/nvidia-drivers driver version to correspond to the matching"
ewarn "GPU microarchitecture."
ewarn
ewarn "x11-drivers/nvidia-drivers actual version:  ${pv_actual}"
ewarn "x11-drivers/nvidia-drivers expected version:  390.x, 470.x, 535.x, 570.x, 575.x"
ewarn "GPU microarchitecture (actual):  ${sm_arch}"
ewarn "Kernel version:  ${PV}"
ewarn
ewarn "Expected microarchitecture to driver version correspondance:"
ewarn
ewarn "=x11-drivers/nvidia-drivers-575*:  maxwell, pascal, volta, turing, ampere, ada-lovelace, hopper, blackwell, sm_50, sm_52, sm_53, sm_60, sm_61, sm_62, sm_70, sm_72, sm_75, sm_80, sm_86, sm_87, sm_89, sm_90, sm_90a, sm_100, sm_100a, sm_101, sm_101a, sm_120, sm_120a"
ewarn "=x11-drivers/nvidia-drivers-570*:  maxwell, pascal, volta, turing, ampere, ada-lovelace, hopper, blackwell, sm_50, sm_52, sm_53, sm_60, sm_61, sm_62, sm_70, sm_72, sm_75, sm_80, sm_86, sm_87, sm_89, sm_90, sm_90a, sm_100, sm_100a, sm_101, sm_101a, sm_120, sm_120a"
ewarn "=x11-drivers/nvidia-drivers-535*:  maxwell, pascal, volta, turing, ampere, ada-lovelace, sm_50, sm_52, sm_53, sm_60, sm_61, sm_62, sm_70, sm_72, sm_75, sm_80, sm_86, sm_87, sm_89"
ewarn "=x11-drivers/nvidia-drivers-470*:  kepler, maxwell, pascal, volta, turing, ampere, sm_30, sm_32, sm_35, sm_37, sm_50, sm_52, sm_53, sm_60, sm_61, sm_62, sm_70, sm_72, sm_75, sm_80, sm_86, sm_87"
ewarn "=x11-drivers/nvidia-drivers-390*:  fermi, kepler, maxwell, pascal, sm_20, sm_21, sm_30, sm_32, sm_35, sm_37, sm_50, sm_52, sm_53, sm_60, sm_61, sm_62"
ewarn
ewarn "Expected kernel versions to driver version correspondance:"
ewarn
ewarn "=x11-drivers/nvidia-drivers-575*:  4.15.x - 6.13.x"
ewarn "=x11-drivers/nvidia-drivers-570*:  4.15.x - 6.13.x"
ewarn "=x11-drivers/nvidia-drivers-535*:  4.15.x - 6.8.x"
ewarn "=x11-drivers/nvidia-drivers-470*:  4.15.x - 6.8.x"
ewarn "=x11-drivers/nvidia-drivers-390*:  3.10.x - 5.19.x"
ewarn
ewarn "To make this message disappear, either"
ewarn
ewarn "1. Set the proper graphics:<sm_xxx> or graphics:<codename> value"
ewarn "2. Switch to graphics:nouveau"
ewarn "3. Hard mask the incompatible versions and emerge the proper x11-drivers/nvidia-drivers driver major version immediately after this kernel is installed"
ewarn
		fi
	fi
}

# efi [non-accelerated] > nvidiafb [accelerated] or radeonfb [accelerated]
ot-kernel-driver-bundle_add_graphics_fb_by_driver_name() {
	local disable_efi=0
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:matroxfb") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_MATROX" # 1999-2001
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:3d-rage"|"graphics:atyfb"|"graphics:mach64"|"graphics:mach"($|" ")|"graphics:rage-pro") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_ATY"
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:aty128fb"|"graphics:rage128"|"graphics:rage-128") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_ATY128" # 1998
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics:nvidiafb" ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_NVIDIA" # 1998
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:pm3fb"|"graphics:permedia-3") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_PM3" # 1999
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:rivafb"|"graphics:riva"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_RIVA" # 1997
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:s3fb"|"graphics:trio"|"graphics:virge") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_S3" # 1995/1996
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:savagefb"|"graphics:savage"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_SAVAGE" # 1998
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:sstfb"|"graphics:voodoo1") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_VOODOO1" # 1996-1998
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:tdfxfb"|"graphics:banshee"|"graphics:voodoo3"|"graphics:voodoo4"|"graphics:voodoo5") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_3DFX" # 1998-2000
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		disable_efi=1
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:vesafb"|"graphics:vesa"|"graphics:wonder") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB"
		ot-kernel_y_configopt "CONFIG_FB_VESA" # 1994
		disable_efi=1
	fi

	# If simplefb [unaccelerated] and efifb [unaccelerated] are both built, simplefb wins to load.
	# If simplefb [unaccelerated] and vesafb [unaccelerated] are both built, simplefb wins to load.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:simplefb") ]] ; then
		ot-kernel_y_configopt "CONFIG_FB_SIMPLE" # For early boot only to later use nvidia closed source driver
		disable_efi=1
	fi

	if (( ${disable_efi} == 1 )) ; then
		ot-kernel_unset_configopt "CONFIG_FB_EFI" # unaccelerated, efifb is to see early boot
	fi
}

# Mic and earphones
ot-kernel-driver-bundle_add_usb_gamer_headsets() {
	# For feature completness
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HID_STEELSERIES" # 2001, 2019, racing-wheel, console headset
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_USB"
	ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_USB"
}

ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes() {
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HID_CORSAIR" # 2011, 2013, 2016, 2017, fixes keyboard/mouse
	ot-kernel_y_configopt "CONFIG_HID_GLORIOUS" # 2019-2020
	ot-kernel_y_configopt "CONFIG_HID_HOLTEK" # 2012, 2016, 2017, 2018, 2019, 2021, 2022, for mouse/keyboard/game controller
	ot-kernel_y_configopt "CONFIG_HID_KYE" # 2013
	ot-kernel_y_configopt "CONFIG_HID_LOGITECH" # 2005
	ot-kernel_y_configopt "CONFIG_HID_LOGITECH_HIDPP" # 2014, 2016, 2017, 2019, 2020, 2024, for feature completeness
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
	ot-kernel_y_configopt "CONFIG_USB_HID"
}

ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes() {
	# HID (USB/Bluetooth) based keyboards
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HID_CORSAIR" # 2011, 2013, 2016, 2017, fixes keyboard/mouse
	ot-kernel_y_configopt "CONFIG_HID_COUGAR" # 2014, keyboard fixes
	ot-kernel_y_configopt "CONFIG_HID_DRAGONRISE" # 2009, 2023
	ot-kernel_y_configopt "CONFIG_HID_LOGITECH" # 2005
	ot-kernel_y_configopt "CONFIG_HID_RAZER" # 2010, keyboard fixes
	ot-kernel_y_configopt "CONFIG_HID_REDRAGON" # 2015, keyboard fix
	ot-kernel_y_configopt "CONFIG_HID_ROCCAT" # 2019-2023, mouse/keyboard
	ot-kernel_y_configopt "CONFIG_HID_SEMITEK" # 2018, 2019, 2020, 2021
	ot-kernel_y_configopt "CONFIG_HID_SIGMAMICRO" # 2022
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_HID_TOPRE" # 2018, N-key rollover support
	ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
	ot-kernel_y_configopt "CONFIG_USB_HID"
}

ot-kernel-driver-bundle_add_haptic_devices_by_usb() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "haptic-device:touch-x"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_FF_MEMLESS"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GENERIC"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("haptic-device:touch"($|" ")|"haptic-device:touch-x"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HIDRAW"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_HID"

		# For closed source drivers
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_n_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		_FORCE_OT_KERNEL_EXTERNAL_MODULES=1
	fi
}

ot-kernel-driver-bundle_add_haptic_devices_by_ethernet() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("haptic-device:touch"($|" ")|"haptic-device:touch-x"($|" ")) ]] ; then
	# OpenHaptics support on Linux (2009)
	# Touch (2003), Touch X (2008)
	# USB 2.0, USB 3.0, Ethernet
	# For ethernet for the haptic stylus or wired Internet
		ot-kernel_y_configopt "CONFIG_ETHERNET"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992

		# For closed source drivers
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_n_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		_FORCE_OT_KERNEL_EXTERNAL_MODULES=1
	fi
}

ot-kernel-driver-bundle_add_haptic_devices_by_parport() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "haptic-device:phantom-premium" ]] ; then
	# For 3D modeling with a haptic stylus
	# Parallel Port (EPP)
	# Phantom Premium 1.5 (2001)
		ot-kernel_y_configopt "CONFIG_ETHERNET" # 1983
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GENERIC"
		ot-kernel_y_configopt "CONFIG_INET"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_NET"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PARPORT"
		ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
		ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
		ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991
		ot-kernel_y_configopt "CONFIG_PCI" # 1992

		# For closed source drivers
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_n_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		_FORCE_OT_KERNEL_EXTERNAL_MODULES=1
	fi
}

ot-kernel-driver-bundle_add_haptic_devices() {
	local tags="${1}"
	if [[ "${tags}" =~ "parport" ]] ; then
		ot-kernel-driver-bundle_add_haptic_devices_by_parport
	fi
	if [[ "${tags}" =~ "ethernet" ]] ; then
		ot-kernel-driver-bundle_add_haptic_devices_by_ethernet
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel-driver-bundle_add_haptic_devices_by_usb
	fi
}

ot-kernel-driver-bundle_add_graphics_tablet_by_serial() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics-tablet:wacom" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
		ot-kernel_y_configopt "CONFIG_TABLET_SERIAL_WACOM4"
		ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987
	fi
}

ot-kernel-driver-bundle_add_graphics_tablet_by_usb() {
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics-tablet:aiptek"|"graphics-tablet:genius") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
		ot-kernel_y_configopt "CONFIG_TABLET_USB_AIPTEK" # 2003, 2006
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics-tablet:kb-gear" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
		ot-kernel_y_configopt "CONFIG_TABLET_USB_KBTAB" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics-tablet:acecad" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
		ot-kernel_y_configopt "CONFIG_TABLET_USB_ACECAD" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics-tablet:hawang" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
		ot-kernel_y_configopt "CONFIG_TABLET_USB_HANWANG" # 2009
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "graphics-tablet:wacom" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_WACOM" # 1998/2001
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
		ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("smartpen:genie"|"smartpen:iris"|"smartpen:newyes"|"smartpen:pegasus") ]] ; then
		ot-kernel_y_configopt "CONFIG_TABLET_USB_PEGASUS"
	fi
}

ot-kernel-driver-bundle_add_graphics_tablet() {
	local tags="${1}"
	if [[ "${tags}" =~ "serial" ]] ; then
		ot-kernel-driver-bundle_add_graphics_tablet_by_serial
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel-driver-bundle_add_graphics_tablet_by_usb
	fi
}

ot-kernel-driver-bundle_add_home_theater_remote() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "remote:apple" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_APPLEIR"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "remote:ati" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_ATI_REMOTE2"
		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "remote:keyspan" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_KEYSPAN_REMOTE" # 2001
		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "remote:philips" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_ATI_REMOTE2"
		ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "remote:zydacron" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_ZYDACRON"
	fi
}

# It goes after ot-kernel-driver-bundle_add_sound.
ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers() {
	local tags="${1}"
	if [[ "${tags}" =~ "hid" ]] ; then
		# USB or Bluetooth
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_hid_by_vendor
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_hid_by_class
	fi
	if [[ "${tags}" =~ "gameport" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981, 15 pin
		if grep -q -E -e "^CONFIG_SND_EMU10K1=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_GAMEPORT_EMU10K1" # 1998
		fi
		if grep -q -E -e "^CONFIG_SND_FM801=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_GAMEPORT_FM801" # 1998
		fi
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_gameport_by_vendor
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_gameport_by_class
	fi
	if [[ "${tags}" =~ "serial" ]] ; then
		ot-kernel_y_configopt "CONFIG_SERIO" # 1984 (9-pin DE-9), 1981 (25-pin PC version)
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_serial_by_vendor
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_serial_by_class
	fi
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_usb_by_vendor
		ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_usb_by_class
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_serial_by_vendor() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gravis" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_STINGER" # 1998, 9-pin
		ot-kernel_y_configopt "CONFIG_SERIO"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:act-labs"|"controller:avb"|"controller:boeder"|"controller:iforce"|"controller:guillemot"|"controller:logitech"|"controller:saitek"|"controller:thrustmaster"|"controller:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_232"
		ot-kernel_y_configopt "CONFIG_SERIO"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_serial_by_class() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gamepad" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_STINGER" # 1998, 9-pin
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:steering-wheel"|"controller:racing-wheel") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_232"
		ot-kernel_y_configopt "CONFIG_SERIO"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:flight-stick"|"controller:joystick") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_232"
		ot-kernel_y_configopt "CONFIG_SERIO"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_gameport_by_vendor() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:ch"($|" ")|"controller:saitek"|"controller:thrustmaster") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ANALOG" # 1992, 2000, 2016
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:creative-labs" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_COBRA" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:guillemot" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GUILLEMOT" #
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gravis" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GRIP" # 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GRIP_MP"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:genius" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GF2K" #
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:interact" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_INTERACT" # 1997, 1999, 2000
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:logitech" ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_WARRIOR" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:mad-catz" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_A3D" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:microsoft" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SIDEWINDER" # 1995-2003
		if (( ${disable_xpad} == 0 )) ; then
			ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
			ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:thrustmaster" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_gameport_by_class() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:joystick" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ANALOG" # 1992, 2000, 2016
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gamepad" ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_COBRA" # 1997
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GF2K" #
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GUILLEMOT" #
		ot-kernel_y_configopt "CONFIG_JOYSTICK_INTERACT" # 1997, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SIDEWINDER" # 1995-2003
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
		if (( ${disable_xpad} == 0 )) ; then
			ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
			ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
		fi

	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:steering-wheel"|"controller:racing-wheel") ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:6dof") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEORB" # 1996
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:flight-stick"|"controller:joystick") ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_A3D" # 1997, trackball and joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GF2K" #
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GUILLEMOT" #
		ot-kernel_y_configopt "CONFIG_JOYSTICK_INTERACT" # 1997, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_SIDEWINDER" # 1995-2003
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
		ot-kernel_y_configopt "CONFIG_JOYSTICK_WARRIOR" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:two-handed-joystick" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:fps" ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:throttle" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_TMDC" # 1997, 1998, 2005
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:adapter" ]] ; then
		ot-kernel_y_configopt "CONFIG_JOYSTICK_GRIP_MP"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_hid_by_vendor() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:acrux" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_ACRUX"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:betop" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_BETOP_FF"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:bigben" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_BIGBEN_FF" # 2021
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:dragonrise" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_DRAGONRISE" # 2009, 2023
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gembird" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GEMBIRD" # 2016
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:google" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GOOGLE_STADIA_FF" # 2019
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:greenasia" ]] ; then
		ot-kernel_y_configopt "CONFIG_GREENASIA_FF" # 2009/2013
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GREENASIA"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:logitech" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_LOGIG940_FF" # 2009
		ot-kernel_y_configopt "CONFIG_LOGIRUMBLEPAD2_FF" # 2004-2006
		ot-kernel_y_configopt "CONFIG_LOGITECH_FF" # 2001-2006
		ot-kernel_y_configopt "CONFIG_LOGIWHEELS_FF" # 2000-2015
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:mayflash" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_MAYFLASH" # 2014, 2015
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:microsoft" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_MICROSOFT" # 2000, 2004, 2006, 2011, 2016, 2019, 2020, fixes for mouse/joystick/gamepads
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:nintendo" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_NINTENDO" # 2017, 2018
		ot-kernel_y_configopt "CONFIG_HID_WIIMOTE" # 2006, 2012
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:phoenixrc" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_PXRC" # 2023
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:retrode" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID_RETRODE" # 2012
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:saitek" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SAITEK" # 2009, 2010, fixes mouse/gamepad
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:steam" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_STEAM" # 2015
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:sony" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SONY" # 2005, 2006, 2009, 2011, 2013, 2015, 2016
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:steelseries" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_STEELSERIES" # 2001, 2019
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:thrustmaster" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_THRUSTMASTER" # 2002, 2007, 2011, 2015, 2022
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:thq" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_UDRAW_PS3" # 2011
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:united-game-artists" ]] ; then
		# Game immersion
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_TRANCEVIBRATOR" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:winwing" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_WINWING" # 2023-2024
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:xfx" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_ZEROPLUS" # 2000
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:zeroplus" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_ZEROPLUS" # 2000
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:generic-brand" ]] ; then
		# No vendor name
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SMARTJOYPLUS" # 2003, 2008, 2009, 2020
		ot-kernel_y_configopt "CONFIG_HID_VRC2" # 2015
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_hid_by_class() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:joystick" ]] ; then
		# Explicitly labeled joystick
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:drawing-tablet" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_UDRAW_PS3" # 2011
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gamepad" ]] ; then
		ot-kernel_y_configopt "CONFIG_GREENASIA_FF" # 2009/2013
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_ACRUX"
		ot-kernel_y_configopt "CONFIG_HID_BETOP_FF" # 2021
		ot-kernel_y_configopt "CONFIG_HID_BIGBEN_FF" # 2021
		ot-kernel_y_configopt "CONFIG_HID_DRAGONRISE" # 2009, 2023
		ot-kernel_y_configopt "CONFIG_HID_GEMBIRD" # 2016
		ot-kernel_y_configopt "CONFIG_HID_GREENASIA"
		ot-kernel_y_configopt "CONFIG_HID_GOOGLE_STADIA_FF" # 2019
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_MICROSOFT" # 2000, 2004, 2006, 2011, 2016, 2019, 2020, fixes for mouse/joystick/gamepads
		ot-kernel_y_configopt "CONFIG_HID_NINTENDO" # 2017, 2018
		ot-kernel_y_configopt "CONFIG_HID_SAITEK" # 2009, 2010, fixes mouse/gamepad
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_STEAM" # 2015
		ot-kernel_y_configopt "CONFIG_HID_ZEROPLUS" # 2000
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_LOGIRUMBLEPAD2_FF" # 2004-2006
		ot-kernel_y_configopt "CONFIG_LOGITECH_FF" # 2001-2006
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:toy-remote-control" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_PXRC" # 2023
		ot-kernel_y_configopt "CONFIG_HID_VRC2" # 2015
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:steering-wheel"|"controller:racing-wheel") ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_STEELSERIES" # 2001, 2019, racing-wheel, console headset
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_LOGIRUMBLEPAD2_FF" # 2004-2006
		ot-kernel_y_configopt "CONFIG_LOGIWHEELS_FF" # 2000-2015
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:flight-stick"|"controller:joystick") ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_MICROSOFT" # 2000, 2004, 2006, 2011, 2016, 2019, 2020, fixes for mouse/joystick/gamepads
		ot-kernel_y_configopt "CONFIG_HID_THRUSTMASTER" # 2002, 2007, 2011, 2015, 2022
		ot-kernel_y_configopt "CONFIG_LOGITECH_FF" # 2001-2006
		ot-kernel_y_configopt "CONFIG_LOGIG940_FF" # 2009
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:flight-throttle" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_LOGITECH"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_WINWING" # 2023-2024
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_LOGIG940_FF" # 2009
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
		ot-kernel_y_configopt "CONFIG_USB_HID"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:motion-controller" ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_HID_WIIMOTE" # 2006, 2012
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:adapter"|"controller:dongle") ]] ; then
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_MAYFLASH" # 2014, 2015
		ot-kernel_y_configopt "CONFIG_HID_RETRODE" # 2012
		ot-kernel_y_configopt "CONFIG_HID_SMARTJOYPLUS" # 2003, 2008, 2009, 2020
		ot-kernel_y_configopt "CONFIG_HID_SONY" # 2005, 2006, 2009, 2011, 2013, 2015, 2016
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_HID"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:vibrator" ]] ; then
		# Game immersion
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_TRANCEVIBRATOR" # 2001
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_usb_by_vendor() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:act-labs"|"controller:avb"|"controller:boeder"|"controller:iforce"|"controller:guillemot"|"controller:logitech"|"controller:saitek"|"controller:thrustmaster"|"controller:trust") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_USB"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ \
		"${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"controller:8bitdo"\
|"controller:acer"\
|"controller:amazon"\
|"controller:asus"\
|"controller:andamiro"\
|"controller:bda"\
|"controller:bigben"\
|"controller:bigben-interactive"\
|"controller:black-shark"\
|"controller:chic"\
|"controller:elecom"\
|"controller:fanatec"\
|"controller:gamepad-digital"\
|"controller:gamesir"\
|"controller:gamestop"\
|"controller:generic-brand"\
|"controller:gpd"\
|"controller:hama"\
|"controller:hyperkin"\
|"controller:hyperx"\
|"controller:hori"\
|"controller:intec"\
|"controller:interact"\
|"controller:ion-audio"\
|"controller:joytech"\
|"controller:lenovo"\
|"controller:logic3"\
|"controller:logitech"\
|"controller:mad-catz"\
|"controller:machenike"\
|"controller:msi"\
|"controller:micro-star-international"\
|"controller:nacon"\
|"controller:performance-designed-products"\
|"controller:pdp"\
|"controller:pelican"\
|"controller:powera"\
|"controller:razer"\
|"controller:radica-games"\
|"controller:redoctane"\
|"controller:saitek"\
|"controller:scuf-gaming"\
|"controller:snakebyte"\
|"controller:shanwan"\
|"controller:steelseries"\
|"controller:tecno"\
|"controller:thrustmaster"\
|"controller:turtle-beach"\
|"controller:wooting"\
|"controller:xiaomi"\
|"controller:zotac"\
) \
	]] ; then
		ot-kernel-driver-bundle_add_xpad
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:sony" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:logitech" ]] ; then
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_usb_by_class() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:dance-pad" ]] ; then
		ot-kernel-driver-bundle_add_xpad
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:arcade" ]] ; then
		ot-kernel-driver-bundle_add_xpad
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:drum" ]] ; then
		ot-kernel-driver-bundle_add_xpad
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:gamepad" ]] ; then
		ot-kernel-driver-bundle_add_xpad
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:guitar" ]] ; then
		ot-kernel-driver-bundle_add_xpad
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:steering-wheel"|"controller:racing-wheel") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_USB"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("controller:flight-stick"|"controller:joystick") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE" # 1998, 1999, 2001, 2004, steering wheel, flying joystick
		ot-kernel_y_configopt "CONFIG_JOYSTICK_IFORCE_USB"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "controller:microphone" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_USB"
		ot-kernel_y_configopt "CONFIG_SND_USB_AUDIO"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
}

ot-kernel-driver-bundle_add_xpad() {
	if [[ "${tags}" =~ "usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB_ARCH_HAB"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD"
	fi
	if [[ "${tags}" =~ "bt" ]] ; then
	# USB 2.0 (2000) if using dongle to connect to other Bluetooth.
	# Does not use xpad driver
		ot-kernel_y_configopt "CONFIG_BT"
		ot-kernel_y_configopt "CONFIG_BT_RFCOMM"
		ot-kernel_y_configopt "CONFIG_BT_HIDP"
		ot-kernel_y_configopt "CONFIG_BT_HCIBTUSB"
		ot-kernel_y_configopt "CONFIG_BT_HCIUART"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
		ot-kernel_y_configopt "CONFIG_UHID"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers() {
	ot-kernel_y_configopt "CONFIG_FW_LOADER"
	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers_by_vendor
	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers_by_model
}

ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers_by_vendor() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:atheros" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_AR5523" # 2018
		ot-kernel_y_configopt "CONFIG_ATH5K" # 2002-2005
		ot-kernel_y_configopt "CONFIG_ATH5K_PCI"
		ot-kernel_y_configopt "CONFIG_ATH6KL" # 2011
		ot-kernel_y_configopt "CONFIG_ATH9K" # 2008
		ot-kernel_y_configopt "CONFIG_ATH10K" # 2012
		ot-kernel_y_configopt "CONFIG_ATH11K" # 2020
		ot-kernel_y_configopt "CONFIG_ATH12K" # 2025
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:broadcom"|"wifi:bcm") ]] ; then
		ot-kernel_y_configopt "CONFIG_B43" # 2008
		ot-kernel_y_configopt "CONFIG_B43LEGACY" # 2002, 2008
		ot-kernel_y_configopt "CONFIG_BCMA_POSSIBLE"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_SSB_POSSIBLE"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_BROADCOM"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:intel" ]] ; then
		ot-kernel_y_configopt "CONFIG_CFG80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_IWLWIFI" # 2001, 2002, 2003, 2004, 2008, 2009, 2011, 2013, 2014, 2015, 2019
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_INTEL"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mediatek" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT7601U" # 2012
		ot-kernel_y_configopt "CONFIG_MT76x0U" # 2013
		ot-kernel_y_configopt "CONFIG_MT76x2U" # 2013
		ot-kernel_y_configopt "CONFIG_MT7663U" # 2019
		ot-kernel_y_configopt "CONFIG_MT7921U" # 2023
		ot-kernel_y_configopt "CONFIG_MT7925U" # 2024
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ralink" ]] ; then
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RT2X00"
		ot-kernel_y_configopt "CONFIG_RT2500USB" # 2005-2008
		ot-kernel_y_configopt "CONFIG_RT2800USB" # 2009
		ot-kernel_y_configopt "CONFIG_RT73USB" # 2007
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_RALINK"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:realtek" ]] ; then
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTL8180" # 2002, PCI
		ot-kernel_y_configopt "CONFIG_RTL8187" # 2004
		ot-kernel_y_configopt "CONFIG_RTL8188EE" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8192CE" # 2009
		ot-kernel_y_configopt "CONFIG_RTL8192CU" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8192DE" # 2010
		ot-kernel_y_configopt "CONFIG_RTL8192DU" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8192EE" # 2015
		ot-kernel_y_configopt "CONFIG_RTL8192SE" # 2012
		ot-kernel_y_configopt "CONFIG_RTL8723AE" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8723BE" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8821AE" # 2014-2015
		ot-kernel_y_configopt "CONFIG_RTL8XXXU" # 2010, 2011, 2013, 2014, 2017, 2019, 2022
		ot-kernel_y_configopt "CONFIG_RTW88_8821CE" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8821CU" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8822BE" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_RTW88_8822CE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW88_8822CU" # 2021
		ot-kernel_y_configopt "CONFIG_RTW88_8723DE" # 2018
		ot-kernel_y_configopt "CONFIG_RTW88_8723DU" # 2018
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8851BE" # 2023
		ot-kernel_y_configopt "CONFIG_RTW89_8852AE" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852BE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW89_8852BTE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW89_8852CE" # 2024
		ot-kernel_y_configopt "CONFIG_RTW89_8922AE" # 2024
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi
}

ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers_by_model() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ar5523" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_AR5523" # 2018
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath5k" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH5K" # 2002-2005
		ot-kernel_y_configopt "CONFIG_ATH5K_PCI"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath6kl" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH6KL" # 2011
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath9k" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH9K" # 2008
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath10k" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH10K" # 2012
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath11k" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH11K" # 2020
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:ath12k" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_ATH12K" # 2025
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_ATH"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:b43" ]] ; then
		ot-kernel_y_configopt "CONFIG_B43" # 2008
		ot-kernel_y_configopt "CONFIG_B43LEGACY" # 2002, 2008
		ot-kernel_y_configopt "CONFIG_BCMA_POSSIBLE"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_SSB_POSSIBLE"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_BROADCOM"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:iwlwifi" ]] ; then
		ot-kernel_y_configopt "CONFIG_CFG80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_IWLWIFI" # 2001, 2002, 2003, 2004, 2008, 2009, 2011, 2013, 2014, 2015, 2019
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_INTEL"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt7601u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT7601U" # 2012
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt76x0u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT76x0U" # 2013
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt76x2u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT76x2U" # 2013
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt7663u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT7663U" # 2019
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi


	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt7921u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT7921U" # 2023
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:mt7925u" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_MT7925U" # 2024
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_MEDIATEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rt2500usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RT2X00"
		ot-kernel_y_configopt "CONFIG_RT2500USB" # 2005-2008
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_RALINK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rt2800usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RT2X00"
		ot-kernel_y_configopt "CONFIG_RT2800USB" # 2009
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_RALINK"
	fi


	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rt73usb" ]] ; then
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RT2X00"
		ot-kernel_y_configopt "CONFIG_RT73USB" # 2007
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_RALINK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rtl8180" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8180" # 2002, PCI
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rtl8187" ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8187" # 2004
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8188"|"wifi:rtl8188de"|"wifi:rtl8192"|"wifi:rtl8192de") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192DE" # 2010
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8188"|"wifi:rtl8188ee") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8188EE" # 2013
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8188"|"wifi:rtl8188ce"|"wifi:rtl8192"|"wifi:rtl8192ce") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192CE" # 2009
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8188"|"wifi:rtl8188cu"|"wifi:rtl8192"|"wifi:rtl8192cu") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192CU" # 2013
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8192"|"wifi:rtl8192du") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192DU" # 2013
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8192"|"wifi:rtl8192ee") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192EE" # 2015
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8191"|"wifi:rtl8191se"|"wifi:rtl8192"|"wifi:rtl8192se") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8192SE" # 2012
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8723"|"wifi:rtl8723ae") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8723AE" # 2013
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8723"|"wifi:rtl8723be") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8723BE" # 2013
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8812"|"wifi:rtl8812ae"|"wifi:rtl8821"|"wifi:rtl8821ae") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8821AE" # 2014-2015
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8xxxu"|"wifi:rtl8723au"|"wifi:rtl8188cu"|"wifi:rtl8188ru"|"wifi:rtl8191cu"|"wifi:rtl8192cu"|"wifi:rtl8723bu"|"wifi:rtl8192eu"|"wifi:rtl8188fu"|"wifi:rtl8188eu"|"wifi:rtl8710bu"|"wifi:rtl8188gu"|"wifi:rtl8192fu") ]] ; then
		ot-kernel_y_configopt "CONFIG_LEDS_CLASS"
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NEW_LEDS"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTL8XXXU" # 2010, 2011, 2013, 2014, 2017, 2019, 2022
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw87") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8723DE" # 2018
		ot-kernel_y_configopt "CONFIG_RTW88_8723DU" # 2018
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8723"|"wifi:rtw8723de") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8723DE" # 2018
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8723"|"wifi:rtw8723du") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8723DU" # 2018
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rtw88"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8821CE" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8821CU" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8822BE" # 2016
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_RTW88_8822CE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW88_8822CU" # 2021
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8811"|"wifi:rtl8821"|"wifi:rtl8821ce") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8821CE" # 2017
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8811"|"wifi:rtl8821"|"wifi:rtl8821cu") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8821CU" # 2017
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8822"|"wifi:rtl8822be") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8822BE" # 2016
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8822"|"wifi:rtl8822bu") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8822"|"wifi:rtl8822ce") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8822CE" # 2022
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8822"|"wifi:rtl8822cu") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8822CU" # 2021
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8851"|"wifi:rtw8851be") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8851BE" # 2023
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8852"|"wifi:rtw8852ae") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852AE" # 2021
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8852"|"wifi:rtw8852be") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852BE" # 2022
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8852"|"wifi:rtw8852bte") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852BTE" # 2022
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8852"|"wifi:rtw8852ce") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852CE" # 2024
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtw8922"|"wifi:rtw8922ae") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8922AE" # 2024
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rtw89"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW89" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8851BE" # 2023
		ot-kernel_y_configopt "CONFIG_RTW89_8852AE" # 2021
		ot-kernel_y_configopt "CONFIG_RTW89_8852BE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW89_8852BTE" # 2022
		ot-kernel_y_configopt "CONFIG_RTW89_8852CE" # 2024
		ot-kernel_y_configopt "CONFIG_RTW89_8922AE" # 2024
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_usb_1_1_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dec2000-t"|"tv-tuner:dec2540-t"|"tv-tuner:dec3000-s") ]] ; then
	# Hauppauge
	# TechnoTrend
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_TTUSB_DEC" # Tuner for DVB-T.  It is the whole device driver that includes the USB bridge.
	# The ttusbdecfe.c is the demodulator driver.  The AI said that it does have hints or infer that it is also a tuner driver.
	# The ttusb_dec.c is the USB bridge driver.
	# The frontend is the portion containg the tuner and the demodulator according to linuxtv.  This is why you see fe in the name.
	# It is hypothesized that the firmware has the LNB controller driver for DVB-S.  Typically, the LNB support is a driver in the kernel.
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dec3000-s") ]] ; then
			export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-S USB-1.1"
		else
			export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-T USB-1.1"
		fi
	fi
	# The tv-tuner:dec3000-s is not supported until the DVB-S demodulator model is known.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-usb"($|" ")|"tv-tuner:wintv-nova-t-usb-p1"($|" ")) ]] ; then
	# Frontend possibility 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_TTUSB_BUDGET" # Tuner for DVB-T with td1316.  It is the whole device driver that includes the USB bridge.
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-1.1"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-usb"($|" ")|"tv-tuner:wintv-nova-t-usb-p2"($|" ")) ]] ; then
	# Frontend possibility 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22700" # Demodulator for DVB-T, QAM, 8-VSB
		ot-kernel_y_configopt "CONFIG_DVB_TTUSB_BUDGET" # Tuner for DVB-T with TDMB7.  It is the whole device driver that includes the USB bridge.
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-1.1"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s-usb"($|" ")|"tv-tuner:wintv-nova-s-usb-p1") ]] ; then
	# Frontend possibility 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_STV0299" # Demodulator for DVB-S, DSSTM
		ot-kernel_y_configopt "CONFIG_DVB_TTUSB_BUDGET" # Tuner for DVB-S with BSRU6.  It is the whole device driver that includes the USB bridge.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S USB-1.1"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s-usb"|"tv-tuner:wintv-nova-s-usb-p2") ]] ; then
	# Frontend possibility 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_TDA8083" # Demodulator for DVB-S
		ot-kernel_y_configopt "CONFIG_DVB_TTUSB_BUDGET" # Tuner for DVB-S with 29504-451.  It is the whole device driver that includes the USB bridge.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S USB-1.1"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:artec-t1-usb-tv-box"($|" ")|"tv-tuner:artec-t1-usb-tvbox"($|" ")|"tv-tuner:usb1.1-dvb-t-reference-design-mod3000"|"tv-tuner:usb1.1-dvb-t-reference-design") ]] ; then
	# Artec T1 USB1.1 TVBOX with AN2135 -> Thomson Cable [tuner, driver default]
	# DiBcom USB1.1 DVB-T reference design (MOD3000) -> Panasonic ENV77H11D5 [tuner]
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MB" # Demodulator for DVB-T based on logs
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIBUSB_MB" # USB bridge, tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIBUSB_MB_FAULTY" # From log
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-1.1"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:artec-t1-usb-tv-box"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-1.1"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_usb_2_0_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-aero-m" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LG2160" # ATSC-M/H demodulator
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3305" # ATSC & DVB-T demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB_MXL111SF" # Tuner & demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ATSC-M/H DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-duet-hd-stick-52009" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T for 7000PC
		ot-kernel_y_configopt "CONFIG_DVB_TUNER_DIB0070" # Tuner for DVB-T/T2, DVB-H, DVB-SH, T-DMB, ISDB-T, CMMB, DAB/DAB+, ATSC-M/H
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850"($|" ")|"tv-tuner:wintv-hvr-850-65301") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # A/V decoder for analog video input
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850"($|" ")|"tv-tuner:wintv-hvr-850-72301") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_DTV" # Digital demodulator
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Tuner and analog demodulator
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850"($|" ")|"tv-tuner:wintv-hvr-850-01200") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3305" # ATSC demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Analog and digital tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB interface, A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-900"($|" ")|"tv-tuner:wintv-hvr-900-65008"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge and A/V analog decode for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog decoder
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-900"($|" ")|"tv-tuner:wintv-hvr-900-65018"($|" ")) ]] && ver_test "${KV_MAJOR_MINOR}" -le "2.6" ; then
	# Not supported because the kernel is old
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DRX397XD" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge and A/V analog decode for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog decoder
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	# The wintv-hvr-900h is not supported because chip models IDs are not clear or well defined.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-930c"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DRXK" # Demodulator for DVB-C, DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_IR_MCEUSB"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Tuner for NTSC, PAL, SECAM, DVB-C, DVB-S, DVB-T/T2 and analog IF demodulator
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge and A/V analog decode for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T PAL USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-930c-hd"($|" ")|"tv-tuner:wintv-hvr-930c-hd-p1") ]] ; then
	# Frontend possibility 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2165" # Demodulator for DVB-C, DVB-H, DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, DVB-T/T2, DVB-C/C2, ATSC, ISDB-T, DTMB, J.83B
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T NO-PAL USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-935c"($|" ")) ]] ; then
	# This set represents an actual hvr-935c.  The auto probe for tv-tuner:wintv-hvr-935-hd which identifies as hvr-935c may be different from the hvr-935c hardware set.
	# Supported upstream but chip details are unknown.
	# Typically, the bridge chip will stay the same but the frontend (tuner or demodulators) changes for different model numbers or possibly revisions.
	# This is why this one is separate from the tv-tuner:wintv-hvr-930c-hd.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_IR_MCEUSB"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for demodulators and tuners
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-T ?-DVB-T2 ?-DVB-C ?-PAL USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-930c-hd"($|" ")|"tv-tuner:wintv-hvr-930c-hd-p2") ]] ; then
	# Frontend possibility 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2165" # Demodulator for DVB-C, DVB-H, DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_IR_MCEUSB"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for ATSC, QAM, DTMB, DVB-T/T2, DVB-C/C2, ISDB-T/C, NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T NO-PAL USB-2.0"
	fi
	#
	# You can't really trust what is put out there.
	# There are some hypothetical possibilities:
	# 1. The wiki contributor or editor placed the dmesg log in the wrong wiki page.
	# 2. The manufactuer did not update the firmware model product name in the firmware but the hardware and chips itself are correct.
	# 3. The card was placed in the wrong box.
	# 4. The driver has the wrong model name.
	# 5. The card was possibly rebranded from 935c to 935 hd.
	# 6. The card's <vendor-id>:<product-id> has multiple product names and was mislabled by the driver.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-935-hd"($|" ")) ]] ; then
	# Based on logs
	# See the linuxtv wiki "making it work" section about the inconsistency/workaround/quirk.
	# The quirk is that the The WinTV-HVR-935 HD card uses driver or firmware that identifies as WinTV-HVR-935C.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator for DVB-C, DVB-T/T2/T2-Lite
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_IR_MCEUSB"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T/T2, DTMB, ISDB-T/C, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge, analog IF demodulator for NTSC, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # A/V decoder for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T ?-DVB-T2 PAL USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-950"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Digital demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner and analog demodulator
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2" # Analog capture
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Video decoder
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-950q") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_DTV" # ATSC and ClearQAM digital demodulators
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_V4L" # Analog demodulator
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_V4L2" # Analog video capture
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-955q" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3306A" # ATSC and QAM digital demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog and digital tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-975"($|" ")) ]] ; then
	# Supported upstream but chip details are unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_IR_MCEUSB"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for demodulators and tuners
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="?-ATSC-1.0 ?-QAM ?-DVB-T ?-DVB-T2 ?-DVB-C ?-NTSC ?-PAL ?-SECAM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1900" ]] ; then
	# Model 73219, rev D1F5
	# Based on logs
	# The logs are missing the demodulator model.
	# The driver set assumes that the CONFIG_VIDEO_PVRUSB2_DVB will add all the DVB-T demodulator
	# drivers and autodetect the DVB-T demodulator.
	# The FM tuner chip is unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, ATSC, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # Hypothesized from American version; MPEG encoder, analog IF demodulator for FM radio
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # A/V decoder with cx25843-24 for NTSC, PAL, SECAM, BTSC, EIA-J, AT, NICAM, FM/AM
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_SYSFS"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL NO-FM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1950" ]] ; then
	# The FM tuner chip is unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_IT913X" # Possibly used digital tuner DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Possibly used analog/digital tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder, analog IF demodulator for FM radio
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # Video decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_SYSFS"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC NO-FM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-hd-stick"($|" ")|"tv-tuner:pctv-hd-stick-801ese") ]] ; then
	# Missing analog support in driver
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1411" # ATSC (8-VSB) and QAM demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 QAM NO-NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-hd-pro-stick"($|" ")|"tv-tuner:pctv-hd-pro-stick-800e") ]] ; then
	# QAM is not supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # ATSC, NTSC, ClearQAM tuner
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, DMB-T, DVB-T, ISDB-T; driver also supports xc3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog video decoder for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2_SUBDEV_API"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-hd-pro-stick"($|" ")|"tv-tuner:pctv-hd-pro-stick-801e") ]] ; then
	# Missing analog support in driver
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1411" # Demodulator for ATSC, ClearQAM
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # Analog video/audio decoder for NTSC, PAL, PAL60, SECAM
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 QAM NO-NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-72e" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MC"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000M"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_TUNER_DIB0070" # Tuner
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-nano-stick"($|" ")|"tv-tuner:pctv-73e"($|" ")|"tv-tuner:pctv-nano-stick-73e-se-solo") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_TUNER_DIB0070" # The assumed tuner, but it is not defined in the component list
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_SMS_USB_DRV"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-nanostick-t2"($|" ")|"tv-tuner:pctv-nanostick-t2-290e") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CXD2820R" # Decoding and demodulation for DVB-T/T2, DVB-C
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_COMMON_OPTIONS"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner to IF to send to demodulator for PAL, NTSC, SECAM, DVB-T, ATSC, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-dvb-s2-stick"|"tv-tuner:pctv-dvb-s2-stick-460e") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10071" # Demodulator and tuner for DVB-S/S2
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv-wonder-hd-600-usb") ]] ; then
	# ATI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Digital demodulator for ATSC (8-VSB) and 64/256-QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog decoder
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-hybrid"($|" ")|"tv-tuner:eyetv-hybrid-2008"|"tv-tuner:eyetv-hybrid-eu-2008") ]] ; then
	# Elgato
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DRXK" # Demodulator for DVB-C DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for DVB-C, DVB-T, ISDB-T ATSC, NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge, analog audio
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog video decoder for NTSC, PAL, PAL60
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T PAL USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-hybrid-us") ]] ; then
	# Elgato
	# QAM is not supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Analog tuner for NTSC, PAL, SECAM, CVBS, SIF; Digital tuner for ATSC, DVB-C, DVB-T, DMB-T, ISDB-T, 64-QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Analog (NTSC, PAL, SECAM) and digital tuner (ATSC, DVB-T, DVB-C)
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge, analog audio
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog video decoder for NTSC, PAL, PAL60
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-dtt"(|" ")|"tv-tuner:eyetv-dtt-rev.2") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator and tuner for DVB-T, DVB-H, T-DMB, ISDB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-dtt-deluxe"(|" ")) ]] ; then
	# Elgato
	# I haven't seen all the chips detected in dmesg logs compared to the EyeTV DTT
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for tuner, demodulators
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-dtt-deluxe-v2"(|" ")|"tv-tuner:eyetv-dtt-deluxe-2009"|"tv-tuner:picostick"($|" ")|"tv-tuner:picostick-74e"($|" ")) ]] ; then
	# Elgato
	# PCTV
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_AS102" # USB bridge, tuning and demodulation of DVB-T.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:indtube"|"tv-tuner:in-d-tube") ]] ; then
	# EVGA
	# TODO:  consider adding patch, see wiki
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # ATSC (8-VSB), ClearQAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Tuner for PAL, SECAM, NTSC, FM radio, analog TV sound
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge, analog audio
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:xbox-one-digital-tv-tuner") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MN88472" # Demodulator for DVB-T, DVB-T2, DVB-C, ISDB-T, DTMB
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18250" # A tuner that lets the demodulator determine the supported standards
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T DVB-T2 DVB-C USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-stick"|"tv-tuner:wintv-nova-t-stick-70001"|"tv-tuner:wintv-nova-t-stick-70009"|"tv-tuner:wintv-nova-t"($|" ")|"tv-tuner:wintv-nova-t-lite"|"tv-tuner:wintv-nova-t-se") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T, DVB-H, T-DMB, ISDB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2266" # Tuners for DVB-T, DVB-H
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-usb2") ]] ; then
		ot-kernel_y_configopt "CONFIG_CYPRESS_FIRMWARE" # For USB bridge with FX2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MC" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # PLL for DVB-T with ENV57H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_DVB_USB_NOVA_T_USB2" # USB bridge with FX2
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-td-stick") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T, DVB-H, T-DMB, ISDB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2266" # Tuners for DVB-T, DVB-H
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s-usb2") ]] && ver_test "${KV_MAJOR_MINOR}" -le "6.0" ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24123" # Demodulator and tuner for DVB-S with CX24123; tuner and LNB controller for DVB-S with CX24109
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_TM6000" # USB bridge and video decoder.  Only available kernel version <= 6.0.
		ot-kernel_y_configopt "CONFIG_VIDEO_TM6000_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_TM6000_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s2"($|" ")|"tv-tuner:wintv-nova-s2-satellite-tv-receiver") ]] ; then
	# Supported upstream but with workaround
	# There are more patches for the Nova S2.
	# Users noted that the branded "wintv-nova-s2" device is identified as PCTV 461 or misidentified as PCTV DVB-S2 Stick (461e v2).
	#
	# For fixes, see
	# Workaround - https://github.com/b-rad-NDi/media_tree/issues/12
	# Patch to fix both misidentification and similaneous TV cards - https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/issues/162
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for tuner, demodulators, and LNB controller.
		# Typically the LNB controller is manually added.
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB device controller
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"

	# There is a design choice where you can build all drivers as external modules or as built-in.
	# It is assumed as built-in for security reasons, but users can choose to build as modules.
		ot-kernel_unset_pat_kconfig_kernel_cmdline "em28xx.card=[0-9]+"

		if [[ "${OT_KERNEL_WINTV_NOVA_S2_GH_162_FIX_APPLIED}" == "1" ]] ; then
			:
		else
			ot-kernel_set_kconfig_kernel_cmdline "em28xx.card=92" # The workaround
	# People have multiple TV cards so they can do picture-in-picture in their live streams.
ewarn "A user patch for tv-tuner:wintv-nova-s2 may be needed for multiple tuners cards to be used at the same time with the same em2xx driver."
ewarn "See https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/issues/162"
ewarn "After applying the patch use OT_KERNEL_WINTV_NOVA_S2_GH_162_FIX_APPLIED=1"
		fi

		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-solohd") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MMAP"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Digital demodulator for DVB-C/T/T2
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER_DVB"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, QAM, DVB-T/T2, DVB-C, DTMB
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB device controller
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-dualhd") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Digital demodulator for DVB-C/T/T2
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, QAM, DVB-T/T2, DVB-C, DTMB
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB device controller
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-triplestick-t2"($|" ")|"tv-tuner:pctv-triplestick-t2-292e") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Digital demodulator for DVB-C/T/T2
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, QAM, DVB-T/T2, DVB-C, DTMB
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB device controller
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:avertv-digi-volar-x"($|" ")|"tv-tuner:avertv-digi-volar-x-a815") ]] ; then
	# AVerMedia
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MXL5005S" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:avertvhd-volar"($|" ")|"tv-tuner:avertvhd-volar-a868r") ]] ; then
	# AVerMedia
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator/decoder for ATSC (8-VSB), QAM
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_CXUSB" # USB bridge
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MXL5005S" # Tuner, but LG DT3303 is needed for 8-VSB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:t328b"($|" ")) ]] ; then
	# Geniatech
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER_DVB"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:t220"($|" ")) ]] ; then
	# Geniatech
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CXD2820R" # Demodulator for DVB-C, DVB-T/T2
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_CXUSB" # Whole device driver for both the CY7C68013A (USB microcontroller) and tuners
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:t230"($|" ")|"tv-tuner:t210v2"($|" ")|"tv-tuner:pt360"|"tv-tuner:d202") ]] ; then
	# August
	# Geniatech
	# MyGica
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator for DVB-C, DVB-T/T2
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_CXUSB" # Whole device driver for both the CY7C68013A-56LTXC (USB microcontroller) and tuners
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, QAM, DVB-C, DVB-T/T2, DTMB with either Si2148-A20 or Si2158-A20 tuners depending on model
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:t230c"($|" ")|"tv-tuner:t2"($|" ")|"tv-tuner:t2-hybrid"|"tv-tuner:t2-lite") ]] ; then
	# Elgato eyeTV
	# Geniatech
	# MyGica
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator for DVB-C, DVB-T/T2
		ot-kernel_y_configopt "CONFIG_DVB_USB_DVBSKY" # Whole device driver for both the CY7C68013A-56LTXC (USB microcontroller) and tuners
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, QAM, DVB-C, DVB-T/T2, DTMB
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-C DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:t230c2"($|" ")|"tv-tuner:dvb-t210-v2.0"|"tv-tuner:dvb-t230") ]] ; then
	# August
	# Geniatech
	# MyGica
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator for DVB-C, DVB-T/T2
		ot-kernel_y_configopt "CONFIG_DVB_USB_DVBSKY" # Whole device driver for both the CY7C68013A (USB bridge) and tuners
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, QAM, DVB-C, DVB-T/T2, DTMB
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T DVB-T2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:sbtvd-stick-s870") ]] ; then
	# Geniatech
	# MyGica
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB8000" # Demodulator and tuner for ISDB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="ISDB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-t-usb2-stick") ]] ; then
	# Hama
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:playtv-usb-sbtvd") ]] ; then
	# PixelView
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB9000" # TV tuner and demodulator for ISDB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ISDB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-ministick"($|" ")|"tv-tuner:pctv-microstick-pc-and-mac"($|" ")|"tv-tuner:pctv-microstick-pc-and-mac-77e") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SMS_USB_DRV" # Hypothesized USB bridge.  Tuner and demodulator for DVB-T.
	# Typically a TV tuner will have 2-3 chips or driver config symbols.
	# Two LLMs suggest that it is a tuner and demodulator and then eagerly say that it is not a USB bridge.
	# I ask the question to one of them does the source code hint [infer] that it could be a USB bridge and could you tell by grepping it?
	# One LLM suggested that it fulfils the role as a USB bridge.
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-ministick-2"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_AF9033" # USB bridge, demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_IT913X" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-dvb-s2-stick-461e"($|" ")|"tv-tuner:pctv-dvb-s2-stick"($|" ")) ]] && ver_test "${KV_MAJOR_MINOR}" -le "4.0" ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_M88DS3103" # Demodulator for DVB-S/S2
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_M88TS2022" # Tuner for DVB-S/S2
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-duo"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-mini-ii"($|" ")|"tv-tuner:digi-vox-mini-ii"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_M920X" # USB bridge, tuner and demodulator drivers
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-mini-ii-v3.0"($|" ")|"tv-tuner:k-vox"($|" ")|"tv-tuner:digivox-mini-ii-v3.0-p2") ]] ; then
	# MSI
	# Device profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-mini-ii-v3.0"($|" ")|"tv-tuner:digivox-mini-deluxe"($|" ")|"tv-tuner:digivox-mini-ii-v3.0-p1"|"usb-dvbt-hd"|"hu394") ]] ; then
	# DIKOM
	# MaxMedia
	# MSI
	# Device profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_RTL2832" # Demodulator for DVB-T, ISDB-T, DAB, DAB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_RTL28XXU" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_FC0012" # Tuner for DVB-T, DAB, FM, SDR, H.262, H.264
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-mini-iii"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:digivox-trio"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DRXK" # Demodulator for DVB-C, DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface with em2884
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:md95700"($|" ")|"tv-tuner:md95700-mdusbtv-hybrid") ]] ; then
	# Medion
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_CXUSB" # For transfering firmware to device.  It also likely includes the USB bridge driver which interacts with an unlisted IC/chip.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME MK3 tuner for DVB-T, PAL, SECAM, FM radio.  Partial demodulator for FM radio.
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_ATI_REMOTE"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # A/V decoder and demodulator for PAL, SECAM; ADC; linear PCM output (For FM radio)
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL FM ?-Capture USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:mytv.t"($|" ")|"tv-tuner:nova-t-mytv.t") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_ATI_REMOTE"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:playtv"($|" ")|"tv-tuner:playtv-dual-tuner-dvb-t"($|" ")) ]] ; then
	# Sony
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator and tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:my-cinema-u3000-mini"($|" ")) ]] ; then
	# ASUS
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator and tuner for DVB-T.
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # For loading firmware, USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2266" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:u7000"($|" ")) ]] ; then
	# Gigabyte
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:u8000-rh"($|" ")) ]] ; then
	# Gigabyte
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Digital demodulator and tuner for DVB-T.
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # For loading firmware, USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-NTSC NO-PAL NO-SECAM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:quatrostick-nano-520e"($|" ")|"tv-tuner:pctv-520e"($|" ")) ]] ; then
	# PCTVSystems
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DRXK" # Demodulator for DVB-C, DVB-T, PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator and tuner for DVB-T.
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME MK3 tuner for DVB-T, PAL, SECAM, FM radio.  Partial demodulator for FM radio.
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface with em28174
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # Analog TV decode for NTSC, PAL, SECAM; ADC; audio capture, TV/video digitization, video capture
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T NO-PAL NO-SECAM NO-NTSC NO-FM USB-2.0"
	fi
	# In this eclass,
	# (1) any changes to the USB bridge but retain the same product name/id is considered a new device profile.
	# (2) any changes to the demodulator but retain the same bridge model and product name/id is considered a new fontend profile.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:mega-sky-580"($|" ")|"tv-tuner:mega-sky-580-p1") ]] ; then
	# MSI
	# Device profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT352" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_M920X" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_QT1010" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:mega-sky-55801"($|" ")|"tv-tuner:mega-sky-580"($|" ")|"tv-tuner:mega-sky-580-p2") ]] ; then
	# MSI
	# Device profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_GL861" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_QT1010" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-dongle-mini-d"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_RTL2832" # Demodulator for DVB-T, ISDB-T, DAB, DAB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_RTL28XXU" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_FC0012" # Tuner for DVB-T, DAB, FM, SDR, H.262, H.264.  This could be pruned and log doesn't show it load
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-dongle-gold"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-dongle"($|" ")|"tv-tuner:usb2.0-winfast-dtv-dongle"($|" ")|"tv-tuner:usb-2.0-winfast-dtv-dongle-stk3000p"($|" ")|"tv-tuner:winfast-dtv-dongle-stk3000p"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MC" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIBUSB_MC" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dongle-hybrid"($|" ")|"tv-tuner:winfast-dtv-dongle-h"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator for DVB-T/T2
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # A/V decoder for NTSC, PAL, SECAM, FM/AM
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-dual-dongle"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9035" # Demodulator for DVB-T and USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_IT913X" # Tuner for DVB-T with IT9135
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-dual-dvb-t-diversity-stick"($|" ")|"tv-tuner:pctv-dual-dvb-t-diversity-stick-2001e"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MC"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000M"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "dvb_usb_dib0700.force_lna_activation=[01]"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "dvb_usb.disable_rc_polling=[01]"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "usbcore.autosuspend=(-1|0|1)"
		ot-kernel_set_kconfig_kernel_cmdline "dvb_usb_dib0700.force_lna_activation=1"
		ot-kernel_set_kconfig_kernel_cmdline "dvb_usb.disable_rc_polling=1"
		ot-kernel_set_kconfig_kernel_cmdline "usbcore.autosuspend=-1"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-hybrid-pro-card"($|" ")|"tv-tuner:pctv-hybrid-pro-card-310c"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="NO-DVB-T PAL SECAM FM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tvgo-dvb-t03"($|" ")|"tv-tuner:tvgo-dvb-t03-p1") ]] ; then
	# Genius
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tvgo-dvb-t03"($|" ")|"tv-tuner:tvgo-dvb-t03-p2") ]] ; then
	# Genius
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_RTL2832" # Demodulator for DVB-T, ISDB-T, DAB, DAB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_RTL28XXU" # PCI bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_FC0012" # Tuner for DVB-T, DAB, FM, SDR, H.262, H.264
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:max-s2-or-wintv-nova-hd-usb2.0"($|" ")|"tv-tuner:wintv-nova-hd-usb2.0"($|" ")|"tv-tuner:max-s2"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DW2102" # Whole driver for all components
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-315u"($|" ")|"tv-tuner:plustv-hd-usb-315"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator for ATSC (8VSB), QAM,
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # Tuner for DVB-T with DTT 7611A
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA711X" # Video decoder for NTSC, PAL, SECAM; closed captioning
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-330u"($|" ")|"tv-tuner:plustv-hd-hybrid-stick-330"($|" ")|"tv-tuner:plustv-hd-hybrid-330"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
	# The S5H1409 is rebranded as CX24227.  See commit 89885558ada9e076b48f4b6887e252e13e7eaf74
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Video decoder for NTSC, PAL, SECAM; closed captioning
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-340u"($|" ")|"tv-tuner:plustv-hd-hybrid-stick-340"($|" ")|"tv-tuner:astc-340u-dongle-hdtv-usb-stick") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator for ATSC (8VSB), QAM,
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM NTSC USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:ub435-q-usb-atsc-tv-stick"($|" ")|"tv-tuner:ub435-q-v2"($|" ")|"tv-tuner:ub435-q"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator for ATSC (8VSB), QAM,
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:ub435-q-v3"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator for ATSC (8VSB), QAM,
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18212" # Tuner for ATSC, DVB-T, DVB-T2
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM USB-2.0"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:ub445-u-atsc-hybrid-tv-stick"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24110" # Analog IF demodulator with CX24228-21Z for ATSC, QAM.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB interface, A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ASTC-1.0 ClearQAM NTSC USB-2.0"
	fi
	# Missing 18272/M driver for tv-tuner:ub445-u2-atsc-hybrid-tv-stick
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:ub445-u-atsc-hybrid-tv-stick"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T USB-2.0"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_usb_3_0_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-quadhd"($|" ")|"tv-tuner:wintv-quadhd-usb"($|" ")|"tv-tuner:wintv-quadhd-usb-astc"($|" ")) ]] ; then
	# It will be identified as "quadHD-A"
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MXL692" # Tunerand demodulator for ASTC
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface with em28174
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 USB-2.0"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_pci_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hdtv-wonder"($|" ")|"tv-tuner:hdtv-wonder-regular-edition") ]] ; then
	# ATI
	# No analog sound support because driver missing
	# Digital sound decode done by sound card DAC
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ATSC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ATSC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF (radio Intermediate Frequency) demodulator for PAL, SECAM, NTSC
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 QAM NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hdtv-wonder"($|" ")|"tv-tuner:hdtv-wonder-value-edition") ]] ; then
	# ATI
	# TU1236 uses the same driver as TUV1236D
	# Removes AK5355, TDA9887
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ATSC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ATSC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:my-cinema-p7131-hybrid") ]] ; then
	# ASUS
	# FM radio support is incomplete
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator and tuner for DVB-T and PAL
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog demodulator
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge and A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL NO-FM PCI"
	fi
	# tv-tuner:wintv-d is not supported because it is missing the driver for TDA8960, a demodulator
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1100" ]] ; then
	# The FM radio model for the demodulator is unknown.
	# The FM radio demodulator could be the CX2388X.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME MK3 tuner for DVB-T, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge with CX2388X
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL NO-FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1110" ]] ; then
	# The FM radio models for tuner and demodulator are unknown but suggested in wiki.
	# The DVB-T tuner model is unknown.
	# It assumes that the tuner is autodetected and all possible DVB-T tuners are enabled by SAA7134.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL NO-FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1300") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME tuner for DVB-T, PAL, SECAM, FM radio.  Partial demodulator for FM radio.
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX2388X.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD" # MPEG-2 encoder with CX23416
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	#
	# The hypothetical high level analysis for FM radio support
	#
	# 1. FMD1216ME does FM frequency tuning and partial demodulation of FM radio.
	# 2. FMD1216ME passes signal to CX2388x for ADC (audio to digital conversion) processing to PCM.
	# 3. CX2388x passes PCM to software.
	# 4. Software performs stereo decoding, where the mono signal is converted to stereo.
	#
	# For the above list, stereo decoding happens in CX2388x in step 2 or it is offloaded to the CPU in step 4.
	# The component interaction map can determine if the driver set is complete.
	#
	# Alternatively,
	#
	# 1. FM radio waves > tuner
	# 2. tuner > demodulator
	# 3. demodulator > ADC
	# 4. ADC > PCM
	# 5. PCM > PCI
	# 6. PCI > OS
	# 7. OS > App
	# 8. App > library
	# 9. library > mono-to-stereo DSP
	# 10. mono-to-stereo DSP > library
	# 11. library > app
	# 12. app > OS
	# 13. OS > speaker
	#
	# Different systems will combine or offload to reduce cost and to miniaturize.
	#
	# The CONFIG_VIDEO_IVTV is not necessary.  Two LLMs disagree if the symbol is needed for FM radio support for wintv-hvr-1300.
	#
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1600" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
	# The S5H1409 is rebranded as CX24227.  See commit 89885558ada9e076b48f4b6887e252e13e7eaf74
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog demodulator for NTSC, PAL, SECAM, AM/FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MXL5005S" # Digital tuner for ASTC, DVB-T, ClearQAM, PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCI_QUIRKS"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX18" # Handle video and audio streams
		ot-kernel_y_configopt "CONFIG_VIDEO_CX18_ALSA" # Audio support
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="NO-ATSC-1.0 ClearQAM NTSC NO-FM PCI" # ClearQAM support is model dependent.
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-3000" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_CX24123" # Demodulator, LNB controller, tuner for DVB-S
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME tuner for DVB-T, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
	# Missing FM radio model for demodulator for FM radio support
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-T NO-PAL NO-SECAM NO-FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-4000" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_CX24116" # Demodulator for DVB-S/S2.  It is also the driver for CX24118A tuner for DVB-S/S2.
		ot-kernel_y_configopt "CONFIG_DVB_ISL6421" # LNB controller
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Demodulator for FM, analog TV
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME MK3 tuner for DVB-T, PAL, SECAM, FM radio; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ATSC, PAL, NTSC, DOCSIS
	# Missing driver for TDA7040 FM decoder so it is offloaded to the CPU
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_WM8775" # ADC
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 DVB-T PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nexus-s"($|" ")|"tv-tuner:wintv-nexus-s-rev-2.x"($|" ")|"tv-tuner:wintv-nexus-s-rev-2.1-p1"|"tv-tuner:wintv-nexus-s-rev-2.2"|"tv-tuner:wintv-nexus-s-rev-2.3") ]] ; then
	# Frontend possibility 1
		ot-kernel_y_configopt "CONFIG_DVB_AV7110" # DVB-S tuner with either BSRU6, BSRV2, or BSBE1; MPEG-2 decoder
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_STV0299" # Demodulator for DVB-S, DSSTM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_STAGING"
		ot-kernel_y_configopt "CONFIG_STAGING_MEDIA"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7146" # USB bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nexus-s"($|" ")|"tv-tuner:wintv-nexus-s-rev-2.x"($|" ")|"tv-tuner:wintv-nexus-s-rev-2.1-p2") ]] ; then
	# Frontend possibility 2
		ot-kernel_y_configopt "CONFIG_DVB_AV7110" # DVB-S tuner with either BSRU6, BSRV2, or BSBE1; MPEG-2 decoder
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_VES1X93" # Demodulator for DVB-S
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_STAGING"
		ot-kernel_y_configopt "CONFIG_STAGING_MEDIA"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7146" # USB bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s-pci") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_BUDGET_CORE" # DVB-S tuner with BSBE1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_STV0299" # Demodulator for DVB-S, DSSTM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7146" # USB bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-s-plus"|"tv-tuner:wintv-nova-se2") ]] ; then
	# The tuner model is unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24123" # Demodulator and FEC decoder for DVB-S, DSS
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force autodetection of tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-pci"($|" ")|"tv-tuner:wintv-nova-t-pci-p1") ]] ; then
	# Frontend possibility 1
		ot-kernel_y_configopt "CONFIG_DVB_BUDGET_CORE" # Tuner for DVB-T with 29504-401.04
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_L64781" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7146" # PCI bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-pci"($|" ")|"tv-tuner:wintv-nova-t-pci-p2") ]] ; then
	# Frontend possibility 2
		ot-kernel_y_configopt "CONFIG_DVB_BUDGET_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_BUDGET_CI" # Tuner for DVB-T  with tdm1316l
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7146" # PCI bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-pci"($|" ")|"tv-tuner:wintv-nova-t-pci-90002"|"tv-tuner:nova-t-dvb-t"($|" ")) ]] ; then
	# This is added  based on the working status in the distro forum.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # For dtt759x tuner or specifically dtt7592 for ASTC, DVB-T ; This could be pruned since dmesg doesn't show message of the driver loading but config symbol added for robustness.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882;  The cx88 driver will report tuner=76 which corresponds to Thomson dtt759x symbol.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_MPEG"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	# tv-tuner:wintv-nova-t-pci-90003 is not supported because driver is missing for DTT75105 tuner.
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-t-500"|"tv-tuner:wintv-nova-t-500-dual-dvb-t") ]] ; then
	# USB drivers required because of USB 2.0 hub on-board
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB3000MC" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # PCI-to-USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-nova-td-500"($|" ")|"tv-tuner:wintv-nova-td-500-dual-tuner"|"tv-tuner:wintv-nova-td-500-84xxx") ]] ; then
	# Based on logs
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P" # Demodulator and tuner for DVB-T, DTMB
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Tuner for NTSC, PAL, SECAM, DVB-C
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	# tv-tuner:wintv-hvr-1600mce is not supported since TMFNM05_12E was removed
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-hd-card"($|" ")|"tv-tuner:pctv-hd-card-800i") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Analog and digital tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 QAM NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:avertv-dvb-t-super-007"($|" ")|"tv-tuner:avertv-dvb-t-super-007-m135d") ]] ; then
	# AVerMedia
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator and decoder for DVB-T, DVB-H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA827X" # Tuner for DVB-T if paired with TDA10046A
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge, analog decoder for A/V
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-pci-fm") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FM1216ME MK3 tuner for PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF demodulator for NTSC, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		export _OT_KERNEL_TV_TUNER_TAGS="PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-radio"($|" ")|"tv-tuner:wintv-radio-44914-rev-c121") ]] ; then
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # Analog tuner for PAL, FM radio with possibly FI1216
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_BT848" # PCI bridge, video decoder, video capture, video processing
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:voodootv-100-pci") ]] ; then
	# 3DFX
		ot-kernel_y_configopt "CONFIG_EEPROM_AT24" # For reading the 24c01a
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # Tuner for NTSC, FM radio; and analog audio demodulation with 4032FY5
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SND_BT87X"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_VIDEO_BT848" # PCI bridge and analog video demodulation
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_TDA7432" # Audio processor
		ot-kernel_y_configopt "CONFIG_VIDEO_TEA6420" # Audio switch for input and output
		ot-kernel_y_configopt "CONFIG_VIDEO_TVAUDIO" # Audio decoder with TDA9850
		export _OT_KERNEL_TV_TUNER_TAGS="NTSC PAL FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:lr6650"|"tv-tuner:winfast-dtv1000-t") ]] ; then
	# LiveView
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # Tuner with DTT 7579
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hd-2000") ]] ; then
	# pcHDTV
		ot-kernel_y_configopt "CONFIG_DVB_BT8XX" # DVB support
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_OR51211" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_BT848" # A/V decoder, USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hd-3000") ]] ; then
	# pcHDTV
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_OR51132" # Digital tuner and demodulator for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF demodulator for NTSC, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882; Tuner freq selection control for TUA6030 (PAL/NTSC) component in DTT7011 tuner.  The DTT7011 does ATSC/8VSB tuning.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hd-5500") ]] ; then
	# pcHDTV
	# Supported but the models and tuners and demodulators are unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator for ATSC (8VSB), QAM,
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF demodulator for NTSC, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23882; Tuner freq selection control for TUA6030 (PAL/NTSC) component in DTT7011 tuner.  The DTT7011 does ATSC/8VSB tuning.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-1800-h"|"tv-tuner:winfast-dtv-1800-h-p1"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23883
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NTSC PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-1800-h"|"tv-tuner:winfast-dtv-1800-h-p2"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC4000" # Tuner for NTSC, PAL, SECAM, ASTC, DVB-T, QAM64; analog demodulation
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23883
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NTSC PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv-2000-h"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # FMD1216ME MK3 tuner for DVB-T, PAL, SECAM, FM radio.  Partial demodulator for FM radio.
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX2388X
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T NTSC PAL NO-FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv2000-h-plus"($|" ")|"tv-tuner:winfast-dtv2000-h-plus-p1"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC4000" # Tuner for NTSC, PAL, SECAM, ASTC, DVB-T, QAM64; analog demodulation
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge, A/V decoder and analog IF demodulator, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NTSC PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv2000-h-plus"($|" ")|"tv-tuner:winfast-dtv2000-h-plus-p2"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge, A/V decoder and analog IF demodulator, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NTSC PAL SECAM FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-starburst"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10071" # DVB-S/S2 demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge, A/V decoder and analog IF demodulator, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S2 PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-s-digistar"($|" ")|"digiwave-103g"($|" ")|"spc1000"($|" ")) ]] ; then
	# Geniatech
	# HomeVision
	# X3M
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24123" # Demodulator and tuner for DVB-S with CX24123; tuner and LNB controller for DVB-S with CX24109
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge, A/V decoder and analog IF demodulator, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-300i"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT352" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT20XX" # Tuner for NTSC, PAL, DVB-C, DVB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog demodulator
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # USB bridge, A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv2000ds"($|" ")|"tv-tuner:winfast-dtv2000-ds"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-dtv2000ds-plus"($|" ")|"tv-tuner:winfast-dtv2000-ds-plus"($|" ")) ]] ; then
	# Leadtek
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_RTL2832" # Demodulator for DVB-T, ISDB-T, DAB, DAB-T
		ot-kernel_y_configopt "CONFIG_DVB_USB_RTL28XXU" # PCI bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # DAB+
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_FC0013" # Tuner for DvB-T, DAB, DAB+
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T ?-DAB+ PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:v-stream-xpert-dvb-t-pci"($|" ")|"tv-tuner:v-stream-xpert-dvb-t-pci-p1"($|" ")|"tv-tuner:vstream-xpert-dvb-t-2"($|" ")) ]] ; then
	# KWorld
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # Tuner with DTT 7579
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:v-stream-xpert-dvb-t-pci"($|" ")|"tv-tuner:v-stream-xpert-dvb-t-pci-p2"($|" ")|"tv-tuner:vstream-xpert-dvb-t"($|" ")) ]] ; then
	# KWorld
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX22702" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # For dtt759x tuner or for ASTC, DVB-T ; This could be pruned since dmesg doesn't show message of the driver loading but config symbol added for robustness.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	# The cx88 driver is for PCI but the cx23885 driver is for PCIe.
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:v-stream-xpert-dvb-t-pci"($|" ")|"tv-tuner:v-stream-xpert-dvb-t-pci-p3"($|" ")|"tv-tuner:v-stream-xpert-dvt-dvb-t-pci"($|" ")) ]] ; then
	# KWorld
	# Frontend profile 3
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT352" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # Tuner for DVB-T with TDTC9251DH01C.  The driver references TDTC9251DH0.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23883
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:avertv-dvb-t-771"($|" ")) ]] ; then
	# AVerMedia
		ot-kernel_y_configopt "CONFIG_DVB_BT8XX" # DVB support
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT352" # Demodulator for DVB-T.
		ot-kernel_y_configopt "CONFIG_DVB_PLL" # Tuner for DVB-T with TDTC9251DH0
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_BT848" # PCI bridge, video decoder, video capture, video processing
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-t-pc160-2t"($|" ")) ]] ; then
	# KWorld
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_AF9013" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for DVB-T tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T ?-NTSC ?-PAL ?-SECAM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pc-160-t"($|" ")) ]] ; then
	# Peak
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_AF9013" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB_AF9015" # Demodulator for DVB-T; ADC; USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for DVB-T tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-t-220"($|" ")|"tv-tuner:dvb-t-220rf"($|" ")|"tv-tuner:dvbt-220rf"($|" ")) ]] ; then
	# KWorld
	# Tevion
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for DVB-T tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Tuner for NTSC, PAL, SECAM with tda8290+75a; FM radio processing
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # Analog demodulator for NTSC, PAL, SECAM, FM radio
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL ?-FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-110"($|" ")|"tv-tuner:astc110"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ATSC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ATSC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF (radio Intermediate Frequency) demodulator for PAL, SECAM, NTSC
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge, A/V analog decoding for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-115"($|" ")|"tv-tuner:plustv-hd-pci-115"($|" ")|"tv-tuner:astc110/115"($|" ")|"tv-tuner:astc115") ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ATSC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ATSC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF (radio Intermediate Frequency) demodulator for PAL, SECAM, NTSC
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge, A/V analog decoding for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atsc-120"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, ClearQAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge and A/V decoder with CX23883
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_BLACKBIRD"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 NTSC FM PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pc150-u"($|" ")|"tv-tuner:astc-150"($|" ")) ]] ; then
	# KWorld
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1411" # DTV receiver and demodulator for DVB-T, DVB-H, T-DMB, ISDB-T, MediaFLO, CMMB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC ?-FM PCI"
	fi
	if false && [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-t-210"($|" ")|"tv-tuner:dvb-t-210-p1") ]] ; then
	# KWorld
	# Profile 1
# Unfinished
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=65"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.tuner=54"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if false && [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:dvb-t-210"($|" ")|"tv-tuner:dvb-t-210-p2") ]] ; then
	# KWorld
	# Profile 2
# Unfinished
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=81"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.tuner=54"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv@nywhere-a/d"($|" ")|"tv-tuner:flydvb-t-hybrid") ]] ; then
	# MSI
	# LifeView
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_PLL"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TUNER"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=94"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.tuner=61"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv@nywhere-a/d-v1.1"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T with TDA10046H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TUNER"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=135" # The LinuxTVWiki suggested card=94 but claimed it caused tuning problems.
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PAL PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv@nywhere-a/d-v1.1-alt"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T with TDA10046H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA827X" # with 8275AC1
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Demodulator for NTSC, PAL, SECAM; with 8275AC1
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TUNER"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=109"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T PCI"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_pcie_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-starburst2"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_M88RS6000T" # Demodulator and tuner for DVB-S/S2
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and analog decoder for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1200") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10048" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, QAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and analog decoder for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	# Missing FM radio tuner and demodulator model ids.
	# It is possible that some revisions did or did not have FM radio support.
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-PAL NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1250") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
	# The S5H1409 is rebranded as CX24227.  See commit 89885558ada9e076b48f4b6887e252e13e7eaf74
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, ClearQAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	# Digital video decoding is unaccelerated and handled by the CPU with
	# userspace decoding.
	# It requires udev to make /dev/dvb/adapter0/dvr0 device node.
	# The dvr0 device node contains raw MPEG-2 Transport Stream (TS) but
	# needs a video player with DVB support for a few cards lacking
	# a hardware accelerated video decoder.
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Analog tuner for NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2131" # Digital tuner for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and analog decoder for PAL, NTSC, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1255"($|" ")) ]] ; then
	# Supported upstream but chip details are unknown.
ewarn "tv-tuner:wintv-hvr-1255 may require user patch for tuner.  See https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/blob/master/patches/mainline-extra/tip/10.random.patches/0002-cx23885-Set-Hauppauge-HVR1255-tuner-type-to-TDA18271.patch"
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for demodulators and tuners
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		export _OT_KERNEL_TV_TUNER_TAGS="?-ATSC-1.0 ?-ClearQAM ?-NTSC PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1265"($|" ")) ]] ; then
	# Supported upstream but chip details are unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT" # Force bloated autodetection for demodulators and tuners
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		export _OT_KERNEL_TV_TUNER_TAGS="?-ATSC-1.0 ?-ClearQAM ?-NTSC PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1700") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10048" # Digital demodulator for DVB-T, DVB-H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-T/T2, ISDB-T, DTMB.  From dmesg log in wiki.
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator for NTSC, PAL, SECAM, FM radio.  For Philips 18271_8295 from dmesg log in wiki.
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder for analog TV
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	# Missing FM radio tuner and demodulator model ids.
	# It is possible that some revisions did or did not have FM radio support.
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-PAL NO-SECAM NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1800"($|" ")|"tv-tuner:wintv-hvr-1800-full-height") ]] ; then
	# Medford
	# The LLM is flip-floping and self-contradicting for the the FM tuner chip.  The FM tuner model is unknown.
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Digital demodulator for ATSC, ClearQAM, VSB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2131" # Digital tuner for ATSC, QAM, NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Analog tuner PAL, NTSC, SECAM;  Digital tuner for DVB-T, ATSC 1.0 (8-VSB), QAM
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator with TDA8295
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder for analog TV
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1800"($|" ")|"tv-tuner:wintv-hvr-1800-low-profile") ]] ; then
	# Brentwood
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Digital demodulator for ATSC, ClearQAM, VSB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2131" # Digital tuner for ATSC, QAM, NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA827X" # Analog tuner for NTSC, PAL, SECAM, FM radio with TDA8275A
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator with TDA8275A
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder for analog TV
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NTSC FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2200") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10048" # Demodulator for DVB-T, DVB-H
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for PAL, NTSC, SECAM, DVB-T, ATSC, ISDB-T, DMB-T/H
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # A/V decoder for NTSC, PAL, SECAM
	# Missing FM radio model ids for tuner and demodulator
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-PAL NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2205"|"tv-tuner:wintv-hvr-2215") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator for DVB-C/T/T2/T2-Lite
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, QAM, DVB-C/C2/T/T2, ISDB-C/T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-T DVB-T2 NO-PAL PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2250"($|" ")|"tv-tuner:wintv-hvr-2250-rev-c1f1") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24110" # Analog IF demodulator with CX24228-21Z for ATSC, QAM.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for PAL, NTSC, SECAM, DVB, ATSC, ISDB, DTMB
		ot-kernel_y_configopt "CONFIG_DVB_CX24110" # Analog IF demodulator with CX24228-21Z for ATSC, QAM.
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2250"($|" ")|"tv-tuner:wintv-hvr-2250-rev-c2f2") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24110" # Analog IF demodulator with CX24228-21Z for ATSC, QAM.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for PAL, NTSC, SECAM, DVB, ATSC, ISDB, DTMB
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2250"($|" ")|"tv-tuner:wintv-hvr-2250-rev-c3f2") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CX24110" # Analog IF demodulator with CX24228-21Z for ATSC, QAM.
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for PAL, NTSC, SECAM, DVB, ATSC, ISDB, DTMB
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2250"($|" ")|"tv-tuner:wintv-hvr-2250-rev-c4f2") ]] ; then
	# Does not support DVB
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1411" # DTV receiver and demodulator for DVB-T, DVB-H, T-DMB, ISDB-T, MediaFLO, CMMB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuner for PAL, NTSC, SECAM, DVB, ATSC, ISDB, DTMB
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge and analog encoder for MPEG-1/2
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-2255") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3306A" # Digital video demodulator and decoder for ATSC, ClearQAM (QAM-B)
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-T/T2, DVB-C/C2, DTMB, ISDB-T/C, QAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCIe bridge and analog encoder for MPEG-1/2; analog video decoder for NTSC, PAL, SECAM.
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-4400") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2165" # DVB-T/T2, DVB-C demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder, Analog IF demodulator
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-S DVB-S2 NO-DVB-T NO-PAL PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-5525") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller for DVB-S/S2 support
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # DVB-T2/C and DVB-S2 demodulator for digital cable or terrestrial antenna
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_M88RS6000T" # Receiver and demodulator chip for DVB-S/S2/S2X, ISDB-S for satellite
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, QAM, DVB-T2/T/C2/C, DTMB, ISDB-T/C
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge for A/V
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C DVB-S DVB-S2 DVB-T DVB-T2 PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-5500") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_A8293" # LNB controller
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2165" # DVB-T/T2, DVB-C demodulator
		ot-kernel_y_configopt "CONFIG_DVB_TDA10071" # DVB-S/S2 demodulator
		# Possibly has a CX24118A - Missing tuner for DVB-S, DVB-S2
		# Possibly has a CX24501 - Missing driver
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuners for analog TV (PAL/SECAM), DVB-C, DVB-T, FM radio
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge, A/V decoder and analog IF demodulator, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-C NO-DVB-S NO-DVB-S2 DVB-T NO-PAL NO-SECAM NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-quadhd"($|" ")|"tv-tuner:wintv-quadhd-pci"($|" ")|"tv-tuner:wintv-quadhd-atsc-clearqam"|"tv-tuner:wintv-quadhd-pci-astc-clearqam"($|" ")|"tv-tuner:wintv-quadhd-astc-clearqam"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3306A" # ATSC and ClearQAM demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-quadhd"($|" ")|"tv-tuner:wintv-quadhd-pci"($|" ")|"tv-tuner:wintv-quadhd-dvb-t-t2-c"|"tv-tuner:wintv-quadhd-pci-dvb-t-t2-c"|"tv-tuner:wintv-quadhd-dvb-t-t2-c") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and host adapter
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T DVB-T2 DVB-C PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:atv-pex85-isdb"|"tv-tuner:x8502"($|" ")|"tv-tuner:x8507-pci-express-hybrid-card"|"tv-tuner:xtreme-pcie-vi8057") ]] ; then
	# Advantek Networks
	# Geniatech
	# Leadership
	# MyGica
	# Visus
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MB86A20S" # Demodulator for ISDB-T, FM radio tuner, digital radio (ISDB-Tb)
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Tuner for ISDB-T, audio processing, FM radio demodulator
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder, FM radio decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	# It is possible to use a ISDB-T tuner with an ISDB-Tb demodulator to extract ISDB-Tb digital radio.
	# The ISDB-Tb digital radio signal can be used for radio TV channels or for ISDB-Tb car radio receiver.
	#
	# The driver didn't mainline FM radio changes to CX23885 driver yet.
	# The FM radio patch is available, we can possibly add it.
		export _OT_KERNEL_TV_TUNER_TAGS="ISDB-T ?-ISDB-Tb NO-FM PCIe"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-pxdvr3200-h"($|" ")|"tv-tuner:winfast-pxdvr3200-h-p1"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 1
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC4000" # Tuner for NTSC, PAL, SECAM, ASTC, DVB-T, QAM64; analog demodulation
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # Analog video to MPEG2 video encoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-T ?-NTSC ?-PAL ?-SECAM ?-FM PCIe EXPERIMENTAL"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:winfast-pxdvr3200-h"($|" ")|"tv-tuner:winfast-pxdvr3200-h-p1"($|" ")) ]] ; then
	# Leadtek
	# Frontend profile 2
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_ZL10353" # Rebranded demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_RADIO_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DMB-T, DVB-C, DVB-T, ISDB-T with XC3028; analog demodulator for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder, ADC, PCM
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # Analog video to MPEG2 video encoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="?-DVB-T ?-NTSC ?-PAL ?-SECAM ?-FM PCIe EXPERIMENTAL"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_cardbus_by_product_name() {
	# CardBus (1995) with PCI
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:avertv-hybrid+fm-cardbus"($|" ")|"tv-tuner:avertv-hybrid+fm-cardbus-e506r") ]] ; then
	# AVerMedia
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT352" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for DVB-T
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-FM CardBus"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv@nywhere-a/d-nb"($|" ")) ]] ; then
	# MSI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_PLL"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # Demodulator for DVB-T
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA6752HS"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TUNER"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.card=[0-9]+"
		ot-kernel_unset_pat_kconfig_kernel_cmdline "saa7134.tuner=[0-9]+"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.card=94"
		ot-kernel_set_kconfig_kernel_cmdline "saa7134.tuner=67"
		export _OT_KERNEL_TV_TUNER_TAGS="DVB-T NO-PAL CardBus"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_expresscard_by_product_name() {
	# ExpressCard (2003) with PCIe, USB 2.0, USB 3.0
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1500"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ASTC, ClearQAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ATSC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		export _OT_KERNEL_TV_TUNER_TAGS="ATSC-1.0 ClearQAM NO-NTSC ExpressCard"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner() {
	# Only digital supported
	local tags="${1}"

	# ATSC - North America, Carribean, South Korea
	#  - 1.0 - 1995
	#  - 3.0 - 2017
	# 8-VSB - 1996
	# QAM - Digital Cable US & UK
	# DVB - Europe, Africa, Asia, Oceana
	#  -T - Terrestrial antenna; Australia, India, Ireland, England
	#  -T2 - Second version of -T; Malaysia, Indonesia, Iran, Turkey, Ukraine, Middle East, Italy, Netherlands, Spain, Ireland, England, North Korea
	#  -S - Satellite
	#  -S2 - Second version of -S; Turkey; Netherlands
	#  -C - Cable; Netherlands
	# ISDB - Japan, South America, Southeast Asia, Africa, Philippines
	# DTMB - China, Cuba, Comoros, Cambodia, Laos, Pakistan

	# NTSC - US, Canada, Japan, South America
	# PAL - Europe, Australia, Asia, Africa
	#  -M - Brazil
	# SECAM - French, Russia, West Africa

	# The ATSC and DVB TV tuner devices get triaged first.
	# The ebuild only supports TV cards with at least one working standard with either ATSC, DVB-C/T/T2/S/S2, ISDB-T, or FM radio.

	# The NTSC/PAL/SECAM should also be listed for with old VCRs for home videos.

	#
	# Issues for generating TV tuner driver sets
	#
	# 1. Non-intuitive driver selection for the model
	# 2. Hard to find kernel config directions
	# 3. AI hallucinations when reconstructing the proper config
	# 4. AI incomplete driver sets
	# 5. Deleted or merged drivers for components of TV tuner
	# 6. The AI says the component supports the standards but the wiki disagrees about the resultant standard.
	#

	#
	# Workarounds or resolutions for above issues:
	#
	# 1. Explicitly list all supported standards and chips to the AI.
	# 2. Verify selected drivers with IC or chip list on wiki.
	# 3. Put a note or warning that the use case is not supported.
	# 4. Verify 1-to-1 coverage between driver set and components.
	# 5. Verify that it lists a bridge, tuner(s), demodulator(s), decoder(s).
	#
	#    You need at least the bridge, tuner, and the demodulator drivers
	#    for older models without a hardware decoder.
	#
	#    For DVB-S/S2 cards, they need to verify that the LNB controller
	#    driver is installed.
	#
	#    Some devices require fewer drivers if components are integrated.
	#
	#    It may be possible to bypass the decoder chip and do CPU based
	#    decoding if the driver was not implemented for the hardware
	#    decoder.
	#
	#    The order to see a viewable analog image is Tuner > Demodulator > Decoder > Output.
	#    The order to see a viewable digital image is Tuner > Demodulator > Demultiplexer > Decoder > Output.
	#    The order to listen to analog FM radio is Tuner > Demodulator > Decoder > Output.
	#    The order to listen to digital FM radio is Tuner > Demodulator > Output.
	#    The firmware tells which region the card is allowed to operate even though the hardware has capabilities to operate outside the region.
	#
	# 6. Analog support will be disabled if not listed in table.
	#

	# Video decode chip may likely mean both the hardware acceleration of signal decoding of ATSC, DVB and the video codec decoding of H.262, H.264, H.265.
	unset _OT_KERNEL_TV_TUNER_TAGS # It should contain the firmware allowed operation for the model so that code reviewers or device owners know the official capabilities of the device.
	ot-kernel_y_configopt "CONFIG_FW_LOADER"
	ot-kernel_unset_configopt "CONFIG_MEDIA_SUPPORT_FILTER"
	if [[ "${tags}" =~ "usb-1.1"($|" ") ]] ; then
	# USB 1.1 (1998)
		ot-kernel-driver-bundle_add_tv_tuner_usb_1_1_by_product_name
	fi
	if [[ "${tags}" =~ "usb-2.0"($|" ") ]] ; then
	# USB 2.0 (2000)
		ot-kernel-driver-bundle_add_tv_tuner_usb_2_0_by_product_name
	fi
	if [[ "${tags}" =~ "usb-3.0"($|" ") ]] ; then
	# USB 3.0 (2008)
		ot-kernel-driver-bundle_add_tv_tuner_usb_3_0_by_product_name
	fi
	if [[ "${tags}" =~ "pci"($|" ") ]] ; then
	# PCI (1992)
		ot-kernel-driver-bundle_add_tv_tuner_pci_by_product_name
	fi
	if [[ "${tags}" =~ "pcie"($|" ") ]] ; then
	# PCIe (2003)
		ot-kernel-driver-bundle_add_tv_tuner_pcie_by_product_name
	fi
	if [[ "${tags}" =~ "cardbus"($|" ") ]] ; then
	# CardBus (1995)
		ot-kernel-driver-bundle_add_tv_tuner_cardbus_by_product_name
	fi
	if [[ "${tags}" =~ "expresscard"($|" ") ]] ; then
	# ExpressCard (2003)
		ot-kernel-driver-bundle_add_tv_tuner_expresscard_by_product_name
	fi

	if grep -q -E -e "^CONFIG_RC_CORE=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_IR_MCE_KBD_DECODER"
		ot-kernel_y_configopt "CONFIG_IR_NEC_DECODER"
		ot-kernel_y_configopt "CONFIG_IR_RC5_DECODER"
		ot-kernel_y_configopt "CONFIG_LIRC"
		ot-kernel_y_configopt "CONFIG_RC_DECODERS"
	fi

	# The snd-aw2 and saa7146 driver conflict was resolved in 2009.

	# It's like software modems but with TV tuners.
	if [[ -n "${_OT_KERNEL_TV_TUNER_TAGS}" ]] ; then
	#
	# But can the CPU keep up?
	#
	# There are several opinions on the question.
	# One LLM says no only CPU can be used for digital video decoding.  It is possible that the LLM and the same company who happens to create video codecs is biased.
	# Another LLM says yes you can do video decoding with VAAPI implying GPU accelerated decoding.
	#
	# I personally think it is possible that you can use GPU acceleration and the LLM is possibly biased.
	# The other issue to be aware of is the patent tax or fee.  The reason why some companies may
	# not want to pay for the chip is because of royalties for the newer codecs.
	#

	# Analog signal decode is offloaded on the CPU for some TV cards.

	# Flags to display codec status
		local codec_aac=0 # Active patents
		local codec_ac3=0 # Expired patents
		local codec_ac4=0 # Active patents
		local codec_eac3=0 # Active patents
		local codec_h262=0 # Expired patents
		local codec_h264=0 # Active patents
		local codec_h264_optional="" # Active patents
		local codec_h265=0 # Active patents
		local codec_h265_optional="" # Active patents
		local codec_he_aacv2=0 # Active patents
		local codec_mp2=0 # Expired patents
		local codec_mpeg_h=0 # Active patents
		local codec_vvc_optional=0 # Active patents

		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("NTSC") ]] ; then
ewarn "You may need a >= 2000 CPU for software based NTSC decoding for sustained 30 FPS."
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("PAL") ]] ; then
ewarn "You may need a >= 2000 CPU for software based PAL decoding for sustained 30 FPS."
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("SECAM") ]] ; then
ewarn "You may need a >= 2000 CPU for software based SECAM decoding for sustained 30 FPS."
		fi

	# Some TV tuner cards offload both the signal decoding and video codec decoding on the CPU.
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ "ATSC-1.0" ]] ; then
			codec_ac3=1
			codec_h262=1
			codec_h264_optional=" (optional)"
			codec_h265_optional=" (optional)"
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ "ATSC-3.0" ]] ; then
			codec_ac4=1
			codec_eac3=1
			codec_h265=1
			codec_mpeg_h=1
			codec_vvc_optional=" (optional)"
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("QAM"($|" ")|"ClearQAM") ]] ; then
			codec_ac3=1
			codec_h262=1
			codec_h264=1
		fi

		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-T"($|" ")) ]] ; then
			codec_h262=1
			codec_mp2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-T2"($|" ")) ]] ; then
			codec_aac=1
			codec_h264=1
			codec_eac3=1
			codec_he_aacv2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-C"($|" ")) ]] ; then
			codec_aac=1
			codec_eac3=1
			codec_h262=1
			codec_h264=1
			codec_mp2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-C2"($|" ")) ]] ; then
			codec_eac3=1
			codec_h265=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-S"($|" ")) ]] ; then
			codec_eac3=1
			codec_h262=1
			codec_mp2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-S2"($|" ")) ]] ; then
			codec_aac=1
			codec_eac3=1
			codec_h264=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-S2X"($|" ")) ]] ; then
			codec_h265=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("ISDB-T"($|" ")) ]] ; then
			codec_h262=1
			codec_h264=1
			codec_h265=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("ISDB-Tb"($|" ")) ]] ; then
			codec_aac=1
			codec_h264=1
			codec_he_aacv2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("ISDB-S"($|" ")) ]] ; then
			codec_aac=1
			codec_h262=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DMB-T"($|" ")) ]] ; then
			codec_h262=1
			codec_h264=1
			codec_h265=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DAB"($|" ")) ]] ; then
			codec_mp2=1
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DAB+"($|" ")) ]] ; then
			codec_he_aacv2=1
		fi

	# Some TV tuner cards offload the video codec decoding to the CPU but hardware accelerate the signal decoding.

		if (( ${codec_h262} == 1 )) ; then
ewarn "You may need a 2006 or later multicore CPU for CPU based H.262 (MPEG-2) decoding for sustained 30 FPS."
		fi
		if (( ${codec_h264} == 1 )) || [[ -n "${codec_h264_optional}" ]] ; then
ewarn "You may need a 2007 or later multicore CPU for CPU based H.264 (AVC) decoding for sustained 30 FPS.${codec_h264_optional}"
		fi
		if (( ${codec_h265} == 1 )) || [[ -n "${codec_h265_optional}" ]] ; then
ewarn "You may need a 2016 or later CPU for CPU based H.265 (HVEC) decoding for sustained 30 FPS.${codec_h265_optional}"
		fi
		if (( ${codec_vvc} == 1 )) || [[ -n "${codec_vvc_optional}" ]] ; then
ewarn "You may need a 2021 or later CPU for CPU based VVC decoding for sustained 30 FPS.${codec_vvc_optional}"
		fi

einfo "Alternatively, consider using the GPU accelerated decoding with AMF, CUVID, NVDEC, QSV, VAAPI, VDPAU, or Vulkan to for the TV tuner."

einfo "Be aware that some TV cards may offload patented codecs to GPU or CPU."
einfo "The patent status for codecs used in digital TV standards:"
		if (( ${codec_aac} == 1 )) ; then
ewarn "AAC - active"
		fi
		if (( ${codec_ac3} == 1 )) ; then
ewarn "AC-3 - expired"
		fi
		if (( ${codec_ac4} == 1 )) ; then
ewarn "AC-4 - active"
		fi
		if (( ${codec_eac3} == 1 )) ; then
ewarn "E-AC-3 - active"
		fi
		if (( ${codec_h262} == 1 )) ; then
ewarn "H.262 - expired"
		fi
		if (( ${codec_h264} == 1 )) || [[ -n "${codec_h264_optional}" ]] ; then
ewarn "H.264 - active"
		fi
		if (( ${codec_h265} == 1 )) || [[ -n "${codec_h265_optional}" ]] ; then
ewarn "H.265 - active"
		fi
		if (( ${codec_he_aacv2} == 1 )) ; then
ewarn "HE-AAC v2 - active"
		fi
		if (( ${codec_mp2} == 1 )) ; then
ewarn "MP2 audio - expired"
		fi
		if (( ${codec_mpeg_h} == 1 )) ; then
ewarn "MPEG-H - active"
		fi
		if (( ${codec_vvc} == 1 )) || [[ -n "${codec_vvc_optional}" ]] ; then
ewarn "VVC - active"
		fi

einfo "TV tuner tags:  ${_OT_KERNEL_TV_TUNER_TAGS}"
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ "NO-" ]] ; then
einfo "NO- means that support is broken because either missing/broken driver or missing chip model information."
		fi
		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ "?-" ]] ; then
einfo "?- means that support is unverified or is based on low confidence/veracity or hypothesized chip model information."
		fi

		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ "EXPERIMENTAL" ]] ; then
einfo "EXPERIMENTAL means that the TV card's driver shows signs that it is operational but not considered production grade."
		fi

		if [[ "${_OT_KERNEL_TV_TUNER_TAGS}" =~ ("DVB-S"|"ISDB-S"|"QAM") ]] ; then
ewarn
ewarn "For satellite based TV tuners, only one LNB controller should be used to"
ewarn "avoid conflicts."
ewarn
ewarn "This means to disconnect the TV tuner(s) or living room satellite receiver,"
ewarn "or adding a new device to manage the LNB conflict, configure the software"
ewarn "to turn off LNB power for the TV tuner card."
ewarn
ewarn "Consequences could include pixelization, freezing, loss of signal, or"
ewarn "equipment damage."
ewarn
ewarn "For help ask the AI or the satellite company or both to resolve LNB"
ewarn "conflicts or issues."
ewarn
		fi
	fi
}

has_mei_packages() {
	# Missing:  MeshCommander
	if has_version "app-admin/coreboot-utils" ; then
	# Status checker.  Needs ssh to obtain MEI status.
		return 0
	fi
	if has_version "app-admin/mei-amt-check" ; then
	# ME removal, can brick device
		return 0
	fi
	if has_version "dev-libs/metee" ; then
	# Status checker
		return 0
	fi
	if has_version "sys-apps/me_cleaner" ; then
	# Status checker, library only
		return 0
	fi
	return 1
}

# Enable robost fallback for overheating to prevent damage in an infinite loop.
# If the CPU glitches or malfunctions when overheating, then reboot to mitigate
# damage.  If the sensor is damaged, misconfigured, not calibrated, or not
# detected, then use the hardware watchdog as a fallback.
ot-kernel-driver-bundle_add_watchdog() {
	local tags="${1}"
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_WATCHDOG"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_CORE"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_NOWAYOUT"
	if [[ "${tags}" =~ "late-1990" ]] ; then
		ot-kernel_y_configopt "CONFIG_ALIM1535_WDT" # 1998
		ot-kernel_y_configopt "CONFIG_ALIM7101_WDT" # 1998
		ot-kernel_y_configopt "CONFIG_W83877F_WDT" # 1996
		ot-kernel_y_configopt "CONFIG_W83977F_WDT" # 1997
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_ITCO_WDT" # 1999-2000
		fi
	elif [[ "${tags}" =~ "early-2000" ]] ; then
		ot-kernel_y_configopt "CONFIG_IT87_WDT" # 2003
		ot-kernel_y_configopt "CONFIG_IT8712F_WDT" # 2000
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_ITCO_WDT" # 1999-2000
		fi
	elif [[ "${tags}" =~ "late-2000" ]] ; then
		ot-kernel_y_configopt "CONFIG_F71808E_WDT" # Late 2000s, 2010
		ot-kernel_y_configopt "CONFIG_IT87_WDT" # 2003
		ot-kernel_y_configopt "CONFIG_IT8712F_WDT" # 2000, specifically this model
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_SP5100_TCO" # 2009
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_ITCO_WDT" # 1999-2000
			ot-kernel_y_configopt "CONFIG_NV_TCO" # 2006
		fi
	elif [[ "${tags}" =~ "2010" ]] ; then
		ot-kernel_y_configopt "CONFIG_F71808E_WDT" # Late 2000s, 2010
		ot-kernel_y_configopt "CONFIG_IT87_WDT" # 2003
		ot-kernel_y_configopt "CONFIG_WDAT_WDT" # 2014
		if [[ $(ot-kernel_get_cpu_mfg_id) == "amd" ]] ; then
			ot-kernel_y_configopt "CONFIG_SP5100_TCO" # 2009
		fi
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_ITCO_WDT" # 1999-2000
		fi
	elif [[ "${tags}" =~ "2020" ]] ; then
		ot-kernel_y_configopt "CONFIG_WDAT_WDT" # 2014
		if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
			ot-kernel_y_configopt "CONFIG_ITCO_WDT" # 1999-2000
		fi
	fi

	if [[ "${tags}" =~ "mei" ]] ; then
		if has_mei_packages ; then
		# Can report but not necessarily restart.
			ot-kernel_y_configopt "CONFIG_INTEL_MEI_WDT"
		else
			ot-kernel_unset_configopt "CONFIG_INTEL_MEI_WDT"
		fi
	else
		ot-kernel_unset_configopt "CONFIG_INTEL_MEI_WDT"
	fi
}

ot-kernel-driver-bundle_add_hdcp_support() {
	local tags="${1}"
	# MEI is used for enterprise IT remote troubleshooting on laptops and workstations.
	# MEI is a big security risk with vulnerability impact vectors of CE, DoS, DT, ID, PE.
	# ME has an independent OS and doesn't depend on the user's operating system, so it cannot be easily disabled just by disabling kernel support.
	if grep -q -E -e "^CONFIG_DRM_I915=y" "${path_config}" || grep -q -E -e "^CONFIG_DRM_XE=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_INTEL_MEI" # Basic support
		ot-kernel_y_configopt "CONFIG_INTEL_MEI_ME" # Advanced features
		ot-kernel_y_configopt "CONFIG_INTEL_MEI_HDCP" # Allow HDCP 2.2 service compatibility that typically disallow 4K on Linux.
		ot-kernel_y_configopt "CONFIG_PCI"
	# We would like to completely disable the HDCP DRM, but we don't disable
	# because other features below depend on the above symbols:
	# - Anti-Theft feature (for disabling or tracking)
	# - Blue-ray protection
	# - Power management
	# - Remote management and repair
	# - TPM, PTT, disk encryption, key storage
	fi

	if grep -q -E -e "^CONFIG_DRM_AMDGPU=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_DRM_AMD_DC"
		if grep -q -E -e "^CONFIG_DRM_AMDGPU_SI=y" "${path_config}" ; then
			ot-kernel_y_configopt "CONFIG_DRM_AMD_DC_SI"
		fi
ewarn "For HDCP support on AMDGPU:  \`xrandr --output <OUTPUT_NAME> --set \"Content Protection\" \"Enabled\"\` replacing <OUTPUT_NAME> with either DP-1 or HDMI-1."
	# We would like to completely disable HDCP DRM, but we don't disable
	# because other features below depend on the above symbols:
	# - Color management
	# - DisplayPort support
	# - FreeSync or tear-free support
	# - HDMI support
	# - HDR
	# - Multi-monitor
	# - Power management
	# - Wide color gamut
	fi

	if ! grep -q -E -e "^CONFIG_DRM_AMDGPU=y" "${path_config}" && [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:gcn1"($|" ")|"graphics:southern-islands"($|" ")) ]] ; then
ewarn "You are using the radeon driver which doesn't support HDCP."
ewarn "Consider switching to the amdgpu driver for HDCP support."
ewarn "For HDCP, use graphics:gcn1-experimental or graphics:southern-islands-experimental instead."
	fi

	if ! grep -q -E -e "^CONFIG_DRM_AMDGPU=y" "${path_config}" && [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:gcn2"($|" ")|"graphics:sea-islands"($|" ")) ]] ; then
ewarn "You are using the radeon driver which doesn't support HDCP."
ewarn "Consider switching to the amdgpu driver for HDCP support."
ewarn "For HDCP, use graphics:gcn2-experimental or graphics:sea-islands-experimental instead."
	fi

	if grep -q -E -e "^CONFIG_DRM_NOUVEAU=y" "${path_config}" ; then
ewarn "You are using the nouveau driver which doesn't support HDCP."
ewarn "Consider switching to the closed source driver for HDCP support."
ewarn "For HDCP, use graphics:nvidia-drm or graphics:nvidia-drivers instead."
	fi
}

# Only desktop motherboards supported.
# For laptops or smartphone, use custom hook to reduce memory usage.
ot-kernel-driver-bundle_add_sound() {
	local tags="${1}"

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SOUND"
	fi
	if [[ "${tags}" =~ "isa"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ISA" # 1981
	fi
	if [[ "${tags}" =~ "pci" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_PCI"
	fi

	if [[ "${tags}" =~ ("early-2000"|"late-2000"|"2010"|"2020") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA"
	fi

	ot-kernel-driver-bundle_add_sound_by_decade
	ot-kernel-driver-bundle_add_sound_by_vendor_name
	ot-kernel-driver-bundle_add_sound_by_module_name
	ot-kernel-driver-bundle_add_sound_by_product_name

	if \
		   grep -q -E -e "^CONFIG_SND_HDA_CODEC_REALTEK=(m|y)" "${path_config}" \
	; then
		ot-kernel_y_configopt "CONFIG_INPUT"
	fi

	if \
		   grep -q -E -e "^CONFIG_SND_EMU10K1=(m|y)" "${path_config}" \
		|| grep -q -E -e "^CONFIG_SND_ALI5451=(m|y)" "${path_config}" \
	; then
		ot-kernel_y_configopt "CONFIG_ZONE_DMA"
	fi

	if \
		   grep -q -E -e "^CONFIG_SND_AZT2320=(m|y)" "${path_config}" \
		|| grep -q -E -e "^CONFIG_SND_AZT3328=(m|y)" "${path_config}" \
		|| grep -q -E -e "^CONFIG_SND_INTERWAVE_STB=(m|y)" "${path_config}" \
		|| grep -q -E -e "^CONFIG_SND_INTERWAVE=(m|y)" "${path_config}" \
	; then
		ot-kernel_y_configopt "CONFIG_PNP" # 1995
	fi
}

ot-kernel-driver-bundle_add_sound_by_decade() {
	if [[ "${tags}" =~ "early-1990" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1990s"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
		ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
		ot-kernel_y_configopt "CONFIG_SND_CS4231" #
		ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	fi
	if [[ "${tags}" =~ "late-1990" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1990s"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
		ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
		ot-kernel_y_configopt "CONFIG_SND_AZT2316" # 1995
		ot-kernel_y_configopt "CONFIG_SND_AZT2320" # 1997/1998
		ot-kernel_y_configopt "CONFIG_SND_AZT3328" # 1997
		ot-kernel_y_configopt "CONFIG_SND_CS4231" #
		ot-kernel_y_configopt "CONFIG_SND_CS4236" # 1996
		ot-kernel_y_configopt "CONFIG_SND_CS46XX" # 1998
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
		ot-kernel_y_configopt "CONFIG_SND_ENS1370" # 1997
		ot-kernel_y_configopt "CONFIG_SND_ENS1371" # 1997
		ot-kernel_y_configopt "CONFIG_SND_FM801" # 1998
		ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
		ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
		ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
		ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
		ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	fi
	if [[ "${tags}" =~ "early-1990" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1990s-musician"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSCLASSIC" # 1992
		ot-kernel_y_configopt "CONFIG_SND_MSND_CLASSIC" # 1991
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_SSCAPE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_WAVEFRONT" # 1993
	fi
	if [[ "${tags}" =~ "late-1990" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:1990s-musician"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSCLASSIC" # 1992
		ot-kernel_y_configopt "CONFIG_SND_GUSMAX" # 1997
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE" # 1995
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
		ot-kernel_y_configopt "CONFIG_SND_ENS1370" # 1997
		ot-kernel_y_configopt "CONFIG_SND_ENS1371" # 1997
		ot-kernel_y_configopt "CONFIG_SND_KORG1212" # 1997
		ot-kernel_y_configopt "CONFIG_SND_MSND_CLASSIC" # 1991
		ot-kernel_y_configopt "CONFIG_SND_MSND_PINNACLE" # 1997
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_SSCAPE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
		ot-kernel_y_configopt "CONFIG_SND_WAVEFRONT" # 1993
	fi
	if [[ "${tags}" =~ "early-2000" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2000s" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
		ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"

		ot-kernel_y_configopt "CONFIG_SND_CS4281" # 2001
		ot-kernel_y_configopt "CONFIG_SND_ALI5451" # 2001
		ot-kernel_y_configopt "CONFIG_SND_ATIIXP" # 2003
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
		ot-kernel_y_configopt "CONFIG_SND_FM801" # 1998
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	fi
	if [[ "${tags}" =~ "late-2000" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2000s" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
		ot-kernel_y_configopt "CONFIG_SND_CA0106" # 2004
		ot-kernel_y_configopt "CONFIG_SND_CTXFI" # 2005
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1X" # 2003
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
		ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008

		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_ANALOG" # 2005
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CMEDIA" # 2008
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA" # 2006, 2009, 2011
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
		ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
	fi
	if [[ "${tags}" =~ "2010" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2010s" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_ANALOG" # 2005
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CIRRUS" # 2013
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA" # 2006, 2009, 2011
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	fi
	if [[ "${tags}" =~ "2020" && "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:2020s" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	fi
	ot-kernel-driver-bundle_add_midi_playback_support
}

ot-kernel-driver-bundle_add_sound_by_vendor_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:adlib" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ali" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ALI5451" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:aureal" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:amd" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:analog-devices" ]] ; then
		if [[ "${tags}" =~ ("late-2009"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_ANALOG" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:asus" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CMEDIA" # 2008
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ati" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ATIIXP" # 2003
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:aztech" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
		ot-kernel_y_configopt "CONFIG_SND_AZT2316" # 1995
		ot-kernel_y_configopt "CONFIG_SND_AZT2320" # 1997/1998
		ot-kernel_y_configopt "CONFIG_SND_AZT3328" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:c-media" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cirrus-logic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4231" #
		ot-kernel_y_configopt "CONFIG_SND_CS4236" # 1996
		ot-kernel_y_configopt "CONFIG_SND_CS4281" # 2001
		ot-kernel_y_configopt "CONFIG_SND_CS46XX" # 1998
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CIRRUS" # 2013
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CS8409" # 2016
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cmedia" ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CMEDIA" # 2008
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:creative" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CTXFI" # 2005
		ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
		if [[ "${tags}" =~ ("late-2000") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
		if [[ "${tags}" =~ ("2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:e-mu" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:dell" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1X" # 2003
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CIRRUS" # 2013
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CS8409" # 2016
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:dynasonic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ensoniq" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ENS1370" # 1997
		ot-kernel_y_configopt "CONFIG_SND_ENS1371" # 1997
		ot-kernel_y_configopt "CONFIG_SND_SSCAPE" # 1994
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ess" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:gravis" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSCLASSIC" # 1992
		ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
		ot-kernel_y_configopt "CONFIG_SND_GUSMAX" # 1997
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hp" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:idt"|"sound:integrated-device-technology"|"sound:sigmatel") ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:ali"|"sound:amd"|"sound:intel"|"sound:nvidia"|"sound:sis") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:intel" ]] ; then
		if [[ "${tags}" =~ ("early-2000"|"late-2000"|"2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:korg" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_KORG1212" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:panasonic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:lenovo" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:realtek" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA"
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
		ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:s3" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sis" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:trident" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:turtle-beach" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MSND_CLASSIC" # 1991
		ot-kernel_y_configopt "CONFIG_SND_MSND_PINNACLE" # 1997
		ot-kernel_y_configopt "CONFIG_SND_WAVEFRONT" # 1993
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:via" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA" # 2006, 2009, 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:yamaha" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
		ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	fi

	if grep -q -E -e "^CONFIG_SND_HDA=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
	fi
}

ot-kernel-driver-bundle_add_sound_by_module_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:adlib" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ali5451" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ALI5451" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:au8820" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:au8830" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:atiixp" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ATIIXP" # 2003
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt1605" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt2316" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT2316" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt2320" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT2320" # 1997/1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt3328" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT3328" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cs4231" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4231" #
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cs4236" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4236" # 1996
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cs4281" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4281" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cs46xx" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS46XX" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ctxfi" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CTXFI" # 2005
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:emu10k1" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:emu10k1x" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1X" # 2003
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ens1370" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ENS1370" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ens1371" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ENS1371" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:gusclassic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSCLASSIC" # 1992
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:gusextreme" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:gusmax" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSMAX" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-analog" ]] ; then
		if [[ "${tags}" =~ ("late-2009"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_ANALOG" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-cirrus" ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CIRRUS" # 2013
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-ca0110" ]] ; then
		if [[ "${tags}" =~ ("late-2000") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-ca0132" ]] ; then
		if [[ "${tags}" =~ ("2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-cmedia" ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CMEDIA" # 2008
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-conexant" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-cs8409" ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CS8409" # 2016
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-realtek" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA"
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
		ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-sigmatel" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-codec-via" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA" # 2006, 2009, 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:hda-intel" ]] ; then
		if [[ "${tags}" =~ ("early-2000"|"late-2000"|"2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:interwave-stb" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:intel8x0" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:interwave-stb" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:korg1212" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_KORG1212" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:maestro3" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:msnd-classic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MSND_CLASSIC" # 1991
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:msnd-pinnacle" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MSND_PINNACLE" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:opl3sa2" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sb8" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sb16" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sbawe" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sonicvibes" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sscape" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SSCAPE" # 1994
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:trident" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:wavefront" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_WAVEFRONT" # 1993
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:virtuoso" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:via82xx" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ymfpci" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	fi

	if grep -q -E -e "^CONFIG_SND_HDA=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
	fi
}

ot-kernel-driver-bundle_add_sound_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:02-cardbus"|\
"sound:0404"|\
"sound:0404-pcie"|\
"sound:0404b-pci"|\
"sound:1010"|\
"sound:1010-pcie"|\
"sound:1010b-pci"|\
"sound:1212"|\
"sound:1616"|\
"sound:1820"|\
"sound:aps"|\
"sound:audio-production-studio"|\
"sound:sound-blaster-audigy"|\
"sound:sound-blaster-audigy-1"|\
"sound:sound-blaster-audigy-1-es"|\
"sound:sound-blaster-audigy-2"|\
"sound:sound-blaster-audigy-2-platinum"|\
"sound:sound-blaster-audigy-2-platinum-ex"|\
"sound:sound-blaster-audigy-2-value"|\
"sound:sound-blaster-audigy-2-zs"|\
"sound:sound-blaster-audigy-2-zs-notebook"|\
"sound:sound-blaster-audigy-4"|\
"sound:sound-blaster-audigy-4-pro"|\
"sound:sound-blaster-audigy-5"|\
"sound:sound-blaster-audigy-rx"|\
"sound:sound-blaster-live"|\
"sound:sound-blaster-live-5.1"|\
"sound:sound-blaster-live-5.1-dell-oem"|
"sound:sound-blaster-live-value"|\
"sound:sound-blaster-pci-512"|\
) ]] ; then
	# See also the sound:sound-blaster-live-dell-oem
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:440mx"|\
"sound:6300esb"|\
"sound:8x0"|\
"sound:82801aa"|\
"sound:82801aa-ich"|\
"sound:82901ab"|\
"sound:82901ab-ich0"|\
"sound:82801ba"|\
"sound:82801ba-ich2"|\
"sound:82801ca"|\
"sound:82801ca-ich3"|\
"sound:82801db"|\
"sound:82801db-ich4"|\
"sound:amd768"|\
"sound:amd8111"|\
"sound:ck8"|\
"sound:ck8s"|\
"sound:ck804"|\
"sound:ich5"|\
"sound:ich6"|\
"sound:ich7"|\
"sound:esb2"|\
"sound:m5455"|\
"sound:mcp1"|\
"sound:mcp2"|\
"sound:mcp3"|\
"sound:mcp04"|\
"sound:nforce"|\
"sound:nforce2"|\
"sound:nforce3"|\
"sound:si7012"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999, 2000, 2001, 2002, 2004, 2005, 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:7018"|\
"sound:4d-wave"|\
"sound:4d-wave-dx"|\
"sound:4d-wave-nx"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:1212io") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_KORG1212" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ad1986a" ]] ; then
		if [[ "${tags}" =~ ("late-2009"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_ANALOG" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:allegro"|"sound:canyon3d-2"|"sound:maestro3") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:au8820"|"sound:vortex"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:au8830"|"sound:vortex-2"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:audiopci"|"sound:audiopci-1370") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ENS1370" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:audiopci"|\
"sound:audiopci-1371"|\
"sound:audiopci-1373"\
	) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ENS1371" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:azalia"|\
"sound:hda"|\
"sound:high-definition-audio"\
	) ]] ; then
		if [[ "${tags}" =~ ("early-2000"|"late-2000"|"2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt1605" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt2316" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT2316" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt2320" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT2320" # 1997/1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:azt3328" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_AZT3328" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:cirrus-logic-hda-codec"|\
"sound:cs4203"|\
"sound:cs4206"|\
"sound:cs4208"|\
"sound:cs4210"|\
"sound:cs4213"\
) ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CIRRUS" # 2013
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:cs4231" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4231" #
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:cs4232"|\
"sound:cs4236"|\
"sound:cs4236+"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4236" # 1996
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:cs4281"|\
"sound:sound-fusion"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS4281" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:sound-fusion"|\
"sound:cs4280"|\
"sound:cs46xx"|\
"sound:cs461x"|\
"sound:cs462x"|\
"sound:cs463x"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CS46XX" # 1998
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:cirrus-logic-hda-bridge"|\
"sound:cs8409"|\
"sound:cs4206"|\
"sound:cs4207"|\
"sound:cs4208"|\
"sound:cs4210"|\
"sound:cs4213"|\
"sound:cs42l42"\
) ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CS8409" # 2016
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:ca0110-ibg"|"sound:sb0880"|"sound:sb0880-x-fi") ]] ; then
		if [[ "${tags}" =~ ("late-2000") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ca0132" ]] ; then
		if [[ "${tags}" =~ ("2010"|"2020") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:sound-blaster-live-dell-oem"|"sound:dell-sound-blaster-live") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_EMU10K1X" # 2003
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:conexant-hd-audio"|\
"sound:cx8070"|\
"sound:cx8200"|\
"sound:cx11970"|\
"sound:cx20549"|\
"sound:cx20551"|\
"sound:cx20561"|\
"sound:cx20582"|\
"sound:cx20583"|\
"sound:cx20584"|\
"sound:cx20585"|\
"sound:cx20588"|\
"sound:cx20590"|\
"sound:cx20631"|\
"sound:cx20632"|\
"sound:cx20641"|\
"sound:cx20642"|\
"sound:cx20651"|\
"sound:cx20652"|\
"sound:cx20664"|\
"sound:cx20665"|\
"sound:cx20722"|\
"sound:cx20724"|\
"sound:cx20751"|\
"sound:cx20752"|\
"sound:cx20751"|\
"sound:cx20752"|\
"sound:cx20753"|\
"sound:cx20754"|\
"sound:cx20755"|\
"sound:cx20756"|\
"sound:cx20757"|\
"sound:cx20952"|\
"sound:cx21722"|\
"sound:cx21724"|\
"sound:sn6140"|\
"sound:sn6180"\
) ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:cm9825"|\
"sound:cmedia-hd-audio"\
"sound:cmi8888"|\
"sound:cmi9880"|\
) ]] ; then
		if [[ "${tags}" =~ ("2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CMEDIA" # 2008
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:fm-card" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:fuji"|"sound:pinnacle") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MSND_PINNACLE" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:92hd206d"|\
"sound:92hd206x"|\
"sound:92hd66b1x3"|\
"sound:92hd66b1x5"|\
"sound:92hd66b2x3"|\
"sound:92hd66b2x5"|\
"sound:92hd66b3x3"|\
"sound:92hd66b3x5"|\
"sound:92hd66c1x3"|\
"sound:92hd66c1x5"|\
"sound:92hd66c2x3"|\
"sound:92hd66c2x5"|\
"sound:92hd66c3"|\
"sound:92hd66c365"|\
"sound:92hd66c3x5"|\
"sound:92hd71b5x"|\
"sound:92hd71b6x"|\
"sound:92hd71b7x"|\
"sound:92hd71b8x"|\
"sound:92hd73d1x5"|\
"sound:92hd73c1x5"|\
"sound:92hd73e1x5"|\
"sound:92hd75b2x5"|\
"sound:92hd75b3x5"|\
"sound:92hd83c1x5"|\
"sound:92hd83c1c5"|\
"sound:92hd81b1x5"|\
"sound:92hd81b1c5"|\
"sound:92hd87b1"|\
"sound:92hd87b3"|\
"sound:92hd87b2"|\
"sound:92hd87b4"|\
"sound:92hd88b3"|\
"sound:92hd88b1"|\
"sound:92hd88b2"|\
"sound:92hd88b4"|\
"sound:92hd95"|\
"sound:92hd89b1"|\
"sound:92hd89b2"|\
"sound:92hd89b3"|\
"sound:92hd89c1"|\
"sound:92hd89c2"|\
"sound:92hd89c3"|\
"sound:92hd89d1"|\
"sound:92hd89d2"|\
"sound:92hd89d3"|\
"sound:92hd89e1"|\
"sound:92hd89e2"|\
"sound:92hd89e3"|\
"sound:92hd89f3"|\
"sound:92hd89f2"|\
"sound:92hd89f1"|\
"sound:92hd90bxx"|\
"sound:92hd91bxx"|\
"sound:92hd93bxx"|\
"sound:92hd98bxx"|\
"sound:92hd99bxx"|\
"sound:cxd9872rd"|\
"sound:cxd9872rk"|\
"sound:cxd9872akd"|\
"sound:stac9200"|\
"sound:stac9202"|\
"sound:stac9202d"|\
"sound:stac9204"|\
"sound:stac9204d"|\
"sound:stac9205"|\
"sound:stac9205d"|\
"sound:stac9220"|\
"sound:stac9220d"|\
"sound:stac9221"|\
"sound:stac9221d"|\
"sound:stac9223d"|\
"sound:stac9227"|\
"sound:stac9228"|\
"sound:stac9229"|\
"sound:stac9250"|\
"sound:stac9250d"|\
"sound:stac9251"|\
"sound:stac9254"|\
"sound:stac9254d"\
"sound:stac9255"|\
"sound:stac9255d"|\
"sound:stac9271d"|\
"sound:stac9271x"|\
"sound:stac9272d"|\
"sound:stac9272x"|\
"sound:stac9273d"|\
"sound:stac9273x"|\
"sound:stac9274"|\
"sound:stac9274d"|\
"sound:stac9274d5nh"|\
"sound:stac9274x5nh"|\
"sound:stac92hd700"|\
"sound:stac9872ak"|\
) ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
			ot-kernel_y_configopt "CONFIG_SND_PCI"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:interwave-stb"|\
"sound:med3210"|\
"sound:pca761aw"|\
"sound:ultrasound-plug-and-play"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:ixp"|\
"sound:ixp-150"|\
"sound:ixp-200"|\
"sound:ixp-250"|\
"sound:ixp-300"|\
"sound:ixp-400"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ATIIXP" # 2003
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:lenovo" ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CONEXANT" # 2007
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:m5451" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_ALI5451" # 2001
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:maui"|\
"sound:tropez"|\
"sound:tropez+"|\
"sound:wavefront") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_WAVEFRONT" # 1993
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:multisound-classic"|\
"sound:monterey"|\
"sound:tahiti"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_MSND_CLASSIC" # 1991
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:realtek-hd-audio"|\
"alc215"|\
"alc221"|\
"alc222"|\
"alc225"|\
"alc236"|\
"alc231"|\
"alc233"|\
"alc234"|\
"alc236"|\
"alc245"|\
"alc255"|\
"alc256"|\
"alc257"|\
"alc260"|\
"alc262"|\
"alc267"|\
"alc268"|\
"alc269"|\
"alc270"|\
"alc272"|\
"alc274"|\
"alc275"|\
"alc276"|\
"alc280"|\
"alc282"|\
"alc283"|\
"alc284"|\
"alc285"|\
"alc286"|\
"alc287"|\
"alc288"|\
"alc289"|\
"alc290"|\
"alc292"|\
"alc293"|\
"alc294"|\
"alc295"|\
"alc298"|\
"alc299"|\
"alc300"|\
"alc623"|\
"alc660"|\
"alc660-vd"|\
"alc662"|\
"alc662"|\
"alc663"|\
"alc665"|\
"alc667"|\
"alc668"|\
"alc670"|\
"alc671"|\
"alc680"|\
"alc700"|\
"alc701"|\
"alc703"|\
"alc711"|\
"alc861"|\
"alc861-vd"|\
"alc880"|\
"alc882"|\
"alc883"|\
"alc885"|\
"alc887"|\
"alc888"|\
"alc889"|\
"alc889a"|\
"alc891"|\
"alc892"|\
"alc897"|\
"alc898"|\
"alc1150"|\
"alc1200"|\
"alc1220"|\
"alcs1200a"|\
"hw8326"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA"
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004, 2005, 2006, 2008, 2009, 2011, 2013, 2014, 2015, 2017, 2018, 2024
		ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
		ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		ot-kernel_y_configopt "CONFIG_SND_PCI"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sonicvibes" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:sound-blaster-1.0"|\
"sound:sound-blaster-2.0"|\
"sound:sound-blaster-pro"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:sound-blaster-16"|\
"sound:sound-blaster-16-pnp"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:sound-blaster-awe"|\
"sound:sound-blaster-awe-pnp"|\
"sound:sound-blaster-awe-32"|\
"sound:sound-blaster-awe-64"|\
"sound:sound-blaster-awe-32-pnp"|\
"sound:sound-blaster-awe-64-pnp"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:sound-blaster-x-fi" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_CTXFI" # 2005
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:soundscape" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_SSCAPE" # 1994
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ultrasound-classic" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSCLASSIC" # 1992
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ultrasound-extreme" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "sound:ultrasound-max" ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_GUSMAX" # 1997
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:via82xx"|\
"sound:via8233"|\
"sound:via8235"\
	) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:oxygen-hd-audio"|\
"sound:virtuoso"|\
"sound:virtuoso-66"|\
"sound:virtuoso-100"|\
"sound:virtuoso-200"|\
"sound:xonar-d1"|\
"sound:xonar-d2"|\
"sound:xonar-d2x"|\
"sound:xonar-ds"|\
"sound:xonar-dsx"|\
"sound:xonar-dx"|\
"sound:xonar-hdav1.3"|\
"sound:xonar-hdav1.3+h6"|\
"sound:xonar-hdav1.3-slim"|\
"sound:xonar-st"|\
"sound:xonar-st+h6"|\
"sound:xonar-stx"|\
"sound:xonar-stx-ii"|\
"sound:xonar-stx-ii+h6"|\
"sound:xonar-xense"|\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:via-hd-audio"|\
"sound:vt1702"|\
"sound:vt1705"|\
"sound:vt1705cf"|\
"sound:vt1708sce"|\
"sound:vt1708"|\
"sound:vt1708b"|\
"sound:vt1708s"|\
"sound:vt1709"|\
"sound:vt1708s"|\
"sound:vt1716s"|\
"sound:vt1718s"|\
"sound:vt1802"|\
"sound:vt1808"|\
"sound:vt1812"|\
"sound:vt1818s"|\
"sound:vt1828s"|\
"sound:vt2002p"|\
"sound:vt2020"\
) ]] ; then
		if [[ "${tags}" =~ ("late-2000"|"2010") ]] ; then
			ot-kernel_y_configopt "CONFIG_SND_HDA"
			ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA" # 2006, 2009, 2011
			ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
			ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
		fi
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("sound:opl3"|"sound:opl3-sa2"|"sound:opl3-sa3") ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ (\
"sound:ymf724"|\
"sound:ymf724f"|\
"sound:ymf740"|\
"sound:ymf740c"|\
"sound:ymf744"|\
"sound:ymf754"\
) ]] ; then
		ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	fi

	if grep -q -E -e "^CONFIG_SND_HDA=y" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004, audio only
	fi
}

fi
