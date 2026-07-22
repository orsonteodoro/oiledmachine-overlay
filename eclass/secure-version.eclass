# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: secure versions
# @DESCRIPTION:
# Install *only* secure versions in security-critical systems typically for C/C++ programs.

# This ebuild used AI inference to locate repos for review.

# The reason why this ebuild exist because the ebuild maintainers do not like to
# take out the trash or are unhygentic about security.

# For a list of possible vulnerabilities see:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/vf.eclass

# Most are low level vulnerabilities.  For a list of high level vulnerabilies
# see "High level vulnerabilities monitored" section in
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_PACKAGE_DEVEL_GUIDE.md

#
# Quality control notes:
#
# Scope
#
# Each repo is inspected at the head/tip.  We inspect from today to early 2010s
# decade for vulnerabilies in the commit logs.  This eclass applies to the *DEPENDs
# sections.  If you are interested in knowing which live commits are secure, see
# secure-timestamp instead.  Both secure-timestamp and
# secure-version work together and use the same logic when finding possible
# vulnerable code.  We are interested vulnerabilities that happen during
# runtime or after install.  Also, most of these are dependencies are
# high to security-critical C/C++ based packages or from memory unsafe
# languages.
#
#
# These are vulnerable or hint keywords that are scanned from the commit log section
# of the web interface:
#
# bounds
# buffer overflow
# corruption
# crash
# deadlock
# divide by zero
# double free
# fix wiping
# harden
# heap overflow
# leak
# infinite loop
# integer overflow
# underflow
# memory corruption
# memory leak
# mitigation
# null pointer dereference
# oob
# off by one
# out of bounds
# overflow
# race
# reject [Fail-Secure hints]
# segfault
# stack overflow
# toctou
# uaf
# ub
# unaligned memory
# use after free
# undefined behavior (ub)
# uninitalized [ub]
# uninitalized memory
# uninitalized variable [ub]
#
#
# What is and is not a vulnerability
#
# Not all of these keywords are actually vulnerabilities.  If the bug does
# not have an associated attacker controlled input directly or indirectly, it is
# not considered vulnerability, but we still take precaution since we do not
# fully understand the code or how a threat actor may abuse it.  So, we presume
# by default that it is a security vulnerability.
#
#
# Skips or ignored vulnerable commits
#
# If the possible vulnerability is not Linux, it is ignored.
# If the vulnerability happens in the test code, it is ignored.
#
#
# Explanation of live ebuild and not latest stable
#
# Some may find it uncomfortable with live packages (9999), the fact is that
# *most* projects do not make a tagged security fixes within a week or two.
# Only a few actually release a proper acceptable time tagged security
# release for general availability.  Some of these vulnerabilies are
# considered high to critical severity.
#

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_ECLASS}" ]] ; then
_SECURE_VERSION_ECLASS=1

# The ebuild name has precedence for naming rules for ease in conversion.

# 215 rows unconditional
# 126 rows marked 9999 (58.6% are unstabled)
# 89 rows marked tagged (41.3% are stable tagged)

# Ebuilds or users can override this

