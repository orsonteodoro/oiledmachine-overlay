# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib flag-o-matic python-any-r1 toolchain-funcs

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	SRC_URI="https://storage.googleapis.com/aom-releases/${P}.tar.gz"
	S="${WORKDIR}/${P}"
	S_orig="${WORKDIR}/${P}"
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
IUSE+=" cfi cfi-cast cfi-cross-dso cfi-icall cfi-vcall clang hardened libcxx lto shadowcallstack static-libs"
IUSE+=" +asm"
IUSE+=" pgo pgo-custom
	pgo-trainer-2-pass-constrained-quality
	pgo-trainer-constrained-quality
	pgo-trainer-lossless
	chromium
"
# Link libraries with CFI Cross-DSO (.so) or Basic mode (.a)
REQUIRED_USE="
	!cfi-cross-dso? (
		cfi? ( static-libs )
		cfi-cast? ( static-libs )
		cfi-icall? ( static-libs )
		cfi-vcall? ( static-libs )
	)
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
	cfi? ( clang lto )
	cfi-cast? ( clang lto cfi-vcall )
	cfi-cross-dso? ( || ( cfi cfi-vcall ) )
	cfi-icall? ( clang lto cfi-vcall )
	cfi-vcall? ( clang lto )
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
	shadowcallstack? ( clang )
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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi?]
			cfi-cross-dso? ( sys-devel/clang:${v}[${MULTILIB_USEDEP},experimental] )
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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[shadowcallstack?]
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
				>=sys-libs/libcxx-${v}:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,static-libs?,${MULTILIB_USEDEP}]
			)
		)
		"
	done
}

RDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
DEPEND+=" ${RDEPEND}"

BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" abi_x86_32? ( dev-lang/yasm )
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

pkg_setup() {
	if use chromium ; then
		einfo "The chromium USE flag is in testing."
	fi

	if use pgo && has_version "media-video/ffmpeg" ; then
		if ! has_version "media-video/ffmpeg[libaom]" ; then
			ewarn "You need to emerge ffmpeg with libaom for pgo training."
			ewarn "The regular emerge path with be taken instead."
			ewarn "After you install ffmpeg, re-emerge this package again."
		fi
		if ! ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
			ewarn "Missing WebM support from ffmpeg for PGO training"
		fi
		if [[ -z "${LIBAOM_PGO_VIDEO}" ]] ; then
eerror
eerror "LIBAOM_PGO_VIDEO is missing the abspath to your av1 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
			die
		else
			einfo "LIBAOM_PGO_VIDEO=${LIBAOM_PGO_VIDEO}"
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
eerror "the proper codec is supported for that file in ffmpeg."
eerror
		fi
	fi
}

src_unpack() {
	mkdir -p "${WORKDIR}/${P}" || die
	cd "${WORKDIR}/${P}" || die
	unpack "${A}"
}

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	cmake_src_prepare
	if use clang && use lto ; then
		sed -i -e "s|-fuse-ld=gold|-fuse-ld=lld|g" \
			build/cmake/sanitizers.cmake || die
	fi
	if use cfi ; then
		sed -i -e "s|-fno-sanitize-trap=cfi||g" \
			build/cmake/sanitizers.cmake || die
		if use static-libs ; then
			eapply "${FILESDIR}/libaom-3.1.2-static-link-apps.patch"
		fi
	fi
	prepare_abi() {
		for build_type in $(get_build_types) ; do
			einfo "Build type is ${build_type}"
			export S="${S_orig}.${ABI}_${build_type/-*}"
			einfo "Copying to ${S}"
			cp -a "${S_orig}" "${S}" || die
		done
	}
	multilib_foreach_abi prepare_abi
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
	if ffprobe "${LIBAOM_PGO_VIDEO}" 2>/dev/null 1>/dev/null ; then
		meets_input_req=1
	fi
	if ( ffmpeg -formats 2>&1 | grep -q -e "E.*webm .*WebM" ) ; then
		meets_output_req=1
	fi
	(( ${meets_input_req} && ${meets_output_req} )) && return 0
	return 1
}

has_pgo_requirement() {
	if has_ffmpeg && has_codec_requirements ; then
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
	filter-flags '-flto*' '-fuse-ld=*'
	if tc-is-clang ; then
		append-flags -flto=thin
		append-ldflags -fuse-ld=lld -flto=thin
		[[ "${build_type}" == "static-libs" ]] \
			&& append_all -fsplit-lto-unit
	else
		append-flags -flto
		append-ldflags -flto
	fi
}

is_hardened_clang() {
	if tc-is-clang && clang --version 2>/dev/null | grep -q -e "Hardened:" ; then
		return 0
	fi
	return 1
}

is_hardened_gcc() {
	if tc-is-gcc && gcc --version 2>/dev/null | grep -q -e "Hardened" ; then
		return 0
	fi
	return 1
}

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${build_type}" == "static-libs" ]] ; then
		return 0
	elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
		return 0
	fi
	return 1
}

