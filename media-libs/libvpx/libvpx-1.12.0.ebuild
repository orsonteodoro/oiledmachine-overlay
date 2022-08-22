# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic llvm multilib-minimal toolchain-funcs tpgo

# To create a new testdata tarball:
# 1. Unpack source tarball or checkout git tag
# 2. mkdir libvpx-testdata
# 3. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 4. configure --enable-unit-tests --enable-vp9-highbitdepth
# 5. make testdata
# 6. tar -caf libvpx-testdata-${MY_PV}.tar.xz libvpx-testdata

LIBVPX_TESTDATA_VER=1.12.0

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="https://www.webmproject.org"
SRC_URI="
	https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://dev.gentoo.org/~whissi/dist/libvpx/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz )
"

LICENSE="BSD"
SLOT="0/7"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_ppc_vsx3 doc +highbitdepth postproc static-libs test +threads"
IUSE+=" svc +examples"
IUSE+=" cfi cfi-cast cfi-cross-dso cfi-icall cfi-vcall clang chromium hardened libcxx lto pie shadowcallstack"
IUSE+=" pgo
	pgo-custom
	pgo-trainer-2-pass-constrained-quality
	pgo-trainer-constrained-quality
	pgo-trainer-lossless
"
# Link utils to either CFI Cross-DSO (.so) or Basic (.a)
REQUIRED_USE="
	!cfi-cross-dso? (
		cfi? ( static-libs )
		cfi-cast? ( static-libs )
		cfi-icall? ( static-libs )
		cfi-vcall? ( static-libs )
	)
	cfi? ( clang lto )
	cfi-cast? ( clang lto cfi-vcall )
	cfi-icall? ( clang lto cfi-vcall )
	cfi-vcall? ( clang lto )
	cfi-cross-dso? ( || ( cfi cfi-vcall ) )
	pie? ( hardened )
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
	shadowcallstack? ( clang )
"

