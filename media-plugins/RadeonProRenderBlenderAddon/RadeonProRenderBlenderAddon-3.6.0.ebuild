# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U18, U20

# Essentially if it is >= GCN 1.x it is supported.
AMDGPU_TARGETS_COMPAT=(
# From dev-libs/rocm-device-libs:5.3
# For names, see
# https://llvm.org/docs/AMDGPUUsage.html
# https://en.wikipedia.org/wiki/Template:AMD_GPU_features
	gfx600
	gfx601
	gfx602
	gfx700
	gfx701
	gfx702
	gfx703
	gfx704
	gfx705
	gfx801
	gfx802
	gfx803
	gfx805
	gfx810
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx909
	gfx940
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
)
AMDGPU_TARGETS_UNTESTED=(
## = Supported by general matching
#	gfx600
#	gfx601
#	gfx602
	gfx700
#	gfx701
##	gfx702
	gfx703
#	gfx704
	gfx705
	gfx801
##	gfx802
#	gfx803
#	gfx805
	gfx810
#	gfx900
	gfx902
	gfx904
##	gfx906
##	gfx908
	gfx909
	gfx940
##	gfx90a
	gfx90c
##	gfx1010
	gfx1011
##	gfx1012
	gfx1013
#	gfx1030
##	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
)
CUDA_TARGETS_COMPAT=(
# For names, see https://en.wikipedia.org/wiki/CUDA
	sm_35
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_87
	sm_89
	sm_90
)
CUDA_TARGETS_UNTESTED=(
#	sm_35
#	sm_37
#	sm_50
#	sm_52
#	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_87
	sm_89
	sm_90
)
LEGACY_TBB_SLOT="2" # https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSharedComponents/blob/master/OpenVDB/include/tbb/tbb_stddef.h
LLVM_COMPAT=( 15 )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
# LLVM versions supported by Blender:
# =media-gfx/blender-9999 (4.2.0 alpha) :: 17 16 15
# =media-gfx/blender-3.6* :: 16 15 14 13 12 11
# =media-gfx/blender-3.5* :: 13 12 11
# =media-gfx/blender-3.4* :: 13 12 11
# =media-gfx/blender-3.3* :: 13 12 11

BLENDER_SLOTS=(
	blender-3_3 # python3_11 .. python3_10
	blender-3_4 # python3_11 .. python3_10
	blender-3_5 # python3_11 .. python3_10
)
CONFIGURATION="release"
# Ceiling values based on python compatibility matching the particular Blender
# version
MAX_BLENDER_PV="3.6" # Exclusive
MIN_BLENDER_PV="2.93"
NV_DRIVER_VERSION_OCL_1_2="368.39" # >= OpenCL 1.2
NV_DRIVER_VERSION_VULKAN="390.132"
PLUGIN_NAME="rprblender"
# It supports Python 3.7 to 3.10, but they are deprecated in this distro in
# python-utils-r1.eclass.
PYTHON_COMPAT=( "python3_11" )
# Commits are based on left side.  The commit associated with the message
# (right) differs with the commit associated with the folder (left) on the
# GitHub website.
HIPBIN_COMMIT="1fc712e1e5912db2a732bbe046691523e64fd93c"
HIPBIN_DF="RadeonProRenderSDKKernels-${HIPBIN_COMMIT:0:7}.tar.gz"
ROCM_SLOTS=(
	rocm_5_3
)
RPIPSDK_COMMIT="76068b7ca29aa8a7f29f65475f334981f0dd5e53"
RPIPSDK_DF="RadeonImageFilter-${RPIPSDK_COMMIT:0:7}.tar.gz"
RPRSC_COMMIT="6608117fcddd783e81b2aedc2c1abdf0b449d465"
RPRSC_DF="RadeonProRenderSharedComponents-${RPRSC_COMMIT:0:7}.tar.gz"
RPRSDK_COMMIT="c61d7d3d56b0953d052ad561259d58e9c9a96f8f"
RPRSDK_DF="RadeonProRenderSDK-${RPRSDK_COMMIT:0:7}.tar.gz"
VIDEO_CARDS="
	video_cards_amdgpu
	video_cards_intel
	video_cards_nvidia
"

inherit check-reqs git-r3 linux-info python-single-r1 unpacker

KEYWORDS="~amd64"

# Download limits?
#https://github.com/GPUOpen-LibrariesAndSDKs/RadeonImageFilter/archive/${RPIPSDK_COMMIT}.tar.gz
#	-> ${RPIPSDK_DF}

