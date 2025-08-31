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

# TODO:  Review xpad for wooting keyboards changes

#
# Rollover rules:
#
# For mobo components, they can rollover a year forward (e.g. 1999 can roll over to 2000s profile; early decade [2004] can roll over to late decade [2005]) but not backward.
# For accessories or cards, they can rollover backwards or forward decades if compatible.
# If an older edition card or older accessory has been observed during that time period, it can be placed in that time period.
#

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

	ot-kernel-driver-bundle_add_early_1990s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_late_1990s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_1990s_cgi_artist_drivers
	ot-kernel-driver-bundle_add_late_1990s_musician_drivers
	ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_vpceb25fx_drivers
	ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_2010s_cgi_artist_drivers
	ot-kernel-driver-bundle_add_2020s_pc_gamer_drivers
	if declare -f ot-kernel-driver-bundle_add_custom_bundle_drivers ; then
eerror "ot-kernel-driver-bundle_add_custom_bundle_drivers has been renamed to ot-kernel-driver-bundle_add_custom_driver_bundle"
		die
	fi
	if declare -f ot-kernel-driver-bundle_add_custom_driver_bundle ; then
einfo "Adding a custom driver bundle"
		ot-kernel-driver-bundle_add_custom_driver_bundle
	fi
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_1990s_pc_gamer_drivers
# @DESCRIPTION:
# An early 1990s x86 gamer driver bundle
# At least Pentium is available for this ebuild
ot-kernel-driver-bundle_add_early_1990s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-1990s-pc-gamer" ]] || return
ewarn "The early-1990s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "isa pci"
	ot-kernel-driver-bundle_add_graphics "isa pci" # vlb is not suppored
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_keyboard "ps2"
	ot-kernel-driver-bundle_add_mouse "ps2 serial"
	ot-kernel-driver-bundle_add_floppy_drive

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
	ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
	ot-kernel_y_configopt "CONFIG_SND_CS4231" #
	ot-kernel_y_configopt "CONFIG_SND_ISA" # 1981
	ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
	ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
	ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	ot-kernel-driver-bundle_add_midi_playback_support

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_1990s_pc_gamer_drivers
# @DESCRIPTION:
# A late 1990s x86 gamer driver bundle
ot-kernel-driver-bundle_add_late_1990s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-pc-gamer" ]] || return
ewarn "The late-1990s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "isa pci agp"
	ot-kernel-driver-bundle_add_graphics "agp pci"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 serial usb"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd-rw"

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

	ot-kernel_y_configopt "CONFIG_PNP"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_ISA"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
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
	ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
	ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999
	ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
	ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
	ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
	ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	ot-kernel_y_configopt "CONFIG_ZONE_DMA"
	ot-kernel-driver-bundle_add_midi_playback_support

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

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
	ot-kernel-driver-bundle_add_tv_tuner "pci"
}

# @FUNCTION: ot-kernel-driver-bundle_add_1990s_cgi_artist_drivers
# @DESCRIPTION:
# A late 1990s x86 artist driver bundle, for CAD and graphic arts
ot-kernel-driver-bundle_add_1990s_cgi_artist_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("1990s-cgi-artist"|"1990s-drafter") ]] || return
ewarn "The 1990s-cgi-artist driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "isa pci agp"
	ot-kernel-driver-bundle_add_graphics "agp pci"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 serial usb"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd-rw"
	ot-kernel-driver-bundle_add_external_storage "ide parport scsi"

	# For HDD
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

	ot-kernel_y_configopt "CONFIG_PNP"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_ISA"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
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
	ot-kernel_y_configopt "CONFIG_SND_GUSEXTREME" # 1996
	ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999
	ot-kernel_y_configopt "CONFIG_SND_INTERWAVE_STB" # 1995
	ot-kernel_y_configopt "CONFIG_SND_MAESTRO3" # 1999
	ot-kernel_y_configopt "CONFIG_SND_OPL3SA2" # 1995
	ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994
	ot-kernel_y_configopt "CONFIG_SND_SONICVIBES" # 1997
	ot-kernel_y_configopt "CONFIG_SND_TRIDENT" # 1997
	ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	ot-kernel_y_configopt "CONFIG_SND_YMFPCI" # 1998
	ot-kernel_y_configopt "CONFIG_ZONE_DMA"
	ot-kernel-driver-bundle_add_midi_playback_support

	# For scanner
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_ALI15X3" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_ALI1535" # 1999
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_SIS5595" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
	ot-kernel_y_configopt "CONFIG_I2C_VIA" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_VIAPRO" # 1998, 1999, 2000, 2002, 2004, 2006, 2008, 2009, 2010
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
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

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_MAGELLAN" # 1993
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEBALL" # 1991, 1995, 1999
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEORB" # 1996

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet"
	ot-kernel-driver-bundle_add_graphics_tablet "serial usb"
	ot-kernel-driver-bundle_add_tv_tuner "pci"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_1990s_musician_drivers
