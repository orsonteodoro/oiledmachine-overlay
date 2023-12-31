# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TRAIN_USE_X=1
TRAIN_TEST_DURATION=20
PYTHON_COMPAT=( python3_{8..11} )
UOPTS_BOLT_EXCLUDE_BINS+="libOpenGLWindow.so" # \
# examples/OpenGLWindow/opengl_fontstashcallbacks.cpp:93: virtual void InternalOpenGL2RenderCallbacks::updateTexture(sth_texture*, sth_glyph*, int, int): Assertion `glGetError() == GL_NO_ERROR' failed.
inherit cmake flag-o-matic lcnr multilib-build python-single-r1 toolchain-funcs uopts

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
LICENSE+="
	BSD
	examples? ( BSD )
	extras? ( BSD )
"

# The ^^ ( LGPL-2.1+ BSD ) conditional was subsituted with BSD.
LICENSE+=" BSD ZLIB" # src/BulletDynamics/MLCPSolvers

# data/MPL, test/OpenCL/RadixSortBenchmark/
LICENSE+="
	demos? ( Apache-2.0 )
	test? ( Apache-2.0 )
"

# data/MPL/mpl2.xml ; the Apache-2.0 does not have all rights reserved but
#   the older 1.0 and 1.1 do
LICENSE+="
	demos? (
		all-rights-reserved
		Apache-2.0
	)
"

# data/quadruped
# examples/ThirdPartyLibs/Wavefront
LICENSE+="
	demos? ( BSD-2 )
	examples? ( BSD-2 )
"

# data/dinnerware (It actually says "CC-SA")
LICENSE+="
	demos? ( CC-BY-SA-4.0 )
"

# data/kuka_lwr/meshes_arm
LICENSE+="
	demos? ( CC-BY-3.0 )
"

# data/duck.dae
# examples/pybullet/gym/data/duck.dae # SCEA
LICENSE+="
	demos? ( SCEA )
	examples? ( SCEA )
"

# data/kitchens https://blog.turbosquid.com/royalty-free-license/
LICENSE+="
	demos? ( TurboSquid-Royalty-Free-License )
"

# docs/pybullet_quickstart_guide/WordpressPreview/markdeep.min.js
# docs/pybullet_quickstart_guide/WordpressPreview/PreviewBlogPage.htm
LICENSE+="
	doc? (
		BSD
		BSD-2
		GPL-2+
	)
"

# examples/ThirdPartyLibs/Eigen/src/SparseCholesky/SimplicialCholesky_impl.h
# The LGPL-2.1+ does not have all rights reserved.
LICENSE+="
	examples? (
		all-rights-reserved
		LGPL-2.1+
	)
"

# examples/ThirdPartyLibs/openvr/bin/osx64/OpenVR.framework/Headers/openvr_api.cs
# examples/ThirdPartyLibs/openvr/bin/osx64/OpenVR.framework/Headers/openvr_capi.h
#  just contains all-rights-reserved but no mention of other license
LICENSE+="
	examples? ( all-rights-reserved )
"

# In the root folder (examples/ThirdPartyLibs/openvr) it is BSD
LICENSE+="
	examples? ( BSD )
"

# examples/ThirdPartyLibs/Glew/CustomGL/wglew.h
LICENSE+="
	examples? (
		BSD
		MIT
	)
"

# examples/ThirdPartyLibs/clsocket/src/ActiveSocket.h
LICENSE+="
	examples? ( BSD-4 )
"

# examples/Importers/ImportBsp/BspLoader.cpp,
LICENSE+="
	examples? ( GPL-2+ )
"

# examples/ThirdPartyLibs/minizip/unzip.c
LICENSE+="
	examples? ( Info-ZIP )
"

# The ^^ ( MIT Unlicense ) conditional was subsituted with Unlicense
# You may fork the ebuild if you want the MIT license instead.
# examples/ThirdPartyLibs/imgui/stb_truetype.h
LICENSE+="
	examples? ( Unlicense )
