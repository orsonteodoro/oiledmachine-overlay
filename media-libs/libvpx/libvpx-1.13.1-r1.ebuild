# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO:  live streamer trainers will be added after portage secure wipe hooks
# [aka bash exit/abort traps] are implemented/fixed.

EAPI=8

LIBVPX_TESTDATA_VER=1.13.1
N_SAMPLES=1

inherit flag-o-matic flag-o-matic-om llvm multilib-minimal toolchain-funcs uopts

#
# To create a new testdata tarball:
#
# 1. Unpack source tarball or checkout git tag
# 2. mkdir libvpx-testdata
# 3. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 4. configure --enable-unit-tests --enable-vp9-highbitdepth
# 5. make testdata
# 6. tar -caf libvpx-testdata-${MY_PV}.tar.xz libvpx-testdata
#

SRC_URI="
	https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://dev.gentoo.org/~whissi/dist/libvpx/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz
	)
"
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="https://www.webmproject.org"
LICENSE="BSD"
SLOT="0/7"
KEYWORDS="
~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86
~amd64-linux ~x86-linux
"
PPC_IUSE="
	cpu_flags_ppc_vsx3
"
TRAINER_IUSE="
	trainer-2-pass-constrained-quality
	trainer-2-pass-constrained-quality-quick
	trainer-constrained-quality
	trainer-constrained-quality-quick
	trainer-lossless
	trainer-lossless-quick
"
IUSE="
${PPC_IUSE}
${TRAINER_IUSE}
chromium doc +examples +highbitdepth pgo postproc static-libs svc test +threads
"
REQUIRED_USE="
	pgo? (
		|| (
			${TRAINER_IUSE}
		)
	)
	test? (
		threads
	)
	trainer-2-pass-constrained-quality? (
		pgo
	)
	trainer-2-pass-constrained-quality-quick? (
		pgo
	)
	trainer-constrained-quality? (
		pgo
	)
	trainer-constrained-quality-quick? (
		pgo
	)
	trainer-lossless? (
		pgo
	)
	trainer-lossless-quick? (
		pgo
	)
"
# Disable test phase when USE="-test"
RESTRICT="
	!test? (
		test
	)
	strip
"
BDEPEND="
	dev-lang/perl
	abi_x86_32? (
		dev-lang/yasm
	)
	abi_x86_64? (
		dev-lang/yasm
	)
	abi_x86_x32? (
		dev-lang/yasm
	)
	chromium? (
		>=dev-lang/nasm-2.14
	)
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"
PDEPEND="
	pgo? (
		media-video/ffmpeg[${MULTILIB_USEDEP},encode,vpx]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.3.0-sparc-configure.patch" # 501010
	"${FILESDIR}/${PN}-1.10.0-exeldflags.patch"
	"${FILESDIR}/${PN}-1.13.1-allow-fortify-source.patch"
)

get_asset_ids() {
	local types=(
		VIDEO_CGI
		VIDEO_GAMING
		VIDEO_GENERAL
		VIDEO_GRAINY
		VIDEO_SCREENCAST
	)
	local t
	for t in ${types[@]} ; do
		for i in $(seq 0 ${LIBVPX_TRAINING_MAX_ASSETS_PER_TYPE}) ; do
			echo "LIBVPX_TRAINING_${t}_${i}"
		done
	done
}

__check_video_codec() {
	if use pgo && has_version "media-video/ffmpeg" ; then
		if ! has_version "media-video/ffmpeg[vpx]" ; then
			ewarn "You need to emerge ffmpeg with vpx for pgo training."
			ewarn "The regular emerge path with be taken instead."
			ewarn "After you install ffmpeg, re-emerge this package again."
		fi
		if ! ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
			ewarn "Missing WebM support from ffmpeg"
		fi
	fi
}

