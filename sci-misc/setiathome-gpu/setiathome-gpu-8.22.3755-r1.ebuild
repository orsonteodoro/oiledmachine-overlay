# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic subversion toolchain-funcs versionator git-r3

SETIATHOME_VERSION="$(get_version_component_range 1-2 ${PV})"
SETIATHOME_SVN_REVISION="$(get_version_component_range 3 ${PV})" # The versioning is based on https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AKv8/client folder's revision and contents of configure.ac .
SETIATHOME_GL_GRAPHICS_REVISION="1962" # 7.07 trunk
MY_P="setiathome-gpu-${SETIATHOME_VERSION}"
DESCRIPTION="Seti@Home"
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
IUSE_APIS=$( echo opengl opencl -cuda{,_6_0} )
IUSE_ARM="armv7"
IUSE="${X86_CPU_FEATURES[@]%:*} ${IUSE_GPUS} ${IUSE_APIS} ${IUSE_ARM} test custom-cflags akpf +jspf neon pgo signals-on-gpu twinchirp"
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
	sci-misc/setiathome-art:7
	sci-misc/setiathome-updater:8
"
REQUIRED_USE="video_cards_fglrx? ( video_cards_amdgpu ) !video_cards_r600
	      !video_cards_r600
              ^^ ( video_cards_nvidia video_cards_fglrx video_cards_intel video_cards_r600 video_cards_radeonsi video_cards_amdgpu )
              cuda_6_0? ( cuda )
              jspf? ( || ( cpu_flags_x86_sse2 cpu_flags_x86_sse cpu_flags_x86_sse3 ) )
              akpf? ( cpu_flags_x86_sse2 )
             "

SLOT_BOINC="7.14"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.67
	sci-misc/boinc:=
	sci-misc/setiathome-boincdir:${SLOT_BOINC}
	app-text/xmlstarlet
"

# You can define these in your per package env.
SETIATHOME_GPU_INSTANCES=${SETIATHOME_GPU_INSTANCES:=1}
SETIATHOME_CPU_INSTANCES=${SETIATHOME_CPU_INSTANCES:=1}
SAH_GPU_TYPE=${SAH_GPU_TYPE:=""} # It can be intel_gpu, ATI, NVIDIA.  This needs to be filled out if you defined SAH_GPU_CMDLN.
SAH_GPU_CMDLN=${SAH_GPU_CMDLN:=""} # See documentation below:
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AKv8/client/ReadMe_MultiBeam_OpenCL.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_Brook.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU_AMD.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_ATi.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_Intel.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV.txt
#https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV_CC1.txt

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

	export BOINC_VER=`boinc --version | awk '{print $1}'`
}