_7ZIP_PV=${_7ZIP_PV:-"26.02"}
ACL_PV=${ACL_PV:-"2.4.0"}
ALSA_LIB_PV=${ALSA_LIB_PV:-"9999"}
ALSA_PLUGINS_PV=${ALSA_PLUGINS_PV:-"1.2.6"}
ALSA_UTILS_PV=${ALSA_UTILS_PV:-"1.2.16"}
APACHE_PV=${APACHE2_PV:-"2.4.68"}
ASSIMP_PV=${ASSIMP_PV:-"9999"}
AT_SPI2_CORE_PV=${AT_SPI2_CORE_PV:-"9999"}
ARPING_PV=${ARPING_PV:-"2.29"}
ATTR_PV=${ATTR_PV:-"2.6.0"}
AUDIT_PV=${AUDIT_PV:-"9999"} # Same as sys-process/audit or audit-userspace
AVAHI_PV=${AVAHI_PV:-"9999"}
BASH_PV=${BASH_PV:-"9999"}
BINUTILS_PV=${BINUTILS_PV:-"9999"}
BLUEZ_PV=${BLUEZ_PV:-"9999"}
BROTLI_PV=${BROTLI_PV:-"9999"}
BUBBLEWRAP_PV=${BUBBLEWRAP_PV:-"9999"}
BUSYBOX_PV=${BUSYBOX_PV:-"9999"}
BZIP2_PV=${BZIP2_PV:-"9999"}
C_ARES_PV=${C_ARES_PV:-"9999"}
CA_CERTIFICATES_PV=${CA_CERTIFICATES_PV:-"20260601"}
CAIRO_PV=${CAIRO_PV:-"9999"}
CDPARANOIA_PV=${CDPARANOIA_PV:-"9999"}
CEF_PV=${CEF_PV:-"9999"}
CEF_BIN_PV=${CEF_BIN_PV:-"9999"}
CHROMAPRINT_PV=${CHROMAPRINT_PV:-"9999"}
CHROMIUM_PV=${CHROMIUM_PV:-"150.0.7871.114"} # Stable
CIVETWEB_PV=${CIVETWEB_PV:-"9999"}
CJSON_PV=${CJSON_PV:-"9999"}
COLORD_PV=${COLORD_PV:-"9999"}
COREUTILS_PV=${COREUTILS_PV:-"9999"}
CPIO_PV=${CPIO_PV:-"9999"}
CPP_HTTPLIB_PV=${CPP_HTTPLIB_PV:-"0.49.0"}
CUPS_PV=${CUPS_PV:-"9999"}
CSOUND_PV=${CSOUND_PV:-"9999"}
CURL_PV=${CURL_PV:-"9999"}
DASH_PV=${DASH_PV:-"9999"}
DAV1D_PV=${DAV1D_PV:-"9999"}
DBUS_PV=${DBUS_PV:-"9999"}
DHCPCD_PV=${DHCPCD_PV:-"9999"}
DMENU_PV=${DMENU_PV:-"5.4"}
DNSMASQ_PV=${DNSMASQ_PV:-"2.93"}
DOTCONF_PV=${DOTCONF_PV:-"1.4"}
DOUBLE_CONVERSION_PV=${DOUBLE_CONVERSION_PV:-"9999"}
ELECTRON_PV=${ELECTRON_PV:-"43.1.1"} # node 24.18.0, chromium 150.0.7871.114
ELFUTILS_PV=${ELFUTILS_PV:-"9999"}
ELOGIND_PV=${ELOGIND_PV:-"257.9999"}
EMBREE_PV=${EMBREE_PV:-"4.4.1"}
ENET_PV=${ENET_PV:-"9999"}
FIREFOX_RAPID_PV=${FIREFOX_RAPID_PV:-"152.0.3"}
FIREFOX_ESR_PV=${FIREFOX_ESR_PV:-"140.9.1"}
GAVL_PV=${GAVL_PV:-"9999"}
GAME_MUSIC_EMU_PV=${GAME_MUSIC_EMU_PV:-"0.6.5"}
GD_PV=${GD_PV:-"9999"}
GDAL_PV=${GDAL_PV:-"9999"}
GDK_PIXBUF_PV=${GDK_PIXBUF_PV:-"2.44.6"}
GECKODRIVER_PV=${GECKODRIVER_PV:-"0.27.0"}
GLIB_PV=${GLIB_PV:-"2.89.9999"}
GLIBC_PV=${GLIBC_PV:-"2.43"}
GNUTLS_PV=${GNUTLS_PV:-"3.8.13"}
GOBJECT_INTROSPECTION_PV=${GOBJECT_INTROSPECTION_PV:-"1.86.0"}
GOOGLE_CHROME_PV=${GOOGLE_CHROME_PV:-"149.0.7827.200"} # Stable
GOOGLE_PERFTOOLS_PV=${GOOGLE_PERFTOOLS_PV:-"2.18"}
GRAPHICSMAGICK_PV=${GRAPHICSMAGICK_PV:-"9999"}
GSASL_PV=${GSASL_PV:-"2.2.4"}
GTK3_PV=${GTK3_PV:-"3.24.9999"}
GTK4_PV=${GTK4_PV:-"4.23.9999"}
EXPAT_PV=${EXPAT_PV:-"9999"}
ESPEAK_NG_PV=${ESPEAK_NG_PV:-"9999"}
FAAC_PV=${FAAC_PV:-"9999"}
FAAD2_PV=${FAAD2_PV:-"9999"}
FDK_AAC_PV=${FDK_AAC_PV:-"2.0.3"}
FFMPEG_PV=${FFMPEG_PV:-"8.1.2"}
FFMPEG_9999_PV=${FFMPEG_9999_PV:-"9999"}
FFMPEG_4_4_PV=${FFMPEG_4_4_PV:-"4.4.8"}
FFMPEG_5_1_PV=${FFMPEG_5_1_PV:-"5.1.10"}
FFMPEG_6_1_PV=${FFMPEG_6_1_PV:-"6.1.6"}
FFMPEG_7_1_PV=${FFMPEG_7_1_PV:-"7.1.5"}
FFMPEG_8_0_PV=${FFMPEG_8_0_PV:-"8.0.3"}
FFMPEG_8_1_PV=${FFMPEG_8_1_PV:-"8.1.2"}
FILE_PV=${FILE_PV:-"5.48"}
FINDUTILS_PV=${FINDUTILS_PV:-"4.8"}
FIREJAIL_PV=${FIREJAIL_PV:-"9999"}
FLITE_PV=${FLITE_PV:-"2.2"}
FRIBIDI_PV=${FRIBIDI_PV:-"9999"}
FLAC_PV=${FLAC_PV:-"9999"}
FLUIDSYNTH_PV=${FLUIDSYNTH_PV:-"9999"}
FONTCONFIG_PV=${FONTCONFIG_PV:-"9999"}
FREEGLUT_PV=${FREEGLUT_PV-"3.6.0"}
FREETYPE_PV=${FREETYPE_PV:-"9999"}
FREI0R_PLUGINS_PV=${FREI0R_PLUGINS_PV:-"3.2.1"}
FRIBIDI_PV=${FRIBIDI_PV:-"9999"}
GEOCLUE_PV=${GEOCLUE_PV:-"2.8.2"}
GIFLIB_PV=${GIFLIB_PV:-"9999"}
GIMP_PV=${GIMP_PV:-"9999"}
GHOSTSCRIPT_GPL_PV=${GHOSTSCRIPT_GPL_PV:-"9999"}
GLFW_PV=${GLFW_PV:-"9999"}
GMP_PV=${GMP_PV:-"6.3.0-r100"}
GNUPG_PV=${GNUPG_PV:-"2.5.20"}
GOOGLE_CLOUD_CPP_PV=${GOOGLE_CLOUD_CPP_PV:-"3.6.0"}
GRAPHITE2_PV=${GRAPHITE2_PV:-"1.3.15"}
GREP_PV=${GREP_PV:-"3.8"}
GSTREAMER_PV=${GSTREAMER_PV:-"1.28.5"}
GSM_PV=${GSM_PV:-"1.0.24"}
GZIP_PV=${GZIP_PV:-"9999"}
HARFBUZZ_PV=${HARFBUZZ_PV:-"9999"}
HARDENED_MALLOC_PV=${HARDENED_MALLOC_PV:-"2026052400"}
HIGHWAY_PV=${HIGHWAY_PV:-"9999"}
HYPHEN_PV=${HYPHEN_PV:-"2.8.9"}
ICEAUTH_PV=${ICEAUTH_PV:-"1.0.2"}
ICU_PV=${ICU_PV:-"79.0.9999"}
IMAGEMAGICK_PV=${IMAGEMAGICK_PV:-"9999"}
INIPARSER_PV=${INIPARSER_PV:-"4.2.5"}
INTEL_MICROCODE_PV=${INTEL_MICROCODE_PV:-"20260512"} # Do not change the format
IPUTILS_PV=${IPUTILS_PV:-"99999999"}
IPTABLES_PV=${IPTABLES_PV:-"1.8.13"}
IWD_PV=${IWD_PV:-"2.16"}
JQ_PV=${JQ_PV:-"9999"}
JACK2_PV=${JACK2_PV:-"1.9.22"}
JANSSON_PV=${JANSSON_PV:-"9999"}
JBIG2DEC_PV=${JBIG2DEC_PV:-"9999"}
JEMALLOC_PV=${JEMALLOC_PV:-"9999"}
JSON_C_PV=${JSON_C_PV:-"9999"}
JSON_GLIB_PV=${JSON_GLIB_PV:-"1.10.0"}
JSONCPP_PV=${JSONCPP_PV:-"9999"}
KBD_PV=${KBD_PV:-"2.10.0"}
KMOD_PV=${KMOD_PV:-"9999"}
KSH_PV=${KSH_PV:-"9999"}
KVAZAAR_PV=${KVAZAAR_PV:-"9999"}
LBZIP2_PV=${LBZIP2_PV:-"9999"}
LCMS_PV=${LCMS_PV:-"9999"}
LENSFUN_PV=${LENSFUN_PV:-"9999"}
LERC_PV=${LERC_PV:-"9999"}
LEVEL_ZERO_PV=${LEVEL_ZERO_PV:-"1.31.0"}
LIBAOM_PV=${LIBAOM_PV:-"9999"}
LIBAPPARMOR_5_0_PV=${LIBAPPARMOR_5_0_PV:-"5.0.1"} # Rolling
LIBAPPARMOR_4_1_PV=${LIBAPPARMOR_4_1_PV:-"4.1.7"} # LTS, 5 years
LIBARCHIVE_PV=${LIBARCHIVE_PV:-"9999"}
LIBASS_PV=${LIBASS_PV:-"0.17.4"}
LIBAVIF_PV=${LIBAVIF_PV:-"9999"}
LIBB2_PV=${LIBB2_PV:-"0.98.1"}
LIBBACKTRACE_PV=${LIBBACKTRACE_PV:-"9999"}
LIBBLURAY_PV=${LIBBLURAY_PV:-"1.4.1"}
LIBBPF_PV=${LIBBPF_PV:-"9999"}
LIBBSD_PV=${LIBBSD_PV:-"0.11.8"}
LIBCACA_PV=${LIBCACA_PV:-"9999"}
LIBCAMERA_PV=${LIBCAMERA_PV:-"0.6.0"}
LIBCAP_PV=${LIBCAP_PV:-"9999"}
LIBCDIO_PARANOIA_PV=${LIBCDIO_PARANOIA_PV:-"9999"}
LIBCDIO_PV=${LIBCDIO_PV:-"9999"}
LIBCGROUP_PV=${LIBCGROUP_PV:-"9999"}
LIBCLOUDPROVIDERS_PV=${LIBCLOUDPROVIDERS_PV:-"0.4.0"}
LIBDATACHANNEL_PV=${LIBDATACHANNEL_PV:-"0.24.4"}
LIBDCA_PV=${LIBDCA_PV:-"0.0.7"}
LIBDE265_PV=${LIBDE265_PV:-"1.1.1"}
LIBDEFLATE_PV=${LIBDEFLATE_PV:-"9999"}
LIBDISPLAY_INFO_PV=${LIBDISPLAY_INFO_PV:-"9999"}
LIBDRM_PV=${LIBDRM_PV:-"9999"}
LIBDVDNAV_PV=${LIBDVDNAV_PV:-"7.0.0"}
LIBDVDREAD_PV=${LIBDVDREAD_PV:-"9999"}
LIBEDIT_PV=${LIBEDIT_PV:-"20260305"}
LIBEI_PV=${LIBEI_PV:-"1.6.0"}
LIBEV_PV=${LIBEV_PV:-"4.28"}
LIBEVENT_PV=${LIBEVENT_PV:-"9999"}
LIBFFI_PV=${LIBFFI_PV:-"9999"}
LIBFONTENC_PV=${LIBFONTENC_PV:-"1.1.8"}
LIBGCRYPT_PV=${LIBGCRYPT_PV:-"9999"}
LIBGLVND_PV=${LIBGLVND_PV:-"1.7.0"}
LIBGPHOTO2_PV=${LIBGPHOTO2_PV:-"2.5.34"}
LIBHEIF_PV=${LIBHEIF_PV:-"1.23.0"}
LIBICE_PV=${LIBICE_PV:-"1.1.2"}
LIBID3TAG_PV=${LIBID3TAG_PV:-"9999"}
LIBIDN_PV=${LIBIDN_PV:-"1.44"}
LIBIDN2_PV=${LIBIDN2_PV:-"2.1.1"}
LIBINPUT_PV=${LIBINPUT_PV:-"9999"}
LIBEXIF_PV=${LIBEXIF_PV:-"0.6.26"}
LIBITE_PV=${LIBITE_PV:-"2.6.2"}
LIBJPEG_TURBO_PV=${LIBJPEG_TURBO_PV:-"9999"}
LIBJXL_PV=${LIBJXL_PV:-"9999"}
LIBLC3_PV=${LIBLC3_PV:-"1.1.2"}
LIBLIFTOFF_PV=${LIBLIFTOFF_PV:-"9999"}
LIBMD_PV=${LIBMD_PV:-"1.2.0"}
LIBMICRODNS_PV=${LIBMICRODNS_PV:-"9999"}
LIBMICROHTTPD_PV=${LIBMICROHTTPD_PV:-"1.0.6"}
LIBMODPLUG_PV=${LIBMODPLUG_PV:-"9999"}
LIBMSPACK_PV=${LIBMSPACK_PV:-"9999"}
LIBNDP_PV=${LIBNDP_PV:-"1.8"}
LIBNL_PV=${LIBNL_PV:-"3.12.0"}
LIBNVME_PV=${LIBNVME_PV:-"1.16.2"}
LIBOGG_PV=${LIBOGG_PV:-"9999"}
LIBPCRE2_PV=${LIBPCRE2_PV:-"9999"}
LIBPCIACCESS_PV=${LIBPCIACCESS_PV:-"0.19"}
LIBPLACEBO_PV=${LIBPLACEBO_PV:-"9999"}
LIBPNG_PV=${LIBPNG_PV:-"9999"}
LIBPROXY_PV=${LIBPROXY_PV:-"9999"}
LIBPULSE_PV=${LIBPULSE_PV:-"9999"}
LIBPSL_PV=${LIBPSL_PV:-"0.23.0"}
LIBRAW_PV=${LIBRAW_PV:-"9999"}
LIBRIST_PV=${LIBRIST_PV:-"9999"}
LIBRSVG_PV=${LIBRSVG_PV:-"9999"}
LIBSAMPLERATE_PV=${LIBSAMPLERATE_PV:-"0.2.2"}
LIBSELINUX_PV=${LIBSELINUX_PV:-"9999"}
LIBSECCOMP_PV=${LIBSECCOMP_PV:-"2.6.0"}
LIBSECRET_PV=${LIBSECRET_PV:-"0.21.3"}
LIBSIXEL_PV=${LIBSIXEL_PV:-"1.8.7_p2"}
LIBSM_PV=${LIBSM_PV:-"1.2.4"}
LIBSODIUM_PV=${LIBSODIUM_PV:-"9999"}
LIBSOUP_PV=${LIBSOUP_PV:-"3.9999"}
LIBSOUP3_PV=${LIBSOUP3_PV:-"3.9999"}
LIBSOUP2_PV=${LIBSOUP2_PV:-"2.74.9999"}
LIBSPNG_PV=${LIBSPNG_PV:-"0.7.3"}
LIBSNDFILE_PV=${LIBSNDFILE_PV:-"9999"}
LIBSRTP_3_PV=${LIBSRTP_3_PV:-"9999"}
LIBSRTP_2_PV=${LIBSRTP_2_PV:-"2.8.0"}
LIBSSH_PV=${LIBSSH_PV:-"9999"}
LIBSSH2_PV=${LIBSSH2_PV:-"9999"}
LIBSDL2_PV=${LIBSDL2_PV:-"9999"}
LIBSDL3_PV=${LIBSDL3_PV:-"9999"}
LIBSPECTRE_PV=${LIBSPECTRE_PV:-"0.2.11"}
LIBTEAM_PV=${LIBTEAM_PV:-"1.32"}
LIBTHEORA_PV=${LIBTHEORA_PV:-"9999"}
LIBUEV_PV=${LIBUEV_PV:-"2.4.1"}
LIBUNWIND_PV=${LIBUNWIND_PV:-"9999"}
LIBUSB_PV=${LIBUSB_PV:-"9999"}
LIBUV_PV=${LIBUV_PV:-"9999"}
LIBVA_PV=${LIBVA_PV:-"9999"}
LIBVISUAL_0_4_PV=${LIBVISUAL_0_4_PV:-"0.4.2"}
LIBVISUAL_0_5_PV=${LIBVISUAL_0_5_PV:-"9999"}
LIBVORBIS_PV=${LIBVORBIS_PV:-"9999"}
LIBVPX_PV=${LIBVPX_PV:-"9999"}
LIBV4L_PV=${LIBV4L_PV:-"1.30.0"}
LIBVMAF_PV=${LIBVMAF_PV:-"3.2.0"}
LIBWEBP_PV=${LIBWEBP_PV:-"9999"}
LIBYUV_PV=${LIBYUV_PV:-"1947"}
LIBWMF_PV=${LIBWMF_PV:-"9999"}
LIBX11_PV=${LIBX11_PV:-"9999"}
LIBXCB_PV=${LIBXCB_PV:-"9999"}
LIBXCURSOR_PV=${LIBXCURSOR_PV:-"9999"}
LIBXCVT_PV=${LIBXCVT_PV:-"9999"}
LIBXDMCP_PV=${LIBXDMCP_PV:-"1.1.5"}
LIBXEXT_PV=${LIBXEXT_PV:-"1.3.6"}
LIBXFIXES_PV=${LIBXFIXES_PV:-"5.0.3"}
LIBXFONT2_PV=${LIBXFONT2_PV:-"9999"}
LIBXFT_PV=${LIBXFT_PV:-"2.3.9"}
LIBXI_PV=${LIBXI_PV:-"1.8.2"}
LIBXINERAMA_PV=${LIBXINERAMA_PV:-"1.1.3"}
LIBXKBCOMMON_PV=${LIBXKBCOMMON_PV:-"9999"}
LIBXKBFILE_PV=${LIBXKBFILE_PV:-"1.2.0"}
LIBXML2_PV=${LIBXML2_PV:-"9999"}
LIBXPRESENT_PV=${LIBXPRESENT_PV:-"1.0.2"}
LIBXRANDR_PV=${LIBXRANDR_PV:-"1.5.4"}
LIBXRENDER_PV=${LIBXRENDER_PV:-"0.9.12"}
LIBXSHMFENCE_PV=${LIBXSHMFENCE_PV:-"1.3.1"}
LIBXSLT_PV=${LIBXSLT_PV:-"1.1.44"}
LIBXT_PV=${LIBXT_PV:-"1.3.0"}
LIBXTST_PV=${LIBXTST_PV:-"1.2.5"}
LIBXV_PV=${LIBXV_PV:-"1.0.13"}
LIBXXF86VM_PV=${LIBXXF86VM_PV:-"1.1.3"}
LIBZIP_PV=${LIBZIP_PV:-"9999"}
LIEF_PV=${LIEF_PV:-"9999"}
LINUX_KERNEL_7_2_PV=${LINUX_KERNEL_7_2_PV:-"9999"}
LINUX_KERNEL_7_2_RC_PV=${LINUX_KERNEL_7_2_RC_PV:-"7.2_rc4"}
LINUX_KERNEL_7_1_PV=${LINUX_KERNEL_7_1_PV:-"7.1.4"}
LINUX_KERNEL_6_18_PV=${LINUX_KERNEL_6_18_PV:-"6.18.39"}
LINUX_KERNEL_6_12_PV=${LINUX_KERNEL_6_12_PV:-"6.12.96"}
LINUX_KERNEL_6_6_PV=${LINUX_KERNEL_6_6_PV:-"6.6.144"}
LINUX_KERNEL_6_1_PV=${LINUX_KERNEL_6_1_PV:-"6.1.177"}
LINUX_KERNEL_5_15_PV=${LINUX_KERNEL_5_15_PV:-"5.15.211"}
LINUX_KERNEL_5_10_PV=${LINUX_KERNEL_5_10_PV:-"5.10.260"}
LINUX_FIRMWARE_PV=${LINUX_FIRMWARE_PV:-"20260516"} # Do not change the YYYYMMDD format
LINUX_FIRMWARE_AMD_SEV_PV=${LINUX_FIRMWARE_AMD_SEV_PV:-"20250729"} # Do not change the YYYYMMDD format
LINUX_FIRMWARE_AMD_UCODE_PV=${LINUX_FIRMWARE_AMD_UCODE_PV:-"20250724"} # Do not change the YYYYMMDD format
LILV_PV=${LILV_PV:-"0.28.0"}
LV2_PV=${LV2_PV:-"9999"}
LZ4_PV=${LZ4_PV:-"9999"}
LZIP_PV=${LZIP_PV:-"1.22"}
LZO_PV=${LZIP_PV:-"2.10"}
MBEDTLS_4_PV=${MBEDTLS_PV:-"4.2.0"}
MBEDTLS_3_PV=${MBEDTLS_PV:-"3.6.7"}
MESA_PV=${MESA_PV:-"9999"}
MIMALLOC1_PV=${MIMALLOC1_PV:-"1.9.10"}
MIMALLOC2_PV=${MIMALLOC2_PV:-"2.3.2"}
MIMALLOC3_PV=${MIMALLOC3_PV:-"3.3.2"}
MINIZIP_NG_PV=${MINIZIP_NG_PV:-"9999"}
MIT_KRB5_PV=${MIT_KRB_PV:-"9999"}
MERCURIAL_PV=${MERCURIAL_PV:-"7.2.1"}
MOLD_PV=${MOLD_PV:-"2.41.0"}
MPG123_PV=${MPG123_PV:-"1.33.6"}
MPV_PV=${MPV_PV:-"9999"}
MUJS_PV=${MUJS_PV:-"9999"}
MUPARSER_PV=${MUPARSER_PV:-"9999"}
MUSL_PV=${MUSL_PV:-"1.2.6"}
NAS_PV=${NAS_PV:-"1.9.5"}
NCURSES_PV=${NCURSES_PV:-"6.5_p20251213"}
NETTLE_PV=${NETTLE_PV:-"9999"}
NETWORKMANAGER_PV=${NETWORKMANAGER_PV:-"9999"}
NEWT_PV=${NEWT_PV:-"9999"}
NFTABLES_PV=${NFTABLES_PV:-"9999"}
NGTCP2_PV=${NGTCP2_PV:-"1.23.0"}
NGHTTP2_PV=${NGHTTP2_PV:-"9999"}
NGHTTP3_PV=${NGHTTP3_PV:-"1.16.0"}
NLOHMANN_JSON_PV=${NLOHMANN_JSON_PV:-"9999"}
NOCTALIA_QS_PV=${NOCTALIA_QS_PV:-"9999"}
NSS_PV=${NSS_PV:-"3.125"}
NSPR_PV=${NSPR_PV:-"4.39"}
NODEJS_26_PV=${NODEJS_26_PV:-"26.5.0"}
NODEJS_24_PV=${NODEJS_24_PV:-"24.18.0"}
NODEJS_22_PV=${NODEJS_22_PV:-"22.23.1"}
PAMBASE_PV=${PAMBASE_PV:-"20251104"}
OFONO_PV=${OFONO_PV:-"2.17"}
OGRE_PV=${OGRE_PV:-"9999"}
ONNXRUNTIME_PV=${ONNXRUNTIME_PV:-"1.27.0"}
OPENAL_PV=${OPENAL_PV:-"1.25.2"}
OPENCORE_AMR_PV=${OPENCORE_AMR_PV:-"0.1.6"}
OPENCV4_PV=${OPENCV4_PV:-"4.9999"}
OPENCV5_PV=${OPENCV4_PV:-"5.9999"}
OPENEXR_PV=${OPENEXR_PV:-"9999"}
OPENBLAS_PV=${OPENBLAS_PV:-"9999"}
OPENJPEG_PV=${OPENJPEG_PV:-"2.5.4-r1"}
OPENJPH_PV=${OPENJPH_PV:-"0.30.0"}
OPENLDAP_PV=${OPENLDAP_PV:-"9999"}
OPENSSL_PV_4_0_PV=${OPENSSL_PV_4_0_PV:-"4.0.9999"}
OPENSSL_PV_3_6_PV=${OPENSSL_PV_3_6_PV:-"3.6.9999"}
OPENSSL_PV_3_5_PV=${OPENSSL_PV_3_5_PV:-"3.5.9999"}
OPENSSL_PV_3_4_PV=${OPENSSL_PV_3_4_PV:-"3.4.9999"}
OPENSSL_PV_3_0_PV=${OPENSSL_PV_3_0_PV:-"3.0.9999"}
OPUS_PV=${OPUS_PV:-"9999"}
OPENH264_PV=${OPENH264_PV:-"9999"}
OPENVINO_PV=${OPENVINO_PV:-"9999"}
ORC_PV=${ORC_PV:-"0.4.42"}
PAM_PV=${PAM_PV:-"9999"}
PANGO_PV=${PANGO_PV:-"1.58.0"}
PERL_PV=${PERL_PV:-"5.42.2"} # Stable
PIGZ_PV=${PIGZ_PV:-"2.8"}
PIPEWIRE_PV=${PIPEWIRE_PV:-"9999"}
PIXMAN_PV=${PIXMAN_PV:-"9999"}
PLZIP_PV=${PLZIP_PV:-"1.11"}
PUGIXML_PV=${PUGIXML_PV:-"1.16"}
POLKIT_PV=${POLKIT_PV:-"9999"}
POPPLER_PV=${POPPLER_PV:-"9999"}
POPT_PV=${POPT_PV:-"1.19"}
PROCPS_PV=${PROCPS_PV:-"9999"}
PCSC_LITE_PV=${PCSC_LITE_PV:-"2.5.1"}
PYSTRING_PV=${PYSTRING_PV:-"1.1.4"}
QRENCODE_PV=${QRENCODE_PV:-"4.1.0"} # Same as libqrencode
QT5COMPAT6_PV=${QT5COMPAT6_PV:-"6.9999"}
QTBASE6_PV=${QTBASE6_PV:-"6.9999"}
QTDECLARATIVE6_PV=${QTDECLARATIVE6_PV:-"6.9999"}
QTIMAGEFORMATS6_PV=${QTIMAGEFORMATS6_PV:-"6.9999"}
QTTOOLS6_PV=${QTTOOLS6_PV:-"6.9999"}
QTWAYLAND6_PV=${QTWAYLAND6_PV:-"6.9999"}
QUIRC_PV=${QUIRC_PV:-"1.2"}
RAV1E_PV=${RAV1E_PV:-"9999"}
READLINE_PV=${READLINE_PV:-"9999"}
RECASTNAVIGATION_PV=${RECASTNAVIGATION_PV:-"9999"}
RHASH_PV=${RHASH_PV:-"9999"}
RNNOISE_PV=${RNNOISE_PV:-"0.4.1_p20170902"}
RTMPDUMP_PV=${RTMPDUMP_PV:-"9999"}
RUBBERBAND_PV=${RUBBERBAND_PV:-"4.0.0"}
RUSTLS_FFI_PV=${RUSTLS_FFI_PV:-"0.15.1"}
SAMBA_PV=${SAMBA_PV:-"9999"}
SEATD_PV=${SEATD_PV:-"9999"}
SED_PV=${SED_PV:-"4.10"}
SELENIUM_PV=${SELENIUM_PV:-"4.14.0"}
SHADOW_PV=${SHADOW_PV:-"4.19.3"}
SNAPPY_PV=${SNAPPY_PV:-"9999"}
SNDIO_PV=${SNDIO_PV:-"9999"}
SLANG_PV=${SLANG_2_PV:-"2.3.3"}
SPANDSP_PV=${SPANDSP_PV:-"3.0.0"}
SPEECH_DISPATCHER_PV=${SPEECH_DISPATCHER_PV:-"9999"}
SPEEX_PV=${SPEEX_PV:-"9999"}
SRT_PV=${SRT_PV:-"9999"}
SQLITE_PV=${SQLITE_PV:-"9999"}
SUBRANDR_PV=${SUBRANDR_PV:-"9999"}
SUBVERSION_PV=${SUBVERSION_PV:-"9999"}
SVT_AV1_PV=${SVG_AV1_PV:-"9999"}
SWAY_PV=${SWAY_PV:-"9999"}
SWAYBG_PV=${SWAYBG_PV:-"1.2.2"}
SYSTEMD_PV=${SYSTEMD_PV:-"9999"}
TABBED_PV=${TABBED_PV:-"0.8"}
TAGLIB_PV=${TAGLIB_PV:-"2.3"}
TAR_PV=${TAR:-"9999"}
TBB_PV=${TBB_PV:-"9999"}
TESSERACT_PV=${TESSERACT_PV:-"9999"}
TIFF_PV=${TIFF_PV:-"9999"}
TOMLPLUSPLUS_PV=${TOMLPLUSPLUS_PV:-"9999"}
TREMOR_PV=${TREMOR_PV:-"9999"}
TSLIB_PV=${TSLIB_PV:-"1.24"}
TWOLAME_PV=${TWOLAME_PV:-"0.4.0"}
UCHARDET_PV=${UCHARDET_PV:-"9999"}
UNRAR_PV=${UNRAR_PV:-"6.2.3"}
UTIL_LINUX_PV=${UTIL_LINUX_PV:-"9999"}
UUTILS_COREUTILS_PV=${UUTILS_COREUTILS_PV:-"9999"}
UVG266_PV=${UVG266_PV:-"9999"}
VAPORSYNTH_PV=${VAPORSYNTH_PV:-"77"}
VIDSTAB_PV=${VIDSTAB_PV:-"9999"}
VO_AMRWBENC_PV=${VO_AMRWBENC_PV:-"9999"}
VSCODE_PV=${VSCODE_PV:-"1.123.1"}
VULKAN_LOADER_PV=${VULKAN_LOADER_PV:-"1.4.356"}
VULKANMEMORYALLOCATOR_PV=${VULKANMEMORYALLOCATOR_PV:-"3.4.0"}
VVDEC_PV=${VVDEC_PV:-"9999"}
VVENC_PV=${VVENC_PV:-"9999"}
WAVPACK_PV=${WAVPACK_PV:-"9999"}
WAYLAND_PV=${WAYLAND_PV:-"9999"}
WEBKIT_GTK_PV=${WEBKIT_GTK_PV:-"2.52.4"}
WEBKIT_GTK_STABLE_PV=${WEBKIT_GTK_PV:-"2.52.4"}
WHISPER_CPP_PV=${WHISPER_CPP_PV:-"9999"}
WILDMIDI_PV=${WILDMIDI_PV:-"9999"}
WLROOTS_PV=${WLROOTS_PV:-"9999"}
WOFF2_PV=${WOFF2_PV:-"9999"}
X264_PV=${X264_PV:-"9999"}
X265_PV=${X265_PV:-"9999"}
XAUTH_PV=${XAUTH_PV:-"1.1.4"}
XDG_DESKTOP_PORTAL_PV=${XDG_DESKTOP_PORTAL_PV:-"1.21.1"}
XDG_UTILS_PV=${XDG_UTILS_PV:-"1.2.1-r10"}
XKEYBOARD_CONFIG_PV=${XKEYBOARD_CONFIG_PV:-"2.5"}
XINIT_PV=${XINIT_PV:-"1.4.1"}
XKBCOMP_PV=${XKBCOMP_PV:-"1.5.0"}
XORG_SERVER_PV=${XORG_SERVER_PV:-"9999"}
WPA_SUPPLICANT_PV=${WPA_SUPPLICANT_PV:-"9999"}
WGET_PV=${WGET_PV:-"9999"}
WGET2_PV=${WGET_PV:-"9999"}
XPROP_PV=${XPROP_PV:-"1.2.5"}
XSCREENSAVER_PV=${XSCREENSAVER_PV:-"5.45"}
XTRANS_PV=${XTRANS_PV:-"1.5.1"}
XVID_PV=${XVID_PV:-"1.3.5"}
XWAYLAND_PV=${XWAYLAND_PV:-"9999"}
XZ_UTILS_PV=${XZ_UTILS_PV:-"9999"}
ZEROMQ_PV=${ZEROMQ_PV:-"9999"}
ZLIB_PV=${ZLIB_PV:-"1.3.2"}
ZBAR_PV=${ZBAR_PV:-"0.23.93"}
ZIMG_PV=${ZIMG_PV:-"3.0.6"}
ZSH_PV=${ZSH_PV:-"9999"}
ZSTD_PV=${ZSTD_PV:-"9999"}
ZXING_CPP_PV=${ZXING_CPP_PV:-"9999"}
ZVBI_PV=${ZVBI_PV:-"0.2.44"}