__check_video() {
	if use pgo && has_version "media-video/ffmpeg" ; then
		if [[ -z "${video_asset_path}" ]] ; then
eerror
eerror "${id} is missing the abspath to your vp8/vp9 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
			die
		fi
		if ffprobe "${video_asset_path}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			if false && ! ( ffprobe "${video_asset_path}" 2>&1 \
				| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
				die
			fi
			if false && ! ( ffprobe "${video_asset_path}" 2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
				die
			fi

			local d=$(ffprobe "${video_asset_path}" 2>&1 \
				| grep -E -e "Duration" \
				| cut -f 4 -d " " \
				| sed -e "s|,||g" \
				| cut -f 1 -d ".")
			local h=$(($(echo "${d}" \
				| cut -f 1 -d ":") * 60 * 60))
			local m=$(($(echo "${d}" \
				| cut -f 2 -d ":") * 60))
			local s=$(($(echo "${d}" \
				| cut -f 3 -d ":") * 1))
			local t=$((${h} + ${m} + ${s}))
			if (( ${t} < 5 )) ; then
eerror
eerror "The PGO video sample must be >= 5 seconds."
eerror
				die
			fi
		else
eerror
eerror "${video_asset_path} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file"
eerror
		fi
	fi
}

__pgo_setup() {
	export LIBVPX_TRAINING_MAX_ASSETS_PER_TYPE=${LIBVPX_TRAINING_MAX_ASSETS_PER_TYPE:-100}
	__check_video_codec
	local id
	for id in $(get_asset_ids) ; do
		local video_asset_path="${!id}"
		[[ -e "${video_asset_path}" ]] || continue
		__check_video
	done
}

pkg_setup() {
	__pgo_setup
	llvm_pkg_setup
	uopts_setup
}

get_native_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${DEFAULT_ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_multiabi_ffmpeg() {
	if multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_native_abi_use)]" ; then
		echo "${EPREFIX}/usr/bin/ffmpeg"
	elif ! multilib_is_native_abi && has_version "media-video/ffmpeg[${MULTILIB_ABI_FLAG}]" ; then
		echo "${EPREFIX}/usr/bin/ffmpeg-${ABI}"
	else
		echo ""
	fi
}

has_ffmpeg() {
	local x=$(get_multiabi_ffmpeg)
	if [[ -n "${x}" && -e "${x}" ]] ; then
		return 0
	else
		return 1
	fi
}

has_codec_requirements() {
	local meets_input_req=1
	local meets_output_req=0
	local id
	addpredict /dev/video*
	for id in $(get_asset_ids) ; do
		local video_asset_path="${!id}"
		[[ ! -e "${video_asset_path}" ]] && continue
		if ! ffprobe "${video_asset_path}" 2>/dev/null 1>/dev/null ; then
			meets_input_req=0
		fi
	done
	if ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
		meets_output_req=1
	fi
	(( ${meets_input_req} && ${meets_output_req} )) && return 0
	return 1
}

train_meets_requirements() {
	if has_ffmpeg ; then
einfo "media-video/ffmpeg[${MULTILIB_ABI_FLAG}] support:\tY"
	else
einfo "media-video/ffmpeg[${MULTILIB_ABI_FLAG}] support:\tN"
	fi
	if has_codec_requirements ; then
einfo "Codec requirements:\t\t\t\tY"
	else
einfo "Codec requirements:\t\t\t\tN"
	fi
	has_ffmpeg && has_codec_requirements && return 0
	return 1
}

# The order does matter in PGO.
# Since we cannot combine a static library with the encoder app during PGO
# training, we have to reuse the shared PGO profile.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

src_prepare() {
	default
	if tc-is-clang ; then
		eapply "${FILESDIR}/libvpx-1.10.0-cfi-static-link.patch"
		eapply "${FILESDIR}/libvpx-1.10.0-add-cxxflags-to-linking-libvpx.patch"
		eapply "${FILESDIR}/libvpx-1.10.0-add-cxxflags-to-linking-examples.patch"
	else
		eapply "${FILESDIR}/libvpx-1.10.0-gcov.patch"
	fi

	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			einfo "Copying to ${S}"
			cp -a "${S_orig}" "${S}" || die
			uopts_src_prepare
		done
	}
	multilib_foreach_abi prepare_abi
}

