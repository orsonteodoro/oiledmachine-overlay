# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender common implementation
# @DESCRIPTION:
# The blender eclass helps reduce code duplication
# across the blender eclasses to reduce maintenance cost.

PGO_SAMPLE_SIZE_=${PGO_SAMPLE_SIZE:=30}

inherit eapi7-ver
inherit blender-multibuild check-reqs cmake-utils flag-o-matic llvm pax-utils \
	python-single-r1 toolchain-funcs xdg

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS=${KEYWORDS:="~amd64 ~x86"}

LICENSE=" || ( GPL-2 BL )
all-rights-reserved
LGPL-2.1+
MPL-2.0
build_creator? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
build_headless? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
cycles? (
	Apache-2.0
	Boost-1.0
	BSD
	MIT
)
"
PROPERTIES=interactive # For PGO

# intern/mikktspace contains ZLIB
# intern/CMakeLists.txt contains GPL+ with all-rights-reserved ; there is no
#   all rights reserved in the vanilla GPL-2

# Slotting is for scripting and plugin compatibility
SLOT="${PV}"
SLOT_MAJ=${SLOT%/*}
RESTRICT="mirror !test? ( test )"

BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:=latest}

# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org tarball is preferred because they
# bundle all the dependencies.
if [[ "${PV}" == "2.83" ]] ; then
SRC_URI="https://download.blender.org/source/blender-${PV}.0.tar.xz"
elif ver_test $(ver_cut 1-2 ${PV}) -ge 2.81 ; then
SRC_URI="https://download.blender.org/source/blender-${PV}.tar.xz"
else
SRC_URI="https://download.blender.org/source/${P}.tar.gz"
fi

X86_CPU_FLAGS=( mmx:mmx sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 lzcnt:lzcnt \
sse4_1:sse4_1 sse4_2:sse4_2 avx:avx f16c:f16c fma:fma bmi:bmi avx2:avx2 \
avx512f:avx512f avx512er:avx512er avx512dq:avx512dq )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE+=" ${CPU_FLAGS[@]%:*}"
IUSE="${IUSE/cpu_flags_x86_mmx/+cpu_flags_x86_mmx}"
IUSE="${IUSE/cpu_flags_x86_sse /+cpu_flags_x86_sse }"
IUSE="${IUSE/cpu_flags_x86_sse2/+cpu_flags_x86_sse2}"
IUSE+=" pgo
	pgo-trainer-cycles-still
	pgo-trainer-cycles-anim
	pgo-trainer-eevee-still
	pgo-trainer-eevee-anim
"

# Assets categories are listed in https://www.blender.org/download/demo-files/
# PGO is not ready yet
REQUIRED_USE+="
	pgo-trainer-cycles-still? ( pgo )
	pgo-trainer-cycles-anim? ( pgo )
	pgo-trainer-eevee-still? ( pgo )
	pgo-trainer-eevee-anim? ( pgo )
"

# At the source code level, they mix the sse2 intrinsics functions up with the
#   __KERNEL_SSE__.
REQUIRED_USE_MINIMAL_CPU_FLAGS="
	!cpu_flags_x86_mmx? ( !cpu_flags_x86_sse !cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2? ( !cpu_flags_x86_sse? ( cpu_flags_x86_mmx ) )
"

REQUIRED_USE_CYCLES="
	cycles? (
		openexr tiff openimageio osl? ( llvm )
		amd64? ( cpu_flags_x86_sse2 )
		x86? ( cpu_flags_x86_sse2 )
		cpu_flags_x86_sse? ( cpu_flags_x86_sse2 )
		cpu_flags_x86_sse2? ( cpu_flags_x86_sse )
		cpudetection? (
			cpu_flags_x86_avx? ( cpu_flags_x86_sse )
			cpu_flags_x86_avx2? ( cpu_flags_x86_sse )
		)
		!cpudetection? (
			amd64? (
				cpu_flags_x86_sse4_1? ( cpu_flags_x86_sse3 )
				cpu_flags_x86_avx? ( cpu_flags_x86_sse4_1 )
				cpu_flags_x86_avx2? ( cpu_flags_x86_avx
							cpu_flags_x86_sse4_1
							cpu_flags_x86_fma
							cpu_flags_x86_lzcnt
							cpu_flags_x86_bmi
							cpu_flags_x86_f16c )
			)
			cpu_flags_x86_sse3? ( cpu_flags_x86_sse2
						cpu_flags_x86_ssse3 )
			cpu_flags_x86_ssse3? ( cpu_flags_x86_sse3 )
		)
	)
"

# See https://gitlab.com/libeigen/eigen/-/blob/3.3.7/Eigen/Core
REQUIRED_USE_EIGEN="
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse3
		cpu_flags_x86_ssse3
		cpu_flags_x86_sse4_1
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx512er? ( cpu_flags_x86_avx512f )
	cpu_flags_x86_avx512dq? ( cpu_flags_x86_avx512f )
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_fma
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
	)
"

REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	${REQUIRED_USE_EIGEN}
	${REQUIRED_USE_CYCLES}
	${REQUIRED_USE_MINIMAL_CPU_FLAGS}
"

RDEPEND+="
	pgo? (
		app-admin/sudo
		x11-base/xorg-server
	)
"

# This could be modded for multiabi builds.
declare -A _LD_LIBRARY_PATHS
declare -A _LIBGL_DRIVERS_DIRS
declare -A _LIBGL_DRIVERS_PATHS
declare -A _PATHS

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_prepare src_configure src_compile \
	src_install src_test pkg_postinst pkg_postrm

get_dest() {
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		echo "/usr/share/${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	else
		echo "/usr/$(get_libdir)/${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	fi
}

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

# Dependency PreFiX
dpfx() {
	echo "/usr/$(get_libdir)/${PN}"
}

# EROOT Dependency PreFiX
erdpfx() {
	echo "${EROOT}/$(dpfx)"
}

blender_pkg_pretend() {
	blender_check_requirements
}

check_embree() {
	# There is no standard embree ebuild.  Assume other repo or local copy.

	if has embree ${IUSE_EFFECTIVE} && use embree ; then
		# The default for EMBREE_FILTER_FUNCTION is ON in embree.
		if grep -q -F -e "EMBREE_FILTER_FUNCTION=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild 2>/dev/null ; then
			ewarn "EMBREE_FILTER_FUNCTION should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-filter_function]' || \
				has_version 'media-libs/embree[-filter-function]' || \
				has_version 'media-libs/embree[-filterfunction]' ; then
				ewarn "EMBREE_FILTER_FUNCTION should be set to ON for embree."
			fi
		fi

		# The default for EMBREE_BACKFACE_CULLING is OFF in embree.
		if grep -q -F -e "EMBREE_BACKFACE_CULLING=ON" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild 2>/dev/null ; then
			ewarn "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
		else
			if has_version 'media-libs/embree[backface_culling]' || \
				has_version 'media-libs/embree[backface-culling]' || \
				has_version 'media-libs/embree[backfaceculling]' ; then
				ewarn "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
			fi
		fi

		# The default for EMBREE_RAY_MASK is OFF in embree.
		if grep -q -F -e "EMBREE_RAY_MASK=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild 2>/dev/null ; then
			ewarn "EMBREE_RAY_MASK should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-ray_mask]' || \
				has_version 'media-libs/embree[-ray-mask]' || \
				has_version 'media-libs/embree[-raymask]' ; then
				ewarn "EMBREE_RAY_MASK should be set to ON for embree."
			elif has_version 'media-libs/embree[ray_mask]' || \
				has_version 'media-libs/embree[ray-mask]' || \
				has_version 'media-libs/embree[raymask]' ; then
				:;
			elif has_version 'media-libs/embree' ; then
				ewarn "EMBREE_RAY_MASK should be set to ON for embree."
			fi
		fi
	fi
}

check_compiler() {
	test-flags-CXX "-std=c++${CXXABI_V}" 2>/dev/null 1>/dev/null \
		|| die "Switch to a c++${CXXABI_V} compatible compiler."
	if tc-is-gcc ; then
		if ver_test $(gcc-fullversion) -lt ${GCC_MIN} ; then
			die "${PN} requires GCC >= ${GCC_MIN}"
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_MIN} ; then
			die "${PN} requires Clang >= ${CLANG_MIN}"
		fi
	else
		die "Compiler is not supported"
	fi
}

blender_pkg_setup() {
#      [ebuild developer note - rough draft]
#      PGO Trainer (PGT) Options and still deciding:
#      #1 - run the trainer as root accelerated (easiest but risky if assets are
#           not vetted and assumed not)
#      #2 - run the trainer as non-root with accelerated separate pgo account
#           and video group permission (preferred in order to use GPU header
#           only data structures like nvdb, follows typical use)
#      #3 - run the trainer with headless software rendering (distro standard
#           possibly skips nvdb code paths, fastest, but not typical. PGO
#           assumes typical use or else performance regression)
	if use pgo ; then
ewarn
ewarn "The pgo USE flag is in development"
ewarn
		if ! id pgo ; then
eerror
eerror "PGO requires a pgo system account in the video group with a password."
eerror "Increase timestamp_timeout if frequent password request annoys you."
eerror
die
		fi
		if [[ $(id pgo) =~ "(video)" ]] ; then
eerror
eerror "The pgo system account must be in the video group."
eerror
die
		fi
		if [[ $(passwd --status pgo | cut -f 2 -d " ") != "P" ]] ; then
eerror
eerror "The pgo system account must have a password."
eerror
die
		fi
	fi

	llvm_pkg_setup
	blender_check_requirements
	python-single-r1_pkg_setup
	check_amdgpu_pro
	check_cpu
	check_optimal_compiler_for_cycles_x86
	check_embree
	check_compiler
	if declare -f _blender_pkg_setup > /dev/null ; then
		_blender_pkg_setup
	fi
}

check_amdgpu_pro() {
	if ( has_version 'x11-drivers/amdgpu-pro[opengl_pro]' ) \
	|| ( has_version 'x11-drivers/amdgpu-pro-lts[opengl_pro]' ); then
		die \
"You must switch to x11-drivers/amdgpu-pro[opengl_mesa] or \
x11-drivers/amdgpu-pro-lts[opengl_mesa] instead"
	fi
}

check_portable_dependencies() {
	# The idea with Blender player was to share games.
	# It requires all dependencies of Blender to be generically compiled.

	# About the player:
# https://docs.blender.org/manual/en/2.79/game_engine/blender_player.html
	# Game licensing details:
# https://docs.blender.org/manual/en/2.79/game_engine/licensing.html

	# Libraries also get statically linked to reduce the complexity of
	# running the game on different machines.

	# Best way to make it portable is maybe chroot or by docker container.
	# This way you keep system packages optimized, the container or chroot
	# image is portable.
	if has build_portable ${IUSE_EFFECTIVE} ; then
		if use build_portable ; then
			if [[ "${ABI}" == "x86" ]] ; then
				[[ "${CXXFLAGS}" =~ "march=x86-64" ]] \
					|| ewarn \
"The CXXFLAGs doesn't contain -march=x86-64.  It will not be portable unless \
you change it."
			fi
			if [[ "${ABI}" == "x86" ]] ; then
				[[ "${CXXFLAGS}" =~ "march=i686" ]] \
					|| ewarn \
"The CXXFLAGs doesn't contain -march=i686.  It will not be portable unless \
you change it."
			fi
			# These are .a libraries listed from the linking phase
			# of build_portable
			#
			# Mesa is listed because it was shipped in the Blender
			# binary distribution.  This may be required
			# when distributing games with Blender player.
			RDEPEND_279=(
				"dev-libs/boost"
				"blender-libs/mesa"
				"blender-libs/openvdb"
				"blender-libs/osl"
				"dev-libs/libpcre"
				"dev-libs/libspnav"
				"media-libs/opensubdiv"
				"media-libs/openjpeg"
				"sci-libs/fftw"
				"sys-libs/zlib"
			)
			for p in ${RDEPEND_279[@]} ; do
				if ls "${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS \
					2>/dev/null 1>/dev/null ; then
					if [[ "${ABI}" == "amd64" ]] ; then
						grep -q -F -e "march=x86-64" \
							"${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS \
							|| ewarn \
"${p} is not compiled with -march=x86-64.  It is not portable.  Recompile the \
dependency."
					fi
					if [[ "${ABI}" == "x86" ]] ; then
						grep -q -F -e "march=i686" \
							"${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS \
							|| ewarn \
"${p} is not compiled with -march=i686.  It is not portable.  Recompile the \
dependency"
					fi
				fi
			done
		fi
	fi
}

check_cpu() {
	if [[ ! -e "/proc/cpuinfo" ]] ; then
		ewarn "Skipping cpu checks.  The compiled program may exhibit runtime failure."
		return
	fi

	# Sorted by chronological order to be able to disable remaining
	# incompatible.
	grep -q -i -E -e 'mmx( |$)' /proc/cpuinfo # 1997
	local has_mmx="$?"
	grep -q -i -E -e 'sse( |$)' /proc/cpuinfo # 1999
	local has_sse="$?"
	grep -q -i -E -e 'sse2( |$)' /proc/cpuinfo # 2000
	local has_sse2="$?"
	grep -q -i -E -e 'sse3( |$)' /proc/cpuinfo # 2004
	local has_sse3="$?"
	grep -q -i -E -e 'pni( |$)' /proc/cpuinfo # 2004, equivalent to sse3
	local has_pni="$?"
	grep -q -i -E -e 'ssse3( |$)' /proc/cpuinfo # 2006
	local has_ssse3="$?"
	grep -q -i -E -e 'abm( |$)' /proc/cpuinfo # 2007
	local has_abm="$?"
	grep -q -i -E -e 'sse4_1( |$)' /proc/cpuinfo # 2008
	local has_sse4_1="$?"
	grep -q -i -E -e 'sse4_2( |$)' /proc/cpuinfo # 2008
	local has_sse4_2="$?"
	grep -q -i -E -e 'avx( |$)' /proc/cpuinfo # 2011
	local has_avx="$?"
	grep -q -i -E -e 'f16c( |$)' /proc/cpuinfo # 2011
	local has_f16c="$?"
	grep -q -i -E -e 'fma( |$)' /proc/cpuinfo # 2012
	local has_fma="$?"
	grep -q -i -E -e 'bmi1( |$)' /proc/cpuinfo # 2013
	local has_bmi1="$?"
	grep -q -i -E -e 'avx2( |$)' /proc/cpuinfo # 2013
	local has_avx2="$?"
	grep -q -i -E -e 'avx512f( |$)' /proc/cpuinfo # 2016 / 2017
	local has_avx512f="$?"
	grep -q -i -E -e 'avx512er( |$)' /proc/cpuinfo # 2016
	local has_avx512er="$?"
	grep -q -i -E -e 'avx512dq( |$)' /proc/cpuinfo # 2017
	local has_avx512dq="$?"

	# We cancel building to prevent runtime errors with dependencies
	# that may not do sufficient runtime checks for cpu types like eigen.

	if use cpu_flags_x86_mmx ; then
		if [[ "${has_mmx}" != "0" ]] ; then
			die \
"mmx may not be supported on your CPU and was enabled via cpu_flags_x86_mmx"
		fi
	fi

	if use cpu_flags_x86_sse ; then
		if [[ "${has_sse}" != "0" ]] ; then
			die \
"sse may not be supported on your CPU and was enabled via cpu_flags_x86_sse"
		fi
	fi

	if use cpu_flags_x86_sse2 ; then
		if [[ "${has_sse2}" != "0" ]] ; then
			die \
"sse2 may not be supported on your CPU and was enabled via cpu_flags_x86_sse2"
		fi
	fi

	if use cpu_flags_x86_sse3 ; then
		if [[ "${has_sse3}" != "0" && "${has_pni}" != "0" ]] ; then
			die \
"sse3 may not be supported on your CPU and was enabled via cpu_flags_x86_sse3"
		fi
	fi

	if use cpu_flags_x86_ssse3 ; then
		if [[ "${has_ssse3}" != "0" ]] ; then
			die \
"ssse3 may not be supported on your CPU and was enabled via cpu_flags_x86_ssse3"
		fi
	fi

	if use cpu_flags_x86_lzcnt ; then
		if [[ "${has_bmi1}" != "0" && "${has_abm}" != "0" ]] ; then
			die \
"lzcnt may not be supported on your CPU and was enabled via cpu_flags_x86_lzcnt"
		fi
	fi

	if use cpu_flags_x86_sse4_1 ; then
		if [[ "${has_sse4_1}" != "0" ]] ; then
			die \
"sse4_1 may not be supported on your CPU and was enabled via cpu_flags_x86_sse4_1"
		fi
	fi

	if use cpu_flags_x86_sse4_2 ; then
		if [[ "${has_sse4_2}" != "0" ]] ; then
			die \
"sse4_2 may not be supported on your CPU and was enabled via cpu_flags_x86_sse4_2"
		fi
	fi

	if use cpu_flags_x86_avx ; then
		if [[ "${has_avx}" != "0" ]] ; then
			die \
"avx may not be supported on your CPU and was enabled via cpu_flags_x86_avx"
		fi
	fi

	if use cpu_flags_x86_f16c ; then
		if [[ "${has_f16c}" != "0" ]] ; then
			die \
"f16c may not be supported on your CPU and was enabled via cpu_flags_x86_f16c"
		fi
	fi

	if use cpu_flags_x86_fma ; then
		if [[ "${has_fma}" != "0" ]] ; then
			die \
"fma may not be supported on your CPU and was enabled via cpu_flags_x86_fma"
		fi
	fi

	# For tzcnt
	if use cpu_flags_x86_bmi ; then
		if [[ "${has_bmi1}" != "0" ]] ; then
			die \
"bmi may not be supported on your CPU and was enabled via cpu_flags_x86_bmi"
		fi
	fi

	if use cpu_flags_x86_avx2 ; then
		if [[ "${has_avx2}" != "0" ]] ; then
			die \
"avx2 may not be supported on your CPU and was enabled via cpu_flags_x86_avx2"
		fi
	fi

	if use cpu_flags_x86_avx512f ; then
		if [[ "${has_avx512f}" != "0" ]] ; then
			die \
"avx512f may not be supported on your CPU and was enabled via cpu_flags_x86_avx512f"
		fi
	fi

	if use cpu_flags_x86_avx512er ; then
		if [[ "${has_avx512er}" != "0" ]] ; then
			die \
"avx512er may not be supported on your CPU and was enabled via cpu_flags_x86_avx512er"
		fi
	fi

	if use cpu_flags_x86_avx512dq ; then
		if [[ "${has_avx512dq}" != "0" ]] ; then
			die \
"avx512dq may not be supported on your CPU and was enabled via cpu_flags_x86_avx512dq"
		fi
	fi
}

check_optimal_compiler_for_cycles_x86() {
	if [[ "${ABI}" == "x86" ]] ; then
		# Cycles says that a bug might be in in gcc so use clang or icc.
		# If you use gcc, it will not optimize cycles except with maybe sse2.
		if [[ -n "${BLENDER_CC_ALT}" && -n "${BLENDER_CXX_ALT}" ]] ; then
			export CC=${BLENDER_CC_ALT}
			export CXX=${BLENDER_CXX_ALT}
		elif [[ -n "${CC}" && -n "${CXX}" ]] \
			&& [[ ! ( "${CC}" =~ gcc ) ]] \
			&& [[ ! ( "${CXX}" =~ "g++" ) ]] ; then
			# Defined by user from per-package environmental variables.
			export CC
			export CXX
		elif has_version 'sys-devel/clang' ; then
			export CC=clang
			export CXX=clang++
		elif has_version 'dev-lang/icc' ; then
			export CC=icc
			export CXX=icpc
		fi
	else
		if [[ ! -n "${CC}" || ! -n "${CXX}" ]] ; then
			export CC=$(tc-getCC $(get_abi_CHOST "${ABI}"))
			export CXX=$(tc-getCXX $(get_abi_CHOST "${ABI}"))
		fi
	fi

	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
}

_src_prepare() {
	cd "${BUILD_DIR}" || die

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_prepare

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		# we don't want static glew, but it's scattered across
		# multiple files that differ from version to version
		# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
		local file
		while IFS="" read -d $'\0' -r file ; do
			if grep -q -F -e "-DGLEW_STATIC" "${file}" ; then
				einfo "Removing -DGLEW_STATIC from ${file}"
				sed -i -e '/-DGLEW_STATIC/d' "${file}"
			fi
		done < <(find . -type f -name "CMakeLists.txt" -print0)

		sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
			intern/cycles/app/CMakeLists.txt || die
	fi

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die
}

blender_src_prepare() {
	xdg_src_prepare

	cd "${S}" || die
	eapply ${_PATCHES[@]}
	if declare -f _src_prepare_patches > /dev/null ; then
		_src_prepare_patches
	fi

	blender_prepare() {
		_src_prepare
	}
	blender-multibuild_copy_sources
	blender-multibuild_foreach_impl blender_prepare
}

blender_configure_eigen() {
	if use cpu_flags_x86_avx512f ; then
		if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
knl|knm|skylake-avx512|cannonlake|icelake-client|icelake-server|cascadelake\
|cooperlake|tigerlake|sapphirerapids) ]] \
		|| [[ "${CXXFLAGS}" =~ mavx512f( |$) ]] ; then
			# Already added
			:;
		else
			append-cxxflags -mavx512f
		fi
	else
		append-cxxflags -mno-avx512f
	fi

	if use cpu_flags_x86_avx512dq ; then
		if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
skylake-avx512|cannonlake|icelake-client|icelake-server|cascadelake|cooperlake\
|tigerlake|sapphirerapids) ]] \
		|| [[ "${CXXFLAGS}" =~ mavx512dq( |$) ]] ; then
			# Already added
			:;
		else
			append-cxxflags -mavx512dq
		fi
	else
		append-cxxflags -mno-avx512dq
	fi

	if use cpu_flags_x86_avx512er ; then
		if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
knl|knm) ]] \
		|| [[ "${CXXFLAGS}" =~ mavx512er( |$) ]] ; then
			# Already added
			:;
		else
			append-cxxflags -mavx512er
		fi
	else
		append-cxxflags -mno-avx512er
	fi

	if use cpu_flags_x86_avx512f ; then
		append-cxxflags -DEIGEN_ENABLE_AVX512
	fi

	if ! use cpu_flags_x86_mmx \
	&& ! use cpu_flags_x86_sse \
	&& ! use cpu_flags_x86_sse2 \
	&& ! use cpu_flags_x86_sse3 \
	&& ! use cpu_flags_x86_ssse3 \
	&& ! use cpu_flags_x86_sse4_1 \
	&& ! use cpu_flags_x86_sse4_2 \
	&& ! use cpu_flags_x86_avx \
	&& ! use cpu_flags_x86_avx2 \
	&& ! use cpu_flags_x86_avx512f \
	&& ! use cpu_flags_x86_avx512dq \
	&& ! use cpu_flags_x86_avx512er \
	&& ! use cpu_flags_x86_fma \
	&& ! use cpu_flags_x86_f16c ; then
		append-cxxflags -DEIGEN_DONT_VECTORIZE
	fi
}

blender_configure_linker_flags() {
	# Respect the user linker choice.
	mycmakeargs+=(
		-DWITH_LINKER_LLD=OFF
		-DWITH_LINKER_GOLD=OFF
	)
}

blender_configure_simd_cycles() {
	if ver_test $(ver_cut 1-2 ${PV}) -ge 2.80 ; then
		if ! has_version 'media-libs/embree[cpu_flags_x86_avx]' ; then
			sed -i -e "/embree_avx/d" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi

		if ! has_version 'media-libs/embree[cpu_flags_x86_avx2]' ; then
			sed -i -e "/embree_avx2/d" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi

		if ! has_version 'media-libs/embree[cpu_flags_x86_sse4_2]' ; then
			sed -i -e "/embree_sse42/d" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi
	fi

	if use cycles && ! use cpudetection ; then
		if use cpu_flags_x86_sse ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse2 ; then
			sed -i -e "/WITH_KERNEL_SSE2/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse3 ; then
			sed -i -e "/WITH_KERNEL_SSE3/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse4_1 ; then
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx2 ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if [[ "${ABI}" == "x86" ]] && grep -q -F -e "WITH_KERNEL_SSE41" intern/cycles/CMakeLists.txt ; then
			# See intern/cycles/util/util_optimization.h for reason why it was axed in x86 (32-bit)..
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		# No instructions present
		sed -i -e "s|-mbmi2||g" \
			intern/cycles/CMakeLists.txt || die
	fi

	# The avx2 config in CMakeLists.txt already sets this.
	if tc-is-gcc || tc-is-clang ; then
		if ! use cpudetection && use cycles && ! use cpu_flags_x86_avx2 ; then
			if use cpu_flags_x86_bmi ; then
				# bmi1 only, tzcnt
				if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|\
\
bdver2|bdver3|bdver4|znver1|znver2|btver2) ]] \
				|| [[ "${CXXFLAGS}" =~ mbmi( |$) ]] ; then
					# Already added
					:;
				else
					append-cxxflags -mbmi
				fi
			else
				append-cxxflags -mno-bmi
			fi
			if use cpu_flags_x86_lzcnt ; then
				# intel puts lzcnt in bmi1
				# amd puts lzcnt in abm
				if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|\
\
amdfam10|barcelona|bdver1|bdver2|bdver3|bdver4|znver1|znver2|btver1|btver2) ]] \
				|| [[ "${CXXFLAGS}" =~ mlzcnt ]] ; then
					# Already added
					:;
				else
					append-cxxflags -mlzcnt
				fi
			else
				append-cxxflags -mno-lzcnt
			fi
		fi

		if use cpu_flags_x86_f16c ; then
			if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
ivybridge|haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|\
icelake-client|icelake-server|cascadelake|copperlake|tigerlake|sapphirerapids|\
\
bdver2|bdver3|bdver4|znver1|znver2|btver2) ]] \
			|| [[ "${CXXFLAGS}" =~ mf16c ]] ; then
				# Already added
				:;
			else
				append-cxxflags -mf16c
			fi
		else
			append-cxxflags -mno-f16c
		fi

		if use cpu_flags_x86_fma ; then
			# for eigen and cycles
			if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|alderlake|\
\
bdver2|bdver3|bdver4|znver1|znver2) ]] \
			|| [[ "${CXXFLAGS}" =~ mfma ]] ; then
				# Already added
				:;
			else
				append-cxxflags -mfma
			fi
		else
			append-cxxflags -mno-fma
		fi

		if use cycles && use cpudetection ; then
			# automatically adds -march=native
			filter-flags -m*avx* -m*mmx -m*sse* -m*ssse3 -m*3dnow \
				-m*popcnt -m*abm -m*bmi -m*lzcnt -m*f16c -m*fma
			filter-flags -march=*
		fi

	fi
}

blender_configure_openusd() {
	if use usd ; then
		export USD_ROOT_DIR="/usr/$(get_libdir)/openusd/lib"
		_LD_LIBRARY_PATH="/usr/$(get_libdir)/openusd/lib:${_LD_LIBRARY_PATH}"
	fi
}

blender_configure_openxr_cxxyy() {
	if use openxr ; then
		export XR_OPENXR_SDK_ROOT_DIR="$(erdpfx)/openxr/${CXXABI_V}/usr"
		_LD_LIBRARY_PATH="$(erdpfx)/openxr/${CXXABI_V}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
	fi
}

blender_configure_openvdb_cxxyy() {
	if use openvdb ; then
		export OPENVDB_ROOT_DIR="$(erdpfx)/openvdb/${OPENVDB_V_DIR}/usr"
		_LD_LIBRARY_PATH="$(erdpfx)/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
	fi
}

blender_configure_mesa_match_llvm() {
	mycmakeargs+=( -DOpenGL_GL_PREFERENCE=GLVND )
	if [[ -e "${EROOT}/usr/$(get_libdir)/libGLX.so" ]] ; then
		mycmakeargs+=( -DOPENGL_glx_LIBRARY="${EROOT}/usr/$(get_libdir)/libGLX.so" )
	else
		die "Install media-libs/libglvnd."
	fi
	if [[ -e "${EROOT}/usr/$(get_libdir)/libOpenGL.so" ]] ; then
		mycmakeargs+=( -DOPENGL_opengl_LIBRARY="${EROOT}/usr/$(get_libdir)/libOpenGL.so" )
	else
		die "Install media-libs/libglvnd."
	fi
	if [[ -e "${EROOT}/usr/$(get_libdir)/libEGL.so" ]] ; then
		mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/libEGL.so" )
	fi

	# Fix loading {vendor}_dri.so linked with LLVM-9
	_LIBGL_DRIVERS_DIR="$(erdpfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri" # works but deprecated
	_LIBGL_DRIVERS_PATH="$(erdpfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri" # not work but replaces LIBGL_DRIVERS_DIR
}

blender_configure_mesa_match_system_llvm() {
	mycmakeargs+=( -DOpenGL_GL_PREFERENCE=GLVND )
	if [[ -e "${EROOT}/usr/$(get_libdir)/libGLX.so" ]] ; then
		mycmakeargs+=( -DOPENGL_glx_LIBRARY="${EROOT}/usr/$(get_libdir)/libGLX.so" )
	else
		die "Install media-libs/libglvnd."
	fi
	if [[ -e "${EROOT}/usr/$(get_libdir)/libOpenGL.so" ]] ; then
		mycmakeargs+=( -DOPENGL_opengl_LIBRARY="${EROOT}/usr/$(get_libdir)/libOpenGL.so" )
	else
		die "Install media-libs/libglvnd."
	fi
	if [[ -e "${EROOT}/usr/$(get_libdir)/libEGL.so" ]] ; then
		mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/libEGL.so" )
	fi
}

blender_configure_osl_match_llvm() {
	if use osl ; then
		export OSL_ROOT_DIR="$(erdpfx)/osl/${LLVM_V}/usr"
		_LD_LIBRARY_PATH="$(erdpfx)/osl/${LLVM_V}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
		_PATH="$(erdpfx)/osl/${LLVM_V}/usr/bin:${_PATH}"
	fi
}

blender_configure_nvcc() {
	if use nvcc ; then
		if [[ -x "${EROOT}/opt/cuda/bin/nvcc" ]] ; then
			mycmakeargs+=(
		-DCUDA_NVCC_EXECUTABLE="${EROOT}/opt/cuda/bin/nvcc"
			)
		elif [[ -n "${BLENDER_NVCC_PATH}" \
		&& -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
			mycmakeargs+=(
	-DCUDA_NVCC_EXECUTABLE="${EROOT}/${BLENDER_NVCC_PATH}/nvcc"
			)
		elif [[ -n "${BLENDER_NVCC_PATH}" \
	&& ! -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
			die \
"\n\
nvcc is unreachable from BLENDER_NVCC_PATH.  It should be an absolute path\n\
like /opt/cuda/bin/nvcc.\n\
\n"
		else
			die \
"\n\
You need to define BLENDER_NVCC_PATH as a per-package environmental variable\n\
containing the absolute path to nvcc e.g. /opt/cuda/bin/nvcc.\n\
\n"
		fi
	fi
}

blender_configure_nvrtc() {
	if use nvrtc ; then
		if [[ -f "${EROOT}/opt/cuda/$(get_libdir)/libnvrtc-builtins.so" ]] ; then
			mycmakeargs+=(
			-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/opt/cuda"
			)
		elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/$(get_libdir)/libnvrtc-builtins.so" ]] ; then
			mycmakeargs+=(
	-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}"
			)
		elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& ! -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/$(get_libdir)/libnvrtc-builtins.so" ]] ; then
			die \
"Cannot reach \$BLENDER_CUDA_TOOLKIT_ROOT_DIR/$(get_libdir)/libnvrtc-builtins.so"
		else
			die \
"\n
libnvrtc-builtins.so is unreachable.  Define BLENDER_CUDA_TOOLKIT_ROOT_DIR\n\
as a per-package environmental variable (e.g. /opt/cuda).\n
\n"
		fi
	fi
}

blender_configure_optix() {
	if use optix ; then
		if [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
	&& -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
			mycmakeargs+=(
		-DOPTIX_ROOT_DIR="${EROOT}/${BLENDER_OPTIX_ROOT_DIR}"
			)
		elif [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
	&& ! -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
			die \
"\n\
Cannot reach \$BLENDER_OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
		elif [[ -n "${OPTIX_ROOT_DIR}" \
	&& -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
			:;
		elif [[ -n "${OPTIX_ROOT_DIR}" \
	&& ! -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
"\n\
Cannot reach \$OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
		else
			die \
"\n\
You need to define BLENDER_OPTIX_ROOT_DIR to point to the Optix SDK folder.\n\
The build scripts expect BLENDER_OPTIX_ROOT_DIR/include/optix.h.\n\
\n"
		fi
	fi
}

blender_src_configure() {
	:;
}

_src_compile() {
	if [[ -n "${_LD_LIBRARY_PATHS[${EBLENDER}]}" ]] ; then
		export LD_LIBRARY_PATH="${_LD_LIBRARY_PATHS[${EBLENDER}]}"
		einfo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
	fi
	if [[ -n "${_PATHS[${EBLENDER}]}" ]] ; then
		export PATH="${_PATHS[${EBLENDER}]}:${PATH}"
		einfo "PATH=${PATH}"
	fi

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_compile
}

_src_compile_docs() {
	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background \
			--python doc/python_api/sphinx_doc_gen.py -noaudio \
			|| die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

_install_pgx() {
	einfo "Installing sandboxed copy"
	_src_install
}

_clean_pgx() {
	einfo "Wiping sandboxed install"
	cd "${S}" || die
	rm -rf "${D}" || die
}

blender_src_compile() {
	blender_compile() {
		_ORIG_PATH="${PATH}"
		cd "${BUILD_DIR}" || die
		if use pgo ; then
			PGO_PHASE="pgi"
			_src_configure
			_src_compile
			_src_install
			_run_trainer
			_clean_pgx
			PGO_PHASE="pgo"
			_src_configure
			_src_compile
		else
			_src_configure
			_src_compile
		fi
		if [[ "${EBLENDER}" == "build_creator" ]] ; then
			_src_compile_docs
		fi
		export PATH="${_ORIG_PATH}"
	}
	blender-multibuild_foreach_impl blender_compile
}

_run_trainer() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	local search_paths=()
	if [[ -d "${distdir}/blender/demo_assets" ]] ; then
		search_paths+=( "${distdir}/blender/demo_assets" )
	fi
	if [[ -d "/usr/share/blender/demo_assets" ]] ; then
		search_paths+=( "/usr/share/blender/demo_assets" )
	fi

	local asset_list=( $(find "${search_paths[@]}" -name "*.blend" ) )

	export PATH="${D}/usr/bin:${PATH}"

	# See https://www.blender.org/download/demo-files/ for assets
	if use pgo-trainer-cycles-still ; then
		local renderer_name="Cycles"
		for asset in ${asset_list[@]} ; do
			[[ ! -e "${distdir}/blender/assets/${asset}" ]] && continue
			[[ ! ( $(basename "${asset}") =~ ${BLENDER_PGO_CYCLES_ASSETS} ) ]] && continue

			einfo "Obtaining start and end frame data"
			O=$(${EPYTHON} "${D}/usr/share/blender/$(ver_cut 1-2 ${PV})/scripts/modules/blend_render_info.py" "${asset}")
			local start=$(echo "${O}" | cut -f 1 -d " ")
			local end=$(echo "${O}" | cut -f 2 -d " ")

			local cmd
			einfo "Running PGO trainer for ${asset} as still image using ${renderer_name}"
			for i in $(seq ${PGO_SAMPLE_SIZE}) ; do
				local rand=$((${RANDOM} % $((${end}-${start}+1)) + ${start} ))
				cmd="DISPLAY=${DISPLAY} blender -b $(realpath ${distdir}/${asset}) -E CYCLES -f ${rand} -o /dev/null"
				einfo "Note:  sudo may ask you for password"
				einfo "sudo -u pgo bash -c \"${cmd}\""
				sudo -u pgo bash -c "${cmd}"
			done
		done
	fi
	if use pgo-trainer-cycles-anim ; then
		local renderer_name="Cycles"
		for asset in ${asset_list[@]} ; do
			[[ ! -e "${distdir}/blender/assets/${asset}" ]] && continue
			[[ ! ( $(basename "${asset}") =~ ${BLENDER_PGO_CYCLES_ASSETS} ) ]] && continue

			einfo "Obtaining start and end frame data"
			O=$(${EPYTHON} "${D}/usr/share/blender/$(ver_cut 1-2 ${PV})/scripts/modules/blend_render_info.py" "${asset}")
			local start=$(echo "${O}" | cut -f 1 -d " ")
			local end=$(echo "${O}" | cut -f 2 -d " ")

			einfo "Running PGO trainer for ${asset} as an animation using ${renderer_name}"
			cmd="DISPLAY=${DISPLAY} blender -b $(realpath ${distdir}/${asset}) -E BLENDER_EEVEE -s ${start} -e ${end} -o /dev/null"
			einfo "Note:  sudo may ask you for password"
			einfo "sudo -u pgo bash -c \"${cmd}\""
			sudo -u pgo bash -c "${cmd}"
		done
	fi
	if use pgo-trainer-eevee-still ; then
		local renderer_name="EEVEE"
		for asset in ${asset_list[@]} ; do
			[[ ! -e "${distdir}/blender/assets/${asset}" ]] && continue
			[[ ! ( $(basename "${asset}") =~ ${BLENDER_PGO_EEVEE_ASSETS} ) ]] && continue

			einfo "Obtaining start and end frame data"
			O=$(${EPYTHON} "${D}/usr/share/blender/$(ver_cut 1-2 ${PV})/scripts/modules/blend_render_info.py" "${asset}")
			local start=$(echo "${O}" | cut -f 1 -d " ")
			local end=$(echo "${O}" | cut -f 2 -d " ")

			local cmd
			einfo "Running PGO trainer for ${asset} as a still image using ${renderer_name}"
			for i in $(seq ${PGO_SAMPLE_SIZE}) ; do
				local rand=$((${RANDOM} % $((${end}-${start}+1)) + ${start} ))
				cmd="DISPLAY=${DISPLAY} blender -b $(realpath ${distdir}/${asset}) -E BLENDER_EEVEE -f ${rand} -o /dev/null"
				einfo "Note:  sudo may ask you for password"
				einfo "sudo -u pgo bash -c \"${cmd}\""
				sudo -u pgo bash -c "${cmd}"
			done
		done
	fi
	if use pgo-trainer-eevee-anim ; then
		local renderer_name="EEVEE"
		for asset in ${asset_list[@]} ; do
			[[ ! -e "${distdir}/blender/assets/${asset}" ]] && continue
			[[ ! ( $(basename "${asset}") =~ ${BLENDER_PGO_EEVEE_ASSETS} ) ]] && continue

			einfo "Obtaining start and end frame data"
			O=$(${EPYTHON} "${D}/usr/share/blender/$(ver_cut 1-2 ${PV})/scripts/modules/blend_render_info.py" "${asset}")
			local start=$(echo "${O}" | cut -f 1 -d " ")
			local end=$(echo "${O}" | cut -f 2 -d " ")

			local cmd
			einfo "Running PGO trainer for ${asset} as an animation using ${renderer_name}"
			cmd="DISPLAY=${DISPLAY} blender -b $(realpath ${distdir}/${asset}) -E BLENDER_EEVEE -s ${start} -e ${end} -o /dev/null"
			einfo "Note:  sudo may ask you for password"
			einfo "sudo -u pgo bash -c \"${cmd}\""
			sudo -u pgo bash -c "${cmd}"
		done
	fi
}

_src_test() {
	if use test; then
		einfo "Running Blender Unit Tests for ${EBLENDER} ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

blender_src_test() {
	blender_test() {
		cd "${BUILD_DIR}" || die
		_src_test
	}
	blender-multibuild_foreach_impl blender_test
}

_src_install_cycles_network() {
	if has cycles-network ${IUSE_EFFECTIVE} \
		&& use cycles-network ; then
		exeinto "${d_dest}"
		dosym "../../..${d_dest}/cycles_server" \
			"/usr/bin/cycles_server-${SLOT_MAJ}" || die
		doexe "${CMAKE_BUILD_DIR}${d_dest}/cycles_server"
	fi
}

_src_install_doc() {
	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die
}

install_licenses() {
	for f in $(find "${BUILD_DIR}" \
		   -iname "*licen*" -type f \
		-o -iname "*copyright*" \
		-o -iname "*copying*" \
		-o -iname "*patent*" \
		-o -iname "*notice*" \
		-o -iname "*author*" \
		-o -iname "*CONTRIBUTORS*" \
		-o -path "*/license/*" \
		-o -path "*/macholib/README.ctypes" \
		-o -path "*/materials_library_vx/README.txt" ) \
		$(grep -i -G -l \
			-e "copyright" \
			-e "licens" \
			-e "licenc" \
			-e "warrant" \
			$(find "${BUILD_DIR}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		if ver_test $(ver_cut 1-2 ${PV}) -ge 2.80 ; then
			docinto "licenses/${d}"
			dodoc -r "${f}"
		else
			if [[ "${EBLENDER}" == "build_portable" ]] ; then
				insinto "${d_dest}/licenses/${d}"
				doins -r "${f}"
			elif [[ "${EBLENDER}" == "build_creator" \
			     || "${EBLENDER}" == "build_headless" ]] ; then
				docinto "licenses/${d}"
				dodoc -r "${f}"
			fi
		fi
	done
}