secure-version_gen_openssl_depends() {
	local range="${1}" # 1, 3.0-4.0, 3.0-, <empty string>
	local usedep="${2}" # [${MULTILIB_USEDEP}], <empty string>
	local t=""
	t+="
		!=dev-libs/openssl-3.0.9999
		dev-libs/openssl:=${usedep}
		|| (
	"
	local l=""
	local r=""
	if [[ -z "${range}" ]] ; then
		l="3.0"
		r="4.0"
	elif [[ "${range}" =~ "-" ]] ; then
		l="${range%-*}"
		r="${range#*-}"
		if [[ -z "${r}" ]] ; then
			r="4.0"
		fi
	else
		l="${range}"
		r="${range}"
	fi
	local L=(
		"4.0"
		"3.6"
		"3.5"
		"3.4"
		# EOL 3.3 is EOL
		"3.0"
	)
	local x
	for x in "${L[@]}" ; do
		if ver_test "${l}" "-le" "${x}" && ver_test "${x}" "-le" "${r}" ; then
			local u="OPENSSL_PV_${x/./_}_PV"
			t+="
				~dev-libs/openssl-${x}.9999${usedep}
			"
		fi
	done
	t+="
		)
	"

	local output=""
	local t2=""

	if [[ "${_MULTILIB_BUILD_ECLASS}" == "1" ]] ; then
                t2="${t//\$\{MULTILIB_USEDEP\}/${MULTILIB_USEDEP}}"
	else
		t2="${t}"
	fi

	output="${t2}"
#einfo "${output}"
	echo "${output}"
}

