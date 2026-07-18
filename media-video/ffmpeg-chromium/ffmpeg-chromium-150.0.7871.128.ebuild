# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The distro ebuild maintainer makes the false assumption that it is secure once
# on each major version.  Also they degrade the original Chromium security flags.

# Same as ffmpeg ebuild
CFLAGS_HARDENED_ASSEMBLERS="gas inline nasm yasm"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan lsan msan tsan ubsan"
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_SSP_LEVEL=3 # SSP all is upstream default
CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DF DOS HO IO MC NPD OOBR OOBW RC SO UAF"

# Referenced in ffmpeg_revision in https://github.com/chromium/chromium/blob/150.0.7871.128/DEPS#L519
# Referenced in ffmpeg submodule in https://github.com/chromium/chromium/tree/150.0.7871.128/third_party
COMMIT="ad41607c61898cf7150e0fb20fe4bbabd44922a3" # FFmpeg submodule commit ID.

# Options to use as use_enable in the foo[:bar] form.
# This will feed configure with $(use_enable foo bar)
# or $(use_enable foo foo) if no :bar is set.
# foo is added to IUSE.
FFMPEG_FLAG_MAP=(
	"cpudetection:runtime-cpudetect"
	"debug"
	"+gpl"
	"vaapi"
	"vdpau"
	"vulkan"
	"nvenc:ffnvcodec"
	# Threads; we only support pthread for now but ffmpeg supports more
	"+threads:pthreads"
)

# Strings for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
ARM_CPU_FEATURES=(
	"cpu_flags_arm_thumb:armv5te"
	"cpu_flags_arm_v6:armv6"
	"cpu_flags_arm_thumb2:armv6t2"
	"cpu_flags_arm_neon:neon"
	"cpu_flags_arm_vfp:vfp"
	"cpu_flags_arm_vfpv3:vfpv3"
	"cpu_flags_arm_v8:armv8"
	"cpu_flags_arm_asimddp:dotprod"
	"cpu_flags_arm_i8mm:i8mm"
)
ARM_CPU_REQUIRED_USE="
	arm64? (
		cpu_flags_arm_v8
	)
	cpu_flags_arm_v8? (
		cpu_flags_arm_vfpv3 cpu_flags_arm_neon
	)
	cpu_flags_arm_neon? (
		cpu_flags_arm_vfp
		arm? (
			cpu_flags_arm_thumb2
		)
	)
	cpu_flags_arm_vfpv3? (
		cpu_flags_arm_vfp
	)
	cpu_flags_arm_thumb2? (
		cpu_flags_arm_v6
	)
	cpu_flags_arm_v6? (
		arm? (
			cpu_flags_arm_thumb
		)
	)
"
X86_CPU_FEATURES_RAW=(
	"3dnow:amd3dnow"
	"3dnowext:amd3dnowext"
	"aes:aesni"
	"avx:avx"
	"avx2:avx2"
	"fma3:fma3"
	"fma4:fma4"
	"mmx:mmx"
	"mmxext:mmxext"
	"sse:sse"
	"sse2:sse2"
	"sse3:sse3"
	"ssse3:ssse3"
	"sse4_1:sse4"
	"sse4_2:sse42"
	"xop:xop"
)

X86_CPU_FEATURES=(
	"${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_}"
)

