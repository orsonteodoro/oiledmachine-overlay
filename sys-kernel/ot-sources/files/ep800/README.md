gspca_ep800
===========

This is a linux driver for the Endpoints EP800/SE402/SE401* driver.  This driver is based on Jeroen B. Vreeken 
EP800 driver and is simply adapted to the newer GSPCA driver framework.

The driver is released under the terms of the GPL Version 2 (or newer).

Linux Kernel 3.4.x is currently supported.

*SE401 is supported only for newer firmware.

Potential problems that you may encounter
-----------------------------------------
If you compile a newer kernel and compile this immediately afterward and forgot to restart, you will get missing symbols in dmesg.  You need to restart the new kernel and recompile the driver again.

Changes
-------
20160125 Compiled successfully against Kernel 4.1.2.  Still needs testing.  Code updates were about fixing missing structs.  No features were lost or gain.  Makefile was added to compile driver seperately.
