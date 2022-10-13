# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake-multilib flag-o-matic python-any-r1 toolchain-funcs uopts

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	SRC_URI="https://storage.googleapis.com/aom-releases/${P}.tar.gz"
	S="${WORKDIR}/${P}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org"

LICENSE="BSD-2"
SLOT="0/3"
IUSE="doc examples static-libs test"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3"
IUSE="${IUSE} cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_neon"
IUSE+=" +asm"
IUSE+="
	chromium
	pgo
	trainer-2-pass-constrained-quality
	trainer-constrained-quality
	trainer-lossless
"
REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
	pgo? (
		|| (
			trainer-2-pass-constrained-quality
			trainer-constrained-quality
			trainer-lossless
		)
	)
	trainer-2-pass-constrained-quality? ( pgo )
	trainer-constrained-quality? ( pgo )
	trainer-lossless? ( pgo )
"

BDEPEND+="
	>=dev-util/cmake-3.7
	abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	chromium? ( >=dev-lang/nasm-2.14 )
	doc? ( app-doc/doxygen )
"

PDEPEND="
	pgo? (
		media-video/ffmpeg[encode,libaom,${MULTILIB_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-aom_sadXXXxh-are-ssse3.patch"
	"${FILESDIR}/${PN}-3.1.2-cfi-rework.patch"
	"${FILESDIR}/${PN}-3.4.0-posix-c-source-ftello.patch"
)

# The PATENTS file is required to be distributed with this package bug #682214.
DOCS=( PATENTS )
# Don't strip CFI
RESTRICT="strip"
# Tests need more wiring up
RESTRICT+=" !test? ( test ) test"

get_asset_ids() {
	local types=(
		VIDEO_CGI
		VIDEO_GAMING
		VIDEO_GRAINY
		VIDEO_GENERAL
		VIDEO_SCREENCAST
	)
	local t
	for t in ${types[@]} ; do
		for i in $(seq 0 ${LIBAOM_TRAINING_MAX_ASSETS_PER_TYPE}) ; do
			echo "LIBAOM_TRAINING_${t}_${i}"
		done
	done
}

__check_video_codecs() {
	if use pgo && has_version "media-video/ffmpeg" ; then
		if ! has_version "media-video/ffmpeg[libaom]" ; then
			ewarn "You need to emerge ffmpeg with libaom for pgo training."
			ewarn "The regular emerge path with be taken instead."
			ewarn "After you install ffmpeg, re-emerge this package again."
		fi
		if ! ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
			ewarn "Missing WebM support from ffmpeg for PGO training"
		fi
	fi
}

__check_video() {
	if use pgo && has_version "media-video/ffmpeg" ; then
		if ffprobe "${video_asset_path}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			if false && ! ( ffprobe "${video_asset_path}" 2>&1 \
				| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160 for ${id}."
eerror
				die
			fi
			if false && ! ( ffprobe "${video_asset_path}" 2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps for ${id}."
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
			if (( ${t} < 3 )) ; then
eerror
eerror "The PGO video sample must be >= 3 seconds for ${id}."
eerror
				die
			fi
		else
eerror
eerror "${video_asset_path} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file in ffmpeg."
eerror
		fi
	fi
}

check_video() {
	__check_video_codecs
	local id
	for id in $(get_asset_ids) ; do
		local video_asset_path="${!id}"
		[[ -e "${video_asset_path}" ]] || continue
		__check_video
	done
}

pkg_setup() {
	LIBAOM_TRAINING_MAX_ASSETS_PER_TYPE=${LIBAOM_TRAINING_MAX_ASSETS_PER_TYPE:-100}
	if use chromium ; then
		einfo "The chromium USE flag is in testing."
	fi
	check_video
	uopts_setup
}

# The order does matter with PGO.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	if tc-is-clang \
		&& has_version "sys-devel/lld" \
		&& [[ "${CFLAGS}" =~ "-flto" ]] ; then
		sed -i -e "s|-fuse-ld=gold|-fuse-ld=lld|g" \
			build/cmake/sanitizers.cmake || die
	fi
	if tc-is-clang \
		&& has_version "sys-libs/compiler-rt-sanitizers[cfi]" \
		&& [[ "${CFLAGS}" =~ "-fsanitize".*"cfi" ]] ; then
		sed -i -e "s|-fno-sanitize-trap=cfi||g" \
			build/cmake/sanitizers.cmake || die
		if use static-libs ; then
			eapply "${FILESDIR}/libaom-3.1.2-static-link-apps.patch"
		fi
	fi
	prepare_abi() {
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cp -a "${S}" "${CMAKE_USE_DIR}" || die
			uopts_src_prepare
		done
	}
	multilib_foreach_abi prepare_abi
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
	has_ffmpeg && has_codec_requirements && return 0
	return 1
}

src_configure() { :; }

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

_src_configure() {
	export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${CMAKE_USE_DIR}" || die
	uopts_src_configure

	if tc-is-clang && ( use pgo || use epgo ) ; then
#
# Fix for:
#
# LLVM Profile Warning: Unable to track new values: Running out of static
# counters.  Consider using option -mllvm -vp-counters-per-site=<n> to allocate
# more value profile counters at compile time.
#
		append-flags -mllvm -vp-counters-per-site=8
	fi

	tc-export CC CXX

	# Stuck on ~31 frames for more than double the time compared to -O1 when encoding.
	replace-flags -O0 -O1

	local mycmakeargs=(
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF

		# Needs libjxl, currently unpackaged.
		-DCONFIG_TUNE_BUTTERAUGLI=0

		# neon support is assumed to be always enabled on arm64
		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON $(usex arm64 ON OFF))
		# ENABLE_DSPR2 / ENABLE_MSA for mips
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_SSE4_2=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
	)

	if tc-is-clang && has_version "sys-libs/compiler-rt-sanitizers[cfi]" ; then
		# Prevent Illegal instruction with /usr/bin/aomdec --help
		strip-flag-value "strip-flag-value"
		append_all -fno-sanitize=cfi-icall
	fi

	if use chromium && [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DAOM_AS_FLAGS="-DCHROMIUM"
			-DENABLE_NASM=ON
		)
	else
		mycmakeargs+=( -DENABLE_NASM=OFF )
	fi

	if [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=OFF
		)
	else
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=ON
		)
	fi

	if ! [[ "${CFLAGS}" =~ "-fsanitize=".*"cfi" ]] ; then
		mycmakeargs+=(
			-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		)
	else
		if use static-libs ; then
			# Build only once
			# If static-libs, then use CFI basic mode, else use CFI Cross-DSO mode.
			if [[ "${lib_type}" == "static" ]] ; then
				mycmakeargs+=(
					-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
				)
				#[[ "${USE}" =~ "cfi" ]] && append-ldflags -ldl # It's missing for some reason.
			else
				mycmakeargs+=(
					-DENABLE_EXAMPLES=OFF
				)
			fi
		else
			mycmakeargs+=(
				-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
			)
		fi
	fi

	# Bug when building for various ABIs.
	if ! use asm ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=generic )
	elif [[ "${ABI}" == "x86" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=x86 )
	elif [[ "${ABI}" == "amd64" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=x86_64 )
	elif [[ "${ABI}" == "mips" && $(get_libdir) == "lib" ]] ; then
		# o32
		mycmakeargs+=( -DAOM_TARGET_CPU=mips32 )
	elif [[ "${ABI}" == "mips" && $(get_libdir) == "lib32" ]] ; then
		# n32
		mycmakeargs+=( -DAOM_TARGET_CPU=mips64 )
	elif [[ "${ABI}" == "mips" && $(get_libdir) == "lib64" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=mips64 )
	elif [[ "${ABI}" == "arm" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=arm )
	elif [[ "${ABI}" == "arm64" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=arm64 )
	elif [[ "${ABI}" == "ppc" ]] ; then
		mycmakeargs+=( -DAOM_TARGET_CPU=ppc )
	elif [[ "${ABI}" == "ppc64" ]] ; then
		ewarn "No reference to ppc64 in source"
		mycmakeargs+=( -DAOM_TARGET_CPU=ppc )
	else
		mycmakeargs+=( -DAOM_TARGET_CPU=generic )
	fi
	cmake_src_configure
}

_vdecode() {
	einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -i "${T}/traintemp/test.webm" -f null - )
	"${cmd[@]}" || die
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
	if [[ -n "${LIBAOM_TRAINING_CUSTOM_VOD_RESOLUTIONS}" ]] ; then
		for e in ${LIBAOM_TRAINING_CUSTOM_VOD_RESOLUTIONS} ; do
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

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local duration="3"
	local m60fps="1"
	local extra_args=()
	local bits="" # 8 bit

	[[ "${fps}" == "60" ]] && m60fps="1.5"
	[[ "${dynamic_range}" == "hdr" ]] && return

	local pf=$(ffprobe -show_entries stream=pix_fmt "${video_asset_path}" 2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${pf}" =~ "444" ]] ; then
		extra_args+=( -profile:v 1 ) # 4:4:4 8 bit chroma subsampling
		extra_args+=( -pix_fmt yuv422p )
	elif [[ "${pf}" =~ "422" ]] ; then
		extra_args+=( -profile:v 2 ) # 4:2:2 8 bit chroma subsampling
		extra_args+=( -pix_fmt yuv422p )
	else
		extra_args+=( -profile:v 0 ) # 4:2:0 or 4:0:0 8 bit chroma subsampling
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
		-c:v libaom-av1 \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_TRAINING_ARGS} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.webm"
	)
	"${cmd[@]}" || die
	_vdecode "${cheight} ${fps} fps"
}

_trainer_plan_constrained_quality() {
	local L=(
		$(_get_resolutions)
	)

	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for 1 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_constrained_quality_training_session "${e}"
			done
		done
	fi
}

_trainer_plan_2_pass_constrained_quality_training_session() {
	local entry="${1}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local dynamic_range=$(echo "${entry}" | cut -f 4 -d ";")
	local duration="3"
	local mhdr="1"
	local m60fps="1"
	local bits=""

	local extra_args=()

	[[ "${fps}" == "60" ]] && m60fps="1.5"

	local pf=$(ffprobe -show_entries stream=pix_fmt "${video_asset_path}" 2>/dev/null \
		| grep "pix_fmt" \
		| cut -f 2 -d "=")

	if [[ "${dynamic_range}" == "hdr" ]] ; then
		extra_args+=(
			# See libavfilter/vf_setparams.c
			# Target HDR10
			-color_primaries bt2020
			-color_range limited # video
			-color_trc smpte2084
			-colorspace bt2020nc
		)

		if [[ "${pv}" =~ "p12" ]] ; then
			bits="12"
		else
			bits="10"
		fi
		bits="${bits}le"
		mhdr="1.25"
	else
		bits="" # 8 bit
	fi

	if [[ "${pf}" =~ "444" ]] ; then
		extra_args+=( -profile:v 1 ) # 4:4:4 8/10 bit chroma subsampling
		extra_args+=( -pix_fmt yuv422p${bits} )
	elif [[ "${pf}" =~ "422" ]] ; then
		extra_args+=( -profile:v 2 ) # 4:2:2 8/10/12 bit chroma subsampling; or 12 bit 4:0:0, 4:4:4
		extra_args+=( -pix_fmt yuv422p${bits} )
	else
		extra_args+=( -profile:v 0 ) # 4:2:0 or 4:0:0 8/10 bit chroma subsampling
		extra_args+=( -pix_fmt yuv420p${bits} )
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
	local avgrate=$(python -c "import math;print(abs(4.95*pow(10,-8)*(30*${width}*${height})-0.2412601555) * ${mhdr} * ${m60fps} * 1000)")
	local maxrate=$(python -c "print(${avgrate}*1.45)") # moving
	local minrate=$(python -c "print(${avgrate}*0.5)") # stationary

	local cmd
	local cheight=$(_cheight "${height}")
	einfo "Encoding as ${cheight} for ${duration} sec, ${fps} fps"
	cmd1=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v libaom-av1 \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_TRAINING_ARGS} \
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
		-c:v libaom-av1 \
		-maxrate ${maxrate}k -minrate ${minrate}k -b:v ${avgrate}k \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_TRAINING_ARGS} \
		-pass 2 \
		${extra_args[@]} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/traintemp/test.webm"
	)
	"${cmd1[@]}" || die
	"${cmd2[@]}" || die
	_vdecode "${cheight} ${fps} fps"
}