install_readmes() {
	for f in $(find "${BUILD_DIR}" -iname "*readme*") ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		if ver_test $(ver_cut 1-2 ${PV}) -ge 2.80 ; then
			docinto "readmes/${d}"
			dodoc -r "${f}"
		else
			if [[ "${EBLENDER}" == "build_portable" ]] ; then
				insinto "${d_dest}/readmes/${d}"
				doins -r "${f}"
			elif [[ "${EBLENDER}" == "build_creator" \
			     || "${EBLENDER}" == "build_headless" ]] ; then
				docinto "readmes/${d}"
				dodoc -r "${f}"
			fi
		fi
	done
}

_src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_install
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		CMAKE_USE_DIR="${BUILD_DIR}" \
		_src_install_doc
	fi

	local d_dest=$(get_dest)
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		if [[ -e "${ED%/}${d_dest}/blender-thumbnailer.py" ]] ; then
			python_fix_shebang "${ED%/}${d_dest}/blender-thumbnailer.py"
		fi
		python_optimize "${ED%/}/usr/share/${PN}/${SLOT_MAJ}/scripts"
	fi

	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		_src_install_cycles_network
	fi

	_LD_LIBRARY_PATH=()
	_PATH=()
	if declare -f blender_set_wrapper_deps > /dev/null ; then
		blender_set_wrapper_deps
	fi
	_LD_LIBRARY_PATH=$(echo -e "${_LD_LIBRARY_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")
	_LIBGL_DRIVERS_DIR=$(echo -e "${_LIBGL_DRIVERS_DIR[0]}")
	_LIBGL_DRIVERS_PATH=$(echo -e "${_LIBGL_DRIVERS_PATH[0]}")
	_PATH=$(echo -e "${_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")

	local suffix=
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications"/blender{,-${SLOT_MAJ}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT_MAJ}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=/usr/bin/${PN}-${SLOT_MAJ}|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT_MAJ}|g" "${menu_file}" || die
		if [[ -n "${IS_LTS}" && "${IS_LTS}" == "1" ]] ; then
			touch "${ED}/${d_dest}/.lts"
		fi
	fi

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		if [[ "${EBLENDER_NAME}" == "creator" ]] ; then
			suffix=""
		elif [[ "${EBLENDER_NAME}" == "headless" ]] ; then
			suffix="-headless"
		fi
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		if declare -f blender_set_wrapper_deps > /dev/null ; then
			sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
				-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}:\${LD_LIBRARY_PATH}\"|g" \
				-e "s|#PATH|export PATH=\"${_PATH}:\${PATH}\"|g" \
				-e "s|#LIBGL_DRIVERS_DIR|export LIBGL_DRIVERS_DIR=\"${_LIBGL_DRIVERS_DIR}\"|g" \
				-e "s|#LIBGL_DRIVERS_PATH|export LIBGL_DRIVERS_PATH=\"${_LIBGL_DRIVERS_PATH}\"|g" \
				-e "s|#PYTHONPATH|export PYTHONPATH=\"/usr/lib/${EPYTHON}:/usr/lib/${EPYTHON}/lib-dynload:/usr/lib/${EPYTHON}/site-packages:\${PYTHONPATH}\"|g" \
				-e "s|#BLENDER_EXTERN_DRACO_LIBRARY_PATH|BLENDER_EXTERN_DRACO_LIBRARY_PATH=/usr/$(get_libdir)/${PN}/$(ver_cut 1-3 ${PV})/python/lib/${EPYTHON}/site-packages|g" \
				"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		else
			sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
				-e "s|#PYTHONPATH|export PYTHONPATH=\"/usr/lib/${EPYTHON}:/usr/lib/${EPYTHON}/lib-dynload:/usr/lib/${EPYTHON}/site-packages:\${PYTHONPATH}\"|g" \
				-e "s|#BLENDER_EXTERN_DRACO_LIBRARY_PATH|BLENDER_EXTERN_DRACO_LIBRARY_PATH=/usr/$(get_libdir)/${PN}/$(ver_cut 1-3 ${PV})/python/lib/${EPYTHON}/site-packages|g" \
				"${T}/${PN}${suffix}-${SLOT_MAJ}" || die
		fi
		exeinto /usr/bin
		doexe "${T}/${PN}${suffix}-${SLOT_MAJ}"
		if has cycles-network ${IUSE_EFFECTIVE} \
			&& use cycles-network ; then
			cp "${FILESDIR}/blender-wrapper" \
				"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			if declare -f blender_set_wrapper_deps > /dev/null ; then
				sed -i -e "s|\${BLENDER_EXE}|${d_dest}/cycles_network|g" \
					-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}:\${LD_LIBRARY_PATH}\"|g" \
					-e "s|#PATH|export PATH=\"${_PATH}:\${PATH}\"|g" \
					-e "s|#LIBGL_DRIVERS_DIR|export LIBGL_DRIVERS_DIR=\"${_LIBGL_DRIVERS_DIR}\"|g" \
					-e "s|#LIBGL_DRIVERS_PATH|export LIBGL_DRIVERS_PATH=\"${_LIBGL_DRIVERS_PATH}\"|g" \
					-e "s|#PYTHONPATH|export PYTHONPATH=\"/usr/lib/${EPYTHON}:/usr/lib/${EPYTHON}/lib-dynload:/usr/lib/${EPYTHON}/site-packages:\${PYTHONPATH}\"|g" \
					-e "s|#BLENDER_EXTERN_DRACO_LIBRARY_PATH|BLENDER_EXTERN_DRACO_LIBRARY_PATH=/usr/$(get_libdir)/${PN}/$(ver_cut 1-3 ${PV})/python/lib/${EPYTHON}/site-packages|g" \
					"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			else
				sed -i -e "s|\${BLENDER_EXE}|${d_dest}/cycles_network|g" \
					-e "s|#PYTHONPATH|export PYTHONPATH=\"/usr/lib/${EPYTHON}:/usr/lib/${EPYTHON}/lib-dynload:/usr/lib/${EPYTHON}/site-packages:\${PYTHONPATH}\"|g" \
					-e "s|#BLENDER_EXTERN_DRACO_LIBRARY_PATH|BLENDER_EXTERN_DRACO_LIBRARY_PATH=/usr/$(get_libdir)/${PN}/$(ver_cut 1-3 ${PV})/python/lib/${EPYTHON}/site-packages|g" \
					"${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}" || die
			fi
			doexe "${T}/cycles_network${suffix/-/_}-${SLOT_MAJ}"
		fi
	fi
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		echo -e \
"# The following libraries were linked to blenderplayer as shared libraries and\n\
# need to be present on the other computer or distributed with blenderplayer\n\
# with licenses or built without such dependencies.  The dependency of those\n\
# direct shared dependencies may also be required.\n\n" \
			> "${ED}${d_dest}/README.3rdparty_deps"
		[[ ! -e "${T}/build-build_portable.log" ]] \
			&& die "Missing build log"

		# List direct dependencies
		echo -e "# Direct shared dependencies:\n" \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die
		grep -E -e "-o .*blenderplayer " \
			"${T}"/build-build_portable.log \
			| grep -o -E -e "[^ ]+\.so(.[0-9]+)?" | sort | uniq \
			| sed -e "/^$/d" \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die
		echo -e "\n\n# Dependency of direct shared dependencies:\n" \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die

		# List dependency of those direct dependencies
		echo -e $(for f in $(cat "${ED}/${d_dest}/README.3rdparty_deps" \
				| sed -e "/^#/d" ) ; do \
				ldd "${f}" \
					| cut -f 2 -d ">" \
					| sed -e "s|\t||g" -e "s|^[ ]||g" \
					| sort ; \
			done) \
			| sed -E -e "s|\([0-9a-z]+\)||g" \
			| tr " " "\n" | sort | uniq \
			| sed -E -e "/(statically|linked|linux-vdso.so.1)/d" \
			| sed -e "/^$/d" \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die
		echo -e \