# Disable test phase when USE="-test"
# checksec says that no CFI with strip, but present after compile.
RESTRICT="!test? ( test ) strip"

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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi]
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
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND="
	dev-lang/perl
	abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
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
		media-video/ffmpeg[encode,vpx,${MULTILIB_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/libvpx-1.3.0-sparc-configure.patch" # 501010
	"${FILESDIR}/libvpx-1.10.0-exeldflags.patch"
)
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"

get_asset_ids() {
	local i
	for i in $(seq 0 ${LIBVPX_ASSET_LIMIT}) ; do
		echo "LIBVPX_PGO_VIDEO_${i}"
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
		if [[ -z "${libvpx_asset_path}" ]] ; then
eerror
eerror "${id} is missing the abspath to your vp8/vp9 video as a"
eerror "per-package envvar.  The video must be 3840x2160 resolution,"
eerror "60fps, >= 3 seconds."
eerror
			die
		fi
		if ffprobe "${libvpx_asset_path}" 2>/dev/null 1>/dev/null ; then
			einfo "Verifying asset requirements"
			if false && ! ( ffprobe "${libvpx_asset_path}" 2>&1 \
				| grep -q -e "3840x2160" ) ; then
eerror
eerror "The PGO video sample must be 3840x2160."
eerror
				die
			fi
			if false && ! ( ffprobe "${libvpx_asset_path}" 2>&1 \
				| grep -q -E -e ", (59|60)[.0-9]* fps" ) ; then
eerror
eerror "The PGO video sample must be >=59 fps."
eerror
				die
			fi

			local d=$(ffprobe "${libvpx_asset_path}" 2>&1 \
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
eerror "${libvpx_asset_path} is possibly not a valid video file.  Ensure that"
eerror "the proper codec is supported for that file"
eerror
		fi
	fi
}

__pgo_setup() {
	export LIBVPX_ASSET_LIMIT=${LIBVPX_ASSET_LIMIT:-100}
	__check_video_codec
	local id
	for id in $(get_asset_ids) ; do
		local libvpx_asset_path="${!id}"
		__check_video
	done
}

pkg_setup() {
	__pgo_setup
	llvm_pkg_setup
	tpgo_setup
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
		echo "${EPREFIX}/usr/bin/ffmpeg"
	elif ! multilib_is_native_abi && has_version "media-video/ffmpeg[$(get_abi_use ${ABI})]" ; then
		echo "${EPREFIX}/usr/bin/ffmpeg-${ABI}"
	else
		echo ""
	fi
}

has_ffmpeg() {
	local x=$(get_multiabi_ffmpeg)
	[[ -n "${x}" && -e "${x}" ]] && return 0
	return 1
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

tpgo_meets_requirements() {
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
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			einfo "Copying to ${S}"
			cp -a "${S_orig}" "${S}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	# https://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/ #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn
	addpredict /session_mm_cli0.sem #nowarn
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

append_lto() {
	filter-flags '-flto*' '-fuse-ld=*'
	if tc-is-clang ; then
		append-flags -flto=thin
		append-ldflags -fuse-ld=lld -flto=thin
		[[ "${lib_type}" == "static" ]] \
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
	if [[ "${lib_type}" == "static" ]] ; then
		return 0
	elif use cfi-cross-dso && [[ "${lib_type}" == "shared" ]] ; then
		return 0
	fi
	return 1
}

_src_configure() {
	[[ -f Makefile ]] && emake clean
	unset CODECS #357487

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
		'-lubsan' \
		'-static-libstdc++' \
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
		[[ "${lib_type}" == "shared" ]] \
			&& append-ldflags -lc++
		[[ "${lib_type}" == "static" ]] \
			&& append-ldflags -static-libstdc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	autofix_flags
	tpgo_src_configure

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

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		if tc-is-clang && is_cfi_supported ; then
			if [[ "${lib_type}" == "static" ]] ; then
				append_all -fvisibility=hidden
			elif use cfi-cross-dso && [[ "${lib_type}" == "shared" ]] ; then
				append_all -fvisibility=default
			fi
			if use cfi ; then
				append_all -fsanitize=cfi
				append_all -fno-sanitize=cfi-icall # Prevent illegal instruction with vpxenc --help
			else
				use cfi-cast && append_all \
							-fsanitize=cfi-derived-cast \
							-fsanitize=cfi-unrelated-cast
				#use cfi-icall && append_all \
				#			-fsanitize=cfi-icall
				use cfi-vcall && append_all \
							-fsanitize=cfi-vcall
			fi
			[[ "${USE}" =~ "cfi" ]] && append-ldflags -Wl,-lubsan
			use cfi-cross-dso \
				&& [[ "${lib_type}" == "shared" ]] \
				&& append_all -fsanitize-cfi-cross-dso
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	if use chromium && [[ "${lib_type}" == "static" ]] ; then
		export ASFLAGS="-DCHROMIUM"
		myconfargs+=( --as=nasm )
	else
		unset ASFLAGS
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
				#append-cppflags -D_FORTIFY_SOURCE=2 # override by package which disables default
				append-flags $(test-flags-CC -fstack-clash-protection)
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
			else
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector
			fi
			append-ldflags -Wl,-z,relro -Wl,-z,now

			if use pie ; then
				ewarn "-pie hasn't been tested"
				append-ldflags -pie
			fi
		fi
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

	if use pgo && tpgo_meets_requirements && tc-is-gcc && [[ "${PGO_PHASE}" == "pgi" ]] ; then
		myconfargs+=( --enable-gcov )
	fi

	unset EXELDFLAGS
	if is_hardened_clang || is_hardened_gcc ; then
		:;
	elif use hardened ; then
		export EXELDFLAGS="-pie"
	fi
	if [[ "${USE}" =~ "cfi" && "${lib_type}" == "static" ]] ; then
		myconfargs+=( --enable-cfi )
	fi

	echo "${S}"/configure "${myconfargs[@]}" >&2
	"${S}"/configure "${myconfargs[@]}"
}

_src_pre_train() {
	export FFMPEG=$(get_multiabi_ffmpeg)
}

_vdecode() {
	einfo "Decoding ${1}"
	cmd=( "${FFMPEG}" -i "${T}/test.webm" -f null - )
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

	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local libvpx_asset_path="${!id}"
			einfo "Running PGO trainer for ${encoding_codec} for 1 pass constrained quality"
			local cmd
			einfo "Encoding as 720p for 3 sec, 30 fps"
			cmd=( "${FFMPEG}" \
				-y \
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
		done
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

	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local libvpx_asset_path="${!id}"
			einfo "Running PGO trainer for ${encoding_codec} for 2 pass constrained quality"
			local cmd
			einfo "Encoding as 720p for 3 sec, 30 fps"
			cmd1=( "${FFMPEG}" \
				-y \
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
				-i "${libvpx_asset_path}" \
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
		done
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

	if use pgo && tpgo_meets_requirements ; then
		local id
		for id in $(get_asset_ids) ; do
			local libvpx_asset_path="${!id}"
			einfo "Running PGO trainer for ${encoding_codec} for lossless"
			einfo "Encoding for lossless"
			local cmd
			cmd=( "${FFMPEG}" \
				-y \
				-i "${libvpx_asset_path}" \
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
		done
	fi
}

tpgo_train_custom() {
	[[ "${lib_type}" == "static" ]] || return # Reuse the shared PGO profile
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

_src_compile() {
	# build verbose by default and do not build examples that will not be installed
	# disable stripping of debug info, bug #752057
	# (only works as long as upstream does not use non-gnu strip)
	emake verbose=yes GEN_EXAMPLES= HAVE_GNU_STRIP=no
}

_src_post_pgo() {
	export PGO_RAN=1
}

src_compile() {
	compile_abi() {
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			tpgo_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
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
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
			multilib_is_native_abi && use doc && dodoc -r docs/html
		done
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
elog "No PGO optimization performed.  Please re-emerge this package."
elog "The following package must be installed before PGOing this package:"
elog "  media-video/ffmpeg[encode,vpx,$(get_arch_enabled_use_flags)]"
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

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  hardened, cfi, lto, pgo
