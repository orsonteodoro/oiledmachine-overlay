# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib java-pkg-opt-2
inherit flag-o-matic

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0/0.2"
if [[ "$(ver_cut 3)" -lt 90 ]] ; then
	KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"
fi
IUSE="+asm cpu_flags_arm_neon java static-libs"
IUSE+=" cfi cfi-vcall cfi-cast cfi-icall clang cross-dso-cfi hardened lto shadowcallstack"
IUSE+="
	pgo
	pgo-custom
	pgo-trainer-70-pct-quality-baseline
	pgo-trainer-75-pct-quality-baseline
	pgo-trainer-80-pct-quality-baseline
	pgo-trainer-90-pct-quality-baseline
	pgo-trainer-95-pct-quality-baseline
	pgo-trainer-98-pct-quality-baseline
	pgo-trainer-99-pct-quality-baseline
	pgo-trainer-100-pct-quality-baseline
	pgo-trainer-70-pct-quality-progressive
	pgo-trainer-75-pct-quality-progressive
	pgo-trainer-80-pct-quality-progressive
	pgo-trainer-90-pct-quality-progressive
	pgo-trainer-95-pct-quality-progressive
	pgo-trainer-98-pct-quality-progressive
	pgo-trainer-99-pct-quality-progressive
	pgo-trainer-100-pct-quality-progressive
	pgo-trainer-crop
	pgo-trainer-decode
	pgo-trainer-grayscale
	pgo-trainer-transformations
"
REQUIRED_USE="
	cfi? ( clang lto static-libs )
	cfi-cast? ( clang lto cfi-vcall static-libs )
	cfi-icall? ( clang lto cfi-vcall static-libs )
	cfi-vcall? ( clang lto static-libs )
	cross-dso-cfi? ( clang || ( cfi cfi-cast cfi-icall cfi-vcall ) )
	pgo? (
		pgo-trainer-decode
		|| (
			pgo-custom
			pgo-trainer-70-pct-quality-baseline
			pgo-trainer-75-pct-quality-baseline
			pgo-trainer-80-pct-quality-baseline
			pgo-trainer-90-pct-quality-baseline
			pgo-trainer-95-pct-quality-baseline
			pgo-trainer-98-pct-quality-baseline
			pgo-trainer-99-pct-quality-baseline
			pgo-trainer-100-pct-quality-baseline
			pgo-trainer-70-pct-quality-progressive
			pgo-trainer-75-pct-quality-progressive
			pgo-trainer-80-pct-quality-progressive
			pgo-trainer-90-pct-quality-progressive
			pgo-trainer-95-pct-quality-progressive
			pgo-trainer-98-pct-quality-progressive
			pgo-trainer-99-pct-quality-progressive
			pgo-trainer-100-pct-quality-progressive
			pgo-trainer-crop
			pgo-trainer-decode
			pgo-trainer-grayscale
			pgo-trainer-transformations
		)
	)
	pgo-custom? ( pgo )
	pgo-trainer-70-pct-quality-baseline? ( pgo )
	pgo-trainer-75-pct-quality-baseline? ( pgo )
	pgo-trainer-80-pct-quality-baseline? ( pgo )
	pgo-trainer-90-pct-quality-baseline? ( pgo )
	pgo-trainer-95-pct-quality-baseline? ( pgo )
	pgo-trainer-98-pct-quality-baseline? ( pgo )
	pgo-trainer-99-pct-quality-baseline? ( pgo )
	pgo-trainer-100-pct-quality-baseline? ( pgo )
	pgo-trainer-70-pct-quality-progressive? ( pgo )
	pgo-trainer-75-pct-quality-progressive? ( pgo )
	pgo-trainer-80-pct-quality-progressive? ( pgo )
	pgo-trainer-90-pct-quality-progressive? ( pgo )
	pgo-trainer-95-pct-quality-progressive? ( pgo )
	pgo-trainer-98-pct-quality-progressive? ( pgo )
	pgo-trainer-99-pct-quality-progressive? ( pgo )
	pgo-trainer-100-pct-quality-progressive? ( pgo )
	pgo-trainer-crop? ( pgo )
	pgo-trainer-decode? ( pgo )
	pgo-trainer-grayscale? ( pgo )
	pgo-trainer-transformations? ( pgo )
	shadowcallstack? ( clang )
"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi]
			cross-dso-cfi? ( sys-devel/clang:${v}[${MULTILIB_USEDEP},experimental] )
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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[shadowcallstack?]
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
BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" >=dev-util/cmake-3.16.5
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )"
PDEPEND=" pgo? ( media-video/mpv )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

PATCHES=(
	# Upstream patch
	"${FILESDIR}"/${P}-arm64-relro.patch
)

S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"

