# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENPATCHES_FALLBACK_COMMIT="4d22cd24ec825388ef8b0dd320b2994064491536" # 2025-05-11 15:41:55 -0400
LINUX_SOURCES_FALLBACK_COMMIT="7586ac7c340c3672f116052c1d150f134810965b" # 2025-05-23 09:47:43 -0700
RC_PV="" # See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Makefile#n5

# See
# https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=6.16
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

EBUILD_REV="ebuild_revision_7"
GENPATCHES_VER="14" # can be live only when 9999
PATCH_PROJC_VER="6.16-r0"
PATCH_RT_VER="6.16-rt3"

inherit ot-kernel-v6.16

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v6.16.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.15.1 (20250605) with modified builder profile with -O2 and -march=native, KFENCE off, KCFI off, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.15.6 (20250714) with modified builder profile with -O2 and -march=native, KFENCE on, KCFI off, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.15.6 (20250715) with modified builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.16.1 (20250816) with modified builder profile with -O2 and -march=native, KFENCE off, KCFI off, UBSAN off, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 6.16.2 (20250822) with modified builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on


# OILEDMACHINE-OVERLAY-TEST:  N/A

#
# Some USE or OT_KERNEL_USE may be ignored in eclasses.
#

# boot time test - pass
# emerge/compile test - pass
# network - pass
# streaming video playback - pass
# initscript - pass
# runtime stability note:  TBA

# env file builder profile sample:
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_USE="-rt c2tcp -O3 -bbrv2 -bbrv3 disable_debug -tresor -tresor_sysfs
# -tresor_x86_64 -tresor_x86_64-256-bit-key-support -tresor_aesni cfs -prjc
# kernel_compiler_patch futex futex-proton multigen_lru -genpatches -clang pgo
# -zen-muqss -zen-sauce -cfi -kcfi -zen-multigen_lru -genpatches_1510 build zstd
# openssl -lto ncurses"
# OT_KERNEL_VERBOSITY=1
# OT_KERNEL_WORK_PROFILE="builder-interactive"
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-throughput"
# OT_KERNEL_EXTRAVERSION="builder"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_SLAB_ALLOCATOR="slub"
# OT_KERNEL_USB_AUTOSUSPEND=-1

# env file gamer profile sample (disabled):
# OT_KERNEL_AUTO_CONFIGURE_KERNEL_FOR_PKGS=1
# OT_KERNEL_CPU_SCHED="cfs-interactive"
# OT_KERNEL_EXTRAVERSION="gaming"
# OT_KERNEL_LOGO_COUNT=1
# OT_KERNEL_LOGO_MAGICK_ARGS="-geometry x112 -colors 224"
# OT_KERNEL_LOGO_URI="<redacted>"
# OT_KERNEL_MODULES_COMPRESSOR="zstd"
# OT_KERNEL_MODULES_SUPPORT="1"
# OT_KERNEL_SLAB_ALLOCATOR="slab"
# OT_KERNEL_USB_AUTOSUSPEND=-1
# OT_KERNEL_WORK_PROFILE="pro-gaming"
# OT_KERNEL_ZSWAP_ALLOCATOR="zsmalloc"
# OT_KERNEL_ZSWAP_COMPRESSOR="zstd"
