# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {13..11} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
# LLVM versions supported:
# =media-gfx/blender-9999 (4.2.0 alpha) :: 17 16 15 ( not supported in this series )
# =media-gfx/blender-3.6* :: 16 15 14 13 12 11      ( not supported in this series )
# =media-gfx/blender-3.5* :: 13 12 11               ( not supported in this series )
# =media-gfx/blender-3.4* :: 13 12 11
# =media-gfx/blender-3.3* :: 13 12 11

BLENDER_SLOTS="
	blender-3_3 # python3_11 .. python3_10
	blender-3_4 # python3_11 .. python3_10
"
CONFIGURATION="release"
# Ceiling values based on python compatibility matching the particular Blender
# version.
MAX_BLENDER_PV="3.5" # Exclusive
MIN_BLENDER_PV="2.80"
NV_DRIVER_VERSION_OCL_1_2="368.39" # >= OpenCL 1.2
NV_DRIVER_VERSION_VULKAN="390.132"
PLUGIN_NAME="rprblender"
# It supports Python 3.7 to 3.10, but they are deprecated in this distro in
# python-utils-r1.eclass.
PYTHON_COMPAT=( "python3_11" )
ROCM_SLOTS=(
#	rocm_5_4 # Disabled to avoid multiple LLVMs loaded bug
#	rocm_5_3 # Disabled to avoid multiple LLVMs loaded bug
#	rocm_5_2 # Disabled to avoid multiple LLVMs loaded bug
#	rocm_5_1 # Disabled to avoid multiple LLVMs loaded bug
	rocm_4_5
	rocm_4_3
)
declare -A ROCM_TO_LLVM_SLOT=(
#	["rocm_5_4"]="15" # Disabled to avoid multiple LLVMs loaded bug
#	["rocm_5_3"]="15" # Disabled to avoid multiple LLVMs loaded bug
#	["rocm_5_2"]="14" # Disabled to avoid multiple LLVMs loaded bug
#	["rocm_5_1"]="14" # Disabled to avoid multiple LLVMs loaded bug
	["rocm_4_5"]="13"
	["rocm_4_3"]="13"
)
# Commits are based on left side.  The commit associated with the message
# (right) differs with the commit associated with the folder (left) on the
# GitHub website.
RPIPSDK_COMMIT="76068b7ca29aa8a7f29f65475f334981f0dd5e53"
RPIPSDK_DF="RadeonImageFilter-${RPIPSDK_COMMIT:0:7}.tar.gz"
RPRSC_COMMIT="6608117fcddd783e81b2aedc2c1abdf0b449d465"
RPRSC_DF="RadeonProRenderSharedComponents-${RPRSC_COMMIT:0:7}.tar.gz"
RPRSDK_COMMIT="c6424e29169743cd5a05c10593a2665dfedb185c"
RPRSDK_DF="RadeonProRenderSDK-${RPRSDK_COMMIT:0:7}.tar.gz"
VIDEO_CARDS="
	video_cards_amdgpu
	video_cards_intel
	video_cards_nvidia
	video_cards_radeonsi
"

inherit check-reqs git-r3 linux-info llvm python-r1 unpacker

KEYWORDS="~amd64"

# Download limits?
#https://github.com/GPUOpen-LibrariesAndSDKs/RadeonImageFilter/archive/${RPIPSDK_COMMIT}.tar.gz
#	-> ${RPIPSDK_DF}

S="${WORKDIR}/${P}"
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
"

DESCRIPTION="This hardware-agnostic rendering plug-in for Blender uses \
accurate ray-tracing technology to produce images and animations of your \
scenes, and provides real-time interactive rendering and continuous adjustment \
of effects."
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
# The default license is Apache-2.0, the rest are third party.
RPIPSDK_LICENSE="
	Apache-2.0
	MIT
	UoI-NCSA
"
RPRSC_LICENSE="
	Apache-2.0
	Boost-1.0
	BSD
	MIT
	MPL-2.0
"
RPRSDK_LICENSE="
	Apache-2.0
	BSD
	BSD-2
	Khronos-IP-framework
	MIT
"
# See https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/v3.5.0/src/rprblender/EULA.html
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
	Apache-2.0
	${RPRSC_LICENSE}
	${RPRSDK_LICENSE}
	${RPIPSDK_LICENSE}
	${RPRBLENDER_EULA_LICENSE}
