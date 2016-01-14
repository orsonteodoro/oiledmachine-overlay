# oiledmachine-overlay
This portage overlay contains various ebuilds for the Gentoo Linux Distribution.

In this overlay, I provide 32 bit ebuilds for libraries and programs of some programs while the Gentoo overlay contains native ebuilds.  Reason why I choose to use the 32-bit versions over the 64-bit versions because of the 32 bit versions have a lower virtual memory and lower memory footprint overall.  I only offer the stable modified ebuilds to minimize memory leaks.

Here is an example of what I mean.

*www-client/firefox - 32 bit only builds on a AMD64 machine.  You can still build the 64 bit version.

*www-client/chromium - 32 bit only builds on a AMD64 machine.  You can still build the 64 bit version.

*net-libs/webkit-gtk - 32 bit only builds on a AMD64 machine.  You can still build the 64 bit version.  FTLJIT enabled webkit.  FTLJIT is disabled on the main Gentoo overlay.  (FTLJIT needs testing).

*www-client/surf - WebkitGTK browser with built in Ad-blocking support even in SSL.  Fixes to support for Facebook.  Support for GTK3 smooth scrolling.  Support for external MIME, external Flash video for some sites, and link highlighting.

*sci-misc/boinc-server - This is essentially the Bonic Server Maker with my personal helper scripts.  The Science overlay and Gentoo overlay do not have this.  Use emerge --config boinc-server to create your own Boinc Server project with the boinc-server-maker.  It will do everything for you except installing the application.  You must provide the executibles and template files.  See sci-misc/boinc-server-project-coinking and sci-misc/boinc-server-project-eligius for examples on how to integrate your application.  You should be able to edit those helper scripts (e.g. fresh-update, update_app) to fit your project.  Copy and use update-binaries script in your project every time you upgrade your server.

*sci-misc/boinc-server-project-coinking - Coinking Mining Pool Boinc Server Project example.

*sci-misc/boinc-server-project-eligius - Eligius Mining Pool Boinc Server Project example.

*sci-misc/setiathome-gpu - Seti@home version 7/8 client for CPU.  Added 3D Boinc screensaver support on GPUs which is not part of the official sources.  Support for recommended GPU settings.  Using ati_hd5xxx ati_hdx7xx for example targets ATI HD 57xx edition.

*sci-misc/setiathome-cpu - Seti@Home version 7/8 client for the CPUs.  Support for ebuild level GCC/LLVM PGO for all.

*sci-misc/astropulse-cpu - Astropulse version 7/8 client for CPUs.  Support for ebuild level GCC/LLVM PGO for all.

*sci-misc/astropulse-gpu - Astropulse version 7/8 client for GPUs.

*sci-misc/setiathome-art - Seti@home Art Assets to prevent merging conflicts.

*sci-misc/astropulse-art - Astropulse Art Assets to prevent merging conflicts.

*sci-misc/setiathome-cfg - Updates anonymous platform configuration files for setiathome-{cpu,gpu},astropulse-{cpu,gpu}.  You must run this every time you upgrade setiathome-{cpu,gpu} and/or astropulse-{cpu,gpu}.

*net-misc/boinc-bfgminer-gpu - BFGMiner with Boinc support for GPUs.  It requires the Boinc Wrapper sample app.  See sci-misc/boinc-server-project-eligius ebuild on in how to use it.  The reason why I have Boinc support so we can have the Boinc client manage project switching or CPU/GPU resources based on user activity (e.g. mouse move).

*net-misc/boinc-bfgminer-cpu - BFGMiner with Boinc support for CPUs.  It requires the Boinc Wrapper sample app.  Ebuild level support for Profile Guided Optimizations (PGO).

*app-emulation/genymotion - Genymotion with third party hacks support.  Support for installers from genymotion.com and extra dependency checks.

*net-misc/bitlbee - Fixed support for Skype through libpurple.  I haven't uploaded this upstream.

*x11-wm/dwm - Integrated Fibonacci layout

*app-eselect/eselect-opencl - Switch between SDK libraries and driver OpenCL implementation.

TODO:

*net-analyzer/wireshark - integrate MTP (Media Transfer Protocol) packet filter into ebuild.  Currently patches are stored in seperate my /etc/portage/patches

*media-video/libmtp - MTP/IP partial support.  Currently patches are stored in seperate my /etc/portage/patches

*System-wide PGO (Profile Guided Optimization) for /etc/portage/bashrc.  I will release this soon after sufficient testing.  It is in testing phase.  It has @pgo-update set support.  It requires GCC or LLVM/Clang >=3.7 support since <3.7 breaks library profiling and has an annoying set environmental variable feature before profiling.  We use --profile-generate instead on LLVM/Clang.  Users need to be added to the wheel group to simulate the program.
