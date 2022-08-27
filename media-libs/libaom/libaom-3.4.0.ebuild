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
IUSE+=" pgo pgo-custom
	pgo-trainer-2-pass-constrained-quality
	pgo-trainer-constrained-quality
	pgo-trainer-lossless
	chromium
"
REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
	pgo? (
		|| (
			pgo-custom
			pgo-trainer-2-pass-constrained-quality
			pgo-trainer-constrained-quality
			pgo-trainer-lossless
		)
	)
	pgo-custom? ( pgo )
	pgo-trainer-2-pass-constrained-quality? ( pgo )
	pgo-trainer-constrained-quality? ( pgo )
	pgo-trainer-lossless? ( pgo )
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
	"${FILESDIR}/libaom-2.0.1-aom_sadXXXxh-are-ssse3.patch"
	"${FILESDIR}/libaom-3.1.2-cfi-rework.patch"
)

# the PATENTS file is required to be distributed with this package bug #682214
DOCS=( PATENTS )
# Don't strip CFI
RESTRICT="strip"
# Tests need more wiring up
RESTRICT+=" !test? ( test ) test"

get_asset_ids() {
	local i
	for i in $(seq 0 ${LIBAOM_PGO_MAX_ASSETS}) ; do
		echo "LIBAOM_PGO_VIDEO_i"
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
	LIBAOM_PGO_MAX_ASSETS=${LIBAOM_PGO_MAX_ASSETS:-100}
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
	local meets_input_req=0
	local meets_output_req=0
	if ffprobe "${video_asset_path}" 2>/dev/null 1>/dev/null ; then
		meets_input_req=1
	fi
	if ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
		meets_output_req=1
	fi
	(( ${meets_input_req} && ${meets_output_req} )) && return 0
	return 1
}

tpgo_meets_requirements() {
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

	tc-export CC CXX

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
	cmd=( "${FFMPEG}" -i "${T}/test.webm" -f null - )
	"${cmd[@]}" || die
}

_trainer_plan_custom() {
	if use pgo-custom && [[ -e "pgo-custom.sh" ]] ; then
		chown portage:portage pgo-custom.sh || die
		chmod +x pgo-custom || die
		./pgo-custom.sh || die
	elif use pgo-custom && [[ ! -e "pgo-custom.sh" ]] ; then
eerror
eerror "Could not find pgo-custom.sh in ${S}"
eerror
		die
	fi
}

_trainer_plan_constrained_quality_training_session() {
	local entry="${1}"

	local fps=$(echo "${entry}" | cut -f 1 -d ";")
	local width=$(echo "${entry}" | cut -f 2 -d ";")
	local height=$(echo "${entry}" | cut -f 3 -d ";")
	local duration=$(echo "${entry}" | cut -f 4 -d ";")
	local max_bpp=${LIBAOM_PGO_BPP_MAX:-1.0}
	local min_bpp=${LIBAOM_PGO_BPP_MIN:-0.5}
	local avg_bpp=$(python -c "print((${max_bpp}+${min_bpp})/2)")
	local maxrate=$(python -c "print(${width}*${height}*${fps}*${max_bpp})")"k" # moving
	local minrate=$(python -c "print(${width}*${height}*${fps}*${min_bpp})")"k" # stationary
	local avgrate=$(python -c "print(${width}*${height}*${fps}*${avg_bpp}")"k" # average BPP (bits per pixel)

	local cmd
	einfo "Encoding as ${height}p for ${duration} sec, ${fps} fps"
	cmd=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v libaom-av1 \
		-maxrate ${maxrate} -minrate ${minrate} -b:v ${avgrate} \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_PGO_TRAINING_ARGS} \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/test.webm"
	)
	"${cmd[@]}" || die
	_vdecode "${height}p, ${fps} fps"
}