configure_pgx() {
	[[ -f build.ninja ]] && eninja clean
	find "${BUILD_DIR}" -name "CMakeCache.txt" -delete 2>/dev/null

	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		unset LD
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'--param=ssp-buffer-size=*' \
		'-f*sanitize*' \
		'-f*stack*' \
		'-f*visibility*' \
		'-fprofile*' \
		'-fsplit-lto-unit' \
		'-lc++' \
		'-ldl' \
		'-lubsan' \
		'-static-libc++' \
		'-stdlib=libc++' \
		'-Wl,-lubsan' \
		'-Wl,-z,noexecstack' \
		'-Wl,-z,now' \
		'-Wl,-z,relro'

	if tc-is-clang && use libcxx && [[ "${USE}" =~ "cfi" ]] ; then
		# The -static-libstdc++ is a misnomer.  It also means \
		# -static-libc++ which does not exist.
                append-cxxflags -stdlib=libc++
                append-ldflags -stdlib=libc++
		[[ "${build_type}" == "shared-libs" ]] \
			&& append-ldflags -lc++
		[[ "${build_type}" == "static-libs" ]] \
			&& append-ldflags -static-libstdc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	autofix_flags

	tc-export CC CXX
	export FFMPEG=$(get_multiabi_ffmpeg)
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags -fprofile-generate="${T}/pgo-${ABI}"
		else
			append-flags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${T}/pgo-${ABI}/pgo-custom.profdata" \
				"${T}/pgo-${ABI}" || die
			append-flags -fprofile-use="${T}/pgo-${ABI}/pgo-custom.profdata"
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
		fi
	fi
	local mycmakeargs=(
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_TESTS=OFF
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

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		if tc-is-clang && is_cfi_supported ; then
			mycmakeargs+=( -DSANITIZE=cfi )
			mycmakeargs+=( -DCFI=$(usex cfi) )
			mycmakeargs+=( -DCFI_CAST=$(usex cfi-cast) )
			#mycmakeargs+=( -DCFI_ICALL=$(usex cfi-icall) )
			mycmakeargs+=( -DCFI_VCALL=$(usex cfi-vcall) )
			if [[ "${build_type}" == "shared-libs" ]] ; then
				mycmakeargs+=( -DCROSS_DSO_CFI=$(usex cfi-cross-dso) )
			fi
			mycmakeargs+=( -DCFI_EXCEPTIONS="-fno-sanitize=cfi-icall" ) # Prevent Illegal instruction with /usr/bin/aomdec --help
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	if use chromium && [[ "${build_type}" == "static-libs" ]] ; then
		mycmakeargs+=(
			-DAOM_AS_FLAGS="-DCHROMIUM"
			-DENABLE_NASM=ON
		)
	else
		mycmakeargs+=( -DENABLE_NASM=OFF )
	fi
	use hardened && append-ldflags -Wl,-z,noexecstack
	use lto && append_lto
	if is_hardened_gcc ; then
		:;
	elif is_hardened_clang ; then
		set_cfi
	else
		set_cfi
		if use hardened ; then
			if [[ -n "${USE_HARDENED_PROFILE_DEFAULTS}" \
				&& "${USE_HARDENED_PROFILE_DEFAULTS}" == "1" ]] ; then
				append-cppflags -D_FORTIFY_SOURCE=2
				append-flags $(test-flags-CC -fstack-clash-protection)
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
			else
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector
			fi
			append-ldflags -Wl,-z,relro -Wl,-z,now
			mycmakeargs+=(
				-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS} -pie"
			)
		fi
	fi

	if [[ "${build_type}" == "static-libs" ]] ; then
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=OFF
		)
	else
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=ON
		)
	fi

	if [[ ! ( "${USE}" =~ "cfi" ) ]] ; then
		mycmakeargs+=(
			-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		)
	else
		if use static-libs ; then
			# Build only once
			# If static-libs, then use CFI basic mode, else use CFI Cross-DSO mode.
			if [[ "${build_type}" == "static-libs" ]] ; then
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

src_compile() {
	compile_abi() {
		for build_type in $(get_build_types) ; do
			einfo "Build type is ${build_type}"
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}_build"
			if use pgo \
				&& has_pgo_requirement ; then
				if [[ "${build_type}" == "shared-libs" ]] ; then
					PGO_PHASE="pgi"
					configure_pgx
					compile_pgx
					run_trainer
				fi
				if (( $(find "${T}/pgo-${ABI}" 2>/dev/null | wc -l) > 0 )) ; then
					PGO_PHASE="pgo"
					[[ "${build_type}" == "static-libs" ]] \
						&& ewarn "Reusing PGO data from shared-libs"
				else
					ewarn "No PGO data found.  Skipping PGO build and building normally."
					unset PGO_PHASE
				fi
				configure_pgx
				compile_pgx
				export PGO_RAN=1
			else
				ewarn "Not using PGO for ${ABI}"
				configure_pgx
				compile_pgx
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}_build"
			cd "${BUILD_DIR}" || die
			if multilib_is_native_abi && use doc ; then
				local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
			fi
			cmake_src_install
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

	if use cfi-cross-dso ; then
ewarn "Using cfi-cross-dso requires a rebuild of the app with only the clang"
ewarn "compiler."
	fi

	if [[ "${USE}" =~ "cfi" ]] && use static-libs ; then
ewarn "Using cfi with static-libs requires the app be built with only the clang"
ewarn "compiler."
	fi

	if use lto && use static-libs ; then
		if tc-is-clang ; then
ewarn "You are only allowed to static link this library with clang."
		elif tc-is-gcc ; then
ewarn "You are only allowed to static link this library with gcc."
		else
ewarn "You are only allowed to static link this library with CC=${CC}"
ewarn "CXX=${CXX}."
		fi
	fi
}
