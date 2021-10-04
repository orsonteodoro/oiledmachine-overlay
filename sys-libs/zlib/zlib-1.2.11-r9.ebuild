# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTO_DEPEND="no"
inherit autotools flag-o-matic multilib-minimal toolchain-funcs usr-ldscript

CYGWINPATCHES=(
	"https://github.com/cygwinports/zlib/raw/22a3462cae33a82ad966ea0a7d6cbe8fc1368fec/1.2.11-gzopen_w.patch -> ${PN}-1.2.11-cygwin-gzopen_w.patch"
	"https://github.com/cygwinports/zlib/raw/22a3462cae33a82ad966ea0a7d6cbe8fc1368fec/1.2.7-minizip-cygwin.patch -> ${PN}-1.2.7-cygwin-minizip.patch"
)

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="https://zlib.net/"
SRC_URI="https://zlib.net/${P}.tar.gz
	http://www.gzip.org/zlib/${P}.tar.gz
	http://www.zlib.net/current/beta/${P}.tar.gz
	elibc_Cygwin? ( ${CYGWINPATCHES[*]} )"

LICENSE="ZLIB
	pgo? ( GPL-2 )"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="minizip static-libs"
IUSE+=" cfi cfi-vcall cfi-cast cfi-icall clang hardened lto shadowcallstack"
IUSE+="
	pgo
	pgo-custom
	pgo-trainer-minizip-binary-long
	pgo-trainer-minizip-binary-max-compression
	pgo-trainer-minizip-binary-short
	pgo-trainer-minizip-binary-store
	pgo-trainer-minizip-text-long
	pgo-trainer-minizip-text-max-compression
	pgo-trainer-minizip-text-short
	pgo-trainer-minizip-text-store
	pgo-trainer-zlib-binary-all
	pgo-trainer-zlib-binary-default
	pgo-trainer-zlib-binary-max
	pgo-trainer-zlib-binary-min
	pgo-trainer-zlib-binary-random
	pgo-trainer-zlib-images-all
	pgo-trainer-zlib-images-default
	pgo-trainer-zlib-images-level-8
	pgo-trainer-zlib-images-max
	pgo-trainer-zlib-images-min
	pgo-trainer-zlib-images-random
	pgo-trainer-zlib-text-all
	pgo-trainer-zlib-text-default
	pgo-trainer-zlib-text-max
	pgo-trainer-zlib-text-min
	pgo-trainer-zlib-text-random
"
REQUIRED_USE="
	cfi? ( clang lto static-libs )
	cfi-cast? ( clang lto cfi-vcall static-libs )
	cfi-icall? ( clang lto cfi-vcall static-libs )
	cfi-vcall? ( clang lto static-libs )
	pgo? ( || (
		pgo-custom
		pgo-trainer-minizip-binary-long
		pgo-trainer-minizip-binary-max-compression
		pgo-trainer-minizip-binary-short
		pgo-trainer-minizip-binary-store
		pgo-trainer-minizip-text-long
		pgo-trainer-minizip-text-max-compression
		pgo-trainer-minizip-text-short
		pgo-trainer-minizip-text-store
		pgo-trainer-zlib-binary-all
		pgo-trainer-zlib-binary-default
		pgo-trainer-zlib-binary-max
		pgo-trainer-zlib-binary-min
		pgo-trainer-zlib-binary-random
		pgo-trainer-zlib-images-all
		pgo-trainer-zlib-images-default
		pgo-trainer-zlib-images-max
		pgo-trainer-zlib-images-min
		pgo-trainer-zlib-images-random
		pgo-trainer-zlib-text-all
		pgo-trainer-zlib-text-default
		pgo-trainer-zlib-text-max
		pgo-trainer-zlib-text-min
		pgo-trainer-zlib-text-random
	) )
	pgo-custom? ( pgo )
	pgo-trainer-zlib-binary-all? ( pgo )
	pgo-trainer-zlib-binary-default? ( pgo )
	pgo-trainer-zlib-binary-max? ( pgo )
	pgo-trainer-zlib-binary-min? ( pgo )
	pgo-trainer-zlib-binary-random? ( pgo )
	pgo-trainer-zlib-images-all? ( pgo )
	pgo-trainer-zlib-images-default? ( pgo )
	pgo-trainer-zlib-images-max? ( pgo )
	pgo-trainer-zlib-images-min? ( pgo )
	pgo-trainer-zlib-images-random? ( pgo )
	pgo-trainer-zlib-text-all? ( pgo )
	pgo-trainer-zlib-text-default? ( pgo )
	pgo-trainer-zlib-text-max? ( pgo )
	pgo-trainer-zlib-text-min? ( pgo )
	pgo-trainer-zlib-text-random? ( pgo )
	pgo-trainer-minizip-binary-long? ( pgo minizip )
	pgo-trainer-minizip-binary-max-compression? ( pgo minizip )
	pgo-trainer-minizip-binary-short? ( pgo minizip )
	pgo-trainer-minizip-binary-store? ( pgo minizip )
	pgo-trainer-minizip-text-long? ( pgo minizip )
	pgo-trainer-minizip-text-max-compression? ( pgo minizip )
	pgo-trainer-minizip-text-short? ( pgo minizip )
	pgo-trainer-minizip-text-store? ( pgo minizip )
	shadowcallstack? ( clang )
"
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"
PDEPEND="
	pgo? (
		app-arch/pigz[${MULTILIB_USEDEP}]
		|| (
			media-gfx/graphicsmagick
			media-gfx/imagemagick
		)
	)
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
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
		)
		     "
	done
}

