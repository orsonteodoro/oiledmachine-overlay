# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

SETIATHOME_VERSION="$(get_version_component_range 1-2 ${PV})"
SETIATHOME_SVN_REVISION="$(get_version_component_range 3 ${PV})" # versioning based on the latest revision for https://setisvn.ssl.berkeley.edu/trac/browser/seti_boinc folder
MY_P="setiathome-cpu-${SETIATHOME_VERSION}"
DESCRIPTION="Seti@Home"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="$(get_major_version)"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

X86_CPU_FEATURES_RAW=( avx sse3 sse2 sse mmx 3dnow )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
IUSE="${X86_CPU_FEATURES[@]%:*} opengl custom-cflags altivec neon pgo"
REQUIRED_USE=""

RDEPEND="
	sci-libs/fftw:=[static-libs]
	sci-misc/setiathome-art:7
"

SLOT_BOINC="7.14"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.67
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:${SLOT_BOINC}
	sci-misc/setiathome-updater:8
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [ ! -f /usr/share/boinc/${SLOT_BOINC}/config.h ] ; then
		eerror "You need the boinc from the oiledmachine-overlay"
		die
	fi

	if $(tc-is-clang) ; then
		ewarn "The configure script may fail with clang.  Switch to gcc if it fails."
	fi

	export BOINC_VER=`boinc --version | awk '{print $1}'`
}

src_unpack() {
	ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/seti_boinc"
	ESVN_REVISION="${SETIATHOME_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
	subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/seti_boinc" "${WORKDIR}/${MY_P}/AKv8" || die
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps" || die
}

src_prepare() {
	cd "${WORKDIR}/${MY_P}"
	eapply "${FILESDIR}"/setiathome-7.09-configureac.patch
	eapply "${FILESDIR}"/setiathome-8.00.3701-nopackagever.patch
	eapply "${FILESDIR}"/setiathome-cpu-8.00.3473-concat-custom-string-fix.patch

	PACKAGE_VERSION=$(grep -r -e "PACKAGE_VERSION" ./sah_config.h | cut -d' ' -f3 | sed -e "s|\"||g")
	sed -i -e "s|__PACKAGE_VERSION__|$PACKAGE_VERSION|g" AKv8/client/analyzeFuncs.cpp || die

	if $(version_is_at_least "7.3.19" $BOINC_VER ) ; then
		true
	else
		eapply "${FILESDIR}/setiathome-cpu-8.00.3473-boinc-compat.patch"
	fi

	eapply "${FILESDIR}"/setiathome-8.00.3979-cxx11-isnan.patch

	eapply_user

	cd "${WORKDIR}/${MY_P}/AKv8"
	AT_M4DIR="m4" eautoreconf
	chmod +x configure || die
}

src_configure() {
        append-flags -Wa,--noexecstack
	#conf run in src_compile
}