"\n\nPlace the shared libraries in the lib folder containing blenderplayer\n\
along with licenses.  A \`gamelaunch.sh\` launcher wrapper script has been\n\
provided.  Edit the file and set the name of my_game_project.blend file.\n\
Blender adds mesa libs to their binary distribution.  You may need to do\n\
the same especially to avoid the multiple LLVM versions being loaded bug." \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die
		dodir "${d_dest}/lib/dri"
		exeinto "${d_dest}"
		doexe "${FILESDIR}/gamelaunch.sh"
	fi
	install_licenses
	if use doc ; then
		install_readmes
	fi
}

blender_src_install() {
	blender_install() {
		cd "${BUILD_DIR}" || die
		_src_install
	}
	blender-multibuild_foreach_impl blender_install
	local ed_icon_hc="${ED}/usr/share/icons/hicolor"
	local ed_icon_scale="${ed_icon_hc}/scalable"
	local ed_icon_sym="${ed_icon_hc}/symbolic"
	if ver_test $(ver_cut 1-2 ${PV}) -lt 2.80 ; then
		for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
			if [[ -e "${ed_icon_hc}/${size}/apps/blender.png" ]] ; then
				mv "${ed_icon_hc}/${size}/apps/blender"{,-${SLOT_MAJ}}".png" || die
			fi
		done
	fi
	if [[ -e "${ed_icon_scale}/apps/blender.svg" ]] ; then
		mv "${ed_icon_scale}/apps/blender"{,-${SLOT_MAJ}}".svg" || die
		if ver_test $(ver_cut 1-2) -ge 2.80 ; then
			mv "${ed_icon_sym}/apps/blender-symbolic"{,-${SLOT_MAJ}}".svg"
		fi
	fi
	rm -rf "${ED}/usr/share/applications/blender.desktop" || die
	if [[ -d "${ED}/usr/share/doc/blender" ]] ; then
		mv "${ED}/usr/share/doc/blender"{,-${SLOT_MAJ}} || die
	fi
	mv "${ED}/usr/share/man/man1/blender"{,-${SLOT_MAJ}}".1"
}