# @DESCRIPTION:
# A late 1990s x86 music production driver bundle
ot-kernel-driver-bundle_add_late_1990s_musician_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-musician" ]] || return
ewarn "The late-1990s-musician driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "isa pci agp"
	ot-kernel-driver-bundle_add_graphics "agp pci"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 usb"
	ot-kernel-driver-bundle_add_floppy_drive
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd-rw dvd-ram"
	ot-kernel-driver-bundle_add_external_storage "ide parport scsi"

	# For HDD
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

	ot-kernel_y_configopt "CONFIG_PNP"
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_ISA"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
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
	ot-kernel-driver-bundle_add_midi_playback_support

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_DRIVERS"
	ot-kernel_y_configopt "CONFIG_SND_MPU401" # 1984

	# For temperature, RAM timing info
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_I2C_CHARDEV"
	ot-kernel_y_configopt "CONFIG_I2C_ALI15X3" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_ALI1535" # 1999
	ot-kernel_y_configopt "CONFIG_I2C_I801" # 1999, 2000, 2002, 2003, 2004, 2009, 2012, 2026
	ot-kernel_y_configopt "CONFIG_I2C_PIIX4" # 1997, 1999, 2000, 2001, 2002, 2004, 2005, 2006, 2010
	ot-kernel_y_configopt "CONFIG_I2C_SIS5595" # 1997
	ot-kernel_y_configopt "CONFIG_I2C_SMBUS"
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

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel-driver-bundle_add_printer "parport"
	ot-kernel-driver-bundle_add_tv_tuner "pci"
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers
# @DESCRIPTION:
# An early 2000s x86 music production driver bundle
ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-2000s-pc-gamer" ]] || return
ewarn "The early-2000s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
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

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
	ot-kernel_y_configopt "CONFIG_SND_PCI"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_CS4281" # 2001
	ot-kernel_y_configopt "CONFIG_SND_ALI5451" # 2001
	ot-kernel_y_configopt "CONFIG_SND_ATIIXP" # 2003
	ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
	ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
	ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
	ot-kernel_y_configopt "CONFIG_SND_INTEL8X0" # 1999
	ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	ot-kernel_y_configopt "CONFIG_ZONE_DMA"

	ot-kernel-driver-bundle_add_midi_playback_support

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

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pci usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers
# @DESCRIPTION:
# A late 2000s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-2000s-pc-gamer" ]] || return
ewarn "The late-2000s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "agp pci pcie"
	ot-kernel-driver-bundle_add_graphics "agp pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "ps2 usb"
	ot-kernel-driver-bundle_add_optical_drive "cd-rom cd-r cd-rw dvd-rom dvd-r dvd+rw dvd-rw dvd+rw dvd-ram"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_data_storage_interfaces "sata"

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

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_AU8820" # 1997
	ot-kernel_y_configopt "CONFIG_SND_AU8830" # 1998
	ot-kernel_y_configopt "CONFIG_SND_CA0106" # 2004
	ot-kernel_y_configopt "CONFIG_SND_CTXFI" # 2005
	ot-kernel_y_configopt "CONFIG_SND_EMU10K1" # 1998
	ot-kernel_y_configopt "CONFIG_SND_EMU10K1X" # 2003
	ot-kernel_y_configopt "CONFIG_SND_VIA82XX" # 1999
	ot-kernel_y_configopt "CONFIG_SND_VIRTUOSO" # 2008
	ot-kernel_y_configopt "CONFIG_ZONE_DMA"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_SIGMATEL" # 2005
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_VIA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
	ot-kernel_y_configopt "CONFIG_SND_PCI"

	ot-kernel-driver-bundle_add_midi_playback_support

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

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pci pcie usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_vpceb25fx_drivers
# @DESCRIPTION:
# Driver bundle for vpceb25fx (2010)
ot-kernel-driver-bundle_add_vpceb25fx_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "vpceb25fx" ]] || return
ewarn "The vpceb25fx driver bundle has not been recently tested."
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

	ot-kernel_y_configopt "CONFIG_INET"
	ot-kernel_y_configopt "CONFIG_NET"
	ot-kernel_y_configopt "CONFIG_IPV6"

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

	# For sound, HDMI (TV output)
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK"
	ot-kernel-driver-bundle_add_midi_playback_support

	# For possibly watchdog to restart on freeze
	ot-kernel_y_configopt "CONFIG_LPC_ICH"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_ITCO_WDT"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_WATCHDOG"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_CORE"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_NOWAYOUT"

	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_graphics_tablet "usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet usb"
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers
# @DESCRIPTION:
# A 2010s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-pc-gamer" ]] || return
ewarn "The 2010s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "pci pcie"
	ot-kernel-driver-bundle_add_graphics "pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_data_storage_interfaces "nvme sata"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel-driver-bundle_add_midi_playback_support

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

	# For ethernet for wired Internet
	ot-kernel_y_configopt "CONFIG_ETHERNET"
	ot-kernel_y_configopt "CONFIG_E1000E" # 2005
	ot-kernel_y_configopt "CONFIG_IGB" # 2008
	ot-kernel_y_configopt "CONFIG_R8169" # 2003
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK_OPTIONAL"

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_bluetooth
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_cgi_artist_drivers
# @DESCRIPTION:
# A 2010s x86 video game artist driver bundle
# FIXME:  It should be a laptop, but this is the desktop version.
ot-kernel-driver-bundle_add_2010s_cgi_artist_drivers() {
	# TODO:  rename
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("2010s-cgi-artist"|"2010s-video-game-artist") ]] || return
ewarn "The 2010s-cgi-artist driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "pcie"
	ot-kernel-driver-bundle_add_graphics "pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram"
	ot-kernel-driver-bundle_add_data_storage_interfaces "nvme sata"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel-driver-bundle_add_midi_playback_support

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

	# Temp, fan control
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_CPRO" # 2017

	# PSU sensor
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_PSU" # 2013

	# Water cooler sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_AQUACOMPUTER_D5NEXT" # 2018
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_KRAKEN2" # 2016
	ot-kernel_y_configopt "CONFIG_USB_HID" # Dependency of CONFIG_SENSORS_NZXT_KRAKEN2

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_graphics_tablet "usb serial"
	ot-kernel-driver-bundle_add_bluetooth
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-2.0"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2020s_pc_gamer_drivers
# @DESCRIPTION:
# A 2020s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_2020s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2020s-pc-gamer" ]] || return
ewarn "The 2020s-pc-gamer driver bundle has not been recently tested."
	ot-kernel-driver-bundle_add_pc_speaker
	ot-kernel-driver-bundle_add_expansion_slots "pcie"
	ot-kernel-driver-bundle_add_graphics "pcie"
	ot-kernel-driver-bundle_add_console "tty"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel-driver-bundle_add_usb "usb-1.1 usb-2.0 usb-3.0"
	ot-kernel-driver-bundle_add_keyboard "ps2 usb"
	ot-kernel-driver-bundle_add_mouse "usb"
	ot-kernel-driver-bundle_add_usb_storage_support
	ot-kernel-driver-bundle_add_optical_drive "dvd-rom dvd-r dvd+r dvd-rw dvd+rw dvd-ram"
	ot-kernel-driver-bundle_add_data_storage_interfaces "nvme sata"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel-driver-bundle_add_midi_playback_support

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

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_printer "usb"
	ot-kernel-driver-bundle_add_webcam
	ot-kernel-driver-bundle_add_bluetooth
	ot-kernel-driver-bundle_add_usb_gamer_headsets
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_tv_tuner "pcie usb-2.0"

	if [[ $(ot-kernel_get_cpu_mfg_id) == "intel" ]] ; then
		# For AI support
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_ACCEL"
		ot-kernel_y_configopt "CONFIG_DRM_ACCEL_IVPU"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCI_MSI"
	fi
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
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_SEQUENCER"
	ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"
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
	if grep -q -E -e "^CONFIG_MEDIA_SUPPORT=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT"
	fi
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
		ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for trackball mouse
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
	if [[ "${tags}" =~ "usb-1.1" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008
	fi
	if [[ "${tags}" =~ "usb-2.0" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000
	fi
	if [[ "${tags}" =~ "usb-3.0" ]] ; then
		ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999
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
|"graphics:rv670"\
|"graphics:r700"\
|"graphics:evergreen"\
|"graphics:northern-islands"\
|"graphics:southern-islands"\
|"graphics:sea-islands"\
) \
	]] ; then
		ot-kernel_y_configopt "CONFIG_DRM"
		ot-kernel_y_configopt "CONFIG_DRM_RADEON" # 2000
		ot-kernel_y_configopt "CONFIG_MMU"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# Add temp sensor
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_NVIDIA_GPU" # 2018
		ot-kernel_y_configopt "CONFIG_PCI"
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
|"graphics:rdna"($|" ")\
|"graphics:rdna2"\
|"graphics:rdna3"\
|"graphics:rdna4"\
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:nvidia-drm"|"graphics:nvidia-drivers") ]] ; then
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:atyfb"|"graphics:mach64"|"graphics:mach"($|" ")|"graphics:rage-pro") ]] ; then
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:vesafb"|"graphics:vesa"|"graphics:wonder"|"graphics:3d-rage") ]] ; then
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
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "haptic-devices:touch-x"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_FF_MEMLESS"
		ot-kernel_y_configopt "CONFIG_HID"
		ot-kernel_y_configopt "CONFIG_HID_GENERIC"
		ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("haptic-devices:touch"($|" ")|"haptic-devices:touch-x"($|" ")) ]] ; then
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
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("haptic-devices:touch"($|" ")|"haptic-devices:touch-x"($|" ")) ]] ; then
	# OpenHaptics support on Linux (2009)
	# Touch (2003), Touch X (2008)
	# USB 2.0, USB 3.0, Ethernet
	# For ethernet for the haptic stylus or wired Internet
		ot-kernel_y_configopt "CONFIG_ETHERNET"
		ot-kernel_y_configopt "CONFIG_E1000E" # 2005
		ot-kernel_y_configopt "CONFIG_IGB" # 2008
		ot-kernel_y_configopt "CONFIG_R8169" # 2003
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_NET_VENDOR_INTEL"
		ot-kernel_y_configopt "CONFIG_NET_VENDOR_REALTEK"
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
		ot-kernel_y_configopt "CONFIG_PTP_1588_CLOCK_OPTIONAL"

		# For closed source drivers
		ot-kernel_y_configopt "CONFIG_MODULES"
		ot-kernel_n_configopt "CONFIG_TRIM_UNUSED_KSYMS"
		_FORCE_OT_KERNEL_EXTERNAL_MODULES=1
	fi
}