_trainer_plan_2_pass_constrained_quality() {
	local L=(
		$(_get_resolutions)
	)

	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for 2 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_2_pass_constrained_quality_training_session "${e}"
			done
		done
	fi
}

_trainer_plan_lossless() {
	if train_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running trainer for lossless"
			local cmd
			einfo "Encoding for lossless"
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${video_asset_path}" \
				-c:v libaom-av1 \
				-crf 0 \
				${LIBAOM_TRAINING_ARGS_LOSSLESS} \
				-an \
				-t 3 \
				"${T}/traintemp/test.webm"
			)
			"${cmd[@]}" || die
			_vdecode "lossless"
		done
	fi
}

train_trainer_custom() {
	[[ "${lib_type}" == "static" ]] && return
	export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	if use trainer-constrained-quality ; then
		_trainer_plan_constrained_quality
	fi
	if use trainer-2-pass-constrained-quality ; then
		_trainer_plan_2_pass_constrained_quality
	fi
	if use trainer-lossless ; then
		_trainer_plan_lossless
	fi
}

if ! has libaom_pkg_die ${EBUILD_DEATH_HOOKS} ; then
        EBUILD_DEATH_HOOKS+=" libaom_pkg_die";
fi

libaom_pkg_die() {
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

_src_compile() {
	export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
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

src_compile() {
	mkdir -p "${T}/traintemp" || die
	compile_abi() {
		for lib_type in $(get_lib_types) ; do

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
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			"${BUILD_DIR}"/test_libaom || die
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			if multilib_is_native_abi && use doc ; then
				local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
			fi
			cmake_src_install
			uopts_src_install
		done
	}
	multilib_foreach_abi install_abi

	find "${ED}" -type f \( -name "*.la" \) -delete || die
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
ewarn
ewarn "The following package must be installed before PGOing this package:"
ewarn
ewarn "  media-video/ffmpeg[encode,libaom,$(get_arch_enabled_use_flags)]"
ewarn
	fi
	uopts_pkg_postinst
}