add_sandbox_exceptions() {
	# https://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/ #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn
	addpredict /session_mm_cli0.sem #nowarn
}

src_configure() { :; }

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

_src_configure() {
	export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	[[ -f Makefile ]] && emake clean
	unset CODECS #357487
	einfo "PGO_PHASE: ${PGO_PHASE}"

	add_sandbox_exceptions

	uopts_src_configure

	# Prevent below 25 FPS and erratic FPS
	# Fork ebuild if you need -O0
	replace-flags '-O0' '-O1'

	if is-flagq "-Ofast" ; then
		# Precaution
		append_all $(test-flags -fno-allow-store-data-races)
	fi

	if tc-is-clang && ( use pgo || use epgo ) ; then
		append-flags -mllvm -vp-counters-per-site=8
	fi

	# #498364: sse doesn't work without sse2 enabled,
	local myconfargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-pic
		--enable-vp8
		--enable-vp9
		--extra-cflags="${CFLAGS}"
		$(use_enable examples)
		$(use_enable postproc)
		$(use_enable svc experimental)
		$(use_enable test unit-tests)
		$(use_enable threads multithread)
		$(use_enable highbitdepth vp9-highbitdepth)
	)

	strip-flag-value "cfi-icall"
	if tc-is-clang && has_version "sys-libs/compiler-rt-sanitizers[cfi]" ; then
		append_all -fno-sanitize=cfi-icall # Prevent illegal instruction with vpxenc --help
	fi

	if use chromium && [[ "${lib_type}" == "static" ]] ; then
		export ASFLAGS="-DCHROMIUM"
		myconfargs+=( --as=nasm )
	else
		unset ASFLAGS
	fi

	if [[ "${lib_type}" == "shared" ]] ; then
		myconfargs+=(
			--enable-shared
			--disable-static
		)
	else
		myconfargs+=(
			--disable-shared
			--enable-static
		)
	fi

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# libvpx is fragile: both for tests at runtime.
	# We force using the generic target unless we know things work to
	# avoid runtime breakage on exotic arches.
	if [[ ${ABI} == amd64 ]] ; then
		myconfargs+=( --force-target=x86_64-linux-gcc )
	elif [[ ${ABI} == x86 ]] ; then
		myconfargs+=( --force-target=x86-linux-gcc )
	elif [[ ${ABI} == arm64 ]] ; then
		myconfargs+=( --force-target=arm64-linux-gcc )
	elif [[ ${ABI} == arm ]] && [[ ${CHOST} == *armv7* ]] ; then
		myconfargs+=( --force-target=armv7-linux-gcc )
	elif [[ ${ABI} == ppc64 ]] && [[ $(tc-endian) != big ]] && use cpu_flags_ppc_vsx3; then
		# only enable this target for at least power9 CPU running little-endian
		myconfargs+=( --force-target=ppc64le-linux-gcc )
	else
		myconfargs+=( --force-target=generic-gnu )
	fi

	# powerpc toolchain is not recognized anymore, #694368
	#[[ ${CHOST} == powerpc-* ]] && myconfargs+=( --force-target=generic-gnu )

	# Build with correct toolchain.
	tc-export CC CXX AR NM
	# Link with compiler by default, the build system should override this if needed.
	export LD="${CC}"

	if multilib_is_native_abi; then
		myconfargs+=( $(use_enable doc install-docs) $(use_enable doc docs) )
	else
		# not needed for multilib and will be overwritten anyway.
		myconfargs+=( --disable-examples --disable-install-docs --disable-docs )
	fi

	if train_meets_requirements && tc-is-gcc && [[ "${PGO_PHASE}" == "PGI" ]] ; then
		myconfargs+=( --enable-gcov )
	fi

	echo "${S}"/configure "${myconfargs[@]}" >&2
	"${S}"/configure "${myconfargs[@]}"
}

