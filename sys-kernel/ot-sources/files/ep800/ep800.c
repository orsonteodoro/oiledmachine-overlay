/*
 * GSPCA Endpoints (formerly known as AOX) ep800 USB Camera sub Driver
 *
 * Copyright (C) 2012 Orson Teodoro <orsonteodoro@yahoo.com>
 * Copyright (C) 2011 Hans de Goede <hdegoede@redhat.com>
 *
 * Updates based on the ov534-ov7xxx gspca driver
 * 
 * Copyright (C) 2008 Antonio Ospite <ospite@studenti.unina.it>
 * Copyright (C) 2008 Jim Paris <jim@jtan.com>
 * Copyright (C) 2009 Jean-Francois Moine http://moinejf.free.fr
 * 
 * Based on the v4l1 epcam driver which is:
 *
 * Copyright (c) 2003, 2004 Jeroen B. Vreeken (pe1rxq@amsat.org)
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

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define MODULE_NAME "ep800"

#define READ_REQ_SIZE 64
#define MAX_MODES 4
/* The EP800 compression algorithm uses a fixed quant factor, which
   can be configured by setting the high nibble of the EP800_OPERATINGMODE
   feature. This needs to exactly match what is in libv4l! */
#define EP800_QUANT_FACT 8
#define SD_NPKT 4
#define SD_NURBS 2

#include <linux/input.h>
#include <linux/slab.h>
#include "gspca.h"
#include "ep800.h"

MODULE_AUTHOR("Orson Teodoro <orsonteodoro@yahoo.com>");
MODULE_DESCRIPTION("Endpoints ep800");
MODULE_LICENSE("GPL");

/* controls */
enum e_ctrl {
	GAIN,
	EXPOSURE,
	FREQ,
	NCTRL	/* number of controls */
};

enum {
	BUFFER_UNUSED,
	BUFFER_READY,
	BUFFER_BUSY,
	BUFFER_DONE,
};

enum {
	FRAME_UNUSED,		/* Unused (no MCAPTURE) */
	FRAME_READY,		/* Ready to start grabbing */
	FRAME_GRABBING,		/* In the process of being grabbed into */
	FRAME_DONE,		/* Finished grabbing, but not been synced yet */
	FRAME_ERROR,		/* Something bad happened while processing */
};

/* exposure change state machine states */
enum {
	EXPO_CHANGED,
	EXPO_DROP_FRAME,
	EXPO_NO_CHANGE,
};

enum {
	FMT_BAYER,
	FMT_JANGGU,
	FMT_EPLITE,
};

struct ep800_frame {
	unsigned char *data;		/* Frame buffer */
	volatile int grabstate;		/* State of grabbing */
	unsigned char *curline;
	int curlinepix;
	int curpix;
};

struct ep800_scratch {
	unsigned char *data;
	volatile int state;
	int length;
};


/* specific webcam descriptor */
struct sd {
	struct gspca_dev gspca_dev;	/* !! must be the first item */
	struct v4l2_ctrl ctrls[NCTRL];
	struct v4l2_pix_format fmts[MAX_MODES];
	u8 restart_stream;
	u8 button_state;
	u8 resetlevel;
	u8 resetlevel_frame_count;
	int resetlevel_adjust_dir;
	int maxwidth;
	int maxheight;
	int nfmts;
	int packetsize;

	int maxframesize;	//framewidth*frameheight
	int format;             //compression format
	int curframe;		//current position in frame[]

	int scratch_next;	//active scratch

	//eplite state
	int eplite_curpix;
	int eplite_curline;
	unsigned char eplite_data[1024];
	//variable length decoder state
	int vlc_size;
	int vlc_cod;
	int vlc_data;
	
	struct v4l2_ctrl_handler ctrl_handler;
	struct v4l2_ctrl *gain;
	struct v4l2_ctrl *exposure;
	struct v4l2_ctrl *plfreq;

	struct ep800_frame frame[EP800_NUMFRAMES];	//rendered rgb24 color frame
	struct ep800_scratch scratch[EP800_NUMSCRATCH];	//queue of bayer bits received from urbs
};


/* Helpers for reading/writing integers to bytestrings */
#define INT2BSTR(val, buf) { (buf)[0]=(val)&255; (buf)[1]=(val)/256; }
#define BSTR2INT(buf) ((buf)[0]+(buf)[1]*256)

static void epcam_setcompression(struct gspca_dev *gspca_dev, u16 algo);
static void sd_isoc_irq(struct urb *urb);
static void setgain(struct gspca_dev *gspca_dev, int gain);
static void setexposure(struct gspca_dev *gspca_dev, int exposure);
static int ep800_s_ctrl(struct v4l2_ctrl *ctrl);
static int sd_init_controls(struct gspca_dev *gspca_dev);

static const struct v4l2_ctrl_ops ep800_ctrl_ops = {
        .s_ctrl = ep800_s_ctrl,
};