gen_shadowcallstack_bdepend() {
	local min=${1}
	local max=${2}
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

# Avoid circular dependency problem, after building llvm/clang it should be fine
PDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
PDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
PDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
PDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
PDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
PDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
PDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" minizip? ( ${AUTOTOOLS_DEPEND} )"
# See #309623 for libxml2
RDEPEND+="
	!<dev-libs/libxml2-2.7.7
	!sys-libs/zlib-ng[compat]
"
DEPEND+="${RDEPEND}"
BDEPEND="
	dev-lang/perl
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-fix-deflateParams-usage.patch
	"${FILESDIR}"/${PN}-1.2.11-minizip-drop-crypt-header.patch #658536
)

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

is_clang_ready() {
	for v in $(seq 10 14) ; do
		if has_version "sys-devel/clang:${v}" \
			&& has_version "sys-devel/llvm:${v}" \
			&& has_version "=sys-devel/clang-runtime-${v}*" \
			&& has_version ">=sys-devel/lld-${v}"
		then
			return 0
		fi
	done
	return 1
}

is_lto_ready() {
	for v in $(seq 11 14) ; do
		if has_version "sys-devel/clang:${v}" \
			&& has_version "sys-devel/llvm:${v}" \
			&& has_version "=sys-devel/clang-runtime-${v}*" \
			&& has_version ">=sys-devel/lld-${v}"
		then
			return 0
		fi
	done
	return 1
}

is_cfi_ready() {
	for v in $(seq 12 14) ; do
		if has_version "sys-devel/clang:${v}" \
			&& has_version "sys-devel/llvm:${v}" \
			&& has_version "=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]" \
			&& has_version ">=sys-devel/lld-${v}" \
			&& has_version "=sys-libs/compiler-rt-${v}*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-${v}*[cfi]"
		then
			return 0
		fi
	done
	return 1
}

is_scs_ready() {
	for v in $(seq 12 14) ; do
		if has_version "sys-devel/clang:${v}" \
			&& has_version "sys-devel/llvm:${v}" \
			&& has_version "=sys-devel/clang-runtime-${v}*[compiler-rt,sanitize]" \
			&& has_version ">=sys-devel/lld-${v}" \
			&& has_version "=sys-libs/compiler-rt-${v}*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack]"
		then
			return 0
		fi
	done
	return 1
}

check_img_converter() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	has_image_folder() {
		if [[ -d "${distdir}/pgo/assets/png" ]] ; then
			return 0
		fi
		return 1
	}

	local png=0
	local tiff=0
	if has_image_folder ; then
		local c=0

		local search_path=()
		if [[ -d "${distdir}/pgo/assets/png" ]] ; then
			search_path+=( "${distdir}/pgo/assets/png" )
		fi
		if [[ -d "${distdir}/pgo/assets/tiff" ]] ; then
			search_path+=( "${distdir}/pgo/assets/tiff" )
		fi

		for f in $(find ${search_path} -type f \
			-iname "*.png" \
			-o -iname "*.tiff" \
			) ; do
			if [[ "${f,,}" =~ png$ ]] ; then
				png=0
			elif [[ "${f,,}" =~ tiff$ ]] ; then
				jpeg=0
			fi
		done

		# For zlib image formats
		if (( ${png} == 1 )) ; then
			if has_version "media-gfx/graphicsmagick[png,zlib]" ; then
				:;
			elif has_version "media-gfx/imagemagick[png,zlib]" ; then
				:;
			else
				ewarn
				ewarn "You need at least one of media-gfx/graphicsmagick[png,zlib] or"
				ewarn "media-gfx/imagemagick[png,zlib] for proper compression profiling"
				ewarn
			fi
		fi
		if (( ${tiff} == 1 )) && has_version "media-libs/tiff[zlib]" ; then
			if has_version "media-gfx/graphicsmagick[tiff,zlib]" ; then
				:;
			elif has_version "media-gfx/imagemagick[tiff,zlib]" ; then
				:;
			else
				ewarn
				ewarn "You need at least one of media-gfx/graphicsmagick[tiff,zlib] or"
				ewarn "media-gfx/imagemagick[tiff,zlib] for proper compression profiling"
				ewarn
			fi
		fi
	fi
}

pkg_setup() {
	if [[ "${IUSE}" =~ "pgo-trainer-zlib-images-" ]] ; then
		check_img_converter
	fi
}

src_prepare() {
	default

	if use elibc_Cygwin ; then
		local p
		for p in "${CYGWINPATCHES[@]}" ; do
			# Strip out the "... -> " from the array
			eapply -p2 "${DISTDIR}/${p#*> }"
		done
	fi

	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
	fi

	case ${CHOST} in
	*-cygwin*)
		# do not use _wopen, is a mingw symbol only
		sed -i -e '/define WIDECHAR/d' "${S}"/gzguts.h || die
		# zlib1.dll is the mingw name, need cygz.dll
		# cygz.dll is loaded by toolchain, put into subdir
		sed -i -e 's|zlib1.dll|win32/cygz.dll|' win32/Makefile.gcc || die
		;;
	esac

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

echoit() { echo "$@"; "$@"; }

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

append_lto() {
	filter-flags '-flto*' '-fuse-ld=*'
	if tc-is-clang && is_lto_ready ; then
		append-flags -flto=thin -fuse-ld=lld
		append-ldflags -fuse-ld=lld -flto=thin
	else
		append-flags -flto=auto
		append-ldflags -flto=auto
	fi
	if [[ "${USE}" =~ "cfi" ]] ; then
		append-flags -fsplit-lto-unit
	fi
}

