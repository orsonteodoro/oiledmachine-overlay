# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D10, U20, U22, U24

#
# For download details see:
#
# https://www.spotify.com/us/download/linux/
# https://community.spotify.com/t5/Desktop-Linux/Linux-Spotify-client-1-x-now-in-stable/m-p/1300404
#
# CEF_VERSION="134.3.11"
# CEF_DEPENDS_VERSION="134.0.6998.178"
# CEF_DEPENDS_VERSION_A="134"
# CEF_DEPENDS_VERSION_B="0"
# CEF_DEPENDS_VERSION_C="6998"
# CEF_DEPENDS_VERSION_D="178"
#
# Third party licenses:
#
# CEF uses the BSD license
# CEF uses the Chromium source code and internal third party libraries/codecs which may be under additional licenses and copyright notices.
# Additional copyright notices can be obtained from
# CEF (tarball):	https://bitbucket.org/chromiumembedded/cef/get/<CEF_DEPENDS_VERSION_C>.tar.bz2
# Chromium (tarball):	https://gsdview.appspot.com/chromium-browser-official/chromium-<CEF_DEPENDS_VERSION>.tar.xz
# CEF (repo):		https://bitbucket.org/chromiumembedded/cef/src/<CEF_DEPENDS_VERSION_C>
#			https://github.com/chromiumembedded/cef/tree/<CEF_DEPENDS_VERSION_C>
# Chromium (repo):	https://github.com/chromium/chromium/tree/<CEF_DEPENDS_VERSION>
#
# The repos may not contain all unmodified the third party modules.
# Refer to the tarballs for more copyright notices and licenses for the unmodified third party packages.
# There may be differences based on libcef.so file sizes.
#
#
# Integrity hashes:
#
# http://repository.spotify.com/dists/stable/Release
# http://repository.spotify.com/dists/testing/Release
#
# Current version and requirements:
#
# http://repository.spotify.com/dists/stable/non-free/binary-amd64/Packages
# http://repository.spotify.com/dists/testing/non-free/binary-amd64/Packages
#
# For Chromium *DEPENDs and versioning see:
#
# https://github.com/chromium/chromium/tree/134.0.6998.178/build/linux/sysroot_scripts/generated_package_lists
# https://github.com/chromium/chromium/blob/134.0.6998.178/build/install-build-deps.py
# https://github.com/chromium/chromium/blob/134.0.6998.178/tools/clang/scripts/update.py#L42
#
# For vendored Chromium third party *DEPENDs versioning see:
#
# https://github.com/chromium/chromium/blob/134.0.6998.178/third_party/fontconfig/README.chromium#L3
# https://github.com/chromium/chromium/blob/134.0.6998.178/third_party/zlib/zlib.h#L40
#
# Versions only obtainable through tarball:
#
# https://chromium.googlesource.com/chromium/src.git/+/refs/tags/134.0.6998.178/third_party/freetype/README.chromium            L165    ; newer than generated_package_lists
# https://chromium.googlesource.com/chromium/src.git/+/refs/tags/134.0.6998.178/third_party/harfbuzz-ng/README.chromium         L3      ; newer than generated_package_lists
# https://chromium.googlesource.com/chromium/src.git/+/refs/tags/134.0.6998.178/third_party/libdrm/README.chromium              L24     ; newer than generated_package_lists
# /var/tmp/portage/www-client/chromium-134.0.6998.178/work/chromium-134.0.6998.178/third_party/ffmpeg/libavutil/version.h               ; do not use
# /var/tmp/portage/www-client/chromium-134.0.6998.178/work/chromium-134.0.6998.178/third_party/ffmpeg/libavcodec/version*.h             ; do not use
# /var/tmp/portage/www-client/chromium-134.0.6998.178/work/chromium-134.0.6998.178/third_party/ffmpeg/libavformat/version*.h            ; do not use
#

# Dropped pax-kernel USE flag because of the license plus the CEF version used
# is already EOL.  Use the web version instead for the secure version.

# Dropped systray USE flag because of license.

# Found in Recommends: section of stable requirements.
# For ffmpeg:0/x.y.z, y must be <= 59.
ALSA_LIB="1.1.3"
ATK_PV="2.26.2"
BUILD_ID_AMD64="g126b0d89" # Change this after every bump
CAIRO_PV="1.16.0"
CLANG_PV="17"
DEFAULT_CONFIGURATION="stable"
EXPECTED_DEPENDS_FINGERPRINT="\
fd58cdd53a8053f5409d059776d9356e26a621bf8753f3e9d6887814769a2eab\
83d57ce65c17167fa95d373912ecbe057f08a6d73b17a6a7e6b00c507e1f1529\
" # Packages fingerprint for client
EXPECTED_CR_DEPENDS_FINGERPRINT="\
27ee98a40fe37c9897bb941d98535b999543c44eae9c2460513379387621ce6e\
89ce438d5e3c3df6230912b1eebf3c45c70bd9def0deb9fb047ed13256019a7c\
" # Packages fingerprint of internal dependency Chromium for CEF
FFMPEG_COMPAT=(
#	List based on Packages file
#	"0/avutil.avcodec.avformat" # compare the middle
	"0/56.58.58" # 4.4
	"0/55.57.57" # 3.4
	"0/54.56.56" # 2.4
	"0/52.54.54" # 0.11, 1.0, 1.1, 1.2
)
FFMPEG_SLOT="0/58.60.60" # Same as 6.0 in chromium tarball [do not use]
FONTCONFIG_PV="2.15.0" # Use vendored list for versioning
FREETYPE_PV="2.13.2" # Use vendored list for versioning
GCC_PV="10.2.1"
GLIB_PV="2.56.4"
GLIBC_PV="2.30"
# Details of the repo public key itself \
GPG_KEY_ID="B420FD3777CCE3A7F0076B55C85668DF69375001" # RSA Key
GPG_EXPECTED_UID="Spotify Public Repository Signing Key <tux@spotify.com>"
# It is possible to fingerprint the public keys using ebuild, but it is only
# done in the non-live ebuild versions.
#
# From first line of https://www.spotify.com/us/download/linux/ \
GPG_PUBLIC_KEY_ID="C85668DF69375001"
GPG_PUBLIC_KEY_URI="https://download.spotify.com/debian/pubkey_${GPG_PUBLIC_KEY_ID}.gpg"
GPG_PUBLIC_KEY_SHA512="\
6c6a304887c783681f774e7b3d02c08e0c6d64ad6686d153f5e65a0adc594ca7\
3b6c04ecc06f2b343fc888b03fa892ea225d51f0bc345bb50c52ecc75ea1ee73\
"
GPG_PUBLIC_KEY_BLAKE2B="\
817fb9344eaa0ce296f66b18fa73f5d8786d117ca90c386d0e5ccedf9acc32c9\
5c41b83aa25d442e2c401e5bb0cec9fa415ef1fb62c3f134cbffd2061e6d8e86\
"
GTK3_PV="3.22.30"
GTK4_PV="4.8.3"
LIBXI_PV="1.7.10"
LIBXSCRNSAVER_PV="1.2.3" # Same as libxss1
LIBXTST_PV="1.2.3"
MESA_PV="20.3.5"
NSS_PV="3.35"
PKG_ARCH="amd64" # It can be amd64, i386, all.
QA_PREBUILT="
	opt/${PN}/${PN}-client/${PN}
	opt/${PN}/${PN}-client/libEGL.so
	opt/${PN}/${PN}-client/libGLESv2.so
	opt/${PN}/${PN}-client/libcef.so
	opt/${PN}/${PN}-client/libvk_swiftshader.so
	opt/${PN}/${PN}-client/libvulkan.so.1
	opt/${PN}/${PN}-client/swiftshader/libEGL.so
	opt/${PN}/${PN}-client/swiftshader/libGLESv2.so