static void ep800_write_req(struct gspca_dev *gspca_dev, u16 req, u16 value,
			    int silent)
{
	int err;

	if (gspca_dev->usb_err < 0)
		return;

	err = usb_control_msg(gspca_dev->dev,
			      usb_sndctrlpipe(gspca_dev->dev, 0), req,
			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
			      value, 0, NULL, 0, HZ);
	if (err < 0) {
		if (!silent)
			pr_err("write req failed req %#04x val %#04x error %d\n",
			       req, value, err);
		gspca_dev->usb_err = err;
	}
}

static void ep800_write_bstr_req(struct gspca_dev *gspca_dev, u16 req, unsigned char *data, int size,
			    int silent)
{
	int err;

	if (gspca_dev->usb_err < 0)
		return;

	err = usb_control_msg(gspca_dev->dev,
			      usb_sndctrlpipe(gspca_dev->dev, 0), req,
			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
			      0, 0, data, size, HZ);
	if (err < 0) {
		if (!silent)
			pr_err("write req failed req %#04x error %d\n",
			       req, err);
		gspca_dev->usb_err = err;
	}
}

static void ep800_read_bstr_req(struct gspca_dev *gspca_dev, u16 req, unsigned char *data, int size,
                           int silent)
{
	int err;

	if (gspca_dev->usb_err < 0)
		return;

	if (USB_BUF_SZ < READ_REQ_SIZE) {
		pr_err("USB_BUF_SZ too small!!\n");
		gspca_dev->usb_err = -ENOBUFS;
		return;
	}

	err = usb_control_msg(gspca_dev->dev,
			      usb_rcvctrlpipe(gspca_dev->dev, 0), req,
			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
			      0, 0, data, size, HZ);
	if (err < 0) {
		if (!silent)
			pr_err("read req failed req %#04x error %d\n",
			       req, err);
		gspca_dev->usb_err = err;
	}
}

static void ep800_set_feature(struct gspca_dev *gspca_dev,
			      u16 selector, u16 param)
{
	int err;
        unsigned char cp[2];
        INT2BSTR(param, cp);

	if (gspca_dev->usb_err < 0)
		return;

	err = usb_control_msg(gspca_dev->dev,
			      usb_sndctrlpipe(gspca_dev->dev, 0),
			      EP800_REQ_SET_EXT_FEATURE,
			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
			      selector, 0, cp, 2, HZ);
	if (err < 0) {
		pr_err("set feature failed sel %#04x param %#04x error %d\n",
		       selector, param, err);
		gspca_dev->usb_err = err;
	}
}

static int ep800_get_feature(struct gspca_dev *gspca_dev, u16 selector)
{
	int err;

	if (gspca_dev->usb_err < 0)
		return gspca_dev->usb_err;

	if (USB_BUF_SZ < 2) {
		pr_err("USB_BUF_SZ too small!!\n");
		gspca_dev->usb_err = -ENOBUFS;
		return gspca_dev->usb_err;
	}

	err = usb_control_msg(gspca_dev->dev,
			      usb_rcvctrlpipe(gspca_dev->dev, 0),
			      EP800_REQ_GET_EXT_FEATURE,
			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
			      0, selector, gspca_dev->usb_buf, 2, HZ);
	if (err < 0) {
		pr_err("get feature failed sel %#04x error %d\n",
		       selector, err);
		gspca_dev->usb_err = err;
		return err;
	}
	return gspca_dev->usb_buf[0] | (gspca_dev->usb_buf[1] << 8);
}

static void epcam_setcompression(struct gspca_dev *gspca_dev, u16 algo)
{
        unsigned char cp[2];
	INT2BSTR(algo, cp);
	ep800_write_bstr_req(gspca_dev, EP800_REQ_COMPRESSION, cp, sizeof(cp), 1);
}

static void epcam_setsize(struct gspca_dev *gspca_dev, int width, int height)
{
	struct sd *sd = (struct sd *) gspca_dev;
        unsigned char cp[40];

        memset(cp,0,sizeof(cp));

	//get capture state
	ep800_read_bstr_req(gspca_dev, EP800_REQ_CAPTURE_INFO, cp, sizeof(cp), 1);
        INT2BSTR(1, cp+2); //mode
        INT2BSTR((sd->maxwidth-width)/2, cp+4);   //top left
        INT2BSTR((sd->maxheight-height)/2, cp+6); //top right
        INT2BSTR(width, cp+8);
        INT2BSTR(height, cp+10);

	//set size
	ep800_write_bstr_req(gspca_dev, EP800_REQ_CAPTURE_INFO, cp, sizeof(cp), 1);

        return;
}

static void setgain(struct gspca_dev *gspca_dev, int gain)
{
	u16 _gain = 63 - gain;

	/* red color gain */
	ep800_set_feature(gspca_dev, HV7131_REG_ARCG, _gain);
	/* green color gain */
	ep800_set_feature(gspca_dev, HV7131_REG_AGCG, _gain);
	/* blue color gain */
	ep800_set_feature(gspca_dev, HV7131_REG_ABCG, _gain);
}