src_configure() { :; }

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

_configure_pgx() {
	[[ -f Makefile && "${PGO_PHASE}" == "pgo" ]] \
		&& grep -q -e "^clean:" Makefile \
		&& emake clean
	use minizip \
		&& [[ -f contrib/minizip/Makefile && "${PGO_PHASE}" == "pgo" ]] \
		&& grep -q -e "^clean:" contrib/minizip/Makefile \
		&& emake clean -C contrib/minizip
	cd "${BUILD_DIR}" || die
	if use clang && is_clang_ready ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		LD="ld.lld"
	else
		CC="gcc $(get_abi_CFLAGS ${ABI})"
		CXX="g++ $(get_abi_CFLAGS ${ABI})"
		AR="ar"
		AS="as"
		NM="nm"
		RANLIB="ranlib"
		READELF="readelf"
		LD="ld.bfd"
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'-f*sanitize*' \
		'-f*stack*' \
		'-fprofile*' \
		'-fvisibility=hidden' \
		'-Wno-error=*'
		'--param=ssp-buffer-size=*' \
		-Wl,-z,noexecstack \
		-Wl,-z,now \
		-Wl,-z,relro \
		-stdlib=libc++

	autofix_flags

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		if tc-is-clang && [[ "${build_type}" == "static-libs" ]] ;then
			if use cfi ; then
				append_all -fvisibility=hidden -fsanitize=cfi
			else
				use cfi-cast && append_all -fvisibility=hidden \
							-fsanitize=cfi-derived-cast \
							-fsanitize=cfi-unrelated-cast
				use cfi-icall && append_all -fvisibility=hidden \
							-fsanitize=cfi-icall
				use cfi-vcall && append_all -fvisibility=hidden \
							-fsanitize=cfi-vcall
			fi
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	use hardened && append-ldflags -Wl,-z,noexecstack
	use lto && append_lto
	if is_hardened_gcc ; then
		# Already done in hardened gcc
		:;
	elif is_hardened_clang ; then
		set_cfi
	else
		set_cfi
		if use hardened ; then
			append-ldflags -Wl,-z,relro -Wl,-z,now
			if [[ -n "${USE_HARDENED_PROFILE_DEFAULTS}" \
				&& "${USE_HARDENED_PROFILE_DEFAULTS}" == "1" ]] ; then
				append-cppflags -D_FORTIFY_SOURCE=2
				append-flags $(test-flags-CC -fstack-clash-protection)
				append-ldflags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
			else
				append-ldflags --param=ssp-buffer-size=4 \
						-fstack-protector
			fi
		fi
	fi

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
			llvm-profdata merge -output="${T}/pgo-${ABI}/code.profdata" \
				"${T}/pgo-${ABI}" || die
			append-flags -fprofile-use="${T}/pgo-${ABI}/code.profdata"
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
			if use minizip ; then
				# Apply, only during configure.
				append-flags -Wno-error=coverage-mismatch
			fi
		fi
	fi

	case ${CHOST} in
	*-mingw*|mingw*|*-cygwin*)
		;;
	*)
		local uname=$("${EPREFIX}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3) #347167
		local myconf=(
			--prefix="${EPREFIX}/usr"
			--libdir="${EPREFIX}/usr/$(get_libdir)"
			${uname:+--uname=${uname}}
		)

		if [[ "${build_type}" == "static-libs" ]] ; then
			myconf+=(
				--static
			)
		else
			myconf+=(
				--shared
			)
		fi

		einfo "Configuring zlib for ${build_type} for ${ABI}"
		# not an autoconf script, so can't use econf
		echoit "${S}"/configure "${myconf[@]}" || die
		;;
	esac

	if use minizip ; then
		einfo "Configuring minizip for ${build_type} for ${ABI}"
		local minizipdir="contrib/minizip"
		mkdir -p "${BUILD_DIR}/${minizipdir}" || die
		cd ${minizipdir} || die
		local myconf=()
		if [[ "${build_type}" == "static-libs" ]] ; then
			myconf+=(
				--enable-static
				--disable-shared
			)
		else
			myconf+=(
				--disable-static
				--enable-shared
			)
		fi
		ECONF_SOURCE="${S}/${minizipdir}" \
		econf ${myconf[@]}
		if use pgo ;  then
			sed -i -e "s|-Wno-error=coverage-mismatch||g" "${S}/contrib/minizip/Makefile" || die
			sed -i -e "s|-Wno-error=coverage-mismatch||g" "${S}/contrib/minizip/libtool" || die
			sed -i -e "s|-Wno-error=coverage-mismatch||g" "${S}/Makefile" || die
		fi
	fi
}

_build_pgx() {
	einfo "Compiling ${build_type} for ${ABI}"
	cd "${BUILD_DIR}" || die
	einfo "Building zlib ${build_type} for ${ABI}"
	case ${CHOST} in
	*-mingw*|mingw*|*-cygwin*)
		emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}- ${build_type/-*}
		sed \
			-e 's|@prefix@|'"${EPREFIX}"'/usr|g' \
			-e 's|@exec_prefix@|${prefix}|g' \
			-e 's|@libdir@|${exec_prefix}/'$(get_libdir)'|g' \
			-e 's|@sharedlibdir@|${exec_prefix}/'$(get_libdir)'|g' \
			-e 's|@includedir@|${prefix}/include|g' \
			-e 's|@VERSION@|'${PV}'|g' \
			zlib.pc.in > zlib.pc || die
		;;
	*)
		emake ${build_type/-*}
		;;
	esac
	if use minizip ; then
		einfo "Building minizip ${build_type} for ${ABI}"
		emake -C contrib/minizip
		if use pgo ; then
			emake -C contrib/minizip minizip miniunzip
		fi
	fi
}