"
# Before URI redirect.  Not SSL protected.  MITM attack possible.
# From second line of https://www.spotify.com/us/download/linux/
#REPO_DOMAIN="http://repository.spotify.com" # Never use this URI to install downloaded debs.
# After URI redirect of the above domain.  SSL protected.
REPO_DOMAIN="https://repository-origin.spotify.com/"

unset hash_cmd
declare -A hash_cmd=(
	["blake2b"]="rhash --blake2b"
	["md5"]="md5sum"
	["sha1"]="sha1sum"
	["sha256"]="sha256sum"
	["sha512"]="sha512sum"
)

unset atabs
declare -A atabs=(
	["blake2b"]="\t"
	["md5"]="\t\t"
	["sha1"]="\t\t"
	["sha256"]="\t"
	["sha512"]="\t"
)

inherit desktop flag-o-matic gnome2-utils sandbox-changes toolchain-funcs unpacker xdg

#KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI+="
	${GPG_PUBLIC_KEY_URI}
"

if ! [[ "${PV}" =~ "9999" ]] ; then
	MY_PV=$(ver_cut 1-4 ${PV})
	MY_REV=$(ver_cut 6 ${PV})
	if [[ -z "${MY_REV}" ]] ; then
		_BUILD_ID_AMD64="${BUILD_ID_AMD64}"
	else
		_BUILD_ID_AMD64="${BUILD_ID_AMD64}-${MY_REV}"
	fi
	CONFIGURATION="${DEFAULT_CONFIGURATION}" # stable or testing
	FN_CLIENT="${PN}-client_${MY_PV}.${_BUILD_ID_AMD64}_amd64.deb"
	FN_INRELEASE="${PN}-${PV}-${CONFIGURATION}-InRelease-${GPG_PUBLIC_KEY_ID}"
	FN_PACKAGES="${PN}-${PV}-${CONFIGURATION}-Packages"
	SRC_URI+="
		https://repository-origin.spotify.com/dists/${CONFIGURATION}/InRelease -> ${FN_INRELEASE}
		https://repository-origin.spotify.com/dists/${CONFIGURATION}/non-free/binary-amd64/Packages -> ${FN_PACKAGES}
		https://repository-origin.spotify.com/pool/non-free/s/spotify-client/${FN_CLIENT}
	"
fi

DESCRIPTION="A social music platform"
HOMEPAGE="https://www.spotify.com"
LICENSE="
	Spotify
	BSD
"
RESTRICT="binchecks mirror strip"
SLOT="0/${DEFAULT_CONFIGURATION}"
IUSE+="
emoji ffmpeg firejail bluetooth libnotify pulseaudio vaapi wayland zenity +X
ebuild_revision_1
"
if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		-extra-dep-checks
	"
	# verify-gpg-key implied enabled
else
	IUSE+="
		verify-gpg-key
	"
fi

REQUIRED_USE+="
	|| (
		wayland
		X
	)
"

gen_ffmpeg_depends() {
	echo "
		|| (
			!firejail? (
				media-video/ffmpeg:56.58.58
			)
	"
	local s
	for s in ${FFMPEG_COMPAT[@]} ; do
		echo "
			media-video/ffmpeg:${s}
		"
	done
	echo "
		)
	"
}

OPTIONAL_RDEPENDS_LISTED="
	ffmpeg? (
		$(gen_ffmpeg_depends)
	)
	libnotify? (
		>=x11-libs/libnotify-0.7.7
	)
"

# Not listed in URLs
OPTIONAL_RDEPENDS_UNLISTED="
	emoji? (
		>=media-libs/fontconfig-${FONTCONFIG_PV}
		>=media-libs/freetype-${FREETYPE_PV}[png]
		>=x11-libs/cairo-${CAIRO_PV}
		|| (
			media-fonts/noto-color-emoji
			media-fonts/noto-color-emoji-bin
			media-fonts/noto-emoji
			media-fonts/twemoji
		)
	)
	pulseaudio? (
		>=media-sound/pulseaudio-14.2
	)
	vaapi? (
		>=media-libs/libva-2.17.0[drm(+),wayland?,X?]
		media-libs/vaapi-drivers
	)
	zenity? (
		>=gnome-extra/zenity-3.32.0
	)