blender_pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	if has cycles-network ${IUSE_EFFECTIVE} \
		&& use cycles-network ; then
		einfo
		ewarn "The Cycles Networking support is experimental and"
		ewarn "incomplete."
		einfo
		einfo "To make a OpenCL GPU available do:"
		einfo "cycles_server --device OPENCL"
		einfo
		einfo "To make a CUDA GPU available do:"
		einfo "cycles_server --device CUDA"
		einfo
		einfo "To make a CPU available do:"
		einfo "cycles_server --device CPU"
		einfo
		einfo "Only one instance of a cycles_server can be used on a host."
		einfo
		einfo "You may want to run cycles_server on the client too, but"
		einfo "it is not necessary."
		einfo
		einfo "Clients need to set the Rendering Engine to Cycles and"
		einfo "Device to Networked Device.  Finding the server is done"
		einfo "automatically."
		einfo
	fi
	xdg_pkg_postinst
	local d_src="${EROOT}/usr/$(get_libdir)/${PN}"
	local V=""
	if [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# highest lts
		V=$(basename $(dirname $(dirname $(ls \
			"${d_src}"/*/creator/.lts | sort -V | tail -n 1))))
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# highest v
		V=$(ls "${d_src}/" | sed -e "/^[a-z]/d" | sort -V | tail -n 1)
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
		# custom v
		V=$(echo "${BLENDER_MAIN_SYMLINK_MODE}" | cut -f 2 -d "-")
	fi
	if [[ -n "${V}" ]] ; then
		if use build_creator ; then
			ln -sf "${EROOT}/usr/bin/${PN}-${V}" \
				"${EROOT}/usr/bin/${PN}" || die
			if has cycles-network ${IUSE_EFFECTIVE} \
				&& use cycles-network ; then
				ln -sf "${EROOT}/usr/bin/cycles_server-${V}" \
					"${EROOT}/usr/bin/cycles_server" || die
			fi
		fi
		if use build_headless ; then
			ln -sf "${EROOT}/usr/bin/${PN}-headless-${V}" \
				"${EROOT}/usr/bin/${PN}-headless" || die
			if has cycles-network ${IUSE_EFFECTIVE} \
				&& use cycles-network ; then
				ln -sf "${EROOT}/usr/bin/cycles_server_headless-${V}" \
					"${EROOT}/usr/bin/cycles_server_headless" || die
			fi
		fi
	fi
}

blender_pkg_postrm() {
	xdg_pkg_postrm

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${SLOT_MAJ}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
	if [[ ! -d "${EROOT}/usr/bin/.blender" ]] ; then
		if [[ -e "${EROOT}/usr/bin/blender" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender" || die
		fi
		if [[ -e "${EROOT}/usr/bin/blender-headless" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender-headless" || die
		fi
		if [[ -e "${EROOT}/usr/bin/cycles_server" ]] ; then
			rm -rf "${EROOT}/usr/bin/cycles_server" || die
		fi
		if [[ -e "${EROOT}/usr/bin/cycles_server_headless" ]] ; then
			rm -rf "${EROOT}/usr/bin/cycles_server_headless" || die
		fi
	fi
}
