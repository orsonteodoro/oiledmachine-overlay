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

# @FUNCTION: ot-kernel-driver-bundle_add_drivers
# @DESCRIPTION:
# Main routine for installing drivers in bundles
ot-kernel-driver-bundle_add_drivers() {
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
einfo "Adding a custom driver bundle"
		ot-kernel-driver-bundle_add_custom_bundle_drivers
	fi
}

# @FUNCTION: ot-kernel-driver-bundle_add_early_1990s_pc_gamer_drivers
# @DESCRIPTION:
# An early 1990s x86 gamer driver bundle
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

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_ANALOG" # 1992, 2000, 2016
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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
	ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
	ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB"
	ot-kernel_y_configopt "CONFIG_FB_3DFX" # 1998-2000
	ot-kernel_y_configopt "CONFIG_FB_ATY128" # 1998
	ot-kernel_y_configopt "CONFIG_FB_NVIDIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB_RIVA" # 1997
	ot-kernel_y_configopt "CONFIG_FB_S3" # 1995/1996
	ot-kernel_y_configopt "CONFIG_FB_SAVAGE" # 1998
	ot-kernel_y_configopt "CONFIG_FB_VOODOO1" # 1996-1998
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_VT8231" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_W83627HF" # 1998
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_A3D" # 1997
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SIDEWINDER" # 1995-2003
	ot-kernel_y_configopt "CONFIG_JOYSTICK_STINGER" # 1998
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
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
	ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
	ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_DRM_MGAG200" # 1998
	ot-kernel_y_configopt "CONFIG_FB"
	ot-kernel_y_configopt "CONFIG_FB_MATROX" # 1999-2001
	ot-kernel_y_configopt "CONFIG_FB_NVIDIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB_PM3" # 1999
	ot-kernel_y_configopt "CONFIG_FB_RIVA" # 1997
	ot-kernel_y_configopt "CONFIG_FB_SAVAGE" # 1998
	ot-kernel_y_configopt "CONFIG_FB_VOODOO1" # 1996-1998
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

	# For scanner
	ot-kernel_y_configopt "CONFIG_SCSI"
	ot-kernel_y_configopt "CONFIG_CHR_DEV_SG"

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999
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

	# Graphics tablet for drawing
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_TABLET"
	ot-kernel_y_configopt "CONFIG_TABLET_SERIAL_WACOM4"
	ot-kernel_y_configopt "CONFIG_SERIAL_8250" # 1978/1987
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
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
	ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
	ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB"
	ot-kernel_y_configopt "CONFIG_FB_3DFX" # 1998-2000
	ot-kernel_y_configopt "CONFIG_FB_ATY128" # 1998
	ot-kernel_y_configopt "CONFIG_FB_NVIDIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB_RIVA" # 1997
	ot-kernel_y_configopt "CONFIG_FB_S3" # 1995/1996
	ot-kernel_y_configopt "CONFIG_FB_SAVAGE" # 1998
	ot-kernel_y_configopt "CONFIG_FB_VOODOO1" # 1996-1998
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999
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
	ot-kernel_y_configopt "CONFIG_USB_XHCI_HCD" # 2008

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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
	ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
	ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998
	ot-kernel_y_configopt "CONFIG_FB"
	ot-kernel_y_configopt "CONFIG_FB_3DFX" # 1998-2000
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	# Modern for higher resolutions
	ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
	ot-kernel_y_configopt "CONFIG_FB_CORE"
	ot-kernel_y_configopt "CONFIG_VT"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

	# CPU sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_K8TEMP" # 2003

	# Temp sensors
	ot-kernel_y_configopt "CONFIG_DMI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ASB100" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_IT87" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_VIA686A" # 2000
	ot-kernel_y_configopt "CONFIG_SENSORS_VT1211" # 2002
	ot-kernel_y_configopt "CONFIG_SENSORS_VT8231" # 1999
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83791D" # 2001
	ot-kernel_y_configopt "CONFIG_SENSORS_W83L785TS" # 2002

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_SIDEWINDER" # 1995-2003

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_ANALOG" # 1992, 2000, 2016
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64" # 2002, 2003
	ot-kernel_y_configopt "CONFIG_AGP_INTEL" # 1997-2004
	ot-kernel_y_configopt "CONFIG_AGP_VIA" # 1998

	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_RADEON" # 2000

	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	# Modern for higher resolutions
	ot-kernel_y_configopt "CONFIG_FB_CORE"
	ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
	ot-kernel_y_configopt "CONFIG_VT"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# For webcam
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_MEDIA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_MEDIA_CAMERA_SUPPORT"
	ot-kernel_y_configopt "CONFIG_VIDEO_DEV"
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

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

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU" # 2004
	ot-kernel_y_configopt "CONFIG_SENSORS_ABITUGURU3" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ATK0110" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_I5500" # 2008-2009
	ot-kernel_y_configopt "CONFIG_SENSORS_W83627EHF" # 2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83781D" # 1997-2007
	ot-kernel_y_configopt "CONFIG_SENSORS_W83792D" # 2005
	ot-kernel_y_configopt "CONFIG_SENSORS_W83793" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_W83795" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_W83L786NG" # 2006

	ot-kernel_y_configopt "CONFIG_GAMEPORT" # 1981
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	# For gameport to USB adapter (2005)
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
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

	# For Wi-Fi
	ot-kernel_y_configopt "CONFIG_NETDEVICES"
	ot-kernel_y_configopt "CONFIG_WLAN"
	ot-kernel_y_configopt "CONFIG_WLAN_VENDOR_INTEL"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_CFG80211"
	ot-kernel_y_configopt "CONFIG_IWLWIFI"

	local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
	local filename=$(basename $(ls "/lib/firmware/iwlwifi-6000-"*".ucode"))
	firmware="${firmware} ${filename}" # Insert firmware