_vdecode() {
	local decoding_codec="${1}"
	local msg="${2}"
	einfo "Decoding ${msg}"
	cmd=( "${FFMPEG}" -c:v ${decoding_codec} -i "${T}/traintemp/test.webm" -f null - )
	einfo "${cmd[@]}"
	"${cmd[@]}" || die
}

_get_resolutions_quick() {
	local L=(
		# Most videos are 24 FPS.
		"30;1280;720;sdr"
	)
	local e
	if [[ -n "${LIBVPX_TRAINING_CUSTOM_VOD_RESOLUTIONS_QUICK}" ]] ; then
		for e in ${LIBVPX_TRAINING_CUSTOM_VOD_RESOLUTIONS_QUICK} ; do
			echo "${e}"
		done
	else
		for e in ${L[@]} ; do
			echo "${e}"
		done
	fi
}

_get_resolutions() {
	local L=(
		"30;426;240;sdr"
		"60;426;240;sdr"
		"30;640;360;sdr"
		"60;640;360;sdr"
		"30;854;480;sdr"
		"60;854;480;sdr"
		"30;1280;720;sdr"
		"60;1280;720;sdr"
		"30;1920;1080;sdr"
		"60;1920;1080;sdr"
		"30;2560;1440;sdr"
		"60;2560;1440;sdr"
		"30;3840;2160;sdr"
		"60;3840;2160;sdr"
		"30;7680;4320;sdr"
		"60;7680;4320;sdr"

		"30;1280;720;hdr"
		"60;1280;720;hdr"
		"30;1920;1080;hdr"
		"60;1920;1080;hdr"
		"30;2560;1440;hdr"
		"60;2560;1440;hdr"
		"30;3840;2160;hdr"
		"60;3840;2160;hdr"
		"30;7680;4320;hdr"
		"60;7680;4320;hdr"
	)

	local e
	if [[ -n "${LIBVPX_TRAINING_CUSTOM_VOD_RESOLUTIONS}" ]] ; then
		for e in ${LIBVPX_TRAINING_CUSTOM_VOD_RESOLUTIONS} ; do
			echo "${e}"
		done
	else
		for e in ${L[@]} ; do
			echo "${e}"
		done
	fi
}

# common name for height
_cheight() {
	local height="${1}"
	if [[ "${height}" == "480" ]] ; then
		echo "SD (480p)"
	elif [[ "${height}" == "720" ]] ; then
		echo "HD (720p)"
	elif [[ "${height}" == "1080" ]] ; then
		echo "FHD (1080p)"
	elif [[ "${height}" == "1440" ]] ; then
		echo "QHD (1440p)"
	elif [[ "${height}" == "2160" ]] ; then
		echo "4K"
	elif [[ "${height}" == "4320" ]] ; then
		echo "8K"
	else
		echo "${height}p"
	fi
}

