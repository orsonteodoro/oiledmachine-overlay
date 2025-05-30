# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="nasm inline yasm"
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18"
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DOS HO IO NPD OOBR SO UM"
CMAKE_ECLASS="cmake"
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/jconfig.h"
)
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
UOPTS_BOLT_INST_ARGS=(
	"libjpeg.so.62.3.0:--skip-funcs=.text/1"
	"libturbojpeg.so.0.2.0:--skip-funcs=.text/1"
)

inherit cflags-hardened cmake-multilib java-pkg-opt-2 flag-o-matic
inherit flag-o-matic-om toolchain-funcs uopts

# Unkeyworded for test failures: https://github.com/libjpeg-turbo/libjpeg-turbo/issues/705
if [[ $(ver_cut 3) -lt "90" ]] ; then
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris
	"
fi
S="${WORKDIR}/${P}"
SRC_URI="
	https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/${PV}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz
"

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="
	https://libjpeg-turbo.org/
	https://github.com/libjpeg-turbo/libjpeg-turbo
"
LICENSE="
	BSD
	IJG
	ZLIB
	java? (
		GPL-2-with-classpath-exception
	)
"
SLOT="0/0.2"
IUSE="
+asm cpu_flags_arm_neon java
libjpeg_turbo_trainers_70_pct_quality_baseline
libjpeg_turbo_trainers_75_pct_quality_baseline
libjpeg_turbo_trainers_80_pct_quality_baseline
libjpeg_turbo_trainers_90_pct_quality_baseline
libjpeg_turbo_trainers_95_pct_quality_baseline
libjpeg_turbo_trainers_98_pct_quality_baseline
libjpeg_turbo_trainers_99_pct_quality_baseline
libjpeg_turbo_trainers_100_pct_quality_baseline
libjpeg_turbo_trainers_70_pct_quality_progressive
libjpeg_turbo_trainers_75_pct_quality_progressive
libjpeg_turbo_trainers_80_pct_quality_progressive
libjpeg_turbo_trainers_90_pct_quality_progressive
libjpeg_turbo_trainers_95_pct_quality_progressive
libjpeg_turbo_trainers_98_pct_quality_progressive
libjpeg_turbo_trainers_99_pct_quality_progressive
libjpeg_turbo_trainers_100_pct_quality_progressive
libjpeg_turbo_trainers_crop
libjpeg_turbo_trainers_decode
libjpeg_turbo_trainers_grayscale
libjpeg_turbo_trainers_transformations
pgo static-libs
ebuild_revision_24
"
REQUIRED_USE="
	pgo? (
		libjpeg_turbo_trainers_decode
		|| (
			libjpeg_turbo_trainers_70_pct_quality_baseline
			libjpeg_turbo_trainers_75_pct_quality_baseline
			libjpeg_turbo_trainers_80_pct_quality_baseline
			libjpeg_turbo_trainers_90_pct_quality_baseline
			libjpeg_turbo_trainers_95_pct_quality_baseline
			libjpeg_turbo_trainers_98_pct_quality_baseline
			libjpeg_turbo_trainers_99_pct_quality_baseline
			libjpeg_turbo_trainers_100_pct_quality_baseline
			libjpeg_turbo_trainers_70_pct_quality_progressive
			libjpeg_turbo_trainers_75_pct_quality_progressive
			libjpeg_turbo_trainers_80_pct_quality_progressive
			libjpeg_turbo_trainers_90_pct_quality_progressive
			libjpeg_turbo_trainers_95_pct_quality_progressive
			libjpeg_turbo_trainers_98_pct_quality_progressive
			libjpeg_turbo_trainers_99_pct_quality_progressive
			libjpeg_turbo_trainers_100_pct_quality_progressive
			libjpeg_turbo_trainers_crop
			libjpeg_turbo_trainers_decode
			libjpeg_turbo_trainers_grayscale
			libjpeg_turbo_trainers_transformations
		)
	)
	libjpeg_turbo_trainers_70_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_75_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_80_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_90_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_95_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_98_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_99_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_100_pct_quality_baseline? (
		pgo
	)
	libjpeg_turbo_trainers_70_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_75_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_80_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_90_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_95_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_98_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_99_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_100_pct_quality_progressive? (
		pgo
	)
	libjpeg_turbo_trainers_crop? (
		pgo
	)
	libjpeg_turbo_trainers_decode? (
		pgo
	)
	libjpeg_turbo_trainers_grayscale? (
		pgo
	)
	libjpeg_turbo_trainers_transformations? (
		pgo
	)
"
ASM_DEPEND="
	|| (
		dev-lang/nasm
		dev-lang/yasm
	)
"
COMMON_DEPEND="
	!media-libs/jpeg:0
	!media-libs/jpeg:62
"
BDEPEND+="
	>=dev-build/cmake-3.16.5
	amd64? (
		${ASM_DEPEND}
	)
	amd64-linux? (
		${ASM_DEPEND}
	)
	x86? (
		${ASM_DEPEND}
	)
	x86-linux? (
		${ASM_DEPEND}
	)
	x64-macos? (
		${ASM_DEPEND}
	)
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		>=virtual/jdk-1.8:*[-headless-awt]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	java? (
		>=virtual/jre-1.8:*
	)
"
PDEPEND="
	pgo? (
		media-video/mpv
	)
"

# The order does matter with PGO.
get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

is_pgo_ready() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ ! -d "${distdir}/trainer/assets/jpeg" ]] ; then
		return 1
	fi

	local n_assets=$(\
		find \
			"${distdir}/trainer/assets/jpeg" \
			\( \
				   -iname "*.jpg" \
				-o -iname "*.jpeg" \
			\) \
		| wc -l \
	)
	if (( ${n_assets} == 0 )); then
		return 1
	fi
	return 0
}

