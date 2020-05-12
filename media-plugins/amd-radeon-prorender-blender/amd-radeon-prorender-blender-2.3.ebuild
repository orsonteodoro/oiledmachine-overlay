# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for \
Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
HOMEPAGE_DL=\
"https://www.amd.com/en/support/kb/release-notes/rn-prorender-blender-v2-3-blender-2-80-2-81-2-82"
LICENSE="AMD-RADEON-PRORENDER-BLENDER-EULA \
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES \
	PSF-2 MIT BSD BSD-2 CC-BY"
KEYWORDS="~amd64"
PLUGIN_NAME="rprblender"
S_FN1="radeonprorenderblender_ubuntu.zip"
S_FN2="radeonprorendermateriallibraryinstaller.run"
D_FN1="${P}-plugin.zip"
D_FN2="${P}-matlib.run"
MIN_BLENDER_V="2.80"
MAX_BLENDER_V="2.83" # exclusive
SHA1SUM_PLUGIN="0e1bb299672dc111c6bb5ea4b52efa9dce8d55d6"
SHA1SUM_MATLIB="a4b22ef16515eab431c682421e07ec5b2940319d"
SLOT="0"
IUSE="denoiser +materials opengl_mesa \
-systemwide test video_cards_amdgpu video_cards_intel video_cards_nvidia \
video_cards_r600 video_cards_radeonsi vulkan"
NV_DRIVER_VERSION="368.39" # >= OpenCL 1.2
PYTHON_COMPAT=( python3_{7,8} ) # same as blender
inherit python-single-r1
RDEPEND="${PYTHON_DEPS}
	|| (
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION} )
		video_cards_amdgpu? (
			opengl_mesa? (
				|| (
			x11-drivers/amdgpu-pro[X,developer,open-stack,opengl_mesa,opencl]
			x11-drivers/amdgpu-pro-lts[X,developer,open-stack,opengl_mesa,opencl]
				) )
			!opengl_mesa? ( || ( x11-drivers/amdgpu-pro[opencl] \
					x11-drivers/amdgpu-pro-lts[opencl] ) )
		)
		virtual/opencl
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
	vulkan? ( media-libs/vulkan-loader )
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
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="fetch strip"
inherit unpacker
SRC_URI="https://drivers.amd.com/other/ver_2.x/${S_FN1} -> ${D_FN1}
	materials? ( https://drivers.amd.com/other/${S_FN2} -> ${D_FN2} )"
S="${WORKDIR}"
S_PLUGIN="${WORKDIR}/${PN}-${PV}-plugin"
S_MATLIB="${WORKDIR}/${PN}-${PV}-matlib"
D_USER_MATLIB="Documents/Radeon ProRender/Material Library"
D_MATERIALS="/usr/share/${PN}/${D_USER_MATLIB}"
INTERNAL_PV="2.3.4"

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

pkg_setup() {
	ewarn "Package still in testing/development"
	einfo "It may not work at all"

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

	if has_version "dev-libs/rocm-opencl-runtime" ; then
		ewarn "${PN} may not be compatibile with dev-libs/rocm-opencl-runtime (ROCm OpenCL)"
	fi

	if has_version "media-libs/mesa[opencl]" ; then
		ewarn "${PN} may not be compatibile with media-libs/mesa[opencl] (Mesa Clover, OpenCL 1.1)"
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

src_install_matlib() {
	if use materials ; then
		cd "${S_MATLIB}" || die
		einfo "Copying materials..."
		dodir "${D_MATERIALS}"
		cp -a "${S_MATLIB}"/matlib/feature_MaterialLibrary/* \
			"${ED}/${D_MATERIALS}" || die
	fi
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

src_install_systemwide() {
	cd "${S_PLUGIN}" || die
	local d
	DIRS=$(find /usr/share/blender/ -maxdepth 1 | tail -n +2)

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	for d_ver in ${DIRS} ; do
		if ver_test ${MIN_BLENDER_V} -le ${d_ver} \
			&& ver_test ${d_ver} -lt ${MAX_BLENDER_V} ; then
			einfo "Blender ${d_ver} is supported.  Installing..."
			d_install="/usr/share/blender/${d_ver}/scripts/addons_contrib/${PLUGIN_NAME}"
			ed_install="${ED}/${d_install}"
			dodir "${d_install}"
			chmod 775 "${ed_install}" || die
			chown root:users "${ed_install}" || die
			cp -a "${WORKDIR}/${PLUGIN_NAME}"/* "${ed_install}" || die
			if use materials ; then
				echo "${D_MATERIALS}" > "${ed_install}/.matlib_installed" || die
			fi
			K=$(echo "${REGISTRATION_HASH_SHA1}:${REGISTRATION_HASH_MD5}" | sha1sum | cut -c 1-40)
			einfo "Attempting to mark installation as registered..."
			touch "${ed_install}/.registered" || die
			dodir "${d_install}/addon" || die
			touch "${ed_install}/addon/.installed" || die
			touch "${ed_install}/.files_installed" || die
			generate_enable_plugin_script \
				"${d_install}/addon/addon.zip"
			exeinto "${d_install}/addon"
			doexe "${T}/install_blender_addon.py"

			#exeinto ""
			#doexe uninstall.py
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

		fowners -R ${u}:${u} "${d_addon}"

		if use materials ; then
			cd "${S_MATLIB}" || die
			insinto "${d_matlib}"
			doins -r matlib/feature_MaterialLibrary/*
			exeinto "${d_matlib_meta}"
			doexe uninstall.py
			echo "${d_matlib}" > "${ed_matlib_meta}/.matlib_installed" || die
			echo "${d_matlib}" > "${ed_addon}/.matlib_installed" || die
			fowners -R ${u}:${u} "${d_matlib}"
		fi
	done
}

src_install() {
	if use systemwide ; then
		src_install_systemwide
		if use materials ; then
			cat <<EOF > ${T}/50${P}-matlib
DEV_ENVIRONMENT_VARIABLE="${D_MATERIALS}/Xml"
EOF
			doenvd "${T}"/50${P}-matlib
		fi
	else
		src_install_per_user
	fi
	src_install_matlib
	cd "${S_PLUGIN}" || die
	dodoc eula.txt
}

pkg_postinst() {
	einfo "You must enable the addon manually."

	if use systemwide ; then
		einfo "It is listed under: Edit > Preferences > Add-ons > Community > Render: Radeon ProRender"
		if use materials ; then
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
			if use materials ; then
				local d_matlib="/home/${u}/${D_USER_MATLIB}"
				local blender_ver=$(ls "${EROOT}/usr/share/blender/")
				einfo "Materials location: ${d_matlib}"
				einfo "To tell ${PN} the location of the materials directory:"
				einfo
				einfo "  Add the following to /home/${u}/.bashrc"
				einfo "  export DEV_ENVIRONMENT_VARIABLE=\"${d_matlib}\""
				einfo "  Then, re-log."
				einfo
				einfo "or"
				einfo
				einfo "  After installing and enabling the plugin run:"
				einfo "  sed -i -e 's|material_library_path = None|material_library_path = \"${d_matlib}\"|' /home/${u}/.config/blender/${blender_ver}/scripts/addons/rprblender/config.py"
				einfo
			fi
			einfo
		done
	fi

	einfo "For this version, you are opt-in in sending render statistics to AMD.  See link below to disable this feature."
	einfo "https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/debug.html"
}
