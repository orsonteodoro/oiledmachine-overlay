/*
 * GSPCA Endpoints (formerly known as AOX) ep800 USB Camera sub Driver
 *
 * Copyright (C) 2012 Orson Teodoro <orsonteodoro@yahoo.com>
 * Copyright (C) 2011 Hans de Goede <hdegoede@redhat.com>
 *
 * Based on the v4l1 se401 driver which is:
 *
 * Copyright (c) 2000 Jeroen B. Vreeken (pe1rxq@amsat.org)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#define EP800_REQ_CAMERA_INFO			0x00
#define EP800_REQ_CAPTURE_INFO			0x01
#define EP800_REQ_COMPRESSION			0x02
#define EP800_REQ_IMAGE_INFO			0x05 //not used
#define EP800_DEAD_PIXEL			0x09 //not used
#define EP800_REQ_AUTO_CONTROL			0x0a //se402 and not used
#define EP800_REQ_START_CONTINUOUS_CAPTURE	0x03
#define EP800_REQ_STOP_CONTINUOUS_CAPTURE	0x03
#define EP800_REQ_CAPTURE_FRAME			0x04
#define EP800_REQ_GET_EXT_FEATURE		0x06
#define EP800_REQ_SET_EXT_FEATURE		0x06
#define EP800_REQ_CAMERA_POWER			0x07
#define EP800_REQ_LED_CONTROL			0x08
#define EP800_REQ_BIOS				0xff

#define EP800_BIOS_READ				0x07

#define EP800_FORMAT_BAYER			1

#define EP800_COMPRESSION_BAYER			0x00
#define EP800_COMPRESSION_EPLITE_GT		0x02 //> 320x240 if maxframe 640x480
#define EP800_COMPRESSION_EPLITE_LTE		0x82 //<=320x240 if maxframe 640x480
#define EP800_OPERATINGMODE_BAYER		0x03
#define EP800_OPERATINGMODE_JANGGU_X2		0x40
#define EP800_OPERATINGMODE_JANGGU_X4		0x42


/* Hyundai hv7131b registers
   7121 and 7141 should be the same (haven't really checked...) */
/* Mode registers: */
#define HV7131_REG_MODE_A		0x00
#define HV7131_REG_MODE_B		0x01
#define HV7131_REG_MODE_C		0x02
/* Frame registers: */
#define HV7131_REG_FRSU		0x10
#define HV7131_REG_FRSL		0x11
#define HV7131_REG_FCSU		0x12
#define HV7131_REG_FCSL		0x13
#define HV7131_REG_FWHU		0x14
#define HV7131_REG_FWHL		0x15
#define HV7131_REG_FWWU		0x16
#define HV7131_REG_FWWL		0x17
/* Timing registers: */
#define HV7131_REG_THBU		0x20
#define HV7131_REG_THBL		0x21
#define HV7131_REG_TVBU		0x22
#define HV7131_REG_TVBL		0x23
#define HV7131_REG_TITU		0x25
#define HV7131_REG_TITM		0x26
#define HV7131_REG_TITL		0x27
#define HV7131_REG_TMCD		0x28
/* Adjust Registers: */
#define HV7131_REG_ARLV		0x30
#define HV7131_REG_ARCG		0x31
#define HV7131_REG_AGCG		0x32
#define HV7131_REG_ABCG		0x33
#define HV7131_REG_APBV		0x34
#define HV7131_REG_ASLP		0x54
/* Offset Registers: */
#define HV7131_REG_OFSR		0x50
#define HV7131_REG_OFSG		0x51
#define HV7131_REG_OFSB		0x52
/* Reset level statistics registers: */
#define HV7131_REG_LOREFNOH	0x57
#define HV7131_REG_LOREFNOL	0x58
#define HV7131_REG_HIREFNOH	0x59
#define HV7131_REG_HIREFNOL	0x5a

#define EP800_NUMSCRATCH	64
#define EP800_NUMFRAMES		2

/* se401 registers */
#define EP800_OPERATINGMODE	0x2000 //not used
