# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

SETIATHOME_VERSION="$(get_version_component_range 1-2 ${PV})"
SETIATHOME_SVN_REVISION="$(get_version_component_range 3 ${PV})" #track https://setisvn.ssl.berkeley.edu/trac/browser/seti_boinc
MY_P="setiathome-cpu-${SETIATHOME_VERSION}"
DESCRIPTION="Seti@Home"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="$(get_major_version)"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

IUSE="32bit 64bit opengl custom-cflags avx2 avx avx-btver2 avx-bdver3 avx-bdver2 avx-bdver1 sse42 sse41 ssse3 sse3 sse2 sse mmx 3dnow core2 xeon ppc ppc64 x32 x64 pgo"
REQUIRED_USE=""

#	dev-libs/asmlib
RDEPEND="
	sci-libs/fftw[static-libs]
	sci-misc/setiathome-art:7
"

#BOINC_VER=`boinc --version | cut -d' ' -f1`
BOINC_VER="7.2.47"
#BOINC_MAJOR=`echo $BOINC_VER | cut -d. -f1`
#BOINC_MINOR=`echo $BOINC_VER | cut -d. -f2`
DEPEND="${RDEPEND}
	=sys-devel/autoconf-2.67
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:0/${BOINC_VER}
	sci-misc/setiathome-updater:8
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
		ewarn "The configure script may fail with clang.  Switch to gcc if it fails."
	fi
}

