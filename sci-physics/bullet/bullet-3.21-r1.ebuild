# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-single-r1 toolchain-funcs

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="http://www.bulletphysics.com/"

LICENSE="ZLIB" # The default license
# src/BulletCollision/Gimpact (it is really ^^ ( LGPL-2.1+ BSD ZLIB )),
# src/Bullet3OpenCL/NarrowphaseCollision/b3VoronoiSimplexSolver.cpp

# Additional licenses found:

# build3/cmake,
# Extras/ConvexDecomposition/bestfit.cpp
# examples/OpenGLWindow/TwFonts.h
# src/BulletCollision/NarrowPhaseCollision,
# src/Bullet3Collision/NarrowPhaseCollision/shared,
# src/Bullet3OpenCL/NarrowphaseCollision/kernels/mprKernels.h
LICENSE+=" BSD examples? ( BSD ) extras? ( BSD )"

# The ^^ ( LGPL-2.1+ BSD ) conditional was subsituted with BSD.
LICENSE+=" BSD ZLIB" # src/BulletDynamics/MLCPSolvers

# data/MPL, test/OpenCL/RadixSortBenchmark/
LICENSE+=" demos? ( Apache-2.0 ) test? ( Apache-2.0 )"

# data/MPL/mpl2.xml ; the Apache-2.0 does not have all rights reserved but
#   the older 1.0 and 1.1 do
LICENSE+=" demos? ( all-rights-reserved Apache-2.0 )"

# data/quadruped
# examples/ThirdPartyLibs/Wavefront
LICENSE+=" demos? ( BSD-2 ) examples? ( BSD-2 )"

LICENSE+=" demos? ( CC-BY-SA-4.0 )" # data/dinnerware (It actually says "CC-SA")
LICENSE+=" demos? ( CC-BY-3.0 )" # data/kuka_lwr/meshes_arm

# data/duck.dae
# examples/pybullet/gym/data/duck.dae # SCEA
LICENSE+=" demos? ( SCEA ) examples? ( SCEA )"

# data/kitchens https://blog.turbosquid.com/royalty-free-license/
LICENSE+=" demos? ( TurboSquid-Royalty-Free-License )"

# docs/pybullet_quickstart_guide/WordpressPreview/markdeep.min.js
# docs/pybullet_quickstart_guide/WordpressPreview/PreviewBlogPage.htm
LICENSE+=" doc? ( BSD-2 BSD GPL-2+ )"

# examples/ThirdPartyLibs/Eigen/src/SparseCholesky/SimplicialCholesky_impl.h
# The LGPL-2.1+ does not have all rights reserved.
LICENSE+=" examples? ( all-rights-reserved LGPL-2.1+ )"

# examples/ThirdPartyLibs/openvr/bin/osx64/OpenVR.framework/Headers/openvr_api.cs
# examples/ThirdPartyLibs/openvr/bin/osx64/OpenVR.framework/Headers/openvr_capi.h
#  just contains all-rights-reserved but no mention of other license
LICENSE+=" examples? ( all-rights-reserved )"

# In the root folder (examples/ThirdPartyLibs/openvr) it is BSD
LICENSE+=" examples? ( BSD )"

# examples/ThirdPartyLibs/Glew/CustomGL/wglew.h
LICENSE+=" examples? ( BSD MIT )"

# examples/ThirdPartyLibs/clsocket/src/ActiveSocket.h
LICENSE+=" examples? ( BSD-4 )"

# examples/Importers/ImportBsp/BspLoader.cpp,
LICENSE+=" examples? ( GPL-2+ )"

LICENSE+=" examples? ( Info-ZIP )" # examples/ThirdPartyLibs/minizip/unzip.c

# The ^^ ( MIT Unlicense ) conditional was subsituted with Unlicense
# You may fork the ebuild if you want the MIT license instead.
LICENSE+=" examples? ( Unlicense )" # examples/ThirdPartyLibs/imgui/stb_truetype.h

LICENSE+=" examples? ( imgui-public-domain )" # examples/ThirdPartyLibs/imgui/stb_textedit.h
LICENSE+=" examples? ( RtAudio )" # examples/TinyAudio ; modified MIT
LICENSE+=" examples? ( RtMidi )" # examples/ThirdPartyLibs/midi ; modified MIT

# examples/ThirdPartyLibs/optionalX11/LICENSE.txt
# examples/ThirdPartyLibs/optionalX11/X11/X.h
LICENSE+=" examples? ( optionalX11-KP optionalX11-OG optionalX11-OG-DEC optionalX11-SGCSI )"

