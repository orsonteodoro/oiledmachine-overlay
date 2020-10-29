#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# This Firejail profile is for the sheepit-client using the no-repacks USE flag
# (meaning that tarballs come frome downloads.blender.org)
# Status:  Work In Progress (WIP) / Testing
# TODO:  Add more blacklist rules for dev tools, usr/libexec, opt/icedtea-bin, internal python
# TODO:  Blacklist rules to block compilation
# TODO:  Add netfilter firewall rules
# TODO:  Apparmor support

# Uncomment (*) sections and use an interactive shell and do to find missing
# libs:
#
#   for f in $(find . -executable -type f) ; do echo "inspecting ${f}" ; \
#   ldd "${f}" | grep "not found" ; done
#
# Add the missing libs with the private-libs rule.
#
# To use the interactive shell run:
# firejail --profile=/etc/firejail/sheepit-client.profile bash

# Add OpenCL driver and Java overrides in here
include sheepit-client.local
include globals.local

# We need to do this per rule because the missing symlink in java-config-2
# caused by inexact reconstruction of symlink in /etc/java-config-2 in firejail
# with private-etc in vm_handle in the /usr/bin/java wrapper.

blacklist /usr/lib32
blacklist /lib32

whitelist /etc/ca-certificates
whitelist /etc/java-config-2
whitelist /etc/ld.so.cache
whitelist /etc/ld.so.preload
whitelist /etc/OpenCL
whitelist /etc/resolv.conf
whitelist /etc/ssl
whitelist /etc/vulkan
# For auto-restoring service password.  Disable if you don't need auto-restore.
whitelist /etc/passwd

# (*) etc paths allowed for debugging only.  Disable when not in use
#whitelist /etc/bash
#whitelist /etc/terminfo

whitelist /usr/share/blender
whitelist /usr/share/cursors
whitelist /usr/share/fonts
whitelist /usr/share/gtk-2.0
whitelist /usr/share/gtk-3.0
whitelist /usr/share/icons
whitelist /usr/share/java-config-2
whitelist /usr/share/jna
whitelist /usr/share/sheepit-client
whitelist /usr/share/vulkan
whitelist /usr/share/zenity
whitelist /opt/amdgpu
whitelist /opt/amdgpu-pro
whitelist /opt/icedtea-bin-3.16.0

include allow-java.inc
include disable-devel.inc

# Allow usage of AMD GPU by OpenCL
noblacklist /sys/module
whitelist /sys/module/amdgpu
read-only /sys/module/amdgpu

disable-mnt
noautopulse
nodbus
nodvd
nogroups
notv
nou2f
novideo
nosound
x11 xorg
hostname sheepit-client
shell none

# To reduce the attack surface, we limiting libraries and executibles visible.
# More code ∝ (is proportional to) more bugs.
# More libraries ∝ (is proportional to) more vulnerabilities.

private-dev
private-home .sheepit.conf,.sheepit-client
mkdir ${HOME}/.cache

# (*) For sheepit-client wrapper
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
#private-bin bash,basename,cut,echo,find,grep,groups,kdialog,killall,md5sum
#private-bin mkdir,rm,stat,which,zenity

# For blender
private-bin X11

# For java compatibility in tiling managers
private-bin wmname

# For debugging this profile
#private-bin find,grep,ldd,less,ls,strings,wc

# For Firejail
private-bin xauth

# For java
private-bin echo,id,java,readlink,sh,uname

# For sheepit-client
private-bin bash,id,ldd,nice,sheepit-client

# For no-repacks
private-bin tar,gzip,xz

# For tar and gzip
private-lib ld-linux-x86-64.so.*,libacl.so.*,libc.so.*

# For xz
private-lib ld-linux-x86-64.so.*,libc.so.*,liblzma.so.*,libpthread.so.*

# For bz2
private-lib ld-linux-x86-64.so.*,libbz2.so.*,libc.so.*

# For sheepit-client shutdown support
#private-bin shutdown

# For icedtea-bin jre
private-lib gcc,jvm,ld-linux-x86-64.so.*,libbsd.so.*,libbz2.so.*,libc.so.*
private-lib libdl.so.*,libexpat.so.*,libfontconfig.so.*,libfreetype.so.*
private-lib libgif.so.*,libjpeg.so.*,liblcms2.so.*,libm.so.*,libpng16.so.*
private-lib libpthread.so.*,libstdc++.so.*,libthread_db.so.*,libuuid.so.*
private-lib libX11.so.*,libXau.so.*,libXcomposite.so.*,libXdmcp.so.*
private-lib libXext.so.*,libXi.so.*,libXrender.so.*,libXtst.so.*,libz.so.*
# private-lib libasound.so.* # disabled because sound is disabled

# For jna
private-lib jna,ld-linux-x86-64.so.*,libffi.so.*,libc.so.*

# For id, nice (used by sheepit-client)
private-lib ld-linux-x86-64.so.*,libc.so.*,

# For sh (used by java wrappers from eselect-java ; sh is just a symlink to bash) ; bash (used by sheepit-client)
private-lib ld-linux-x86-64.so.*,libreadline.so.*,libtinfo.so.*,libc.so.*,libtinfow.so.*

# For grep (used by sheepit-client wrapper)
private-lib ld-linux-x86-64.so.*,libc.so.*,libpcre.so.*,libpthread.so.*