S="${WORKDIR}/${P}"
S_HIPBIN="${WORKDIR}/RadeonProRenderSDKKernels-${HIPBIN_COMMIT}"
S_RPIPSDK="${WORKDIR}/${P}/RadeonProImageProcessingSDK"
S_RPRSDK="${WORKDIR}/RadeonProRenderSDK-${RPRSDK_COMMIT}"
S_RPRSC="${WORKDIR}/RadeonProRenderSharedComponents-${RPRSC_COMMIT}"
SRC_URI="
https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDK/archive/${RPRSDK_COMMIT}.tar.gz
	-> ${RPRSDK_DF}
https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSharedComponents/archive/${RPRSC_COMMIT}.tar.gz
	-> ${RPRSC_DF}
https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDKKernels/archive/${HIPBIN_COMMIT}.tar.gz
	-> ${HIPBIN_DF}
"

DESCRIPTION="A Blender® rendering plug-in for accurate ray-tracing to produce \
images and animations of scenes and providing real-time interactive \
rendering and continuous adjustment of effects."
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
# The default license is Apache-2.0, the rest are third party.
RPIPSDK_LICENSE="
	Apache-2.0
	MIT
	UoI-NCSA
"
RPRSC_LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	MIT
	MPL-2.0
"
RPRSDK_LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	BSD
	BSD-2
	CC0-1.0
	Khronos-IP-framework
	MIT
"
# See https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/v3.6.0/src/rprblender/EULA.html
RPRBLENDER_EULA_LICENSE="
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES
	BSD
	CC-BY
	Khronos-IP-framework
	MIT
	PSF-2
	SPA-DISCLAIMER-DATA-AND-SOFTWARE
"
LICENSE="
	${RPRSC_LICENSE}
	${RPRSDK_LICENSE}
	${RPIPSDK_LICENSE}
	${RPRBLENDER_EULA_LICENSE}
	Apache-2.0
