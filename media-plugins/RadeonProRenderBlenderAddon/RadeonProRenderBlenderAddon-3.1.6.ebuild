# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,9} ) # same as blender

inherit check-reqs linux-info python-r1 unpacker

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for \
Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
# The default license is Apache-2.0, the rest are third party.
RPRSC_LICENSE="
	Apache-2.0
	MIT
	BSD
	MPL-2.0
	Boost-1.0"
RPRSDK_LICENSE="
	Apache-2.0
	BSD
	MIT
	Khronos-IP-framework
	BSD-2"
RIF_LICENSE="
	Apache-2.0
	MIT
	UoI-NCSA"
# See https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/v3.1.0/src/rprblender/EULA.html
RPRBLENDER_EULA_LICENSE="
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES
	SPA-DISCLAIMER-DATA-AND-SOFTWARE
	PSF-2
	CC-BY
	BSD
	MIT
	Khronos-IP-framework"
LICENSE="Apache-2.0
	${RPRSC_LICENSE}
	${RPRSDK_LICENSE}
	${RIF_LICENSE}
	${RPRBLENDER_EULA_LICENSE}"
# KEYWORDS="~amd64" ebuild is still a Work In Progress (WIP)
PLUGIN_NAME="rprblender"
# ceiling based on python compatibility matching the particular blender version
MIN_BLENDER_V="2.80"
MAX_BLENDER_V="2.93" # exclusive
SLOT="0"
IUSE+=" +blender-lts +blender-stable blender-master"
IUSE+=" denoiser intel-ocl +matlib +opencl opencl_rocr opencl_orca \
opencl_pal opengl_mesa split-drivers -systemwide test video_cards_amdgpu \
video_cards_amdgpu-pro video_cards_amdgpu-pro-lts video_cards_i965 \
video_cards_iris video_cards_nvidia video_cards_radeonsi +vulkan"
NV_DRIVER_VERSION_OCL_1_2="368.39" # >= OpenCL 1.2
NV_DRIVER_VERSION_VULKAN="390.132"
# systemwide is preferred but currently doesn't work but did in the past in <2.0
REQUIRED_USE+="  ${PYTHON_REQUIRED_USE}
	|| ( blender-lts blender-master blender-stable )
	!systemwide
	python_targets_python3_7
	blender-lts? ( python_targets_python3_7 )
	blender-master? ( python_targets_python3_9 )
	blender-stable? ( python_targets_python3_7 )
	opencl_orca? (
		|| ( video_cards_amdgpu
			video_cards_amdgpu-pro
			video_cards_amdgpu-pro-lts ) )
	opencl_pal? (
		|| ( video_cards_amdgpu-pro
		video_cards_amdgpu-pro-lts ) )
	opencl_rocr? (
		|| ( video_cards_amdgpu
			video_cards_amdgpu-pro
			video_cards_amdgpu-pro-lts )
		split-drivers )
	split-drivers? ( || (
		opencl_orca
		opencl_rocr ) )
	video_cards_amdgpu? (
		!video_cards_amdgpu-pro
		!video_cards_amdgpu-pro-lts
		!video_cards_radeonsi
		|| ( opencl_orca
			opencl_rocr )
		split-drivers )
	video_cards_amdgpu-pro? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro-lts
		!video_cards_radeonsi
		|| ( opencl_orca
			opencl_pal
			opencl_rocr ) )
	video_cards_amdgpu-pro-lts? (
		!video_cards_amdgpu
		!video_cards_amdgpu-pro
		!video_cards_radeonsi
		|| ( opencl_orca
			opencl_pal
			opencl_rocr ) )"
# Assumes U 18.04.03 minimal
CDEPEND_NOT_LISTED="
	dev-lang/python[xml]
	sys-devel/gcc[openmp]"
DEPEND_NOT_LISTED=""
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.1.0/README-LNX.md#build-requirements
DEPEND+="  ${CDEPEND_NOT_LISTED}
	${DEPEND_NOT_LISTED}
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/distro[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/imageio[${PYTHON_USEDEP}]')
	dev-util/opencl-headers
	sys-apps/pciutils
	$(python_gen_cond_dep 'dev-python/cffi:=[${PYTHON_USEDEP}]')
	x11-libs/libdrm"
# These are mentioned in the command line output and downloaded after install.
# They are not really used on linux since athena_send is disabled on Linux but
# may crash if not installed.
# For details see,
#   src/rprblender/utils/install_libs.py
PIP_DOWNLOADED="
	$(python_gen_cond_dep 'dev-python/boto3[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/pip[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/wheel[${PYTHON_USEDEP}]')"
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
		dev-cpp/tbb
		dev-lang/vtune
		sys-libs/libomp
	)"
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.1.0/README-LNX.md#addon-runuse-linux-ubuntu-requirements