"
# zenity is not in generated_package_lists.

# START CEF DEPENDS
# Some *DEPENDs below are copy pasted and based on the cef-bin ebuild.

# *DEPENDs based on install-build-deps.sh's common_lib_list and lib_list variables.

# For details see:
# https://github.com/chromium/chromium/blob/134.0.6998.178/build/install-build-deps.py#L329

# The version is obtained in src_prepare

CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.38.0
	>=dev-libs/glib-${GLIB_PV}:2
	>=dev-libs/libevdev-1.11.0
	>=dev-libs/libffi-3.3
	>=dev-libs/nss-${NSS_PV}
	>=media-libs/alsa-lib-${ALSA_LIB}
	>=media-libs/mesa-${MESA_PV}[gbm(+),wayland?,X?]
	>=sys-apps/dbus-1.12.24
	>=sys-apps/pciutils-3.7.0
	>=sys-apps/util-linux-2.36.1
	>=sys-libs/glibc-${GLIBC_PV}
	>=sys-libs/libcap-2.44
	>=sys-libs/pam-1.4.0
	>=x11-libs/cairo-${CAIRO_PV}
	>=x11-libs/gtk+-${GTK3_PV}:3[wayland?,X?]
	>=x11-libs/libdrm-2.4.115
	bluetooth? (
		>=net-wireless/bluez-5.55
	)
	wayland? (
		>=dev-libs/wayland-1.18.0:=
	)
	X? (
		>=x11-libs/libXtst-${LIBXTST_PV}
	)
"
# For libdrm use vendored list for versioning

# Possibly Nth level dependencies, but not direct.
UNLISTED_RDEPEND="
	>=media-libs/mesa-${MESA_PV}[egl(+),wayland?,X?]
	>=x11-libs/libxkbcommon-1.0.3
	>=dev-libs/fribidi-1.0.8
	>=dev-libs/gmp-6.2.1
	>=dev-libs/libbsd-0.11.3
	>=dev-libs/libtasn1-4.16.0
	>=dev-libs/libunistring-0.9.10
	>=dev-libs/nettle-3.7.3
	>=media-libs/harfbuzz-8.5.0
	>=media-libs/libglvnd-1.3.2
"
# For harfbuzz use vendored list for versioning
#

# Not listed as either direct or Nth level library
# Also the feature may not be present or reachable.
#UNLISTED_CR_RDEPEND_DROPPED="
#	>=app-accessibility/speech-dispatcher-0.11.4
#	>=dev-db/sqlite-3.34.1
#	>=dev-libs/libappindicator-12.10
#	gnome-keyring? (
#		>=gnome-base/gnome-keyring-3.12.0
#	)
#"
# libappindicator and gnome-keyring not in generated_package_lists.

#UNLISTED_SP_RDEPEND_DROPPED="
#	>=x11-libs/libxshmfence-1.3
#"

OPTIONAL_RDEPEND="
	>=media-libs/vulkan-loader-1.3.224.0
"

# cups is required or it will segfault.
CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${OPTIONAL_RDEPEND}
	${UNLISTED_RDEPEND}
	>=dev-libs/atk-${ATK_PV}
	>=dev-libs/expat-2.2.10
	>=dev-libs/libpcre-8.39:3
	>=dev-libs/libpcre2-10.36
	>=dev-libs/nspr-4.29
	>=media-libs/fontconfig-${FONTCONFIG_PV}
	>=media-libs/freetype-${FREETYPE_PV}
	>=media-libs/libpng-1.6.37
	>=net-print/cups-2.3.3
	>=sys-devel/gcc-${GCC_PV}[cxx(+)]
	>=x11-libs/pango-1.46.2
	>=x11-libs/pixman-0.40.0
	>=sys-libs/zlib-1.3
	X? (
		>=x11-libs/libX11-1.7.2
		>=x11-libs/libXau-1.0.9
		>=x11-libs/libXcomposite-0.4.5
		>=x11-libs/libXcursor-1.2.0
		>=x11-libs/libXdamage-1.1.5
		>=x11-libs/libXdmcp-1.1.2
		>=x11-libs/libXext-1.3.3
		>=x11-libs/libXfixes-5.0.3
		>=x11-libs/libXi-${LIBXI_PV}
		>=x11-libs/libXinerama-1.1.4
		>=x11-libs/libXrandr-1.5.1
		>=x11-libs/libXrender-0.9.10
		>=x11-libs/libxcb-1.14
	)
"
# Use zlib from vendored lists for versioning.

CEFCLIENT_RDEPEND_NOT_LISTED="
	>=x11-libs/gtk+-${GTK3_PV}:3[wayland?,X?]
"

CEFCLIENT_RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:2
	>=x11-libs/libXi-${LIBXI_PV}
"

RDEPEND+="
	${CEFCLIENT_RDEPEND}
	${CHROMIUM_RDEPEND}
"
PDEPEND+="
	sys-apps/firejail[firejail_profiles_spotify,X?]
"

# END CEF DEPENDS


# gcc contains libatomic.so.1
# mesa contains libgbm.so.1
# Sourced from http://repository.spotify.com/dists/testing/non-free/binary-amd64/Packages
RDEPEND+="
	${OPTIONAL_RDEPENDS_LISTED}
	${OPTIONAL_RDEPENDS_UNLISTED}
	>=dev-libs/atk-${ATK_PV}
	>=dev-libs/glib-${GLIB_PV}:2
	>=dev-libs/libayatana-appindicator-0.5.3
	>=dev-libs/nss-${NSS_PV}
	>=gnome-base/gconf-3.2.6
	>=media-libs/alsa-lib-${ALSA_LIB}
	>=media-libs/mesa-${MESA_PV}[wayland?,X?]
	>=net-misc/curl-7.88.1[ssl,gnutls]
	>=x11-libs/gtk+-${GTK3_PV}:3[wayland?,X?]
	>=x11-misc/xdg-utils-1.1.1
	>=sys-devel/gcc-${GCC_PV}
	>=sys-libs/glibc-${GLIBC_PV}
	X? (
		>=x11-libs/libXScrnSaver-${LIBXSCRNSAVER_PV}
		>=x11-libs/libXtst-${LIBXTST_PV}
	)
	|| (
		=dev-libs/openssl-3*:0/3
		>=dev-libs/openssl-1.1.1n:0/1.1
		~dev-libs/openssl-1.0.2:0
	)
