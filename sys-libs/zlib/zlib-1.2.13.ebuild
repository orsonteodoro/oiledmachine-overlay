# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports.
AUTOTOOLS_AUTO_DEPEND="no"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/madler.asc
inherit autotools flag-o-matic flag-o-matic-om multilib-minimal toolchain-funcs
inherit uopts usr-ldscript verify-sig

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="https://zlib.net/"
SRC_URI="
	https://zlib.net/${P}.tar.gz
	https://zlib.net/fossils/${P}.tar.xz
	https://zlib.net/current/beta/${P}.tar.xz
	verify-sig? ( https://zlib.net/${P}.tar.xz.asc )
"

LICENSE="ZLIB"
# pgo? ( GPL-2 ) # unsourced, can't remember why this was added.
# The FAQ does mention GPL-2 but the file is not there but a file with a
# similar name exist but under different licensing.
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minizip minizip-utils static-libs backup-copy"
IUSE+="
	pgo
	trainer-minizip-binary-long
	trainer-minizip-binary-max-compression
	trainer-minizip-binary-short
	trainer-minizip-binary-store
	trainer-minizip-text-long
	trainer-minizip-text-max-compression
	trainer-minizip-text-short
	trainer-minizip-text-store
	trainer-zlib-binary-all
	trainer-zlib-binary-default
	trainer-zlib-binary-max
	trainer-zlib-binary-min
	trainer-zlib-binary-random
	trainer-zlib-images-all
	trainer-zlib-images-default
	trainer-zlib-images-level-8
	trainer-zlib-images-max
	trainer-zlib-images-min
	trainer-zlib-images-random
	trainer-zlib-text-all
	trainer-zlib-text-default
	trainer-zlib-text-max
	trainer-zlib-text-min
	trainer-zlib-text-random
"
REQUIRED_USE="
	pgo? (
		minizip? ( minizip-utils )
		|| (
			trainer-minizip-binary-long
			trainer-minizip-binary-max-compression
			trainer-minizip-binary-short
			trainer-minizip-binary-store
			trainer-minizip-text-long
			trainer-minizip-text-max-compression
			trainer-minizip-text-short
			trainer-minizip-text-store
			trainer-zlib-binary-all
			trainer-zlib-binary-default
			trainer-zlib-binary-max
			trainer-zlib-binary-min
			trainer-zlib-binary-random
			trainer-zlib-images-all
			trainer-zlib-images-default
			trainer-zlib-images-max
			trainer-zlib-images-min
			trainer-zlib-images-random
			trainer-zlib-text-all
			trainer-zlib-text-default
			trainer-zlib-text-max
			trainer-zlib-text-min
			trainer-zlib-text-random
		)
	)
	trainer-zlib-binary-all? ( pgo )
	trainer-zlib-binary-default? ( pgo )
	trainer-zlib-binary-max? ( pgo )
	trainer-zlib-binary-min? ( pgo )
	trainer-zlib-binary-random? ( pgo )
	trainer-zlib-images-all? ( pgo )
	trainer-zlib-images-default? ( pgo )
	trainer-zlib-images-max? ( pgo )
	trainer-zlib-images-min? ( pgo )
	trainer-zlib-images-random? ( pgo )
	trainer-zlib-text-all? ( pgo )
	trainer-zlib-text-default? ( pgo )
	trainer-zlib-text-max? ( pgo )
	trainer-zlib-text-min? ( pgo )
	trainer-zlib-text-random? ( pgo )
	trainer-minizip-binary-long? ( pgo minizip )
	trainer-minizip-binary-max-compression? ( pgo minizip )
	trainer-minizip-binary-short? ( pgo minizip )
	trainer-minizip-binary-store? ( pgo minizip )
	trainer-minizip-text-long? ( pgo minizip )
	trainer-minizip-text-max-compression? ( pgo minizip )
	trainer-minizip-text-short? ( pgo minizip )
	trainer-minizip-text-store? ( pgo minizip )
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

BDEPEND+="
	minizip? ( ${AUTOTOOLS_DEPEND} )
	verify-sig? ( sec-keys/openpgp-keys-madler )
"
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
	# Don't install unexpected & unused crypt.h header (which would clash with other pkgs)
	# Pending upstream. bug #658536
	"${FILESDIR}"/${PN}-1.2.11-minizip-drop-crypt-header.patch

	# Respect AR, RANLIB, NM during build. Pending upstream. bug #831628
	"${FILESDIR}"/${PN}-1.2.11-configure-fix-AR-RANLIB-NM-detection.patch

	# Respect LDFLAGS during configure tests. Pending upstream
	"${FILESDIR}"/${PN}-1.2.13-use-LDFLAGS-in-configure.patch
)

