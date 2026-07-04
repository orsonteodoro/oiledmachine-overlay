# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-timestamp.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: secure timestamps
# @DESCRIPTION:
# A collection of secure timestamps for live ebuilds for chkl.eclass

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_SECURE_TIMESTAMP_ECLASS} ]] ; then
_SECURE_TIMESTAMP_ECLASS=1

# This ebuild contains AI inference clarification and info.

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
#
# Performance regressions and rollbacks:
#
# If the performance impact by a commit is 2x slower or feels that the
# processing time is doubled or more, it is equivalent to a DoS on this overlay.
# Backtrack the commit(s) back to the last known green checkmarks.  The green
# checkmarks hints that the test at least was completable.  Also some repos
# have performance bots that notify that a performance regression exists.
#
# Before the xz-utils incident (Mar 29, 2024), performance regessions were not
# an issue.  They are a big deal now because they may indicate a possible
# supply chain attack.  In the xz-utils incident, a performance regression
# lead to the discovery of a supply chain attack.  The attacks typically
# happen during build time not runtime after install.
#
# Rankings of supply chain attacks by language:
#
# 1. JavaScript / Typescript
# 2. Python
# 3. Java
# 4. Rust
# 5. C / C++
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
SECURE_TIMESTAMP["app_accessibility_at_spi2_core_9999"]="Apr 29, 2026 8:10:31 AM PDT"
SECURE_TIMESTAMP["app_accessibility_speech_dispatcher_9999"]="May 3, 2026 5:56 PM PDT"
SECURE_TIMESTAMP["app_accessibility_whisper_cpp_9999"]="Jun 19, 2026 2:53 AM PDT"
SECURE_TIMESTAMP["app_arch_brotli_9999"]="Sun, 30 Apr 2026 10:19 AM PDT"
SECURE_TIMESTAMP["app_arch_bzip2_9999"]="Jun 22 2026 00:37:44 +0200"
SECURE_TIMESTAMP["app_arch_cpio_9999"]="2025-05-29 08:28:33 +0300"
SECURE_TIMESTAMP["app_arch_gzip_9999"]="2026-04-18 09:21:50 -0700"
SECURE_TIMESTAMP["app_arch_lbzip2_9999"]="Jun 20, 2025 4:24 PM PDT"
SECURE_TIMESTAMP["app_arch_libarchive_9999"]="Jun 27, 2026 9:03 AM PST"
SECURE_TIMESTAMP["app_arch_libdeflate_9999"]="May 16, 2026 9:28 PM PDT"
SECURE_TIMESTAMP["app_arch_lz4_9999"]="Jun 1, 2026 3:21 PM PDT"
SECURE_TIMESTAMP["app_arch_snappy_9999"]="Jun 23, 2026 4:22 AM PDT"
SECURE_TIMESTAMP["app_arch_tar_9999"]="2026-04-06 14:04:48 -0700"
SECURE_TIMESTAMP["app_arch_xz_utils_9999"]="Jun 17, 2026 12:15 PM PDT"
SECURE_TIMESTAMP["app_arch_zstd_9999"]="Mar 17, 2026 4:16 PM PDT"
SECURE_TIMESTAMP["app_crypt_rhash_9999"]="Apr 9, 2026 2:16 PM PDT"
SECURE_TIMESTAMP["app_i18n_uchardet_9999"]="Jun 7, 2025 4:35:44 PM PDT"
SECURE_TIMESTAMP["app_shells_dash_9999"]="2026-06-07 13:18:35 +0800"
SECURE_TIMESTAMP["app_shells_ksh_9999"]="Jun 19, 2026 2:06 PDT"
SECURE_TIMESTAMP["app_shells_bash_9999"]="2026-06-10 08:56:30 -0400"
SECURE_TIMESTAMP["app_shells_zsh_9999"]="Jun 9, 2026 8:20 PM PDT"
SECURE_TIMESTAMP["app_text_ghostscript_gpl"]="2026-07-02 11:16:41 +0100"
SECURE_TIMESTAMP["app_text_poppler_9999"]="Jun 27, 2026 3:57:43 PM PDT"
SECURE_TIMESTAMP["app_text_tesseract_9999"]="Feb 9 2026 3:36 AM PST"
SECURE_TIMESTAMP["dev_build_ninja_9999"]="Sat, 11 May 2024 13:43:36 +0200"
SECURE_TIMESTAMP["dev_cpp_abseil_cpp_9999"]="Tue, 21 Apr 2026 12:08:14 -0700"
SECURE_TIMESTAMP["dev_cpp_highway_9999"]="Jun 22, 2026 1:28 AM PDT"
SECURE_TIMESTAMP["dev_cpp_muParser_9999"]="Apr 10, 2026 2:18 PM PDT"
SECURE_TIMESTAMP["dev_cpp_nlohmann_json_9999"]="Jan 12, 2026 1:17 AM PST"
SECURE_TIMESTAMP["dev_cpp_simdutf_9999"]="Jan 13, 2026 12:30 PST"
SECURE_TIMESTAMP["dev_cpp_tomlplusplus_9999"]="Mar 23, 2026 8:33 AM PDT"
SECURE_TIMESTAMP["dev_db_sqlite_9999"]="Jul 3, 2026 1:26 PM PDT"
SECURE_TIMESTAMP["dev_qt_qtbase_6_9999"]="Jun 19, 2026 9:06 AM PDT"
SECURE_TIMESTAMP["dev_qt_qtdeclarative_6_9999"]="Jun 25, 2026 10:10 PM PDT"
SECURE_TIMESTAMP["dev_qt_qtmultimedia_6_9999"]="Jun 25, 2026 3:28 AM PDT"
SECURE_TIMESTAMP["dev_qt_qtsvg_6_9999"]="Jun 10, 2026 3:18 AM PDT"
SECURE_TIMESTAMP["dev_qt_qtwayland_6_9999"]="Mar 3, 2026 6:45 AM PST"
SECURE_TIMESTAMP["dev_qt_qtwebengine_6_9999"]="Jun 26, 2026 2:05 AM PDT"
SECURE_TIMESTAMP["dev_games_ogre_9999"]="Jun 19, 2026 10:03 AM PDT"
SECURE_TIMESTAMP["dev_libs_crc32c_9999"]="Fri, 1 Mar 2019 15:37:35 -0800"
SECURE_TIMESTAMP["dev_libs_glib_2_89_9999"]="Jun 23, 2026 7:04:21 AM PDT"
SECURE_TIMESTAMP["dev_libs_gmp_9999"]="Wed, 27 Aug 2025 08:08:18 +0200"
SECURE_TIMESTAMP["dev_libs_elfutils_9999"]="Sun, 21 Jun 2026 08:41:18 -0700"
SECURE_TIMESTAMP["dev_libs_expat_9999"]="Jun 21, 2026 10:59 AM PDT"
SECURE_TIMESTAMP["dev_libs_flatbuffers_9999"]="Mon, 15 Dec 2025 08:59:17 +0900"
SECURE_TIMESTAMP["dev_libs_fribidi_9999"]="Apr 13, 2026 12:07 PM PDT"
SECURE_TIMESTAMP["dev_libs_icu_79_0_9999"]="Tue, 8 May 2026 5:52 PM PDT"
SECURE_TIMESTAMP["dev_libs_jemalloc_9999"]="Jun 16, 2026 6:02 PM PDT"
SECURE_TIMESTAMP["dev_libs_jansson_9999"]="Jun 13, 2026 1:54 PM PDT"
SECURE_TIMESTAMP["dev_libs_json_c_9999"]="Jun 21, 2026 4:46 PM PDT"
SECURE_TIMESTAMP["dev_libs_jsoncpp_9999"]="Sun, 15 Mar 2026 22:51:09 -0700"
SECURE_TIMESTAMP["dev_libs_libcdio_9999"]="Jun 11, 2026 6:16 AM PDT"
SECURE_TIMESTAMP["dev_libs_libcdio_paranoia_9999"]="Dec 24, 2024 4:17 AM PST"
SECURE_TIMESTAMP["dev_libs_libevent_9999"]="Jun 21, 2026 4:49 PM PDT"
SECURE_TIMESTAMP["dev_libs_libbpf_9999"]="May 30, 2026 8:45 PM PDT"
SECURE_TIMESTAMP["dev_libs_libcgroup"]="Mar 19, 2026 12:08 PM PDT"
SECURE_TIMESTAMP["dev_libs_libffi_9999"]="Jun 21, 2026 3:28 PM PDT"
SECURE_TIMESTAMP["dev_libs_libgcrypt_9999"]="Apr 16, 2026 6:13 PM PDT"
SECURE_TIMESTAMP["dev_libs_libinput_9999"]="Jun 10, 2026 6:17:53 PM PDT"
SECURE_TIMESTAMP["dev_libs_libmspack_9999"]="Jun 15 2026 9:33 AM PDT"
SECURE_TIMESTAMP["dev_libs_libpcre2_9999"]="Mar 3, 2026 1:25 PM PST"
SECURE_TIMESTAMP["dev_libs_libsodium_9999"]="Apr 9, 2026 1:17 PM PDT"
SECURE_TIMESTAMP["dev_libs_libusb_9999"]="Jun 8, 2026 7:04 AM PDT"
SECURE_TIMESTAMP["dev_libs_libuv_9999"]="Jun 3, 2026 7:09 AM PDT"
SECURE_TIMESTAMP["dev_libs_libxml2_9999"]="Tue, 26 May 2026 22:06:25 +0200"
SECURE_TIMESTAMP["dev_libs_libxslt_9999"]="Nov 25, 2025 7:57:09 AM PST"
SECURE_TIMESTAMP["dev_libs_libzip_9999"]="Jun 9, 2026 1:27 AM PDT"
SECURE_TIMESTAMP["dev_libs_nettle_9999"]="May 8, 2026 6:29 AM PDT"
SECURE_TIMESTAMP["dev_libs_nspr_9999"]="05-May-2026 13:21"
SECURE_TIMESTAMP["dev_libs_nss_9999"]="Thu, 23 Apr 2026 12:28:50 -0700"