function run_config {
	local -a mycommonmakeargs
	local -a mycommonmakedefargs

	local -a mysahmakeargs
	local -a mysahmakedefargs

	local -a sahfftwlibs

        append-flags -Wa,--noexecstack

	if [[ ${ARCH} =~ (amd64|ia64|arm64|ppc64|alpha) || ${host} =~ (sparc64) ]]; then
		mysahmakeargs+=( --enable-bitness=64 )
		sahfftwlibs=( -L/usr/lib64 )
	elif [[ ${ARCH} =~ (x86|i386|arm|ppc|m68k|s390|hppa) || ${host} =~ (sparc) ]] ; then
		mysahmakeargs+=( --enable-bitness=32 )
		sahfftwlibs=( -L/usr/lib32 )
	else
		warn "ARCH is not supported.  Continuing anyway..."
		sahfftwlibs=( -L/usr/lib )
	fi

	mycommonmakeargs+=( --disable-server )
	mycommonmakeargs+=( --enable-client )
	mycommonmakeargs+=( --disable-static-client )
	#mycommonmakeargs+=( --disable-intrinsics ) #enabling breaks compile

	mycommonmakedefargs+=( -D_GNU_SOURCE )

	if use opengl ; then
		mycommonmakedefargs+=( -DBOINC_APP_GRAPHICS )
		mycommonmakeargs+=( --enable-graphics )
                mycommonmakedefargs+=( -DHAVE_GL_GL_H )
                mycommonmakedefargs+=( -DHAVE_GL_GLU_H )
                mycommonmakedefargs+=( -DHAVE_GL_GLUT_H )
	else
		mycommonmakeargs+=( --disable-graphics )
	fi

	mysahmakedefargs+=( -DSETI7 )

	sahfftwlibs+=( -lfftw3f )
	mysahmakedefargs+=( -DUSE_FFTW )

	if use custom-cflags ; then
		true
	else
		strip-flags
		filter-flags -O3 -O2 -O1 -Os -Ofast -O4
	fi

	if use cpu_flags_x86_avx ; then
		mycommonmakeargs+=( --enable-avx )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_sse3 ; then
		mycommonmakeargs+=( --enable-sse3 )
		mycommonmakedefargs+=( -DUSE_SSE3 )
	elif use cpu_flags_x86_sse2 ; then
		mycommonmakeargs+=( --enable-sse2 )
		mycommonmakedefargs+=( -DUSE_SSE2 )
	elif use cpu_flags_x86_sse ; then
		mycommonmakeargs+=( --enable-sse )
		mycommonmakedefargs+=( -DUSE_SSE )
	elif use cpu_flags_x86_mmx ; then
		mycommonmakeargs+=( --enable-mmx )
		mycommonmakedefargs+=( -DUSE_MMX )
	elif use cpu_flags_x86_3dnow ; then
		mycommonmakeargs+=( --enable-3dnow )
		mycommonmakedefargs+=( -DUSE_3DNOW )
	elif use altivec ; then
		mycommonmakeargs+=( --enable-altivec )
		mycommonmakedefargs+=( -DUSE_ALTIVEC )
	fi

	if use neon ; then
		mycommonmakeargs+=( --enable-neon )
	fi

	mycommonmakeargs+=( --enable-fast-math )

	if [ ! -d "/usr/share/boinc/$SLOT_BOINC" ] ; then
		die "Cannot find matching version between setiathome-boincdir to emerged boinc."
	fi

	cd "${WORKDIR}/${MY_P}/AKv8"
	CFLAGS="${CFLAGS} ${PGO_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}"  LIBS="${sahfftwlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${mysahmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$SLOT_BOINC" econf \
	${mycommonmakeargs[@]} \
	${mysahmakeargs[@]} || die
	cp "sah_config.h" "config.h" || die
}

src_compile() {
	INSTRUMENT_CFLAGS=""
	INSTRUMENT_LDFLAGS=""
	INSTRUMENT_LIBS=""
	PROFILE_DATA_CFLAGS=""
	PROFILE_DATA_LDFLAGS=""
	PROFILE_DATA_LIBS=""
	if $(tc-is-gcc) ; then
		INSTRUMENT_CFLAGS="-fprofile-generate"
		INSTRUMENT_LDFLAGS="-fprofile-generate"
		INSTRUMENT_LIBS=""

		PROFILE_DATA_CFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LDFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LIBS=""
	elif $(tc-is-clang) ; then
                INSTRUMENT_CFLAGS="-fprofile-instr-generate"
                INSTRUMENT_LDFLAGS="-fprofile-instr-generate"
                INSTRUMENT_LIBS=""

                PROFILE_DATA_CFLAGS="-fprofile-instr-use=${T}/code.profdata"
                PROFILE_DATA_LDFLAGS="-fprofile-instr-use=${T}/code.profdata"
                PROFILE_DATA_LIBS=""
	else
		die "Check your compiler CC and CXX must be clang/clang++ or gcc/g++."
	fi

	einfo "Making classic client..."
	if use pgo ; then
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client"
                emake || die
		cp test_workunits/reference_work_unit.sah work_unit.sah
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./seti_boinc -standalone
		ls result.sah || die "simulating failed"
		#diff -u test_workunits/reference_result_unit.sah result.sah
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		if $(tc-is-clang) ; then
                        llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
                fi
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client" || die
                emake || die
	else
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client" || die
                emake || die
        fi
}