# The order does matter with USE=pgo
# Shared comes first so that static can reuse the shared-lib PGO profile if
# the compiler allows it.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

check_img_converter() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	has_image_folder() {
		if [[ -d "${distdir}/trainer/assets/png" ]] ; then
			return 0
		fi
		return 1
	}

	local png=0
	local tiff=0
	if has_image_folder ; then
		local c=0

		local search_path=()
		if [[ -d "${distdir}/trainer/assets/png" ]] ; then
			search_path+=( "${distdir}/trainer/assets/png" )
		fi
		if [[ -d "${distdir}/trainer/assets/tiff" ]] ; then
			search_path+=( "${distdir}/trainer/assets/tiff" )
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
ewarn
ewarn "If you use experimental features, patches, optimizations, please make a"
ewarn "backup of the package first.  Not doing so may make your computer"
ewarn "unbootable.  This copy should be already uncompressed."
ewarn
ewarn "In an event that the ebuild breaks, DO NOT REBOOT the computer but"
ewarn "try to replace the broken /$(get_libdir)/libz.so.${PV} with a"
ewarn "working copy matching the ABI and SOVERSION."
ewarn
ewarn "A backup copy can be made with USE=backup-copy with the previous"
ewarn "install.  It is important that the previous build to be replaced is"
ewarn "working properly for this to work."
ewarn
ewarn "Emerge this package twice to see if the patch/optimization works"
ewarn "properly."
ewarn
sleep 15
	if [[ "${IUSE}" =~ "trainer-zlib-images-" ]] ; then
		check_img_converter
	fi
	uopts_setup
}

src_prepare() {
	default

	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
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

echoit() { echo "$@"; "$@"; }

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

src_configure() { :; }

_tpgo_custom_clean() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ -f Makefile ]] \
		&& grep -q -e "^clean:" Makefile \
		&& emake clean
	use minizip \
		&& [[ -f contrib/minizip/Makefile ]] \
		&& grep -q -e "^clean:" contrib/minizip/Makefile \
		&& emake clean -C contrib/minizip
}