secure-version_gen_ffmpeg_depends() {
	local range="${1}" # 4.4, 4.4-8.1, 4.4-s, 4.4-r, 4.4-l, 4.4-, <empty string>
	local usedep="${2}" # [lame], [${MULTILIB_USEDEP}], [${MULTILIB_USEDEP},${PYTHON_SINGLE_USEEP},lame], <empty string>
	local slot_mode="${3}" # single, multi, any, <empty string>
	local t=""
	t+="
		media-video/ffmpeg:=${usedep}
		|| (
	"
	local l=""
	local r=""
	if [[ -z "${range}" ]] ; then
	# Slots used in any distro releases
		l="4.4"
		r="9999"
	elif [[ "${range}" == "s" ]] ; then
	# Slots used in LTS distro releases
		l="4.4"
		r="8.0"
	elif [[ "${range}" == "r" ]] ; then
	# Slots used in rolling distro releases
		l="8.1"
		r="8.1"
	elif [[ "${range}" == "l" ]] ; then
	# Slots used in live distro releases
		l="9999"
		r="9999"
	elif [[ "${range}" =~ "-" ]] ; then
		l="${range%-*}"
		r="${range#*-}"
		if [[ "${r}" == "r" ]] ; then
	# Slot used in rolling distro releases
			r="8.1"
		elif [[ "${r}" == "s" ]] ; then
	# Slot used in LTS distro releases
			r="8.0"
		elif [[ "${r}" == "l" ]] ; then
	# Slot used in live distro releases
			r="9999"
		elif [[ -z "${r}" ]] ; then
	# Slot used in live distro releases
			r="9999"
		fi
	else
		l="${range}"
		r="${range}"
	fi
	local L=(
		"9999"
		"8.1"
		"8.0"
		"7.1"
		"6.1"
		"5.1"
		"4.4"
	)
	local x
	for x in "${L[@]}" ; do
		if ver_test "${l}" "-le" "${x}" && ver_test "${x}" "-le" "${r}" ; then
			local u="FFMPEG_${x/./_}_PV"
#einfo "${u} ${x} ${!u}"
			if [[ "${slot_mode}" == "single" ]] ; then
				t+="
					~media-video/ffmpeg-${!u}${usedep}
				"
			elif [[ "${slot_mode}" == "multi" ]] ; then
				t+="
					~media-video/ffmpeg-${!u}m${usedep}
				"
			else
				t+="
					~media-video/ffmpeg-${!u}${usedep}
					~media-video/ffmpeg-${!u}m${usedep}
				"
			fi
		fi
	done
	t+="
		)
	"

	local output=""
	local t2=""

	if [[ "${_MULTILIB_BUILD_ECLASS}" == "1" ]] ; then
                t2="${t//\$\{MULTILIB_USEDEP\}/${MULTILIB_USEDEP}}"
	else
		t2="${t}"
	fi

	if [[ "${_PYTHON_SINGLE_R1_ECLASS}" == "1" ]] ; then
                t2="${t2//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}"
	else
		t2="${t2}"
	fi

	output="${t2}"
#einfo "${output}"
	echo "${output}"
}

fi