static void setexposure(struct gspca_dev *gspca_dev, int exposure)
{
	struct sd *sd = (struct sd *) gspca_dev;
	unsigned int integration = exposure << 6;
	u8 expose_h, expose_m, expose_l;

	/* Do this before the set_feature calls, for proper timing wrt
	   the interrupt driven pkt_scan. Note we may still race but that
	   is not a big issue, the expo change state machine is merely for
	   avoiding underexposed frames getting send out, if one sneaks
	   through so be it */

	if (sd->ctrls[FREQ].val == V4L2_CID_POWER_LINE_FREQUENCY_50HZ)
		integration = integration - integration % 106667;
	if (sd->ctrls[FREQ].val == V4L2_CID_POWER_LINE_FREQUENCY_60HZ)
		integration = integration - integration % 88889;

	expose_h = (integration >> 16);
	expose_m = (integration >> 8);
	expose_l = integration;
	pr_info("Exposure: %d %d %d %d\n", sd->ctrls[EXPOSURE].val, expose_h, expose_m, expose_l);

	/* integration time low */
	ep800_set_feature(gspca_dev, HV7131_REG_TITL, expose_l);
	/* integration time mid */
	ep800_set_feature(gspca_dev, HV7131_REG_TITM, expose_m);
	/* integration time high */
	ep800_set_feature(gspca_dev, HV7131_REG_TITU, expose_h);
}

static int sd_config(struct gspca_dev *gspca_dev,
			const struct usb_device_id *id)
{
	struct sd *sd = (struct sd *)gspca_dev;
	struct cam *cam = &gspca_dev->cam;
	int i;
        unsigned char cp[40];
	int widths[4] = {160,320,640,800};
	int heights[4] = {120,240,480,600};

	/* Read the camera descriptor */
        memset(cp,0,sizeof(cp));
	ep800_read_bstr_req(gspca_dev, EP800_REQ_CAMERA_INFO, cp, sizeof(cp), 1);
	if (gspca_dev->usb_err) {
		/* Sometimes after being idle for a while the se401 won't
		   respond and needs a good kicking  */
		usb_reset_device(gspca_dev->dev);
		gspca_dev->usb_err = 0;
		ep800_read_bstr_req(gspca_dev, EP800_REQ_CAMERA_INFO, cp, sizeof(cp), 1);
	}

	for(i = 0; i<40;i+=2)
		pr_info("dump: %d    %d : 0x%x\n", i, BSTR2INT(cp+i), BSTR2INT(cp+i));

	//TODO: adjust nfmts based on model
	sd->nfmts=3;
	sd->maxwidth=widths[sd->nfmts-1];
	sd->maxheight=heights[sd->nfmts-1];
	sd->maxframesize = sd->maxwidth*sd->maxheight*3;

	/* Some cameras start with their LED on */
	ep800_write_req(gspca_dev, EP800_REQ_LED_CONTROL, 0, 0);
	if (gspca_dev->usb_err)
		return gspca_dev->usb_err;

	for (i = 0; i < sd->nfmts ; i++) {
		sd->fmts[i].width = widths[i];
		sd->fmts[i].height = heights[i];
		sd->fmts[i].field = V4L2_FIELD_NONE;
		sd->fmts[i].colorspace = V4L2_COLORSPACE_SRGB;
		sd->fmts[i].priv = 1;
		sd->fmts[i].pixelformat = V4L2_PIX_FMT_RGB24;
		sd->fmts[i].bytesperline = widths[i] * 3;
		sd->fmts[i].sizeimage = widths[i] * heights[i] * 3;
		pr_info("Frame size: %dx%d\n",
			widths[i], heights[i]);
	}

	cam->cam_mode = sd->fmts;
	cam->nmodes = sd->nfmts;
	cam->bulk = 0;
	sd->resetlevel = 0x2d; /* Set initial resetlevel */
	gspca_dev->cam.no_urb_create = 1;

	return 0;
}

/* this function is called at probe and resume time */
static int sd_init(struct gspca_dev *gspca_dev)
{
	return 0;
}

static int sd_isoc_init(struct gspca_dev *gspca_dev)
{
	gspca_dev->alt = 3 + 1;

        return 0;
}

