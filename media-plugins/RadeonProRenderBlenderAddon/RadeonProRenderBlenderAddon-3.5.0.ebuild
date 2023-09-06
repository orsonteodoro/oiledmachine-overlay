# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# It supports Python 3.7 but 3.7 is deprecated in this distro in python-utils-r1.eclass.
PYTHON_COMPAT=( python3_{9..11} )
LLVM_MAX_SLOT=15
# Blender:head :: 15 14 13 12 11
# Blender:3.6 :: 15 14 13 12 11
# Blender:3.3 :: 13 12 11
LLVM_SLOTS=( 15 14 13 12 11 )

inherit check-reqs git-r3 linux-info llvm python-r1 unpacker

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for
Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
# The default license is Apache-2.0, the rest are third party.
RPRSC_LICENSE="
	Apache-2.0
	MIT
	BSD
	MPL-2.0
	Boost-1.0
"
RPRSDK_LICENSE="
	Apache-2.0
	BSD
	MIT
	Khronos-IP-framework
	BSD-2
"
RIF_LICENSE="
	Apache-2.0
	MIT
	UoI-NCSA
"
# See https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/v3.3.5/src/rprblender/EULA.html
RPRBLENDER_EULA_LICENSE="
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES
	SPA-DISCLAIMER-DATA-AND-SOFTWARE
	PSF-2
	CC-BY
	BSD
	MIT
	Khronos-IP-framework
"
LICENSE="
	Apache-2.0
	${RPRSC_LICENSE}
	${RPRSDK_LICENSE}
	${RIF_LICENSE}
	${RPRBLENDER_EULA_LICENSE}
"
# KEYWORDS="~amd64" ebuild is still a Work In Progress (WIP) and needs testing.
PLUGIN_NAME="rprblender"
# Ceiling values based on python compatibility matching the particular Blender
# version.
MIN_BLENDER_PV="2.80"
MAX_BLENDER_PV="3.5" # exclusive
SLOT="0"
IUSE+="
blender-lts-3_3 blender-master blender-stable denoiser
intel-ocl +matlib +opencl opencl_rocr opencl_orca -systemwide video_cards_amdgpu
video_cards_intel video_cards_nvidia video_cards_radeonsi +vulkan
"
NV_DRIVER_VERSION_OCL_1_2="368.39" # >= OpenCL 1.2
NV_DRIVER_VERSION_VULKAN="390.132"
# Systemwide is preferred but currently doesn't work but did in the past in <2.0
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	!systemwide
	blender-lts-3_3? (
		python_targets_python3_10
		python_targets_python3_11
	)
	blender-master? (
		python_targets_python3_10
		python_targets_python3_11
	)
	blender-stable? (
		python_targets_python3_10
		python_targets_python3_11
	)
	opencl_orca? (
		video_cards_amdgpu
	)
	opencl_rocr? (
		video_cards_amdgpu
	)
	video_cards_amdgpu? (
		!video_cards_radeonsi
		|| (
			opencl_orca
			opencl_rocr
		)
	)
	|| (
		blender-lts-3_3
		blender-master
		blender-stable
	)
"
# Assumes U 18.04.03 minimal
CDEPEND_NOT_LISTED="
	dev-lang/python[xml]
	sys-devel/gcc[openmp]
"
DEPEND_NOT_LISTED=""
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.3.5/README-LNX.md#build-requirements
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
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				media-gfx/blender[llvm-${s}]
				sys-libs/libomp:${s}
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
# See https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderBlenderAddon/blob/v3.3.5/README-LNX.md#addon-runuse-linux-ubuntu-requirements

