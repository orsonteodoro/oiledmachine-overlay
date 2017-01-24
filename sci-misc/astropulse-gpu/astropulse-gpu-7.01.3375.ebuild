# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

ASTROPULSE_VERSION="$(get_version_component_range 1-2 ${PV})"
ASTROPULSE_SVN_REVISION="$(get_version_component_range 3 ${PV})"
SETIATHOME_SVN_REVISION="3602" #match setiathome-gpu
MY_P="astropulse-gpu-${ASTROPULSE_VERSION}"
DESCRIPTION="Astropulse"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="$(get_major_version)/${ASTROPULSE_SVN_REVISION}"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

#cuda only supported on windows
IUSE="test 32bit 64bit opengl opencl -cuda -cuda_2_2 -cuda_2_3 -cuda_3_2 -cuda_4_2 -cuda_5_0 custom-cflags avx2 avx avx-btver2 avx-bdver3 avx-bdver2 avx-bdver1 sse42 sse41 ssse3 sse3 sse2 sse mmx 3dnow video_cards_nvidia video_cards_fglrx video_cards_intel ati_hd4xxx core2 xeon ppc ppc64 x32 x64 intel_hd intel_hd2xxx intel_hd3xxx intel_hd_gt1 intel_hd4xxx intel_hd5xxx intel_iris5xxx ati_hd5xxx ati_hd6xxx ati_hd7xxx ati_hdx3xx ati_hdx4xx ati_hdx5xx ati_hdx6xx ati_hdx7xx ati_hdx8xx ati_hdx9xx ati_rx_200 ati_rx_300 ati_rx_400 ati_rx_x2x ati_rx_x3x ati_rx_x4x ati_rx_x5x ati_rx_x6x ati_rx_x7x ati_rx_x8x ati_rx_x9x nv_1xx nv_2xx nv_3xx nv_4xx nv_5xx nv_6xx nv_7xx nv_8xx nv_9xx nv_x00 nv_x10 nv_x20 nv_x30 nv_x40 nv_x00_fast nv_x10_fast nv_x20_fast nv_x30_fast nv_x40_fast nv_x50 nv_x60 nv_x70 nv_x50_fast nv_x60_fast nv_x70_fast nv_x70 nv_x80 nv_x70_fast nv_x80_fast nv_780ti nv_titan nv_780ti_fast nv_titan_fast nv_8xxx nv_9xxx nv_8xxx_fast nv_9xxx_fast armv6-neon-nopie armv6-neon armv6-vfp-nopie armv6-vfp armv7-neon armv7-neon-nopie armv7-vfpv3 armv7-vfpv3d16 armv7-vfpv3d16-nopie armv7-vfpv4 armv7-vfpv4-nopie arm pgo ati_apu"

#	dev-libs/asmlib
RDEPEND="
	sci-libs/fftw[static-libs]
	video_cards_nvidia? ( || ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit ) )
	video_cards_fglrx? ( || ( x11-drivers/ati-drivers dev-util/amdapp ) )
	video_cards_intel? ( dev-libs/intel-beignet )
	sci-misc/astropulse-art:7
"

BOINC_VER=`boinc --version | cut -d' ' -f1`
BOINC_MAJOR=`echo $BOINC_VER | cut -d. -f1`
BOINC_MINOR=`echo $BOINC_VER | cut -d. -f2`
DEPEND="${RDEPEND}
	=sys-devel/autoconf-2.67
	opencl? ( dev-util/amdapp )
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:${BOINC_VER}
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
		ewarn "The configure script may fail with clang.  Switch to gcc if it fails."
	fi
}

