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

inherit toolchain-funcs

# TODO:  Review xpad for wooting keyboards changes

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
	ot-kernel-driver-bundle_add_1990s_artist_drivers
	ot-kernel-driver-bundle_add_late_1990s_music_production_drivers
	ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_vpceb25fx_drivers
	ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers
	ot-kernel-driver-bundle_add_2010s_video_game_artist_drivers
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
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2" # 1987

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_SERIAL" # 1985
	ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for trackball mouse
	ot-kernel_y_configopt "CONFIG_TTY"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	ot-kernel_y_configopt "CONFIG_BLOCK"

	ot-kernel-driver-bundle_add_graphics "isa pci" # vlb is not suppored

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_EISA" # 1988

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_ADLIB" # 1987
	ot-kernel_y_configopt "CONFIG_SND_AZT1605" # 1994/1995
	ot-kernel_y_configopt "CONFIG_SND_CS4231" #
	ot-kernel_y_configopt "CONFIG_SND_ISA" # 1981
	ot-kernel_y_configopt "CONFIG_SND_SB8" # 1989
	ot-kernel_y_configopt "CONFIG_SND_SB16" # 1992
	ot-kernel_y_configopt "CONFIG_SND_SBAWE" # 1994

	ot-kernel_y_configopt "CONFIG_PARPORT" # For printer
	ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
	ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_1990s_pc_gamer_drivers
# @DESCRIPTION:
# A late 1990s x86 gamer driver bundle
ot-kernel-driver-bundle_add_late_1990s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-pc-gamer" ]] || return
ewarn "The late-1990s-pc-gamer driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	# For optical mouse (USB 1.1)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_SERIAL" # 1985
	ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for trackball mouse
	ot-kernel_y_configopt "CONFIG_TTY"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"

	# For CD-ROM
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	ot-kernel_y_configopt "CONFIG_SCSI"

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

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_EISA" # 1988

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

	# To play MIDI music
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_SEQUENCER"
	ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"

	ot-kernel_y_configopt "CONFIG_PARPORT" # For printer
	ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
	ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

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

	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport"
}

# @FUNCTION: ot-kernel-driver-bundle_add_1990s_artist_drivers
# @DESCRIPTION:
# A late 1990s x86 artist driver bundle, for CAD and graphic arts
ot-kernel-driver-bundle_add_1990s_artist_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "1990s-artist" ]] || return
ewarn "The 1990s-artist driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	# For optical mouse (USB 1.1)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_SERIAL" # 1985
	ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987, for trackball mouse
	ot-kernel_y_configopt "CONFIG_TTY"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"

	# For CD-ROM
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	ot-kernel_y_configopt "CONFIG_SCSI"

	ot-kernel-driver-bundle_add_storage "ide parport scsi"

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

	ot-kernel-driver-bundle_add_graphics "agp pci"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_EISA" # 1988

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

	# To play MIDI music
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_SEQUENCER"
	ot-kernel_y_configopt "CONFIG_SND_OSSEMUL"

	ot-kernel_y_configopt "CONFIG_PARPORT" # For printer, scanner
	ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
	ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

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

	ot-kernel_y_configopt "CONFIG_PCI"

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_MAGELLAN" # 1993
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEBALL" # 1991, 1995, 1999
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SPACEORB" # 1996

	ot-kernel-driver-bundle_add_haptic_devices "ethernet"
	ot-kernel-driver-bundle_add_graphics_tablet "serial usb"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_1990s_music_production_drivers
# @DESCRIPTION:
# A late 1990s x86 music production driver bundle
ot-kernel-driver-bundle_add_late_1990s_music_production_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-1990s-music-production" ]] || return
ewarn "The late-1990s-music-production driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	# For optical mouse (USB 1.1)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	ot-kernel_y_configopt "CONFIG_BLOCK"

	# For CD-ROM, CD-RW (1997)
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	ot-kernel_y_configopt "CONFIG_SCSI"

	ot-kernel-driver-bundle_add_storage "ide parport scsi"

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

	ot-kernel-driver-bundle_add_graphics "agp pci"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_EISA" # 1988

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

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_DRIVERS"
	ot-kernel_y_configopt "CONFIG_SND_MPU401" # 1984

	ot-kernel_y_configopt "CONFIG_PARPORT" # For printer
	ot-kernel_y_configopt "CONFIG_PARPORT_PC" # 1981
	ot-kernel_y_configopt "CONFIG_PARPORT_PC_FIFO"
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

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
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers
# @DESCRIPTION:
# An early 2000s x86 music production driver bundle
ot-kernel-driver-bundle_add_early_2000s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "early-2000s-pc-gamer" ]] || return
ewarn "The early-2000s-pc-gamer driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2" # 1987

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	# For optical mouse (USB 1.1)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_FD" # 5.25" floppy (1976), 3.5" floppy (1976)
	ot-kernel_y_configopt "CONFIG_BLK_DEV_LOOP"
	ot-kernel_y_configopt "CONFIG_BLOCK"

	# For CD-ROM, CD-RW (1997)
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	ot-kernel_y_configopt "CONFIG_SCSI"

	ot-kernel-driver-bundle_add_storage "ide parport scsi"

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

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_RECONFIG"
	ot-kernel_y_configopt "CONFIG_SND_PCI"

	ot-kernel-driver-bundle_add_graphics "agp pci"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_EISA" # 1988

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

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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
	ot-kernel_y_configopt "CONFIG_SENSORS_ADM1025" # 1999, 2004
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

	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_usb_gamer_headsets

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
}

