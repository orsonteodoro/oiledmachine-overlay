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
MEDIA_WIKI_VERSION=1.36.1
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="minizip static-libs"
IUSE+=" cfi cfi-vcall cfi-cast cfi-icall full-relro lto noexecstack shadowcallstack ssp"
IUSE+="
	pgo
	pgo-custom
	pgo-trainer-binary
	pgo-trainer-text
"
REQUIRED_USE="
	cfi? ( lto static-libs )
	cfi-cast? ( lto cfi-vcall static-libs )
	cfi-icall? ( lto cfi-vcall static-libs )
	cfi-vcall? ( lto static-libs )
	pgo-custom? ( pgo )
	pgo-trainer-binary? ( pgo )
	pgo-trainer-text? ( pgo )
"
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"
PDEPEND="pgo? ( app-arch/pigz )"

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

BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" lto? ( || ( $(gen_lto_bdepend 11 14) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" minizip? ( ${AUTOTOOLS_DEPEND} )"
# See #309623 for libxml2
RDEPEND+="
	!<dev-libs/libxml2-2.7.7
	!sys-libs/zlib-ng[compat]
"
DEPEND+="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-fix-deflateParams-usage.patch
	"${FILESDIR}"/${PN}-1.2.11-minizip-drop-crypt-header.patch #658536
)

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
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
	append-flags -flto=thin -fuse-ld=lld
	append-ldflags -fuse-ld=lld -flto=thin
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
	if use lto || use shadowcallstack ; then
		export CC="clang $(get_abi_CFLAGS ${ABI})"
		export CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		export AR=llvm-ar
		export AS=llvm-as
		export NM=llvm-nm
		export RANLIB=llvm-ranlib
		export READELF=llvm-readelf
		export LD="ld.lld"
	fi

	filter-flags \
		'-fprofile-correction' \
		'-fprofile-dir*' \
		'-fprofile-generate*' \
		'-fprofile-use*'

	filter-flags \
		'-fsanitize=*' \
		'-fvisibility=hidden' \
		--param=ssp-buffer-size=4 \
		-fno-sanitize=safe-stack \
		-fstack-protector \
		-Wl,-z,noexecstack \
		-Wl,-z,now \
		-Wl,-z,relro \
		-stdlib=libc++

	if tc-is-clang ; then
		filter-flags -fprefetch-loop-arrays \
			'-fopt-info*' \
			-frename-registers
	fi

	if [[ "${build_type}" == "static-libs" ]] ; then
		if use cfi ; then
			append_all -fvisibility=hidden \
					-fsanitize=cfi
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
	use lto && append_lto
	use full-relro && append-ldflags -Wl,-z,relro -Wl,-z,now
	use noexecstack && append-ldflags -Wl,-z,noexecstack
	use shadowcallstack && append-flags -fno-sanitize=safe-stack \
					-fsanitize=shadow-call-stack
	use ssp && append-ldflags --param=ssp-buffer-size=4 \
				-fstack-protector

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
		emake -C contrib/minizip libminizip.la
	fi
}

