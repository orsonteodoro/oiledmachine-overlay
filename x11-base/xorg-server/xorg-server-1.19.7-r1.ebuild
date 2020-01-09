# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DOC=doc
inherit xorg-2 multilib versionator flag-o-matic
EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/xserver.git"

DESCRIPTION="X.Org X servers"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

IUSE_SERVERS="dmx kdrive wayland xephyr xnest xorg xvfb"
IUSE="${IUSE_SERVERS} debug ipv6 libressl minimal selinux +suid systemd tslib +udev unwind xcsecurity"

CDEPEND=">=app-eselect/eselect-opengl-1.3.0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl )
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.46
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-libs/xtrans-1.3.5
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-2.4.1-r3
	dmx? (
		x11-libs/libXt
		>=x11-libs/libdmx-1.0.99.1
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXaw-1.0.4
		>=x11-libs/libXext-1.0.99.4
		>=x11-libs/libXfixes-5.0
		>=x11-libs/libXi-1.2.99.1
		>=x11-libs/libXmu-1.0.3
		x11-libs/libXrender
		>=x11-libs/libXres-1.0.3
		>=x11-libs/libXtst-1.0.99.2
	)
	kdrive? (
		>=x11-libs/libXext-1.0.5
		x11-libs/libXv
	)
	xephyr? (
		x11-libs/libxcb[xkb]
		x11-libs/xcb-util
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
	!minimal? (
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXext-1.0.5
		>=media-libs/mesa-10.3.4-r1[X(+),egl,gbm]
		media-libs/libepoxy[X,egl(+)]
		!x11-libs/glamor
	)
	tslib? ( >=x11-libs/tslib-1.0 )
	udev? ( >=virtual/udev-150 )
	unwind? ( sys-libs/libunwind )
	wayland? (
		>=dev-libs/wayland-1.3.0
		media-libs/libepoxy
		>=dev-libs/wayland-protocols-1.1
	)
	>=x11-apps/xinit-1.3.3-r1
	systemd? (
		sys-apps/dbus
		sys-apps/systemd
	)"

DEPEND="${CDEPEND}
	sys-devel/flex
	x11-base/xorg-proto
	dmx? (
		doc? (
			|| (
				www-client/links
				www-client/lynx
				www-client/w3m
			)
		)
	)"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-xserver )
	!x11-drivers/xf86-video-modesetting
"

PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(get_version_component_range 1-2)
		 <x11-base/xorg-drivers-1.20 )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)
	xephyr? ( kdrive )"

#UPSTREAMED_PATCHES=(
#	"${WORKDIR}/patches/"
#)

# CVE fixes, crash, leak mitigation