_trainer_plan_constrained_quality_training_session() {
	local entry="${1}"
	local duration="${2}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local m60fps="1"
	local extra_args=()


	[[ "${fps}" == "60" ]] && m60fps="1.5"
	[[ "${dynamic_range}" == "hdr" ]] && return

	local pf=$(ffprobe -show_entries stream=pix_fmt "${video_asset_path}" 2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${pf}" =~ ("422"|"444") ]] ; then
		extra_args+=( -profile:v 1 ) # 4:2:2 or 4:4:4 8 bit chroma subsampling
		extra_args+=( -pix_fmt yuv422p )
	else
		extra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
		extra_args+=( -pix_fmt yuv420p )
	fi

	if [[ "${id}" =~ ("CGI"|"GAMING"|"SCREENCAST") ]] ; then
		extra_args+=( -tune-content 1 ) # 1=screen
	elif [[ "${id}" =~ "GRAINY" ]] ; then
		extra_args+=( -tune-content 2 ) # 2=film
	elif [[ "${id}" =~ "GENERAL" ]] ; then
		extra_args+=( -tune-content 0 ) # 0=default
	fi

	# Formula based on point slope linear curve fitting.  Drop 1000 for Mbps.
	# Yes 30 for 30 fps is not a mistake, so we scale it later with m60fps.
	local avgrate=$(python -c "import math;print(abs(4.95*pow(10,-8)*(30*${width}*${height})-0.2412601555) * ${m60fps} * 1000)")
	local maxrate=$(python -c "print(${avgrate}*1.45)") # moving
	local minrate=$(python -c "print(${avgrate}*0.5)") # stationary

	local cmd
	local cheight=$(_cheight "${height}")
	einfo "Encoding as ${cheight} for ${duration} sec, ${fps} fps"
	cmd=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${training_args} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.webm"
	)
	local len=$(ffprobe -i "${video_asset_path}" -show_entries format=duration -v quiet -of csv="p=0" | cut -f 1 -d ".")
	(( len < 0 )) && len=0
	for i in $(seq 1 ${N_SAMPLES}) ; do
		local pos=$(python -c "print(int(${i}/${N_SAMPLES} * ${len}))")
		einfo "Seek:  ${i} / ${N_SAMPLES}"
		einfo "Position / Length:  ${pos} / ${len}"
		einfo "${cmd[@]} -ss ${pos}"
		"${cmd[@]}" -ss ${pos} || die
		_vdecode "${decoding_codec}" "${cheight}, ${fps} fps"
	done
}

_trainer_plan_constrained_quality() {
	local L=()
	local mode="${2}"
	local duration

	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_TRAINING_VP8_ARGS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_TRAINING_VP9_ARGS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if [[ "${mode}" == "quick" ]] ; then
		L=( $(_get_resolutions_quick) )
		duration="1"
	else
		L=( $(_get_resolutions) )
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for ${encoding_codec} for 1 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_constrained_quality_training_session "${e}" "${duration}"
			done
		done
	fi
}