src_unpack() {
	ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/seti_boinc"
	ESVN_REVISION="${SETIATHOME_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
	subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/seti_boinc" "${WORKDIR}/${MY_P}/AKv8"
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps"
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

	eapply_user

	cd "${WORKDIR}/${MY_P}/AKv8"
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

	local -a mysahmakeargs
	local -a mysahmakedefargs

	local -a myapmakeargs
	local -a myapmakedefargs
	local -a sahfftwlibs
	local -a apfftwlibs
	local -a asmlibs

        append-flags -Wa,--noexecstack

	if use 32bit ; then
		mysahmakeargs+=( --enable-bitness=32 )
		#mysahmakeargs+=( --host=i686-pc-linux-gnu )
		#mysahmakeargs+=( --target=i686-pc-linux-gnu )
		#mysahmakeargs+=( --build=i686-pc-linux-gnu )
		#mysahmakeargs+=( --with-boinc-platform=i686-pc-linux-gnu )
		sahfftwlibs=( -L/usr/lib32 )
		apfftwlibs=( -L/usr/lib32 )
		#asmlibs=( -L/usr/lib32 )
		#asmlibs+=( -laelf32p )
	elif use 64bit ; then
		mysahmakeargs+=( --enable-bitness=64 )
		#mysahmakeargs+=( --host=x86_64-pc-linux-gnu )
		#mysahmakeargs+=( --target=x86_64-pc-linux-gnu )
		#mysahmakeargs+=( --build=x86_64-pc-linux-gnu )
		#mysahmakeargs+=( --with-boinc-platform=x86_64-pc-linux-gnu )
		sahfftwlibs=( -L/usr/lib64 )
		apfftwlibs=( -L/usr/lib64 )
		#asmlibs=( -L/usr/lib64 )
		#asmlibs+=( -laelf64 )
	fi

	mycommonmakeargs+=( --disable-server )
	mycommonmakeargs+=( --enable-client )
	mycommonmakeargs+=( --disable-static-client )
	#mycommonmakeargs+=( --disable-intrinsics ) #enabling breaks compile

	mycommonmakedefargs+=( -D_GNU_SOURCE )
	#mycommonmakedefargs+=( -DUSE_ASMLIB )

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

	if use ppc ; then
		mysahmakedefargs+=( -DUSE_PPC_G4 ) #32 bit
		mysahmakedefargs+=( -DUSE_PPC_OPTIMIZATIONS )
	elif use ppc64 ; then
		mysahmakedefargs+=( -DUSE_PPC_G5 ) #64 bit
		mysahmakedefargs+=( -DUSE_PPC_OPTIMIZATIONS )
	elif use x32 || use x64 ; then
		mysahmakedefargs+=( -DUSE_I386_OPTIMIZATIONS ) #uses sse3 sse2
		#mycommonmakeargs+=( --enable-asmlib )
	fi

	if use xeon ; then
		mysahmakedefargs+=( -DUSE_I386_XEON )
	fi
	mysahmakedefargs+=( -DFFTOUT )
	mysahmakedefargs+=( -DUSE_JSPF )

	sahfftwlibs+=( -lfftw3f )
	mysahmakedefargs+=( -DUSE_FFTW )

	if use custom-cflags ; then
	#	mycommonmakeargs+=( --disable-comoptions )
		true
	else
		strip-flags
		filter-flags -O3 -O2 -O1 -Os -Ofast -O4
	#	mycommonmakeargs+=( --enable-comoptions )
	fi

	#Enabling this will disable more optimized JSPF (Joe Segur's SSE Pulse Finding Alignment)
	#if use core2 ; then
	#	mycommonmakedefargs+=( -DUSE_I386_CORE2 )
	#fi

	if use avx2 ; then
		mycommonmakeargs+=( --enable-avx2 )
		mycommonmakedefargs+=( -DUSE_AVX2 )
	elif use avx-btver2 ; then
		mycommonmakeargs+=( --enable-btver2 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use avx-bdver3 ; then
		mycommonmakeargs+=( --enable-bdver3 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use avx-bdver2 ; then
		mycommonmakeargs+=( --enable-bdver2 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use avx-bdver1 ; then
		mycommonmakeargs+=( --enable-bdver1 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use avx ; then
		mycommonmakeargs+=( --enable-avx )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use sse42 ; then
		mycommonmakeargs+=( --enable-sse42 )
		mycommonmakedefargs+=( -DUSE_SSE42 )
	elif use sse41 ; then
		mycommonmakeargs+=( --enable-sse41 )
		mycommonmakedefargs+=( -DUSE_SSE41 )
	elif use ssse3 ; then
		mycommonmakeargs+=( --enable-ssse3 )
		mycommonmakedefargs+=( -DUSE_SSSE3 )
	elif use sse3 ; then
		mycommonmakeargs+=( --enable-sse3 )
		mycommonmakedefargs+=( -DUSE_SSE3 )
	elif use sse2 ; then
		mycommonmakeargs+=( --enable-sse2 )
		mycommonmakedefargs+=( -DUSE_SSE2 )
	elif use sse ; then
		mycommonmakeargs+=( --enable-sse )
		mycommonmakedefargs+=( -DUSE_SSE )
	elif use mmx ; then
		mycommonmakeargs+=( --enable-mmx )
		mycommonmakedefargs+=( -DUSE_MMX )
	elif use 3dnow ; then
		mycommonmakeargs+=( --enable-3dnow )
		mycommonmakedefargs+=( -DUSE_3DNOW )
	elif use altivec ; then
		mycommonmakeargs+=( --enable-altivec )
		mycommonmakedefargs+=( -DUSE_ALTIVEC )
	fi

	mycommonmakeargs+=( --enable-fast-math )

	if [ ! -d "/usr/share/boinc/$BOINC_VER" ] ; then
		die "Cannot find matching version between setiathome-boincdir to emerged boinc."
	fi

	append-cppflags -D_GLIBCXX_USE_CXX11_ABI=0

	cd "${WORKDIR}/${MY_P}/AKv8"
	CFLAGS="${CFLAGS} ${PGO_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}"  LIBS="${sahfftwlibs[@]} ${asmlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${mysahmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$BOINC_VER" econf \
	${mycommonmakeargs[@]} \
	${mysahmakeargs[@]} || die
	cp "sah_config.h" "config.h"
}

src_compile() {
	INSTRUMENT_CFLAGS=""
	INSTRUMENT_LDFLAGS=""
	INSTRUMENT_LIBS=""
	PROFILE_DATA_CFLAGS=""
	PROFILE_DATA_LDFLAGS=""
	PROFILE_DATA_LIBS=""
	if [[ "${CC}" == "gcc" || "${CXX}" == "g++" ]]; then
		INSTRUMENT_CFLAGS="-fprofile-generate"
		INSTRUMENT_LDFLAGS="-fprofile-generate"
		INSTRUMENT_LIBS=""

		PROFILE_DATA_CFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LDFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LIBS=""
	elif [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
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
		cd "${WORKDIR}/${MY_P}/AKv8"
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client"
                emake || die
		cp test_workunits/reference_work_unit.sah work_unit.sah
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./seti_boinc -standalone
		ls result.sah || die "simulating failed"
		#diff -u test_workunits/reference_result_unit.sah result.sah
		cd "${WORKDIR}/${MY_P}/AKv8"
                if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
                	llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
                fi
		cd "${WORKDIR}/${MY_P}/AKv8"
		make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client"
                emake || die
	else
		cd "${WORKDIR}/${MY_P}/AKv8"
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
		cd "${WORKDIR}/${MY_P}/AKv8/client"
                emake || die
        fi
}

src_install() {
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu"
	BOINC_VER=`boinc --version | awk '{print $1}'`
	#cat ${FILESDIR}/app_info.xml_start >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
	AP_CPU_TYPE="CPU"
	AP_PLAN_CLASS="sse3"
	SAH_CPU_TYPE="CPU"
	SAH_PLAN_CLASS="sse3"

	cd "${WORKDIR}/${MY_P}/AKv8"
	SAH_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g"`
	SAH_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	cd "${WORKDIR}/${MY_P}/AKv8/client"
	SAH_EXE=`ls setiathome-* | sed -r -e "s| |\n|g" | grep -v "debug"`
	cp ${SAH_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${SAH_EXE}_cpu

	cd "${WORKDIR}/${MY_P}/AKv8/client"
	#cp better_banner.jpg "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu

	SAH_VER_TAG="_v${SAH_VER_MAJOR}"
	SAH_PLAN_CLASS="" #nothing in v8

	SAH_CMDLN=""
	cat "${FILESDIR}/app_info.xml_sah_cpu_sse" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_SAH_EXE|${SAH_EXE}_cpu|g" -e "s|CFG_SAH_VER_NODOT|${SAH_VER_NODOT}|g" -e "s|CFG_SAH_VER_TAG|${SAH_VER_TAG}|g" -e "s|CFG_SAH_PLAN_CLASS|${SAH_PLAN_CLASS}|g" -e "s|CFG_SAH_CMDLN|${SAH_CMDLN}|g" > ${T}/app_info.xml_sah_cpu_sse

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
		cp seti_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/seti_graphics_cpu
	fi
	cat ${T}/app_info.xml_sah_cpu_sse | awk -v Z1="${SAH_GFX_EXE_SEC_A}" -v Z2="${SAH_GFX_EXE_SEC_B}" '{ sub(/CFG_SAH_GFX_EXE_SEC_A/, Z1); sub(/CFG_SAH_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_sah_cpu
	#cat ${FILESDIR}/app_info.xml_end >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml
}

pkg_postinst() {
	/usr/bin/setiathome-updater
}

#plan_class
#https://boinc.berkeley.edu/trac/wiki/AppPlan

#CPU_TYPE
#https://boinc.berkeley.edu/trac/wiki/AppCoprocessor