/* -- start the camera -- */
static int sd_start(struct gspca_dev *gspca_dev)
{
	struct sd *sd = (struct sd *)gspca_dev;
	struct urb *urb;
	int i, n;
        struct usb_host_interface *alt;
        struct usb_interface *intf;

        /* Set the camera to Iso transfers */
	pr_info("altsetting before usb_set_interface %d", gspca_dev->alt);
        if (usb_set_interface(gspca_dev->dev, gspca_dev->iface, gspca_dev->alt)< 0) {
		pr_err("interface set failed2\n");
                return -1;
        }

        intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
        alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
	pr_info("altsetting for packetsize %d", sd->gspca_dev.alt);
        if (!alt) {
                pr_err("Couldn't get altsetting\n");
                sd->gspca_dev.usb_err = -EIO;
                return -1;
        }
        sd->packetsize = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);

	ep800_write_req(gspca_dev, EP800_REQ_CAMERA_POWER, 1, 1);
	if (gspca_dev->usb_err) {
		/* Sometimes after being idle for a while the se401 won't
		   respond and needs a good kicking  */
		usb_reset_device(gspca_dev->dev);
		gspca_dev->usb_err = 0;
		ep800_write_req(gspca_dev, EP800_REQ_CAMERA_POWER, 1, 0);
	}
	ep800_write_req(gspca_dev, EP800_REQ_LED_CONTROL, 1, 0);

	ep800_set_feature(gspca_dev, HV7131_REG_MODE_B, 0x5);
	setexposure(gspca_dev, 15000);
	ep800_set_feature(gspca_dev, HV7131_REG_MODE_C, 0xa);
	setgain(gspca_dev, 25);

	epcam_setsize(gspca_dev, gspca_dev->pixfmt.width, gspca_dev->pixfmt.height);
	epcam_setcompression(gspca_dev, EP800_COMPRESSION_BAYER);

	/* set size + mode */
	pr_info("setsize: width: %d height %d\n", gspca_dev->pixfmt.width, gspca_dev->pixfmt.height);

	ep800_write_req(gspca_dev, EP800_REQ_START_CONTINUOUS_CAPTURE, 1, 0);

	sd->format = FMT_BAYER;
	sd->restart_stream = 0;
	sd->resetlevel_frame_count = 0;
	sd->resetlevel_adjust_dir = 0;

	sd->frame[0].grabstate=FRAME_READY;
	sd->frame[1].grabstate=FRAME_UNUSED;
	sd->frame[0].curpix=0;
	sd->frame[1].curpix=0;
	sd->curframe=0;

	//sd->lastoffset=-1;
	sd->scratch_next=0;
	//sd->scratch_overflow=0;

	for (i=0; i<EP800_NUMFRAMES; i++) {
		sd->frame[i].data=kmalloc(sd->maxframesize, GFP_KERNEL);
		sd->frame[i].curpix=0;
	}

	for (i=0; i<EP800_NUMSCRATCH; i++) {
		sd->scratch[i].data=kmalloc(sd->packetsize*SD_NPKT, GFP_KERNEL);
		sd->scratch[i].state=BUFFER_UNUSED;
	}

	/* create 2 URBs - 2 on endpoint 0x81 */
#if MAX_NURBS < 4
#error "Not enough URBs in the gspca table"
#endif
	for (n = 0; n < SD_NURBS; n++) {
		pr_info("creating urb %d",n);
		urb = usb_alloc_urb(SD_NPKT, GFP_KERNEL);
		if (!urb) {
			pr_err("usb_alloc_urb failed\n");
			return -ENOMEM;
		}
		gspca_dev->urb[n] = urb;
		urb->transfer_buffer = usb_alloc_coherent(gspca_dev->dev,
						sd->packetsize * SD_NPKT,
						GFP_KERNEL,
						&urb->transfer_dma);
		if (urb->transfer_buffer == NULL) {
			pr_err("usb_alloc_coherent failed\n");
			return -ENOMEM;
		}
		urb->dev = gspca_dev->dev;
		urb->context = gspca_dev;
		urb->transfer_buffer_length = sd->packetsize * SD_NPKT;
		urb->pipe = usb_rcvisocpipe(gspca_dev->dev, 0x81);
		urb->transfer_flags = URB_ISO_ASAP
					 | URB_NO_TRANSFER_DMA_MAP;
		urb->interval = 1;
		urb->complete = sd_isoc_irq;
		urb->number_of_packets = SD_NPKT;
		for (i = 0; i < SD_NPKT; i++) {
			urb->iso_frame_desc[i].length = sd->packetsize;
			urb->iso_frame_desc[i].offset = sd->packetsize * i;
		}
	}

	ep800_set_feature(gspca_dev, HV7131_REG_ARLV, sd->resetlevel);

	pr_info("starting capture\n");

	return 0;
}

