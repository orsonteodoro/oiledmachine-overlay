# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

ASTROPULSE_VERSION="$(get_version_component_range 1-2 ${PV})"
ASTROPULSE_SVN_REVISION="$(get_version_component_range 3 ${PV})" # The versioning is based on the https://setisvn.ssl.berkeley.edu/trac/browser/astropulse/client folder's revision.
SETIATHOME_SVN_REVISION="3979" # This should be the same as the setiathome ebuild.

MY_P="astropulse-cpu-${ASTROPULSE_VERSION}"
DESCRIPTION="Astropulse"
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
	sci-misc/astropulse-art:7
	sci-misc/setiathome-updater:8
"

SLOT_BOINC="7.14"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.67
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:${SLOT_BOINC}
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
	cp -r "${ESVN_STORE_DIR}/${PN}/seti_boinc" "${WORKDIR}/${MY_P}/AKv8"
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps"

	ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/astropulse"
        ESVN_REVISION="${ASTROPULSE_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
        subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/astropulse" "${WORKDIR}/${MY_P}/AP"
}

src_prepare() {
	cd "${WORKDIR}/${MY_P}"
	eapply "${FILESDIR}"/astropulse-cpu-7.01.3495-optimizationsm4-01.patch
	eapply "${FILESDIR}"/astropulse-cpu-7.01.3495-optimizationsm4-02.patch
	eapply "${FILESDIR}"/astropulse-cpu-7.01.3495-optimizationsm4-03.patch
	eapply "${FILESDIR}"/astropulse-cpu-7.01.3495-optimizationsm4-04.patch
	eapply "${FILESDIR}"/setiathome-7.09-configureac.patch
	epatch "${FILESDIR}"/setiathome-7.09-apgfxmainh.patch
	epatch "${FILESDIR}"/setiathome-7.09-apgfxbaseh.patch

	if $(version_is_at_least "7.3.19" $BOINC_VER ) ; then
		true
	else
		eapply "${FILESDIR}"/astropulse-cpu-7.01.3495-boinc-compat.patch
	fi

	eapply_user

	cd "${WORKDIR}/${MY_P}/AP/client"
	AT_M4DIR="m4" eautoreconf
	chmod +x configure
}

src_configure() {
        append-flags -Wa,--noexecstack
	#conf run in src_compile
}

function run_config {
	local -a mycommonmakeargs
	local -a mycommonmakedefargs

	local -a myapmakeargs
	local -a myapmakedefargs
	local -a apfftwlibs
	local -a asmlibs

        append-flags -Wa,--noexecstack

	if [[ ${ARCH} =~ (amd64|ia64|arm64|ppc64|alpha) || ${host} =~ (sparc64) ]]; then
		apfftwlibs=( -L/usr/lib64 )
	elif [[ ${ARCH} =~ (x86|i386|arm|ppc|m68k|s390|hppa) || ${host} =~ (sparc) ]] ; then
		apfftwlibs=( -L/usr/lib32 )
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

	myapmakedefargs+=( -DAP_CLIENT )

	apfftwlibs+=( -lfftw3f )
	myapmakedefargs+=( -DUSE_FFTW )

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

	cd "${WORKDIR}/${MY_P}/AP/client"
	CFLAGS="${CFLAGS} ${PGL_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}" LIBS="${apfftwlibs[@]} ${asmlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${myapmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$SLOT_BOINC" BOINC_DIR="/usr/share/boinc/$SLOT_BOINC" SETI_BOINC_DIR="${WORKDIR}/${MY_P}/AKv8" econf \
	${mycommonmakeargs[@]} \
	${myapmakeargs[@]} || die
	cp ap_config.h config.h || die
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

	einfo "Making astropulse client..."
	cd "${WORKDIR}/${MY_P}/AP/client" || die
        if use pgo ; then
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" run_config
                emake || die
		einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./ap_client -standalone
                ls pulse.out || die "simulating failed"
                #diff -u pulse.out pulse.out.ref
		if $(tc-is-clang) ; then
			llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
		fi
		make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
                emake || die
        else
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
                emake || die
	fi
}