# For killall (used by sheepit-client wrapper to remove zombie)

# For wmname
#private-lib ld-linux-x86-64.so.*,libbsd.so.*,libc.so.*,libdl.so.*,libX11.so.*
#private-lib libXau.so.*,libXdmcp.so.*,libxcb.so.*

# For zenity (used in the sheepit-client wrapper to report errors on desktop)
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
#private-lib ld-linux-x86-64.so.*,libatk-1.0.so.*,libatk-bridge-2.0.so.*
#private-lib libatspi.so.*,libblkid.so.*,libbsd.so.*,libbz2.so.*,libc.so.*
#private-lib libcairo.so.*,libcairo-gobject.so.*,libdbus-1.so.*,libdl.so.*
#private-lib libGL.so.*,libgdk-3.so.*,libgdk_pixbuf-2.0.so.*,libglib-2.0.so.*
#private-lib libgmodule-2.0.so.*,libgobject-2.0.so.*,libgraphite2.so.*
#private-lib libgtk-3.so.*,libEGL.so.*,libepoxy.so.*,libexpat.so.*,libffi.so.*
#private-lib libfribidi.so.*,libfontconfig.so.*,libfreetype.so.*,libgio-2.0.so.*
#private-lib libharfbuzz.so.*,libm.so.*,libmount.so.*,libpango-1.0.so.*
#private-lib libpangocairo-1.0.so.*,libpangoft2-1.0.so.*,libpcre.so.*
#private-lib libpixman-1.so.*,libpng16.so.*,libpthread.so.*,libresolv.so.*
#private-lib libuuid.so.*,libX11.so.*,libXau.so.*,libXcursor.so.*
#private-lib libXcomposite.so.*,libXdamage.so.*,libXdmcp.so.*,libXfixes.so.*
#private-lib libXext.so.*,libGLX.so.*,libGLdispatch.so.*,libXrandr.so.*
#private-lib libXi.so.*,libXrender.so.*,libxcb.so.*,libxcb-shm.so.*
#private-lib libxcb-render.so.*,libz.so.*

# For the AMDGPU drivers
private-lib gcc,llvm,xorg,ld-linux-x86-64.so.*,libbsd.so.*,libc.so.*,libdl.so.*
private-lib libdrm.so.*,libdrm_amdgpu.so.*,libdrm_radeon.so.*,libedit.so.*
private-lib libelf.so.*,libexpat.so.*,libgbm.so.*,libffi.so.*,libglapi.so.*
private-lib libm.so.*,libpcre.so.*,libpthread.so.*,librt.so.*,libselinux.so.*
private-lib libstdc++.so.*,libxshmfence.so.*,libtinfo.so.*,libudev.so.*
private-lib libX11.so.*,libX11-xcb.so.*,libXau.so.*,libXdamage.so.*
private-lib libXdmcp.so.*,libXext.so.*,libXfixes.so.*,libXxf86vm.so.*
private-lib libxcb.so.*,libxcb-dri2.so.*,libxcb-dri3.so.*,libxcb-xfixes.so.*
private-lib libxcb-glx.so.*,libxcb-present.so.*,libxcb-sync.so.*,libz.so.*
private-lib libwayland-server.so.*,libwayland-client.so.*

# For xauth
private-lib ld-linux-x86-64.so.*,libbsd.so.*,libc.so.*,libdl.so.*,libX11.so.*
private-lib libXau.so.*,libXext.so.*,libXdmcp.so.*,libXmuu.so.*

# For Blender 2.79b-2.90.0 vanilla
private-lib gcc,ld-linux-x86-64.so.*,libbsd.so.*,libc.so.*,libdl.so.*,libm.so.*
private-lib libpthread.so.*,librt.so.*,libutil.so.*,libGL.so.*,libGLX.so.*
private-lib libGLdispatch.so.*,libX11.so.*,libXau.so.*,libXdmcp.so.*
private-lib libXext.so.*,libXi.so.*,libXfixes.so.*,libXrender.so.*
private-lib libXxf86vm.so.*,libxcb.so.*

# For Blender 2.79b-2.90.0 libs folder
private-lib gcc,libbsd.so.*,libc.so.*,libdl.so.*,libglapi.so.*,libGL.so.*
private-lib libGLX.so.*,libGLdispatch.so.*,libm.so.*,libpthread.so.*
private-lib libX11.so.*,libXau.so.*,libxcb.so.*,libXdmcp.so.*,libXext.so.*
private-lib libz.so.*

# For Blender 2.79b-2.90.0 python
private-lib ld-linux-x86-64.so.*,libc.so.*,libcrypt.so.*,libdl.so.*,libm.so.*
private-lib libncursesw.so.*,libnsl.so.*,libpanelw.so.*,libpthread.so.*
private-lib libutil.so.*,libstdc++.so.*,libtinfo.so.*,libtinfow.so.*

# For openvdb
private-lib libGLU.so.*,libglfw.so.*

# For mesa drivers - libvulkan_radeon.so
private-lib libxcb-randr.so.*

# For mesa libEGL_mesa.so.0.0.0
private-lib libxcb-xfixes.so.*

# For cycles and OpenCL.java
private-lib libOpenCL.so.*

# Required if not using internal python to avoid: ModuleNotFoundError: No module named 'encodings'
#private-lib python2.7
#private-lib python3.6
#private-lib python3.7
#private-lib python3.8

private-tmp
