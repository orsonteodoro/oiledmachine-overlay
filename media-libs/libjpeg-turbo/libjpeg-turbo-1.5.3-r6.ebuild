# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools java-pkg-opt-2 toolchain-funcs multilib-minimal
inherit flag-o-matic

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0/0.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+asm java static-libs"
IUSE+=" cfi cfi-vcall cfi-cast cfi-icall clang full-relro lto noexecstack shadowcallstack ssp"
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
BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.5 )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.5 )"
PDEPEND=" pgo? ( media-video/mpv )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-x32.patch #420239
	"${FILESDIR}"/${P}-divzero_fix.patch #658624
	"${FILESDIR}"/${P}-cve-2018-11813.patch
	"${FILESDIR}"/${P}-CVE-2020-13790.patch
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
}

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	default

	eautoreconf

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

src_configure() { :; }

_configure_pgx() {
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

	autofix_flags

	use lto && append_lto
	use noexecstack && append-ldflags -Wl,-z,noexecstack
	if tc-is-gcc && gcc --version | grep -q -e "Hardened" ; then
		:;
	else
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
		if tc-is-clang && clang --version | grep -q -e "Hardened:" ; then
			# Already done by hardened clang
			:;
		else
			use full-relro && append-ldflags -Wl,-z,relro -Wl,-z,now
			use ssp && append-ldflags --param=ssp-buffer-size=4 \
						-fstack-protector
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	fi

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

	local myconf=()
	if multilib_is_native_abi; then
		myconf+=( $(use_with java) )
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
		fi
	else
		myconf+=( --without-java )
	fi
	[[ ${ABI} == "x32" ]] && myconf+=( --without-simd ) #420239

	# Force /bin/bash until upstream generates a new version. #533902
	CONFIG_SHELL="${EPREFIX}"/bin/bash \
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(use_with asm simd) \
		--with-mem-srcdst \
		"${myconf[@]}"
}

_build_pgx() {
	local _java_makeopts
	use java && _java_makeopts="-j1"
	emake ${_java_makeopts}

	if multilib_is_native_abi; then
		pushd ../debian/extra >/dev/null
		emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
		popd >/dev/null
	fi
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

src_test() {
	emake test
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
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		exampledir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if multilib_is_native_abi; then
		pushd "${WORKDIR}"/debian/extra >/dev/null
		emake \
			DESTDIR="${D}" prefix="${EPREFIX}"/usr \
			INSTALL="install -m755" INSTALLDIR="install -d -m755" \
			install
		popd >/dev/null

		if use java; then
			rm -rf "${ED}"/usr/classes
			java-pkg_dojar java/turbojpeg.jar
		fi
	fi
}

_install_once() {
	cd "${S}" || die
	find "${ED}" -type f -name '*.la' -delete || die

	docinto html
	dodoc -r "${S}"/doc/html/*
	newdoc "${WORKDIR}"/debian/changelog changelog.debian
	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/*
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
}

pkg_postinst() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if use pgo && [[ -z "${PGO_RAN}" ]] ; then
elog "No PGO optimization performed.  Please re-emerge this package."
elog "The following package must be installed before PGOing this package:"
elog "  jpeg assets placed in ${distdir}/pgo/assets/jpeg"
	fi
	if [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "cfi, cfi-cast, cfi-icall, cfi-vcall require static linking of this"
ewarn "library."
ewarn
ewarn "If you do ldd and you still see libjpeg.so libturbojpeg.so, then it"
ewarn "breaks the CFI runtime protection spec as if that scheme of CFI was"
ewarn "never used.  For details, see"
ewarn "https://clang.llvm.org/docs/ControlFlowIntegrity.html"
ewarn "with \"statically linked\" keyword search."
ewarn
	fi
}