"
# libayatana-appindicator is not in generated_package_lists but in Packages file.
# gconf, xdg-utils not in generated_package_lists.

#RDEPEND_LISTED_BUT_NOT_LINKED="
#	>=x11-libs/libXScrnSaver-${LIBXSCRNSAVER_PV}
#	>=x11-libs/libXtst-${LIBXTST_PV}
#"

BDEPEND+="
	app-arch/gzip
	app-crypt/rhash
	net-misc/wget
	sys-apps/coreutils
	wayland? (
		|| (
			>=sys-devel/gcc-${GCC_PV}
			>=llvm-core/clang-${CLANG_PV}
		)
	)
"

if [[ "${PV}" =~ "9999" ]] ; then
	BDEPEND+="
		app-crypt/gnupg[ssl]
	"
else
	BDEPEND+="
		app-crypt/gnupg
		verify-gpg-key? (
			app-crypt/gnupg[ssl]
		)
	"
fi

pkg_setup() {
ewarn "A newer processor may be required to use this version."
ewarn "Older processors can use the =${CATEGORY}/${PN}-1.2.45.454 ebuild or website instead."
einfo "The web version can be found at https://open.spotify.com"
	local configuration_desc
	if [[ "${PV}" =~ "9999" ]] ; then
		CONFIGURATION="${DEFAULT_CONFIGURATION}"
		export FN_INRELEASE="${PN}-${PV}-${CONFIGURATION}-InRelease"
		export FN_PACKAGES="${PN}-${PV}-${CONFIGURATION}-Packages"
	fi
	if [[ "${CONFIGURATION}" == "testing" ]] ; then
		configuration_desc="beta"
	else
		configuration_desc="${CONFIGURATION}"
	fi
einfo
einfo "This is the latest ${configuration_desc} release."
einfo
	if ! has_version "sys-devel/gcc:10" ; then
ewarn
ewarn "Upstream assumes gcc-10 with libatomic.so.1 is installed"
ewarn "like the reference developer machine but is missing."
ewarn
	fi
	if ! use ffmpeg ; then
ewarn
ewarn "Some podcasts will be broken if the ffmpeg USE flag is disabled."
ewarn
	fi

	if \
		has "extra-dep-checks" ${IUSE} \
			&& \
		use extra-dep-checks \
	; then
		sandbox-changes_no_network_sandbox "To verify Chromium dependencies"
	fi
	if \
		has "verify-gpg-key" ${IUSE} \
			&& \
		use verify-gpg-key \
	; then
		sandbox-changes_no_network_sandbox "To verify public repository key"
	fi
	if \
		[[ "${PV}" =~ "9999" ]] \
	; then
		sandbox-changes_no_network_sandbox "To download from a life source and verify public repository key"
	fi
	export EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
}

