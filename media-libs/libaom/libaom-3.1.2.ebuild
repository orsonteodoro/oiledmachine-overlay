# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic toolchain-funcs

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	SRC_URI="https://storage.googleapis.com/aom-releases/${P}.tar.gz"
	S="${WORKDIR}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org"

LICENSE="BSD-2"
SLOT="0/3"
IUSE="doc examples"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3"
IUSE="${IUSE} cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_neon"
IUSE+=" cfi full-relro libcxx lto noexecstack shadowcallstack ssp"
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

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_cfi_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi?]
		)
		     "
	done
}

gen_shadowcallstack_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
		)
		     "
	done
}

gen_lto_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP}]
			>=sys-devel/lld-${v}
		)
		"
	done
}

gen_libcxx_depend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			libcxx? (
				!cfi? ( >=sys-libs/libcxx-${v}[full-relro?,shadowcallstack?,ssp?,${MULTILIB_USEDEP}] )
				cfi? ( >=sys-libs/libcxx-${v}[cfi,cfi-icall,cfi-full,full-relro?,shadowcallstack?,ssp?,${MULTILIB_USEDEP}] )
			)
		)
		"
	done
}

RDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
DEPEND+=" ${RDEPEND}"

BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"
BDEPEND+=" lto? ( || ( $(gen_lto_bdepend 11 14) ) )"
BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"

BDEPEND+=" abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	chromium? ( >=dev-lang/nasm-2.14 )
	doc? ( app-doc/doxygen )
"