RDEPEND+="
	${CDEPEND_NOT_LISTED}
	${RDEPEND_NOT_LISTED}
	>=media-libs/embree-2.12.0
	>=media-libs/openimageio-1.6
	>=media-libs/freeimage-3.17.0[jpeg,jpeg2k,openexr,png,raw,tiff,webp]
	blender-lts-3_3? (
		$(python_gen_any_dep "
			=media-gfx/blender-3.3*["'${PYTHON_SINGLE_USEDEP}'"]
		")
	)
	blender-master? (
		$(python_gen_any_dep "
			=media-gfx/blender-9999*["'${PYTHON_SINGLE_USEDEP}'"]
		")
	)
	blender-stable? (
		$(python_gen_any_dep "
			<media-gfx/blender-9999["'${PYTHON_SINGLE_USEDEP}'"]
			>=media-gfx/blender-3.4["'${PYTHON_SINGLE_USEDEP}'"]
		")
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
				opencl_orca? (
					dev-libs/amdgpu-pro-opencl
				)
				opencl_rocr? (
					dev-libs/rocm-opencl-runtime
				)
			)
			video_cards_intel? (
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
	$(python_gen_cond_dep 'dev-python/pip[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pytest-3[${PYTHON_USEDEP}]')
	>=dev-util/cmake-3.11
	app-arch/makeself
	dev-util/patchelf
	dev-cpp/castxml
	dev-vcs/git
"
RIF_PV="1.7.2"
RPRSDK_PV="2.2.16"
RPRSC_PV="9999"
# Commits based on left side.  The commit associated with the message (right) differs
# with the commit associated with the folder (left) on the GitHub website.
EGIT_COMMIT_RIF="76068b7ca29aa8a7f29f65475f334981f0dd5e53"
EGIT_COMMIT_RPRSC="6608117fcddd783e81b2aedc2c1abdf0b449d465"
EGIT_COMMIT_RPRSDK="c6424e29169743cd5a05c10593a2665dfedb185c"
RIF_DF="RadeonImageFilter-${RIF_PV}-${EGIT_COMMIT_RIF:0:7}.tar.gz"
RPRSC_DF="RadeonProRenderSharedComponents-${RPRSC_PV}-${EGIT_COMMIT_RPRSC:0:7}.tar.gz"
RPRSDK_DF="RadeonProRenderSDK-${RPRSDK_PV}-${EGIT_COMMIT_RPRSDK:0:7}.tar.gz"
GH_ORG_BURI="https://github.com/GPUOpen-LibrariesAndSDKs"

# Download limits?
#${GH_ORG_BURI}/RadeonImageFilter/archive/${EGIT_COMMIT_RIF}.tar.gz
#	-> ${RIF_DF}

SRC_URI="
${GH_ORG_BURI}/RadeonProRenderBlenderAddon/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
${GH_ORG_BURI}/RadeonProRenderSDK/archive/${EGIT_COMMIT_RPRSDK}.tar.gz
	-> ${RPRSDK_DF}
${GH_ORG_BURI}/RadeonProRenderSharedComponents/archive/${EGIT_COMMIT_RPRSC}.tar.gz
	-> ${RPRSC_DF}
"
RESTRICT="mirror strip"
S="${WORKDIR}/${P}"
S_RIF="${WORKDIR}/RadeonImageFilter-${EGIT_COMMIT_RIF}"
S_RPRSDK="${WORKDIR}/RadeonProRenderSDK-${EGIT_COMMIT_RPRSDK}"
S_RPRSC="${WORKDIR}/RadeonProRenderSharedComponents-${EGIT_COMMIT_RPRSC}"
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
	for s in ${LLVM_SLOTS[@]} ; do
		if use denoiser \
			&& has_version "media-gfx/blender[llvm-${s}]" \
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

	use blender-lts-3_3 && export LLVM_MAX_SLOT=15
	use blender-master && export LLVM_MAX_SLOT=15
	use blender-stable && export LLVM_MAX_SLOT=13

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
	if cat /proc/cpuinfo | grep sse2 2>/dev/null 1>/dev/null ; then
einfo
einfo "CPU is compatible."
einfo
	else
ewarn
ewarn "CPU may not be compatible.  ${PN} requires SSE2."
ewarn
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

get_rif() {
	EGIT_MIN_CLONE_TYPE="single"
	EGIT_COMMIT="${EGIT_COMMIT_RIF}"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${S}/RadeonProImageProcessingSDK"
	EGIT_REPO_URI="https://github.com/GPUOpen-LibrariesAndSDKs/RadeonImageFilter.git"
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf RadeonProImageProcessingSDK \
		RadeonProRenderSDK \
		RadeonProRenderSharedComponents || die
#	ln -s "${S_RIF}" "RadeonProImageProcessingSDK" || die
	ln -s "${S_RPRSDK}" "RadeonProRenderSDK" || die
	ln -s "${S_RPRSC}" "RadeonProRenderSharedComponents" || die
	get_rif
}

src_prepare() {
	ewarn "This is the release build."
	default
	eapply "${FILESDIR}/rpr-3.5.2-more-generic-call-python3.patch"
	eapply "${FILESDIR}/rpr-${PV}-bump-version.patch"
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

einfo
einfo "Installing addon in shared"
einfo

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

	# Denoiser may need libiomp.so.5

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