# @FUNCTION: ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers
# @DESCRIPTION:
# A late 2000s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_late_2000s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "late-2000s-pc-gamer" ]] || return
ewarn "The late-2000s-pc-gamer driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSE"
	ot-kernel_y_configopt "CONFIG_MOUSE_PS2" # 1987

	# For optical mouse (USB 1.1, 2.0)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_PCSPKR_PLATFORM" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_PCSPKR"

	# For CD-ROM, CD-RW (1997)
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR" # 1987 (SCSI CD-ROM)
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_ISO9660_FS"
	ot-kernel_y_configopt "CONFIG_JOLIET"
	ot-kernel_y_configopt "CONFIG_SCSI"

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

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	ot-kernel-driver-bundle_add_graphics "agp pcie"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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

	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_usb_gamer_headsets

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "serial gameport hid usb bt"
}

# @FUNCTION: ot-kernel-driver-bundle_add_vpceb25fx_drivers
# @DESCRIPTION:
# Driver bundle for vpceb25fx (2010)
ot-kernel-driver-bundle_add_vpceb25fx_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "vpceb25fx" ]] || return
ewarn "The vpceb25fx driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	ot-kernel_y_configopt "CONFIG_KEYBOARD_ATKBD" # 1984 (AT), 1987 (PS/2 Keyboard)

	# For optical mouse (USB 2.0)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

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

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	# No USB 3.0

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	# For DVD
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_BLK_DEV"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_SR"

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

	ot-kernel-driver-bundle_add_console "tty"

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

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

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

	# For possibly watchdog to restart on freeze
	ot-kernel_y_configopt "CONFIG_LPC_ICH"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_ITCO_WDT"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_WATCHDOG"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_CORE"
	ot-kernel_y_configopt "CONFIG_WATCHDOG_NOWAYOUT"

	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
	ot-kernel-driver-bundle_add_graphics_tablet "usb"
	ot-kernel-driver-bundle_add_haptic_devices "ethernet usb"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers
# @DESCRIPTION:
# A 2010s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_2010s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-pc-gamer" ]] || return
ewarn "The 2010s-pc-gamer driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	# Assumes USB keyboard

	# For optical mouse (USB 2.0)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	# For NVMe SSD
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_NVME" # 2011

	# For SATA HDD/SSD
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	ot-kernel-driver-bundle_add_graphics "pcie"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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

	# CPU temp sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_CPU_SUP_AMD"
	ot-kernel_y_configopt "CONFIG_SENSORS_K10TEMP" # 2007-2014
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006
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

	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_usb_gamer_headsets

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_video_game_artist_drivers
# @DESCRIPTION:
# A 2010s x86 video game artist driver bundle
# FIXME:  It should be a laptop, but this is the desktop version.
ot-kernel-driver-bundle_add_2010s_video_game_artist_drivers() {
	# TODO:  rename
	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("2010s-cgi-artist"|"2010s-video-game-artist") ]] ; then
		:
	else
		return
	fi
ewarn "The 2010s-video-game-artist driver bundle has not been recently tested."
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	# Assumes USB keyboard

	# For optical mouse (USB 2.0)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	# For NVMe SSD
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_NVME" # 2011

	# For SATA HDD/SSD
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	ot-kernel-driver-bundle_add_graphics "pcie"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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

	# CPU temp sensor
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

	ot-kernel-driver-bundle_add_graphics_tablet "usb serial"

	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_usb_gamer_headsets

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
}