PDEPEND="
	pgo? (
		media-video/mpv[cli]
		media-video/ffmpeg[encode,libaom,${MULTILIB_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/libaom-2.0.0-visibility-default.patch" )

# the PATENTS file is required to be distributed with this package bug #682214
DOCS=( PATENTS )

pkg_setup() {
	if use pgo ; then
		if ! has_version "media-video/ffmpeg[libaom]" ; then
			ewarn "You need to emerge ffmpeg with libaom for pgo training."
			ewarn "The regular emerge path with be taken instead."
			ewarn "After you install ffmpeg, re-emerge this package again."
		fi
		if ! has_version "media-video/mpv" ; then
			ewarn "You need mpv to perform PGO decode training."
			ewarn "After you install mpv, re-emerge this package again."
		fi
		if ! ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
			die "Missing WebM support from ffmpeg"
		fi
		if [[ -z "${LIBAOM_PGO_VIDEO}" ]] ; then
eerror
eerror "LIBAOM_PGO_VIDEO is missing the abspath to your av1 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
			die
		fi
		if ffprobe "${LIBAOM_PGO_VIDEO}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			if ! ( ffprobe "${LIBAOM_PGO_VIDEO}" 2>&1 \
				| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
				die
			fi
			if ! ( ffprobe "${LIBAOM_PGO_VIDEO}" 2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
				die
			fi

			local d=$(ffprobe "${LIBAOM_PGO_VIDEO}" 2>&1 \
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
eerror "The PGO video sample must be >= 3 seconds."
eerror
				die
			fi
		else
eerror
eerror "${LIBAOM_PGO_VIDEO} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file"
eerror
			die
		fi
	fi
}

src_prepare() {
	cmake_src_prepare
	if use cfi ; then
		sed -i -e "s|-fuse-ld=gold|-fuse-ld=lld|g" \
			build/cmake/sanitizers.cmake || die
	fi
	multilib_copy_sources
}

get_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_native_abi_use() {
	for p in $(multilib_get_enabled_abi_pairs) ; do
		[[ "${p}" =~ "${DEFAULT_ABI}"$ ]] && echo "${p}" | cut -f 1 -d "."
	done
}

get_multiabi_ffmpeg() {
	if multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_native_abi_use)]" ; then
		echo "/usr/bin/ffmpeg"
	elif ! multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_abi_use ${ABI})]" ; then
		echo "/usr/bin/ffmpeg-${ABI}"
	else
		echo ""
	fi
}

get_multiabi_mpv() {
	if multilib_is_native_abi && has_version "media-video/mpv" ; then
		echo "/usr/bin/mpv"
	elif ! multilib_is_native_abi && has_version "media-video/mpv" ; then
		echo "/usr/bin/mpv-${ABI}"
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

has_mpv() {
	local x=$(get_multiabi_mpv)
	if [[ -n "${x}" && -e "${x}" ]] ; then
		return 0
	else
		return 1
	fi
}

has_pgo_requirement() {
	if has_ffmpeg && has_mpv ; then
		return 0
	else
		return 1
	fi
}

src_configure() { :; }

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

append_lto() {
	filter-flags '-flto*'
	append-flags -flto=thin
	append-ldflags -fuse-ld=lld -flto=thin
}

configure_pgx() {
	[[ -f build.ninja ]] && eninja clean
	find "${BUILD_DIR}" -name "CMakeCache.txt" -delete
	filter-flags \
		'-fprofile-correction' \
		'-fprofile-dir*' \
		'-fprofile-generate*' \
		'-fprofile-use*'

	if use lto || use shadowcallstack ; then
		export CC="clang $(get_abi_CFLAGS ${ABI})"
		export CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		export NM=llvm-nm
		export AR=llvm-ar
		export READELF=llvm-readelf
		export AS=llvm-as
		unset LD
	fi

	if tc-is-clang && use libcxx ; then
                append-cxxflags -stdlib=libc++
                append-ldflags -stdlib=libc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	if tc-is-clang ; then
		filter-flags -fprefetch-loop-arrays \
			'-fopt-info*' \
			-frename-registers
		append-cppflags -DFLAC__USE_VISIBILITY_ATTR
	fi

	use chromium && append-cppflags -DCHROMIUM
	use full-relro && append-ldflags -Wl,-z,relro -Wl,-z,now
	use lto && append_lto
	use noexecstack && append-ldflags -Wl,-z,noexecstack
	use shadowcallstack && append-flags -fno-sanitize=safe-stack \
					-fsanitize=shadow-call-stack
	use ssp && append-ldflags --param=ssp-buffer-size=4 \
				-fstack-protector

	tc-export CC CXX
	export FFMPEG=$(get_multiabi_ffmpeg)
	export MPV=$(get_multiabi_mpv)
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-cflags -fprofile-generate="${T}/pgo-${ABI}"
			append-cxxflags -fprofile-generate="${T}/pgo-${ABI}"
		else
			append-cflags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
			append-cxxflags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${T}/pgo-${ABI}/code.profdata" \
				"${T}/pgo-${ABI}" || die
			append-cflags -fprofile-use="${T}/pgo-${ABI}/code.profdata"
			append-cxxflags -fprofile-use="${T}/pgo-${ABI}/code.profdata"
		else
			append-cflags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
			append-cxxflags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
		fi
	fi
	local mycmakeargs=(
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		-DENABLE_NASM=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF

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
	if use cfi ; then
		mycmakeargs+=(
			-DSANITIZE=cfi
		)
	fi
	cmake_src_configure
}

_vdecode() {
	einfo "Decoding ${1}"
	cmd=( "${MPV}" \
		--msg-level=all=debug \
		--hwdec=no \
		--vd=libaom-av1 \
		--vo=null \
		"${T}/test.webm" )
	LD_LIBRARY_PATH="${BUILD_DIR}" \
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

_trainer_plan_constrained_quality() {
	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for 1 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "720p, 30 fps"

		einfo "Encoding as 720p for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "720p, 60 fps"

		einfo "Encoding as 1080p for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "1080p, 30 fps"

		einfo "Encoding as 1080p for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "1080p, 60 fps"

		einfo "Encoding as 4k for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "4k, 30 fps"

		einfo "Encoding as 4k for 3 sec, 60 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "4k, 60 fps"
	fi
}

_trainer_plan_2_pass_constrained_quality() {
	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for 2 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "720p, 30 fps"

		einfo "Encoding as 720p for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "720p, 60 fps"

		einfo "Encoding as 1080p for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "1080p, 30 fps"

		einfo "Encoding as 1080p for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "1080p, 60 fps"

		einfo "Encoding as 4k for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 30 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "4k, 30 fps"

		einfo "Encoding as 4k for 3 sec, 60 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${LIBAOM_PGO_TRAINING_ARGS} \
			-pass 2 \
			-an \
			-r 60 \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd1[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd1[@]}" || die
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd2[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd2[@]}" || die
		_vdecode "4k, 60 fps"
	fi
}

_trainer_plan_lossless() {
	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for lossless"
		local cmd
		einfo "Encoding for lossless"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBAOM_PGO_VIDEO}" \
			-c:v libaom-av1 \
			-crf 0 \
			${LIBAOM_PGO_TRAINING_ARGS_LOSSLESS} \
			-an \
			-t 3 \
			"${T}/test.webm" )
		einfo "LD_LIBRARY_PATH=\"${BUILD_DIR}\" ${cmd[@]}"
		LD_LIBRARY_PATH="${BUILD_DIR}" \
		"${cmd[@]}" || die
		_vdecode "lossless"
	fi
}

run_trainer() {
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

compile_pgx() {
	cmake_src_compile
}

multilib_src_compile() {
	if use pgo \
		&& has_pgo_requirement ; then
		PGO_PHASE="pgi"
		configure_pgx
		compile_pgx
		run_trainer
		PGO_PHASE="pgo"
		configure_pgx
		compile_pgx
		export PGO_RAN=1
	else
		ewarn "Not using PGO for ${ABI}"
		configure_pgx
		compile_pgx
	fi
}

multilib_src_install() {
	if multilib_is_native_abi && use doc ; then
		local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	fi
	cmake_src_install
}

multilib_src_install_all() {
	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
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
		elog "  media-video/mpv[cli]"
		elog "  media-video/ffmpeg[encode,libaom,$(get_arch_enabled_use_flags)]"
	fi
}
