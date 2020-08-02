# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

ASTROPULSE_VERSION="$(get_version_component_range 1-2 ${PV})"
ASTROPULSE_SVN_REVISION="$(get_version_component_range 3 ${PV})" #The version matches https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client folder's revision.
SETIATHOME_SVN_REVISION="3701" #match setiathome-gpu
MY_P="astropulse-gpu-${ASTROPULSE_VERSION}"
DESCRIPTION="Astropulse"
HOMEPAGE="http://setiathome.ssl.berkeley.edu/"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="$(get_major_version)"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"

X86_CPU_FEATURES_RAW=( avx2 avx avx-btver2 avx-bdver3 avx-bdver2 avx-bdver1 sse42 sse41 ssse3 sse3 sse2 sse mmx 3dnow )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
#cuda only supported on windows
IUSE_GPUS_AMD=$( echo video_cards_{amdgpu,fglrx,radeonsi,r600} ati_hd{4,5,6,7}xxx ati_hdx{3,4,5,6,7,8,9}xx ati_rx_{2,3,4}00 ati_rx_x{2,3,4,5,6,7,8,9}x ati_apu )
IUSE_GPUS_NVIDIA=$( echo video_cards_nvidia nv_{1,2,3,4,5,6,7,8,9}xx nv_x{0,1,2,3,4,5,6,7,8}0{,_fast} nv_780ti nv_titan nv_780ti_fast nv_titan_fast nv_{8,9}xxx nv_{8,9}xxx_fast )
IUSE_GPUS_INTEL=$( echo video_cards_intel intel_hd intel_hd{2,3,4,5}xxx intel_hd_gt1 intel_iris5xxx )
IUSE_GPUS="${IUSE_GPUS_AMD} ${IUSE_GPUS_NVIDIA} ${IUSE_GPUS_INTEL}"
IUSE_APIS=$( echo opengl opencl -cuda )
IUSE="${X86_CPU_FEATURES[@]%:*} ${IUSE_GPUS} ${IUSE_APIS} test custom-cflags core2 pgo"
REQUIRED_USE=""

RDEPEND="
	sci-libs/fftw:=[static-libs]
	opencl? (
		|| (
			virtual/opencl
			dev-util/nvidia-cuda-sdk[opencl]
			video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
			video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
		)
	)
	sci-misc/astropulse-art:7
	sci-misc/setiathome-updater:8
"
REQUIRED_USE="video_cards_fglrx? ( video_cards_amdgpu )
	      !video_cards_r600
              ^^ ( video_cards_nvidia video_cards_fglrx video_cards_intel video_cards_r600 video_cards_radeonsi video_cards_amdgpu )
             "

SLOT_BOINC="7.14"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.67
	opencl? ( video_cards_amdgpu? ( dev-util/amdapp ) )
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:${SLOT_BOINC}
"

# You can define these in your per package env flags.
AP_GPU_INSTANCES=${AP_GPU_INSTANCES:=1}
AP_CPU_INSTANCES=${AP_CPU_INSTANCES:=1}
AP_GPU_TYPE=${AP_GPU_TYPE:=""} # This can be ATI, NVIDIA, intel_gpu.  This needs to be provided if you defined AP_GPU_CMDLN.
AP_GPU_CMDLN=${AP_GPU_CMDLN:=""} # See documents below:
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_Brook.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU_AMD.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_ATi.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_Intel.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV.txt
# https://setisvn.ssl.berkeley.edu/trac/export/4014/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV_CC1.txt

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use video_cards_amdgpu ; then
		if [[ -d /opt/AMDAPP/include/ ]] ; then
			true
		elif [[ -f /usr/lib64/OpenCL/vendors/amdgpu/include/CL/cl.h ]] ; then
			true
		else
			die "You need the amdgpu-pro ebuild from oiledmachine-overlay or the amdapp ebuild."
		fi
	fi

	if use video_cards_fglrx ; then
		/opt/bin/clinfo | grep "CL_DEVICE_TYPE_GPU"
		if [[ "$?" != "0" ]] ; then
			eerror "Your video card driver has broken OpenCL support for GPUs."
			eerror "15.12 beta fglrx driver is broken for GPU OpenCL support."
			eerror "You can use >=15.11 but you need the ati-opencl package from the oiledmachine overlay."
			die
		fi
	elif use video_cards_r600 ; then
		#see https://www.x.org/wiki/RadeonFeature/#Decoder_ring_for_engineering_vs_marketing_names
		die "Mesa Clover (open source OpenCL implementation) is not supported.  Use the proprietary driver."
	elif use video_cards_radeonsi ; then
		#see https://www.x.org/wiki/RadeonFeature/#Decoder_ring_for_engineering_vs_marketing_names
		ewarn "Mesa Clover (open source OpenCL implementation) is not supported but may work.  Use the proprietary driver if it fails."
	fi

	if $(tc-is-clang) ; then
		ewarn "The configure script may fail with clang.  Switch to gcc if it fails."
	fi

	export BOINC_VER=`boinc --version | awk '{print $1}'`
}