src_install() {
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu" || die
	#cat ${FILESDIR}/app_info.xml_start >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	SAH_CPU_TYPE="CPU"
	SAH_PLAN_CLASS=""

	if use cpu_flags_x86_sse2 ; then
		SAH_PLAN_CLASS="sse2"
	elif use cpu_flags_x86_sse ; then
		SAH_PLAN_CLASS="sse"
	else
		ewarn "Using the fallback plan class."
		SAH_PLAN_CLASS=""
	fi

	cd "${WORKDIR}/${MY_P}/AKv8" || die
	SAH_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g"`
	SAH_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	cd "${WORKDIR}/${MY_P}/AKv8/client"
	SAH_EXE=`ls setiathome-* | sed -r -e "s| |\n|g" | grep -v "debug"`
	cp ${SAH_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${SAH_EXE}_cpu || die

	cd "${WORKDIR}/${MY_P}/AKv8/client"

	SAH_VER_TAG="_v${SAH_VER_MAJOR}"

	# Testing this again 20190310
	#SAH_PLAN_CLASS="" #nothing in v8

	SAH_CMDLN=""
	cat "${FILESDIR}/app_info.xml_sah_cpu_sse" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_SAH_EXE|${SAH_EXE}_cpu|g" -e "s|CFG_SAH_VER_NODOT|${SAH_VER_NODOT}|g" -e "s|CFG_SAH_VER_TAG|${SAH_VER_TAG}|g" -e "s|CFG_SAH_PLAN_CLASS|${SAH_PLAN_CLASS}|g" -e "s|CFG_SAH_CMDLN|${SAH_CMDLN}|g" > ${T}/app_info.xml_sah_cpu_sse || die

	SAH_GFX_EXE_SEC_A=""
	SAH_GFX_EXE_SEC_B=""
	SAH_GFX_EXE_A=""
	SAH_GFX_EXE_B=""
        if use opengl ; then
		SAH_GFX_MD5=`md5sum seti_graphics | awk '{print $1}'`
		SAH_GFX_EXE_A="seti_graphics_cpu"
		SAH_GFX_EXE_B="seti_graphics_cpu"
		SAH_GFX_EXE_SEC_A=`cat ${FILESDIR}/app_info.xml_sah_gfx_1 | sed -r -e "s|CFG_SAH_GFX_EXE_A|${SAH_GFX_EXE_A}|g" -e "s|CFG_SAH_GFX_MD5|${SAH_GFX_MD5}|g"`
		SAH_GFX_EXE_SEC_B=`cat ${FILESDIR}/app_info.xml_sah_gfx_2 | sed -r -e "s|CFG_SAH_GFX_EXE_B|${SAH_GFX_EXE_B}|g"`
		cp seti_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/seti_graphics_cpu || die
	fi
	cat ${T}/app_info.xml_sah_cpu_sse | awk -v Z1="${SAH_GFX_EXE_SEC_A}" -v Z2="${SAH_GFX_EXE_SEC_B}" '{ sub(/CFG_SAH_GFX_EXE_SEC_A/, Z1); sub(/CFG_SAH_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_sah_cpu || die
}

pkg_postinst() {
	/usr/bin/setiathome-updater
}

#plan_class
#https://boinc.berkeley.edu/trac/wiki/AppPlan

#CPU_TYPE
#https://boinc.berkeley.edu/trac/wiki/AppCoprocessor
