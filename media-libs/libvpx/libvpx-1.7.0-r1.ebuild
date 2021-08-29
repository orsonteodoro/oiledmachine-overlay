# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit flag-o-matic llvm toolchain-funcs multilib-minimal

# To create a new testdata tarball:
# 1. Unpack source tarbll or checkout git tag
# 2. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 3. configure --enable-unit-tests --enable-vp9-highbitdepth
# 4. make testdata
# 5. tar -cjf libvpx-testdata-${MY_PV}.tar.bz2 libvpx-testdata

LIBVPX_TESTDATA_VER=1.7.0

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="https://www.webmproject.org"
SRC_URI="https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( mirror://gentoo/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz )"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 doc cpu_flags_x86_mmx postproc cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 +highbitdepth static-libs svc test +threads"
IUSE+=" clang lto pgo
	pgo-custom
	pgo-trainer-2-pass-constrained-quality
	pgo-trainer-constrained-quality
	pgo-trainer-lossless
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
	test? ( threads )
"

# Disable test phase when USE="-test"
RESTRICT="!test? ( test )"

LTO_CLANG_BDEPEND="
        (
                sys-devel/clang:11
                sys-devel/llvm:11
                >=sys-devel/lld-11
        )
        (
                sys-devel/clang:12
                sys-devel/llvm:12
                >=sys-devel/lld-12
        )
        (
                sys-devel/clang:13
                sys-devel/llvm:13
                >=sys-devel/lld-13
        )"

BDEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
	lto? (
		|| (
			${LTO_CLANG_BDEPEND}
			sys-devel/gcc
		)
	)
"