ot-kernel-driver-bundle_add_haptic_devices_by_parport() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "haptic-devices:phantom-premium" ]] ; then
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
		ot-kernel_y_configopt "CONFIG_ADI"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
		ot-kernel_y_configopt "CONFIG_JOYSTICK_ADI" # 1997, 1998, 1999, 2000
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
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RTL_CARDS"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTL8180" # 2002, PCI
		ot-kernel_y_configopt "CONFIG_RTL8187" # 2004
		ot-kernel_y_configopt "CONFIG_RTL8192CU" # 2013
		ot-kernel_y_configopt "CONFIG_RTL8192DU" # 2013
		ot-kernel_y_configopt "CONFIG_RTW88_8821CU" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_RTW88_8822CU" # 2021
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


	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8192"|"wifi:rtl8192cu") ]] ; then
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "wifi:rtw87"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8723DU" # 2018
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_WLAN"
		ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_REALTEK"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8723"|"wifi:rtl8723du") ]] ; then
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
		ot-kernel_y_configopt "CONFIG_RTW88_8821CU" # 2017
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_RTW88_8822CU" # 2021
		ot-kernel_y_configopt "CONFIG_USB"
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("wifi:rtl8822"|"wifi:rtl8822bu") ]] ; then
		ot-kernel_y_configopt "CONFIG_MAC80211"
		ot-kernel_y_configopt "CONFIG_NETDEVICES"
		ot-kernel_y_configopt "CONFIG_RTW88"
		ot-kernel_y_configopt "CONFIG_RTW88_8822BU" # 2016
		ot-kernel_y_configopt "CONFIG_USB"
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