_trainer_plan_2_pass_constrained_quality_training_session() {
	local entry="${1}"
	local duration="${2}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local mhdr="1"
	local m60fps="1"
	local bits=""

	local extra_args=()

	local pf=$(ffprobe -show_entries stream=pix_fmt "${video_asset_path}" 2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${dynamic_range}" == "hdr" ]] ; then
		extra_args+=(
			# See libavfilter/vf_setparams.c
			# Target HDR10
			-color_primaries bt2020
			-color_range 0 # 0 = limited [16, 235], 1 = full [0, 255]
			-color_trc smpte2084
			-colorspace bt2020nc
		)
		mhdr="1.25"
		bits="10le"
	else
		bits="" # 8 bit
	fi

	# Rounding color complexity rules
	# Higher complexity or larger gamuts goes up
	# Old complexity or smaller gamuts  goes down
	if [[ "${dynamic_range}" == "hdr" ]] ; then
		if [[ "${pf}" =~ ("422"|"444") ]] ; then
			extra_args+=( -profile:v 3 ) # 4:2:2 or 4:4:4 10/12 bit chroma subsampling
			extra_args+=( -pix_fmt yuv422p${bits} )
		else
			extra_args+=( -profile:v 2 ) # 4:2:0 10/12 bit chroma subsampling
			extra_args+=( -pix_fmt yuv420p${bits} )
		fi
	else
		if [[ "${pf}" =~ ("422"|"444") ]] ; then
			extra_args+=( -profile:v 1 ) # 4:2:2 or "4:4:4" 8 bit chroma subsampling
			extra_args+=( -pix_fmt yuv422p )
		else
			extra_args+=( -profile:v 0 ) # 4:2:0 8 bit chroma subsampling
			extra_args+=( -pix_fmt yuv420p )
		fi
	fi

	[[ "${fps}" == "60" ]] && m60fps="1.5"

	if [[ "${id}" =~ ("CGI"|"GAMING"|"SCREENCAST") ]] ; then
		extra_args+=( -tune-content 1 ) # 1=screen
	elif [[ "${id}" =~ "GRAINY" ]] ; then
		extra_args+=( -tune-content 2 ) # 2=film
	elif [[ "${id}" =~ "GENERAL" ]] ; then
		extra_args+=( -tune-content 0 ) # 0=default
	fi

	# Formula based on point slope linear curve fitting.  Drop 1000 for Mbps.
	# Yes 30 for 30 fps is not a mistake, so we scale it later with m60fps.
	local avgrate=$(python -c "import math;print(abs(4.95*pow(10,-8)*(30*${width}*${height})-0.2412601555) * ${mhdr} * ${m60fps} * 1000)")
	local maxrate=$(python -c "print(${avgrate}*1.45)") # moving
	local minrate=$(python -c "print(${avgrate}*0.5)") # stationary

	local cheight=$(_cheight "${height}")

	local cmd
	einfo "Encoding as ${cheight} for ${duration} sec, ${fps} fps"
	cmd1=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${training_args} \
		-pass 1 \
		${extra_args[@]} \
		-an \
		-r ${fps} \
		-t ${duration} \
		-f null /dev/null
	)
	cmd2=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v ${encoding_codec} \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${training_args} \
		-pass 2 \
		${extra_args[@]} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.webm"
	)

	local len=$(ffprobe -i "${video_asset_path}" -show_entries format=duration -v quiet -of csv="p=0" | cut -f 1 -d ".")
	(( len < 0 )) && len=0
	for i in $(seq 1 ${N_SAMPLES}) ; do
		local pos=$(python -c "print(int(${i}/${N_SAMPLES} * ${len}))")
		einfo "Seek:  ${i} / ${N_SAMPLES}"
		einfo "Position / Length:  ${pos} / ${len}"
		einfo "${cmd1[@]} -ss ${pos}"
		"${cmd1[@]}" -ss ${pos} || die
		einfo "${cmd2[@]} -ss ${pos}"
		"${cmd2[@]}" -ss ${pos} || die
		_vdecode "${decoding_codec}" "${cheight}, ${fps} fps"
	done
}

_trainer_plan_2_pass_constrained_quality() {
	local L=()
	local mode="${2}"
	local duration

	local encoding_codec="${1}"
	local decoding_codec
	local training_args

	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_TRAINING_VP8_ARGS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_TRAINING_VP9_ARGS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if [[ "${mode}" == "quick" ]] ; then
		L=( $(_get_resolutions_quick) )
		duration="1"
	else
		L=( $(_get_resolutions) )
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for ${encoding_codec} for 2 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_2_pass_constrained_quality_training_session "${e}" "${duration}"
			done
		done
	fi
}

_trainer_plan_lossless() {
	local mode="${2}"
	local duration

	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_TRAINING_VP8_ARGS_LOSSLESS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_TRAINING_VP9_ARGS_LOSSLESS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if [[ "${mode}" == "quick" ]] ; then
		duration="1"
	else
		duration="3"
	fi

	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for ${encoding_codec} for lossless"
			einfo "Encoding for lossless"
			local cmd
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${video_asset_path}" \
				-c:v ${encoding_codec} \
				-lossless 1 \
				${training_args} \
				-an \
				-t ${duration} \
				"${T}/traintemp/test.webm"
			)
			local len=$(ffprobe -i "${video_asset_path}" -show_entries format=duration -v quiet -of csv="p=0" | cut -f 1 -d ".")
			(( len < 0 )) && len=0
			for i in $(seq 1 ${N_SAMPLES}) ; do
				local pos=$(python -c "print(int(${i}/${N_SAMPLES} * ${len}))")
				einfo "Seek:  ${i} / ${N_SAMPLES}"
				einfo "Position / Length:  ${pos} / ${len}"
				einfo "${cmd[@]} -ss ${pos}"
				"${cmd[@]} -ss ${pos}" || die
				_vdecode "${decoding_codec}" "lossless"
			done
		done
	fi
}