pkg_setup() {
ewarn "Use GCC 12 if build fails for =${CATEGORY}/${PN}-${PVR}."
	if use pgo && ! is_pgo_ready ; then
		local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
ewarn
ewarn "Missing PGO assets.  PGO assets should be placed in"
ewarn "${distdir}/trainer/assets/jpeg and relatively the same dimension and"
ewarn "quality that you typically USE."
ewarn
	fi
	java-pkg-opt-2_pkg_setup
ewarn
ewarn "Install may fail.  \`emerge -C ${PN}\` then \`emerge -1 =${P}\`."
ewarn "PGO may randomly fail with CFI.  Disable the pgo USE flag to fix it."
ewarn
	uopts_setup
}

src_prepare() {
	local FILE
	ln -snf ../debian/extra/*.c . || die

	for FILE in ../debian/extra/*.c; do
		FILE=${FILE##*/}
cat >> CMakeLists.txt <<-EOF || die
add_executable(${FILE%.c} ${FILE})
install(TARGETS ${FILE%.c})
EOF
	done

	cmake_src_prepare
	java-pkg-opt-2_src_prepare

	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

trainer_meets_requirements() {
	return $(is_pgo_ready)
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

src_configure() { :; }

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

_src_configure() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cd "${CMAKE_USE_DIR}" || die
	local mycmakeargs=()

	strip-flag-value "cfi-icall"
	if tc-is-clang && has_version "llvm-runtimes/compiler-rt-sanitizers[cfi]" ; then
		append_all -fno-sanitize=cfi-icall # breaks precompiled cef based apps
	fi
	cflags-hardened_append

	if use static-libs && [[ "${lib_type}" == "static" ]] ;then
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

	uopts_src_configure
	if use pgo && tc-is-clang ; then
		append-flags $(test-flags -Wno-backend-plugin)
		if [[ "${PGO_PHASE}" == "PGI" ]] ; then
			if ver_test $(clang-major-version) -ge 11 ; then
				append-flags -mllvm -vp-counters-per-site=8
			fi
		fi
	fi

	if multilib_is_native_abi && use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	mycmakeargs+=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DWITH_JAVA="$(multilib_native_usex java)"
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

	# We should tell the test suite which floating-point flavor we are
	# expecting: https://github.com/libjpeg-turbo/libjpeg-turbo/issues/597
	# For now, mark loong as fp-contract.
	if use loong; then
		mycmakeargs+=(
			-DFLOATTEST=fp-contract
		)
	fi

	# Mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

_src_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
	cmake_src_compile
}

train_trainer_custom() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	local sandbox_path="${T}/sandbox"
	mkdir -p "${sandbox_path}" || die
	local p
	for p in $(find "${distdir}/trainer/assets/jpeg" \( -iname "*.jpg" -o -iname "*.jpeg" \)) ; do
		local bn=$(basename "${p}")
		local bn_bmp=$(basename "${p}" \
                                | sed -r -e "s|\.jpg|.bmp$|g" -e "s|\.jpeg|.bmp$|"
		)

		if use libjpeg_turbo_trainers_decode ; then
			einfo "Decoding image jpeg -> bmp"
			djpeg -verbose "${p}" > "${sandbox_path}/${bn_bmp}" || die
		fi

		for pct in 70 75 80 90 95 98 99 100 ; do
			if use "libjpeg_turbo_trainers_${pct}_pct_quality_baseline" ; then
				einfo "Encoding image bmp -> baseline jpeg with ${pct}% quality"
				cjpeg -verbose -quality ${pct} "${sandbox_path}/${bn_bmp}" > "${sandbox_path}/t-${bn}" || die
				einfo "Decoding image baseline jpeg with ${pct}% (default) -> bmp"
				djpeg -verbose "${sandbox_path}/t-${bn}" > "${sandbox_path}/t-${bn_bmp}" || die
			fi
			if use "libjpeg_turbo_trainers_${pct}_pct_quality_progressive" ; then
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

		if use libjpeg_turbo_trainers_transformations ; then
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
		if use libjpeg_turbo_trainers_grayscale ; then
			einfo "Converting to grayscale"
			jpegtran -verbose -grayscale "${p}" > "${sandbox_path}/${bn}" || die
		fi

		if use libjpeg_turbo_trainers_crop ; then
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
	done
	rm -rf "${sandbox_path}" || die
}

_src_pre_train() {
	einfo "Installing image into sandbox staging area"
	_install
}

_src_post_train() {
	einfo "Resetting sandbox staging area"
	rm -rf "${ED}" || die
}

_src_post_pgo() {
	export PGO_RAN=1
}

src_compile() {
	export PATH="${ED}/usr/bin:${PATH}"
	compile_abi() {
		local lib_type
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
}

_install() {
	cmake_src_install

	if multilib_is_native_abi && use java ; then
		rm -rf "${ED}"/usr/classes || die
		java-pkg_dojar java/turbojpeg.jar
	fi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			_install
			uopts_src_install
		done
		multilib_prepare_wrappers
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_install_wrappers
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

	newdoc "${WORKDIR}"/debian/changelog changelog.debian
	dobin "${WORKDIR}"/debian/extra/exifautotran
	doman "${WORKDIR}"/debian/extra/*.[0-9]*

	docinto html
	dodoc -r "${S}"/doc/html/.

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/.
		newdoc "${S}"/java/README README.java
	fi
}

pkg_postinst() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
ewarn
ewarn "No PGO optimization performed.  Please re-emerge this package."
ewarn
ewarn "The following package must be installed before PGOing this package:"
ewarn
ewarn "  jpeg assets placed in ${distdir}/trainer/assets/jpeg"
ewarn
	fi
	uopts_pkg_postinst
}