X86_CPU_REQUIRED_USE="
	cpu_flags_x86_mmxext?  (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_3dnow?  (
		cpu_flags_x86_mmx
	)
	cpu_flags_x86_3dnowext? (
		cpu_flags_x86_3dnow
	)
	cpu_flags_x86_sse? (
		cpu_flags_x86_mmxext
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_sse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_aes? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma4? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma3? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_xop? (
		cpu_flags_x86_avx
	)
"

CPU_FEATURES_MAP=(
	"${ARM_CPU_FEATURES[@]}"
	"${X86_CPU_FEATURES[@]}"
)

CPU_REQUIRED_USE="
	${ARM_CPU_REQUIRED_USE}
	${X86_CPU_REQUIRED_USE}
"

CHKL_TIMESTAMPS=(
	"media-libs/opus-9999"
	"media-libs/libva-9999"
	"media-libs/vulkan-loader-9999"
)

inherit cflags-hardened chkl flag-o-matic secure-version toolchain-funcs

DESCRIPTION="Chromium's fork of FFmpeg with reduced attack surface"
HOMEPAGE="https://ffmpeg.org/"
LICENSE="
	!gpl? (
		LGPL-2.1
	)
	gpl? (
		GPL-2
	)
"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64"
RESTRICT="
	test
"
SLOT="${PV%%.*}/${PV}"
IUSE="
	${CPU_FEATURES_MAP[@]%:*}
	${FFMPEG_FLAG_MAP[@]%:*}
	doc patent_status_nonfree
	ebuild_revision_1
"
REQUIRED_USE="
	${CPU_REQUIRED_USE}
	vulkan? (
		threads
	)
"

RDEPEND="
	>=media-libs/opus-${OPUS_PV}:=
	nvenc? (
		>=media-libs/nv-codec-headers-11.1.5.3:=
	)
	vaapi? (
		>=media-libs/libva-${LIBVA_PV}:=
	)
	vdpau? (
		>=x11-libs/libvdpau-0.7:=
	)
	vulkan? (
		>=media-libs/vulkan-loader-${VULKAN_LOADER_PV}:=
	)
"
DEPEND="
	${RDEPEND}
	~www-client/chromium-sources-${PV}:=
	vulkan? (
		>=dev-util/vulkan-headers-1.3.277:=
	)
"
BDEPEND="
	>=dev-build/make-3.81
	virtual/pkgconfig
	cpu_flags_x86_mmx? (
		>=dev-lang/nasm-2.13
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-138-configure-enable-libopus.patch"
	"${FILESDIR}/chromium.patch"
)
DOCS=(
	"Changelog"
	"README.chromium"
	"README.md"
)

# This is how you reconstruct the tarball.
src_unpack() {
	cp -aT "/usr/share/chromium/${PV}/sources/third_party/ffmpeg" "${S}" || die
}

src_prepare() {
	export revision="git-N-g${COMMIT:0:10}"
	default

	echo 'include $(SRC_PATH)/ffbuild/libffmpeg.mak' >> Makefile || die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	local myconf=( )

	# Bug #918997. Will probably be fixed upstream in the next release.
	use vulkan && append-ldflags "-Wl,-z,muldefs"

	local ffuse=( "${FFMPEG_FLAG_MAP[@]}" )

	for i in "${ffuse[@]#+}" ; do
		myconf+=( $(use_enable "${i%:*}" "${i#*:}") )
	done

	# CPU features
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		use "${i%:*}" || myconf+=( "--disable-${i#*:}" )
	done

	# Try to get cpu type based on CFLAGS.
	# Bug #172723
	# We need to do this so that features of that CPU will be better used
	# If they contain an unknown CPU it will not hurt since ffmpeg's configure
	# will just ignore it.
	for i in $(get-flag "mcpu") $(get-flag "march") ; do
		[[ "${i}" == "native" ]] && i="host" # bug #273421
		if use arm64; then # 830165 - 'host' explicitly not supported on arm64
			[[ "${i}" != "host" ]] && myconf+=( --cpu="${i}" )
		else
			myconf+=( "--cpu=${i}" )
		fi
		break
	done

	# LTO support, bug #566282, bug #754654, bug #772854
	if [[ "${ABI}" != "x86" ]] && tc-is-lto; then
		# Respect -flto value, e.g -flto=thin
		local v="$(get-flag flto)"
		if [[ -n "${v}" ]] ; then
			myconf+=( "--enable-lto=${v}" )
		else
			myconf+=( "--enable-lto" )
		fi
	fi
	filter-lto

	# Mandatory configuration
	myconf=(
		--disable-stripping
		# This is only for hardcoded cflags; those are used in configure checks that may
		# interfere with proper detections, bug #671746 and bug #645778
		# We use optflags, so that overrides them anyway.
		--disable-optimizations
		--disable-libcelt # bug #664158
		"${myconf[@]}"
	)

	# Cross compile support
	if tc-is-cross-compiler ; then
		myconf+=(
			--enable-cross-compile
			--arch=$(tc-arch-kernel)
			--cross-prefix="${CHOST}-"
			--host-cc="$(tc-getBUILD_CC)"
		)
		case "${CHOST}" in
			*"mingw32"*)
				myconf+=( "--target-os=mingw32" )
				;;
			*"linux"*)
				myconf+=( "--target-os=linux" )
				;;
		esac
	fi

	myargs=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--shlibdir="${EPREFIX}/usr/$(get_libdir)"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--ar="$(tc-getAR)"
		--nm="$(tc-getNM)"
		--strip="$(tc-getSTRIP)"
		--ranlib="$(tc-getRANLIB)"
		--pkg-config="$(tc-getPKG_CONFIG)"
		--extra-cflags="-DCHROMIUM_NO_LOGGING"
		--disable-all
		--disable-autodetect
		--disable-error-resilience
		--disable-everything
		--disable-faan
		--disable-iamf
		--disable-iconv
		--disable-network
		--enable-avcodec
		--enable-avformat
		--enable-avutil
		--enable-libopus
		--enable-pic
		--enable-static
	)

	# The distro ebuild is so offending by making it unconditional.
	# So disrespectful and dishonorable.
	if use patent_status_nonfree ; then
		myargs+=(
			--enable-decoder=aac,flac,h264,libopus,mp3,pcm_alaw,pcm_f32le,pcm_mulaw,pcm_s16be,pcm_s16le,pcm_s24be,pcm_s24le,pcm_s32le,pcm_u8,vorbis
			--enable-demuxer=aac,flac,matroska,mov,mp3,ogg,wav
			--enable-parser=aac,flac,h264,mpegaudio,opus,vorbis,vp9
		)
	else
		myargs+=(
			--enable-decoder=flac,libopus,mp3,pcm_alaw,pcm_f32le,pcm_mulaw,pcm_s16be,pcm_s16le,pcm_s24be,pcm_s24le,pcm_s32le,pcm_u8,vorbis
			--enable-demuxer=flac,matroska,mov,mp3,ogg,wav
			--enable-parser=flac,mpegaudio,opus,vorbis,vp9
		)
	fi

	myargs+=(
	)

	# Use --extra-libs if needed for LIBS
	set -- "${S}/configure" \
		"${myargs[@]}" \
		--optflags="${CFLAGS}" \
		"${myconf[@]}" \
		${EXTRA_FFMPEG_CONF} \


	echo "${@}"
	"${@}" || die
}

src_compile() {
	emake V=1 "libffmpeg"
}

src_install() {
	# Bug with SLOT with emake
	exeinto "/usr/$(get_libdir)/chromium/"
	newexe "libffmpeg.so" "libffmpeg.so.${PV%%.*}"
	docinto "licenses"
	local L=(
		"COPYING.GPLv2"
		"COPYING.GPLv3"
		"COPYING.LGPLv2.1"
		"COPYING.LGPLv3"
		"CREDITS"
		"CREDITS.chromium"
		"LICENSE.md"
	)
	dodoc "${L[@]}"
	use doc && einstalldocs
}