"

# examples/ThirdPartyLibs/imgui/stb_textedit.h
LICENSE+="
	examples? ( imgui-public-domain )
"

# examples/TinyAudio ; modified MIT
LICENSE+="
	examples? ( RtAudio )
"

# examples/ThirdPartyLibs/midi ; modified MIT
LICENSE+="
	examples? ( RtMidi )
"

# examples/ThirdPartyLibs/optionalX11/LICENSE.txt
# examples/ThirdPartyLibs/optionalX11/X11/X.h
LICENSE+="
	examples? (
		optionalX11-KP
		optionalX11-OG
		optionalX11-OG-DEC
		optionalX11-SGCSI
	)
"

# examples/ThirdPartyLibs/Gwen,
# examples/ThirdPartyLibs/openvr/samples/shared/lodepng.h
# test/GwenOpenGLTest,
LICENSE+="
	examples? ( ZLIB )
	test? ( ZLIB )
"

# Extras/Serialize/makesdna/makesdna.cpp (First line says ZLIB for complete
#   rewrite in C++ but some parts look the same as original)
# The GPL-2+ license does not contain all rights reserved but in the source it
#   is explicit.
LICENSE+="
	extras? (
		all-rights-reserved
		GPL-2+
		ZLIB
	)
"

# build3/lcpp.lua,
# Extras/VHACD/inc/vhacdMutex.h
# examples/ThirdPartyLibs/glad/LICENSE.txt
# examples/ThirdPartyLibs/glad/KHR/khrplatform.h
# examples/ThirdPartyLibs/imgui
# examples/ThirdPartyLibs/lua-5.2.3/src/lua.h
# examples/ThirdPartyLibs/serial,
# src/clew/clew.h,
LICENSE+="
	MIT
	examples? (
		Apache-2.0
		MIT
	)
	extras? (
		MIT
	)
"

LICENSE+=" MPL-2.0" # some files in examples/ThirdPartyLibs/Eigen

# examples/pybullet/gym/pybullet_envs/agents # Apache-2.0
# examples/pybullet/gym/pybullet_data/husky/husky.urdf # BSD
LICENSE+="
	demos? (
		Apache-2.0
		BSD
	)
	examples? (
		Apache-2.0
		BSD
	)
	python? (
		Apache-2.0
		BSD
	)
"

# test/Bullet2/vectormath/neon/quat_aos.h
# the ZLIB does not have all rights reserved but in the source it is explicitly
#   stated
LICENSE+="
	test? (
		all-rights-reserved
		ZLIB
	)
"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SRC_URI="
https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	+bullet3
	+bullet-robotics
	+bullet-robotics-gui
	+convex-decomposition
	+demos
	doc
	-double-precision
	examples
	+extras
	+gimpactutils
	+graphical-benchmark
	+hacd
	+inverse-dynamics
	+network
	-numpy
	+obj2sdf
	-openmp
	-openvr
	-python
	+serialize
	-tbb
	test
	-threads
"
REQUIRED_USE+="
	bullet-robotics? ( extras )
	bullet-robotics-gui? ( extras )
	convex-decomposition? ( extras )
	demos? ( extras )
	examples? ( bullet-robotics network serialize )
	gimpactutils? ( extras )
	hacd? ( extras )
	inverse-dynamics? ( extras )
	numpy? ( python )
	obj2sdf? ( extras )
	openmp? ( threads )
	openvr? ( examples )
	pgo? ( examples )
	python? (
		${PYTHON_REQUIRED_USE}
		demos
	)
	serialize? ( extras )
	tbb? ( threads )
"
CDEPEND="
	python? (
		${PYTHON_DEPS}
		numpy? (
			$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
		)
	)
