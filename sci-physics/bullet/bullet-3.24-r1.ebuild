# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic multilib-build python-single-r1 toolchain-funcs virtualx

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
	pgo
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
		numpy? ( $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]') )
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
	pgo? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.85-soversion.patch
)
DOCS=( AUTHORS.txt LICENSE.txt README.md )
# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="mirror test"
S="${WORKDIR}/${PN}3-${PV}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
	# Allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
}

_configure() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	if [[ "${PGO_PHASE}" == "pgo" ]] ; then
		cd "${BUILD_DIR}" || die
		rm -rf "${BUILD_DIR}" || die
	fi
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
	if [[ "${PGO_PHASE}" == "pg0" ]] ; then
einfo
einfo "Skipping PGO / Normal build"
einfo
	elif [[ "${PGO_PHASE}" == "pgi" ]] ; then
einfo
einfo "Instrumenting build"
einfo
	elif [[ "${PGO_PHASE}" == "pgo" ]] ; then
einfo
einfo "Optimizing build"
einfo
	fi

	filter-flags -fprofile*
	local pgo_datadir="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}"
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags -fprofile-generate="${pgo_datadir}"
		else
			append-flags -fprofile-generate -fprofile-dir="${pgo_datadir}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${pgo_datadir}/pgo-custom.profdata" \
				"${pgo_datadir}" || die
			append-flags -fprofile-use="${pgo_datadir}/pgo-custom.profdata"
		else
			append-flags -fprofile-use -fprofile-dir="${pgo_datadir}"
		fi
	fi

	cmake_src_configure
}

src_configure() { :; }

_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
	cd "${BUILD_DIR}" || die
	cmake_src_compile
}

_set_demo() {
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

_run_demo() {
	local duration="${1}"
	shift 1
	local name="${@}"
	local now=$(date +"%s")
	local done_at=$((${now} + ${duration}))
	local done_at_s=$(date --date="@${done_at}")
einfo
einfo "Running '${name}' demo for ${duration}s to be completed at"
einfo "${done_at_s}"
einfo
cat > "run.sh" <<EOF
#!/bin/sh
timeout -s 3 ${duration} examples/ExampleBrowser/App_ExampleBrowser &
sleep ${duration}
true
EOF
	chmod +x "run.sh" || die
	virtx ./run.sh
	rm run.sh || die
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
		if [[ "${x}" == "${y}" ]] ; then
			IFS=$' \n\r\t'
			return 0
		fi
	done
	IFS=$' \n\r\t'
	return 1
}

_train() {
	# Sandbox violation prevention
	export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache" # Prevent sandbox violation
	export MESA_SHADER_CACHE_DIR="${HOME}/mesa_shader_cache"
	for x in $(find /dev/input -name "event*") ; do
		einfo "Adding \`addwrite ${x}\` sandbox rule"
		addwrite "${x}"
	done

	# See examples/ExampleBrowser/ExampleEntries.cpp under each ExampleEntry
	local all_demos=(
	)

	local pgo_datadir="${T}/pgo-${MULTILIB_ABI_FLAG}.${ABI}"
	IFS=$'\n'
	local x
	for x in $(grep "ExampleEntry([01]" \
			"${S}/examples/ExampleBrowser/ExampleEntries.cpp" \
			| cut -f 2 -d '"' \
			| sort) ; do
		local duration=20 # seconds
		if is_benchmark_demo "${x}" ; then
			duration=180 # 3 min
		fi
		_set_demo "${x}"
		_run_demo "${duration}" "${x}"
		rm 0_Bullet3Demo.txt || die
		if use pgo &&  tc-is-gcc ; then
			if ! find "${pgo_datadir}" -name "*.gcda" \
				2>/dev/null 1>/dev/null ; then
ewarn
ewarn "Didn't generate a PGO profile"
ewarn
			fi
		elif use pgo && tc-is-clang ; then
			if ! find "${pgo_datadir}" -name "*.profraw" \
				2>/dev/null 1>/dev/null ; then
ewarn
ewarn "Didn't generate a PGO profile"
ewarn
			fi
		fi
	done
	IFS=$' \n\r\t'
	if use pgo && tc-is-gcc ; then
		if ! find "${pgo_datadir}" -name "*.gcda" ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	elif use pgo && tc-is-clang ; then
		if ! find "${pgo_datadir}" -name "*.profraw" ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	fi
	# It doesn't close some of them.
	killall -9 App_ExampleBrowser || die
}

src_compile() {
	compile_abi() {
		if use pgo ; then
			# PGO on average is 10% performance benefit
			PGO_PHASE="pgi"
			_configure
			_compile
			_train
			PGO_PHASE="pgo"
			_configure
			_compile
		else
			PGO_PHASE="pg0"
			_configure
			_compile
		fi
	}
	multilib_foreach_abi compile_abi
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
	install_abi() {
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
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
			doins -r "${CMAKE_USE_DIR}/examples/pybullet/gym"
		fi
	}
	multilib_foreach_abi install_abi
	cd "${S}" || die
	if use examples ; then
		insinto /usr/share/${PN}
		doins -r examples
echo "This folder contains source code examples.  For compiled demos see" \
	>> "${ED}/usr/share/${PN}/examples/readme.txt" || die
echo "/usr/share/${PN}/demos" \
	>> "${ED}/usr/share/${PN}/examples/readme.txt" || die
	fi
	einstalldocs
	_install_licenses
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
einfo "To properly render the pybullet models do:"
einfo
einfo "  cd /usr/share/bullet/demos/data"
einfo "  ${EPYTHON} /usr/share/bullet/demos/examples/pybullet/examples/inverse_kinematics_pole.py"
einfo
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo
# OILEDMACHINE-OVERLAY-META-TAGS:  profile-guided-optimization
