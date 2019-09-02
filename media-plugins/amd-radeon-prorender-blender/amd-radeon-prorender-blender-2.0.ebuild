# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit unpacker python-single-r1

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
HOMEPAGE_DL="https://www.amd.com/en/technologies/radeon-prorender-downloads"

PLUGIN_NAME="rprblender"
FN="radeonprorenderforblender.run"
SRC_URI="https://drivers.amd.com/other/ver_2.x/${FN} -> ${P}.run"

RESTRICT="fetch strip"

IUSE="+checker denoiser embree +materials system-cffi system-tbb test video_cards_radeonsi video_cards_nvidia video_cards_fglrx video_cards_amdgpu video_cards_intel video_cards_r600"

# if amdgpu-pro is installed libgl-mesa-dev containing development headers and libs were pulled and noted in the Packages file:
# amdgpu-pro 19.20.812932 -> libgl-mesa-dev 18.3.0-812932
# amdgpu-pro 19.30.838629 -> libgl-mesa-dev 19.2.0-838629
#
NV_DRIVER_VERSION="368.39"
RDEPEND="${PYTHON_DEPS}
	dev-lang/python[xml]
	>=media-gfx/blender-2.80[${PYTHON_USEDEP},opensubdiv]
	media-libs/opensubdiv[opencl]
	video_cards_amdgpu? ( media-libs/mesa )
	|| (
		virtual/opencl
		video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION} )
		video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
		video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
	)
	>=media-libs/freeimage-3.0
	embree? ( media-libs/embree:2[tbb,raymask] )
	denoiser? ( >=media-libs/openimageio-1.2.3 )
	sys-devel/gcc[openmp]
	dev-libs/libbsd
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	dev-python/numpy[${PYTHON_USEDEP}]
	system-cffi? ( dev-python/cffi[${PYTHON_USEDEP}] )
	system-tbb? ( dev-cpp/tbb )
	"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	     "

LICENSE="AMD-RADEON-PRORENDER-BLENDER-EULA AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES PSF-2 MIT BSD BSD-2 CC-BY"
KEYWORDS="~amd64"
SLOT="0"

S="${WORKDIR}/${PN}-${PV}"

D_MATERIALS="/usr/share/${PN}/Radeon_ProRender/Blender/Material_Library"

pkg_pretend() {
	if use checker ; then
		for DEVICE in $(ls /dev/*/card* /dev/dri/renderD128)
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

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE_DL} and rename it to ${P}.run place it in ${distdir}"
}

_pkg_setup() {
	ewarn "Package still in testing/development"

	if use python_targets_python3_6 ; then
		ewarn "python_targets_python3_6 USE flag is for debugging ebuild only use only python_targets_python3_7."
	fi

	cd "${S}"
	BLENDER_VER=$(/usr/bin/blender --version | grep -e "Blender [0-9.]*" | tr "(" "_" | tr ")" "_" | tr " " "_" | sed "s|Blender||" | cut -c 2-)
	BLENDER_BUILD_HASH="unknown" # from --version inspection but none found
	APPVERSION="${BLENDER_VER}__${BLENDER_BUILD_HASH}"

	if use video_cards_amdgpu || use video_cards_radeonsi || use video_cards_r600 || use video_cards_fglrx ; then
		true
	elif use video_cards_nvidia ; then
		true
	else
		ewarn "Your card may not be supported but may be limited to CPU rendering."
		if ! use embree ; then
			einfo "You may need to enable the embree USE flag for CPU rendering / raytracing."
		fi
	fi

	if use checker ; then
		# Checker needs OpenCL or it will crash
		# The checker will check your hardware for compatibility and generate a registration url
		yes | BLENDER_VERSION=${APPVERSION} ./addon/checker || die
	else
		ewarn "Disabling checker is experimental."
	fi
}

src_unpack() {
	default

	mkdir -p ${S}

	cd "${S}"

	unpack_makeself ${P}.run

	cd "${WORKDIR}"
	unpack_zip "${S}"/addon/addon.zip

	_pkg_setup
}

src_install() {
	local d
	DIRS=$(find /usr/share/blender/ -maxdepth 1 | tail -n +2)

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	for d_ver in ${DIRS} ; do
		d_install="${D}/${d_ver}/scripts/addons_contrib/${PLUGIN_NAME}"
		mkdir -p "${d_install}" || die
		chmod 775 "${d_install}" || die
		chown root:users "${d_install}" || die
		cp -a "${WORKDIR}/${PLUGIN_NAME}"/* "${d_install}" || die
		if use materials ; then
			echo "${D_MATERIALS}" > "${d_install}/.matlib_installed" || die
		fi
		K=$(echo "${REGISTRATION_HASH_SHA1}:${REGISTRATION_HASH_MD5}" | sha1sum | cut -c 1-40)
		einfo "Attempting to mark installation as registered..."
		touch "${d_install}/.registered" || die
		mkdir -p "${d_install}/addon" || die
		touch "${d_install}/addon/.installed" || die
		touch "${d_install}/.files_installed" || die

		if use system-cffi ; then
			pushd "${d_install}" || die
				rm _cffi_backend.cpython-*m-x86_64-linux-gnu.so libffi-*.so.*.*.* || die
			popd
		fi

		if use system-tbb ; then
			pushd "${d_install}" || die
				rm libtbbmalloc.so libtbb.so || die
			popd
		fi
	done
	if use materials ; then
		einfo "Copying materials..."
		mkdir -p "${D}/${D_MATERIALS}" || die
		cp -a "${S}"/matlib/feature_MaterialLibrary/* "${D}/${D_MATERIALS}" || die
		doenvd "${FILESDIR}"/99${PN}
	fi

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

pkg_postinst() {
	einfo "You must enable the addon manually."
	einfo "It is listed under: File > User Preferences > Add-ons > Testing > All > Render: Radeon ProRender"

	if use materials ; then
		einfo "The material library have been installed in:"
		einfo "${D_MATERIALS}"
	fi

	einfo "For this version, you are opt-in in sending render statistics to AMD.  See link below to disable this feature."
	einfo "https://radeon-pro.github.io/RadeonProRenderDocs/plugins/blender/debug.html"
}