# todo: check if backport required in commented out commits
SRC_URI+="
	https://gitlab.freedesktop.org/xorg/xserver/commit/14be894b3f7976c133fc186e0e3c475606bab241.patch -> xorg-server-9999-Xext-Fix-memory-leaks-in-hashtable.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/3336291fc68444ee65b48ba675ec947e505fed57.patch -> xorg-server-9999-test-Return-error-from_simple-xinit_if-the-client-crashes.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/6abdb54a11dac4e8854ff94ecdcb90a14321ab31.patch -> xorg-server-9999-modesetting-Fix-leak-of-tile_blob-in-drmmode_output_destroy.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/2af0a50a4bb9be9f58681d417ceb9a7029caaf3b.patch -> xorg-server-9999-randr-Fix-a-crash-on-initialization-with-GPU-screens.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/7d689f049c3cc16b8e0cb0103a384a2ceb84ea33.patch -> xorg-server-9999-xfree86-Fix-Option-MaxClients-validation.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/f0a5c0d1fdaeee3cd701215f4f57b7eacaf783c2.patch -> xorg-server-9999-glamor-fix-leak-of-fs_getcolor_source.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/cad3a1a82da3c8421b5cc98af27a779a38b5c709.patch -> xorg-server-9999-posix_tty-free-leak-of-xf86SetStrOption-return-value.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/50c0cf885a6e91c0ea71fb49fa8f1b7c86fe330e.patch -> xorg-server-9999-Disable_-logfile-and_-modulepath-when-running-with-elevated-privileges.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/2aec5c3c812ffe4a85b5e62452b244819a812dd6.patch -> xorg-server-9999-glx-Fix-potential-crashes-in-glXWait-GL-X.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/fabc4219622f3c0b41b1cb897c46e092377059e3.patch -> xorg-server-9999-Fix-crash-on-XkbSetMap-1.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/8469bfead9515ab3644f1769a1ff51466ba8ffee.patch -> xorg-server-9999-Fix-crash-on-XkbSetMap-2.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/0a07446318f248b65fcbc8ab8a73ead51153f09e.patch -> xorg-server-9999-xwayland-Avoid-a-crash-on-pointer-enter-with-a-grab.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/d0850241c6218f61127c45c2f95d6e791c3fea44.patch -> xorg-server-9999-xwayland-Expand-the-RANDR-screen-size-limits.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/7667180fb9dbd606e40c000aefc807371d2fb478.patch -> xorg-server-9999-glamor_egl-check-for-non-NULL-pixmap-at-egl_close_screen.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/429ee86ab949d6e49c07491a88d6b8d8babc3246.patch -> xorg-server-9999-udev-Fixed-NULL-pointer-argument-of-strcmp.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/e693c9657f98c334e9921ca2f8ebf710497c0c6a.patch -> xorg-server-9999-dix-Check-for-NULL-spriteInfo-in-GetPairedDevice.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/744c419cb4eaed4006b5f0f319b72d7ffa9fbc6d.patch -> xorg-server-9999-glamor-check-for-non-NULL-pixmap-at-close_screen.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/4308f5d3d1fbd0f5dce81e22c0c3f08c65a7c9d8.patch -> xorg-server-9999-os-Dont-crash-in-AttendClient-if-the-client-is-gone.patch
"