_src_configure() {
	einfo "Called _src_configure"
	cd "${BUILD_DIR}" || die
	uopts_src_configure

	# Prevents libpng from being built, breaks pngfix when zlib libs are being replaced
	# Prevents loading of precompiled www browser
	# It doesn't work for elibc_glibc and gcc combo.
	for value in cfi-vcall cfi-nvcall cfi-derived-cast cfi-unrelated-cast cfi ; do
		if is-flagq "-fsanitize=*${value}" ; then
			einfo "Removing ${value}"
			strip-flag-value "${value}"
		fi
	done
	filter-flags -fsanitize-cfi-cross-dso

	local flag
	for flag in CFLAGS CXXFLAGS LDFLAGS ; do
		if [[ "${!flag}" =~ "cfi" ]] ; then
eerror
eerror "Remove all cfi flags from ${flag}"
eerror
			die
		fi
	done

	if use pgo && tc-is-gcc && train_meets_requirements && [[  "${PGO_PHASE}" == "PGO" ]] ; then
		if use minizip ; then
			# Apply, only during configure.
			append-flags -Wno-error=coverage-mismatch
			append-flags $(test-flags -Wbackend-plugin) # It should be okay if no code changes.
		fi
	fi

	case ${CHOST} in
	*-mingw*|mingw*)
		;;
	*)
		local uname=$("${EPREFIX}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3) #347167
		local myconf=(
			--prefix="${EPREFIX}/usr"
			--libdir="${EPREFIX}/usr/$(get_libdir)"
			${uname:+--uname=${uname}}
		)

		if [[ "${lib_type}" == "static" ]] ; then
			myconf+=(
				--static
			)
		else
			myconf+=(
				--shared
			)
		fi

		einfo "Configuring zlib for ${lib_type} for ${ABI}"
		# not an autoconf script, so can't use econf
		echoit "${S}"/configure "${myconf[@]}" || die
	esac

	if use minizip ; then
		einfo "Configuring minizip for ${lib_type} for ${ABI}"
		local minizipdir="contrib/minizip"
		mkdir -p "${BUILD_DIR}/${minizipdir}" || die
		cd ${minizipdir} || die
		local myconf=()
		if [[ "${lib_type}" == "static" ]] ; then
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

_src_compile() {
	einfo "Compiling ${lib_type} for ${ABI}"
	cd "${BUILD_DIR}" || die
	einfo "Building zlib ${lib_type} for ${ABI}"
	case ${CHOST} in
	*-mingw*|mingw*)
		emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}- ${lib_type}
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
		emake ${lib_type}
		;;
	esac
	if use minizip ; then
		einfo "Building minizip ${lib_type} for ${ABI}"
		emake -C contrib/minizip
		if use minizip-utils ; then
			emake -C contrib/minizip minizip miniunzip
		fi
	fi
}

_run_trainer_images_zlib() {
	local mode="${1}"
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	train_meets_requirements || return
	einfo "Running image compression training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	local N=270 # 30 * 9 compression levels
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_TRAINING_MAX_FILES:=500} # arbitrary

	has_image_folder() {
		if [[ -d "${distdir}/trainer/assets/avif" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/bmp" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/gif" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/images" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/jpeg" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/png" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/svg" ]] ; then
			return 0
		fi
		if [[ -d "${distdir}/trainer/assets/webp" ]] ; then
			return 0
		fi
		return 1
	}

	if has_image_folder ; then
		local c=0

		local search_path=()
		if [[ -d "${distdir}/trainer/assets/apng" ]] ; then
			search_path+=( "${distdir}/trainer/assets/apng" )
		fi
		if [[ -d "${distdir}/trainer/assets/avif" ]] ; then
			search_path+=( "${distdir}/trainer/assets/avif" )
		fi
		if [[ -d "${distdir}/trainer/assets/bmp" ]] ; then
			search_path+=( "${distdir}/trainer/assets/bmp" )
		fi
		if [[ -d "${distdir}/trainer/assets/gif" ]] ; then
			search_path+=( "${distdir}/trainer/assets/gif" )
		fi
		if [[ -d "${distdir}/trainer/assets/ico" ]] ; then
			search_path+=( "${distdir}/trainer/assets/ico" )
		fi
		if [[ -d "${distdir}/trainer/assets/images" ]] ; then
			search_path+=( "${distdir}/trainer/assets/images" )
		fi
		if [[ -d "${distdir}/trainer/assets/jpeg" ]] ; then
			search_path+=( "${distdir}/trainer/assets/jpeg" )
		fi
		if [[ -d "${distdir}/trainer/assets/png" ]] ; then
			search_path+=( "${distdir}/trainer/assets/png" )
		fi
		if [[ -d "${distdir}/trainer/assets/svg" ]] ; then
			search_path+=( "${distdir}/trainer/assets/svg" )
		fi
		if [[ -d "${distdir}/trainer/assets/tiff" ]] ; then
			search_path+=( "${distdir}/trainer/assets/tiff" )
		fi
		if [[ -d "${distdir}/trainer/assets/webp" ]] ; then
			search_path+=( "${distdir}/trainer/assets/webp" )
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
		die "Missing at least one ${distdir}/trainer/assets/{apng,bmp,gif,images,jpeg,png,svg,tiff,webp} folder for training"
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
	train_meets_requirements || return
	einfo "Running text compression training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	local N=270 # 30 * 9 compression levels
	if [[ -d "${EPREFIX}/usr/include/linux" ]] ; then
		local c=0
		for f in $(find "${EPREFIX}/usr/include/linux" -type f | shuf) ; do
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
	elif [[ -d "${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include" ]] ; then
		local c=0
		for f in $(find "${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include" -type f | shuf) ; do
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
		die "Missing ${EPREFIX}/usr/include/linux or ${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include for training"
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
	train_meets_requirements || return
	einfo "Running text compression training for ${ABI} for minizip"
	export MINIZIP="minizip"
	export MINIUNZIP="miniunzip"

	# Typical use.
	# Most people compress everything at the same time.
	# This test will simulate compressing an entire folder of files, then
	# it will decompress this single file.
	# It does it 300 times for various directory sizes for about 30
	# times per compression level.
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_TRAINING_MAX_FILES:=500} # arbitrary
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
		if [[ -d "${EPREFIX}/usr/include/linux" ]] ; then
			local c=0
			for f in $(find "${EPREFIX}/usr/include/linux" -type f | shuf) ; do
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
		elif [[ -d "${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include" ]] ; then
			local c=0
			for f in $(find "${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include" -type f | shuf) ; do
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
			die "Missing ${EPREFIX}/usr/include/linux or ${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-version).0/include for training"
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
	train_meets_requirements || return
	einfo "Running binary compression training for ${ABI} for zlib"
	if multilib_is_native_abi ; then
		export PIGZEXE="pigz"
	else
		export PIGZEXE="pigz-${ABI}"
	fi

	#einfo "Preparing training sandbox"
	mkdir -p "${T}/sandbox" || die
	cd "${T}/sandbox" || die
	[[ ! -d "${EPREFIX}/usr/bin/" ]] && die "Missing ${EPREFIX}/usr/bin/ for training"
	# ~391 = 9 compression levels * stats rule of 30 samples [per each level of compression] * 1.45
	# (additional files from weeding out 45% junk files 3/10 to 6/10 is ~45%)
	# Cut short because some files may be gigabytes
	local c=0
	for f in $(find "${EPREFIX}/usr/bin/" -maxdepth 1 -type f | shuf) ; do
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
	train_meets_requirements || return
	einfo "Running binary compression training for ${ABI} for minizip"
	export MINIZIP="minizip"
	export MINIUNZIP="miniunzip"

	[[ ! -d "${EPREFIX}/usr/bin/" ]] && die "Missing ${EPREFIX}/usr/bin/ for training"

	# Binary version:  This test will simulate compressing an entire folder
	# of files, then it will decompress this single file.
	local MAX_FILES_IN_ARCHIVE=${MINIZIP_TRAINING_MAX_FILES:=500} # arbitrary
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