# examples/ThirdPartyLibs/Gwen,
# examples/ThirdPartyLibs/openvr/samples/shared/lodepng.h
# test/GwenOpenGLTest,
LICENSE+=" examples? ( ZLIB ) test? ( ZLIB )"

# Extras/Serialize/makesdna/makesdna.cpp (First line says ZLIB for complete
#   rewrite in C++ but some parts look the same as original)
# The GPL-2+ license does not contain all rights reserved but in the source it
#   is explicit.
LICENSE+=" extras? ( all-rights-reserved GPL-2+ ZLIB )"

# build3/lcpp.lua,
# Extras/VHACD/inc/vhacdMutex.h
# examples/ThirdPartyLibs/glad/LICENSE.txt
# examples/ThirdPartyLibs/glad/KHR/khrplatform.h
# examples/ThirdPartyLibs/imgui
# examples/ThirdPartyLibs/lua-5.2.3/src/lua.h
# examples/ThirdPartyLibs/serial,
# src/clew/clew.h,
LICENSE+=" MIT examples? ( MIT Apache-2.0 ) extras? ( MIT )"

LICENSE+=" MPL-2.0" # some files in examples/ThirdPartyLibs/Eigen

# examples/pybullet/gym/pybullet_envs/agents # Apache-2.0
# examples/pybullet/gym/pybullet_data/husky/husky.urdf # BSD
LICENSE+=" examples? ( Apache-2.0 BSD ) demos? ( Apache-2.0 BSD ) python? ( Apache-2.0 BSD )"

# test/Bullet2/vectormath/neon/quat_aos.h
# the ZLIB does not have all rights reserved but in the source it is explicitly
#   stated
LICENSE+=" test? ( all-rights-reserved ZLIB )"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SRC_URI="
https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
SLOT="0/${PV}"
IUSE+=" +bullet3
	+bullet-robotics
	+bullet-robotics-gui
	+convex-decomposition
	+demos
	doc
	-double-precision
	examples
	+extras
	+gimpactutils
	+hacd
	+inverse-dynamic
	+network
	-numpy
	+obj2sdf
	-openmp
	-openvr
	-python
	+serialize
	-tbb
	test
	-threads"
REQUIRED_USE+="
	bullet-robotics? ( extras )
	bullet-robotics-gui? ( extras )
	convex-decomposition? ( extras )
	demos? ( extras )
	gimpactutils? ( extras )
	hacd? ( extras )
	inverse-dynamic? ( extras )
	numpy? ( python )
	obj2sdf? ( extras )
	openmp? ( threads )
	openvr? ( examples )
	python? (
		${PYTHON_REQUIRED_USE}
		demos
	)
	serialize? ( extras )
	tbb? ( threads )"
CDEPEND="python? (
		${PYTHON_DEPS}
		numpy? ( $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]') )
	 )"