SRC_URI_TRASH="
#	https://gitlab.freedesktop.org/xorg/xserver/commit/cba5a10fd93310702cad9dbe1e6d48da99f5552f.patch -> xorg-server-9999-ramdac-Check-sPriv-ne-NULL-in-xf86CheckHWCursor-fn.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/555e0a42d138ac8d83af62638752a1bebad602d6.patch -> xorg-server-9999-randr-fix-xserver-crash-when-xrandr-setprovideroutputsource.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/f1f865e909090406841a9b9416ea6259a75c2086.patch -> xorg-server-9999-parser-Fix-crash-when-xf86nameCompare-fn-args-s1-eq-x-s2-eq-NULL.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/45e0eb4b156f2155687cce268b07f10540fc507b.patch -> xorg-server-9999-loader-Handle-mod-VersionInfo-eq-NULL.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/38696ea56854e055c31bd2730adfc7c39aa115b0.patch -> xorg-server-9999-damage-Validate-source-pictures-bound-to-windows-before-unwrapping.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/21eda7464d0e13ac6558edaf6531c3d3251e05df.patch -> xorg-server-9999-dmx-Fix-null-pointer-dereference.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/f40ff18c96e02ff18a367bf53feeb4bd8ee952a0.patch -> xorg-server-9999-glamor-Check-for-NULL-pixmap-in-glamor_get_pixmap_texture-fn.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/8805a48ed35afb2ca66315656c1575ae5a01c639.patch -> xorg-server-9999-glamor-avoid-a-crash-if-texture-allocation-failed.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/d4995a3936ae283b9080fdaa0905daa669ebacfc.patch -> xorg-server-9999-modesetting-Validate-the-atom-for-enum-properties.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/ce393de0efb8626d15f3b97c97916971a6aefebd.patch -> xorg-server-9999-modesetting-handle-NULL-cursor-in-drmmode_set_cursor.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/bd353e9b84e013fc34ed730319d5b63d20977903.patch -> xorg-server-9999-glamor-handle-NULL-source-picture.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/14be894b3f7976c133fc186e0e3c475606bab241.patch -> xorg-server-9999-Xext-Fix-memory-leaks-in-hashtable.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/9869dcb349b49f6d4cc2fab5d927cd8b1d1f463c.patch -> xorg-server-9999-glamor-Avoid-overflow-between-box32-and-box16-box.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/3336291fc68444ee65b48ba675ec947e505fed57.patch -> xorg-server-9999-test-Return-error-from_simple-xinit_if-the-client-crashes.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/b95f25af141d33a65f6f821ea9c003f66a01e1f1.patch -> xorg-server-9999-Xext-shm-Validate-shmseg-resource-id-CVE-2017-13721.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/cad5a1050b7184d828aef9c1dd151c3ab649d37e.patch -> xorg-server-9999-Unvalidated-lengths.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/55caa8b08c84af2b50fbc936cf334a5a93dd7db5.patch -> xorg-server-9999-xfixes-unvalidated-lengths-CVE-2017-12183.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/1b1d4c04695dced2463404174b50b3581dbd857b.patch -> xorg-server-9999-hw-xfree86-unvalidated-lengths.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/d088e3c1286b548a58e62afdc70bb40981cdb9e8.patch -> xorg-server-9999-Xi-integer-overflow-and-unvalidated-length-in-S-ProcXIBarrierReleasePointer.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/859b08d523307eebde7724fd1a0789c44813e821.patch -> xorg-server-9999-Xi-fix-wrong-extra-length-check-in-ProcXIChangeHierarchy-CVE-2017-12178.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/4ca68b878e851e2136c234f40a25008297d8d831.patch -> xorg-server-9999-Unvalidated-variable-length-request-in-ProcDbeGetVisualInfo-CVE-2017-12177.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/b747da5e25be944337a9cd1415506fc06b70aa81.patch -> xorg-server-9999-Unvalidated-extra-length-in-ProcEstablishConnection-CVE-2017-12176.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/6abdb54a11dac4e8854ff94ecdcb90a14321ab31.patch -> xorg-server-9999-modesetting-Fix-leak-of-tile_blob-in-drmmode_output_destroy.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/68d95e759f8b6ebca6bd52e69e6bc34cc174f8ca.patch -> xorg-server-9999-ramdac-Check-ScreenPriv-ne-NULL-in-xf86ScreenSetCursor-fn.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/04a305121fbc08ecc2ef345ee7155d6087a43fd1.patch -> xorg-server-9999-modesetting-Fix-potential-buffer-overflow.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/9f7a9be13d6449c00c86d3035374f4f543654b3f.patch -> xorg-server-9999-dix-avoid-deferencing-NULL-PtrCtrl.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/6883ae43eb72fe4e2651c1dca209563323fad2db.patch -> xorg-server-9999-os-Fix-strtok-free-crash-in-ComputeLocalClient.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/a309323328d9d6e0bf5d9ea1d75920e53b9beef3.patch -> xorg-server-9999-config-fix-NULL-value-detection-for-ID_INPUT-being-unset.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/7fc757986947ad89d76fc0fd3d69f5fdeefc9055.patch -> xorg-server-9999-glx-NULL-check-the-correct-argument-in-dispatch_GLXVendorPriv.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/22a3ffe68c9c498e0b6b74ebcf1404becda8e2b1.patch -> xorg-server-9999-glx-Dont-pass-NULL-to-glxGetClient.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/2af0a50a4bb9be9f58681d417ceb9a7029caaf3b.patch -> xorg-server-9999-randr-Fix-a-crash-on-initialization-with-GPU-screens.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/af151895f3cb1755a7a5631f2398a3d3b219cbef.patch -> xorg-server-9999-glamor-egl-Avoid-crashing-on-broken-configurations.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/1c002bc43472063cf8599abb0d6d7367e30456e2.patch -> xorg-server-9999-modesetting-drmmode-add-NULL-pointer-check-in-drmmode_output_dpms.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/bf147f67b2b7170fcc5cca07192f6b195dce85e5.patch -> xorg-server-9999-xwayland-Dont-crash-on-WarpPointer-fn-args-dest_w-eq-None.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/9d5af632fde0373babfa32e66a59cfbf26ed7e5d.patch -> xorg-server-9999-animcur-Fix-crash-when-removing-a-master-device.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/6cace4990abc2386b6ea68536b321994d264c295.patch -> xorg-server-9999-modesetting-Fix-GBM-objects-leak-when-checking-for-flip.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/53ce2ba0a19af9c549f47a4cc678afcebeb6087e.patch -> xorg-server-9999-xwayland-fix-access-to-invalid-pointer.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/7d689f049c3cc16b8e0cb0103a384a2ceb84ea33.patch -> xorg-server-9999-xfree86-Fix-Option-MaxClients-validation.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/71703e4e8bd00719eefad53c2ed6c604079f87ea.patch -> xorg-server-9999-xfree86-ensure-the-readlink-buffer-is-null-terminated.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/709c6562975c3bea10dd0571527a4aac79a6bf6f.patch -> xorg-server-9999-vnd-Fix-a-silly-memory-leak.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/f0a5c0d1fdaeee3cd701215f4f57b7eacaf783c2.patch -> xorg-server-9999-glamor-fix-leak-of-fs_getcolor_source.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/cad3a1a82da3c8421b5cc98af27a779a38b5c709.patch -> xorg-server-9999-posix_tty-free-leak-of-xf86SetStrOption-return-value.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/036794bebce72a3fa2f95996d2e537ff568e0ff1.patch -> xorg-server-9999-xwayland-do-not-crash-if-gbm_bo_create-fn-fails.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/cb0de153bf0c486da7e968ab0f258c9c0c9ed34a.patch -> xorg-server-9999-xwayland-Plug-leaks-in-xwl_present_sync_callback.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/50c0cf885a6e91c0ea71fb49fa8f1b7c86fe330e.patch -> xorg-server-9999-Disable_-logfile-and_-modulepath-when-running-with-elevated-privileges.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/2aec5c3c812ffe4a85b5e62452b244819a812dd6.patch -> xorg-server-9999-glx-Fix-potential-crashes-in-glXWait-GL-X.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/fabc4219622f3c0b41b1cb897c46e092377059e3.patch -> xorg-server-9999-Fix-crash-on-XkbSetMap-1.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/8469bfead9515ab3644f1769a1ff51466ba8ffee.patch -> xorg-server-9999-Fix-crash-on-XkbSetMap-2.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/0a07446318f248b65fcbc8ab8a73ead51153f09e.patch -> xorg-server-9999-xwayland-Avoid-a-crash-on-pointer-enter-with-a-grab.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/d0850241c6218f61127c45c2f95d6e791c3fea44.patch -> xorg-server-9999-xwayland-Expand-the-RANDR-screen-size-limits.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/7667180fb9dbd606e40c000aefc807371d2fb478.patch -> xorg-server-9999-glamor_egl-check-for-non-NULL-pixmap-at-egl_close_screen.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/d9ec525059dbe96fc893c73c0362be2a6dd73e85.patch -> xorg-server-9999-xwayland-Do-not-free-a-NULL-GBM-bo.patch
#	https://gitlab.freedesktop.org/xorg/xserver/commit/95dcc81cb122e5a4c5b38e84ef46eb872b2e1431.patch -> xorg-server-9999-glx-Fix-previous-context-validation-in-xorgGlxMakeCurrent.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/429ee86ab949d6e49c07491a88d6b8d8babc3246.patch -> xorg-server-9999-udev-Fixed-NULL-pointer-argument-of-strcmp.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/e693c9657f98c334e9921ca2f8ebf710497c0c6a.patch -> xorg-server-9999-dix-Check-for-NULL-spriteInfo-in-GetPairedDevice.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/744c419cb4eaed4006b5f0f319b72d7ffa9fbc6d.patch -> xorg-server-9999-glamor-check-for-non-NULL-pixmap-at-close_screen.patch
	https://gitlab.freedesktop.org/xorg/xserver/commit/4308f5d3d1fbd0f5dce81e22c0c3f08c65a7c9d8.patch -> xorg-server-9999-os-Dont-crash-in-AttendClient-if-the-client-is-gone.patch