static void sd_stopN(struct gspca_dev *gspca_dev)
{
	struct sd *sd = (struct sd *)gspca_dev;
	int i;
	pr_info("sd_stopN called\n");
	ep800_write_req(gspca_dev, EP800_REQ_STOP_CONTINUOUS_CAPTURE, 0, 0);
	ep800_write_req(gspca_dev, EP800_REQ_LED_CONTROL, 0, 0);
	ep800_write_req(gspca_dev, EP800_REQ_CAMERA_POWER, 0, 0);

	for (i=0; i<EP800_NUMFRAMES; i++) {
		if (sd->frame[i].data) {
			kfree(sd->frame[i].data);
			sd->frame[i].data=NULL;
		}
	}
	for (i=0; i<EP800_NUMSCRATCH; i++) {
		if (sd->scratch[i].data) {
			kfree(sd->scratch[i].data);
			sd->scratch[i].data=NULL;
		}
	}
	for (i=0; i<SD_NURBS; i++) {
		if (gspca_dev->urb[i]->transfer_buffer) {
			pr_info("freeing gspca_dev->urb[%d]->transfer_buffer.data", i);
			usb_free_coherent(gspca_dev->dev,
						sd->packetsize * SD_NPKT,
						gspca_dev->urb[i]->transfer_buffer,
						gspca_dev->urb[i]->transfer_dma);
			gspca_dev->urb[i]->transfer_buffer=NULL;
		}
	}
}

static void sd_dq_callback(struct gspca_dev *gspca_dev)
{
	struct sd *sd = (struct sd *)gspca_dev;
	unsigned int ahrc, alrc;
	int oldreset, adjust_dir;
	pr_info("sd_dq_callback called");

	setexposure(gspca_dev, sd->exposure->val);

	/* Restart the stream if requested do so by pkt_scan */
	if (sd->restart_stream) {
		pr_info("restarting stream");
		sd_stopN(gspca_dev);
		sd_start(gspca_dev);
		sd->restart_stream = 0;
	}

	/* Automatically adjust sensor reset level
	   Hyundai have some really nice docs about this and other sensor
	   related stuff on their homepage: www.hei.co.kr */
	sd->resetlevel_frame_count++;
	if (sd->resetlevel_frame_count < 20)
		return;

	/* For some reason this normally read-only register doesn't get reset
	   to zero after reading them just once... */
	ep800_get_feature(gspca_dev, HV7131_REG_HIREFNOH);
	ep800_get_feature(gspca_dev, HV7131_REG_HIREFNOL);
	ep800_get_feature(gspca_dev, HV7131_REG_LOREFNOH);
	ep800_get_feature(gspca_dev, HV7131_REG_LOREFNOL);
	ahrc = 256*ep800_get_feature(gspca_dev, HV7131_REG_HIREFNOH) +
	    ep800_get_feature(gspca_dev, HV7131_REG_HIREFNOL);
	alrc = 256*ep800_get_feature(gspca_dev, HV7131_REG_LOREFNOH) +
	    ep800_get_feature(gspca_dev, HV7131_REG_LOREFNOL);

	/* Not an exact science, but it seems to work pretty well... */
	oldreset = sd->resetlevel;
	if (alrc > 10) {
		while (alrc >= 10 && sd->resetlevel < 63) {
			sd->resetlevel++;
			alrc /= 2;
		}
	} else if (ahrc > 20) {
		while (ahrc >= 20 && sd->resetlevel > 0) {
			sd->resetlevel--;
			ahrc /= 2;
		}
	}
	/* Detect ping-pong-ing and halve adjustment to avoid overshoot */
	if (sd->resetlevel > oldreset)
		adjust_dir = 1;
	else
		adjust_dir = -1;
	if (sd->resetlevel_adjust_dir &&
	    sd->resetlevel_adjust_dir != adjust_dir)
		sd->resetlevel = oldreset + (sd->resetlevel - oldreset) / 2;

	if (sd->resetlevel != oldreset) {
		sd->resetlevel_adjust_dir = adjust_dir;
		ep800_set_feature(gspca_dev, HV7131_REG_ARLV, sd->resetlevel);
	}

	sd->resetlevel_frame_count = 0;
}