# For EOL dates, see
# https://openssl-library.org/source/
# https://openssl-library.org/policies/releasestrat/index.html
SECURE_TIMESTAMP["dev_libs_openssl_4_0_9999"]="Jun 28, 2026 10:54 AM PDT"
SECURE_TIMESTAMP["dev_libs_openssl_3_6_9999"]="Jun 28, 2026 10:56 AM PDT"
SECURE_TIMESTAMP["dev_libs_openssl_3_5_9999"]="Jun 28, 2026 10:59 AM PDT"
SECURE_TIMESTAMP["dev_libs_openssl_3_4_9999"]="Jul 3, 2026 13:37 PM PDT"
SECURE_TIMESTAMP["dev_libs_openssl_3_0_9999"]="Jul 3, 2026 12:38 PM PDT"

SECURE_TIMESTAMP["dev_libs_pugixml_9999"]="Jun 15, 2026 1:38 PM PDT"
SECURE_TIMESTAMP["dev_libs_re2_9999"]="Thu, 22 Jan 2026 16:05:23 -0500"
SECURE_TIMESTAMP["dev_libs_wayland_9999"]="Mar 26, 2026 1:38:38 AM PDT"
SECURE_TIMESTAMP["dev_lang_mujs_9999"]="May 6, 2026 8:40 AM PDT"
SECURE_TIMESTAMP["dev_lang_rust_9999"]="Fri, 27 Feb 2026 09:38:23 -0800"
SECURE_TIMESTAMP["dev_lang_rust_bin_9999"]="Fri, 27 Feb 2026 09:38:23 -0800"
SECURE_TIMESTAMP["dev_qt_qtbase_6_9999"]="Jun 24, 2026 7:51 AM PDT"
SECURE_TIMESTAMP["dev_util_spirv_headers_9999"]="Thu, 30 Apr 2026 22:51:58 +0200"
SECURE_TIMESTAMP["dev_util_spirv_tools_9999"]="Wed, 29 Apr 2026 15:51:06 -0700"
SECURE_TIMESTAMP["dev_vcs_subversion_9999"]="May 30, 2026, 1:40 PM PDT"
SECURE_TIMESTAMP["dev_vcs_mercurial_9999"]="Tue, 17 Mar 2026 18:37:39 +0000"
SECURE_TIMESTAMP["gnome_base_librsvg_9999"]="Fri, Jun 19, 2026 3:34:38 PM PDT"
SECURE_TIMESTAMP["gui_libs_gtk_4_23_9999"]="Jun 29, 2026 2:08:23 PM PDT"
SECURE_TIMESTAMP["llvm_core_clang_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_core_clang_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_core_lld_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_core_lld_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_core_llvm_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_core_llvm_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_sanitizers_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_compiler_rt_sanitizers_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_libcxx_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_libcxx_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_libcxxabi_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["llvm_runtimes_libcxxabi_23_0_0_9999"]="Jun 27, 2026 8:13 AM PDT"
SECURE_TIMESTAMP["media_gfx_graphicsmagick_9999"]="Jun 24, 2026 1:09:02 PM PDT"
SECURE_TIMESTAMP["media_libs_alsa_lib_9999"]="Jun 8, 2026 5:35 AM PDT"
SECURE_TIMESTAMP["media_libs_assimp_9999"]="Jul 3, 2026 1:45 PM PDT"
SECURE_TIMESTAMP["media_libs_chromaprint_9999"]="Jun 16, 2026 4:22 AM PDT"
SECURE_TIMESTAMP["media_libs_dav1d_9999"]="Mar 17, 2026 1:40 PM PDT"
SECURE_TIMESTAMP["media_libs_faac_9999"]="May 16, 2026 1:40 AM PDT"
SECURE_TIMESTAMP["media_libs_faad2_9999"]="Jun 18, 2026 11:50 AM PDT"
SECURE_TIMESTAMP["media_libs_flac_9999"]="May 8 2026 4:28 AM PDT"
SECURE_TIMESTAMP["media_libs_fontconfig_9999"]="Fri, 22 May 2026 13:56:36 -0500"
SECURE_TIMESTAMP["media_libs_freetype_9999"]="Sat, 9 May 2026 09:51:56 -0400" # The 2.14.3 doesn't have the b6bcd217 OF check but the live does.
SECURE_TIMESTAMP["media_libs_gavl_9999"]="Jan 26, 2026 1:24 PM PST"
SECURE_TIMESTAMP["media_libs_giflib_9999"]="2026-06-11 10:01:15"
SECURE_TIMESTAMP["media_libs_harfbuzz_9999"]="Wed, 17 Jun 2026 10:04:23 +0200"
SECURE_TIMESTAMP["media_libs_jbig2dec_9999"]="Jul 15, 2024 7:38 AM PDT"
SECURE_TIMESTAMP["media_libs_kvazaar_9999"]="Mar 6, 2026 2:53 AM PST"
SECURE_TIMESTAMP["media_libs_lcms_9999"]="Wed, 17 Jun 2026 08:02:07 +0200"
SECURE_TIMESTAMP["media_libs_lensfun_9999"]="Nov 16, 2025 10:32 AM PST"
SECURE_TIMESTAMP["media_libs_lerc_9999"]="Apr 29 2026 12:42 PM PDT"
SECURE_TIMESTAMP["media_libs_libaom_9999"]="Mon, Jun 15, 2026 12:39:12 -0700"
SECURE_TIMESTAMP["media_libs_libavif_9999"]="Jun 18, 2026 8:32 AM PDT"
SECURE_TIMESTAMP["media_libs_libcaca_9999"]="Apr 12, 2026 12:06 PM PDT"
SECURE_TIMESTAMP["media_libs_libde265_9999"]="Jun 3, 2026 8:05 AM PDT"
SECURE_TIMESTAMP["media_libs_libdisplay_info_9999"]="Nov 20, 2025 3:13:41 PM PST"
SECURE_TIMESTAMP["media_libs_libdvdnav_9999"]="Tue, Sep 23, 2025 7:48:59 AM PDT"
SECURE_TIMESTAMP["media_libs_libdvdread_9999"]="Apr 1, 2026 9:38:43 AM PDT"
SECURE_TIMESTAMP["media_libs_libepoxy_9999"]="Tue, 12 Oct 2021 02:41:41 +0900"
SECURE_TIMESTAMP["media_libs_libglvnd_9999"]="Tue, 12 Sep 2023 08:02:00 -0600"
SECURE_TIMESTAMP["media_libs_libheif_9999"]="May 29, 2026 8:28 AM PDT"
SECURE_TIMESTAMP["media_libs_libid3tag_9999"]="May 27, 2026 04:20 PM PDT"
SECURE_TIMESTAMP["media_libs_libglvnd_9999"]="Apr 4, 2023 5:49:16 AM PDT"
SECURE_TIMESTAMP["media_libs_libjpeg_turbo_9999"]="Jun 18 2026 11:42 AM PDT"
SECURE_TIMESTAMP["media_libs_libjxl_9999"]="Jun 26, 2026 2:24 AM PDT"
SECURE_TIMESTAMP["media_libs_libmodplug_9999"]="Jan 29, 2022 4:54 AM PST"
SECURE_TIMESTAMP["media_libs_libogg_9999"]="Mar 2, 2026 5:10 AM PST"
SECURE_TIMESTAMP["media_libs_libplacebo_9999"]="Jun 1 2026 11:39 AM PDT"
SECURE_TIMESTAMP["media_libs_libpng_9999"]="Wed, 15 Apr 2026 20:23:26 +0300"
SECURE_TIMESTAMP["media_libs_libpulse_9999"]="Sep 13, 2025"
SECURE_TIMESTAMP["media_libs_libraw_9999"]="Jun 17, 2026 9:58 AM PDT"
SECURE_TIMESTAMP["media_libs_libsdl2_9999"]="Apr 28, 2026 4:59 AM PST"
SECURE_TIMESTAMP["media_libs_libsndfile_9999"]="Jul 3, 2026 4:07 AM PDT"
SECURE_TIMESTAMP["media_libs_libtheora_9999"]="Apr 26, 2026 11:27:53 AM PDT"
SECURE_TIMESTAMP["media_libs_libwebp_9999"]="Fri, 22 May 2026 11:45:40 +0200"
SECURE_TIMESTAMP["media_libs_libva_9999"]="Apr 13, 2026"
SECURE_TIMESTAMP["media_libs_libvisual_9999"]="Jan 21, 2025 6:32 PM PST"
SECURE_TIMESTAMP["media_libs_libvorbis_9999"]="May 24, 2026 2:10:05 PM PDT"
SECURE_TIMESTAMP["media_libs_libvpx_9999"]="Wed, May 27, 2026 18:14:29"
SECURE_TIMESTAMP["media_libs_libyuv_9999"]="Jun 05, 2026 6:38 PM PDT"
SECURE_TIMESTAMP["media_libs_lv2_9999"]="Sep 28, 2025 4:27 PM PDT"
SECURE_TIMESTAMP["media_libs_mesa_9999"]="Jul 2, 2026 2:34:23 AM PDT"
SECURE_TIMESTAMP["media_libs_opencv_4.9999"]="Jun 20, 2026 3:01 AM PDT"
SECURE_TIMESTAMP["media_libs_opencv_5.9999"]="Jun 21, 2026 4:39 PM PDT"
SECURE_TIMESTAMP["media_libs_openexr_9999"]="Jun 22, 2026 6:25 AM PDT"
SECURE_TIMESTAMP["media_libs_openh264_9999"]="May 10, 2026 11:27 PM PDT"
SECURE_TIMESTAMP["media_libs_openjpeg_9999"]="Sun, 5 Apr 2026 13:25:27 +0200"
SECURE_TIMESTAMP["media_libs_openjph_9999"]="Jun 21, 2026 5:45 AM PDT"
SECURE_TIMESTAMP["media_libs_opus_9999"]="Jun 12, 2026 12:26 PM PDT"
SECURE_TIMESTAMP["media_libs_speex_9999"]="Jun 16, 2026 6:20:59 AM PDT"
SECURE_TIMESTAMP["media_libs_libspng_9999"]="May 8, 2023 6:45 AM PDT"
SECURE_TIMESTAMP["media_libs_subrandr_9999"]="May 13, 2026 6:54 AM PDT"
SECURE_TIMESTAMP["media_libs_svt_av1_9999"]="Jun 18, 2026 3:19:46 AM PDT"
SECURE_TIMESTAMP["media_libs_tiff_9999"]="Sun, 18 Jun 2026 2:44:19 PDT"
SECURE_TIMESTAMP["media_libs_tremor_9999"]="Fri Jun 14, 2024 6:53:53 AM PDT"
SECURE_TIMESTAMP["media_libs_uvg266_9999"]="Jul 14, 2025 3:46 AM PDT"
SECURE_TIMESTAMP["media_libs_vidstab_9999"]="Jan 7, 2024 12:46 PM PST"
SECURE_TIMESTAMP["media_libs_vo_amrwbenc_9999"]="Nov 7, 2014 1:07 AM PST"
SECURE_TIMESTAMP["media_libs_vulkan_loader_9999"]="Jun 22, 2026 8:57 AM PDT"
SECURE_TIMESTAMP["media_libs_vvdec_9999"]="Jun 15, 2026 2:40 AM PDT"
SECURE_TIMESTAMP["media_libs_vvenc_9999"]="Apr 13, 2026 5:22 AM PDT"
SECURE_TIMESTAMP["media_libs_woff2_9999"]="Apr 15, 2026 6:13 PM PDT"
SECURE_TIMESTAMP["media_libs_x264_9999"]="Oct 5, 2022 1:36 PM"
SECURE_TIMESTAMP["media_libs_x265_9999"]="May 19, 2026 6:35:51 AM PDT"
SECURE_TIMESTAMP["media_libs_zxing_cpp_9999"]="Jun 17, 2026 2:40 AM PDT"
SECURE_TIMESTAMP["media_gfx_graphite2_9999"]="Mon, 1 Jun 2026 03:21:42 +0700"
SECURE_TIMESTAMP["media_gfx_imagemagick_9999"]="Jun 30, 2026 7:25 PM PDT"
SECURE_TIMESTAMP["media_plugins_frei0r_plugins_9999"]="Jun 9, 2026 5:44 AM PDT"
SECURE_TIMESTAMP["media_sound_cdparanoia_9999"]="Dec 24, 2024 4:17 AM PST"
SECURE_TIMESTAMP["media_sound_csound_9999"]="May 31, 2026 3:15 AM PDT"
SECURE_TIMESTAMP["media_sound_jack2"]="Feb 2, 2023 3:04 AM PST"
SECURE_TIMESTAMP["media_sound_sndio_9999"]="Nov 11, 2025 4:41 AM PST"
SECURE_TIMESTAMP["media_sound_wavpack_9999"]="Jun 21, 2026 1:22 PM PDT"
SECURE_TIMESTAMP["media_sound_wildmidi_9999"]="Jun 21, 2026 1:55 AM PDT"
SECURE_TIMESTAMP["media_video_ffmpeg_9999"]="Jul 2, 2026 6:55 PM PDT"
SECURE_TIMESTAMP["media_video_ffmpeg_9999m"]="Jul 2, 2026 6:55 PM PDT"
SECURE_TIMESTAMP["media_video_mpv_9999"]="Jul 2, 2026 10:36 AM PDT"
SECURE_TIMESTAMP["media_video_pipewire_9999"]="Mon, Jun 22 2026 04:05:32 AM PDT"
SECURE_TIMESTAMP["media_video_rav1e_9999"]="Jun 11, 2025 10:16 AM PDT"
SECURE_TIMESTAMP["media_video_rtmpdump_9999"]="Mar 30, 2019 2:33 PM PDT"
SECURE_TIMESTAMP["net_dns_avahi_9999"]="Jun 22, 2026 8:53 AM PDT"
SECURE_TIMESTAMP["net_dns_c_ares_9999"]="May 24, 2026 8:43 AM PDT"
SECURE_TIMESTAMP["net_dns_libidn_9999"]="Tue, 16 Jun 2026 17:23:38 +0200"
SECURE_TIMESTAMP["net_fs_samba_9999"]="Fri, Jun 19, 2026 4:15:46 AM PDT"
SECURE_TIMESTAMP["net_libs_libmicrodns_9999"]="Jun 11, 2026 3:05 AM PDT"
SECURE_TIMESTAMP["net_libs_libproxy_9999"]="Feb 26, 2026 10:16 PM PST"
SECURE_TIMESTAMP["net_libs_librist_9999"]="Jun 21, 2026 11:46:56 AM PDT"
SECURE_TIMESTAMP["net_libs_libsoup_2_74_9999"]="Apr 12, 2025 12:51 PM PDT"
SECURE_TIMESTAMP["net_libs_libsoup_3_7_9999"]="May 26, 2026 10:22 AM PDT" # Same as 9999
SECURE_TIMESTAMP["net_libs_libsoup_9999"]="May 26, 2026 10:22 AM PDT"
SECURE_TIMESTAMP["net_libs_libsrtp_9999"]="May 11, 2026 7:46 AM PDT"
SECURE_TIMESTAMP["net_libs_libssh_9999"]="Jun 12, 2026"
SECURE_TIMESTAMP["net_libs_libssh2_9999"]="Jul 3, 2026 7:12 AM PDT"
SECURE_TIMESTAMP["net_libs_mbedtls_9999"]="Jun 18, 2026 3:36 AM PDT"
SECURE_TIMESTAMP["net_libs_nghttp2_9999"]="Jun 4, 2026 7:21 AM PDT"
SECURE_TIMESTAMP["net_libs_nghttp3_9999"]="Jan 21, 2026 2:08 AM PST"
SECURE_TIMESTAMP["net_libs_ngtcp2_9999"]="May 8, 2026 5:25 AM PDT"
SECURE_TIMESTAMP["net_libs_nodejs_99999999"]="Tue, 16 Jun 2026 12:29:30 -0400"
SECURE_TIMESTAMP["net_libs_rustls_ffi_9999"]="Mar 21, 2026 1:52 AM PDT"
SECURE_TIMESTAMP["net_libs_srt_9999"]="May 21, 2026 5:20 AM PDT"
SECURE_TIMESTAMP["net_libs_zeromq_9999"]="Dec 19, 2023 7:21 AM PST"
SECURE_TIMESTAMP["net_misc_connman_9999"]="2026-02-09 15:45:56 +0100"
SECURE_TIMESTAMP["net_misc_curl_9999"]="Mon, 15 Jun 2026 12:57:42 +0100"
SECURE_TIMESTAMP["net_misc_dhcpcd_9999"]="Jun 22 2026 1:14 PM PDT"
SECURE_TIMESTAMP["net_misc_iputils_99999999"]="Oct 14, 2025 3:14 AM PDT"
SECURE_TIMESTAMP["net_misc_networkmanager_9999"]="Jun 25, 2026 1:47:21 AM PDT"
SECURE_TIMESTAMP["net_misc_wget_9999"]="2026-07-02 13:23:46 +0200"
SECURE_TIMESTAMP["net_misc_wget2_9999"]="Jun 12, 2026 9:17:56 AM PDT"
SECURE_TIMESTAMP["net_nds_openldap_9999"]="Jun 8, 2026 8:56 AM PDT"
SECURE_TIMESTAMP["net_print_cups_9999"]="Jul 2, 2026 9:53 AM PDT"
SECURE_TIMESTAMP["net_wireless_bluez_9999"]="Jun 16, 2026 2:06 PM PDT"
SECURE_TIMESTAMP["net_wireless_wpa_supplicant_9999"]="2026-06-17 15:35:23 +0300"
SECURE_TIMESTAMP["sci_libs_gdal_9999"]="Jun 22, 2026 1:11 PM PDT"
SECURE_TIMESTAMP["sci_libs_openblas_9999"]="Jun 23, 2026 11:56 AM PDT"
SECURE_TIMESTAMP["sci_ml_openvino_9999"]="Jun 22, 2026 1:59 AM PDT"
SECURE_TIMESTAMP["sys_apps_acl_9999"]="2026-06-29 11:00:28 +0200"
SECURE_TIMESTAMP["sys_apps_attr_9999"]="2026-06-29 10:59:33 +0200"
SECURE_TIMESTAMP["sys_apps_busybox_9999"]="Mar 11, 2026 11:25 PM PDT"
SECURE_TIMESTAMP["sys_apps_coreutils_9999"]="2026-06-19 07:39:10 -0700"
SECURE_TIMESTAMP["sys_apps_file_9999"]="Jun 7, 2026 4:44 PM PDT"
SECURE_TIMESTAMP["sys_apps_findutils_9999"]="2025-01-26 18:17:10 +0100"
SECURE_TIMESTAMP["sys_apps_firejail_9999"]="May 1, 2026 4:49 AM PDT"
SECURE_TIMESTAMP["sys_apps_dbus_9999"]="Aug 11, 2025 8:30:12 AM PDT"
SECURE_TIMESTAMP["sys_apps_kmod_9999"]="2026-04-23 00:23:07 -0500"
SECURE_TIMESTAMP["sys_apps_systemd_9999"]="Jul 3, 2026 9:25 AM PDT"
SECURE_TIMESTAMP["sys_apps_util_linux_9999"]="Jun 30, 2026 3:49 AM PDT"
SECURE_TIMESTAMP["sys_apps_uutils_coreutils_9999"]="Jun 28, 2026 4:33 AM PDT"
SECURE_TIMESTAMP["sys_auth_elogind_257_9999"]="May 8, 2026 1:52 AM PDT"
SECURE_TIMESTAMP["sys_auth_pambase_999999999"]="Nov 4, 2025 1:38 AM PST"
SECURE_TIMESTAMP["sys_auth_polkit_9999"]="May 11, 2026 9:29 AM PDT"
SECURE_TIMESTAMP["sys_devel_binutils_9999"]="2026-06-29" # Rounded up
SECURE_TIMESTAMP["sys_kernel_linux_next_9999"]="2026-07-03 05:48:05 -1000"
SECURE_TIMESTAMP["sys_kernel_ot_sources_7_2_9999"]="2026-07-03 05:48:05 -1000"
SECURE_TIMESTAMP["sys_process_audit_9999"]="May 10, 2026 7:54 AM PDT"
SECURE_TIMESTAMP["sys_libs_libbacktrace_9999"]="Feb 10, 2025 3:04 PM PST"
SECURE_TIMESTAMP["sys_libs_libcap_9999"]="Jun 19, 2026 06:04:20 -0700"
SECURE_TIMESTAMP["sys_libs_libseccomp_9999"]="Jan 23, 2025 4:35 PM PST"
SECURE_TIMESTAMP["sys_libs_libselinux_9999"]="Jun 10, 2026 7:43 AM PDT"
SECURE_TIMESTAMP["sys_libs_libunwind_9999"]="Jun 19, 2026 9:44 AM PDT"
SECURE_TIMESTAMP["sys_libs_readline_9999"]="2025-12-10 11:36:18 -0500"

# Tracks AMD µcode security annoucements
# Repo date fix - Advisories
# 2025-12-23 to 2021-09-12 - AMD-SB-3023 security fixes with SEV update (for protecting guests VM on enterprise/cloud CPUs)
# 2025-07-29 - AMD-SB-3023, AMD-SB-3027 (StackWarp) security fix with µcode update (for fixing CPU bugs on consumer or enterprise)
# 2023-07-24 - AMD-SB-3005 (CacheWarp) security fix for µcode an SEV update
# The AI recommends latest SEV FW build to mitigate CacheWarp.
SECURE_TIMESTAMP["sys_kernel_linux_firmware_99999999"]="2026-06-24 11:52:55 -0500"

SECURE_TIMESTAMP["sys_process_procps_9999"]="Mar 26, 2026 4:03:17 AM PDT"
SECURE_TIMESTAMP["x11_base_xorg_server_9999"]="2026-06-08 02:12:00 +0000"
SECURE_TIMESTAMP["x11_libs_libX11_9999"]="Apr 15, 2026 1:18:31 AM PDT"
SECURE_TIMESTAMP["x11_libs_libxcb_9999"]="Jul 29, 2025 4:20:59 PM PDT"
SECURE_TIMESTAMP["x11_libs_libXcursor_9999"]="2026-01-04 03:00:04 +0100"
SECURE_TIMESTAMP["x11_libs_libxcvt_9999"]="Apr 30, 2026 2:02:28 AM PDT"
SECURE_TIMESTAMP["x11_libs_libXfont2_9999"]="2026-06-09 10:48:06 +1000"
SECURE_TIMESTAMP["x11_libs_libxkbcommon_9999"]="May 28, 2026 10:50 PM PDT"
SECURE_TIMESTAMP["x11_libs_cairo_9999"]="Wed, 6 May 2026 13:42:03 +0100"
SECURE_TIMESTAMP["x11_libs_gdk_pixbuf_9999"]="Mon, 30 Mar 2026 9:55:53 AM PDT"
SECURE_TIMESTAMP["x11_libs_gtk+_3_24_9999"]="Jun 27, 2026 11:11:01 AM PDT"
SECURE_TIMESTAMP["x11_libs_libdrm_9999"]="2026-04-06 08:00:12 +0000"
SECURE_TIMESTAMP["x11_libs_pango_9999"]="Jun 1, 2026 3:30 PM PDT"
SECURE_TIMESTAMP["x11_libs_pixman_9999"]="Aug 1, 2025 9:38:49 AM PDT"
SECURE_TIMESTAMP["x11_misc_colord_9999"]="Feb 2, 2026 1:31 AM PST"

#SECURE_TIMESTAMP[""]=""

	declare -p SECURE_TIMESTAMP
}

fi