is_pgo_ready() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ ! -d "${distdir}/pgo/assets/jpeg" ]] ; then
		return 1
	fi
	if (( $(find "${distdir}/pgo/assets/jpeg" -iname "*.jpg" -o -iname "*.jpeg" | wc -l) == 0 )); then
		return 1
	fi
	return 0
}

pkg_setup() {
	if use pgo && ! is_pgo_ready ; then
		local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
		ewarn
		ewarn "Missing PGO assets.  PGO assets should be placed in ${distdir}/pgo/assets/jpeg"
		ewarn "and relatively the same dimension and quality that you typically USE."
		ewarn
	fi
	if use java ; then
		java-pkg-opt-2_pkg_setup
	fi
	ewarn "Install may fail.  \`emerge -C ${PN}\` then \`emerge -1 =${P}\`."
	ewarn "PGO may randomly fail with CFI.  Disable the pgo USE flag to fix it."
}

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	local FILE
	ln -snf ../debian/extra/*.c . || die

	for FILE in ../debian/extra/*.c; do
		FILE=${FILE##*/}
		cat >> CMakeLists.txt <<EOF || die
add_executable(${FILE%.c} ${FILE})
install(TARGETS ${FILE%.c})
EOF
	done

	for FILE in ../debian/extra/exifautotran; do
		cat >> CMakeLists.txt <<EOF || die
