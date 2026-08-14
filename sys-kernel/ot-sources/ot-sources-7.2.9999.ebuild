# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Contains AI generated synthetic data in metadata.xml.
# Contains patches derived from AI generated code.

# See also https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/

GENPATCHES_FALLBACK_COMMIT="d4fa92430e875432c3a61bb3abd9b6e68ea9fcbd" # 2026-06-04 18:26:32 -0400
LINUX_SOURCES_FALLBACK_COMMIT="ad8d485e665829ecbf3c97b22ce251f8ff5f8037" # 2026-08-14 07:58:01 -0700 @ Merge tag 'vfs-7.2-rc8.fixes'
RC_PV="" # See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Makefile#n5

# See
# https://gitweb.gentoo.org/proj/linux-patches.git/log/?h=7.2
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

EBUILD_REV="ebuild_revision_15"
GENPATCHES_VER="live" # can be live only when 9999
PATCH_PROJC_VER="7.1-r0"
PATCH_RT_VER="7.2-rc4-rt3"

inherit ot-kernel-v7.2

# See also,
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel-v7.2.eclass

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  modularize-ebuild-as-milestone-eclasses
# OILEDMACHINE-OVERLAY-META-TAGS:  see-eclass-for-full-details
# OILEDMACHINE-OVERLAY-META-WIP:  tresor, signed-kexec-kernel, signed-kernels
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.0.1 (20260424) with gaming profile
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.0.3 (20260503) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.0.5 (20260508) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.0.7 (20260514) with hardened profile with -O2 and -march=native, KASAN on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.0.7 (20260514) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 665159e (20260701) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 87320be (20260702) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 f105f36 (20260705) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 940d91c (20260712) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 7059bdf (20260714) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 7059bdf (20260714) with hardened profile with -O2 and -march=native, KASAN on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 48a5a7a (20260723) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 f5098b6 (20260726) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 62cc902 (20260727) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 2d2338c (20260801) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 848acc8 (20260803) with builder profile with -O2 and -march=native, KFENCE on, KCFI on, UBSAN on, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM on, yama LSM on
# OILEDMACHINE-OVERLAY-TEST:  PASS (interactive) 7.2.9999 06cf618 (20260809) with builder profile with -O2 and -march=native, KFENCE off, KCFI off, UBSAN off, -D_FORTIFY_SOURCE on, apparmor LSM on, capability LSM on, landlock LSM off, yama LSM on, usb autosuspend -1 (off)

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