RDEPEND+="  ${CDEPEND_NOT_LISTED}
	${RDEPEND_NOT_LISTED}
	blender-lts? (
		>=media-gfx/blender-${MIN_BLENDER_V}[python_single_target_python3_7]
		 <media-gfx/blender-${MAX_BLENDER_V}[python_single_target_python3_7]
	)
	blender-stable? (
		>=media-gfx/blender-${MIN_BLENDER_V}[python_single_target_python3_7]
		 <media-gfx/blender-${MAX_BLENDER_V}[python_single_target_python3_7]
	)
	blender-master? (
		>=media-gfx/blender-9999[python_single_target_python3_9]
	)
	>=media-libs/embree-2.12.0
	>=media-libs/openimageio-1.6
	>=media-libs/freeimage-3.17.0[jpeg,jpeg2k,openexr,png,raw,tiff,webp]
	matlib? ( media-plugins/RadeonProRenderMaterialLibrary )
	opencl? (
		intel-ocl? ( dev-util/intel-ocl-sdk )
		|| (
		video_cards_amdgpu-pro? (
			!split-drivers? (
				opengl_mesa? (
					|| (
<x11-drivers/amdgpu-pro-20.45\
[X,developer,open-stack,opencl,opencl_orca?,opencl_pal?,opengl_mesa,-opengl_pro]
>=x11-drivers/amdgpu-pro-20.45\
[X,developer,open-stack,opencl,opencl_orca?,opencl_rocr?,opengl_mesa,-opengl_pro]

					)
				)
				!opengl_mesa? (
					|| (
<x11-drivers/amdgpu-pro-20.45\
[opencl,opencl_orca?,opencl_pal?,-opengl_mesa,opengl_pro]
>=x11-drivers/amdgpu-pro-20.45\
[opencl,opencl_orca?,opencl_rocr?,-opengl_mesa,opengl_pro]
					)
				)
			)
			split-drivers? (
				opencl_orca? ( dev-libs/amdgpu-pro-opencl )
				opencl_rocr? ( dev-libs/rocm-opencl-runtime )
			)
		)
		video_cards_amdgpu-pro-lts? (
			!split-drivers? (
				opengl_mesa? (
					|| (
<x11-drivers/amdgpu-pro-lts-20.45\
[X,developer,open-stack,opencl,opencl_orca?,opencl_pal?,opengl_mesa,-opengl_pro]
>=x11-drivers/amdgpu-pro-lts-20.45\
[X,developer,open-stack,opencl,opencl_orca?,opencl_rocr?,opengl_mesa,-opengl_pro]
					)
				)
				!opengl_mesa? (
					|| (
<x11-drivers/amdgpu-pro-lts-20.45\
[opencl,opencl_orca?,opencl_pal?,-opengl_mesa,opengl_pro]
>=x11-drivers/amdgpu-pro-lts-20.45\
[opencl,opencl_orca?,opencl_rocr?,-opengl_mesa,opengl_pro]
					)
				)
			)
			split-drivers? (
				opencl_orca? ( dev-libs/amdgpu-pro-opencl )
				opencl_rocr? ( dev-libs/rocm-opencl-runtime )
			)
		)
		video_cards_amdgpu? (
			split-drivers? (
				opencl_orca? ( dev-libs/amdgpu-pro-opencl )
				opencl_rocr? ( dev-libs/rocm-opencl-runtime )
			)
		)
		video_cards_i965? (
			dev-libs/intel-neo
		)
		video_cards_iris? (
			dev-libs/intel-neo
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
			video_cards_amdgpu-pro? (
		x11-drivers/amdgpu-pro[vulkan]
			)
			video_cards_amdgpu-pro-lts? (
		x11-drivers/amdgpu-pro-lts[vulkan]
			)
			video_cards_i965? (
		media-libs/mesa[video_cards_i965,vulkan]
			)
			video_cards_iris? (
		media-libs/mesa[video_cards_iris,vulkan]
			)
			video_cards_nvidia? (
		>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
			)
			video_cards_radeonsi? (
		media-libs/mesa[video_cards_radeonsi,vulkan]
			)
		)
	)"
BDEPEND+="  ${CDEPEND_NOT_LISTED}
	${PYTHON_DEPS}
	app-arch/makeself
	dev-util/patchelf
	dev-cpp/castxml
	$(python_gen_cond_dep 'dev-python/pip[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pytest-3[${PYTHON_USEDEP}]')
	>=dev-util/cmake-3.11
	dev-vcs/git"
#RIF_V="1.7.0" # new
#RPRSDK_V="2.2.2" # new
RIF_V="1.6.1" # old
RPRSDK_V="2.2.1" # old
RPRSC_V="9999_p20201109"
EGIT_COMMIT_RPRSC="41d2e5fb8631ef2bfa60fa27f5dbf7c4a8e2e4aa"
RIF_DF="RadeonImageFilter-${RIF_V}.tar.gz"
RPRSDK_DF="RadeonProRenderSDK-${RPRSDK_V}.tar.gz"
RPRSC_DF="RadeonProRenderSharedComponents-${RPRSC_V}-${EGIT_COMMIT_RPRSC:0:7}.tar.gz"
GH_ORG_BURI="https://github.com/GPUOpen-LibrariesAndSDKs"
SRC_URI="
${GH_ORG_BURI}/RadeonProRenderBlenderAddon/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
${GH_ORG_BURI}/RadeonImageFilter/archive/refs/tags/${RIF_V}.tar.gz
	-> ${RIF_DF}
${GH_ORG_BURI}/RadeonProRenderSDK/archive/refs/tags/v${RPRSDK_V}.tar.gz
	-> ${RPRSDK_DF}
${GH_ORG_BURI}/RadeonProRenderSharedComponents/archive/${EGIT_COMMIT_RPRSC}.tar.gz
	-> ${RPRSC_DF}"
RESTRICT="mirror strip"
S="${WORKDIR}/${P}"
S_RIF="${WORKDIR}/RadeonImageFilter-${RIF_V}"
S_RPRSDK="${WORKDIR}/RadeonProRenderSDK-${RPRSDK_V}"
S_RPRSC="${WORKDIR}/RadeonProRenderSharedComponents-${EGIT_COMMIT_RPRSC}"
PATCHES=(
	"${FILESDIR}/rpr-3.1.6-gentoo-skip-libs_cffi_backend.patch"
	"${FILESDIR}/rpr-3.1.0-disable-download-wheel-boto3.patch"
)

_set_check_reqs_requirements() {
	CHECKREQS_DISK_BUILD="970M"
	CHECKREQS_DISK_USR="739M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

show_codename_docs() {
	einfo
	einfo "Details about codenames can be found at"
	einfo
	einfo "Radeon Pro:  https://en.wikipedia.org/wiki/Radeon_Pro"
	einfo "Radeon RX Vega:  https://en.wikipedia.org/wiki/Radeon_RX_Vega_series"
	einfo "Radeon RX 5xx:  https://en.wikipedia.org/wiki/Radeon_RX_500_series"
	einfo "Radeon RX 4xx:  https://en.wikipedia.org/wiki/Radeon_RX_400_series"
	einfo "Radeon R5/R7/R9:  https://en.wikipedia.org/wiki/Radeon_Rx_300_series"
	einfo "APU:  https://en.wikipedia.org/wiki/AMD_Accelerated_Processing_Unit"
	einfo "Device IDs <-> codename: \
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L777"
	einfo
}

show_notice_pcie3_atomics_required() {
	# See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdkfd/kfd_device.c
	# https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/blob/master/runtime/device/rocm/rocdevice.cpp
	# Device should be supported end-to-end from kfd to runtime.
	ewarn
	ewarn "Detected no PCIe atomics."
	ewarn
	ewarn "ROCm OpenCL requires PCIe atomics for the following:"
	ewarn "raven"
	ewarn "fiji"
	ewarn "polaris10"
	ewarn "polaris11"
	ewarn "polaris12"
	einfo
	einfo "If your device matches one of the codenames above, use the"
	einfo "opencl_orca (for polaris 10, polaris 11, polaris 12, fiji) or"
	einfo "opencl_pal (for raven) USE flag instead or upgrade CPU and"
	einfo "Mobo combo with both PCIe 3.0 support, or upgrade to one of"
	einfo "the GPUs in the list following immediately."
	einfo
	einfo "In addition, your kernel config must have CONFIG_HSA_AMD=y."
	einfo
	einfo
	einfo "You may ignore if your device is the following:"
	einfo "kaveri"
	einfo "carrizo"
	einfo "hawaii"
	einfo "vega10"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "navi12"
	einfo "navi14"
	einfo
	einfo "Not supported for ROCm:"
	ewarn "tonga (PCIe atomics required, don't work on ROCm)"
	ewarn "vegam (PCIe atomics required, may work on ROCm)"
	ewarn "iceland"
	ewarn "vega12 (no PCIE atomics required)"
	einfo
	einfo "Try opencl_orca for tonga, vegam, iceland."
	einfo "Try opencl_pal for vega12."
	einfo
	einfo "If ROCm OpenCL doesn't work, stick to either opencl_pal"
	einfo "opencl_orca."
	einfo
	show_codename_docs
}

show_notice_pal_support() {
	# Vega 10 is in the GFX_v9 set
	# Navi 10 is GFX_v10
	einfo
	einfo "opencl_pal is only supported for GFX_v9 and the following:"
	einfo "vega10"
	einfo "vega12"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "raven"
	einfo
	einfo "If your device does not match one of the codenames above, use"
	einfo "the opencl_rocr if CPU and Mobo both have PCIe 3.0 support;"
	einfo "otherwise, try opencl_orca."
	einfo
	show_codename_docs
}

pkg_setup() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if ! use opencl ; then
		einfo \
"The OpenCL USE flag is strongly recommended or else the GPU selection will \
not be available."
	fi

	if ! use vulkan ; then
		einfo \
"The vulkan USE flag is strongly recommended or rendering at any quality \
setting for Hybrid rendering will fail."
	fi

	if has_version "media-libs/mesa[opencl]" ; then
		ewarn \
"${PN} may not be compatibile with media-libs/mesa[opencl] (Mesa Clover, \
OpenCL 1.1)"
	fi

	# We know because of embree and may be statically linked.
	if cat /proc/cpuinfo | grep sse2 2>/dev/null 1>/dev/null ; then
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
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
			2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		fi
	fi

	if use opencl_pal ; then
		CONFIG_CHECK="HSA_AMD"
		WARNING_HSA_AMD=\
"Change CONFIG_HSA_AMD=y kernel config.  It may be required for opencl_pal \
support for pre-Vega 10."
		linux-info_pkg_setup
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
			2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		fi
	fi
}


src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf RadeonProImageProcessingSDK \
		RadeonProRenderSDK \
		RadeonProRenderSharedComponents || die
	ln -s "${S_RIF}" "RadeonProImageProcessingSDK" || die
	ln -s "${S_RPRSDK}" "RadeonProRenderSDK" || die
	ln -s "${S_RPRSC}" "RadeonProRenderSharedComponents" || die
}