static inline void decode_bayer (struct gspca_dev *gspca_dev, unsigned char *data, int len)
{
	struct sd *sd = (struct sd *) gspca_dev;
	int datasize=gspca_dev->pixfmt.width*gspca_dev->pixfmt.height;
	struct ep800_frame *frame=&sd->frame[sd->curframe];

	unsigned char *framedata=frame->data, *curline, *nextline;
	int width=gspca_dev->pixfmt.width;
	int blineoffset=0, bline;
	int linelength=width*3, i;

	//pr_info("decode_bayer called %d", len);

	/* Check if we have to much data */
	if (frame->curpix+len > datasize) {
		pr_info("to much! %d %d %d %d", datasize, frame->curpix, len, frame->curpix+len-datasize);
//		frame->curpix=0;
//		return;
		len=datasize-frame->curpix;
	}

	if (frame->curpix==0) {
		if (frame->grabstate==FRAME_READY) {
			frame->grabstate=FRAME_GRABBING;
		}
		/* Clear stuff the user might have put on this line */
		memset(framedata+datasize*3-linelength, 0, linelength);
		frame->curline=framedata+linelength*2;
		frame->curlinepix=0;
	}

	if (gspca_dev->pixfmt.height%4)
		blineoffset=1;
	bline=frame->curpix/gspca_dev->pixfmt.width+blineoffset;

	curline=frame->curline;
	nextline=curline+linelength;
	if (nextline >= framedata+datasize*3)
		nextline=curline;
	while (len) {
		if (frame->curlinepix>=width) {
			frame->curlinepix-=width;
			bline=frame->curpix/width+blineoffset;
			curline+=linelength*2;
			nextline+=linelength*2;
			if (curline >= framedata+datasize*3) {
				frame->curlinepix++;
				curline-=3;
				nextline-=3;
				len--;
				data++;
				frame->curpix++;
			}
			if (nextline >= framedata+datasize*3)
				nextline=curline;
		}
		if ((bline&1)) {
			if ((frame->curlinepix&1)) {
				*(curline+2)=*data;
				*(curline-1)=*data;
				*(nextline+2)=*data;
				*(nextline-1)=*data;
			} else {
				*(curline+1)=(*(curline+1)+*data)/2;
				*(curline-2)=(*(curline-2)+*data)/2;
				*(nextline+1)=*data;
				*(nextline-2)=*data;
			}
		} else {
			if ((frame->curlinepix&1)) {
				*(curline+1)=(*(curline+1)+*data)/2;
				*(curline-2)=(*(curline-2)+*data)/2;
				*(nextline+1)=*data;
				*(nextline-2)=*data;
			} else {
				*curline=*data;
				*(curline-3)=*data;
				*nextline=*data;
				*(nextline-3)=*data;
			}
		}
		frame->curlinepix++;
		curline-=3;
		nextline-=3;
		len--;
		data++;
		frame->curpix++;
	}
	frame->curline=curline;

	if (frame->curpix>=datasize) {
//	if (frame->curpix>=datasize-sd->packetsize) {
		/* Fix the top line */
		framedata+=linelength*2;
		for (i=0; i<linelength*2; i++) {
			framedata--;
			*(framedata)=*(framedata+linelength);
		}
		/* Fix the left side (green is already present) */
		for (i=0; i<gspca_dev->pixfmt.height; i++) {
			*framedata=*(framedata+3);
			*(framedata+1)=*(framedata+4);
			*(framedata+2)=*(framedata+5);
			framedata+=linelength;
		}
		framedata-=linelength*2;
		/* Bottom */
		for (i=0; i<linelength*2; i++) {
			framedata++;
			*(framedata)=*(framedata-linelength);
		}
		frame->curpix=0;
		frame->grabstate=FRAME_DONE;
		//pr_info("frame is done");
		gspca_frame_add(gspca_dev, FIRST_PACKET, sd->frame[sd->curframe].data, datasize*3);
		gspca_frame_add(gspca_dev, INTER_PACKET, sd->frame[sd->curframe].data, 0);
		gspca_frame_add(gspca_dev, LAST_PACKET, sd->frame[sd->curframe].data, 0);

		if (sd->frame[(sd->curframe+1)&(EP800_NUMFRAMES-1)].grabstate==FRAME_READY) {
			sd->curframe=(sd->curframe+1) & (EP800_NUMFRAMES-1);
		}
	}
}

static inline void decode_eplite_integrate(struct gspca_dev *gspca_dev, int data)
{
	struct sd *sd = (struct sd *) gspca_dev;
	int linelength=gspca_dev->pixfmt.width;
	int i;

	/* First two are absolute, all others relative.
	 */
	if (sd->eplite_curpix < 2) {
		*(sd->eplite_data+sd->eplite_curpix)=1+data*4;
	} else {
		*(sd->eplite_data+sd->eplite_curpix)=i=
		    *(sd->eplite_data+sd->eplite_curpix-2)+data*4;
		if (i>255 || i<0) {
			;
			//sd->lastoffset=-1;
			//sd->datacorrupt++;
		}
	}

	sd->eplite_curpix++;

	if (sd->eplite_curpix>=linelength) {
		decode_bayer(gspca_dev, sd->eplite_data, linelength);

		sd->eplite_curpix=0;
		sd->eplite_curline+=linelength;
		if (sd->eplite_curline>=gspca_dev->pixfmt.height*linelength)
			sd->eplite_curline=0;
	}
}