_trainer_plan_constrained_quality() {
	local L=(
		"30;426;240;3"
		"60;426;240;3"
		"30;640;360;3"
		"60;640;360;3"
		"30;854;480;3"
		"60;854;480;3"
		"30;1280;720;3"
		"60;1280;720;3"
		"30;1920;1080;3"
		"60;1920;1080;3"
		"30;2560;1440;3"
		"60;2560;1440;3"
		"30;3840;2160;3"
		"60;3840;2160;3"
	)

	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running PGO trainer for 1 pass constrained quality"
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
	local duration=$(echo "${entry}" | cut -f 4 -d ";")
	local max_bpp=${LIBAOM_PGO_BPP_MAX:-1.0}
	local min_bpp=${LIBAOM_PGO_BPP_MIN:-0.5}
	local avg_bpp=$(python -c "print((${max_bpp}+${min_bpp})/2)")
	local maxrate=$(python -c "print(${width}*${height}*${fps}*${max_bpp})")"k" # moving
	local minrate=$(python -c "print(${width}*${height}*${fps}*${min_bpp})")"k" # stationary
	local avgrate=$(python -c "print(${width}*${height}*${fps}*${avg_bpp}")"k" # average BPP (bits per pixel)

	local cmd
	einfo "Encoding as ${height}p for ${duration} sec, ${fps} fps"
	cmd1=(
		"${FFMPEG}" \
		-y \
		-i "${video_asset_path}" \
		-c:v libaom-av1 \
		-maxrate ${maxrate} -minrate ${minrate} -b:v ${avgrate} \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_PGO_TRAINING_ARGS} \
		-pass 1 \
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
		-maxrate ${maxrate} -minrate ${minrate} -b:v ${avgrate} \
		-vf scale=w=-1:h=${height} \
		${LIBAOM_PGO_TRAINING_ARGS} \
		-pass 2 \
		-an \
		-r ${fps} \
		-t ${duration} \
		"${T}/test.webm"
	)
	"${cmd1[@]}" || die
	"${cmd2[@]}" || die
	_vdecode "${height}p, ${fps} fps"
}

_trainer_plan_2_pass_constrained_quality() {
	local L=(
		"30;426;240;3"
		"60;426;240;3"
		"30;640;360;3"
		"60;640;360;3"
		"30;854;480;3"
		"60;854;480;3"
		"30;1280;720;3"
		"60;1280;720;3"
		"30;1920;1080;3"
		"60;1920;1080;3"
		"30;2560;1440;3"
		"60;2560;1440;3"
		"30;3840;2160;3"
		"60;3840;2160;3"
	)

	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running PGO trainer for 2 pass constrained quality"
			local e
			for e in ${L[@]} ; do
				_trainer_plan_2_pass_constrained_quality_training_session "${e}"
			done
		done
	fi
}

_trainer_plan_lossless() {
	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local video_asset_path="${!id}"
			[[ -e "${video_asset_path}" ]] || continue
			einfo "Running PGO trainer for lossless"
			local cmd
			einfo "Encoding for lossless"
			cmd=(
				"${FFMPEG}" \
				-y \
				-i "${video_asset_path}" \
				-c:v libaom-av1 \
				-crf 0 \
				${LIBAOM_PGO_TRAINING_ARGS_LOSSLESS} \
				-an \
				-t 3 \
				"${T}/test.webm"
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
	if use pgo-trainer-constrained-quality ; then
		_trainer_plan_constrained_quality
	fi
	if use pgo-trainer-2-pass-constrained-quality ; then
		_trainer_plan_2_pass_constrained_quality
	fi
	if use pgo-trainer-lossless ; then
		_trainer_plan_lossless
	fi
	if use pgo-custom ; then
		_trainer_plan_custom
	fi
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
	compile_abi() {
		for lib_type in $(get_lib_types) ; do
			uopts_src_compile
		done
	}
	multilib_foreach_abi compile_abi
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
elog "No PGO optimization performed.  Please re-emerge this package."
elog "The following package must be installed before PGOing this package:"
elog "  media-video/ffmpeg[encode,libaom,$(get_arch_enabled_use_flags)]"
	fi
	uopts_pkg_postinst
}