verify_pubkey() {
	# The keyring is sandboxed so redownload.
	GPG_PUB_KEY_FN=$(basename "${GPG_PUBLIC_KEY_URI}")
	if ! [[ "${PV}" =~ "9999" ]] ; then
		cat "${EDISTDIR}/${GPG_PUB_KEY_FN}" > "${WORKDIR}/${GPG_PUB_KEY_FN}" || die
	elif [[ -z "${EVCS_OFFLINE}" || "${EVCS_OFFLINE}" == "0" ]] ; then
		wget "${GPG_PUBLIC_KEY_URI}" || die
	else
		cat "${EDISTDIR}/${GPG_PUB_KEY_FN}" > "${WORKDIR}/${GPG_PUB_KEY_FN}" || die
	fi
	local actual_sha512=$(\
		${hash_cmd["sha512"]} "${GPG_PUB_KEY_FN}" | cut -f 1 -d " "
	)
	local actual_blake2b=$(\
		${hash_cmd["blake2b"]} "${GPG_PUB_KEY_FN}" | cut -f 1 -d " "
	)

einfo
einfo "${GPG_PUB_KEY_FN} fingerprints:"
einfo
einfo "Expected SHA512:\t${GPG_PUBLIC_KEY_SHA512}"
einfo "Actual SHA512:\t${actual_sha512}"
einfo
einfo "Expected BLAKE2B:\t${GPG_PUBLIC_KEY_BLAKE2B}"
einfo "Actual BLAKE2B:\t${actual_blake2b}"
einfo
	if \
		[[ \
			"${actual_sha512}" == "${GPG_PUBLIC_KEY_SHA512}" \
				&& \
			"${actual_blake2b}" == "${GPG_PUBLIC_KEY_BLAKE2B}" \
		]] \
	; then
		:
	else
eerror
eerror "The fingerprint of the public key changed."
eerror
eerror "QA:"
eerror
eerror "  Manually inspect public keys for trust"
eerror "  Update GPG_PUBLIC_KEY_SHA512 and GPG_PUBLIC_KEY_BLAKE2B"
eerror
		die
	fi

	# Verify validity of key properies.

einfo "Importing GPG key into sandboxed keychain"
	gpg --import "${GPG_PUB_KEY_FN}" || die # \
	# Added the public key to the (sandboxed) keychain.

	if \
		! gpg --list-keys \
		| grep -q -e "${GPG_KEY_ID}" \
	; then
eerror
eerror "GPG_KEY_ID needs to be updated or is untrusted."
eerror
		gpg \
			--show-keys \
			--with-fingerprint \
			$(basename "${GPG_PUBLIC_KEY_URI}") || die
		die
	fi
	local ACTUAL_UID=$(\
		  gpg --list-keys --with-key-data "${GPG_KEY_ID}" \
		| grep -E "^uid:" \
		| cut -f 10 -d ":")
	if [[ "${ACTUAL_UID}" != "${GPG_EXPECTED_UID}" ]] ; then
eerror
eerror "UID mismatch.  If key is trusted, GPG_EXPECTED_UID needs an update."
eerror
eerror
eerror "Expected UID:\t${GPG_EXPECTED_UID}"
eerror "Actual UID:\t${ACTUAL_UID}"
eerror
		die
	fi
	local expired_bit=$(gpg --fingerprint "${GPG_KEY_ID}" \
		| grep -o -e "\[ expired\]")
	if [[ "${expired_bit}" == "[ expired]" ]] ; then
		expired_bit=1
	else
		expired_bit=0
	fi
	local EXPIRE_DATE=$(\
		  gpg --fingerprint "${GPG_KEY_ID}" \
		| grep -E -o -e "expires: [0-9]{4}-[0-9]{2}-[0-9]{2}" \
		| cut -f 2 -d " ")
	local expire_time=$(date -d "${EXPIRE_DATE}" "+%s")
	local now_time=$(date "+%s")
	if \
		has "verify-gpg-key" ${IUSE} \
			&& \
		use verify-gpg-key \
			&& \
		(( ${now_time} > ${expire_time} )) \
	; then
eerror
eerror "The key is outdated.  Is ${PN} End Of Life (EOL)?"
eerror
eerror "Expired bit:\t${expired_bit}"
eerror "Key expiration date:\t${EXPIRE_DATE}"
eerror "Date now\t$(date +%Y-%m-%d)"
eerror
		die
	fi

	local external_key_check=0
	if \
		[[ \
			"${PV}" =~ "9999" \
				&& \
			( \
				-z "${EVCS_OFFLINE}" \
					|| \
				"${EVCS_OFFLINE}" == "0" \
			) \
		]] \
	; then
		external_key_check=1
	fi

	if \
		has "verify-gpg-key" ${IUSE} \
			&& \
		use verify-gpg-key \
	; then
		external_key_check=1
	fi

	(( ${external_key_check} == 0 )) && return 0

	export _GNUPGHOME=$(mktemp -d -p "${T}")
	local pub_keyserver=${GPG_PUBLIC_KEYSERVER:-keys.gnupg.net}
	local O
	O=$(gpg \
		--batch \
		--homedir ${_GNUPGHOME} \
		--keyserver ${pub_keyserver} \
		--recv-keys "${GPG_KEY_ID}" 2>&1)
	if [[ "${O}" =~ "keyserver search failed" ]] ; then
eerror
eerror "The public key server needs to be changed.  Set GPG_PUBLIC_KEYSERVER."
eerror
		die
	fi
	O=$(gpg \
		--batch \
		--homedir ${_GNUPGHOME} \
		--list-keys "${GPG_KEY_ID}" 2>&1)
echo "===================="
echo "${O}"
echo "===================="
	if ! [[ "${O}" =~ "${GPG_KEY_ID}" && "${O}" =~ "${GPG_EXPECTED_UID}" ]] ; then
eerror
eerror "The public key's ID was not found."
eerror
		die
	fi
	if [[ "${O}" =~ "revoked" ]] ; then
eerror
eerror "The public key ${GPG_KEY_ID} is untrusted and has been revoked upstream."
eerror
		die
	fi

	return 0
}

_verify_package_list() {
	local alg="${1}"
	unset offset
	declare -A offset=(
		["md5"]="1"
		["sha1"]="2"
		["sha256"]="3"
	)
	local expected_hash=$(\
		  cat "InRelease" \
		| grep -e "${PKG_LIST}$" \
		| sed -n ${offset[${alg}]}p \
		| cut -f 2 -d " ")
	local actual_hash=$(\
		  ${hash_cmd[${alg}]} "Packages" \
		| cut -f 1 -d " ")
	unset offset
einfo
einfo "Expected ${alg}:\t${expected_hash}"
einfo "Actual ${alg}:${atabs[${alg}]}${actual_hash}"
einfo
	if [[ "${expected_hash}" == "${actual_hash}" ]] ; then
		return 0
	fi
	return 1
}

verify_package_list() {
	local PKG_LIST=$(\
		  cat "InRelease" \
		| grep -e "non-free/binary-${PKG_ARCH}.*$" \
		| sed -n 1p \
		| cut -f 4 -d " ") #
	if ! [[ "${PV}" =~ "9999" ]] ; then
		cat "${EDISTDIR}/${FN_PACKAGES}" > "${WORKDIR}/Packages" || die
	elif [[ -z "${EVCS_OFFLINE}" || "${EVCS_OFFLINE}" == "0" ]] ; then
		wget "${REPO_DOMAIN}/dists/${CONFIGURATION}/${PKG_LIST}" || die
	else
		cat "${EDISTDIR}/${FN_PACKAGES}" > "${WORKDIR}/Packages" || die
	fi
	[[ -e "Packages" ]] || die
einfo
einfo "Packages fingerprints:"
einfo
	if \
		_verify_package_list "md5" \
			&& \
		_verify_package_list "sha1" \
			&& \
		_verify_package_list "sha256" \
	; then
		return 0
	fi
	die
}

_verify_client_deb() {
	local alg="${1}"
	local expected_hash=$(\
		  cat "Packages" \
		| grep -E -e "${alg^^}(sum)?:" \
		| head -n 1 \
		| cut -f 2 -d " ")
	local actual_hash=$(\
		${hash_cmd[${alg}]} "${archive_fn}" \
		| cut -f 1 -d " ")
einfo
einfo "Expected ${alg}:\t${expected_hash}"
einfo "Actual ${alg}:${atabs[${alg}]}${actual_hash}"
einfo
	if [[ "${expected_hash}" == "${actual_hash}" ]] ; then
		return 0
	fi
	return 1
}