src_install() {
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu" || die
	AP_CPU_TYPE="CPU"
	AP_PLAN_CLASS="sse3"

	cd "${WORKDIR}/${MY_P}/AP/client" || die
	AP_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g" -e "s|\)||g"`
	AP_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	AP_EXE=`ls astropulse-* | sed -r -e "s| |\n|g" | grep -v "debug"`
	cp ${AP_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${AP_EXE}_cpu || die

	cd "${WORKDIR}/${MY_P}/AP/client" || die

	# Plan classes listed in
	# https://setiathome.berkeley.edu/apps.php
	AP_VER_TAG="_v${AP_VER_MAJOR}"
	if [[ ${ARCH} =~ (x86) ]] ; then
		if use cpu_flags_x86_sse2 ; then
			AP_PLAN_CLASS="sse2"
		elif use cpu_flags_x86_sse ; then
			AP_PLAN_CLASS="sse"
		else
			ewarn "Using the fallback plan class."
			AP_PLAN_CLASS=""
		fi
	elif [[ ${ARCH} =~ (amd64|ia64) ]] ; then
		if use cpu_flags_x86_sse2 ; then
			AP_PLAN_CLASS="sse2"
		else
			ewarn "Using the fallback plan class."
			AP_PLAN_CLASS=""
		fi
	elif [[ ${ARCH} =~ (ppc64) ]]; then
		ewarn "linux/ppc64 may not be supported.  Using the fallback plan class."
		AP_PLAN_CLASS=""
	elif [[ ${ARCH} =~ (ppc) ]]; then
		ewarn "linux/ppc may not be supported.  Using the fallback plan class."
		AP_PLAN_CLASS=""
	elif [[ ${ARCH} =~ (arm64|arm) ]]; then
		ewarn "ARM/ARM64 may not be supported.  Using the fallback plan class."
		AP_PLAN_CLASS=""
	else
		ewarn "This configuration may not be supported.  Using the fallback plan class."
		AP_PLAN_CLASS=""
	fi

	AP_CMDLN=""
	cat "${FILESDIR}/app_info.xml_ap_cpu_sse" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_AP_EXE|${AP_EXE}_cpu|g" -e "s|CFG_AP_VER_NODOT|${AP_VER_NODOT}|g" -e "s|CFG_AP_VER_TAG|${AP_VER_TAG}|g" -e "s|CFG_AP_PLAN_CLASS|${AP_PLAN_CLASS}|g" -e "s|CFG_AP_CMDLN|${AP_CMDLN}|g" > ${T}/app_info.xml_ap_cpu_sse || die

	AP_GFX_EXE_SEC_A=""
	AP_GFX_EXE_SEC_B=""
	AP_GFX_EXE_A=""
	AP_GFX_EXE_B=""
	if use opengl ; then
		AP_GFX_MD5=`md5sum ap_graphics | awk '{print $1}'`
		AP_GFX_EXE_A="ap_graphics_cpu"
		AP_GFX_EXE_B="ap_graphics_cpu"
		AP_GFX_EXE_SEC_A=`cat ${FILESDIR}/app_info.xml_ap_gfx_1 | sed -r -e "s|CFG_AP_GFX_EXE_A|${AP_GFX_EXE_A}|g" -e "s|CFG_AP_GFX_MD5|${AP_GFX_MD5}|g"`
		AP_GFX_EXE_SEC_B=`cat ${FILESDIR}/app_info.xml_ap_gfx_2 | sed -r -e "s|CFG_AP_GFX_EXE_B|${AP_GFX_EXE_B}|g"`
		cp ap_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/ap_graphics_cpu || die
	fi
	cat ${T}/app_info.xml_ap_cpu_sse | awk -v Z1="${AP_GFX_EXE_SEC_A}" -v Z2="${AP_GFX_EXE_SEC_B}" '{ sub(/CFG_AP_GFX_EXE_SEC_A/, Z1); sub(/CFG_AP_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_ap_cpu || die
}

pkg_postinst() {
	/usr/bin/setiathome-updater
}

#plan_class
#https://boinc.berkeley.edu/trac/wiki/AppPlan

#CPU_TYPE
#https://boinc.berkeley.edu/trac/wiki/AppCoprocessor