"
# The distro's Apache-2.0 license template does not contain all-rights-reserved.
# The distro's MIT license template does not contain all-rights-reserved.
RESTRICT="mirror strip"
SLOT="0/${CONFIGURATION}"
IUSE+="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${BLENDER_SLOTS[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
${VIDEO_CARDS}
denoiser +hip intel-ocl +matlib +opencl +rocr +vulkan
"
gen_amdgpu_opencl_required_use() {
	local g
	for g in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		if [[ "${g}" =~ ^("gfx6"|"gfx7") ]] ; then
			echo "
				amdgpu_targets_${g}? (
					!rocr
				)
			"
		fi
		if [[ "${g}" =~ ^("gfx9"|"gfx10"|"gfx11") ]] ; then
			echo "
				amdgpu_targets_${g}? (
					rocr
				)
			"
		fi
	done
}
gen_amdgpu_required_use() {
	local g
	for g in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${g}? (
				video_cards_amdgpu
			)
		"
	done
}
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	$(gen_amdgpu_required_use)
	blender-3_3? (
		python_single_target_python3_11
	)
	blender-3_4? (
		python_single_target_python3_11
	)
	blender-3_5? (
		python_single_target_python3_11
	)
	opencl? (
		$(gen_amdgpu_opencl_required_use)
	)
	rocm_5_3? (
		llvm_slot_15
	)
	rocr? (
		video_cards_amdgpu
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	video_cards_amdgpu? (
		|| (
			${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
	)
	video_cards_nvidia? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	|| (
		${BLENDER_SLOTS[@]}
	)
	|| (
		hip
		opencl
	)
"
# Assumes U 18.04.03 minimal
CDEPEND_NOT_LISTED="
	dev-lang/python[xml]
	sys-devel/gcc[cxx,openmp]
"
# These are mentioned in the command line output and downloaded after install.
# They are not really used on linux since athena_send is disabled on Linux but
# may crash if not installed.
# For details see,
#   src/rprblender/utils/install_libs.py
PIP_DOWNLOADED="
	$(python_gen_cond_dep '
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
gen_omp_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				media-gfx/blender[llvm_slot_${s}]
			)
		"
	done
}
RDEPEND_NOT_LISTED="
	${PIP_DOWNLOADED}
	dev-libs/libbsd
	dev-libs/libffi
	virtual/libc
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	denoiser? (
		dev-lang/vtune
		|| (
			$(gen_omp_depends)
		)
		|| (
			(
				 <dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
				>=dev-cpp/tbb-2020.1:${LEGACY_TBB_SLOT}=
			)
			(
				 <dev-cpp/tbb-2021:0=
				>=dev-cpp/tbb-2020.1:0=
			)
		)
	)
"
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.6.0/README-LNX.md#addon-runuse-linux-ubuntu-requirements

BLENDER_RDEPEND="
	blender-3_3? (
		=media-gfx/blender-3.3*[${PYTHON_SINGLE_USEDEP}]
	)
	blender-3_4? (
		=media-gfx/blender-3.4*[${PYTHON_SINGLE_USEDEP}]
	)
	blender-3_5? (
		=media-gfx/blender-3.5*[${PYTHON_SINGLE_USEDEP}]
	)
"

RDEPEND+="
	${BLENDER_RDEPEND}
	${CDEPEND_NOT_LISTED}
	${RDEPEND_NOT_LISTED}
	>=media-libs/embree-2.12.0
	>=media-libs/openimageio-1.6
	>=media-libs/freeimage-3.17.0[jpeg,jpeg2k,openexr,png,raw,tiff,webp]
	hip? (
		dev-util/hip:5.3
	)
	matlib? (
		media-plugins/RadeonProRenderMaterialLibrary
	)
	opencl? (
		intel-ocl? (
			dev-util/intel-ocl-sdk
		)
		|| (
			video_cards_amdgpu? (
				!rocr? (
					dev-libs/amdgpu-pro-opencl-legacy
				)
				rocr? (
					rocm_5_3? (
						dev-libs/rocm-opencl-runtime:5.3
					)
				)
			)
			video_cards_intel? (
				dev-libs/intel-compute-runtime
			)
			video_cards_nvidia? (
				>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_OCL_1_2}
				hip? (
					dev-util/hip[cuda]
				)
			)
		)
	)
	vulkan? (
		media-libs/vulkan-loader
		!video_cards_amdgpu? (
			media-libs/vulkan-loader[video_cards_intel?,video_cards_nvidia?]
		)
		video_cards_amdgpu? (
			media-libs/vulkan-loader[video_cards_amdgpu,amdvlk]
		)
	)
"
DEPEND_NOT_LISTED=""
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.6.0/README-LNX.md#build-requirements
DEPEND+="
	${CDEPEND_NOT_LISTED}
	${DEPEND_NOT_LISTED}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/cffi:=[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/imageio[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	dev-util/opencl-headers
	sys-apps/pciutils
	x11-libs/libdrm
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pytest-3[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
	')
	${CDEPEND_NOT_LISTED}
	${PYTHON_DEPS}
	>=dev-build/cmake-3.11
	app-arch/makeself
	app-arch/unzip
	dev-libs/castxml
	dev-util/patchelf
	dev-vcs/git
"
PATCHES=(
	"${FILESDIR}/rpr-3.1.6-gentoo-skip-libs_cffi_backend.patch"
	"${FILESDIR}/rpr-3.3-disable-download-wheel-boto3.patch"
)

_set_check_reqs_requirements() {
	CHECKREQS_DISK_BUILD="970M"
	CHECKREQS_DISK_USR="739M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream."
		fi
	done
	for gpu in ${CUDA_TARGETS_UNTESTED[@]} ; do
		if use "cuda_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream."
		fi
	done
}

pkg_setup() {
	warn_untested_gpu
	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if ! use opencl ; then
einfo
einfo "The OpenCL USE flag is strongly recommended or else the GPU selection"
einfo "will not be available."
einfo
	fi

	if ! use vulkan ; then
einfo
einfo "The vulkan USE flag is strongly recommended or rendering at any quality"
einfo "setting for Hybrid rendering will fail."
einfo
	fi

	if has_version "media-libs/mesa[opencl]" ; then
ewarn
ewarn "${PN} may not be compatibile with media-libs/mesa[opencl] (Mesa Clover,"
ewarn "OpenCL 1.1)"
ewarn
	fi

	# We know because of embree and may be statically linked.
	if tc-is-cross-compiler ; then
		:;
	elif cat /proc/cpuinfo | grep sse2 2>/dev/null 1>/dev/null ; then
einfo "CPU is compatible."
	else
ewarn "CPU may not be compatible.  ${PN} requires SSE2."
	fi

	if use rocr ; then
ewarn "You may disable the rocr USE flag for legacy OpenCL support."
		# No die checks for this kernel config in dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD="Change CONFIG_HSA_AMD=y in kernel config.  It's required for ROCr OpenCL support."
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

get_rpipsdk() {
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${S}/RadeonProImageProcessingSDK"
	EGIT_COMMIT="${RPIPSDK_COMMIT}"
	EGIT_MIN_CLONE_TYPE="single"
	EGIT_REPO_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonImageFilter.git"
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf \
		"RadeonProImageProcessingSDK" \
		"RadeonProRenderSDK" \
		"RadeonProRenderSharedComponents" \
		|| die
#	ln -s "${S_RPIPSDK}" "RadeonProImageProcessingSDK" || die
	ln -s "${S_RPRSDK}" "RadeonProRenderSDK" || die
	ln -s "${S_HIPBIN}" "RadeonProRenderSDK/hipbin" || die
	ln -s "${S_RPRSC}" "RadeonProRenderSharedComponents" || die
	get_rpipsdk
}

fix_version() {
	local line_num=$(grep -n -e "\"version\"" "src/rprblender/__init__.py" \
		| cut -f 1 -d ":")
	einfo "line_num:  ${line_num}"
	sed -i -e "${line_num}d" "src/rprblender/__init__.py" || die
	local ver_major=$(ver_cut 1 ${PV})
	local ver_minor=$(ver_cut 2 ${PV})
	local ver_patch=$(ver_cut 3 ${PV})
	sed -i -e "${line_num}i \ \ \ \ \"version\": (${ver_major}, ${ver_minor}, ${ver_patch})," "src/rprblender/__init__.py" || die
}

src_prepare() {
	ewarn "This is the ${CONFIGURATION} build."
	default
	fix_version
	eapply "${FILESDIR}/rpr-3.5.2-more-generic-call-python3.patch"
	git init || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die
}

src_configure() {
	default
	cd "${S}" || die

	einfo "Disabled python 3.9 bindings"
	sed -i -e "/python3.9 build.py/d" \
		build.sh || die
}

src_compile() {
	cd "${S}/BlenderPkg" || die
	./build_linux.sh || die
}

is_version_supported() {
	local folder_version="${1}"
	local slot
	for slot in ${BLENDER_SLOTS[@]} ; do
		local supported_version="${slot/blender-}"
		supported_version="${supported_version/_/.}"
		local _folder_version=$(ver_cut 1-2 "${folder_version}")
		if ver_test "${_folder_version}" -eq "${supported_version}" ; then
			return 0
		fi
	done
	return 1
}

src_install_packed_shared() {
	local head_commit
	# BlenderPkg/.build/rprblender-3.1.0-0422bc6-linux.zip
	pushd "${S}" || die
		head_commit=$(git rev-parse HEAD)
	popd
	D_FN="${PLUGIN_NAME}-${PV}-${head_commit:0:7}-linux.zip"

einfo "Installing addon in shared"

	cd "${S}" || die
	insinto "/usr/share/${PN}"
	newins "${S}/BlenderPkg/.build/${D_FN}" "addon.zip"
}

verify_addon() {
	local L=(
		$(find "${ED}" -name "*.zip")
	)
	IFS=$'\n'
	local p
	for p in ${L[@]} ; do
		if unzip -l "${p}" | grep "libMIOpen.so" 2>/dev/null 1>/dev/null ; then
einfo "${p} passed"
		else
eerror "Failed to build ${p}.  Make sure your dependencies are installed first."
			die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	src_install_packed_shared
	cd "${S}" || die
	docinto "licenses/RadeonProRenderSharedComponents"
	dodoc "${S_RPRSC}/License.txt"
	docinto "licenses/RadeonProRenderSDK"
	dodoc "${S_RPRSDK}/license.txt"
	docinto "licenses/RadeonImageFilter"
	dodoc "${S_RPIPSDK}/License.md"
	docinto "licenses/RadeonProRenderBlenderAddon"
	dodoc "${S}/LICENSE.txt"
	dodoc "${S}/src/${PLUGIN_NAME}/EULA.html"
	verify_addon
}

pkg_postinst() {
ewarn
ewarn "You must enable the addon manually."
ewarn

einfo
einfo "You may need to clear the caches.  Run:"
einfo "rm -rf ~/.config/blender/*/cache/"
einfo
einfo
einfo "You need to switch to the new renderer and see:"
einfo
einfo "  https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/switching.html"
einfo
einfo
einfo "The Full Spectrum Rendering (FSR) modes Low, Medium, High require the"
einfo "vulkan USE flag.  For details, see:"
einfo
einfo "  https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/full_spectrum_rendering.html"
einfo
einfo
einfo "Don't forget to add your user account to the video group."
einfo "This can be done with: \`gpasswd -a USERNAME video\`"
einfo
ewarn
ewarn "If you notice artifacts such as long rectangles when rendering"
ewarn "the scene, disable CPU rendering.  Edge artifacts may appear when"
ewarn "using medium or lower quality settings.  Using the latest drivers"
ewarn "may improve initial compilation time."
ewarn
einfo
einfo "To see the material browser, the renderer must be set to Radeon ProRender"
einfo "It is located at the bottom of the materials property tab."
einfo
	if use hip ; then
ewarn
ewarn "For multislot HIP/ROCm, ensure the following symlink exist:"
ewarn
ewarn "  ln -s /opt/rocm-<ver> /opt/rocm"
ewarn
ewarn "For HIP-cuda, the following symlink may be required"
ewarn
ewarn "  ln -s /opt/cuda /usr/local/cuda"
ewarn
	fi
	if use hip ; then
ewarn
ewarn "You must manually disable \"Use OpenCL\" in the Blender User Setting for HIP support."
ewarn
	fi
	if use opencl ; then
ewarn
ewarn "You must manually enable \"Use OpenCL\" in the Blender User Setting."
ewarn
	fi
}