ot-kernel-driver-bundle_add_tv_tuner_usb_2_0_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-aero-m" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LG2160" # ATSC-M/H demodulator
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3305" # ASTC & DVB-T demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB_MXL111SF" # Tuner & demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_RC_DEVICES"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850-65301") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Demodulator
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # A/V decoder for analog video input
		ot-kernel_y_configopt "CONFIG_DVB_USB"
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
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB interface
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850-72301") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_DTV" # Digital demodulator
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
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
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-850-01200") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3305" # ASTC demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB"
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
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB interface, A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-950"($|" ")) ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # digital demodulator
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner and analog demodulator
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2" # Analog capture
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Video decoder
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-950q") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_DTV" # ATSC and ClearQAM digital demodulators
		ot-kernel_y_configopt "CONFIG_DVB_AU8522_V4L" # Analog demodulator
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_AU0828_V4L2" # Analog video capture
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
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
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX231XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1950" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_IT913X" # Possibly used digital tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Possibly used tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Possibly used analog/digital tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_SYSFS"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX25840" # Video decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_PVRUSB2_SYSFS"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-hd-stick-801ese" ]] ; then
	# Missing analog support in driver
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700" # USB bridge
		ot-kernel_y_configopt "CONFIG_DVB_S5H1411" # ATSC (8-VSB) and QAM demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-hd-stick-800e" ]] ; then
	# QAM is not supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # ATSC, NTSC, ClearQAM tuner
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for DVB-T, ATSC, DMB-T, ISDB-T; driver also supports xc3028
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog video decoder for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_VIDEO_V4L2_SUBDEV_API"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-hd-stick-801e" ]] ; then
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
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-72e" ]] ; then
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
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-nano-stick-73e" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_SMS_USB_DRV"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-microstick-pc-and-mac-77e" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_RTL2832_SDR"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700"
		ot-kernel_y_configopt "CONFIG_DVB_USB_V2"
		ot-kernel_y_configopt "CONFIG_DVB_USB_RTL28XXU"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-nanostix-t2-290e" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_DIB7000P"
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_DVB_USB_DIB0700"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_COMMON_OPTIONS"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_IT913X"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TUA9001"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-dvb-s2-stick-460e" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_STV090x"
		ot-kernel_y_configopt "CONFIG_DVB_TDA10071"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18212"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
	fi
	if false && [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-dvb-s2-stick-461e" ]] ; then
ewarn "The M88TS2022 driver is dropped in later kernel version for tv-tuner:pctv-dvb-s2-stick-461e support."
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_A8293"
		ot-kernel_y_configopt "CONFIG_DVB_M88DS3103"
		#ot-kernel_y_configopt "CONFIG_DVB_M88TS2022" # For tuner
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18212"
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:tv-wonder-hd-600-usb") ]] ; then
	# ATI
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Digital demodulator for ASTC (8-VSB) and 64/256-QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Tuner for NTSC, PAL, SECAM, ASTC, DVB-C, DVB-T, DMB-T, ISDB-T
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog decoder
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:eyetv-hybrid-us") ]] ; then
	# Elgato
	# QAM is not supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT330X" # Analog tuner for NTSC, PAL, SECAM, CVBS, SIF; Digital tuner for ASTC, DVB-C, DVB-T, DMB-T, ISDB-T, 64-QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_CONTROLLER"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC2028" # Analog (NTSC, PAL, SECAM) and digital tuner (ASTC, DVB-T, DVB-C)
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB bridge, analog audio
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_VIDEO_TVP5150" # Analog video decoder for NTSC, PAL, PAL60
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:indtube") ]] ; then
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
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:pctv-nanostick-t2-290e") ]] ; then
	# Only digital TV supported
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_CXD2820R" # Demodulator for DVB-T/T2/C
		ot-kernel_y_configopt "CONFIG_DVB_TDA18271C2DD" # Digital tuner for DVB-T/T2, DVB-C/C2, ATSC, ISDB-T; Analog tuner for NTSC, PAL, SECAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX" # USB device controller
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_EM28XX_V4L2"
		ot-kernel_y_configopt "CONFIG_USB"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_pci_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hdtv-wonder") ]] ; then
	# ATI
	# No analog sound support because driver missing
	# Digital sound decode done by sound card DAC
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ASTC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ASTC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog IF (radio Intermediate Frequency) demodulator for PAL, SECAM, NTSC
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:hdtv-wonder-value-edition") ]] ; then
	# ATI
	# TU1236 uses the same driver as TUV1236D
	# Removes AK5355, TDA9887
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_NXT200X" # ATSC (8-VSB) / QAM / VSB demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SIMPLE" # TUV1236D tuner for ASTC (8-VSB) and 64/256-QAM; TUA6034 tuner for DVB-T, DVB-C, ISDB-T, ASTC, PAL, NTSC, DOCSIS
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:my-cinema-p7131-hybrid") ]] ; then
	# ASUS
	# FM radio support is incomplete
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_TDA1004X" # DVB-T demodulator and tuner
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7164" # PCI bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:wintv-hvr-1600" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Digital demodulator
		ot-kernel_y_configopt "CONFIG_DVB_USB"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887" # Analog tuner
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2060" # Possibly used
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MXL5005S" # Digital tuner
ewarn "The CX24227 driver is missing in the kernel.  For some revisions of tv-tuner:wintv-hvr-1600, the digital TV may not work."
		#ot-kernel_y_configopt "CONFIG_VIDEO_CX24227" # digital demodulator, removed from kernel
		ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_PCI_QUIRKS"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_USB"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX18" # Handle video and audio streams
		ot-kernel_y_configopt "CONFIG_VIDEO_CX18_ALSA" # Audio support
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	# tv-tuner:wintv-hvr-1600mce is not supported since TMFNM05_12E was removed
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-hd-card-800i" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Demodulator for ATSC, QAM
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_XC5000" # Analog and digital tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCI bridge and decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "tv-tuner:pctv-stereo" ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA9887"
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_RC"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_ALSA"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner_pcie_by_product_name() {
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-1800") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_S5H1409" # Digital demodulator for ATSC, ClearQAM, VSB
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_MT2131" # Digital tuner for ATSC, QAM, NTSC
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Analog tuner PAL, NTSC, SECAM;  Digital tuner for DVB-T, ATSC 1.0 (8-VSB)
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA8290" # Analog IF demodulator with TDA8295
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and A/V decoder
		ot-kernel_y_configopt "CONFIG_VIDEO_CX2341X" # MPEG encoder for analog TV
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134"
		ot-kernel_y_configopt "CONFIG_VIDEO_SAA7134_DVB" # Possibly used for analog side
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-5500") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2165" # DVB-T, DVB-C demodulator
		ot-kernel_y_configopt "CONFIG_DVB_TDA10071" # DVB-S2 demodulator
		# CX24118A - Missing tuner for DVB-S, DVB-S2
		# CX24501 - No driver
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SDR_SUPPORT" # FM radio
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_TDA18271" # Tuners for analog TV (PAL/SECAM), DVB-C, DVB-T, FM radio
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # A/V decoder and analog IF demodulator
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-hvr-5525") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_MT312" # DVB-S2 tuner
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # DVB-T2/C and DVB-S2 demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT" # NTSC/PAL/SECAM
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Analog tuner for NTSC, PAL, SECAM; Digital tuner for ATSC, QAM, DVB-T2/T/C2/C, DTMB, ISDB-T/C
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge for A/V
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-quadhd-astc-clearqam") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_LGDT3306A" # ASTC and ClearQAM demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX88" # For sound support
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("tv-tuner:wintv-quadhd-dvt-t-t2-c") ]] ; then
		ot-kernel_y_configopt "CONFIG_DVB_CORE"
		ot-kernel_y_configopt "CONFIG_DVB_SI2168" # Demodulator
		ot-kernel_y_configopt "CONFIG_I2C"
		ot-kernel_y_configopt "CONFIG_I2C_MUX"
		ot-kernel_y_configopt "CONFIG_INPUT"
		ot-kernel_y_configopt "CONFIG_MEDIA_ANALOG_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_DIGITAL_TV_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_PCI_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
		ot-kernel_y_configopt "CONFIG_MEDIA_TUNER_SI2157" # Tuner
		ot-kernel_y_configopt "CONFIG_PCI"
		ot-kernel_y_configopt "CONFIG_RC_CORE"
		ot-kernel_y_configopt "CONFIG_SND"
		ot-kernel_y_configopt "CONFIG_VIDEO_CX23885" # PCIe bridge and host adapter
		ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	fi
}