pkg_pretend() {
	if use test || use pgo ; then
		DEVICES_DRM_RENDER_NODES=""
		if use video_cards_amdgpu ;  then
			DEVICES_DRM_RENDER_NODES=$(ls /dev/dri/renderD*)
		fi
	        for DEVICE in $(ls /dev/*/card*) ${DEVICES_DRM_RENDER_NODES}
	        do
	                cat /etc/sandbox.conf | grep -e "${DEVICE}"
	                if [ $? == 1 ] ; then
				if [ -e ${DEVICE} ] ; then
		                        die "SANDBOX_WRITE=\"${DEVICE}\" needs to be added to /etc/sandbox.conf"
				fi
	                fi
	        done
	fi
}

src_unpack() {
	ESVN_REPO_URI="https://setisvn.ssl.berkeley.edu/svn/branches/sah_v7_opt"
        ESVN_REVISION="${ASTROPULSE_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
        subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/sah_v7_opt" "${WORKDIR}/${MY_P}" || die
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps" || die

	mv "${WORKDIR}/${MY_P}/AP" "${WORKDIR}/${MY_P}/AP6" || die
	mv "${WORKDIR}/${MY_P}/AP_BLANKIT" "${WORKDIR}/${MY_P}/AP" || die

	cd "${WORKDIR}/${MY_P}" || die
	epatch "${FILESDIR}"/astropulse-7.00-apclientmaincpp.patch #1

	if use opengl ; then
		# As explained in the setiathome-gpu ebuild.  This is just a reversion of the removal of the feature.
		# The feature was removed to increase returned results and performance to eliminate a potential bottleneck.

		epatch "${FILESDIR}"/setiathome-7.08-makefileam-ap-gfx.patch #10
		epatch "${FILESDIR}"/setiathome-7.08-configureac-ap-gfx.patch #9

		cd "${WORKDIR}/${MY_P}/AKv8/client" || die
	        ESVN_REVISION="${SETIATHOME_SVN_REVISION}"
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.h" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.cpp" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.cpp" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.h" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/graphics_main.cpp" || die

		cd "${WORKDIR}/${MY_P}" || die
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
	fi

	sed -i -e "s|#define _GLIBCXX_USE_CXX11_ABI 0|//#define _GLIBCXX_USE_CXX11_ABI 0|g" src/GPU_lock.cpp || die
	sed -i -e "s|#define _GLIBCXX_USE_CXX11_ABI 0|//#define _GLIBCXX_USE_CXX11_ABI 0|g" sah_v7_opt/src/GPU_lock.cpp || die

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
	chmod +x configure || die

	if use test || use pgo ; then
		if use video_cards_intel ; then
			VIDEO_CARD="intel_gpu"
		elif use video_cards_amdgpu || use video_cards_fglrx ; then
			VIDEO_CARD="ATI"
		elif use video_cards_nvidia ; then
			VIDEO_CARD="NVIDIA"
		else
			die "only intel, amdgpu, fglrx, nvidia supported"
		fi
	fi
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

	append-flags -Wa,--noexecstack

	if [[ ${ARCH} =~ (amd64|ia64|arm64|ppc64|alpha) || ${host} =~ (sparc64) ]]; then
		apfftwlibs=( -L/usr/lib64 )
	elif [[ ${ARCH} =~ (x86|i386|arm|ppc|m68k|s390|hppa) || ${host} =~ (sparc) ]] ; then
		apfftwlibs=( -L/usr/lib32 )
	else
		ewarn "Your ARCH is not supported.  Continuing anyway..."
		apfftwlibs=( -L/usr/lib )
	fi

	#mycommonmakeargs+=( --disable-server )
	mycommonmakeargs+=( --enable-client )
	mycommonmakeargs+=( --disable-static-client )
	#mycommonmakeargs+=( --disable-intrinsics ) #enabling breaks compile

	mycommonmakedefargs+=( -D_GNU_SOURCE )

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
		if $(tc-is-gcc) ; then
			if [ ! -d /usr/include/isl ] ; then
				mycommonmakeargs+=( --disable-comoptions )
			else
				# You need gcc[graphite] to use this.
				mycommonmakeargs+=( --enable-comoptions )
			fi
		fi
	fi

	if use core2 ; then
		mycommonmakedefargs+=( -DUSE_I386_CORE2 )
	fi

	if use cpu_flags_x86_avx2 ; then
		mycommonmakeargs+=( --enable-avx2 )
		mycommonmakedefargs+=( -DUSE_AVX2 )
	elif use cpu_flags_x86_avx-btver2 ; then
		mycommonmakeargs+=( --enable-btver2 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_avx-bdver3 ; then
		mycommonmakeargs+=( --enable-bdver3 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_avx-bdver2 ; then
		mycommonmakeargs+=( --enable-bdver2 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_avx-bdver1 ; then
		mycommonmakeargs+=( --enable-bdver1 )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_avx ; then
		mycommonmakeargs+=( --enable-avx )
		mycommonmakedefargs+=( -DUSE_AVX )
	elif use cpu_flags_x86_sse42 ; then
		mycommonmakeargs+=( --enable-sse42 )
		mycommonmakedefargs+=( -DUSE_SSE42 )
	elif use cpu_flags_x86_sse41 ; then
		mycommonmakeargs+=( --enable-sse41 )
		mycommonmakedefargs+=( -DUSE_SSE41 )
	elif use cpu_flags_x86_ssse3 ; then
		mycommonmakeargs+=( --enable-ssse3 )
		mycommonmakedefargs+=( -DUSE_SSSE3 )
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

	mycommonmakeargs+=( --enable-fast-math )

	if use video_cards_amdgpu ; then
		if [[ -f /usr/lib64/OpenCL/vendors/amdgpu/include/CL/cl.h ]] ; then
			append-cppflags -I/usr/lib64/OpenCL/vendors/amdgpu/include/
		else
			append-cppflags -I/opt/AMDAPP/include/
		fi
	elif use video_cards_r600 || use video_cards_intel ; then
		append-cppflags -I/usr/$(get_libdir)/OpenCL/vendors/mesa/include/
	# todo: nvidia?
	fi

	cd "${WORKDIR}/${MY_P}/AP/client"
	CFLAGS="${CFLAGS} ${PGL_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}" LIBS="${apfftwlibs[@]} ${asmlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${myapmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$SLOT_BOINC" BOINC_DIR="/usr/share/boinc/$SLOT_BOINC" SETI_BOINC_DIR="${WORKDIR}/${MY_P}/AKv8" econf \
	${mycommonmakeargs[@]} \
	${myapmakeargs[@]} || die
}

AP_PLAN_CLASS=""
NUM_GPU_INSTANCES=""
NUM_CPU_INSTANCES=""
AP_GPU_NUM_INSTANCES=""

function gpu_setup {
	if [[ -n "${AP_GPU_CMDLN}" && -n "${AP_GPU_TYPE}" ]] ; then
		true
	#intel low end
	elif use intel_hd || use intel_hd2xxx ; then
		AP_GPU_TYPE="intel_gpu"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	#intel mid range
	elif use intel_hd3xxx || use intel_hd_gt1 ; then
		AP_GPU_TYPE="intel_gpu"
		AP_GPU_CMDLN="-unroll 10 -ffa_block 6144 -ffa_block_fetch 1536"
	#intel high end
	elif use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
		AP_GPU_TYPE="intel_gpu"
		AP_GPU_CMDLN="-unroll 12 -ffa_block 8192 -ffa_block_fetch 4096"

	#ati low end
	elif use ati_hdx3xx || use ati_hdx4xx || use ati_hdx5xx || use ati_rx_x2x || use ati_rx_x3x || use ati_apu ; then
		AP_GPU_TYPE="ATI"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	#ati mid range
	elif use ati_hdx6xx || use ati_hdx7xx || use ati_rx_x4x || use ati_rx_x5x || use ati_rx_x6x ; then
		AP_GPU_TYPE="ATI"
		AP_GPU_CMDLN="-unroll 12 -oclFFT_plan 256 16 256 -ffa_block 12288 -ffa_block_fetch 6144 -tune 1 64 4 1 -tune 2 64 4 1"
	#ati high end
	elif use ati_hdx8xx || use ati_hdx9xx || use ati_rx_x7x || use ati_rx_x8x || use ati_rx_x9x ; then
		AP_GPU_TYPE="ATI"
		AP_GPU_CMDLN="-unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 4 1 -tune 2 64 4 1"

	#nv low end
	elif use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_8xxx || use nv_9xxx ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-unroll 4 -ffa_block 2048 -ffa_block_fetch 1024"
	elif use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_8xxx_fast || use nv_9xxx_fast ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-use_sleep -unroll 4 -oclFFT_plan 256 16 1024"
	#nv mid range
	elif use nv_x50 || use nv_x60 || use nv_x70 ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-unroll 10 -ffa_block 6144 -ffa_block_fetch 1536"
	elif use nv_x50_fast || use nv_x60_fast || use nv_x70_fast ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-use_sleep -unroll 10 -oclFFT_plan 256 16 512 -ffa_block 12288 -ffa_block_fetch 6144"
	#nv high end
	elif use nv_x70 || use nv_x80 ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-unroll 12 -ffa_block 12288 -ffa_block_fetch 6144"
	elif use nv_x70_fast || use nv_x80_fast ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-use_sleep -unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 8 1 -tune 2 64 8 1"
	#nv enthusiast
	elif use nv_780ti || use nv_titan ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-unroll 16 -ffa_block 16384 -ffa_block_fetch 8192"
	elif use nv_780ti_fast || use nv_titan_fast ; then
		AP_GPU_TYPE="NVIDIA"
		AP_GPU_CMDLN="-use_sleep -unroll 18 -oclFFT_plan 256 16 256 -ffa_block 16384 -ffa_block_fetch 8192 -tune 1 64 8 1 -tune 2 64 8 1"

	fi

	# It may fail to fetch if it is not configured correct.
	if [[ ${ARCH} =~ (amd64|x86) ]]; then
		if use ati_hd4xxx || use ati_hd5xxx || use ati_hd6xxx || use ati_hd7xxx || use ati_rx_200 || use ati_rx_300 || use ati_rx_400 || use ati_apu ; then
			if use opencl ; then
				AP_PLAN_CLASS="opencl_ati_100"
			elif use cpu_flags_x86_sse2 ; then
				ewarn "Using only GPU and SSE2.  You need opencl for GPU acceleration."
				AP_PLAN_CLASS="sse2"
			elif use cpu_flags_x86_sse ; then
				ewarn "Using only GPU and SSE.  You need opencl for GPU acceleration."
				AP_PLAN_CLASS="sse"
			else
				ewarn "Using the fallback plan class.  You need opencl for GPU acceleration."
				AP_PLAN_CLASS=""
			fi
		elif use nv_1xx || use nv_2xx || use nv_3xx || use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_x50 || use nv_x60 || use nv_x70 || use nv_x50_fast || use nv_x60_fast || use nv_x70_fast || use nv_x70 || use nv_x80 || use nv_x70_fast || use nv_x80_fast || use nv_780ti || use nv_titan || use nv_780ti_fast || use nv_titan_fast ; then
			if use opencl ; then
				if use nv_1xx || use nv_2xx || use nv_3xx ; then
					AP_PLAN_CLASS="opencl_nvidia_cc1"
				else
					AP_PLAN_CLASS="opencl_nvidia_100"
				fi
			elif use cuda ; then
				if use nv_1xx || use nv_2xx || use nv_3xx ; then
					AP_PLAN_CLASS="cuda_opencl_cc1"
				else
					AP_PLAN_CLASS="cuda_opencl_100"
				fi
			elif use cpu_flags_x86_sse2 ; then
				ewarn "Using only GPU and SSE2.  You need opencl or cuda for GPU acceleration."
				AP_PLAN_CLASS="sse2"
			elif use cpu_flags_x86_sse ; then
				ewarn "Using only GPU and SSE.  You need opencl or cuda for GPU acceleration."
				AP_PLAN_CLASS="sse"
			else
				ewarn "Using the fallback plan class.  You need opencl or cuda for GPU acceleration."
				AP_PLAN_CLASS=""
			fi
		elif use intel_hd || use intel_hd2xxx || use intel_hd3xxx || use intel_hd_gt1 || use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
			AP_PLAN_CLASS=""
			ewarn "Intel GPUs may not be supported.  Using the fallback plan class."
			# none listed in https://setiathome.berkeley.edu/apps.php for linux
		elif use cpu_flags_x86_sse2 ; then
			AP_PLAN_CLASS="sse2"
			ewarn "No specific GPU chosen.  Consider re-emerging with proper GPU.  Using the FPU and SSE only."
		else
			AP_PLAN_CLASS=""
			ewarn "Using the fallback plan class."
		fi
	elif [[ ${ARCH} =~ (ppc64) && $(use opencl) ]]; then
		AP_PLAN_CLASS=""
		ewarn "PPC64 may not be supported."
		# none listed in https://setiathome.berkeley.edu/apps.php
	elif [[ ${ARCH} =~ (ppc) ]] ; then
		AP_PLAN_CLASS=""
		ewarn "PPC may not be supported."
		# none listed in https://setiathome.berkeley.edu/apps.php
	elif [[ ${ARCH} =~ (arm64|arm) ]] ; then
		AP_PLAN_CLASS=""
		ewarn "ARM/ARM6 may not be supported."
		# As for the reason above.
	else
		AP_PLAN_CLASS=""
		ewarn "This configuration may not be supported.  Using fallback plan class."
	fi

	NUM_GPU_INSTANCES=`bc <<< "scale=6; 1/${AP_GPU_INSTANCES}"`
	NUM_CPU_INSTANCES=`bc <<< "scale=6; 1/${AP_CPU_INSTANCES}"`
	AP_GPU_CMDLN="${AP_GPU_CMDLN} -instances_per_device ${AP_GPU_INSTANCES} -total_GPU_instances_num ${AP_GPU_INSTANCES}"
	AP_GPU_NUM_INSTANCES="${AP_GPU_INSTANCES}"
}

src_compile() {
	gpu_setup

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
		AP_SVN_REV=`grep -r -e "SVN_REV_NUM" ./configure.ac | grep AC_SUBST | tail -n 1 | grep -o -e "[0-9]*"`
		cp AstroPulse_Kernels.cl "AstroPulse_Kernels_r${AP_SVN_REV}.cl"
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./ap_client -standalone ${AP_GPU_CMDLN}
                ls pulse.out || die "simulating failed"
                #diff -u pulse.out pulse.out.ref
		if $(tc-is-clang) ; then
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
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu" || die

	gpu_setup

	cd "${WORKDIR}/${MY_P}/AP/client" || die
	AP_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g" -e "s|\)||g"`
	AP_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	AP_SVN_REV=`grep -r -e "SVN_REV_NUM" ./configure.ac | grep AC_SUBST | tail -n 1 | grep -o -e "[0-9]*"`
	AP_EXE=`ls ap_* | sed -r -e "s| |\n|g" | grep "clGPU"`
	cp ${AP_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${AP_EXE}_gpu.ocl || die

	cd "${WORKDIR}/${MY_P}/AP/client" || die
	cp AstroPulse_Kernels.cl "${D}/var/lib/boinc/projects/setiathome.berkeley.edu/AstroPulse_Kernels_r${AP_SVN_REV}.cl" || die

	AP_VER_TAG="_v${AP_VER_MAJOR}"
	cat "${FILESDIR}/app_info.xml_ap_gpu_ocl" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_AP_EXE|${AP_EXE}_gpu.ocl|g" -e "s|CFG_AP_VER_NODOT|${AP_VER_NODOT}|g" -e "s|CFG_AP_CMDLN|${AP_GPU_CMDLN}|g" -e "s|CFG_AP_VER_TAG|${AP_VER_TAG}|g" -e "s|CFG_AP_SVN_REV|${AP_SVN_REV}|g" -e "s|CFG_AP_GPU_TYPE|${AP_GPU_TYPE}|g" -e "s|CFG_AP_PLAN_CLASS|${AP_PLAN_CLASS}|g" -e "s|CFG_AP_GPU_NUM_INSTANCES|${AP_GPU_NUM_INSTANCES}|g" -e "s|CFG_NUM_GPU_INSTANCES|${NUM_GPU_INSTANCES}|g" > ${T}/app_info.xml_ap_gpu_ocl || die

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
		cp ap_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/ap_graphics_gpu.ocl || die
	fi
	cat ${T}/app_info.xml_ap_gpu_ocl | awk -v Z1="${AP_GFX_EXE_SEC_A}" -v Z2="${AP_GFX_EXE_SEC_B}" '{ sub(/CFG_AP_GFX_EXE_SEC_A/, Z1); sub(/CFG_AP_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_ap_gpu.ocl || die
}

pkg_postinst() {
	/usr/bin/setiathome-updater
}

# CPU_TYPE
# https://boinc.berkeley.edu/trac/wiki/AppCoprocessor

# plan_class
# https://boinc.berkeley.edu/trac/wiki/AppPlan
# https://setiathome.berkeley.edu/apps.php
# http://setiathome.berkeley.edu/get_project_config.php
# http://setiathome.berkeley.edu/forum_thread.php?id=78026&postid=1717477#1717477
# meaning behind zc
# http://jgopt.org/download.html
# http://setiathome.ssl.berkeley.edu/forum_thread.php?id=71728&postid=1373045#1373045