"

PATCHES=(
	"${UPSTREAMED_PATCHES[@]}"
	"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
	# needed for new eselect-opengl, bug #541232
	"${FILESDIR}"/${PN}-1.18-support-multiple-Files-sections.patch
	"${FILESDIR}"/${PN}-1.19.4-sysmacros.patch #633530

	# they don't usually backport crash prevention as far back as the release candidate
	# need to backtrack to oct 28, 2016 or the last 1.19 rc
#	"${DISTDIR}"/${PN}-9999-ramdac-Check-sPriv-ne-NULL-in-xf86CheckHWCursor-fn.patch # 26 Oct 2016
#	"${DISTDIR}"/${PN}-9999-randr-fix-xserver-crash-when-xrandr-setprovideroutputsource.patch # 10 Jan 2017
#	"${DISTDIR}"/${PN}-9999-parser-Fix-crash-when-xf86nameCompare-fn-args-s1-eq-x-s2-eq-NULL.patch # 23 Jan 2017
#	"${DISTDIR}"/${PN}-9999-loader-Handle-mod-VersionInfo-eq-NULL.patch # 26 Jan 2017
#	"${DISTDIR}"/${PN}-9999-damage-Validate-source-pictures-bound-to-windows-before-unwrapping.patch # 7 Feb 2017
#	"${DISTDIR}"/${PN}-9999-dmx-Fix-null-pointer-dereference.patch # 12 Mar 2017
#	"${DISTDIR}"/${PN}-9999-glamor-Check-for-NULL-pixmap-in-glamor_get_pixmap_texture-fn.patch # 14 Mar 2017
#	"${DISTDIR}"/${PN}-9999-glamor-avoid-a-crash-if-texture-allocation-failed.patch # 17 Mar 2017
#	"${DISTDIR}"/${PN}-9999-modesetting-Validate-the-atom-for-enum-properties.patch # 12 Jun 2017
#	"${DISTDIR}"/${PN}-9999-modesetting-handle-NULL-cursor-in-drmmode_set_cursor.patch # 23 Jun 2017
#	"${DISTDIR}"/${PN}-9999-glamor-handle-NULL-source-picture.patch # 26 Jul 2017
	"${DISTDIR}"/${PN}-9999-Xext-Fix-memory-leaks-in-hashtable.patch # 1 Aug 2017
#	"${DISTDIR}"/${PN}-9999-glamor-Avoid-overflow-between-box32-and-box16-box.patch # 26 Jul 2017, 13 Sep, 2017
	"${DISTDIR}"/${PN}-9999-test-Return-error-from_simple-xinit_if-the-client-crashes.patch # 18 Sep 2017
#	"${DISTDIR}"/${PN}-9999-Xext-shm-Validate-shmseg-resource-id-CVE-2017-13721.patch # 28 Jul 2017, 04 Oct, 2017
#	"${DISTDIR}"/${PN}-9999-Unvalidated-lengths.patch # 9 Jan 2015, 10 Oct, 2017 ; Addreses CVE-2017-12184 CVE-2017-12185 CVE-2017-12186 CVE-2017-12187
#	"${DISTDIR}"/${PN}-9999-xfixes-unvalidated-lengths-CVE-2017-12183.patch # 9 Jan 2015, 10 Oct, 2017
#	"${DISTDIR}"/${PN}-9999-hw-xfree86-unvalidated-lengths.patch # 21 Dec 2014, 10 Oct, 2017 ; Addresses CVE-2017-12180 CVE-2017-12181 CVE-2017-12182
#	"${DISTDIR}"/${PN}-9999-Xi-integer-overflow-and-unvalidated-length-in-S-ProcXIBarrierReleasePointer.patch # 9 Jan 2015, 10 Oct, 2017
#	"${DISTDIR}"/${PN}-9999-Xi-fix-wrong-extra-length-check-in-ProcXIChangeHierarchy-CVE-2017-12178.patch # 24 Dec 2014, 10 Oct, 2017
#	"${DISTDIR}"/${PN}-9999-Unvalidated-variable-length-request-in-ProcDbeGetVisualInfo-CVE-2017-12177.patch # 9 Jan 2015, 10 Oct, 2017
#	"${DISTDIR}"/${PN}-9999-Unvalidated-extra-length-in-ProcEstablishConnection-CVE-2017-12176.patch # 9 Jan 2015, 10 Oct, 2017
	"${DISTDIR}"/${PN}-9999-modesetting-Fix-leak-of-tile_blob-in-drmmode_output_destroy.patch # 23 Oct 2017
#	"${DISTDIR}"/${PN}-9999-ramdac-Check-ScreenPriv-ne-NULL-in-xf86ScreenSetCursor-fn.patch # 24 Oct 2017
#	"${DISTDIR}"/${PN}-9999-modesetting-Fix-potential-buffer-overflow.patch # 27 Oct 2017
#	"${DISTDIR}"/${PN}-9999-dix-avoid-deferencing-NULL-PtrCtrl.patch # 5 Dec 2017
#	"${DISTDIR}"/${PN}-9999-os-Fix-strtok-free-crash-in-ComputeLocalClient.patch # 6 Dec 2017
#	"${DISTDIR}"/${PN}-9999-config-fix-NULL-value-detection-for-ID_INPUT-being-unset.patch # 5 Jan 2018
#	"${DISTDIR}"/${PN}-9999-glx-NULL-check-the-correct-argument-in-dispatch_GLXVendorPriv.patch # 19 Feb 2018
#	"${DISTDIR}"/${PN}-9999-glx-Dont-pass-NULL-to-glxGetClient.patch # 26 Feb 2018
	"${DISTDIR}"/${PN}-9999-randr-Fix-a-crash-on-initialization-with-GPU-screens.patch # 28 Feb 2018
#	"${DISTDIR}"/${PN}-9999-modesetting-drmmode-add-NULL-pointer-check-in-drmmode_output_dpms.patch # 30 Mar 2018
#	"${DISTDIR}"/${PN}-9999-xwayland-Dont-crash-on-WarpPointer-fn-args-dest_w-eq-None.patch # 12 Apr 2018
#	"${DISTDIR}"/${PN}-9999-animcur-Fix-crash-when-removing-a-master-device.patch # 23 Apr 2018
#	"${DISTDIR}"/${PN}-9999-modesetting-Fix-GBM-objects-leak-when-checking-for-flip.patch # 26 Apr 2018
#	"${DISTDIR}"/${PN}-9999-xwayland-fix-access-to-invalid-pointer.patch # 28 Aug 2018
	"${DISTDIR}"/${PN}-9999-xfree86-Fix-Option-MaxClients-validation.patch # 29 Aug 2018, 12 Sep, 2018
#	"${DISTDIR}"/${PN}-9999-xfree86-ensure-the-readlink-buffer-is-null-terminated.patch # 17 Oct 2018
	"${DISTDIR}"/${PN}-9999-glamor-fix-leak-of-fs_getcolor_source.patch # 12 Sep 2018 10:52:25
	"${DISTDIR}"/${PN}-9999-posix_tty-free-leak-of-xf86SetStrOption-return-value.patch # 12 Sep 2018 11:05:45
#	"${DISTDIR}"/${PN}-9999-glamor-egl-Avoid-crashing-on-broken-configurations.patch # 5 Oct 2018
#	"${DISTDIR}"/${PN}-9999-vnd-Fix-a-silly-memory-leak.patch # 16 Oct 2018
#	"${DISTDIR}"/${PN}-9999-xwayland-do-not-crash-if-gbm_bo_create-fn-fails.patch # 19 Oct 2018 16:04:32
#	"${DISTDIR}"/${PN}-9999-xwayland-Plug-leaks-in-xwl_present_sync_callback.patch # 19 Oct 2018 18:27:37
	"${DISTDIR}"/${PN}-9999-Disable_-logfile-and_-modulepath-when-running-with-elevated-privileges.patch # 23 Oct 2018 21:29:08 CVE-2018-14665
	"${DISTDIR}"/${PN}-9999-glx-Fix-potential-crashes-in-glXWait-GL-X.patch # 14 May 2019
	"${DISTDIR}"/${PN}-9999-Fix-crash-on-XkbSetMap-1.patch # 1 Jul 2019 02:33:26
	"${DISTDIR}"/${PN}-9999-Fix-crash-on-XkbSetMap-2.patch # 1 Jul 2019 02:31:02
	"${DISTDIR}"/${PN}-9999-xwayland-Avoid-a-crash-on-pointer-enter-with-a-grab.patch # 9 May 2019
	"${DISTDIR}"/${PN}-9999-xwayland-Expand-the-RANDR-screen-size-limits.patch # 15 Jul 2019
	"${DISTDIR}"/${PN}-9999-glamor_egl-check-for-non-NULL-pixmap-at-egl_close_screen.patch # 19 Jul 2019 10:53:19
#	"${DISTDIR}"/${PN}-9999-xwayland-Do-not-free-a-NULL-GBM-bo.patch # 23 Jul 2019
#	"${DISTDIR}"/${PN}-9999-glx-Fix-previous-context-validation-in-xorgGlxMakeCurrent.patch # 16 Aug 2019
	"${DISTDIR}"/${PN}-9999-udev-Fixed-NULL-pointer-argument-of-strcmp.patch # 18 Sep 2019
	"${DISTDIR}"/${PN}-9999-dix-Check-for-NULL-spriteInfo-in-GetPairedDevice.patch # 6 Oct 2019
	"${DISTDIR}"/${PN}-9999-glamor-check-for-non-NULL-pixmap-at-close_screen.patch  # 19 Jul 2019 10:53:19
	"${DISTDIR}"/${PN}-9999-os-Dont-crash-in-AttendClient-if-the-client-is-gone.patch # 19 Nov 2019
)