_get_uri_frag_from_packages() {
	local URI_FRAG=$(\
		  cat "Packages" \
		| grep "Filename:" \
		| head -n 1 \
		| cut -f 2 -d " ")
	[[ -z "${URI_FRAG}" ]] && die
	echo "${URI_FRAG}"
}

_get_archive_fn() {
	local URI_FRAG=$(_get_uri_frag_from_packages)
	local archive_fn=$(basename "${URI_FRAG}")
	echo "${archive_fn}"
}

check_client_depends() {
	local depends=$(\
		  grep  "Depends:" "${package_fn}" \
		| head -n 1)
	local recommends=$(\
		  grep  "Recommends:" "${package_fn}" \
		| head -n 1)
	local suggests=$(\
		  grep  "Suggests:" "${package_fn}" \
		| head -n 1)
	local actual_depends_fingerprint=$(\
		  echo -n "${depends}${recommends}${suggests}" \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_depends_fingerprint}" != "${EXPECTED_DEPENDS_FINGERPRINT}" ]] ; then
eerror
eerror "Upstream has updated the dependencies."
eerror
eerror "Actual depends fingerprint:\t${actual_depends_fingerprint}"
eerror "Expected depends fingerprint:\t${EXPECTED_DEPENDS_FINGERPRINT}"
eerror
eerror "QA task list:"
eerror
eerror "  Update *DEPENDs."
eerror "  Update the EXPECTED_DEPENDS_FINGERPRINT."
eerror
eerror "Depends:"
eerror "${depends}"
eerror
eerror "Recommends:"
eerror "${recommends}"
eerror
eerror "Suggests:"
eerror "${suggests}"
eerror
		die
	fi
}

verify_client_deb() {
	[[ -e "Packages" ]] || die
	csplit \
		--prefix=package \
		--suffix-format=%02d.info \
		--suppress-matched \
		"Packages" \
		/^$/ {*} 1>/dev/null || die
	local package_fn=$(\
		grep -l -r \
			-e "Package: ${PN}-client$" \
			-e $(find . -maxdepth 1 -name "package*.info"))
	if [[ -z "${package_fn}" ]] ; then
eerror
eerror "${PN}-client is missing from Packages."
eerror
		die
	fi

	check_client_depends

	local archive_fn=$(_get_archive_fn)
	if ! [[ "${PV}" =~ "9999" ]] ; then
		ln -s "${EDISTDIR}/${archive_fn}" "${WORKDIR}/${archive_fn}" || die
	elif [[ -z "${EVCS_OFFLINE}" || "${EVCS_OFFLINE}" == "0" ]] ; then
		local URI_FRAG=$(_get_uri_frag_from_packages)
		wget "${REPO_DOMAIN}/${URI_FRAG}" || die
	else
		ln -s "${EDISTDIR}/${archive_fn}" "${WORKDIR}/${archive_fn}" || die
	fi
	[[ -e "${archive_fn}" ]] || die
	local expected_size=$(grep "^Size: " "${package_fn}" | cut -f 2 -d " ")
	local actual_size=$(stat -c "%s" $(realpath "${archive_fn}"))
einfo
einfo "${archive_fn} fingerprints:"
einfo
einfo "Expected size:\t${expected_size}"
einfo "Actual size:\t\t${actual_size}"
einfo
	if \
		_verify_client_deb "md5" \
			&& \
		_verify_client_deb "sha1" \
			&& \
		_verify_client_deb "sha256" \
			&& \
		_verify_client_deb "sha512" \
			&& \
		(( "${expected_size}" == "${actual_size}" )) \
	; then
		return 0
	fi
	die
}

verify_inrelease() {
	# The only and real reason why we use the public key is to verify
	# the signed InRelease file, and it's a Debianism for external mirrors.

	# URI fragments (stable nonfree) are from the second line of
	# https://www.spotify.com/us/download/linux/
	# and from implications typical for external debian mirrors.
	if ! [[ "${PV}" =~ "9999" ]] ; then
		cat "${EDISTDIR}/${FN_INRELEASE}" > "${WORKDIR}/InRelease" || die
	elif [[ -z "${EVCS_OFFLINE}" || "${EVCS_OFFLINE}" == "0" ]] ; then
		wget "${REPO_DOMAIN}/dists/${CONFIGURATION}/InRelease" || die
	else
		cat "${EDISTDIR}/${FN_INRELEASE}" > "${WORKDIR}/InRelease" || die
	fi
	[[ -e "InRelease" ]] || die
	gpg --list-keys
	if gpg --verify "InRelease" ; then
		# The public key has no value beyond this point.
einfo
einfo "InRelease gpg verify passed."
einfo
		return 0
	fi
eerror
eerror "Download failed or is compromised for InRelease."
eerror
	die
}

unpack_online() {
einfo
einfo "To use cached downloads, set EVCS_OFFLINE=1"
einfo
	addwrite "${EDISTDIR}"
	local archive_fn=$(_get_archive_fn)
	[[ -e "${archive_fn}" ]] || die
	cp -af "${archive_fn}" "${EDISTDIR}/${archive_fn}" \
		|| die # For EVCS_OFFLINE=1
	local ACTUAL_BLAKE2B=$(\
		rhash --blake2b "${archive_fn}" \
		| cut -f 1 -d " ")
	cp -af Packages "${EDISTDIR}/${FN_PACKAGES}" || die
	cp -af InRelease "${EDISTDIR}/${FN_INRELEASE}" || die
	echo -n "${ACTUAL_BLAKE2B}" > "${EDISTDIR}/${archive_fn}.blake2b" || die
	echo -n "${archive_fn}" > "${EDISTDIR}/${PN}-${CONFIGURATION}-archive" || die
	unpack_deb "${WORKDIR}/${archive_fn}"
	return 0
}