einfo "Auto inserting ${filename} firmware"
	firmware=$(echo "${firmware}" \
		| sed -r \
			-e "s|[ ]+| |g" \
			-e "s|^[ ]+||g" \
			-e 's|[ ]+$||g') # Trim mid/left/right spaces
	ot-kernel_set_configopt "CONFIG_EXTRA_FIRMWARE" "\"${firmware}\""
	local firmware=$(grep "CONFIG_EXTRA_FIRMWARE" ".config" | head -n 1 | cut -f 2 -d "\"")
einfo "CONFIG_EXTRA_FIRMWARE:  ${firmware}"

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
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

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

	# For sound, HDMI (TV output)
	ot-kernel_y_configopt "CONFIG_SOUND"
	ot-kernel_y_configopt "CONFIG_SND"
	ot-kernel_y_configopt "CONFIG_SND_PCI"
	ot-kernel_y_configopt "CONFIG_SND_HDA_INTEL"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_HDMI"
	ot-kernel_y_configopt "CONFIG_SND_HDA_CODEC_REALTEK"

	ot-kernel_y_configopt "CONFIG_USB_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_USB_PRINTER"

	# CPU temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006

	# For gameport to USB adapter (2005)
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64"

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_RADEON" # 2000

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)

	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	# Modern for higher resolutions
	ot-kernel_y_configopt "CONFIG_FB_CORE"
	ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
	ot-kernel_y_configopt "CONFIG_VT"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

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

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_AQUACOMPUTER_D5NEXT" # 2018
	ot-kernel_y_configopt "CONFIG_SENSORS_ATK0110" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_ASUS_WMI" # 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_CPRO" # 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_PSU" # 2013
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT6683" # 2013
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT7802" # 2012
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_KRAKEN2" # 2016
	ot-kernel_y_configopt "CONFIG_USB_HID" # Dependency of CONFIG_SENSORS_NZXT_KRAKEN2

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

	# For Wi-FI, we need an environment variable or use flag because of the firmware issue
	# iwlwifi
	# b43
	# brcmfmac
	# ath9k
	# ath10k

	# For gameport to USB adapter (2005)
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYSTICK"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"
	ot-kernel_y_configopt "CONFIG_INPUT_EVDEV"
	ot-kernel_y_configopt "CONFIG_JOYSTICK_ANALOG" # 1992, 2000, 2016
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD" # 2001
	ot-kernel_y_configopt "CONFIG_JOYSTICK_XPAD_FF" # 2005
}