PDEPEND="
	pgo? (
		media-video/mpv[cli]
		media-video/ffmpeg[encode,vpx,${MULTILIB_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/libvpx-1.3.0-sparc-configure.patch # 501010
	"${FILESDIR}"/${P}-CVE-2019-9232_9325_9371_9433.patch
)

pkg_setup() {
	if use pgo ; then
		if ! has_version "media-video/ffmpeg[vpx]" ; then
			ewarn "You need to emerge ffmpeg with vpx for pgo training."
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
		if [[ -z "${LIBVPX_PGO_VIDEO}" ]] ; then
eerror
eerror "LIBVPX_PGO_VIDEO is missing the abspath to your vp8/vp9 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
			die
		fi
		if ffprobe "${LIBVPX_PGO_VIDEO}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			if ! ( ffprobe "${LIBVPX_PGO_VIDEO}" 2>&1 \
				| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
				die
			fi
			if ! ( ffprobe "${LIBVPX_PGO_VIDEO}" 2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
				die
			fi

			local d=$(ffprobe "${LIBVPX_PGO_VIDEO}" 2>&1 \
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
eerror "${LIBVPX_PGO_VIDEO} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file"
eerror
			die
		fi
	fi
	llvm_pkg_setup
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

src_prepare() {
	default
	if tc-is-clang ; then
		eapply "${FILESDIR}/libvpx-1.10.0-add-cxxflags-to-linking-libvpx.patch"
		eapply "${FILESDIR}/libvpx-1.10.0-add-cxxflags-to-linking-examples.patch"
	else
		eapply "${FILESDIR}/libvpx-1.10.0-gcov.patch"
	fi
}

src_configure() {
	# https://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/ #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn
	addpredict /session_mm_cli0.sem #nowarn
	multilib-minimal_src_configure
}

configure_pgx() {
	[[ -f Makefile ]] && emake clean
	unset CODECS #357487

	filter-flags \
		'-fprofile-correction' \
		'-fprofile-dir*' \
		'-fprofile-generate*' \
		'-fprofile-use*'
	if tc-is-clang ; then
		filter-flags \
			-fprefetch-loop-arrays \
			'-fopt-info*' \
			-frename-registers
		append-ldflags -pthread
		export AR=llvm-ar
		export AS=llvm-as
		export STRIP=llvm-strip
		export NM=llvm-nm
	else
		export AR=ar
		export AS=as
		export STRIP=strip
		export NM=nm
	fi
	filter-flags '-flto*'
	filter-ldflags '-O*'
	if use lto && tc-is-clang ; then
		append-cflags -flto=thin
		append-cxxflags -flto=thin
		append-ldflags -fuse-ld=lld -flto=thin -O2
	elif use lto && tc-is-gcc ; then
		ncpus=$(lscpu | grep -E "^CPU\(s\):.*[0-9]+" \
			| grep -E -o "[0-9]+")
		append-cflags -flto=${ncpus}
		append-cxxflags -flto=${ncpus}
		append-ldflags -flto=${ncpus} -O2
	fi
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

	# #498364: sse doesn't work without sse2 enabled,
	local myconfargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-pic
		--enable-vp8
		--enable-vp9
		--enable-shared
		--extra-cflags="${CFLAGS}"
		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable cpu_flags_x86_avx2 avx2)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable postproc)
		$(use cpu_flags_x86_sse2 && use_enable cpu_flags_x86_sse sse || echo --disable-sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse3 sse3)
		$(use_enable cpu_flags_x86_sse4_1 sse4_1)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
		$(use_enable svc experimental) $(use_enable svc spatial-svc)
		$(use_enable static-libs static)
		$(use_enable test unit-tests)
		$(use_enable threads multithread)
		$(use_enable highbitdepth vp9-highbitdepth)
	)

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# powerpc toolchain is not recognized anymore, #694368
	[[ ${CHOST} == powerpc-* ]] && myconfargs+=( --force-target=generic-gnu )

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

	if use pgo && has_pgo_requirement && tc-is-gcc && [[ "${PGO_PHASE}" == "pgi" ]] ; then
		myconfargs+=( --enable-gcov )
	fi

	"${S}"/configure "${myconfargs[@]}"
}

_vdecode() {
	einfo "Decoding ${1}"
	cmd=( "${MPV}" \
		--msg-level=all=debug \
		--hwdec=no \
		--vd=${decoding_codec} \
		--vo=null \
		"${T}/test.webm" )
	LD_LIBRARY_PATH="${BUILD_DIR}" \
	"${cmd[@]}" || die
}

_trainer_plan_custom() {
	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_VP8_PGO_TRAINING_ARGS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_VP9_PGO_TRAINING_ARGS}
	else
		die "Unrecognized implementation of vpx"
	fi

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
	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_VP8_PGO_TRAINING_ARGS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_VP9_PGO_TRAINING_ARGS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for 1 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
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
	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_VP8_PGO_TRAINING_ARGS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_VP9_PGO_TRAINING_ARGS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for 2 pass constrained quality"
		local cmd
		einfo "Encoding as 720p for 3 sec, 30 fps"
		cmd1=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 1485k -minrate 512k -b:v 1024k \
			-vf scale=w=-1:h=720 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=720 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 2610k -minrate 900k -b:v 1800k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 4350k -minrate 1500k -b:v 3000k \
			-vf scale=w=-1:h=1080 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 1 \
			-an \
			-r 30 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 17400k -minrate 6000k -b:v 12000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
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
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
			-pass 1 \
			-an \
			-r 60 \
			-t 3 \
			-f null /dev/null )
		cmd2=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-maxrate 26100k -minrate 9000k -b:v 18000k \
			-vf scale=w=-1:h=2160 \
			${training_args} \
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
	local encoding_codec="${1}"
	local decoding_codec
	local training_args
	if [[ "${encoding_codec}" == "libvpx" ]] ; then
		decoding_codec="libvpx"
		training_args=${LIBVPX_VP8_PGO_TRAINING_ARGS_LOSSLESS}
	elif [[ "${encoding_codec}" == "libvpx-vp9" ]] ; then
		decoding_codec="libvpx-vp9"
		training_args=${LIBVPX_VP9_PGO_TRAINING_ARGS_LOSSLESS}
	else
		die "Unrecognized implementation of vpx"
	fi

	if use pgo \
		&& has_pgo_requirement ; then
		einfo "Running PGO trainer for ${encoding_codec} for lossless"
		einfo "Encoding for lossless"
		local cmd
		cmd=( "${FFMPEG}" \
			-y \
			-i "${LIBVPX_PGO_VIDEO}" \
			-c:v ${encoding_codec} \
			-lossless 1 \
			${training_args} \
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
		_trainer_plan_constrained_quality "libvpx"
		_trainer_plan_constrained_quality "libvpx-vp9"
	fi
	if use pgo-trainer-2-pass-constrained-quality ; then
		_trainer_plan_2_pass_constrained_quality "libvpx"
		_trainer_plan_2_pass_constrained_quality "libvpx-vp9"
	fi
	if use pgo-trainer-lossless ; then
		_trainer_plan_lossless "libvpx"
		_trainer_plan_lossless "libvpx-vp9"
	fi
	if use pgo-custom ; then
		_trainer_plan_custom "libvpx"
		_trainer_plan_custom "libvpx-vp9"
	fi
}

compile_pgx() {
	# build verbose by default and do not build examples that will not be installed
	emake verbose=yes GEN_EXAMPLES=
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

multilib_src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}"
	local -x LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata"
	emake verbose=yes GEN_EXAMPLES= test
}

multilib_src_install() {
	emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
	multilib_is_native_abi && use doc && dodoc -r docs/html
}

pkg_postinst() {
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
		elog "No PGO optimization performed.  Please re-emerge this package."
		elog "The following package must be installed before PGOing this package:"
		elog "  media-video/mpv[cli]"
		elog "  media-video/ffmpeg[encode,libaom,$(get_arch_enabled_use_flags)]"
	fi
}