_verify_client_blake2b() {
	[[ -e "${EDISTDIR}/${archive_fn}.blake2b" ]] || die
	local ACTUAL_BLAKE2B=$(\
		rhash --blake2b "${EDISTDIR}/${archive_fn}" \
		| cut -f 1 -d " ")
	local EXPECTED_BLAKE2B=$(\
		cat "${EDISTDIR}/${archive_fn}.blake2b" \
			| sed -e "s|[^a-f0-9]||g")
	local SIZE_BLAKE2B=$(\
		stat -c "%s" "${EDISTDIR}/${archive_fn}.blake2b"
	)
einfo
einfo "Expected BLAKE2B:\t${EXPECTED_BLAKE2B}"
einfo "Actual BLAKE2B:\t${ACTUAL_BLAKE2B}"
einfo
	if \
		[[ \
			"${EXPECTED_BLAKE2B}" == "${ACTUAL_BLAKE2B}" \
				&& \
			"${SIZE_BLAKE2B}" == "128" \
		]] \
	; then
		return 0
	fi
	return 1
}

get_archivefn_from_file() {
	[[ -e "${EDISTDIR}/${PN}-${CONFIGURATION}-archive" ]] || die
	local archive_fn=$(cat "${EDISTDIR}/${PN}-${CONFIGURATION}-archive" \
		| sed -e "s|[^a-z0-9_.-]||g")
	echo "${archive_fn}"
}

unpack_offline() {
	addread "${EDISTDIR}"
	local archive_fn=$(get_archivefn_from_file)
einfo
einfo "${archive_fn} fingerprints:"
einfo
	# The SHA512 check in verify_client_deb plus blake2b would have the
	# same integrity guarantees as Manifest.
	if _verify_client_blake2b ; then
		unpack_deb "${EDISTDIR}/${archive_fn}"
		return 0
	fi
	die
}

src_unpack() {
	verify_pubkey
	verify_inrelease
	verify_package_list
	verify_client_deb
	if ! [[ "${PV}" =~ "9999" ]] ; then
		unpack_deb "${EDISTDIR}/${FN_CLIENT}"
	elif [[ "${EVCS_OFFLINE}" == "1" ]] ; then
		unpack_offline
	else
		unpack_online
	fi
}

check_cr() {
	if [[ "${PV}" =~ "9999" ]] ; then
		# Verify Chromium DEPENDs
		# This is the minimal required but there are additional ones appended to lib_list.
		local CEF_VERSION=$(\
			  strings $(find "${ED}" -name "libcef.so") \
			| grep -E -e "\+chromium-")
		local CR_VERSION=$(\
			  strings $(find "${ED}" -name "libcef.so") \
			| grep -E -e "\+chromium-" \
			| cut -f 2 -d "-")
		# See also https://github.com/chromium/chromium/commits/${CR_VERSION}/build/install-build-deps.sh
		wget "https://raw.githubusercontent.com/chromium/chromium/${CR_VERSION}/build/install-build-deps.sh" || die
		local CR_DEPENDS=$(\
			sed -n '/# List of required run-time libraries/,/^"$/p' \
				"install-build-deps.sh")
		local ACTUAL_CR_DEPENDS_FINGERPRINT=$(\
			sed -n '/# List of required run-time libraries/,/^"$/p' \
				"install-build-deps.sh" \
			| sha512sum \
			| cut -f 1 -d " ")
einfo
einfo "CEF version:\t${CEF_VERSION}"
einfo "Chromium version:\t${CR_VERSION}"
einfo
		if [[ "${EXPECTED_CR_DEPENDS_FINGERPRINT}" != "${ACTUAL_CR_DEPENDS_FINGERPRINT}" ]] ; then
eerror
eerror "Chromium requirements changed for CEF"
eerror
eerror "Expected depends fingerprint:\t${EXPECTED_CR_DEPENDS_FINGERPRINT}"
eerror "Actual depends fingerprint:\t${ACTUAL_CR_DEPENDS_FINGERPRINT}"
eerror
eerror "QA:"
eerror
eerror "  Update EXPECTED_CR_DEPENDS_FINGERPRINT"
eerror "  Update *DEPENDs"
eerror
eerror "Chromium DEPENDS:"
eerror
eerror "  ${CR_DEPENDS}"
eerror
			die
		fi
	fi
}

_missing_libs() {
	for f in $(find \
			"${ED}/opt/${PN}/${PN}-client" \
			-type f \
			\( \
				   -executable \
				-o -name "*.so*" \
			\) \
		) ; do
		# The man page says ldd is insecure.
		local lib_list=(
			$(objdump -p "${f}" \
				| grep "NEEDED.*" \
				| cut -c 24-)
		)
		for lib in ${lib_list[@]} ; do
			if ! ldconfig -p | grep -q "${lib} " ; then
				local n=$(find \
						"${ED}/opt/${PN}/${PN}-client" \
						-maxdepth 1 \
						-name "${lib}" \
						| wc -l)
				(( ${n} == 0 )) && echo "${lib}"
			fi
		done
	done
}

check_libs() {
	local missing_libs=$(_missing_libs)
	if [[ -n "${missing_libs}" ]] ; then
ewarn
ewarn "The following system libraries are missing:"
ewarn
ewarn "${missing_libs}"
ewarn
ewarn "QA:"
ewarn
ewarn "  Update *DEPENDs."
ewarn
	fi
}

src_compile() {
	if use wayland ; then
		filter-flags '-fuse-ld=*'
		cat "${FILESDIR}/xstub.c" > "${T}/xstub.c" || die
		export CC=$(tc-getCC)
		${CC} -v "${T}/xstub.c" -o "${T}/${PN}-xstub.so" -shared || die
	fi
}