pkg_pretend() {
        for DEVICE in $(ls /dev/*/card*)
        do
                cat /etc/sandbox.conf | grep -e "${DEVICE}"
                if [ $? == 1 ] ; then
                        die "SANDBOX_WRITE=\"${DEVICE}\" needs to be added to /etc/sandbox.conf"
                fi
        done
}

src_unpack() {
	ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/branches/sah_v7_opt"
        ESVN_REVISION="${ASTROPULSE_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
        subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/sah_v7_opt" "${WORKDIR}/${MY_P}"
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps"

	mv "${WORKDIR}/${MY_P}/AP" "${WORKDIR}/${MY_P}/AP6"
	mv "${WORKDIR}/${MY_P}/AP_BLANKIT" "${WORKDIR}/${MY_P}/AP"

	BOINC_VER=`boinc --version | awk '{print $1}'`
	BOINC_MAJOR=`echo $BOINC_VER | cut -d. -f1`
	BOINC_MINOR=`echo $BOINC_VER | cut -d. -f2`
	URL="https://github.com/BOINC/boinc/archive/client_release/$BOINC_MAJOR.$BOINC_MINOR/$BOINC_VER.zip"

	cd "${WORKDIR}/${MY_P}"
	epatch "${FILESDIR}"/astropulse-7.00-apclientmaincpp.patch #1
	epatch "${FILESDIR}"/setiathome-7.08-makefileam-ap-gfx.patch #10
	epatch "${FILESDIR}"/setiathome-7.08-configureac-ap-gfx.patch #9

	cd "${WORKDIR}/${MY_P}/AKv8/client"
        ESVN_REVISION="${SETIATHOME_SVN_REVISION}"
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.h" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.cpp" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.cpp" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.h" || die
	wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/graphics_main.cpp" || die

	cd "${WORKDIR}/${MY_P}"
	epatch "${FILESDIR}"/setiathome-7.08-makefileam-apshmem.patch #11
	epatch "${FILESDIR}"/setiathome-7.08-apclientmaincpp-apshmem.patch #7
	epatch "${FILESDIR}"/setiathome-7.08-setih-graphics_lib_handle.patch #test
 	epatch "${FILESDIR}"/setiathome-7.08-makefileam-ap-apshmem.patch #10
 	epatch "${FILESDIR}"/setiathome-7.08-apclientmaincpp-ap-doublemax.patch #5
 	epatch "${FILESDIR}"/setiathome-7.08-apgfxbaseh-ap-reducedarraygen.patch #8
	epatch "${FILESDIR}"/setiathome-7.08-sah-ap-graphics-ap.patch #13 ap
	epatch "${FILESDIR}"/setiathome-7.08-ap-configureac-enablegraphics.patch #2
	epatch "${FILESDIR}"/setiathome-7.08-ap-sah-graphics-fixes1.patch #4
	epatch "${FILESDIR}"/setiathome-7.08-ap-sah-glew-ap.patch #3 ap
	epatch "${FILESDIR}"/setiathome-7.08-noopengl-ap.patch #12 ap

	#cd "${WORKDIR}/${MY_P}/AKv8/client"
	#touch gl.h glu.h glut.h

	#ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/seti_boinc/glut"
        #ESVN_REVISION="1962" #7.07 trunk
	#ESVN_OPTIONS="--trust-server-cert"
        #subversion_src_unpack
	#cp -r "${ESVN_STORE_DIR}/${PN}/glut" "${WORKDIR}/${MY_P}/AKv8"

	if use test || use pgo ; then
		cd "${WORKDIR}/${MY_P}/AP/client"
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/astropulse/client/in.dat" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/astropulse/client/pulse.out.ref" || die
	fi

	if $(version_is_at_least "7.3.19" $BOINC_VER ) ; then
		true
	else
		cd "${S}"
		epatch "${FILESDIR}"/astropulse-gpu-7.01.3375-boinc-compat.patch
	fi
}

src_prepare() {
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

	#mycommonmakeargs+=( --disable-server )
	mycommonmakeargs+=( --enable-client )
	mycommonmakeargs+=( --disable-static-client )
	#mycommonmakeargs+=( --disable-intrinsics ) #enabling breaks compile

	mycommonmakedefargs+=( -D_GNU_SOURCE )
	#mycommonmakedefargs+=( -DUSE_ASMLIB )

	if use opengl ; then
		mycommonmakedefargs+=( -DBOINC_APP_GRAPHICS )
		mycommonmakedefargs+=( -DDYNAMIC_GRAPHICS )
		mycommonmakeargs+=( --enable-graphics )
                mycommonmakedefargs+=( -DHAVE_GL_GL_H )
                mycommonmakedefargs+=( -DHAVE_GL_GLU_H )
                mycommonmakedefargs+=( -DHAVE_GL_GLUT_H )
	else
		mycommonmakeargs+=( --disable-graphics )
	fi

	myapmakedefargs+=( -DAP_CLIENT )
	myapmakedefargs+=( -DBLANKIT ) #use version 7
	myapmakedefargs+=( -DSMALL_CHIRP_TABLE )
	myapmakedefargs+=( -DUSE_CONVERSION_OPT )
	myapmakedefargs+=( -DUSE_INCREASED_PRECISION )

	if use opencl ; then
		myapmakedefargs+=( -DUSE_OPENCL )
		myapmakedefargs+=( -DOPENCL_WRITE )
		if use video_cards_fglrx ; then
                        if use ati_hd4xxx ; then #ati lower hd4xxx cards
                                myapmakedefargs+=( -DLHD4K )
			elif use ati_apu ; then
                                myapmakedefargs+=( -DUSE_OPENCL_HD5xxx )
                        elif use ati_hd5xxx || use ati_hd6xxx || use ati_hd7xxx || use ati_rx_200 || use ati_rx_300 || use ati_rx_400 ; then
	                        myapmakedefargs+=( -DUSE_OPENCL_HD5xxx )
                        fi
		elif use video_cards_nvidia ; then
			myapmakedefargs+=( -DUSE_OPENCL_NV )
		elif use video_cards_intel ; then
			myapmakedefargs+=( -DUSE_OPENCL_INTEL )
		fi
		myapmakedefargs+=( -DCOMBINED_DECHIRP_KERNEL )
		myapmakedefargs+=( -DOCL_ZERO_COPY )
		myapmakedefargs+=( -DTWIN_FFA )
	elif use cuda ; then
		myapmakedefargs+=( -DUSE_GPU )
	#elif use brook ; then
	#	myapmakedefargs+=( -DUSE_BROOK )
	#	myapmakedefargs+=( -DUSE_BROOK_NO_DOUBLE )
	#	myapmakedefargs+=( -DTWINDECHIRP )
	else #cpu only
		myapmakedefargs+=( -DUSE_LRINT )
		myapmakedefargs+=( -DTWINDECHIRP )
	fi

	apfftwlibs+=( -lfftw3f )
	myapmakedefargs+=( -DUSE_FFTW )

	if use custom-cflags ; then
		mycommonmakeargs+=( --disable-comoptions )
	else
		strip-flags
		filter-flags -O3 -O2 -O1 -Os -Ofast -O4
		mycommonmakeargs+=( --enable-comoptions )
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

	cd "${WORKDIR}/${MY_P}/AP/client"
	CFLAGS="${CFLAGS} ${PGL_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}" LIBS="${apfftwlibs[@]} ${asmlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${myapmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$BOINC_VER" BOINC_DIR="/usr/share/boinc/$BOINC_VER" SETI_BOINC_DIR="${WORKDIR}/${MY_P}/AKv8" econf \
	${mycommonmakeargs[@]} \
	${myapmakeargs[@]} || die
}

SAH_GPU_TYPE=""
SAH_GPU_NUM_INSTANCES=""
SAH_PLAN_CLASS=""

AP_GPU_TYPE=""
AP_GPU_NUM_INSTANCES=""
AP_PLAN_CLASS=""

NUM_GPU_INSTANCES=""
NUM_CPU_INSTANCES=""
AP_GPU_CMDLN=""
SAH_GPU_CMDLN=""
AP_GPU_NUM_INSTANCES=""
SAH_GPU_NUM_INSTANCES=""

function gpu_setup {
	#intel low end
	if use intel_hd || use intel_hd2xxx ; then
		SAH_GPU_TYPE="intel_gpu"
		AP_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 2 1 16"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	#intel mid range
	elif use intel_hd3xxx || use intel_hd_gt1 ; then
		SAH_GPU_TYPE="intel_gpu"
		AP_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 64 1 4"
		AP_GPU_CMDLN="-unroll 10 -ffa_block 6144 -ffa_block_fetch 1536"
	#intel high end
	elif use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
		SAH_GPU_TYPE="intel_gpu"
		AP_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 512"
		AP_GPU_CMDLN="-unroll 12 -ffa_block 8192 -ffa_block_fetch 4096"

	#ati low end
	elif use ati_hdx3xx || use ati_hdx4xx || use ati_hdx5xx || use ati_rx_x2x || use ati_rx_x3x || use ati_apu ; then
		SAH_GPU_TYPE="ATI"
		AP_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 2 1 16"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	#ati mid range
	elif use ati_hdx6xx || use ati_hdx7xx || use ati_rx_x4x || use ati_rx_x5x || use ati_rx_x6x ; then
		SAH_GPU_TYPE="ATI"
		AP_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 64 1 4"
		AP_GPU_CMDLN="-unroll 12 -oclFFT_plan 256 16 256 -ffa_block 12288 -ffa_block_fetch 6144 -tune 1 64 4 1 -tune 2 64 4 1"
	#ati high end
	elif use ati_hdx8xx || use ati_hdx9xx || use ati_rx_x7x || use ati_rx_x8x || use ati_rx_x9x ; then
		SAH_GPU_TYPE="ATI"
		AP_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
		AP_GPU_CMDLN="-unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 4 1 -tune 2 64 4 1"

	#nv low end
	elif use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_8xxx || use nv_9xxx ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 128 -spike_fft_thresh 2048 -tune 1 2 1 16"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	elif use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_8xxx_fast || use nv_9xxx_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 128 -spike_fft_thresh 2048 -tune 1 2 1 16"
		AP_GPU_CMDLN="-use_sleep -unroll 4 -oclFFT_plan 256 16 1024"
	#nv mid range
	elif use nv_x50 || use nv_x60 || use nv_x70 ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 192 -spike_fft_thresh 2048 -tune 1 64 1 4"
		AP_GPU_CMDLN="-unroll 10 -ffa_block 6144 -ffa_block_fetch 1536"
	elif use nv_x50_fast || use nv_x60_fast || use nv_x70_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 192 -spike_fft_thresh 2048 -tune 1 64 1 4"
		AP_GPU_CMDLN="-use_sleep -unroll 10 -oclFFT_plan 256 16 512 -ffa_block 12288 -ffa_block_fetch 6144"
	#nv high end
	elif use nv_x70 || use nv_x80 ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
		AP_GPU_CMDLN="-unroll 12 -ffa_block 12288 -ffa_block_fetch 6144"
	elif use nv_x70_fast || use nv_x80_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
		AP_GPU_CMDLN="-use_sleep -unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 8 1 -tune 2 64 8 1"
	#nv enthusiast
	elif use nv_780ti || use nv_titan ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
		AP_GPU_CMDLN="-unroll 16 -ffa_block 16384 -ffa_block_fetch 8192"
	elif use nv_780ti_fast || use nv_titan_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		AP_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
		AP_GPU_CMDLN="-use_sleep -unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 8 1 -tune 2 64 8 1"

	fi

	if use x32 || use x64 ; then
		if use ati_hd5xxx || use ati_hd6xxx || use ati_hd7xxx || use ati_rx_200 || use ati_rx_300 || use ati_rx_400 || use ati_apu ; then
			if use opencl ; then
				AP_PLAN_CLASS="opencl_ati_100"
				SAH_PLAN_CLASS="opencl_ati5_cat132"
			fi
		elif use ati_hd4xxx ; then
			if use opencl ; then
				AP_PLAN_CLASS="opencl_ati_100"
				SAH_PLAN_CLASS="opencl_ati_cat132"
			fi
		elif use nv_1xx || use nv_2xx || use nv_3xx || use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_x50 || use nv_x60 || use nv_x70 || use nv_x50_fast || use nv_x60_fast || use nv_x70_fast || use nv_x70 || use nv_x80 || use nv_x70_fast || use nv_x80_fast || use nv_780ti || use nv_titan || use nv_780ti_fast || use nv_titan_fast ; then
			if use opencl ; then
				if use nv_1xx || use nv_2xx || use nv_3xx ; then
					AP_PLAN_CLASS="opencl_nvidia_cc1"
				else
					AP_PLAN_CLASS="opencl_nvidia_100"
				fi
				SAH_PLAN_CLASS="opencl_nvidia_sah"
			elif use cuda || use cuda_2_2 || use cuda_2_3 || use cuda_3_2 || use cuda_4_2 || use cuda_5_0 ; then
				if use nv_1xx || use nv_2xx || use nv_3xx ; then
					AP_PLAN_CLASS="cuda_opencl_cc1"
				else
					AP_PLAN_CLASS="cuda_opencl_100"
				fi
				if use cuda_2_2 ; then
					SAH_PLAN_CLASS="cuda22"
				elif use cuda_2_3 ; then
					SAH_PLAN_CLASS="cuda32"
				elif use cuda_3_2 ; then
					SAH_PLAN_CLASS="cuda32"
				elif use cuda_4_2 ; then
					SAH_PLAN_CLASS="cuda42"
				elif use cuda_5_0 ; then
					SAH_PLAN_CLASS="cuda50"
				fi
			fi
		elif use intel_hd || use intel_hd2xxx || use intel_hd3xxx || use intel_hd_gt1 || use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
			AP_PLAN_CLASS="opencl_intel_gpu_102"
			SAH_PLAN_CLASS="opencl_intel_gpu_sah"
		fi
	elif use ppc64 && use opencl ; then
		if use ati_hd5xxx || use ati_hd7xxx ; then
			AP_PLAN_CLASS="opencl_ati_mac"
			SAH_PLAN_CLASS="opencl_ati5_mac"
		elif use ati_hd4xxx ; then
			AP_PLAN_CLASS="opencl_ati_mac"
			SAH_PLAN_CLASS="opencl_ati_mac"
		elif use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
			AP_PLAN_CLASS="opencl_intel_gpu_mac"
			SAH_PLAN_CLASS="opencl_intel_gpu_sah"
		elif use nv_1xx || use nv_3xx || use nv_6xx || use nv_7xx ; then
			AP_PLAN_CLASS="opencl_nvidia_mac"
			SAH_PLAN_CLASS="opencl_nvidia_mac"
			if use cuda ; then
				SAH_PLAN_CLASS="opencl_ati5zc_mac"
			fi
		elif use nv_8xxx || use nv_9xxx ; then
			AP_PLAN_CLASS="opencl_nvidia_mac"
			SAH_PLAN_CLASS="opencl_nvidia_mac"
			if use cuda ; then
				SAH_PLAN_CLASS="opencl_ati5zc_mac"
			fi
		fi
	elif use ppc32 ; then
		AP_PLAN_CLASS=""
		SAH_PLAN_CLASS=""
	elif use arm ; then
		#todo
		#nopie means android 5 and above
		#vfp is old floating point
		#neon is simd
		if use armv6-neon-nopie ; then
			SAH_PLAN_CLASS="armv6-neon-nopie"
			AP_PLAN_CLASS=""
		elif use armv6-neon ; then
			SAH_PLAN_CLASS="armv6-neon"
			AP_PLAN_CLASS=""
		elif use armv6-vfp-nopie ; then
			SAH_PLAN_CLASS="armv6-vfp-nopie"
			AP_PLAN_CLASS=""
		elif use armv6-vfp ; then
			SAH_PLAN_CLASS="armv6-vfp"
			AP_PLAN_CLASS=""
		elif use armv7-neon ; then
			SAH_PLAN_CLASS="armv7-neon"
			AP_PLAN_CLASS=""
		elif use armv7-neon-nopie ; then
			SAH_PLAN_CLASS="armv7-neon-nopie"
			AP_PLAN_CLASS=""
		elif use armv7-vfpv3 ; then
			SAH_PLAN_CLASS="armv7-vfpv3"
			AP_PLAN_CLASS=""
		elif use armv7-vfpv3d16 ; then
			SAH_PLAN_CLASS="armv7-vfpv3d16"
			AP_PLAN_CLASS=""
		elif use armv7-vfpv3d16-nopie ; then
			SAH_PLAN_CLASS="armv7-vfpv3d16-nopie"
			AP_PLAN_CLASS=""
		elif use armv7-vfpv4 ; then
			SAH_PLAN_CLASS="armv7-vfpv4"
			AP_PLAN_CLASS=""
		elif use armv7-vfpv4-nopie ; then
			SAH_PLAN_CLASS="armv7-vfpv4-nopie"
			AP_PLAN_CLASS=""
		fi
	fi

	NUM_GPU_INSTANCES=`bc <<< "scale=6; 1/${SETIATHOME_GPU_INSTANCES}"`
	NUM_CPU_INSTANCES=`bc <<< "scale=6; 1/${SETIATHOME_CPU_INSTANCES}"`
	AP_GPU_CMDLN="${AP_GPU_CMDLN} -instances_per_device ${SETIATHOME_GPU_INSTANCES} -total_GPU_instances_num ${SETIATHOME_GPU_INSTANCES}"
	SAH_GPU_CMDLN="${SAH_GPU_CMDLN} -instances_per_device ${SETIATHOME_GPU_INSTANCES} -total_GPU_instances_num ${SETIATHOME_GPU_INSTANCES}"
	AP_GPU_NUM_INSTANCES="${SETIATHOME_GPU_INSTANCES}"
	SAH_GPU_NUM_INSTANCES="${SETIATHOME_GPU_INSTANCES}"
}

src_compile() {
	gpu_setup

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

	einfo "Making astropulse client..."
	cd "${WORKDIR}/${MY_P}/AP/client"
        if use pgo ; then
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" run_config
                emake || die
		AP_SVN_REV=`grep -r -e "SVN_REV_NUM" ./configure.ac | grep AC_SUBST | tail -n 1 | grep -o -e "[0-9]*"`
		cp AstroPulse_Kernels.cl "AstroPulse_Kernels_r${AP_SVN_REV}.cl"
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./ap_client -standalone ${AP_GPU_CMDLN}
                ls pulse.out || die "simulating failed"
                #diff -u pulse.out pulse.out.ref
		if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
			llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
		fi
		make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
                emake || die
	else
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
                emake || die
        fi
}

src_install() {
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu"
	BOINC_VER=`boinc --version | awk '{print $1}'`

	gpu_setup

	cd "${WORKDIR}/${MY_P}/AP/client"
	AP_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g" -e "s|\)||g"`
	AP_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	AP_SVN_REV=`grep -r -e "SVN_REV_NUM" ./configure.ac | grep AC_SUBST | tail -n 1 | grep -o -e "[0-9]*"`
	AP_EXE=`ls ap_* | sed -r -e "s| |\n|g" | grep "clGPU"`
	cp ${AP_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${AP_EXE}_gpu.ocl

	cd "${WORKDIR}/${MY_P}/AP/client"
	#cp ap.jpg "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	#cp x.tga "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	#cp x.tif "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu
	cp AstroPulse_Kernels.cl "${D}/var/lib/boinc/projects/setiathome.berkeley.edu/AstroPulse_Kernels_r${AP_SVN_REV}.cl"

	AP_VER_TAG="_v${AP_VER_MAJOR}"
	cat "${FILESDIR}/app_info.xml_ap_gpu_ocl" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_AP_EXE|${AP_EXE}_gpu.ocl|g" -e "s|CFG_AP_VER_NODOT|${AP_VER_NODOT}|g" -e "s|CFG_AP_CMDLN|${AP_GPU_CMDLN}|g" -e "s|CFG_AP_VER_TAG|${AP_VER_TAG}|g" -e "s|CFG_AP_SVN_REV|${AP_SVN_REV}|g" -e "s|CFG_AP_GPU_TYPE|${AP_GPU_TYPE}|g" -e "s|CFG_AP_PLAN_CLASS|${AP_PLAN_CLASS}|g" -e "s|CFG_AP_GPU_NUM_INSTANCES|${AP_GPU_NUM_INSTANCES}|g" -e "s|CFG_NUM_GPU_INSTANCES|${NUM_GPU_INSTANCES}|g" > ${T}/app_info.xml_ap_gpu_ocl

	AP_GFX_EXE_SEC_A=""
	AP_GFX_EXE_SEC_B=""
	AP_GFX_EXE_A=""
	AP_GFX_EXE_B=""
	if use opengl ; then
		AP_GFX_MD5=`md5sum ap_graphics | awk '{print $1}'`
		AP_GFX_EXE_A="ap_graphics_gpu.ocl"
		AP_GFX_EXE_B="ap_graphics_gpu.ocl"
		AP_GFX_EXE_SEC_A=`cat ${FILESDIR}/app_info.xml_ap_gfx_1 | sed -r -e "s|CFG_AP_GFX_EXE_A|${AP_GFX_EXE_A}|g" -e "s|CFG_AP_GFX_MD5|${AP_GFX_MD5}|g"`
		AP_GFX_EXE_SEC_B=`cat ${FILESDIR}/app_info.xml_ap_gfx_2 | sed -r -e "s|CFG_AP_GFX_EXE_B|${AP_GFX_EXE_B}|g"`
		cp ap_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/ap_graphics_gpu.ocl
	fi
	cat ${T}/app_info.xml_ap_gpu_ocl | awk -v Z1="${AP_GFX_EXE_SEC_A}" -v Z2="${AP_GFX_EXE_SEC_B}" '{ sub(/CFG_AP_GFX_EXE_SEC_A/, Z1); sub(/CFG_AP_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_ap_gpu.ocl

	#cp ${FILESDIR}/cc_config.xml "${D}"/var/lib/boinc
}

#plan_class
#https://boinc.berkeley.edu/trac/wiki/AppPlan

#CPU_TYPE
#https://boinc.berkeley.edu/trac/wiki/AppCoprocessor

#plan_class
#https://setiathome.berkeley.edu/apps.php
#http://setiathome.berkeley.edu/get_project_config.php
#http://setiathome.berkeley.edu/forum_thread.php?id=78026&postid=1717477#1717477
#meaning behind zc
#http://jgopt.org/download.html
#http://setiathome.ssl.berkeley.edu/forum_thread.php?id=71728&postid=1373045#1373045