run_trainer_text() {
	einfo "Running test compression PGO training for ${ABI}"
	if has_pgo_requirement ; then
		if multilib_is_native_abi ; then
			export PIGZEXE="pigz"
		else
			export PIGZEXE="pigz-${ABI}"
		fi

		einfo "Preparing training sandbox"
		mkdir -p "${T}/sandbox" || die
		if [[ -d /usr/include/linux ]] ; then
			local c=0
			for f in $(find /usr/include/linux -type f) ; do
				if [[ -f "${f}" && ! -L "${f}" ]] ; then
					einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || die
					c=$(( ${c} + 1 ))
				else
					einfo "Skipping ${f} which may not be a text file but a symlink"
				fi
				(( ${c} >= 270 )) && break # 30 * 9 compression levels
			done
			rm -rf "${T}/sandbox-headers" || die
		elif [[ -d /usr/lib/gcc/${CHOST}/$(gcc-version).0/include ]] ; then
			local c=0
			for f in $(find /usr/lib/gcc/${CHOST}/$(gcc-version).0/include -type f | head -n 1000) ; do
				if [[ -f "${f}" && ! -L "${f}" ]] ; then
					einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || die
					c=$(( ${c} + 1 ))
				else
					einfo "Skipping ${f} which may not be a text file but a symlink"
				fi
				(( ${c} >= 270 )) && break # 30 * 9 compression levels
			done
		else
			die "Missing /usr/include/linux or /usr/lib/gcc/${CHOST}/$(gcc-version).0/include for PGO training"
		fi
		einfo "Compression training"
		for f in $(find "${T}/sandbox" -type f) ; do
			local cmd=( "${PIGZEXE}" -z -$(($((${RANDOM} % 9)) + 1)) "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		einfo "Decompression training"
		for f in $(find "${T}/sandbox" -type f) ; do
			local cmd=( "${PIGZEXE}" -d "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		einfo "Clearing sandbox"
		rm -rf "${T}/sandbox" || die
	fi
}

run_trainer_binary() {
	einfo "Running binary compression PGO training for ${ABI}"
	if has_pgo_requirement ; then
		if multilib_is_native_abi ; then
			export PIGZEXE="pigz"
		else
			export PIGZEXE="pigz-${ABI}"
		fi

		einfo "Preparing training sandbox"
		mkdir -p "${T}/sandbox" || die
		[[ ! -d /usr/bin/ ]] && die "missing /usr/bin/ for PGO training"
		# ~391 = 9 compression levels * stats rule of 30 samples [per each level of compression] * 1.45
		# (additional files from weeding out 45% junk files 3/10 to 6/10 is ~45%)
		# Cut short because some files may be gigabytes
		local c=0
		for f in $(find /usr/bin/ -maxdepth 1 -type f | sort | head -n 391 ) ; do
			if readelf -h "${f}" 2>/dev/null 1>/dev/null && [[ ! -L "${f}" ]] ; then
				local filesize=$(stat -c "%s" "${f}")
				if (( ${filesize} < 26214400 )) ; then
					# Limit to 25 MiB to prevent compression of gigs of data.
					einfo "Adding ${f} to the compression sandbox"
					cp -a "${f}" "${T}/sandbox" || echo "Skipping ${f}"
					c=$(( ${c} + 1 ))
				else
					einfo "Skipping large data"
				fi
			else
				einfo "Skipping possible text file or symlink ${f}"
			fi
			(( ${c} >= 270 )) && break # 30 * 9 compression levels
		done
		einfo "Compression training"
		for f in $(find "${T}/sandbox" -type f) ; do
			local cmd=( "${PIGZEXE}" -z -$(($((${RANDOM} % 9)) + 1)) "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		einfo "Decompression training"
		for f in $(find "${T}/sandbox" -type f) ; do
			local cmd=( "${PIGZEXE}" -d "${f}" )
			einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
			"${cmd[@]}" || die
		done
		einfo "Clearing sandbox"
		rm -rf "${T}/sandbox" || die
	fi
}

run_trainer_web_wiki() {
	# Closer to typical use
	mkdir -p "${T}/sandbox" || die
	einfo "Downloading Gentoo Wiki Handbook AMD64 (Credits CC-BY-SA-3.0 © 2001–2021 Gentoo Foundation, Inc.)"
	cd "${T}/sandbox" || die
	wget -r -l2 "https://wiki.gentoo.org/wiki/Handbook:AMD64"
	einfo "Compression training"
	for f in $(find "${T}/sandbox" -type f) ; do
		local cmd=( "${PIGZEXE}" -z -$(($((${RANDOM} % 9)) + 1)) "${f}" )
		einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
		"${cmd[@]}" || die
	done
	einfo "Decompression training"
	for f in $(find "${T}/sandbox" -type f) ; do
		local cmd=( "${PIGZEXE}" -d "${f}" )
		einfo "Running: PATH=\"${PATH}\" LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\" ${cmd[@]}"
		"${cmd[@]}" || die
	done
	einfo "Clearing sandbox"
	rm -rf "${T}/sandbox"
}

run_trainer_custom() {
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
	export PATH="${ED}/usr/bin:${PATH}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	if use pgo-trainer-text ; then
		run_trainer_text
	fi
	if use pgo-trainer-binary ; then
		run_trainer_binary
	fi
	if use pgo-custom ; then
		run_trainer_custom
	fi
}

has_pgo_requirement() {
	if which pigz-${ABI} 2>/dev/null 1>/dev/null ; then
		return 0
	return
		return 1
	fi
}

src_compile() {
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
				if (( $(find "${T}/pgo-${ABI}" 2>/dev/null | wc -l) > 0 )) ; then
					PGO_PHASE="pgo"
					[[ "${build_type}" == "static-libs" ]] \
						&& ewarn "Reusing PGO data from static-libs"
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
}
