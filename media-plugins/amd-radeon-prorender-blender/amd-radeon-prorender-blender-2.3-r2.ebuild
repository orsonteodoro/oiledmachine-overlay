# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for \
Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
HOMEPAGE_DL=\
"https://www.amd.com/en/support/kb/release-notes/rn-prorender-blender-v2-3-blender-2-80-2-81-2-82"
LICENSE="AMD-RADEON-PRORENDER-BLENDER-EULA \
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES \
	PSF-2 MIT BSD BSD-2 CC-BY"
KEYWORDS="~amd64"
INTERNAL_PV="2.3.4"
PLUGIN_NAME="rprblender"
MATLIB_NAME="rprmaterials"
S_FN1="radeonprorenderblender_ubuntu.zip"
S_FN2="radeonprorendermateriallibraryinstaller.run"
D_FN1="${P}-plugin.zip"
MIN_BLENDER_V="2.80"
MAX_BLENDER_V="2.83" # exclusive
SHA1SUM_PLUGIN="0e1bb299672dc111c6bb5ea4b52efa9dce8d55d6"
SHA1SUM_MATLIB="a4b22ef16515eab431c682421e07ec5b2940319d"
D_FN2="${PN}-matlib-${SHA1SUM_MATLIB}.run"
SLOT="0"
IUSE="denoiser intel-ocl lts +materials +opencl opencl_rocm opencl_orca \
opencl_pal opengl_mesa pro-drivers split-drivers -systemwide test \
video_cards_amdgpu video_cards_i965 video_cards_iris video_cards_nvidia \
video_cards_radeonsi +vulkan"
NV_DRIVER_VERSION_OCL_1_2="368.39" # >= OpenCL 1.2
NV_DRIVER_VERSION_VULKAN="390.132"
PYTHON_COMPAT=( python3_{7,8} ) # same as blender
inherit python-single-r1
RDEPEND="${PYTHON_DEPS}
	opencl? (
	intel-ocl? ( dev-util/intel-ocl-sdk )
	|| (
		video_cards_amdgpu? (
			|| (
				pro-drivers? (
					opengl_mesa? (
						!lts? ( x11-drivers/amdgpu-pro[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?] )
						lts? ( x11-drivers/amdgpu-pro-lts[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?] )
					)
					!opengl_mesa? (
						!lts? ( x11-drivers/amdgpu-pro[opencl,opencl_pal?,opencl_orca?] )
						lts? ( x11-drivers/amdgpu-pro-lts[opencl,opencl_pal?,opencl_orca?] )
					)
				)
				split-drivers? (
					opencl_orca? ( dev-libs/amdgpu-pro-opencl )
					opencl_rocm? ( dev-libs/rocm-opencl-runtime )
				)
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
	denoiser? (
		dev-cpp/tbb
		dev-lang/vtune
		sys-libs/libomp
	)
	dev-lang/python[xml]
	$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_MULTI_USEDEP}]')
	>=media-gfx/blender-${MIN_BLENDER_V}[${PYTHON_SINGLE_USEDEP}]
	 <media-gfx/blender-${MAX_BLENDER_V}[${PYTHON_SINGLE_USEDEP}]
	>=media-libs/freeimage-3.17.0[jpeg,jpeg2k,openexr,png,raw,tiff,webp]
	vulkan? (
		media-libs/vulkan-loader
		|| (
			video_cards_amdgpu? (
				|| (
		!lts? ( x11-drivers/amdgpu-pro[vulkan] )
		lts? ( x11-drivers/amdgpu-pro-lts[vulkan] )
				)
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
	)
	sys-devel/gcc[openmp]
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxshmfence
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	pro-drivers? ( || ( opencl_orca opencl_pal opencl_rocm ) )
	opencl_orca? (
		|| ( split-drivers pro-drivers )
		video_cards_amdgpu
	)
	opencl_pal? (
		pro-drivers
		video_cards_amdgpu
	)
	opencl_rocm? (
		split-drivers
		video_cards_amdgpu
	)
	split-drivers? ( || ( opencl_orca opencl_rocm ) )
	video_cards_amdgpu? (
		|| ( pro-drivers split-drivers )
	)
"
RESTRICT="fetch strip"
inherit check-reqs linux-info unpacker
SRC_URI="https://drivers.amd.com/other/ver_2.x/${S_FN1} -> ${D_FN1}
	materials? ( https://drivers.amd.com/other/${S_FN2} -> ${D_FN2} )"
S="${WORKDIR}"
S_PLUGIN="${WORKDIR}/${PN}-${PV}-plugin"
S_MATLIB="${WORKDIR}/${PN}-${PV}-matlib"
D_USER_MATLIB="Documents/Radeon ProRender/Material Library"
D_MATERIALS="/usr/share/${PN}/${D_USER_MATLIB}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${S_FN1} (sha1sum is ${SHA1SUM_PLUGIN})"
	einfo "from ${HOMEPAGE_DL} and rename it to ${D_FN1} place it in ${distdir}"
	einfo
	einfo "Please download"
	einfo "  - ${S_FN2} (sha1sum is ${SHA1SUM_MATLIB})"
	einfo "from ${HOMEPAGE_DL} and rename it to ${D_FN2} place it in ${distdir}"
}

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
	einfo "Radeon RX 4xx:  https://en.wikipedia.org/wiki/Radeon_RX_400_series"
	einfo "Radeon RX 5xx:  https://en.wikipedia.org/wiki/Radeon_RX_500_series"
	einfo "Radeon R5/R7/R9:  https://en.wikipedia.org/wiki/Radeon_Rx_300_series"
	einfo "APU:  https://en.wikipedia.org/wiki/AMD_Accelerated_Processing_Unit"
	einfo "Device IDs <-> codename: https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L777"
	einfo
}

show_notice_pcie3_atomics_required() {
	# See
	# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdkfd/kfd_device.c
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
	einfo "the opencl_rocm if CPU and Mobo both have PCIe 3.0 support;"
	einfo "otherwise, try opencl_orca."
	einfo
	show_codename_docs
}

pkg_setup() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if ! use systemwide ; then
		if [[ -z "${RPR_USERS}" ]] ; then
			eerror "You must add RPR_USERS to your make.conf or per-package-wise"
			eerror "Example RPR_USERS=\"johndoe janedoe\""
			die
		fi
	fi
	if use denoiser ; then
		if [[ ! -f /usr/$(get_libdir)/libomp.so.5 ]] ; then
			ewarn
			ewarn "A libomp.so.5 symlink may be required for the denoiser.  Do:"
			ewarn
			ewarn "  ln -s /usr/lib64/libomp.so /usr/lib64/libiomp.so.5"
			ewarn
		fi
	fi

	if ! use opencl ; then
		einfo "The OpenCL USE flag is strongly recommended or else the GPU selection will not be available."
	fi

	if ! use vulkan ; then
		einfo "The vulkan USE flag is strongly recommended or rendering at any quality setting for Hybrid rendering will fail."
	fi

	if has_version "media-libs/mesa[opencl]" ; then
		ewarn "${PN} may not be compatibile with media-libs/mesa[opencl] (Mesa Clover, OpenCL 1.1)"
	fi

	# We know because of embree and may be statically linked.
	if cat /proc/cpuinfo | grep sse2 2>/dev/null 1>/dev/null ; then
		einfo "CPU is compatible."
	else
		ewarn "CPU may not be compatible.  ${PN} requires SSE2."
	fi

	if use opencl_rocm ; then
		# No die checks for this kernel config in dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD=\
"Change CONFIG_HSA_AMD=y in kernel config.  It's required for opencl_rocm support."
		linux-info_pkg_setup
		if dmesg | grep kfd | grep "PCI rejects atomics" 2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		elif dmesg | grep -e '\[drm\] PCIE atomic ops is not supported' 2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		fi
	fi

	if use opencl_pal ; then
		CONFIG_CHECK="HSA_AMD"
		WARNING_HSA_AMD=\
"Change CONFIG_HSA_AMD=y kernel config.  It may be required for opencl_pal support for pre-Vega 10."
		linux-info_pkg_setup
		if dmesg | grep kfd | grep "PCI rejects atomics" 2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		elif dmesg | grep -e '\[drm\] PCIE atomic ops is not supported' 2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		fi
	fi
}


src_unpack() {
	default

	mkdir -p "${S_PLUGIN}" || die
	mkdir -p "${S_MATLIB}" || die

	cd "${S_PLUGIN}" || die

	unpack_zip ${D_FN1}

	unpack_makeself RadeonProRenderForBlender_${INTERNAL_PV}.run

	if use systemwide ; then
		unpack_zip addon/addon.zip
	fi

	rm *.run || die

	cd "${S_MATLIB}" || die

	unpack_makeself ${D_FN2}
}

src_install_systemwide_matlib() {
	cd "${S_MATLIB}" || die
	einfo "Copying materials..."
	dodir "${D_MATERIALS}"
	cp -a "${S_MATLIB}"/matlib/feature_MaterialLibrary/* \
		"${ED}/${D_MATERIALS}" || die
}

generate_enable_plugin_script() {
	einfo "Generating script"
	local path="${1}"
	local s_plugin="${2}"
	head -n 311 "${S_PLUGIN}/install.py" \
		| tail -n 6 \
		| cut -c 10- \
		| sed -e "s|\",$||g" \
		| sed -e "4d" \
		| sed -e "s|\" % str(||g" \
		| sed -e "s|%s|${path}|g" \
		> "${T}/install_blender_addon.py" || die
}

src_install_systemwide_plugin() {
	cd "${S_PLUGIN}" || die
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
			d_matlib_meta="${d_addon_base}/${MATLIB_NAME}"
			ed_matlib_meta="${ED}/${d_install}"
			dodir "${d_install}"
			cp -a "${S_PLUGIN}/${PLUGIN_NAME}/"* "${ed_install}" || die
			if use materials ; then
				exeinto "${d_matlib_meta}"
				doexe "${S_MATLIB}/uninstall.py"
				echo "${D_MATERIALS}" > "${ed_matlib_meta}/.matlib_installed" || die
				echo "${D_MATERIALS}" > "${ed_install}/.matlib_installed" || die
			fi
			einfo "Attempting to mark installation as registered..."
			touch "${ed_install}/.registered" || die
			dodir "${d_install}/addon" || die
			touch "${ed_install}/addon/.installed" || die
			touch "${ed_install}/.files_installed" || die
			generate_enable_plugin_script \
				"${d_install}/addon/addon.zip"
			exeinto "${d_install}/addon"
			doexe "${T}/install_blender_addon.py"
			exeinto "${d_install}"
			doexe uninstall.py
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

src_install_per_user() {
	for u in ${RPR_USERS} ; do
		einfo "Installing addon for user: ${u}"
		local d_addon="/home/${u}/.local/share/${PLUGIN_NAME}"
		local ed_addon="${ED}/${d_addon}"
		local d_matlib_meta="/home/${u}/.local/share/rprmaterials"
		local ed_matlib_meta="${ED}/${d_matlib_meta}"
		local d_matlib="/home/${u}/${D_USER_MATLIB}"
		local ed_matlib="${ED}/${d_matlib}"
		cd "${S_PLUGIN}" || die
		insinto "${d_addon}/addon"
		doins addon/addon.zip
		exeinto "${d_addon}"
		doexe uninstall.py
		touch "${ed_addon}/.registered" || die
		touch "${ed_addon}/.files_installed" || die
		touch "${ed_addon}/.installed" || die

		generate_enable_plugin_script \
			"${d_addon}/addon/addon.zip"
		exeinto "${d_addon}/addon"
		doexe "${T}/install_blender_addon.py"

		if use materials ; then
			cd "${S_MATLIB}" || die
			insinto "${d_matlib}"
			doins -r matlib/feature_MaterialLibrary/*
			exeinto "${d_matlib_meta}"
			doexe uninstall.py
			echo "${d_matlib}" > "${ed_matlib_meta}/.matlib_installed" || die
			echo "${d_matlib}" > "${ed_addon}/.matlib_installed" || die
			fowners -R ${u}:${u} "${d_matlib}"
			fowners -R ${u}:${u} "${d_matlib_meta}"
		fi
		fowners -R ${u}:${u} "${d_addon}"
	done
}

src_install() {
	if use systemwide ; then
		src_install_systemwide_plugin
		src_install_systemwide_matlib
		if use materials ; then
			cat <<EOF > ${T}/50${P}-matlib
RPR_MATERIAL_LIBRARY_PATH="${D_MATERIALS}/Xml"
EOF
			doenvd "${T}"/50${P}-matlib
		fi
	else
		src_install_per_user
	fi
	cd "${S_PLUGIN}" || die
	dodoc eula.txt
}

pkg_postinst() {
	einfo
	einfo "You must enable the addon manually."

	if use systemwide ; then
		einfo
		einfo "It is listed under: Edit > Preferences > Add-ons > Testing > Render: Radeon ProRender"
		if use materials ; then
			einfo
			einfo "The material library have been installed in:"
			einfo "${D_MATERIALS}"
		fi
	else
		einfo "You must install this product manually through blender per user."
		for u in ${RPR_USERS} ; do
			einfo
			einfo "To install and enable the plugin, tell ${u} to run:"
			einfo "/usr/bin/blender --background --python /home/${u}/.local/share/${PLUGIN_NAME}/addon/install_blender_addon.py"
			einfo
			einfo "or"
			einfo
			einfo "Edit > Preferences > Add-ons > Install"
			einfo
			einfo "Addon location: /home/${u}/.local/share/${PLUGIN_NAME}/addon/addon.zip"
			einfo "Then, you must enable it at:"
			einfo "Edit > Preferences > Add-ons > Community > Render: Radeon ProRender"
			einfo
			einfo "If you previously installed this plugin,"
			einfo "You may try \`rm -rf ~/.config/blender/*/scripts/addons/${PLUGIN_NAME}\`"
			einfo "Then check from Edit > Preferences > Add-ons > Community > Render: Radeon ProRender; then remove; then reinstall."
			if use materials ; then
				local d_matlib="/home/${u}/${D_USER_MATLIB}/Xml"
				local blender_ver=$(ls "${EROOT}/usr/share/blender/")
				einfo "Materials location: ${d_matlib}"
				einfo "To tell ${PN} the location of the materials directory:"
				einfo
				einfo "  Add the following to /home/${u}/.bashrc"
				einfo "  export RPR_MATERIAL_LIBRARY_PATH=\"${d_matlib}\""
				einfo "  Then, re-log."
				einfo
			fi
			einfo
		done
	fi

	einfo
	einfo "For this version, you are opt-in in sending render statistics to AMD.  See link below to disable this feature."
	einfo "https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/debug.html"
	einfo
	einfo "You may need to clear the caches.  Run:"
	einfo "rm -rf ~/.config/blender/*/cache/"
	einfo
	einfo "You need to switch to the new renderer:"
	einfo "See https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/switching.html"
	einfo
	einfo "Setting Quality > Render Quality > Full is likely bugged and will emit \"Error: Compiling CL to IR\"."
	einfo "Lower settings work."
	einfo
	einfo "The Full Spectrum Rendering (FSR) modes Low, Medium, High require the vulkan USE flag.  For details, see"
	einfo "https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/full_spectrum_rendering.html"
	einfo
	einfo "Don't forget to add your user account to the video group."
	einfo "This can be done with: \`gpasswd -a USERNAME video\`"
	einfo
}