static inline void decode_eplite (struct gspca_dev *gspca_dev, unsigned char *data, int len)
{
	struct sd *sd = (struct sd *) gspca_dev;
	int i;

	struct ep800_frame *frame=&sd->frame[sd->curframe];

	int pos=0;
	int vlc_cod;
	int vlc_size;
	int vlc_data;
	int bit_cur;

	int bit;

	/* Check for cancelled frames: */
	for (i=0; i<len-3; i++) {
		if (data[i]==0xff && data[i+1]==0xff && data[i+2]==0xff && data[i+3]==0xff) {
			frame->curpix=0;
			return;
		}
	}

	/* New image? */ 
	//handled in decode_bayer
	//if (!offset) {
	//	frame->curpix=0;
	//}
	if (!frame->curpix) {
		sd->eplite_curline=0;
		sd->eplite_curpix=0;
		sd->vlc_cod=0;
		sd->vlc_data=0;
		sd->vlc_size=0;
		if (frame->grabstate==FRAME_READY)
			frame->grabstate=FRAME_GRABBING;
	}

	vlc_cod=sd->vlc_cod;
	vlc_size=sd->vlc_size;
	vlc_data=sd->vlc_data;

	while (pos < len && frame->grabstate==FRAME_GRABBING) {
		bit_cur=8;
		while (bit_cur) {
			bit=((*data)>>(bit_cur-1))&1;
			if (!vlc_cod) {
				if (bit) {
					vlc_size++;
				} else {
					if (!vlc_size) {
						decode_eplite_integrate(gspca_dev, 0);
					} else {
						vlc_cod=2;
						vlc_data=0;
					}
				}
			} else {
				if (vlc_size > 7) {
					//sd->datacorrupt++;
					//sd->lastoffset=-1;
					return;
				}
				if (vlc_cod==2) {
					if (!bit) vlc_data=-(1<<vlc_size)+1;
					vlc_cod--;
				}
				vlc_size--;
				vlc_data+=bit<<vlc_size;
				if (!vlc_size) {
					decode_eplite_integrate(gspca_dev, vlc_data);
					vlc_cod=0;
				}
			}
			bit_cur--;
		}
		pos++;
		data++;

	}

	/* Store variable-lengt-decoder state if in middle of frame */
	if (frame->grabstate==FRAME_GRABBING) {
		sd->vlc_size=vlc_size;
		sd->vlc_cod=vlc_cod;
		sd->vlc_data=vlc_data;
	} else {
		/* If there is data left regard image as corrupt */
		if (len-pos > sd->packetsize) {
			pr_info("len-pos: %d\n", len-pos);
			frame->grabstate=FRAME_GRABBING;
			//sd->datacorrupt++;
		}
		//sd->lastoffset=-1;
	}
}

/* reception of an URB */
static void sd_isoc_irq(struct urb *urb)
{
	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
	struct sd *sd = (struct sd *) gspca_dev;

	int i, st;
	int length = 0;

	//pr_info("sd_isoc_irq called\n");
	//PDEBUG(D_PACK, "sd isoc irq");
	if (!gspca_dev->streaming)
	{
		pr_info("it stopped streaming");
		return;
	}

/*	if (urb->status != 0) {
		if (urb->status == -ESHUTDOWN)
			return;		// disconnection
#ifdef CONFIG_PM
		if (gspca_dev->frozen)
			return;
#endif
		PDEBUG(D_ERR, "urb status: %d", urb->status);
		st = usb_submit_urb(urb, GFP_ATOMIC);
		if (st < 0)
			pr_err("resubmit urb error %d\n", st);
		goto resubmit;
	}*/

	switch(sd->scratch[sd->scratch_next].state) {
		case BUFFER_READY:
		case BUFFER_BUSY: {
			break;
		}
		case BUFFER_UNUSED: {
			for (i=0; i<SD_NPKT; i++) {
				if (urb->iso_frame_desc[i].actual_length) {
					memcpy(
					 sd->scratch[sd->scratch_next].data+length,
					 (unsigned char *)urb->transfer_buffer+urb->iso_frame_desc[i].offset,
					 urb->iso_frame_desc[i].actual_length);
					 length+=urb->iso_frame_desc[i].actual_length;
				}
			}
			if (length) {
				sd->scratch[sd->scratch_next].state=BUFFER_READY;
				sd->scratch[sd->scratch_next].length=length;
//				if (waitqueue_active(&sd->wq))
////					wake_up_interruptible(&sd->wq);
				//sd->scratch_overflow=0;
				// New image?
//				if (!sd->scratch[sd->scratch_next].offset) {
//					pr_info("new frame detected");
//					sd->frame[sd->curframe].curpix=0;
//				}
				if (sd->format==FMT_EPLITE) {
					decode_eplite(gspca_dev, sd->scratch[sd->scratch_next].data,
					                         sd->scratch[sd->scratch_next].length);
				} else {
					decode_bayer(gspca_dev, sd->scratch[sd->scratch_next].data,
					                        sd->scratch[sd->scratch_next].length);
				}

				sd->scratch[sd->scratch_next].state=BUFFER_UNUSED;
				sd->scratch_next++;
				if (sd->scratch_next>=EP800_NUMSCRATCH)
					sd->scratch_next=0;

			}
		}
	}

//resubmit:
        /* resubmit the URB */
        st = usb_submit_urb(urb, GFP_ATOMIC);
        if (st < 0)
                pr_err("usb_submit_urb() ret %d\n", st);
}