gen_wrapper() {
# FIXES:
# libayatana-appindicator-WARNING **: 13:43:34.668: Unable to get the session bus: Unknown or unsupported transport “disabled” for address “disabled:”
# LIBDBUSMENU-GLIB-WARNING **: 13:43:34.668: Unable to get session bus: Unknown or unsupported transport “disabled” for address “disabled:”
# dbus-launch required for openrc, but not required for systemd.
cat <<-EOF >"${D}/usr/bin/${PN}" || die
#!/bin/bash

ps -eo "cmd" | grep -q "^dbus-launch.*exit-with-session"
ret="\$?"
if which ps >/dev/null && (( \${ret} != 0 )) ; then
echo
echo "Did not detect a running dbus-launch.  Please read"
echo
echo "https://wiki.gentoo.org/wiki/D-Bus#The_session_bus"
echo "https://wiki.gentoo.org/wiki/Dwm#Starting"
echo
fi

if [[ -e "/usr/lib64/ffmpeg/56.58.58/lib64" ]] ; then
	export LD_LIBRARY_PATH="/usr/lib64/ffmpeg/56.58.58/lib64:\${LD_LIBRARY_PATH}"
fi

INIT_SYSTEM="${init_system}"
if test -n "\${DISPLAY}" ; then
	"${DEST}/${PN}" "\$@"
else
	LD_PRELOAD="/usr/$(get_libdir)/${PN}-xstub.so" \
	"${DEST}/${PN}" \
		--enable-features=UseOzonePlatform \
		--ozone-platform=wayland \
		"\$@"
fi
EOF
}

src_install() {
	SHARE_PATH="usr/share/${PN}"
	insinto "/usr/share/pixmaps"
	doins "${SHARE_PATH}/icons/"*".png"

	# Install in /opt/${PN}
	DEST="/opt/${PN}/${PN}-client"
	insinto "${DEST}"
	doins -r "${SHARE_PATH}/"*
	fperms +x "${DEST}/${PN}"

	dodir /usr/bin
	use wayland && dolib.so "${T}/${PN}-xstub.so"
	gen_wrapper
	fperms +x /usr/bin/${PN}

	dosym "/usr/$(get_libdir)/libcurl.so.4" \
		"/opt/${PN}/${PN}-client/libcurl-gnutls.so.4"

	local FONT_SIZES=(
		16
		22
		24
		32
		48
		64
		128
		256
		512
	)
	local size
	for size in ${FONT_SIZES[@]} ; do
		newicon -s ${size} \
		"${S}/${SHARE_PATH}/icons/${PN}-linux-${size}.png" \
			"${PN}-client.png"
	done
	domenu "${S}/${SHARE_PATH}/${PN}.desktop"
	# Dropped pax_kernel USE flag because of license.

	if \
		has "extra-dep-checks" ${IUSE} \
			&&
		use extra-dep-checks \
	; then
		check_cr
		check_libs
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_pkg_postinst

ewarn
ewarn "If ${PN^} crashes after an upgrade its cache may be corrupt.  To remove"
ewarn "the cache:"
ewarn
ewarn "  rm -rf ~/.cache/${PN} ~/.config/${PN}"
ewarn

	if ! use ffmpeg ; then
ewarn
ewarn "Some podcasts will be broken if the ffmpeg USE flag is disabled."
ewarn
	else
# This min set was required to play certain audio podcasts from the UK.
ewarn
ewarn "For some podcast to work, FFmpeg must be built with the following"
ewarn "nonfree codecs:"
ewarn
ewarn "  cbs_h264"
ewarn "  h263_parser"
ewarn "  h263dsp"
ewarn "  h264_parser"
ewarn "  h264chroma"
ewarn "  h264dsp"
ewarn "  h264parse"
ewarn "  h264pred"
ewarn "  h264qpel"
ewarn "  httpproxy_protocol"
ewarn "  mp3_decoder"
ewarn "  mpeg4video_parser"
ewarn "  mpegaudio"
ewarn "  mpegaudiodsp"
ewarn "  mpegvideo"
ewarn
ewarn "These are enabled by default by the FFmpeg project."
ewarn
ewarn "You may need to hit play it to load the FFmpeg library with a different"
ewarn "audio podcast and play the intended podcast for actual playback."
ewarn
	fi

	if ! use emoji ; then
ewarn
ewarn "Some tracks will be blank with the emoji USE flag disabled."
ewarn
	fi

	if use wayland ; then
ewarn
ewarn "Fullscreening a video podcast in a Wayland desktop environment may"
ewarn "segfault, use cinema mode instead."
ewarn
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_pkg_postrm
ewarn
ewarn "If using OpenRC, the .xinitrc must be modified for dbus-launch.  See"
ewarn
ewarn "  https://wiki.gentoo.org/wiki/D-Bus#The_session_bus"
ewarn "  https://wiki.gentoo.org/wiki/Dwm#Starting"
ewarn
}

# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.8.923 (20230608)
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.11.916 (20230712) with kernel 6.1.38, 6.4.2
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.13.661 (20230712) with kernel 6.1.38
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.22.982 (20230712) ; Sorting playlists by creator is broken.
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.25.1011 (20231123) ; Sorting playlists by creator is broken.
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.26.1187 (20231221) ; Sorting playlists by creator is broken.
# OILEDMACHINE-OVERLAY-TEST:  PASS [USA] / PASS [UK] (interactive) 1.2.37.701 (20240531) with openrc
# OILEDMACHINE-OVERLAY-TEST:  FAIL (interactive) 1.2.52.442 (20250111) with openrc
# OILEDMACHINE-OVERLAY-TEST:  FAIL (interactive) 1.2.59.514 (20250426) with openrc
# CPU support:  fail with illegal instruction
# X:  pass
# wayland:  pass with older ebuilds
# audio podcasts:  pass
# emoji render:  pass
# UK audio podcast(s):  pass with ffmpeg 4.4.x with 1.2.8.923, 1.2.13.661, 1.2.37.701
# video podcasts:  pass
# typical songs:  pass
# openrc:  pass with 1.2.37.701
# rinit:  fail with older ebuilds but may pass with latest ebuild ; needs retest
# systemd:  pass with older ebuilds

# Warnings that should errors:
# They do not appear in the systemd environment.
# libayatana-appindicator-WARNING **: 13:02:36.657: Unable to get the session bus: Unknown or unsupported transport “disabled” for address “disabled:”
# LIBDBUSMENU-GLIB-WARNING **: 13:02:36.657: Unable to get session bus: Unknown or unsupported transport “disabled” for address “disabled:”