# @FUNCTION: ot-kernel-driver-bundle_add_2010s_video_game_artist_drivers
# @DESCRIPTION:
# A 2010s x86 video game artist driver bundle
# FIXME:  It should be a laptop, but this is the desktop version.
ot-kernel-driver-bundle_add_2010s_video_game_artist_drivers() {
	[[ "${OT_KERNEL_DRIVER_BUNDLE}" =~ "2010s-video-game-artist" ]] || return
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

	ot-kernel_y_configopt "CONFIG_AGP" # 1997
	ot-kernel_y_configopt "CONFIG_AGP_AMD64"

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_RADEON" # 2000

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)

	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	# Modern for higher resolutions
	ot-kernel_y_configopt "CONFIG_FB_CORE"
	ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
	ot-kernel_y_configopt "CONFIG_VT"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

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

	# For gameport to USB adapter (2005)
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	# CPU temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_CPU_SUP_AMD"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006
	ot-kernel_y_configopt "CONFIG_SENSORS_K10TEMP" # 2007-2014
	ot-kernel_y_configopt "CONFIG_SENSORS_FAM15H_POWER" # 2011-2015

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_ACPI"
	ot-kernel_y_configopt "CONFIG_ACPI_WMI"
	ot-kernel_y_configopt "CONFIG_I2C"
	ot-kernel_y_configopt "CONFIG_SENSORS_ACPI_POWER" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_AQUACOMPUTER_D5NEXT" # 2018
	ot-kernel_y_configopt "CONFIG_SENSORS_ASUS_WMI" # 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_ATK0110" # 2009
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_CPRO" # 2017
	ot-kernel_y_configopt "CONFIG_SENSORS_CORSAIR_PSU" # 2013
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT6683" # 2013
	ot-kernel_y_configopt "CONFIG_SENSORS_NCT7802" # 2012
	ot-kernel_y_configopt "CONFIG_SENSORS_NZXT_KRAKEN2" # 2016
	ot-kernel_y_configopt "CONFIG_USB_HID" # Dependency of CONFIG_SENSORS_NZXT_KRAKEN2

	# For 3D modeling with a haptic stylus
	# USB 2.0, USB 3.0, Ethernet, Parallel Port (EPP)
	# OH Linux (2009)
	# G MT (2003), G MT X (2008)
	# PP 1.5 (2001)
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
	ot-kernel_y_configopt "CONFIG_PARPORT_1284" # 1991
	ot-kernel_y_configopt "CONFIG_PCI" # 1992

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

	# For drawing on pen display
	ot-kernel_y_configopt "CONFIG_HID"
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_HID_WACOM" # 1998/2001
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_MISC"
	ot-kernel_y_configopt "CONFIG_INPUT_UINPUT"

	# For closed source drivers
	ot-kernel_y_configopt "CONFIG_MODULES"
	ot-kernel_n_configopt "CONFIG_TRIM_UNUSED_KSYMS"
	_FORCE_OT_KERNEL_EXTERNAL_MODULES=1
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

	ot-kernel_y_configopt "CONFIG_DRM"
	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_MMU"
	ot-kernel_y_configopt "CONFIG_DRM_AMDGPU" # 2015 (GCN3)

	ot-kernel_y_configopt "CONFIG_PCI" # 1992
	ot-kernel_y_configopt "CONFIG_PCIEPORTBUS" # 2003

	# Older framebuffer driver
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_VGA_CONSOLE"

	# Modern for higher resolutions
	ot-kernel_y_configopt "CONFIG_FB_CORE"
	ot-kernel_y_configopt "CONFIG_FRAMEBUFFER_CONSOLE"
	ot-kernel_y_configopt "CONFIG_VT"

	ot-kernel_y_configopt "CONFIG_EXPERT"
	ot-kernel_y_configopt "CONFIG_TTY"
	ot-kernel_y_configopt "CONFIG_VT"
	ot-kernel_y_configopt "CONFIG_VT_CONSOLE"
	ot-kernel_y_configopt "CONFIG_CONSOLE_TRANSLATIONS" # optional, upstream default, unicode support
	ot-kernel_y_configopt "CONFIG_VT_HW_CONSOLE_BINDING" # optional, upstream default
	ot-kernel_y_configopt "CONFIG_UNIX98_PTYS"

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
	ot-kernel_y_configopt "CONFIG_USB_VIDEO_CLASS"

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

	# For gameport to USB adapter (2005)
	ot-kernel_y_configopt "CONFIG_USB_HID"
	ot-kernel_y_configopt "CONFIG_HID_SUPPORT"
	ot-kernel_y_configopt "CONFIG_USB"
	ot-kernel_y_configopt "CONFIG_INPUT"
	ot-kernel_y_configopt "CONFIG_INPUT_JOYDEV"

	# CPU temp sensors
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_SENSORS_CORETEMP" # 2006

	# Temp sensor
	ot-kernel_y_configopt "CONFIG_HWMON"
	ot-kernel_y_configopt "CONFIG_ACPI"
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
}

fi