pkg_pretend() {
	# older gcc is not supported
	[[ "${MERGE_TYPE}" != "binary" && $(gcc-major-version) -lt 4 ]] && \
		die "Sorry, but gcc earlier than 4.0 will not work for xorg-server."
}

pkg_setup() {
	if use wayland && use minimal; then
		ewarn "glamor is necessary for acceleration under Xwayland."
		ewarn "Performance may be unacceptable without it."
		ewarn "Build with USE=-minimal to enable glamor."
	fi
}

src_configure() {
	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	# NOTE: fop is used for doc generating; and I have no idea if Gentoo
	#	package it somewhere
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable debug)
		$(use_enable dmx)
		$(use_enable kdrive)
		$(use_enable kdrive kdrive-kbd)
		$(use_enable kdrive kdrive-mouse)
		$(use_enable kdrive kdrive-evdev)
		$(use_enable suid install-setuid)
		$(use_enable tslib)
		$(use_enable unwind libunwind)
		$(use_enable wayland xwayland)
		$(use_enable !minimal record)
		$(use_enable !minimal xfree86-utils)
		$(use_enable !minimal dri)
		$(use_enable !minimal dri2)
		$(use_enable !minimal glamor)
		$(use_enable !minimal glx)
		$(use_enable xcsecurity)
		$(use_enable xephyr)
		$(use_enable xnest)
		$(use_enable xorg)
		$(use_enable xvfb)
		$(use_enable udev config-udev)
		$(use_with doc doxygen)
		$(use_with doc xmlto)
		$(use_with systemd systemd-daemon)
		$(use_enable systemd systemd-logind)
		--enable-libdrm
		--sysconfdir="${EPREFIX}"/etc/X11
		--localstatedir="${EPREFIX}"/var
		--with-fontrootdir="${EPREFIX}"/usr/share/fonts
		--with-xkb-output="${EPREFIX}"/var/lib/xkb
		--disable-config-hal
		--disable-linux-acpi
		--without-dtrace
		--without-fop
		--with-os-vendor=Gentoo
		--with-sha1=libcrypto
	)

	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install

	server_based_install

	if ! use minimal && use xorg; then
		# Install xorg.conf.example into docs
		dodoc "${AUTOTOOLS_BUILD_DIR}"/hw/xfree86/xorg.conf.example
	fi

	newinitd "${FILESDIR}"/xdm-setup.initd-1 xdm-setup
	newinitd "${FILESDIR}"/xdm.initd-11 xdm
	newconfd "${FILESDIR}"/xdm.confd-4 xdm

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf
}

pkg_postinst() {
	# sets up libGL and DRI2 symlinks if needed (ie, on a fresh install)
	eselect opengl set xorg-x11 --use-old
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if [[ -z ${REPLACED_BY_VERSION} && -e ${EROOT}/usr/$(get_libdir)/xorg/modules ]]; then
		rm -rf "${EROOT}"/usr/$(get_libdir)/xorg/modules
	fi
}

server_based_install() {
	if ! use xorg; then
		rm "${ED}"/usr/share/man/man1/Xserver.1x \
			"${ED}"/usr/$(get_libdir)/xserver/SecurityPolicy \
			"${ED}"/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			"${ED}"/usr/share/man/man1/Xserver.1x
	fi
}