install(FILES \${CMAKE_CURRENT_SOURCE_DIR}/${FILE} DESTINATION \${CMAKE_INSTALL_BINDIR})
EOF
	done

	for FILE in ../debian/extra/*.[0-9]*; do
		cat >> CMakeLists.txt <<EOF || die
install(FILES \${CMAKE_CURRENT_SOURCE_DIR}/${FILE} DESTINATION \${CMAKE_INSTALL_MANDIR}/man${FILE##*.})
EOF
	done

	cmake_src_prepare
	java-pkg-opt-2_src_prepare

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

has_pgo_requirement() {
	return $(is_pgo_ready)
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
	else
		append-flags -flto=auto
		append-ldflags -flto=auto
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

src_configure() { :; }

is_cfi_supported() {
	if [[ "${build_type}" == "static-libs" ]] ; then
		return 0
	elif use cross-dso-cfi && [[ "${build_type}" == "shared-libs" ]] ; then
		return 0
	fi
	return 1
}

_configure_pgx() {
	local mycmakeargs=()
	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		LD="ld.lld"
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'-f*sanitize*' \
		'-f*stack*' \
		'-fprofile*' \
		'-fvisibility=*' \
		'--param=ssp-buffer-size=*' \
		-Wl,-z,noexecstack \
		-Wl,-z,now \
		-Wl,-z,relro

	autofix_flags

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		if tc-is-clang && is_cfi_supported ; then
			if [[ "${USE}" =~ "cfi" && "${build_type}" == "static-libs" ]] ; then
				append_all -fvisibility=hidden
			elif use cross-dso-cfi && [[ "${USE}" =~ "cfi" && "${build_type}" == "shared-libs" ]] ; then
				append_all -fvisibility=default
			fi
			if use cfi ; then
				append_all -fsanitize=cfi
			else
				use cfi-cast && append_all \
							-fsanitize=cfi-derived-cast \
							-fsanitize=cfi-unrelated-cast
				#use cfi-icall && append_all \
				#			-fsanitize=cfi-icall
				use cfi-vcall && append_all \
							-fsanitize=cfi-vcall
			fi
			append_all -fno-sanitize=cfi-icall # breaks precompiled cef based apps
			use cross-dso-cfi \
				&& [[ "${USE}" =~ "cfi" && "${build_type}" == "shared-libs" ]] \
				&& append_all -fsanitize-cfi-cross-dso
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	use hardened && append-ldflags -Wl,-z,noexecstack
	use lto && append_lto
	if is_hardened_gcc ; then
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
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
			else
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector
			fi
			mycmakeargs+=(
				-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS} -pie"
			)
		fi
	fi

	if use static-libs && [[ "${build_type}" == "static-libs" ]] ;then
		mycmakeargs+=(
			-DENABLE_SHARED=OFF
			-DENABLE_STATIC=ON
		)
	else
		mycmakeargs+=(
			-DENABLE_SHARED=ON
			-DENABLE_STATIC=OFF
		)
	fi

	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags -fprofile-generate="${T}/pgo-${ABI}" -Wno-backend-plugin
			if ver_test $(clang-major-version) -ge 11 ; then
				append-flags -mllvm -vp-counters-per-site=8
			fi
		else
			append-flags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${T}/pgo-${ABI}/code.profdata" \
				"${T}/pgo-${ABI}" || die
			append-flags -fprofile-use="${T}/pgo-${ABI}/code.profdata" -Wno-backend-plugin
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
		fi
	fi

	if multilib_is_native_abi && use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	mycmakeargs+=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DWITH_JAVA="$(multilib_native_usex java)"
		-DWITH_MEM_SRCDST=ON
	)

	if ! use asm ; then
		mycmakeargs+=(
			-DWITH_SIMD:BOOL=OFF
		)
	elif use arm; then
		# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON. #792810
		mycmakeargs+=(
			-DWITH_SIMD:BOOL=$(usex cpu_flags_arm_neon ON OFF)
		)
	fi

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

_build_pgx() {
	cmake_src_compile
}

_run_trainers() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export LD_LIBRARY_PATH="${D}/usr/$(get_libdir)"
	local sandbox_path="${T}/sandbox"
	mkdir -p "${sandbox_path}" || die
	local p
	for p in $(find "${distdir}/pgo/assets/jpeg" -iname "*.jpg" -o -iname "*.jpeg") ; do
		local bn=$(basename "${p}")
		local bn_bmp=$(basename "${p}" \
                                | sed -r -e "s|\.jpg|.bmp$|g" -e "s|\.jpeg|.bmp$|"
		)

		if use pgo-trainer-decode ; then
			einfo "Decoding image jpeg -> bmp"
			djpeg -verbose "${p}" > "${sandbox_path}/${bn_bmp}" || die
		fi

		for pct in 70 75 80 90 95 98 99 100 ; do
			if use "pgo-trainer-${pct}-pct-quality-baseline" ; then
				einfo "Encoding image bmp -> baseline jpeg with ${pct}% quality"
				cjpeg -verbose -quality ${pct} "${sandbox_path}/${bn_bmp}" > "${sandbox_path}/t-${bn}" || die
				einfo "Decoding image baseline jpeg with ${pct}% (default) -> bmp"
				djpeg -verbose "${sandbox_path}/t-${bn}" > "${sandbox_path}/t-${bn_bmp}" || die
			fi
			if use "pgo-trainer-${pct}-pct-quality-progressive" ; then
				einfo "Encoding image bmp -> progressive jpeg with ${pct}% quality"
				cjpeg -verbose -progressive -quality ${pct} "${sandbox_path}/${bn_bmp}" > "${sandbox_path}/t-${bn}" || die
				einfo "Decoding image progressive jpeg with ${pct}% (default) -> bmp"
				djpeg -verbose "${sandbox_path}/t-${bn}" > "${sandbox_path}/t-${bn_bmp}" || die
				einfo "Encoding image bmp -> optimized progressive jpeg with ${pct}% quality"
				cjpeg -verbose -optimize -progressive -quality ${pct} "${sandbox_path}/${bn_bmp}" > "${sandbox_path}/t-${bn}" || die
				einfo "Decoding image optimized progressive jpeg with ${pct}% (default) -> bmp"
				djpeg -verbose "${sandbox_path}/t-${bn}" > "${sandbox_path}/t-${bn_bmp}" || die
			fi
		done

		if use pgo-trainer-transformations ; then
			einfo "Flipping horizontal"
			jpegtran -verbose -flip horizontal "${p}" > "${sandbox_path}/${bn}" || die
			einfo "Flipping vertical"
			jpegtran -verbose -flip vertical "${p}" > "${sandbox_path}/${bn}" || die
			einfo "Rotating clockwise by 90 deg 4 times"
			cp -a $(realpath "${p}") "${sandbox_path}/${bn}" || die
			for t in $(seq 4) ; do
				jpegtran -verbose -rotate 90 "${sandbox_path}/${bn}" > "${sandbox_path}/t-${bn}" || die
				mv "${sandbox_path}/t-${bn}" "${sandbox_path}/${bn}" || die
			done
			einfo "Rotating counterclockwise by 90 deg 4 times"
			# No direct way, but done this way
			cp -a $(realpath "${p}") "${sandbox_path}/${bn}" || die
			for t in $(seq 4) ; do
				jpegtran -verbose -rotate 90 "${sandbox_path}/${bn}" > "${sandbox_path}/t-${bn}" || die
				mv "${sandbox_path}/t-${bn}" "${sandbox_path}/${bn}" || die
				jpegtran -verbose -flip vertical "${sandbox_path}/${bn}" > "${sandbox_path}/t-${bn}" || die
				mv "${sandbox_path}/t-${bn}" "${sandbox_path}/${bn}" || die
				jpegtran -verbose -flip horizontal "${sandbox_path}/${bn}" > "${sandbox_path}/t-${bn}" || die
				mv "${sandbox_path}/t-${bn}" "${sandbox_path}/${bn}" || die
			done
		fi
		if use pgo-trainer-grayscale ; then
			einfo "Converting to grayscale"
			jpegtran -verbose -grayscale "${p}" > "${sandbox_path}/${bn}" || die
		fi

		if use pgo-trainer-crop ; then
			cp -a "${p}" "${sandbox_path}/orig-${bn}" || die

			local w=$(jpegtran -flip horizontal -verbose "${sandbox_path}/orig-${bn}" 2>&1 \
				> /dev/null | grep "Start Of Frame" | grep -E -o -e "width=[0-9]+" \
				| sed -e "s|width=||g")
			local h=$(jpegtran -flip horizontal -verbose "${sandbox_path}/orig-${bn}" 2>&1 \
				> /dev/null | grep "Start Of Frame" | grep -E -o -e "height=[0-9]+" \
				| sed -e "s|height=||g")

			for i in $(seq 60) ; do # 60 is the sample size
				local cx1=$((${RANDOM} % (${w} * 95 / 100)))
				local cx2=${w}
				local pct5x=$((${w} * 5 / 100)) # Assumes 5% is minimal or interesting
				local pct5y=$((${h} * 5 / 100))
				while (( ${cx2} < ${cx1} && (${cx1} + ${cx2}) < ${pct5x} && ${cx1} + ${cx2} > ${w})) ; do
					cx2=$((${RANDOM} % (${w} * 95 / 100)))
				done
				local cy1=$((${RANDOM} % (${h} * 95 / 100)))
				local cy2=${h}
				while (( ${cy2} < ${cy1} && (${cy1} + ${cy2}) < ${pct5y} && ${cy1} + ${cy2} > ${h})) ; do
					cy2=$((${RANDOM} % (${h} * 95 / 100)))
				done
				local cw=$((${cx2} - ${cx1}))
				local ch=$((${cy2} - ${cy1}))
				(( ${cx1} + ${cw} > ${w} )) && die "Formula is out of bounds cx1=${cx1} + cw=${cw} > ${w}"
				(( ${cy1} + ${ch} > ${h} )) && die "Formula is out of bounds cy1=${cy1} + ch=${ch} > ${h}"
				einfo "Cropping a ${w}x${h} image at x=${cx1} y=${cy1} w=${cw} h=${ch}"
				jpegtran -verbose -crop \
					${cw}x${ch}+${cx1}+${cy1} \
					"${p}" > "${sandbox_path}/t-${bn}" || die
			done
		fi

		if use pgo-custom ; then
			chmod +x "${S}/custom.sh" || die
			./custom.sh || die
		fi
	done
	rm -rf "${sandbox_path}" || die
}

src_compile() {
	export PATH="${D}/usr/bin:${PATH}"
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
						&& ewarn "Reusing PGO data from shared-libs"
				else
					ewarn "No PGO data found.  Skipping PGO build and building normally."
					unset PGO_PHASE
				fi
				_configure_pgx
				_build_pgx
				export PGO_RAN=1
			else
				einfo "Skipping PGO training for ${ABI}"
				_configure_pgx
				_build_pgx
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

_install_pgx() {
	einfo "Installing image into sandbox staging area"
	_install
}

_clean_pgx() {
	einfo "Resetting sandbox staging area"
	cd "${S}" || die
	rm -rf "${ED}" || die
}

_install() {
	cmake_src_install

	if multilib_is_native_abi && use java ; then
		rm -rf "${ED}"/usr/classes || die
		java-pkg_dojar java/turbojpeg.jar
	fi
}

_install_once() {
	cd "${S}" || die
	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

	newdoc "${WORKDIR}"/debian/changelog changelog.debian

	docinto html
	dodoc -r "${S}"/doc/html/.

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/.
		newdoc "${S}"/java/README README.java
	fi
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
	_install_once
	# This is to save register cache space (compared to -frecord-command-line) and
	# for auto lib categorization with -Wl,-Bstatic.
	# The "CFI Canonical Jump Tables" only emits when cfi-icall and not a good
	# way to check for CFI presence.
	if [[ "${USE}" =~ "cfi" ]] ; then
		local arg=()
		use cross-dso-cfi && arg+=( -o -name "*.so*" )
		for f in $(find "${ED}" -name "*.a" ${arg[@]}) ; do
			if use cfi ; then
				touch "${f}.cfi" || die
			else
				use cfi-cast && ( touch "${f}.cfi" || die )
				use cfi-icall && ( touch "${f}.cfi" || die )
				use cfi-vcall && ( touch "${f}.cfi" || die )
			fi
		done
	fi
}

pkg_postinst() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
elog "No PGO optimization performed.  Please re-emerge this package."
elog "The following package must be installed before PGOing this package:"
elog "  jpeg assets placed in ${distdir}/pgo/assets/jpeg"
	fi
	if [[ "${USE}" =~ "cfi" ]] ; then
# https://clang.llvm.org/docs/ControlFlowIntegrityDesign.html#shared-library-support
ewarn
ewarn "Cross-DSO CFI is experimental."
ewarn
ewarn "You must link these libraries with static linkage for plain CFI to work."
ewarn
	fi
}