train_trainer_custom() {
	einfo "Called train_trainer_custom"
	[[ "${lib_type}" == "static" ]] && return # Reuse the shared PGO profile
	export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}"
	if use trainer-2-pass-constrained-quality ; then
		_trainer_plan_2_pass_constrained_quality "libvpx" "full"
		_trainer_plan_2_pass_constrained_quality "libvpx-vp9" "full"
	fi
	if use trainer-2-pass-constrained-quality-quick ; then
		_trainer_plan_2_pass_constrained_quality "libvpx" "quick"
		_trainer_plan_2_pass_constrained_quality "libvpx-vp9" "quick"
	fi
	if use trainer-constrained-quality ; then
		_trainer_plan_constrained_quality "libvpx" "full"
		_trainer_plan_constrained_quality "libvpx-vp9" "full"
	fi
	if use trainer-constrained-quality-quick ; then
		_trainer_plan_constrained_quality "libvpx" "quick"
		_trainer_plan_constrained_quality "libvpx-vp9" "quick"
	fi
	if use trainer-lossless ; then
		_trainer_plan_lossless "libvpx" "full"
		_trainer_plan_lossless "libvpx-vp9" "full"
	fi
	if use trainer-lossless-quick ; then
		_trainer_plan_lossless "libvpx" "quick"
		_trainer_plan_lossless "libvpx-vp9" "quick"
	fi
}

_src_compile() {
	export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	# build verbose by default and do not build examples that will not be installed
	# disable stripping of debug info, bug #752057
	# (only works as long as upstream does not use non-gnu strip)
	emake verbose=yes GEN_EXAMPLES= HAVE_GNU_STRIP=no
}

_src_pre_train() {
	export LD_LIBRARY_PATH="${BUILD_DIR}"
	export FFMPEG=$(get_multiabi_ffmpeg)
}

_src_post_train() {
	unset LD_LIBRARY_PATH
}

_src_post_pgo() {
	export PGO_RAN=1
}

if ! has libvpx_pkg_die ${EBUILD_DEATH_HOOKS} ; then
        EBUILD_DEATH_HOOKS+=" libvpx_pkg_die";
fi

libvpx_pkg_die() {
	_wipe_data
}

_wipe_data() {
	# May contain sensitive data
	local p
	for p in $(find "${T}/traintemp" -type f) ; do
		if [[ -e "${p}" ]] ; then
			einfo "Wiping possibly sensitive training data"
			shred --remove=wipesync "${p}"
		fi
	done
}

src_compile() {
	mkdir -p "${T}/traintemp" || die
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			if [[ "${lib_type}" == "static" ]] ; then
				uopts_n_training
			else
				uopts_y_training
			fi

			uopts_src_compile
		done
	}
	multilib_foreach_abi compile_abi
	_wipe_data
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			local -x LD_LIBRARY_PATH="${BUILD_DIR}"
			local -x LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata"
			emake verbose=yes GEN_EXAMPLES= test
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
			multilib_is_native_abi && use doc && dodoc -r docs/html
			uopts_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

get_arch_enabled_use_flags() {
	local all_use=()
	for p in $(multilib_get_enabled_abi_pairs) ; do
		local u=${p%.*}
		all_use+=( ${u} )
	done
	echo "${all_use[@]}" | tr " " ","
}

pkg_postinst() {
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
ewarn
ewarn "No PGO optimization performed.  Please re-emerge this package."
ewarn
ewarn "The following package must be installed before PGOing this package:"
ewarn
ewarn "  media-video/ffmpeg[encode,vpx,$(get_arch_enabled_use_flags)]"
ewarn
	fi
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo, cfi-exceptions