ot-kernel-driver-bundle_add_tv_tuner() {
	# Only digital supported
	local tags="${1}"

	# ATSC - North America, Carribean, South Korea
	# QAM - Digital Cable US & UK
	# DVB - Europe, Africa, Asia, Oceana
	#  -T - Terrestrial antenna; Australia, India, Ireland, England
	#  -T2 - Second version of -T; Malaysia, Iran, Turkey, Ukraine, Middle East, Italy, Netherlands, Spain, Ireland, England, North Korea
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
	# The ebuild only supports fully supported models.
	# Partially supported models will be considered if it has basic digital TV or AM/FM radio support.

	#
	# Issues for generating TV tuner driver sets
	#
	# 1. Non-intuitive driver selection for the model
	# 2. Hard to find kernel config directions
	# 3. AI hallucinations when reconstructing the proper config
	# 4. AI incomplete driver sets
	# 5. Deleted or merged drivers for components of TV tuner
	#

	#
	# Workarounds or resolutions for above issues:
	#
	# 1. Explicitly list all supported standards and chips to the AI.
	# 2. Verify selected drivers with IC or chip list on wiki.
	# 3. Put a note or warning that the use case is not supported.
	# 4. Verify 1-to-1 coverage between driver set and components.
	# 5. Verify that it lists a bridge, tuner(s), demodulator(s).
	#    The order to see a viewable analog image is Tuner > Demodulator > Decoder > Output.
	#    The order to see a viewable digital image is Tuner > Demodulator > Demultiplexer > Decoder > Output.
	#    The order to listen to analog FM radio is Tuner > Demodulator > Decoder > Output.
	#    The order to listen to digital FM radio is Tuner > Demodulator > Output.
	# 6. Analog support will be disabled if not listed in table.
	#

	ot-kernel_y_configopt "CONFIG_FW_LOADER"
	ot-kernel_unset_configopt "CONFIG_MEDIA_SUPPORT_FILTER"
	if [[ "${tags}" =~ "usb-2.0"($|" ") ]] ; then
		ot-kernel-driver-bundle_add_tv_tuner_usb_2_0_by_product_name
	fi
	if [[ "${tags}" =~ "pci"($|" ") ]] ; then
		ot-kernel-driver-bundle_add_tv_tuner_pci_by_product_name
	fi
	if [[ "${tags}" =~ "pcie"($|" ") ]] ; then
		ot-kernel-driver-bundle_add_tv_tuner_pcie_by_product_name
	fi
	if grep -q -E -e "^CONFIG_MEDIA_SUPPORT=(y|m)" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_MEDIA_SUBDRV_AUTOSELECT"
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
}

fi