_run_trainer_images_zlib() {
	local mode="${1}"
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	( ! has_pgo_requirement ) && return
	einfo "Running image compression PGO training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	local N=270 # 30 * 9 compression levels
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_PGO_MAX_FILES:=500} # arbitrary

	has_image_folder() {
		if [[ -d "${distdir}/pgo/assets/avif" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/bmp" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/gif" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/images" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/jpeg" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/png" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/svg" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/pgo/assets/webp" ]] ; then
			return 0
		fi
		return 1
	}

	if has_image_folder ; then
		local c=0

		local search_path=()
		if [[ -d "${distdir}/pgo/assets/apng" ]] ; then
			search_path+=( "${distdir}/pgo/assets/apng" )
		fi
		if [[ -d "${distdir}/pgo/assets/avif" ]] ; then
			search_path+=( "${distdir}/pgo/assets/avif" )
		fi
		if [[ -d "${distdir}/pgo/assets/bmp" ]] ; then
			search_path+=( "${distdir}/pgo/assets/bmp" )
		fi
		if [[ -d "${distdir}/pgo/assets/gif" ]] ; then
			search_path+=( "${distdir}/pgo/assets/gif" )
		fi
		if [[ -d "${distdir}/pgo/assets/ico" ]] ; then
			search_path+=( "${distdir}/pgo/assets/ico" )
		fi
		if [[ -d "${distdir}/pgo/assets/images" ]] ; then
			search_path+=( "${distdir}/pgo/assets/images" )
		fi
		if [[ -d "${distdir}/pgo/assets/jpeg" ]] ; then
			search_path+=( "${distdir}/pgo/assets/jpeg" )
		fi
		if [[ -d "${distdir}/pgo/assets/png" ]] ; then
			search_path+=( "${distdir}/pgo/assets/png" )
		fi
		if [[ -d "${distdir}/pgo/assets/svg" ]] ; then
			search_path+=( "${distdir}/pgo/assets/svg" )
		fi
		if [[ -d "${distdir}/pgo/assets/tiff" ]] ; then
			search_path+=( "${distdir}/pgo/assets/tiff" )
		fi
		if [[ -d "${distdir}/pgo/assets/webp" ]] ; then
			search_path+=( "${distdir}/pgo/assets/webp" )
		fi

		for f in $(find ${search_path} -type f \
			-iname "*.apng" \
			-o -iname "*.avif" \
			-o -iname "*.bmp" \
			-o -iname "*.gif" \
			-o -iname "*.ico" \
			-o -iname "*.jfif" \
			-o -iname "*.jpg" \
			-o -iname "*.jpeg" \
			-o -iname "*.pjpeg" \
			-o -iname "*.pjp" \
			-o -iname "*.png" \
			-o -iname "*.svg" \
			-o -iname "*.tiff" \
			-o -iname "*.webp" \
			| shuf) ; do
			if [[ -f "${f}" && ! -L "${f}" ]] ; then
				#einfo "Adding ${f} to the compression sandbox"
				cp -a "${f}" "${T}/sandbox" || die
				c=$(( ${c} + 1 ))
			else
				:; #einfo "Skipping ${f} which may not be a text file but a symlink"
			fi
			(( ${c} >= ${MAX_FILES_IN_ARCHIVE} )) && break
		done
		rm -rf "${T}/sandbox-headers" || die
	else
		die "Missing at least one ${distdir}/pgo/assets/{apng,bmp,gif,images,jpeg,png,svg,tiff,webp} folder for PGO training"
	fi

	einfo "zlib image compression/decompress all compression levels training for ${mode} compression level(s)"
	local L=1
	[[ "${mode}" == "all" ]] && L=270 # Increase the weight of the code paths related to compression levels
	for f in $(find "${T}/sandbox" -type f) ; do
		for i in $(seq ${L}) ; do
			local cmd
			local quality=0
			if [[ "${mode}" == "all" || "${mode}" == "random" ]] ; then
				quality=$(($((${RANDOM} % 9)) + 1))
				cmd=( "${PIGZEXE}" -z -${quality} "${f}" )
			elif [[ "${mode}" == "default" ]] ; then
				quality=6
				cmd=( "${PIGZEXE}" -z -6 "${f}" )
			elif [[ "${mode}" == "level-8" ]] ; then
				quality=8
				cmd=( "${PIGZEXE}" -z -8 "${f}" )
			elif [[ "${mode}" == "max" ]] ; then
				quality=9
				cmd=( "${PIGZEXE}" -z -9 "${f}" )
			elif [[ "${mode}" == "min" ]] ; then
				quality=1
				cmd=( "${PIGZEXE}" -z -1 "${f}" )
			fi

			einfo "Compressing/decompressing image as is"
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
			cmd=( "${PIGZEXE}" -d "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die

			# Convert the image as uncompressed bitmap, then profile the compression
			local has_zlib_image_format=0
			if [[ -e "${T}/sandbox/tmp.bmp" ]] ; then
				rm "${T}/sandbox/tmp.bmp" || die
			fi
			local o1="${T}/sandbox/temp.bmp"
			local o2=""
			local msg1=""
			local cmd2=""
			if which gm 2>/dev/null 1>/dev/null \
				&& has_version "media-gfx/graphicsmagick[png,zlib]" \
				&& [[ "${f,,}" =~ png$ ]] ; then
				cmd1=( gm convert "${f}" "${o1}" )
				cmd2=( gm convert "${o1}" -quality ${quality}0 "${o2}" )
				o2="${T}/sandbox/temp.png"
				has_zlib_image_format=1
			elif which magick 2>/dev/null 1>/dev/null \
				&& has_version "media-gfx/imagemagick[png,zlib]" \
				&& [[ "${f,,}" =~ png$ ]]; then
				o="${T}/sandbox/temp.bmp"
				cmd1=( magick convert "${f}" "${o1}" )
				cmd2=( magick convert "${o1}" -quality ${quality}0 "${o2}" )
				o2="${T}/sandbox/temp.png"
				has_zlib_image_format=1

			elif which gm 2>/dev/null 1>/dev/null \
				&& has_version "media-gfx/graphicsmagick[tiff,zlib]" \
				&& [[ "${f,,}" =~ tiff$ ]] \
				&& has_version "media-libs/tiff[zlib]" ; then
				o="${T}/sandbox/temp.bmp"
				cmd1=( gm convert "${f}" "${o1}" )
				cmd2=( gm convert "${o1}" -quality ${quality}0 "${o2}" )
				o2="${T}/sandbox/temp.tiff"
				has_zlib_image_format=1
			elif which magick 2>/dev/null 1>/dev/null \
				&& has_version "media-gfx/imagemagick[tiff,zlib]" \
				&& [[ "${f,,}" =~ tiff$ ]] \
				&& has_version "media-libs/tiff[zlib]" ; then
				o="${T}/sandbox/temp.bmp"
				cmd1=( magick convert "${f}" "${o1}" )
				cmd2=( magick convert "${o1}" -quality ${quality}0 "${o2}" )
				o2="${T}/sandbox/temp.tiff"
				has_zlib_image_format=1
			fi

			if multilib_is_native_abi && (( ${has_zlib_image_format} == 1 )) ; then
				einfo "Compressing/decompressing zlib image formats -> bitmap -> zlib compressed"
				einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
				"${cmd1[@]}" || die

				einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
				"${cmd2[@]}" || die

				# Remove temporary files
				rm -rf "${o1}" || die
				rm -rf "${o2}" || die
			elif (( ${has_zlib_image_format} == 1 )) ; then
				einfo
				einfo "Profiling skipped with libpng/tiff for non-native ABI because"
				einfo "of unpackaged ${ABI} image converter"
				einfo
			fi
		done
		[[ "${mode}" == "all" ]] && break # do only once
	done
	#einfo "Clearing sandbox"
	rm -rf "${T}/sandbox" || die
}

_run_trainer_text_zlib() {
	local mode="${1}"
	( ! has_pgo_requirement ) && return
	einfo "Running text compression PGO training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	local N=270 # 30 * 9 compression levels
	if [[ -d /usr/include/linux ]] ; then
		local c=0
		for f in $(find /usr/include/linux -type f | shuf) ; do
			if [[ -f "${f}" && ! -L "${f}" ]] ; then
				#einfo "Adding ${f} to the compression sandbox"
				cp -a "${f}" "${T}/sandbox" || die
				c=$(( ${c} + 1 ))
			else
				:; #einfo "Skipping ${f} which may not be a text file but a symlink"
			fi
			(( ${c} >= ${N} )) && break
		done
		rm -rf "${T}/sandbox-headers" || die
	elif [[ -d /usr/lib/gcc/${CHOST}/$(gcc-version).0/include ]] ; then
		local c=0
		for f in $(find /usr/lib/gcc/${CHOST}/$(gcc-version).0/include -type f | shuf) ; do
			if [[ -f "${f}" && ! -L "${f}" ]] ; then
				#einfo "Adding ${f} to the compression sandbox"
				cp -a "${f}" "${T}/sandbox" || die
				c=$(( ${c} + 1 ))
			else
				:; # einfo "Skipping ${f} which may not be a text file but a symlink"
			fi
			(( ${c} >= ${N} )) && break
		done
	else
		die "Missing /usr/include/linux or /usr/lib/gcc/${CHOST}/$(gcc-version).0/include for PGO training"
	fi
	einfo "zlib text compression/decompression training for ${mode} compression level(s)"
	local L=1
	[[ "${mode}" == "all" ]] && L=270
	for f in $(find "${T}/sandbox" -type f) ; do
		for i in ${L} ; do
			local cmd
			if [[ "${mode}" == "all" || "${mode}" == "random" ]] ; then
				cmd=( "${PIGZEXE}" -z -$(($((${RANDOM} % 9)) + 1)) "${f}" )
			elif [[ "${mode}" == "default" ]] ; then
				cmd=( "${PIGZEXE}" -z -6 "${f}" )
			elif [[ "${mode}" == "max" ]] ; then
				cmd=( "${PIGZEXE}" -z -9 "${f}" )
			elif [[ "${mode}" == "min" ]] ; then
				cmd=( "${PIGZEXE}" -z -1 "${f}" )
			fi
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die

			cmd=( "${PIGZEXE}" -d "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		[[ "${mode}" == "all" ]] && break # once only
	done
	#einfo "Clearing sandbox"
	rm -rf "${T}/sandbox" || die

}

_run_trainer_text_minizip() {
	( ! has_pgo_requirement ) && return
	einfo "Running text compression PGO training for ${ABI} for minizip"
	export MINIZIP="minizip"
	export MINIUNZIP="miniunzip"

	# Typical use.
	# Most people compress everything at the same time.
	# This test will simulate compressing an entire folder of files, then
	# it will decompress this single file.
	# It does it 300 times for various directory sizes for about 30
	# times per compression level.
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_PGO_MAX_FILES:=500} # arbitrary
	for i in $(seq 1 ${N}) ; do
		#einfo "Preparing training sandbox"
		mkdir -p "${T}/sandbox" || die
		cd "${T}/sandbox" || die
		local max_files_in_archive=$(( $((${RANDOM} % ${MAX_FILES_IN_ARCHIVE})) + 1 ))
		local compression_level
		if [[ -n "${max_compression}" ]] ; then
			compression_level=9
		elif [[ -n "${store_only}" ]] ; then
			compression_level=0
		else
			compression_level=$((${RANDOM} % 10))
		fi
		einfo "Progress ${i}/${N}, max_files_in_archive = ${max_files_in_archive}, compression_level = ${compression_level}"
		if [[ -d /usr/include/linux ]] ; then
			local c=0
			for f in $(find /usr/include/linux -type f | shuf) ; do
				if [[ -f "${f}" && ! -L "${f}" ]] ; then
					#einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || die
					c=$(( ${c} + 1 ))
				else
					:; #einfo "Skipping ${f} which may not be a text file but a symlink"
				fi
				(( ${c} >= ${max_files_in_archive} )) && break # arbitrary
			done
			rm -rf "${T}/sandbox-headers" || die
		elif [[ -d /usr/lib/gcc/${CHOST}/$(gcc-version).0/include ]] ; then
			local c=0
			for f in $(find /usr/lib/gcc/${CHOST}/$(gcc-version).0/include -type f | shuf) ; do
				if [[ -f "${f}" && ! -L "${f}" ]] ; then
					#einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || die
					c=$(( ${c} + 1 ))
				else
					:; #einfo "Skipping ${f} which may not be a text file but a symlink"
				fi
				(( ${c} >= ${max_files_in_archive} )) && break # arbitrary
			done
		else
			die "Missing /usr/include/linux or /usr/lib/gcc/${CHOST}/$(gcc-version).0/include for PGO training"
		fi
		#einfo "minizip text compression training"
		local cmd=( "${MINIZIP}" -o -${compression_level} example.zip $(find "${T}/sandbox" -type f) )
		#einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
		"${cmd[@]}" 2>/dev/null 1>/dev/null || die
		cd "${T}/sandbox" || die
		#einfo "minizip text decompression training"
		local cmd=( "${MINIUNZIP}" example.zip )
		#einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" yes \"A\" | ${cmd[@]}"
		yes "A" | "${cmd[@]}" 2>/dev/null 1>/dev/null || die
		#einfo "Clearing sandbox"
		rm -rf "${T}/sandbox" || die
	done

}

_run_trainer_binary_zlib() {
	local mode="${1}"
	( ! has_pgo_requirement ) && return
	einfo "Running binary compression PGO training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	[[ ! -d /usr/bin/ ]] && die "missing /usr/bin/ for PGO training"
	# ~391 = 9 compression levels * stats rule of 30 samples [per each level of compression] * 1.45
	# (additional files from weeding out 45% junk files 3/10 to 6/10 is ~45%)
	# Cut short because some files may be gigabytes
	local c=0
	for f in $(find /usr/bin/ -maxdepth 1 -type f | shuf) ; do
		if readelf -h "${f}" 2>/dev/null 1>/dev/null && [[ ! -L "${f}" ]] ; then
			local filesize=$(stat -c "%s" "${f}")
			if (( ${filesize} < 26214400 )) ; then
				# Limit to 25 MiB to prevent compression of gigs of data.
				#einfo "Adding ${f} to the compression sandbox"
				cp -a "${f}" "${T}/sandbox" || echo "Skipping ${f}"
				c=$(( ${c} + 1 ))
			else
				:; #einfo "Skipping large data"
			fi
		else
			:; #einfo "Skipping possible text file or symlink ${f}"
		fi
		(( ${c} >= 270 )) && break # 30 * 9 compression levels
	done
	einfo "zlib binary compression/decompression training for ${mode} compression level(s)"
	local L=1
	[[ "${mode}" == "all" ]] && L=270
	for f in $(find "${T}/sandbox" -type f) ; do
		for i in $(seq ${L}) ; do
			local cmd
			if [[ "${mode}" == "all" || "${mode}" == "random" ]] ; then
				cmd=( "${PIGZEXE}" -z -$(($((${RANDOM} % 9)) + 1)) "${f}" )
			elif [[ "${mode}" == "default" ]] ; then
				cmd=( "${PIGZEXE}" -z -6 "${f}" )
			elif [[ "${mode}" == "max" ]] ; then
				cmd=( "${PIGZEXE}" -z -9 "${f}" )
			elif [[ "${mode}" == "min" ]] ; then
				cmd=( "${PIGZEXE}" -z -1 "${f}" )
			fi
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die

			cmd=( "${PIGZEXE}" -d "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		[[ "${mode}" == "all" ]] && break
	done
	#einfo "Clearing sandbox"
	rm -rf "${T}/sandbox" || die
}

_run_trainer_binary_minizip() {
	( ! has_pgo_requirement ) && return
	einfo "Running binary compression PGO training for ${ABI} for minizip"
	export MINIZIP="minizip"
	export MINIUNZIP="miniunzip"

	[[ ! -d /usr/bin/ ]] && die "missing /usr/bin/ for PGO training"

	# Binary version:  This test will simulate compressing an entire folder
	# of files, then it will decompress this single file.
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_PGO_MAX_FILES:=500} # arbitrary
	for i in $(seq 1 ${N}) ; do
		#einfo "Preparing training sandbox"
		mkdir -p "${T}/sandbox" || die
		cd "${T}/sandbox" || die
		local max_files_in_archive=$(( $((${RANDOM} % ${MAX_FILES_IN_ARCHIVE})) + 1 ))
		local compression_level
		if [[ -n "${max_compression}" ]] ; then
			compression_level=9
		elif [[ -n "${store_only}" ]] ; then
			compression_level=0
		else
			compression_level=$((${RANDOM} % 10))
		fi
		einfo "Progress ${i}/${N}, max_files_in_archive = ${max_files_in_archive}, compression_level = ${compression_level}"
		local c=0
		for f in $(find /usr/bin/ -maxdepth 1 -type f | shuf ) ; do
			if readelf -h "${f}" 2>/dev/null 1>/dev/null && [[ ! -L "${f}" ]] ; then
				local filesize=$(stat -c "%s" "${f}")
				if (( ${filesize} < 26214400 )) ; then
					# Limit to 25 MiB to prevent compression of gigs of data.
					#einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || echo "Skipping ${f}"
					c=$(( ${c} + 1 ))
				else
					:; #einfo "Skipping large data"
				fi
			else
				:; #einfo "Skipping possible text file or symlink ${f}"
			fi
			(( ${c} >= ${max_files_in_archive} )) && break # arbitrary
		done
		#einfo "minizip binary compression training"
		local cmd=( "${MINIZIP}" -o -${compression_level} example.zip $(find "${T}/sandbox" -type f) )
		#einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
		"${cmd[@]}" 2>/dev/null 1>/dev/null || die
		cd "${T}/sandbox" || die
		#einfo "minizip binary decompression training"
		local cmd=( "${MINIUNZIP}" example.zip )
		#einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" yes \"A\" | ${cmd[@]}"
		yes "A" | "${cmd[@]}" 2>/dev/null 1>/dev/null || die
		#einfo "Clearing sandbox"
		rm -rf "${T}/sandbox" || die
	done
}

_run_trainer_custom() {
	if [[ ! -e "pgo-custom.sh" ]] ; then
		die "Missing pgo-custom.sh"
	else
		ewarn "Always use a sandbox in ${T} when using pgo-custom"
		chmod +x "pgo-custom.sh" || die
		chown portage:portage "pgo-custom.sh" || die
		./pgo-custom.sh || die
	fi
}

_run_trainers() {
	export PATH="${S}/contrib/minizip:${PATH_orig}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	if use pgo-trainer-zlib-binary-all ; then
		_run_trainer_binary_zlib "all"
	fi
	if use pgo-trainer-zlib-binary-default ; then
		_run_trainer_binary_zlib "default"
	fi
	if use pgo-trainer-zlib-binary-max ; then
		_run_trainer_binary_zlib "max"
	fi
	if use pgo-trainer-zlib-binary-min ; then
		_run_trainer_binary_zlib "min"
	fi
	if use pgo-trainer-zlib-binary-random ; then
		_run_trainer_binary_zlib "random"
	fi
	if use pgo-trainer-zlib-images-all ; then
		_run_trainer_images_zlib "all"
	fi
	if use pgo-trainer-zlib-images-default ; then
		_run_trainer_images_zlib "default"
	fi
	if use pgo-trainer-zlib-images-level-8 ; then
		_run_trainer_images_zlib "level-8"
	fi
	if use pgo-trainer-zlib-images-max ; then
		_run_trainer_images_zlib "max"
	fi
	if use pgo-trainer-zlib-images-min ; then
		_run_trainer_images_zlib "min"
	fi
	if use pgo-trainer-zlib-images-random ; then
		_run_trainer_images_zlib "random"
	fi
	if use pgo-trainer-zlib-text-all ; then
		_run_trainer_text_zlib "all"
	fi
	if use pgo-trainer-zlib-text-default ; then
		_run_trainer_text_zlib "default"
	fi
	if use pgo-trainer-zlib-text-max ; then
		_run_trainer_text_zlib "max"
	fi
	if use pgo-trainer-zlib-text-min ; then
		_run_trainer_text_zlib "min"
	fi
	if use pgo-trainer-zlib-text-random ; then
		_run_trainer_text_zlib "random"
	fi
	if use pgo-trainer-minizip-binary-long ; then
		local N=${MINIZIP_PGO_LONG_N_ITERATIONS:=300}
		_run_trainer_binary_minizip
	fi
	if use pgo-trainer-minizip-binary-max-compression ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		local max_compression=1
		_run_trainer_binary_minizip
		unset max_compression
	fi
	if use pgo-trainer-minizip-binary-short ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		_run_trainer_binary_minizip
	fi
	if use pgo-trainer-minizip-binary-store ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		local store_only=1
		_run_trainer_binary_minizip
		unset store_only
	fi
	if use pgo-trainer-minizip-text-long ; then
		local N=${MINIZIP_PGO_LONG_N_ITERATIONS:=300}
		_run_trainer_text_minizip
	fi
	if use pgo-trainer-minizip-text-max-compression ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		local max_compression=1
		_run_trainer_text_minizip
		unset max_compression
	fi
	if use pgo-trainer-minizip-text-short ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		_run_trainer_text_minizip
	fi
	if use pgo-trainer-minizip-text-store ; then
		local N=${MINIZIP_PGO_SHORT_N_ITERATIONS:=30}
		local store_only=1
		_run_trainer_text_minizip
		unset store_only
	fi
	if use pgo-custom ; then
		_run_trainer_custom
	fi
}

has_pgo_requirement() {
	if multilib_is_native_abi && which pigz 2>/dev/null 1>/dev/null ; then
		return 0
	elif ! multilib_is_native_abi && which pigz-${ABI} 2>/dev/null 1>/dev/null ; then
		return 0
	fi
	return 1
}

src_compile() {
	export PATH_orig="${ED}/usr/bin:${PATH}"
	compile_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			if use pgo && has_pgo_requirement ; then
				PGO_PHASE="pgi"
				if [[ "${build_type}" == "shared-libs" ]] ; then
					_configure_pgx
					_build_pgx
					# This technique currently works on shared, but the generated profiling data
					# may be compatible with static.
					_install_pgx
					_run_trainers
					_clean_pgx
				fi
				if (( $(find "${T}/pgo-${ABI}" -type f 2>/dev/null | wc -l) > 0 )) ; then
					PGO_PHASE="pgo"
					[[ "${build_type}" == "static-libs" ]] \
						&& ewarn "Reusing PGO data from shared-libs"
				else
					ewarn "No PGO data found.  Skipping PGO build and building normally."
					unset PGO_PHASE
				fi
				_configure_pgx
				_build_pgx
				export RAN_PGO=1
			else
				einfo "Skipping PGO training for ${ABI}"
				_configure_pgx
				_build_pgx
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

sed_macros() {
	# clean up namespace a little #383179
	# we do it here so we only have to tweak 2 files
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' "$@" || die
}

_install_pgx() {
	einfo "Installing ${build_type} into sandbox for ${ABI}"
	_install
}

_clean_pgx() {
	einfo "Wiping sandbox image"
	rm -rf "${ED}" || die
	cd "${S}" || die
}

_install() {
	case ${CHOST} in
	*-mingw*|mingw*|*-cygwin*)
		emake -f win32/Makefile.gcc install \
			BINARY_PATH="${ED}/usr/bin" \
			LIBRARY_PATH="${ED}/usr/$(get_libdir)" \
			INCLUDE_PATH="${ED}/usr/include" \
			SHARED_MODE=1
		# overwrites zlib.pc created from win32/Makefile.gcc #620136
		insinto /usr/$(get_libdir)/pkgconfig
		doins zlib.pc
		;;

	*)
		emake install DESTDIR="${D}" LDCONFIG=:
		[[ "${build_type}" == "shared-libs" ]] && gen_usr_ldscript -a z
		;;
	esac
	sed_macros "${ED}"/usr/include/*.h

	if use minizip ; then
		einfo "Installing minizip for ${ABI}"
		emake -C "${S}/contrib/minizip" install DESTDIR="${D}"
		sed_macros "${ED}"/usr/include/minizip/*.h
	fi

	#if [[ "${build_type}" == "shared-libs" ]] ; then
	#	rm -f "${ED}"/usr/$(get_libdir)/lib{z,minizip}.{a,la} || die #419645
	#fi
}

src_install() {
	install_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_install
		done
	}
	multilib_foreach_abi install_abi

	cd "${S}" || die
	dodoc FAQ README ChangeLog doc/*.txt
	use minizip && dodoc contrib/minizip/*.txt
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
elog "  app-arch/pigz[$(get_arch_enabled_use_flags)]"
	fi
	if [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "cfi, cfi-cast, cfi-icall, cfi-vcall require static linking of this"
ewarn "library."
ewarn
ewarn "If you do \`ldd <path to exe>\` and you still see zlib.so then it breaks"
ewarn "The CFI runtime protection spec as if that scheme of CFI was never used."
ewarn "For details, see"
ewarn "https://clang.llvm.org/docs/ControlFlowIntegrity.html with"
ewarn "\"statically linked\" keyword search."
ewarn
	fi

	if ( use cfi || use cfi-cast || use cfi-icall || use cfi-vcall ) \
		&& ! is_cfi_ready ; then
ewarn
ewarn "A circular depends was avoided, but you still need to re-emerge this"
ewarn "package after LLVM for CFI support then rebuild all CFI dependants"
ewarn "of this package."
ewarn
	fi

	if use clang && ! is_clang_ready ; then
ewarn
ewarn "A circular depends was avoided, but you still need to re-emerge this"
ewarn "package after LLVM."
ewarn
	fi

	if use lto && ! is_lto_ready ; then
ewarn
ewarn "A circular depends was avoided, but you still need to re-emerge this"
ewarn "package after LLVM for LTO support."
ewarn
	fi

	if use shadowcallstack && ! is_scs_ready ; then
ewarn
ewarn "A circular depends was avoided, but you still need to re-emerge this"
ewarn "package after LLVM for shadowcallstack support."
ewarn
	fi
	if use static-libs &&
		( ! is_cfi_ready || ! is_clang_ready || ! is_lto_ready \
		|| ! is_scs_ready ) ; then
ewarn
ewarn "A circular depends was avoided, but you may need to re-emerge this"
ewarn "package optimized/protected after emerging clang and then re-emerge"
ewarn "dependencies that use this package's static-libs."
ewarn
	fi
}