"
LEGACY_TBB_SLOT="2"
DEPEND+="
	${CDEPEND}
	media-libs/freeglut[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	demos? (
		media-libs/mesa[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
	tbb? (
		!<dev-cpp/tbb-2021:0=
		 <dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${CDEPEND}
	dev-util/patchelf
	doc? ( app-doc/doxygen[dot] )
"
PATCHES=(
	"${FILESDIR}/${PN}-2.85-soversion.patch"
	"${FILESDIR}/${PN}-3.24-fix-tbb-linking.patch"
)
DOCS=( AUTHORS.txt LICENSE.txt README.md )
# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="mirror test"
S="${WORKDIR}/${PN}3-${PV}"

pkg_setup() {
	use ebolt && ewarn "The ebolt USE flag may not generate a BOLT profile."
	use bolt && ewarn "The bolt USE flag may not generate a BOLT profile."
einfo
einfo "To hard unmask the USE=tbb add the following line to"
einfo "/etc/portage/profile/package.use.mask:"
einfo
einfo "  sci-physics/bullet -tbb"
einfo
	uopts_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# Allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

_src_configure() {
	# The tc-check-openmp does not print slot/version details
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
	${CC} --version
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	uopts_src_configure
	cd "${CMAKE_USE_DIR}" || die
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
		-DBUILD_INVERSE_DYNAMIC_EXTRA=$(usex inverse-dynamics)
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
		-DUSE_GRAPHICAL_BENCHMARK=$(usex graphical-benchmark)
	)
	if use tbb && has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DBULLET2_TBB_INCLUDE_DIR="/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DBULLET2_TBB_LIB_DIR="/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
	elif use tbb ; then
eerror
eerror "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT} must be installed from the"
eerror "oiledmachine-overlay."
eerror
		die
	fi
einfo
einfo "PGO_PHASE=${PGO_PHASE}"
einfo "BOLT_PHASE=${BOLT_PHASE}"
einfo

	cmake_src_configure
}

src_configure() { :; }

_src_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
}

train_pre_trainer() {
	local name="${@}"
cat > 0_Bullet3Demo.txt <<EOF
--start_demo_name=${name}
--mouse_move_multiplier=0.400000
--mouse_wheel_multiplier=0.010000
--background_color_red= 0.700000
--background_color_green= 0.700000
--background_color_blue= 0.800000
--fixed_timestep= 0.000000
EOF
}

train_post_trainer() {
	rm 0_Bullet3Demo.txt
}

is_benchmark_demo() {
	local x="${@}"
	# Typically 3 min runtime required
	local benchmark_demos=(
		"3000 boxes"
		"2000 stack"
		"1000 stack"
		"Ragdolls"
		"Convex stack"
		"Prim vs Mesh"
		"Convex vs Mesh"
		"Raycast"
		"Convex Pack"
		"Heightfield"
	)
	IFS=$'\n'
	local y
	for y in ${benchmark_demos[@]} ; do
		if [[ "${trainer}" == "${y}" ]] ; then
			IFS=$' \n\r\t'
			return 0
		fi
	done
	IFS=$' \n\r\t'
	return 1
}

train_trainer_list() {
	grep "ExampleEntry([01]" \
		"${S}/examples/ExampleBrowser/ExampleEntries.cpp" \
		| cut -f 2 -d '"' \
		| sort
}

train_override_duration() {
	local trainer="${1}"
	if is_benchmark_demo "${1}" ; then
		echo "180" # 3 min
	else
		echo "20" # seconds
	fi
}

train_get_trainer_exe() {
	echo "examples/ExampleBrowser/App_ExampleBrowser"
}

src_compile() {
	compile_abi() {
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
	if use doc; then
		doxygen || die
		HTML_DOCS+=( html/. )
		DOCS+=( docs/*.pdf )
	fi
}

sanitize_rpaths()
{
einfo
einfo "Running sanitize_rpaths()"
einfo
	for f in $(find "${ED}" -executable -type f) ; do
		ldd "${f}" 2>/dev/null 1>/dev/null || continue
		local old_rpath=$(patchelf --print-rpath "${f}")
		[[ "${old_rpath}" =~ "/var/tmp" ]] || continue
		einfo "Found dirty rpath for ${f}"
		einfo "Old unsanitized rpath for ${f}:"
		echo -e "${old_rpath}"
		einfo "New sanitized rpath for ${f}:"
		local old_rpath=$(echo "${old_rpath}" \
			| sed -E \
				-e "s|/var/tmp[^:]+||g" \
				-e "s|:+|:|g" \
				-e "s|^:||g" \
				-e "s|:$||g" \
				-e "s|^:$||g")
		patchelf --set-rpath "${old_rpath}" "${f}" || die
		echo -e "${old_rpath}"
		if (( ${#old_rpath} == 0 )) ; then
			patchelf --remove-rpath "${f}" || die
		else
			patchelf --set-rpath "${old_rpath}" "${f}" || die
		fi
		[[ "${old_rpath}" =~ "tmp" ]] && die "rpath is still unsanitized."
	done
	# There's no need to restore rpath for broken_rpaths libs/bins because
	# they are already installed in system folders.
}

fix_tbb_rpath() {
	if use tbb ; then
		local found=0
		local f

		for f in $(find "${ED}") ; do
			if ldd "${f}" 2>/dev/null | grep -q "tbb.*not found" ; then
einfo
einfo "Setting rpath for ${f} for TBB"
einfo
				local old_rpath=$(patchelf \
					--print-rpath \
					"${f}") || die
				[[ -n "${old_rpath}" ]] && old_rpath=":${old_rpath}"
				patchelf \
					--set-rpath \
					"/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}${old_rpath}" \
					"${f}" || die
			fi
		done
	fi
}

src_install() {
	install_abi() {
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
		if multilib_is_native_abi && use demos ; then
			for f in $(find "${BUILD_DIR}/examples" -type f) ; do
				local d=$(dirname $(echo "${f}" \
					| sed -e "s|${BUILD_DIR}||g"))
				exeinto "/usr/share/${PN}/demos/${d}"
				if file "${f}" | grep -q -e "executable" ; then
					doexe "${f}"
				elif file "${f}" | grep -q -e "shared object" ; then
					doexe "${f}"
				elif [[ "${f}" =~ "inverse_kinematics_pole.py" ]] ; then
					doexe "${f}"
				fi
			done
			insinto "/usr/share/${PN}/demos"
			doins -r "${BUILD_DIR}/data"
			insinto "/usr/share/${PN}/demos/pybullet"
			doins -r "${CMAKE_USE_DIR}/examples/pybullet/gym"
		fi
		uopts_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	if use examples ; then
		insinto "/usr/share/${PN}"
		doins -r "examples"
echo "This folder contains source code examples.  For compiled demos see" \
	>> "${ED}/usr/share/${PN}/examples/readme.txt" || die
echo "/usr/share/${PN}/demos" \
	>> "${ED}/usr/share/${PN}/examples/readme.txt" || die
	fi
	einstalldocs
	LCNR_SOURCE="${WORKDIR}/${PN}$(ver_cut 1 ${PV})-${PV}"
	lcnr_install_files
	fix_tbb_rpath
	sanitize_rpaths
}

pkg_postinst() {
	if use demos ; then
einfo
einfo "To properly render the TwoJoint do:"
einfo
einfo "  cd /usr/share/bullet/demos/data"
einfo "  /usr/share/bullet/demos/examples/TwoJoint/App_TwoJoint-${PV}"
einfo
		if use python ; then
einfo
einfo "To properly render the pybullet models do:"
einfo
einfo "  cd /usr/share/bullet/demos/data"
einfo "  ${EPYTHON} /usr/share/bullet/demos/examples/pybullet/examples/inverse_kinematics_pole.py"
einfo
		fi
	fi
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo
# OILEDMACHINE-OVERLAY-META-TAGS:  profile-guided-optimization