pkg_pretend() {
	if use test || use pgo ; then
		for DEVICE in $(ls /dev/*/card*)
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
	ESVN_REVISION="${SETIATHOME_SVN_REVISION}"
	ESVN_OPTIONS="--trust-server-cert"
	subversion_src_unpack
	cp -r "${ESVN_STORE_DIR}/${PN}/sah_v7_opt" "${WORKDIR}/${MY_P}" || die
	mkdir "${WORKDIR}/${MY_P}/AKv8/client/.deps" || die

	mv "${WORKDIR}/${MY_P}/AP" "${WORKDIR}/${MY_P}/AP6" || die
	mv "${WORKDIR}/${MY_P}/AP_BLANKIT" "${WORKDIR}/${MY_P}/AP" || die

	cd "${WORKDIR}/${MY_P}/AKv8" || die
	epatch "${FILESDIR}"/setiathome-7.08-makefileam-01.patch
	epatch "${FILESDIR}"/setiathome-7.08-makefileam-02.patch

	if use opengl; then
		# This is basically a reversion of the graphics removal code.
		# Removal was done to increase GPU performance and results.

		cd "${WORKDIR}/${MY_P}" || die
		epatch "${FILESDIR}"/setiathome-7.08-makefileam-sah-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfxbase.patch
		epatch "${FILESDIR}"/setiathome-8.22.3602-configureac-sah-gfx.patch


		cd "${WORKDIR}/${MY_P}/AKv8/client" || die
		ESVN_REVISION="${SETIATHOME_GL_GRAPHICS_REVISION}"
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.h" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_gfx_main.cpp" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.cpp" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/sah_version.h" || die
		wget --no-check-certificate "https://setisvn.ssl.berkeley.edu/trac/export/${ESVN_REVISION}/seti_boinc/client/graphics_main.cpp" || die

		cd "${WORKDIR}/${MY_P}"
		epatch "${FILESDIR}"/setiathome-7.08-gdatah-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-maincpp-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfxmainh-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-setih-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-workercpp-gfx.patch
		epatch "${FILESDIR}"/setiathome-7.08-maincpp-init.patch
		epatch "${FILESDIR}"/setiathome-7.08-main.cpp-graphics2.patch
		epatch "${FILESDIR}"/setiathome-7.08-setih-graphics_lib_handle.patch
		epatch "${FILESDIR}"/setiathome-7.08-analyzefuncscpp-sah_gfx_main.h.patch
		epatch "${FILESDIR}"/setiathome-7.08-workercpp-graphicsold.patch
		epatch "${FILESDIR}"/setiathome-7.08-maincpp-graphics2.patch
		epatch "${FILESDIR}"/setiathome-7.08-makefileam-amcflags.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfxh-get_sah_graphics.patch
		epatch "${FILESDIR}"/setiathome-7.08-workercpp-old.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfxcpp-glut.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfx.cpp-rarray.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-1.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-2.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-3.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-4.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-5.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-6.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-7.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-8.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-9.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-10.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-11.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-12.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-13.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-14.patch
		epatch "${FILESDIR}"/setiathome-7.08-graphics2-15.patch
		epatch "${FILESDIR}"/setiathome-7.08-seti.h-noguiso.patch
		epatch "${FILESDIR}"/setiathome-analyzepot.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-analyzereport.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-gaussfit.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-seti.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-spike.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-worker.cpp-gdatasahgraphics.patch
		epatch "${FILESDIR}"/setiathome-7.08-sahgfxcpp-buf1buf2.patch
		epatch "${FILESDIR}"/setiathome-7.08-makefileam-sahgfxbase.patch
		epatch "${FILESDIR}"/setiathome-7.08-sah_gfx_base.h-reducedarrayrender.patch
		epatch "${FILESDIR}"/setiathome-7.08-sah_gfx.cpp-cnvt_fftlen_hz.patch
		epatch "${FILESDIR}"/setiathome-7.08-sah-ap-graphics-sah.patch ##split
		epatch "${FILESDIR}"/setiathome-7.08-sah-ap-shmem-fixes.patch
		epatch "${FILESDIR}"/setiathome-7.09-sah-ap-makefileincl.patch
		epatch "${FILESDIR}"/setiathome-7.08-ap-sah-glew-sah.patch ##split
		epatch "${FILESDIR}"/setiathome-7.08-sah_gfx_base.cpp-setupgivenprefs.patch
		epatch "${FILESDIR}"/setiathome-7.08-noopengl-sah.patch ##split
		epatch "${FILESDIR}"/setiathome-gpu-7.08-sahgfxbasecpp-havegl.patch
		epatch "${FILESDIR}"/setiathome-7.08-gpu-analyzefuncscpp-removegbp.patch
		#epatch "${FILESDIR}"/setiathome-7.08-sah-sah_graphics-swi.patch
		epatch "${FILESDIR}"/setiathome-7.08-gpu-wufix.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.0-gpu-opengl-on-opencl-1.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.22.3602-gpu-opengl-on-opencl-2.patch #8.22.3602 needs testing for this patch
		epatch "${FILESDIR}"/setiathome-gpu-8.22.3602-gpu-opengl-on-opencl-3.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.0-gpu-opengl-on-opencl-4.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.22.3755-gpu-opengl-on-opencl-5.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.0-gpu-opengl-on-opencl-6.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.0-gpu-opengl-on-opencl-7.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.0-gpu-opengl-on-opencl-8.patch
	fi

	cd "${WORKDIR}/${MY_P}" || die
	epatch "${FILESDIR}"/setiathome-gpu-8.00-clang-fix.patch

	if $(version_is_at_least "7.3.19" $BOINC_VER ) ; then
		true
	else
		cd "${S}" || die
		epatch "${FILESDIR}"/setiathome-gpu-8.22.3602-boinc-compat-1.patch
		epatch "${FILESDIR}"/setiathome-gpu-8.22.3602-boinc-compat-2.patch
	fi

	epatch "${FILESDIR}"/setiathome-gpu-8.22.3602-uncomment-pulsepotnum.patch
	epatch "${FILESDIR}"/setiathome-gpu-8.22.3755-cl_boinc-header.patch

	L=$(grep -l -r -e "#define _GLIBCXX_USE_CXX11_ABI 0" .)
	for f in $L ; do
		einfo "Patching $f"
		sed -i -e "s|#define _GLIBCXX_USE_CXX11_ABI 0|//#define _GLIBCXX_USE_CXX11_ABI 0|g" $f || die
	done
}

src_prepare() {
	eapply_user

	cd "${WORKDIR}/${MY_P}/AKv8"
	AT_M4DIR="m4" eautoreconf
	chmod +x configure || die
}

src_configure() {
        append-flags -Wa,--noexecstack
	append-flags -fexceptions
	#conf run in src_compile
}

function run_config {
	local -a mycommonmakeargs
	local -a mycommonmakedefargs

	local -a mysahmakeargs
	local -a mysahmakedefargs

	local -a sahfftwlibs

	if [[ ${ARCH} =~ (amd64|ia64|arm64|ppc64|alpha) || ${host} =~ (sparc64) ]]; then
		mysahmakeargs+=( --enable-bitness=64 )
		sahfftwlibs=( -L/usr/lib64 )
	elif [[ ${ARCH} =~ (x86|i386|arm|ppc|m68k|s390|hppa) || ${host} =~ (sparc) ]] ; then
		mysahmakeargs+=( --enable-bitness=32 )
		sahfftwlibs=( -L/usr/lib32 )
	else
		ewarn "Your ARCH is not supported.  Continuing anyway..."
		sahfftwlibs=( -L/usr/lib )
	fi

	mycommonmakeargs+=( --disable-server )
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

	if [[ ${ARCH} =~ (ppc64) ]]; then
		mysahmakedefargs+=( -DUSE_PPC_G5 ) #64 bit
		mysahmakedefargs+=( -DUSE_PPC_OPTIMIZATIONS )
	elif [[ ${ARCH} =~ (ppc) ]]; then
		mysahmakedefargs+=( -DUSE_PPC_G4 ) #32 bit
		mysahmakedefargs+=( -DUSE_PPC_OPTIMIZATIONS )
	elif [[ ${ARCH} =~ (amd64|x86) ]] ; then
		mysahmakedefargs+=( -DUSE_I386_OPTIMIZATIONS ) #uses sse3 sse2
	fi

	if [[ ${ARCH} =~ (amd64) ]]; then
		mysahmakedefargs+=( -DUSE_I386_XEON )
	elif [[ ${ARCH} =~ (x86) ]] ; then
		if use cpu_flags_x86_sse || use cpu_flags_x86_sse2 || use cpu_flags_x86_sse3 ; then
			mysahmakedefargs+=( -DUSE_I386_XEON )
		fi
	fi

	if [[ ${ARCH} =~ (amd64|ia64|arm64|ppc64|alpha) || ${host} =~ (sparc64) ]]; then
		if use opencl || use cuda ; then
			mysahmakedefargs+=( -DSETI7 )
			mysahmakedefargs+=( -DSETI8 )
		elif use cpu_flags_x86_sse || use cpu_flags_x86_sse2 || use cpu_flags_x86_sse3 ; then
			mysahmakedefargs+=( -DSETI7 )
			mysahmakedefargs+=( -DSETI8 )
		fi
	elif [[ ${ARCH} =~ (x86|i386|arm|ppc|m68k|s390|hppa) || ${host} =~ (sparc) ]] ; then
		if use cpu_flags_x86_sse || use cpu_flags_x86_sse2 || use cpu_flags_x86_sse3 ; then
			mysahmakedefargs+=( -DSETI7 )
			mysahmakedefargs+=( -DSETI8 )
		elif use opencl && use ati_hd4xxx ; then
			# low end hd4k
			mysahmakedefargs+=( -DSETI7 )
		fi
	fi

	if use opencl ; then
		mysahmakedefargs+=( -DUSE_OPENCL )
		if use video_cards_fglrx ; then
			if use ati_hd4xxx ; then #ati lower hd4xxx cards
				mysahmakedefargs+=( -DLHD4K )
			elif use ati_apu ; then
                                mysahmakedefargs+=( -DUSE_OPENCL_HD5xxx )
                                mysahmakedefargs+=( -DOCL_ZERO_COPY_APU )
				mysahmakedefargs+=( -DOCL_ZERO_COPY )
			elif use ati_hd5xxx || use ati_hd6xxx || use ati_hd7xxx || use ati_rx_200 || use ati_rx_300 || use ati_rx_400 ; then
				mysahmakedefargs+=( -DUSE_OPENCL_HD5xxx )
				if use signals-on-gpu ; then
					mysahmakedefargs+=( -DSIGNALS_ON_GPU )
					mysahmakedefargs+=( -DOCL_CHIRP3 )
				fi
				if use twinchirp ; then
					mysahmakedefargs+=( -DGPU_TWINCHIRP )
				fi
				mysahmakedefargs+=( -DOCL_ZERO_COPY )
			fi
		elif use video_cards_nvidia ; then
			mysahmakedefargs+=( -DUSE_OPENCL_NV )
			if use signals-on-gpu ; then
				mysahmakedefargs+=( -DSIGNALS_ON_GPU )
				mysahmakedefargs+=( -DOCL_CHIRP3 )
			fi
			if use twinchirp ; then
				mysahmakedefargs+=( -DGPU_TWINCHIRP )
			fi
			mysahmakedefargs+=( -DOCL_ZERO_COPY )
		elif use video_cards_intel ; then
			mysahmakedefargs+=( -DUSE_OPENCL_INTEL )
			mysahmakedefargs+=( -DOCL_ZERO_COPY )
		fi
		mysahmakedefargs+=( -DOCL_CHIRP3 )
		mysahmakedefargs+=( -DASYNC_SPIKE )
	elif use cuda ; then
		mysahmakedefargs+=( -DUSE_CUDA )
	else #cpu only
		mysahmakedefargs+=( -DFFTOUT )
	fi

	sahfftwlibs+=( -lfftw3f )
	mysahmakedefargs+=( -DUSE_FFTW )

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

	if use jspf ; then
		mysahmakedefargs+=( -DUSE_JSPF )
	elif use akpf ; then
		# Enabling this will disable more optimized JSPF (Joe Segur's SSE Pulse Finding Alignment)
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

	if use armv7 ; then
		mycommonmakeargs+=( --enable-armv7 )
	fi

	if use neon ; then
		mycommonmakeargs+=( --enable-arm_neon )
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

	cd "${WORKDIR}/${MY_P}/AKv8"
	CFLAGS="${CFLAGS} ${PGO_CFLAGS}" LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}"  LIBS="${sahfftwlibs[@]} -ldl ${PGO_LIBS}" CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" CPPFLAGS="${CPPFLAGS} ${mycommonmakedefargs[@]} ${mysahmakedefargs[@]} ${PGO_CPPFLAGS}" BOINCDIR="/usr/share/boinc/$SLOT_BOINC" econf \
	${mycommonmakeargs[@]} \
	${mysahmakeargs[@]} || die
	cp "sah_config.h" "config.h" || die
}

SAH_PLAN_CLASS=""
NUM_GPU_INSTANCES=""
NUM_CPU_INSTANCES=""
SAH_GPU_NUM_INSTANCES=""

function gpu_setup {
	# TODO: update SAH_GPU_CMDLN to current generation

	if [[ -n "${SAH_GPU_CMDLN}" && -n "${SAH_GPU_TYPE}" ]] ; then
		true
	#intel low end
	elif use intel_hd || use intel_hd2xxx ; then
		SAH_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 2 1 16"
	#intel mid range
	elif use intel_hd3xxx || use intel_hd_gt1 ; then
		SAH_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 64 1 4"
	#intel high end
	elif use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
		SAH_GPU_TYPE="intel_gpu"
		SAH_GPU_CMDLN="-spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 512"

	#ati low end
	elif use ati_hdx3xx || use ati_hdx4xx || use ati_hdx5xx || use ati_rx_x2x || use ati_rx_x3x || use ati_apu ; then
		SAH_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 2 1 16"
	#ati mid range
	elif use ati_hdx6xx || use ati_hdx7xx || use ati_rx_x4x || use ati_rx_x5x || use ati_rx_x6x ; then
		SAH_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 2048 -tune 1 64 1 4"
	#ati high end
	elif use ati_hdx8xx || use ati_hdx9xx || use ati_rx_x7x || use ati_rx_x8x || use ati_rx_x9x ; then
		SAH_GPU_TYPE="ATI"
		SAH_GPU_CMDLN="-spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"

	#nv low end
	elif use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_8xxx || use nv_9xxx ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 128 -spike_fft_thresh 2048 -tune 1 2 1 16"
	elif use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_8xxx_fast || use nv_9xxx_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 128 -spike_fft_thresh 2048 -tune 1 2 1 16"
	#nv mid range
	elif use nv_x50 || use nv_x60 || use nv_x70 ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 192 -spike_fft_thresh 2048 -tune 1 64 1 4"
	elif use nv_x50_fast || use nv_x60_fast || use nv_x70_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 192 -spike_fft_thresh 2048 -tune 1 64 1 4"
	#nv high end
	elif use nv_x70 || use nv_x80 ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
	elif use nv_x70_fast || use nv_x80_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
	#nv enthusiast
	elif use nv_780ti || use nv_titan ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
	elif use nv_780ti_fast || use nv_titan_fast ; then
		SAH_GPU_TYPE="NVIDIA"
		SAH_GPU_CMDLN="-sbs 256 -spike_fft_thresh 4096 -tune 1 64 1 4 -oclfft_tune_gr 256 -oclfft_tune_lr 16 -oclfft_tune_wg 256 -oclfft_tune_ls 512 -oclfft_tune_bn 64 -oclfft_tune_cw 64"
	fi

	# See https://setiathome.berkeley.edu/apps.php for list of plan classes
	# Setting this may be important to get workunits or the proper work unit.
	if [[ ${ARCH} =~ (amd64|x86) ]]; then
		# nocal means driver or GPU doesn't support Compute Abstraction Layer (CAL) [ATI stream]
		if use ati_apu; then
			SAH_PLAN_CLASS="opencl_atiapu_sah"
		elif use ati_hd5xxx || use ati_hd6xxx || use ati_hd7xxx || use ati_rx_200 || use ati_rx_300 || use ati_rx_400; then
			if use opencl ; then
				if use video_cards_amdgpu || use video_cards_fglrx ; then
					if use signals-on-gpu ; then
						SAH_PLAN_CLASS="opencl_ati5_SoG"
					else
						SAH_PLAN_CLASS="opencl_ati5_cat132" # Catalyst 13.2 or later
					fi
				elif use video_cards_r600 ; then
					if use signals-on-gpu ; then
						SAH_PLAN_CLASS="opencl_ati5_SoG"
					else
						SAH_PLAN_CLASS="opencl_ati5_nocal"
					fi
				else
					if use signals-on-gpu ; then
						SAH_PLAN_CLASS="opencl_ati5_SoG"
					else
						SAH_PLAN_CLASS="opencl_ati5_nocal"
					fi
				fi
			else
				SAH_PLAN_CLASS=""
				ewarn "Using the fallback plan class."
			fi
		elif use ati_hd4xxx ; then
			if use opencl ; then
				if use video_cards_fglrx ; then
					SAH_PLAN_CLASS="opencl_ati_cat132"
				elif use video_cards_r600 ; then
					SAH_PLAN_CLASS="opencl_ati_nocal"
				else
					SAH_PLAN_CLASS="opencl_ati_sah"
				fi
			else
				SAH_PLAN_CLASS=""
				ewarn "Using the fallback plan class."
			fi
		elif use nv_1xx || use nv_2xx || use nv_3xx || use nv_x00 || use nv_x10 || use nv_x20 || use nv_x30 || use nv_x40 || use nv_x00_fast || use nv_x10_fast || use nv_x20_fast || use nv_x30_fast || use nv_x40_fast || use nv_x50 || use nv_x60 || use nv_x70 || use nv_x50_fast || use nv_x60_fast || use nv_x70_fast || use nv_x70 || use nv_x80 || use nv_x70_fast || use nv_x80_fast || use nv_780ti || use nv_titan || use nv_780ti_fast || use nv_titan_fast ; then
			if use opencl ; then
				if use signals-on-gpu ; then
					SAH_PLAN_CLASS="opencl_nvidia_SoG"
				elif use nv_1xx || use nv_2xx || use nv_3xx ; then
					SAH_PLAN_CLASS="opencl_nvidia_cc1"
				else
					SAH_PLAN_CLASS="opencl_nvidia_sah"
				fi
			elif use cuda ; then
				if use cuda_6_0 ; then
					SAH_PLAN_CLASS="cuda60"
				else
					SAH_PLAN_CLASS=""
					ewarn "Using the fallback plan class."
				fi
			fi
		elif use intel_hd || use intel_hd2xxx || use intel_hd3xxx || use intel_hd_gt1 || use intel_hd4xxx || use intel_hd5xxx || use intel_iris5xxx ; then
			SAH_PLAN_CLASS="opencl_intel_gpu_sah"
		else
			SAH_PLAN_CLASS=""
			ewarn "Using fallback plan class."
		fi
	elif [[ ${ARCH} =~ (ppc64) && $(use opencl) ]]; then
		SAH_PLAN_CLASS=""
		ewarn "ARCH may not supported for linux/ppc64."
		# not listed in https://setiathome.berkeley.edu/apps.php
	elif [[ ${ARCH} =~ (ppc) ]] ; then
		SAH_PLAN_CLASS=""
		ewarn "ARCH may not supported for linux/ppc."
		# not listed in https://setiathome.berkeley.edu/apps.php
	elif [[ ${ARCH} =~ (arm64|arm) ]] ; then
		SAH_PLAN_CLASS=""
	else
		SAH_PLAN_CLASS=""
		ewarn "This configuation is not supported.  Using the fallback plan class."
	fi

	NUM_GPU_INSTANCES=`bc <<< "scale=6; 1/${SETIATHOME_GPU_INSTANCES}"`
	NUM_CPU_INSTANCES=`bc <<< "scale=6; 1/${SETIATHOME_CPU_INSTANCES}"`
	SAH_GPU_CMDLN="${SAH_GPU_CMDLN} -instances_per_device ${SETIATHOME_GPU_INSTANCES} -total_GPU_instances_num ${SETIATHOME_GPU_INSTANCES}"
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
		emake || die
		cd "${WORKDIR}/${MY_P}/AKv8/client" || die
                cp test_workunits/reference_work_unit.sah work_unit.sah
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
                LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./seti_boinc -standalone ${SAH_GPU_CMDLN}
		ls result.sah || die "simulating failed"
                #diff -u test_workunits/reference_result_unit.sah result.sah
		if $(tc-is-clang) ; then
			llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
		fi
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
		emake || die
	else
		cd "${WORKDIR}/${MY_P}/AKv8" || die
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
		emake || die
	fi
}

src_install() {
	mkdir -p "${D}/var/lib/boinc/projects/setiathome.berkeley.edu" || die

	gpu_setup

	cd "${WORKDIR}/${MY_P}/AKv8"
	SAH_VER_NODOT=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" -e "s|\.||g"`
	SAH_VER_MAJOR=`cat configure.ac | grep AC_INIT | awk '{print $2}' | sed -r -e "s|,||g" | cut -d. -f1`
	SAH_SVN_REV=`grep -r -e "SVN_REV_NUM" ./configure.ac | grep AC_SUBST | tail -n 1 | grep -o -e "[0-9]*"`
	cd "${WORKDIR}/${MY_P}/AKv8/client" || die
	SAH_EXE=`ls MB* | sed -r -e "s| |\n|g" | grep "clGPU"`
	cp ${SAH_EXE} "${D}"/var/lib/boinc/projects/setiathome.berkeley.edu/${SAH_EXE}_gpu.ocl || die

	cd "${WORKDIR}/${MY_P}/AKv8/client" || die
	cp MultiBeam_Kernels.cl "${D}/var/lib/boinc/projects/setiathome.berkeley.edu/MultiBeam_Kernels_r${SAH_SVN_REV}.cl" || die

	# testing commenting out 20190318
	#SAH_PLAN_CLASS="" #none on v8

	SAH_VER_TAG="_v${SAH_VER_MAJOR}"
	cat "${FILESDIR}/app_info.xml_sah_gpu_ocl" | sed -r -e "s|CFG_BOINC_VER|${BOINC_VER}|g" -e "s|CFG_SAH_EXE|${SAH_EXE}_gpu.ocl|g" -e "s|CFG_SAH_VER_NODOT|${SAH_VER_NODOT}|g" -e "s|CFG_SAH_CMDLN|${SAH_GPU_CMDLN}|g" -e "s|CFG_SAH_VER_TAG|${SAH_VER_TAG}|g" -e "s|CFG_SAH_SVN_REV|${SAH_SVN_REV}|g" -e "s|CFG_SAH_GPU_TYPE|${SAH_GPU_TYPE}|g" -e "s|CFG_SAH_PLAN_CLASS|${SAH_PLAN_CLASS}|g"  -e "s|CFG_SAH_GPU_NUM_INSTANCES|${SAH_GPU_NUM_INSTANCES}|g" -e "s|CFG_NUM_GPU_INSTANCES|${NUM_GPU_INSTANCES}|g" > ${T}/app_info.xml_sah_gpu_ocl || die

	SAH_GFX_EXE_SEC_A=""
	SAH_GFX_EXE_SEC_B=""
	SAH_GFX_EXE_A=""
	SAH_GFX_EXE_B=""
	if use opengl ; then
		SAH_GFX_MD5=`md5sum seti_graphics | awk '{print $1}'`
		SAH_GFX_EXE_A="seti_graphics_gpu.ocl"
		SAH_GFX_EXE_B="seti_graphics_gpu.ocl"
		SAH_GFX_EXE_SEC_A=`cat ${FILESDIR}/app_info.xml_sah_gfx_1 | sed -r -e "s|CFG_SAH_GFX_EXE_A|${SAH_GFX_EXE_A}|g" -e "s|CFG_SAH_GFX_MD5|${SAH_GFX_MD5}|g"`
		SAH_GFX_EXE_SEC_B=`cat ${FILESDIR}/app_info.xml_sah_gfx_2 | sed -r -e "s|CFG_SAH_GFX_EXE_B|${SAH_GFX_EXE_B}|g"`
		cp seti_graphics ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/seti_graphics_gpu.ocl || die
	fi
	cat ${T}/app_info.xml_sah_gpu_ocl | awk -v Z1="${SAH_GFX_EXE_SEC_A}" -v Z2="${SAH_GFX_EXE_SEC_B}" '{ sub(/CFG_SAH_GFX_EXE_SEC_A/, Z1); sub(/CFG_SAH_GFX_EXE_SEC_B/, Z2); print; }' >> ${D}/var/lib/boinc/projects/setiathome.berkeley.edu/app_info.xml_sah_gpu.ocl || die
}

pkg_postinst() {
	/usr/bin/setiathome-updater
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