src_prepare() {
	default
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

	if ! use python_targets_python3_7 ; then
		einfo "Disabled python 3.7 bindings"
		sed -i -e "/python3.7 build.py/d" \
			build.sh || die
	fi

	if ! use python_targets_python3_9 ; then
		einfo "Disabled python 3.9 bindings"
		sed -i -e "/python3.9 build.py/d" \
			build.sh || die
	fi
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
		if ver_test ${MIN_BLENDER_V} -le ${d_ver} \
			&& ver_test ${d_ver} -lt ${MAX_BLENDER_V} ; then
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
	dodoc "${S_RIF}/License.md"
	docinto licenses/RadeonProRenderBlenderAddon
	dodoc "${S}/LICENSE.txt"
	dodoc "${S}/src/${PLUGIN_NAME}/EULA.html"
}

pkg_postinst() {
	einfo
	einfo "You must enable the addon manually."

	if use denoiser ; then
		if [[ ! -f /usr/$(get_libdir)/libomp.so.5 ]] ; then
			einfo "Adding symlink for the denoiser:"
			einfo "/usr/$(get_libdir)/libomp.so -> /usr/$(get_libdir)/libiomp.so.5"
			ln -s /usr/$(get_libdir)/libomp.so \
				/usr/$(get_libdir)/libiomp.so.5 || die
		fi
	fi

	if use systemwide ; then
		einfo
		einfo "It is listed under: Edit > Preferences > Add-ons > Community > Render: Radeon ProRender"
	else
		einfo "You must install this product manually through blender per user."
		einfo "The addon can be found in /usr/share/${PN}/addon.zip"
		einfo
		einfo "The addon can be uninstalled/installed at:"
		einfo "Edit > Preferences > Add-ons > Community > Install button at top right > navigate to /usr/share/${PN}/addon.zip"
		einfo
		einfo "The addon can be found and check enabled on after installation by going to:"
		einfo "Edit > Preferences > Add-ons > Community > Render: Radeon ProRender"
		ewarn
		ewarn "You must completely uninstall and reinstall the addon through the same menu for changes or upgrades to take affect."
		ewarn
	fi

	einfo
	einfo "You may need to clear the caches.  Run:"
	einfo "rm -rf ~/.config/blender/*/cache/"
	einfo
	einfo "You need to switch to the new renderer:"
	einfo "See https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/switching.html"
	einfo
	einfo "The Full Spectrum Rendering (FSR) modes Low, Medium, High require the vulkan USE flag.  For details, see"
	einfo "https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/full_spectrum_rendering.html"
	einfo
	einfo "Don't forget to add your user account to the video group."
	einfo "This can be done with: \`gpasswd -a USERNAME video\`"
	einfo

	ewarn
	ewarn "If you notice artifacts such as long rectangles when rendering"
	ewarn "the scene, disable CPU rendering.  Edge artifacts may appear when"
	ewarn "using medium or lower quality settings.  Using the latest drivers"
	ewarn "may improve initial compilation time."

	einfo
	einfo "To see the material browser, the renderer must be set to Radeon ProRender"
	einfo "It is located at the bottom of the materials property tab."
}
