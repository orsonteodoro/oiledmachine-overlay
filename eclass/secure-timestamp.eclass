# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: chkl.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: secure timestamps
# @DESCRIPTION:
# A collection of secure timestamps for live ebuilds for chkl.eclass

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_SECURE_TIMESTAMP_ECLASS} ]] ; then
_SECURE_TIMESTAMP_ECLASS=1

# This ebuild contains AI inference clarification.

#
# Bump policy:
#
# If the commit history list, Changelog*, NEWS fixes a vulnerability in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/vf.eclass
# the latest fix will be used as the latest secure timestamp.
#
# If a package is being bump to the newest version has a secure-critical
# dependency, each of the security-critical dependencies must be
# reviewed from master/main or default branch for security fixes.  Both the
# timestamp and the *DEPENDs must be updated.  The tagged release may
# be used in *DEPEND if it contains all the security fixes; otherwise, the
# live ebuild in *DEPENDs is used.
#
get_secure_timestamps() {
	declare -A SECURE_TIMESTAMP
#
# To verify correctness, use:
#
#   date --date="<any timestamp>" +%s			# Abstract example
#   date --date="2026-04-06 08:00:12 +0000" +%s		# Real world example
#
#
# IMPORTANT:  There is a bug were the web interface landing date disagrees with the Date field of the commit.
# Use the most recent push date or landing date instead.
#
# Normalization and sanitization is required to prevent BASH to interpret the key as a mathematical expression.
#
# Normalization rules for the key:
#
#   [a-zA-Z0-9] -> [a-zA-Z0-9]
#   all non-alphanumeric -> _
#
# Normalization example:
#
#   dev-libs/openssl-4.0.9999 -> dev_libs_openssl_4_0_9999
#
SECURE_TIMESTAMP["app_accessibility_at_spi2_core_9999"]="Sat, 23 May 2026 08:21:47 -0500"
SECURE_TIMESTAMP["app_accessibility_speech_dispatcher_9999"]="Tue, 6 May 2025 20:53:18 +0200"
SECURE_TIMESTAMP["app_arch_brotli_9999"]="Sun, 19 Apr 2026 17:14:00 +0000"
SECURE_TIMESTAMP["app_arch_bzip2_9999"]="Thu, 28 May 2026 19:31:28 +0200"
SECURE_TIMESTAMP["app_arch_libdeflate_9999"]="Thu, 4 Apr 2024 21:14:01 -0400"
SECURE_TIMESTAMP["app_arch_snappy_9999"]="Sat, 17 Aug 2024 19:03:10 -0700"
SECURE_TIMESTAMP["app_arch_xz_utils"]="Tue, 19 May 2026 12:34:53 +0300"
SECURE_TIMESTAMP["app_arch_zstd_9999"]="Tue, 17 Mar 2026 13:08:14 -0700"
SECURE_TIMESTAMP["app_text_ghostscript_gpl"]="2026-06-17 13:17:52 +0100"
SECURE_TIMESTAMP["dev_build_ninja_9999"]="Sat, 11 May 2024 13:43:36 +0200"
SECURE_TIMESTAMP["dev_cpp_abseil_cpp_9999"]="Tue, 21 Apr 2026 12:08:14 -0700"
SECURE_TIMESTAMP["dev_cpp_highway_9999"]="Wed, 22 Apr 2026 09:17:05 -0700"
SECURE_TIMESTAMP["dev_cpp_simdutf_9999"]="Tue, 13 Jan 2026 09:03:21 +0100"
SECURE_TIMESTAMP["dev_db_sqlite_9999"]="Wed, 3 Jun 2026 19:12:13 +0000"
SECURE_TIMESTAMP["dev_qt_qtbase_6_9999"]="Jun 19 2026 7:52 AM PDT"
SECURE_TIMESTAMP["dev_libs_glib_2_89_9999"]="Fri, 5 Jun 2026 13:12:13 +0200"
SECURE_TIMESTAMP["dev_libs_crc32c_9999"]="Fri, 1 Mar 2019 15:37:35 -0800"
SECURE_TIMESTAMP["dev_libs_expat_9999"]="Jun 4, 2026"
SECURE_TIMESTAMP["dev_libs_flatbuffers_9999"]="Mon, 15 Dec 2025 08:59:17 +0900"
SECURE_TIMESTAMP["dev_libs_icu_9999"]="Mon, 16 Mar 2026 15:41:53 -0700"
SECURE_TIMESTAMP["dev_libs_jsoncpp_9999"]="Sun, 15 Mar 2026 22:51:09 -0700"
SECURE_TIMESTAMP["dev_libs_libevent_9999"]="Sat, 3 Aug 2019 14:32:21 +0300"
SECURE_TIMESTAMP["dev_libs_libffi_9999"]="Fri, 5 Jun 2026 18:10:53 +0800"
SECURE_TIMESTAMP["dev_libs_libxml2_9999"]="Wed, 15 Apr 2026 12:11:20 +0200"
SECURE_TIMESTAMP["dev_libs_libxslt_9999"]="Sun, 30 Nov 2025 00:51:29 -0600"
SECURE_TIMESTAMP["dev_libs_nspr_9999"]="05-May-2026 13:21"
SECURE_TIMESTAMP["dev_libs_nss_9999"]="Thu, 23 Apr 2026 12:28:50 -0700"
SECURE_TIMESTAMP["dev_libs_openssl_4_0_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_openssl_3_6_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_openssl_3_5_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_openssl_3_4_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_openssl_3_3_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_openssl_3_0_9999"]="Mon, 11 May 2026 16:29:47 +0200"
SECURE_TIMESTAMP["dev_libs_re2_9999"]="Thu, 22 Jan 2026 16:05:23 -0500"
SECURE_TIMESTAMP["dev_libs_wayland_9999"]="Thu, 26 Mar 2026 16:38:38 +0800"
SECURE_TIMESTAMP["dev_lang_rust_9999"]="Fri, 27 Feb 2026 09:38:23 -0800"
SECURE_TIMESTAMP["dev_lang_rust_bin_9999"]="Fri, 27 Feb 2026 09:38:23 -0800"
SECURE_TIMESTAMP["dev_util_spirv_headers_9999"]="Thu, 30 Apr 2026 22:51:58 +0200"
SECURE_TIMESTAMP["dev_util_spirv_tools_9999"]="Wed, 29 Apr 2026 15:51:06 -0700"
SECURE_TIMESTAMP["gnome_base_librsvg_9999"]="Tue, 29 Oct 2024 14:29:59 -0600"
SECURE_TIMESTAMP["llvm_core_clang_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_core_clang_23_0_0_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_core_lld_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_core_lld_23_0_0_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_core_llvm_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_core_llvm_23_0_0_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_23.0.0.9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_sanitizers_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_sanitizers_23.0.0.9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_libcxx_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_libcxx_23_0_0_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_libcxxabi_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["llvm_runtimes_libcxxabi_23_0_0_9999"]="Thu, 9 Apr 2026 18:28:25 +0200"
SECURE_TIMESTAMP["media_libs_alsa_lib_9999"]="Mon, 1 Jun 2026 10:04:24 +0200"
SECURE_TIMESTAMP["media_libs_dav1d_9999"]="Mon, 27 Oct 2025 19:40:41 +0100"
SECURE_TIMESTAMP["media_libs_flac_9999"]="Fri, 8 May 2026 13:28:44 +0200"
SECURE_TIMESTAMP["media_libs_fontconfig_9999"]="Fri, 22 May 2026 13:56:36 -0500"
SECURE_TIMESTAMP["media_libs_freetype_9999"]="Sat, 9 May 2026 09:51:56 -0400" # The 2.14.3 doesn't have the b6bcd217 OF check but the live does.
SECURE_TIMESTAMP["media_libs_giflib_9999"]="2026-06-11 10:01:15"
SECURE_TIMESTAMP["media_libs_harfbuzz_9999"]="Wed, 17 Jun 2026 10:04:23 +0200"
SECURE_TIMESTAMP["media_libs_lcms_9999"]="Wed, 17 Jun 2026 08:02:07 +0200"
SECURE_TIMESTAMP["media_libs_lerc_9999"]="Thu, 30 Apr 2026 12:31:29 -0700"
SECURE_TIMESTAMP["media_libs_libaom_9999"]="Fri, May 22, 2026 08:26:16 -0700"
SECURE_TIMESTAMP["media_libs_libepoxy_9999"]="Tue, 12 Oct 2021 02:41:41 +0900"
SECURE_TIMESTAMP["media_libs_libglvnd_9999"]="Tue, 12 Sep 2023 08:02:00 -0600"
SECURE_TIMESTAMP["media_libs_libjpeg_turbo_9999"]="Wed, 3 Jun 2026 09:43:18 -0400"
SECURE_TIMESTAMP["media_libs_libplacebo_9999"]="Mon, 1 Jun 2026 20:39:36 +0200"
SECURE_TIMESTAMP["media_libs_libpng_9999"]="Wed, 15 Apr 2026 20:23:26 +0300"
SECURE_TIMESTAMP["media_libs_libpulse_9999"]="Thu, 7 Aug 2025 15:45:26 -0600"
SECURE_TIMESTAMP["media_libs_libwebp_9999"]="Fri, 22 May 2026 11:45:40 +0200"
SECURE_TIMESTAMP["media_libs_libva_9999"]="Apr 13, 2026"
SECURE_TIMESTAMP["media_libs_libvpx_9999"]="Wed, May 27, 2026 18:14:29"
SECURE_TIMESTAMP["media_libs_libyuv_9999"]="Thu, 9 Apr 2026 11:03:54 -0700"
SECURE_TIMESTAMP["media_libs_mesa_9999"]="Wed, 25 Feb 2026 16:54:24 +0100"
SECURE_TIMESTAMP["media_libs_openh264_9999"]="Mon, 10 Feb 2025 15:27:56 +0800"
SECURE_TIMESTAMP["media_libs_openjpeg_9999"]="Sun, 5 Apr 2026 13:25:27 +0200"
SECURE_TIMESTAMP["media_libs_tiff_9999"]="Sun, 31 May 2026 10:58:08 -0500"
SECURE_TIMESTAMP["media_libs_woff2_9999"]="Wed, 15 Apr 2026 15:38:51 -0700"
SECURE_TIMESTAMP["media_gfx_graphite2_9999"]="Mon, 1 Jun 2026 03:21:42 +0700"
SECURE_TIMESTAMP["media_video_ffmpeg_9999"]="Mon, 15 Jun 2026 03:24:14 +0300"
SECURE_TIMESTAMP["media_video_ffmpeg_9999m"]="Mon, 15 Jun 2026 03:24:14 +0300"
SECURE_TIMESTAMP["media_video_pipewire_9999"]="Tue, 9 Jun 2026 09:23:10 +0200"
SECURE_TIMESTAMP["net_dns_avahi_9999"]="Fri, 19 Jun 2026 02:52:13 +0000"
SECURE_TIMESTAMP["net_dns_libidn_9999"]="Tue, 16 Jun 2026 17:23:38 +0200"
SECURE_TIMESTAMP["net_libs_libproxy_9999"]="Mon, 23 Feb 2026 10:30:16 -0600"
SECURE_TIMESTAMP["net_libs_nodejs_99999999"]="Tue, 16 Jun 2026 12:29:30 -0400"
SECURE_TIMESTAMP["net_misc_connman_9999"]="2026-02-09 15:45:56 +0100"
SECURE_TIMESTAMP["net_misc_curl_9999"]="Mon, 15 Jun 2026 12:57:42 +0100"
SECURE_TIMESTAMP["net_misc_networkmanager_9999"]="Mon, 8 Jun 2026 13:17:41 +0200"
SECURE_TIMESTAMP["net_print_cups_9999"]="Sat, 13 Jun 2026 12:21:46 -0400"
SECURE_TIMESTAMP["sys_apps_systemd_9999"]="Tue, 9 Jun 2026 10:36:58 +0530"
SECURE_TIMESTAMP["x11_libs_cairo_9999"]="Wed, 6 May 2026 13:42:03 +0100"
SECURE_TIMESTAMP["x11_libs_gdk_pixbuf_9999"]="Tue, 14 May 2024 22:15:41 -0400"
SECURE_TIMESTAMP["x11_libs_libdrm_9999"]="2026-04-06 08:00:12 +0000"
SECURE_TIMESTAMP["x11_libs_pango_9999"]="Sun, 22 Mar 2026 21:54:26 -0400"
SECURE_TIMESTAMP["x11_libs_pixman_9999"]="Wed, 2 Nov 2022 12:11:10 -0400"
SECURE_TIMESTAMP["x11_libs_pixman_9999"]="Wed, 2 Nov 2022 12:11:10 -0400"
	declare -p SECURE_TIMESTAMP
}

fi