//For snapshot button
#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
static int sd_int_pkt_scan(struct gspca_dev *gspca_dev, u8 *data, int len)
{
	struct sd *sd = (struct sd *)gspca_dev;
	u8 state;

	pr_info("sd_int_pkt_scan called\n");
	if (len != 2)
		return -EINVAL;

	switch (data[0]) {
	case 0:
	case 1:
		state = data[0];
		break;
	default:
		return -EINVAL;
	}
	if (sd->button_state != state) {
		input_report_key(gspca_dev->input_dev, KEY_CAMERA, state);
		input_sync(gspca_dev->input_dev);
		sd->button_state = state;
	}

	return 0;
}
#endif

/* sub-driver description */
static const struct sd_desc sd_desc = {
	.name = MODULE_NAME,

.config = sd_config,
	.init = sd_init,
	.init_controls = sd_init_controls,
	.isoc_init = sd_isoc_init,
	.start = sd_start,
	.stopN = sd_stopN,
	.dq_callback = sd_dq_callback,
#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
	.int_pkt_scan = sd_int_pkt_scan,
#endif
};

/* -- module initialisation -- */
static const struct usb_device_id device_table[] = {
        {USB_DEVICE(0x03e8, 0x1005)}, /* Endpoints EP800 */
        {USB_DEVICE(0x03e8, 0x1003)}, /* Endpoints SE402 */
        {USB_DEVICE(0x03e8, 0x1000)}, /* Endpoints SE401 */
        {USB_DEVICE(0x03e8, 0x2112)}, /* SpyPen Actor */
        {USB_DEVICE(0x03e8, 0x2040)}, /* Rimax Slim Multicam */
        {USB_DEVICE(0x03e8, 0x1010)}, /* Concord Eye-Q Easy */
        {USB_DEVICE(0x041e, 0x400d)}, /* Creative PD1001 */
        {USB_DEVICE(0x04f2, 0xa001)}, /* Chicony DC-100 */
        {USB_DEVICE(0x08ca, 0x0102)}, /* Aiptek Pencam 400 */
        {USB_DEVICE(0x03e8, 0x2182)}, /* Concord EyeQ Mini */
        {USB_DEVICE(0x03e8, 0x2123)}, /* Sipix StyleCam */
	{}
};
MODULE_DEVICE_TABLE(usb, device_table);

/* -- device connect -- */
static int sd_probe(struct usb_interface *intf,
			const struct usb_device_id *id)
{
	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
				THIS_MODULE);
}

static int sd_pre_reset(struct usb_interface *intf)
{
	return 0;
}

static int sd_post_reset(struct usb_interface *intf)
{
	return 0;
}

//needs testing
static int ep800_s_ctrl(struct v4l2_ctrl *ctrl)
{
        struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
        struct gspca_dev *gspca_dev = &sd->gspca_dev;

        gspca_dev->usb_err = 0;
        if (!gspca_dev->streaming)
                return 0;

        switch (ctrl->id) {
        case V4L2_CID_GAIN:
                if (!gspca_dev->usb_err && !ctrl->val && sd->gain)
                        setgain(gspca_dev, ctrl->val);
                break;
        case V4L2_CID_EXPOSURE:
                if (!gspca_dev->usb_err && ctrl->val == V4L2_EXPOSURE_MANUAL &&
                    sd->exposure)
                        setexposure(gspca_dev, ctrl->val);
                break;
        case V4L2_CID_POWER_LINE_FREQUENCY:
				setexposure(gspca_dev, sd->exposure->val);
                break;
        }
        return gspca_dev->usb_err;
}

static int sd_init_controls(struct gspca_dev *gspca_dev)
{
    struct sd *sd = (struct sd *) gspca_dev;
    struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
    
	/* parameters with different values between the supported sensors */
	int exposure_min;
	int exposure_max;
	int exposure_def;
	int hflip_def;

	exposure_min = 0;
	exposure_max = 32767;
	exposure_def = 15000;
	hflip_def = 0;

	v4l2_ctrl_handler_init(hdl, 13);

	sd->gain = v4l2_ctrl_new_std(hdl, &ep800_ctrl_ops,
					V4L2_CID_GAIN, 0, 50, 1, 25);

	sd->exposure = v4l2_ctrl_new_std(hdl, &ep800_ctrl_ops,
					V4L2_CID_EXPOSURE, exposure_min, exposure_max, 1,
					exposure_def);

	sd->plfreq = v4l2_ctrl_new_std_menu(hdl, &ep800_ctrl_ops,
					V4L2_CID_POWER_LINE_FREQUENCY,
					0, V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
					V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
	

	if (hdl->error) {
			pr_err("Could not initialize controls\n");
			return hdl->error;
	}

	return 0;
}

static struct usb_driver sd_driver = {
	.name = MODULE_NAME,
	.id_table = device_table,
	.probe = sd_probe,
	.disconnect = gspca_disconnect,
#ifdef CONFIG_PM
	.suspend = gspca_suspend,
	.resume = gspca_resume,
#endif
	.pre_reset = sd_pre_reset,
	.post_reset = sd_post_reset,
};

module_usb_driver(sd_driver);