train_trainer_custom() {
	[[ "${lib_type}" == "static" ]] && return # Reuse shared PGO profile
einfo
einfo "Running trainer"
einfo
	export PATH="${S}/contrib/minizip:${PATH_orig}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	if use trainer-zlib-binary-all ; then
		_run_trainer_binary_zlib "all"
	fi
	if use trainer-zlib-binary-default ; then
		_run_trainer_binary_zlib "default"
	fi
	if use trainer-zlib-binary-max ; then
		_run_trainer_binary_zlib "max"
	fi
	if use trainer-zlib-binary-min ; then
		_run_trainer_binary_zlib "min"
	fi
	if use trainer-zlib-binary-random ; then
		_run_trainer_binary_zlib "random"
	fi
	if use trainer-zlib-images-all ; then
		_run_trainer_images_zlib "all"
	fi
	if use trainer-zlib-images-default ; then
		_run_trainer_images_zlib "default"
	fi
	if use trainer-zlib-images-level-8 ; then
		_run_trainer_images_zlib "level-8"
	fi
	if use trainer-zlib-images-max ; then
		_run_trainer_images_zlib "max"
	fi
	if use trainer-zlib-images-min ; then
		_run_trainer_images_zlib "min"
	fi
	if use trainer-zlib-images-random ; then
		_run_trainer_images_zlib "random"
	fi
	if use trainer-zlib-text-all ; then
		_run_trainer_text_zlib "all"
	fi
	if use trainer-zlib-text-default ; then
		_run_trainer_text_zlib "default"
	fi
	if use trainer-zlib-text-max ; then
		_run_trainer_text_zlib "max"
	fi
	if use trainer-zlib-text-min ; then
		_run_trainer_text_zlib "min"
	fi
	if use trainer-zlib-text-random ; then
		_run_trainer_text_zlib "random"
	fi
	if use trainer-minizip-binary-long ; then
		local N=${MINIZIP_TRAINING_LONG_N_ITERATIONS:=300}
		_run_trainer_binary_minizip
	fi
	if use trainer-minizip-binary-max-compression ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		local max_compression=1
		_run_trainer_binary_minizip
		unset max_compression
	fi
	if use trainer-minizip-binary-short ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		_run_trainer_binary_minizip
	fi
	if use trainer-minizip-binary-store ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		local store_only=1
		_run_trainer_binary_minizip
		unset store_only
	fi
	if use trainer-minizip-text-long ; then
		local N=${MINIZIP_TRAINING_LONG_N_ITERATIONS:=300}
		_run_trainer_text_minizip
	fi
	if use trainer-minizip-text-max-compression ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		local max_compression=1
		_run_trainer_text_minizip
		unset max_compression
	fi
	if use trainer-minizip-text-short ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		_run_trainer_text_minizip
	fi
	if use trainer-minizip-text-store ; then
		local N=${MINIZIP_TRAINING_SHORT_N_ITERATIONS:=30}
		local store_only=1
		_run_trainer_text_minizip
		unset store_only
	fi
}

