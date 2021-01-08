# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
inherit cmake-multilib python-r1

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
# examples/ThirdPartyLibs/glad/KHR/khrplatform.h
# examples/ThirdPartyLibs/imgui
# examples/ThirdPartyLibs/lua-5.2.3/src/lua.h
# examples/ThirdPartyLibs/serial,
# src/clew/clew.h,
LICENSE+=" MIT examples? ( MIT ) extras? ( MIT )"

LICENSE+=" MPL-2.0" # some files in examples/ThirdPartyLibs/Eigen

# examples/pybullet/gym/pybullet_envs/agents # Apache-2.0
# examples/pybullet/gym/pybullet_data/husky/husky.urdf # BSD
LICENSE+=" examples? ( Apache-2.0 BSD ) demos? ( Apache-2.0 BSD ) python? ( Apache-2.0 BSD )"

# test/Bullet2/vectormath/neon/quat_aos.h
# the ZLIB does not have all rights reserved but in the source it is explicitly
#   stated
LICENSE+=" test? ( all-rights-reserved ZLIB )"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SRC_URI=\
"https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0/${PV}"
IUSE+=" +bullet3 +demos doc -double-precision examples +extras +networking -numpy -python test"
REQUIRED_USE+="
	demos? ( extras )
	numpy? ( python )
	python? ( demos )"
BRDEPEND="python? (
		${PYTHON_DEPS}
		numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	  )"
DEPEND="demos? (
		media-libs/mesa[${MULTILIB_USEDEP},egl]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
	media-libs/freeglut[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]"
RDEPEND="${BRDEPEND}
	 ${DEPEND}"
BDEPEND="${BRDEPEND}
	 doc? ( app-doc/doxygen[dot] )"
PATCHES=( "${FILESDIR}"/${PN}-2.85-soversion.patch )
DOCS=( AUTHORS.txt LICENSE.txt README.md )
# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="mirror test"
S="${WORKDIR}/${PN}3-${PV}"

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
			-DBUILD_CLSOCKET=$(usex networking)
			-DBUILD_ENET=$(usex networking)
			-DBUILD_EXTRAS=$(usex extras)
			-DBUILD_PYBULLET=$(multilib_native_usex python $(usex python) OFF)
			-DBUILD_PYBULLET_NUMPY=$(multilib_native_usex python $(usex numpy) OFF)
			-DBUILD_SHARED_LIBS=ON
			-DBUILD_UNIT_TESTS=$(usex test)
			-DINSTALL_EXTRA_LIBS=ON
			-DINSTALL_LIBS=ON
			-DUSE_DOUBLE_PRECISION=$(usex double-precision)
			-DUSE_GRAPHICAL_BENCHMARK=OFF
		)
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

src_install() {
	cmake-multilib_src_install
	use examples && DOCS+=( examples )
	einstalldocs
	install_abi() {
		if multilib_is_native_abi && use demos ; then
			for f in $(find "${BUILD_DIR}/examples" -executable -type f) ; do
				local d=$(dirname $(echo "${f}" | sed -e "s|${BUILD_DIR}||g"))
				exeinto /usr/share/${PN}/demos/${d}
				if readelf -h "${f}" | grep -q -E -e "ELF(32|64)" ; then
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
}

pkg_postinst() {
	if use demos ; then
		einfo
		einfo "To properly render the TwoJoint do:"
		einfo "  cd /usr/share/bullet/demos/data"
		einfo \
"  /usr/share/bullet/demos/examples/TwoJoint/App_TwoJoint-2.89"
		einfo
		einfo "To properly render the pybullet models do:"
		einfo "  cd /usr/share/bullet/demos/data"
		einfo \
"  python3 /usr/share/bullet/demos/examples/pybullet/examples/inverse_kinematics_pole.py"
	fi
}