"
RESTRICT="mirror strip"
SLOT="0/${CONFIGURATION}"
IUSE+="
${BLENDER_SLOTS}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
${VIDEO_CARDS}
denoiser intel-ocl +matlib +opencl opencl_rocr opencl_orca system-llvm -systemwide +vulkan
"
gen_rocm_required_use() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			${s}? (
				llvm_slot_${ROCM_TO_LLVM_SLOT[${s}]}
				opencl_rocr
			)
		"
	done
}
# Systemwide is preferred but currently doesn't work but did in the past in <2.0
REQUIRED_USE+="
	$(gen_rocm_required_use)
	${PYTHON_REQUIRED_USE}
	!systemwide
	blender-3_3? (
		python_targets_python3_11
	)
	blender-3_4? (
		python_targets_python3_11
	)
	opencl_orca? (
		system-llvm
		video_cards_amdgpu
	)
	opencl_rocr? (
		video_cards_amdgpu
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	video_cards_amdgpu? (
		!video_cards_radeonsi
		|| (
			opencl_orca
			opencl_rocr
		)
	)
	|| (
		${BLENDER_SLOTS}
	)
"
# Assumes U 18.04.03 minimal
CDEPEND_NOT_LISTED="
	dev-lang/python[xml]
	sys-devel/gcc[openmp]
"
DEPEND_NOT_LISTED=""
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.5.0/README-LNX.md#build-requirements
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
LEGACY_TBB_SLOT="2" # https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSharedComponents/blob/master/OpenVDB/include/tbb/tbb_stddef.h
gen_omp_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				media-gfx/blender[llvm_slot_${s}]
				system-llvm? (
					sys-libs/libomp:${s}
				)
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
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.5.0/README-LNX.md#addon-runuse-linux-ubuntu-requirements

BLENDER_RDEPEND="
	blender-3_3? (
		$(python_gen_any_dep "
			=media-gfx/blender-3.3*["'${PYTHON_SINGLE_USEDEP}'"]
		")
	)
	blender-3_4? (
		$(python_gen_any_dep "
			=media-gfx/blender-3.4*["'${PYTHON_SINGLE_USEDEP}'"]
		")
	)
"

 # Disabled to avoid multiple LLVMs loaded bug
RDEPEND_DISABLED="
				opencl_rocr? (
					rocm_5_4? (
						dev-libs/rocm-opencl-runtime:5.4
						sys-libs/llvm-roc-libomp:5.4
					)
					rocm_5_3? (
						dev-libs/rocm-opencl-runtime:5.3
						sys-libs/llvm-roc-libomp:5.3
					)
					rocm_5_2? (
						dev-libs/rocm-opencl-runtime:5.2
						sys-libs/llvm-roc-libomp:5.2
					)
					rocm_5_1? (
						dev-libs/rocm-opencl-runtime:5.1
						sys-libs/llvm-roc-libomp:5.1
					)
				)
"

RDEPEND+="
	${BLENDER_RDEPEND}
	${CDEPEND_NOT_LISTED}
	${RDEPEND_NOT_LISTED}
	>=media-libs/embree-2.12.0
	>=media-libs/openimageio-1.6
	>=media-libs/freeimage-3.17.0[jpeg,jpeg2k,openexr,png,raw,tiff,webp]
	matlib? (
		media-plugins/RadeonProRenderMaterialLibrary
	)
	opencl? (
		intel-ocl? (
			dev-util/intel-ocl-sdk
		)
		|| (
			video_cards_amdgpu? (
				opencl_orca? (
					dev-libs/amdgpu-pro-opencl
				)
				opencl_rocr? (
					rocm_4_5? (
						dev-libs/rocm-opencl-runtime:4.5
						sys-libs/llvm-roc-libomp:4.5
					)
					rocm_4_3? (
						dev-libs/rocm-opencl-runtime:4.3
						sys-libs/llvm-roc-libomp:4.3
					)
				)
			)
			video_cards_intel? (
				dev-libs/intel-compute-runtime
			)
			video_cards_nvidia? (
				>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_OCL_1_2}
			)
			video_cards_radeonsi? (
				dev-libs/amdgpu-pro-opencl
			)
		)
	)
	vulkan? (
		media-libs/vulkan-loader
		|| (
			video_cards_amdgpu? (
				|| (
					media-libs/mesa[video_cards_radeonsi,vulkan]
					media-libs/amdvlk
				)
			)
			video_cards_intel? (
				media-libs/mesa[video_cards_intel,vulkan]
			)
			video_cards_nvidia? (
				>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
			)
			video_cards_radeonsi? (
				media-libs/mesa[video_cards_radeonsi,vulkan]
			)
		)
	)
"
BDEPEND+="
	${CDEPEND_NOT_LISTED}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pytest-3[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
	')
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

check_iomp5() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use denoiser \
			&& has_version "media-gfx/blender[llvm_slot_${s}]" \
			&& [[ ! -e "${EROOT}/usr/lib/llvm/${s}/$(get_libdir)/libiomp5.so" ]] \
	; then
ewarn
ewarn "Missing libiomp5.so symlink.  You may need to..."
ewarn
ewarn "ln -s /usr/lib/llvm/${s}/$(get_libdir)/libomp.so /usr/lib/llvm/${s}/$(get_libdir)/libiomp5.so"
ewarn "ln -s /usr/lib/llvm/${s}/$(get_libdir)/libomp.so /usr/$(get_libdir)/libiomp5.so"
ewarn
		fi
	done
}

pkg_setup() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup

	use blender-3_3 && export LLVM_MAX_SLOT=13
	use blender-3_4 && export LLVM_MAX_SLOT=13

	llvm_pkg_setup
	check_iomp5

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

	if use opencl_rocr ; then
		# No die checks for this kernel config in dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD=\
"Change CONFIG_HSA_AMD=y in kernel config.  It's required for opencl_rocr support."
		linux-info_pkg_setup
ewarn
ewarn "You need PCI atomics to use opencl_rocr.  Use opencl_orca if opencl_rocr"
ewarn "doesn't work."
ewarn
	fi
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

	if use systemwide ; then
		local head_commit
		# BlenderPkg/.build/rprblender-3.1.0-0422bc6-linux.zip
		pushd "${S}" || die
			head_commit=$(git rev-parse HEAD)
		popd
		D_FN="${PLUGIN_NAME}-${PV}-${head_commit:0:7}-linux.zip"

		D_RPRUP="${WORKDIR}/rpr-unpacked"
		mkdir -p "${D_RPRUP}" || die
		pushd "${D_RPRUP}" || die
			unpack "${S}/BlenderPkg/.build/${D_FN}"
		popd
	fi
}

src_install_systemwide_plugin_unpacked() {
	cd "${S}" || die
	local d
	DIRS=$(find /usr/share/blender/ -maxdepth 1 | tail -n +2)

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	for d_ver in ${DIRS} ; do
		d_ver=$(basename ${d_ver})
		if ver_test ${MIN_BLENDER_PV} -le ${d_ver} \
			&& ver_test ${d_ver} -lt ${MAX_BLENDER_PV} ; then
			einfo "Blender ${d_ver} is supported.  Installing..."
			d_addon_base="/usr/share/blender/${d_ver}/scripts/addons_contrib"
			ed_addon_base="${ED}/${d_addon_base}"
			d_install="${d_addon_base}/${PLUGIN_NAME}"
			ed_install="${ED}/${d_install}"
			dodir "${d_install}"
			cp -a "${D_RPRUP}/"* "${ed_install}" || die
		else
			einfo "Blender ${d_ver} not supported.  Skipping..."
		fi
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
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
	if use systemwide ; then
		src_install_systemwide_plugin_unpacked
	else
		src_install_packed_shared
	fi
	cd "${S}" || die
	docinto licenses/RadeonProRenderSharedComponents
	dodoc "${S_RPRSC}/License.txt"
	docinto licenses/RadeonProRenderSDK
	dodoc "${S_RPRSDK}/license.txt"
	docinto licenses/RadeonImageFilter
	dodoc "${S_RPIPSDK}/License.md"
	docinto licenses/RadeonProRenderBlenderAddon
	dodoc "${S}/LICENSE.txt"
	dodoc "${S}/src/${PLUGIN_NAME}/EULA.html"
	verify_addon
}

pkg_postinst() {
ewarn
ewarn "You must enable the addon manually."
ewarn

	# The denoiser may need libiomp.so.5 from sys-libs/libomp.

	if use systemwide ; then
einfo
einfo "It is listed under: Edit > Preferences > Add-ons > Community >"
einfo "Render: Radeon ProRender"
einfo
	else
einfo
einfo "You must install this product manually through blender per user."
einfo "The addon can be found in /usr/share/${PN}/addon.zip"
einfo
einfo "The addon can be uninstalled/installed at:"
einfo "Edit > Preferences > Add-ons > Community > Install button at top right >"
einfo "navigate to /usr/share/${PN}/addon.zip"
einfo
einfo "The addon can be found and check enabled on after installation by going to:"
einfo "Edit > Preferences > Add-ons > Community > Render: Radeon ProRender"
einfo
ewarn
ewarn "You must completely uninstall and reinstall the addon through the same"
ewarn "menu for changes or upgrades to take affect."
ewarn
	fi

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
}