train_meets_requirements() {
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			einfo "ABI=${ABI} lib_type=${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die

			if [[ "${lib_type}" == "static" ]] ; then
				uopts_n_training
			else
				uopts_y_training
			fi

			uopts_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

sed_macros() {
	# clean up namespace a little #383179
	# we do it here so we only have to tweak 2 files
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' "$@" || die
}

_src_pre_train() {
	einfo "Installing ${lib_type} into sandbox for ${ABI}"
	_install
}

_src_post_train() {
	einfo "Wiping sandbox image"
	rm -rf "${ED}" || die
	cd "${S}" || die
}

_src_post_pgo() {
	export PGO_RAN=1
}

_install() {
	case ${CHOST} in
	*-mingw*|mingw*)
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
		[[ "${lib_type}" == "shared" ]] && gen_usr_ldscript -a z
		;;
	esac
	sed_macros "${ED}"/usr/include/*.h

	if use minizip ; then
		einfo "Installing minizip for ${ABI}"
		emake -C "${S}/contrib/minizip" install DESTDIR="${D}"
		sed_macros "${ED}"/usr/include/minizip/*.h
		if use minizip-utils && multilib_is_native_abi ; then
			# Bugs
			mkdir -p "${ED}/usr/bin" || die
			cp -a contrib/minizip/miniunzip \
				"${ED}/usr/bin" || die
			cp -a contrib/minizip/minizip \
				"${ED}/usr/bin" || die
			chmod 0755 "${ED}/usr/bin/minizip" || die
			chmod 0755 "${ED}/usr/bin/miniunzip" || die
		fi
	fi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_install
			uopts_src_install
			if use backup-copy ; then
				local p=$(realpath "${ESYSROOT}/$(get_libdir)/libz.so.1")
				einfo "DEBUG:  p=${p}"
				if [[ -e "${p}" ]] ; then
					einfo "Making backup of ${p}"
					exeinto "/$(get_libdir)"
					local bn=$(basename "${p}")
					newexe "${p}" "${bn}.bak"
				else
					ewarn "No backup made for ${ABI}"
				fi
			fi
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	dodoc FAQ README ChangeLog doc/*.txt
	if use minizip ; then
		dodoc contrib/minizip/*.txt
		doman contrib/minizip/*.1
	fi
	find "${ED}" -type f -name '*.la' -delete || die
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
ewarn "  app-arch/pigz[$(get_arch_enabled_use_flags)]"
ewarn
	fi
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, pgo, cfi-exceptions, install-minizip-bin