# @FUNCTION: ot-kernel-driver-bundle_add_2020s_pc_gamer_drivers
# @DESCRIPTION:
# A 2020s x86 pc gamer driver bundle
ot-kernel-driver-bundle_add_2020s_pc_gamer_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2020s-pc-gamer" ]] || return
ewarn "The 2020s-pc-gamer driver bundle has not been recently tested."

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_KEYBOARD"
	# Assumes USB keyboard

	# For optical mouse (USB 2.0)
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MOUSEDEV"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_HID"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"

	# For NVMe SSD
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_BLOCK"
	ot-kernel_y_configopt "CONFIG_BLK_DEV_NVME" # 2011

	# For SATA HDD/SSD
	ot-kernel_y_configopt "CONFIG_ATA"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_SATA_AHCI"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_EHCI_HCD" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_OHCI_HCD" # 1999

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_USB_STORAGE" # 2000

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64"

	ot-kernel-driver-bundle_add_graphics "pcie"

	ot-kernel-driver-bundle_add_console "tty"

	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_HDA"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI" # 2004
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0110" # 2006-2010
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_CA0132" # 2011
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL" # 2004

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS" # Already has mic support

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

	ot-kernel-driver-bundle_add_hid_gaming_keyboard_fixes
	ot-kernel-driver-bundle_add_hid_gaming_mouse_fixes
	ot-kernel-driver-bundle_add_usb_gamer_headsets

	ot-kernel-driver-bundle_add_x86_desktop_wifi_drivers
	ot-kernel-driver-bundle_add_x86_desktop_gamer_controller_drivers "hid usb bt"

	# For AI support
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_DRM_ACCEL"
	ot-kernel_y_configopt "CONFIG_DRM_ACCEL_IVPU"
	ot-kernel_y_configopt "CONFIG_PCI"
	ot-kernel_y_configopt "CONFIG_PCI_MSI"
}

ot-kernel-driver-bundle_add_console() {
	local tag="${1}"

	if [[ "${tag}" =~ ("hga-tty"|"hercules-tty"|"mono-tty") ]] ; then
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

	if [[ "${tag}" =~ ("cga-tty"|"ega-tty"|(^|" ")"vga-tty") ]] ; then
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

	if [[ "${tag}" =~ ("tty"($|" ")|"svga-tta") ]] ; then
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

	if [[ "${tag}" =~ ($|" ")"serial" ]] ; then
	# For headless servers
		ot-kernel_y_configopt "CONFIG_EXPERT"
		ot-kernel_y_configopt "CONFIG_SERIAL_8250"
		ot-kernel_y_configopt "CONFIG_SERIAL_8250_CONSOLE"
		ot-kernel_y_configopt "CONFIG_TTY"
	fi
	if [[ "${tag}" =~ "usb-serial" ]] ; then
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

		if [[ "${tag}" =~ ("tty"($|" ")|"svga-tta") ]] ; then
	# For switching graphics drivers without reboot
			ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
		else
			ot-kernel_unset_configopt "CONFIG_VT_HW_CONSOLE_BINDING"
		fi

	# For graphical terminals or SSH servers
		ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"
	fi
}

ot-kernel-driver-bundle_add_storage() {
	local tag="${1}"

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tag}" =~ "ide" ]] ; then
	# 1995
		ot-kernel_y_configopt "CONFIG_ATA"
		ot-kernel_y_configopt "CONFIG_ATA_SFF"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
		ot-kernel_y_configopt "CONFIG_SCSI"
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tag}" =~ "scsi" ]] ; then
	# 1995
		ot-kernel_y_configopt "CONFIG_SCSI"
		ot-kernel_y_configopt "CONFIG_BLK_DEV_SD"
		ot-kernel_y_configopt "CONFIG_BLOCK"
		ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"
		# TODO add controller
	fi

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "storage:zip-drive" && "${tag}" =~ "parport" ]] ; then
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
	local tag="${1}"

	if [[ "${tag}" =~ "isa" ]] ; then
		ot-kernel_y_configopt "CONFIG_FB_VGA16" # 1987
		ot-kernel_unset_configopt "CONFIG_FB_EFI" # unaccelerated, efifb is to see early boot for UEFI (2006)
	fi
	if [[ "${tag}" =~ "agp" ]] ; then
		ot-kernel_y_configopt "CONFIG_AGP" # 1997
		ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
		ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
		ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	fi

	if [[ "${tag}" =~ "pci"($|" ") ]] ; then
		ot-kernel_y_configopt "CONFIG_PCI" # 1992
	fi

	if [[ "${tag}" =~ "pcie" ]] ; then
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

	if [[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ ("graphics:pm3fb"|"graphics:permedia3") ]] ; then
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
	local tag="${1}"
	if [[ "${tag}" =~ "parport" ]] ; then
		ot-kernel-driver-bundle_add_haptic_devices_by_parport
	fi
	if [[ "${tag}" =~ "ethernet" ]] ; then
		ot-kernel-driver-bundle_add_haptic_devices_by_ethernet
	fi
	if [[ "${tag}" =~ "usb" ]] ; then
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
	local tag="${1}"
	if [[ "${tag}" =~ "serial" ]] ; then
		ot-kernel-driver-bundle_add_graphics_tablet_by_serial
	fi
	if [[ "${tag}" =~ "usb" ]] ; then
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

fi