DEPEND+=" ${CDEPEND}
	media-libs/freeglut[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	demos? (
		media-libs/mesa[${MULTILIB_USEDEP},egl]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
	tbb? ( <dev-cpp/tbb-2021:2= )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	dev-util/patchelf
	doc? ( app-doc/doxygen[dot] )"
PATCHES=( "${FILESDIR}"/${PN}-2.85-soversion.patch )
DOCS=( AUTHORS.txt LICENSE.txt README.md )
# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="mirror test"
S="${WORKDIR}/${PN}3-${PV}"
TBB_SLOT="2"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare
	# allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		local mycmakeargs=(
			-DBUILD_BULLET2_DEMOS=$(usex demos)
			-DBUILD_BULLET3=$(usex bullet3)
			-DBUILD_BULLET_ROBOTICS_GUI_EXTRA=$(usex bullet-robotics-gui)
			-DBUILD_BULLET_ROBOTICS_EXTRA=$(usex bullet-robotics)
			-DBUILD_CLSOCKET=$(usex network)
			-DBUILD_CONVEX_DECOMPOSITION_EXTRA=$(usex convex-decomposition)
			-DBUILD_ENET=$(usex network)
			-DBUILD_EXTRAS=$(usex extras)
			-DBUILD_GIMPACTUTILS_EXTRA=$(usex gimpactutils)
			-DBUILD_HACD_EXTRA=$(usex hacd)
			-DBUILD_INVERSE_DYNAMIC_EXTRA=$(usex inverse-dynamic)
			-DBUILD_OBJ2SDF_EXTRA=$(usex obj2sdf)
			-DBUILD_PYBULLET=$(multilib_native_usex python $(usex python) OFF)
			-DBUILD_PYBULLET_NUMPY=$(multilib_native_usex python $(usex numpy) OFF)
			-DBUILD_SERIALIZE_EXTRA=$(usex serialize)
			-DBUILD_SHARED_LIBS=ON
			-DBUILD_UNIT_TESTS=$(usex test)
			-DBULLET2_MULTITHREADING=$(usex threads)
			-DBULLET2_USE_OPEN_MP_MULTITHREADING=$(usex openmp)
			-DBULLET2_USE_TBB_MULTITHREADING=$(usex tbb)
			-DINSTALL_EXTRA_LIBS=ON
			-DINSTALL_LIBS=ON
			-DUSE_DOUBLE_PRECISION=$(usex double-precision)
			-DUSE_GRAPHICAL_BENCHMARK=OFF
		)
		if use tbb && has_version "dev-cpp/tbb:${TBB_SLOT}" ; then
			mycmakeargs+=(
				-DBULLET2_TBB_INCLUDE_DIR="/usr/include/tbb/2/tbb"
				-DBULLET2_TBB_LIB_DIR="/usr/lib64/tbb/2"
			)
		elif use tbb ; then
			die "dev-cpp/tbb:2 must be installed from the oiledmachine-overlay"
		fi
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	cmake-multilib_src_compile
	if use doc; then
		doxygen || die
		HTML_DOCS+=( html/. )
		DOCS+=( docs/*.pdf )
	fi
}

_install_licenses() {
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licen*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  -o -iname "*author*" \
	  -o -iname "*CONTRIBUTORS*" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licen" \
		-e "warrant" \
		$(find "${S}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'
}

sanitize_rpaths()
{
	einfo "Running sanitize_rpaths()"
	for f in $(find "${ED}" -executable -type f) ; do
		ldd "${f}" 2>/dev/null 1>/dev/null || continue
		local old_rpath=$(patchelf --print-rpath "${f}")
		[[ "${old_rpath}" =~ "/var/tmp" ]] || continue
		einfo "Found dirty rpath for ${f}"
		einfo "Old unsanitized rpath for ${f}:"
		echo -e "${old_rpath}"
		einfo "New sanitized rpath for ${f}:"
		local old_rpath=$(echo "${old_rpath}" \
			| sed -E -e "s|/var/tmp[^:]+||g" -e "s|^:||g" \
				-e "s|:$||g" -e "s|:+|:|g" -e "s|^:$||g")
		patchelf --set-rpath "${old_rpath}" "${f}" || die
		echo -e "${old_rpath}"
		if (( ${#old_rpath} == 0 )) ; then
			patchelf --remove-rpath "${f}" || die
		else
			patchelf --set-rpath "${old_rpath}" "${f}" || die
		fi
		[[ "${old_rpath}" =~ "tmp" ]] && die "rpath is still unsanitized."
		echo
	done
	# There's no need to restore rpath for broken_rpaths libs/bins because
	# they are already installed in system folders.
}

src_install() {
	cmake-multilib_src_install
	if use examples ; then
		insinto /usr/share/${PN}
		doins -r examples
		echo \
"This folder contains source code examples.  For compiled demos see \
/usr/share/${PN}/demos" \
			>> "${ED}/usr/share/${PN}/examples/readme.txt" || die
	fi
	einstalldocs
	install_abi() {
		if multilib_is_native_abi && use demos ; then
			for f in $(find "${BUILD_DIR}/examples" -executable -type f) ; do
				local d=$(dirname $(echo "${f}" | sed -e "s|${BUILD_DIR}||g"))
				exeinto /usr/share/${PN}/demos/${d}
				if ldd "${f}" 2>/dev/null 1>/dev/null ; then
					doexe "${f}"
				elif [[ "${f}" =~ inverse_kinematics_pole.py ]] ; then
					doexe "${f}"
				fi
			done
			insinto /usr/share/${PN}/demos
			doins -r "${BUILD_DIR}/data"
			insinto /usr/share/${PN}/demos/pybullet
			doins -r "${BUILD_DIR}/examples/pybullet/gym"
		fi
	}
	multilib_foreach_abi install_abi
	_install_licenses
	sanitize_rpaths
}

pkg_postinst() {
	if use demos ; then
		einfo
		einfo "To properly render the TwoJoint do:"
		einfo "  cd /usr/share/bullet/demos/data"
		einfo \
"  /usr/share/bullet/demos/examples/TwoJoint/App_TwoJoint-${PV}"
		einfo
		einfo "To properly render the pybullet models do:"
		einfo "  cd /usr/share/bullet/demos/data"
		einfo \
"  ${EPYTHON} /usr/share/bullet/demos/examples/pybullet/examples/inverse_kinematics_pole.py"
	fi
}
