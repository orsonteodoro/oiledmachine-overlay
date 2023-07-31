# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender common implementation
# @DESCRIPTION:
# The blender eclass helps reduce code duplication
# across the blender eclasses to reduce maintenance cost.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_blender_set_globals() {
	BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:-latest}
einfo "BLENDER_MAIN_SYMLINK_MODE:\t${BLENDER_MAIN_SYMLINK_MODE}"
}
_blender_set_globals
unset -f _blender_set_globals

UOPTS_SUPPORT_TPGO=0
UOPTS_SUPPORT_TBOLT=0

inherit cuda check-reqs cmake flag-o-matic llvm pax-utils python-single-r1
inherit toolchain-funcs xdg uopts

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS=${KEYWORDS:-"~amd64 ~x86"}

LICENSE="
	all-rights-reserved
	|| (
		GPL-2
		BL
	)

	(
		(
			0BSD
			PSF-2
		)
		PSF-2.4
	)
	LGPL-2.1+
	MPL-2.0
	build_creator? (
		Apache-2.0
		AFL-3.0
		BitstreamVera
		CC-BY-SA-3.0
		GPL-2
		GPL-3
		GPL-3-with-font-exception
		LGPL-2.1+
		ZLIB
		color-management? (
			BSD
		)
		jemalloc? (
			BSD-2
		)
	)
	build_headless? (
		Apache-2.0
		AFL-3.0
		BitstreamVera
		CC-BY-SA-3.0
		GPL-2
		GPL-3
		GPL-3-with-font-exception
		LGPL-2.1+
		ZLIB
		color-management? (
			BSD
		)
		jemalloc? (
			BSD-2
		)
	)
	cycles? (
		Apache-2.0
		Boost-1.0
		BSD
		MIT
	)
"

# intern/mikktspace contains ZLIB
# intern/CMakeLists.txt contains GPL+ with all-rights-reserved ; there is no
#   all rights reserved in the vanilla GPL-2

# Slotting is for scripting and plugin compatibility
SLOT_MAJ=${SLOT%/*}
SLOT="${PV}"
RESTRICT="
	!test? (
		test
	)
	mirror
"

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

X86_CPU_FLAGS=(
	mmx:mmx
	sse:sse
	sse2:sse2
	sse3:sse3
	ssse3:ssse3
	lzcnt:lzcnt
	sse4_1:sse4_1
	sse4_2:sse4_2
	avx:avx
	f16c:f16c
	fma:fma
	bmi:bmi
	avx2:avx2
	avx512f:avx512f
	avx512dq:avx512dq
	avx512er:avx512er
	avx512bf16:avx512bf16
)
CPU_FLAGS=(
	${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
)
IUSE+=" ${CPU_FLAGS[@]%:*}"
IUSE="${IUSE/cpu_flags_x86_mmx/+cpu_flags_x86_mmx}"
IUSE="${IUSE/cpu_flags_x86_sse /+cpu_flags_x86_sse }"
IUSE="${IUSE/cpu_flags_x86_sse2/+cpu_flags_x86_sse2}"
# Assets categories are listed in https://www.blender.org/download/demo-files/

# At the source code level, they mix the sse2 intrinsics functions up with the
#   __KERNEL_SSE__.
REQUIRED_USE_MINIMAL_CPU_FLAGS="
	!cpu_flags_x86_mmx? (
		!cpu_flags_x86_sse
		!cpu_flags_x86_sse2
	)
	cpu_flags_x86_sse2? (
		!cpu_flags_x86_sse? (
			cpu_flags_x86_mmx
		)
	)
"

REQUIRED_USE_CYCLES="
	cycles? (
		!cpudetection? (
			amd64? (
				cpu_flags_x86_avx? (
					cpu_flags_x86_sse4_1
				)
				cpu_flags_x86_avx2? (
					cpu_flags_x86_avx
					cpu_flags_x86_sse4_1
					cpu_flags_x86_fma
					cpu_flags_x86_lzcnt
					cpu_flags_x86_bmi
					cpu_flags_x86_f16c
				)
				cpu_flags_x86_sse4_1? (
					cpu_flags_x86_sse3
				)
			)
			cpu_flags_x86_sse3? (
				cpu_flags_x86_sse2
				cpu_flags_x86_ssse3
			)
			cpu_flags_x86_ssse3? (
				cpu_flags_x86_sse3
			)
		)
		openexr
		openimageio
		tiff
		amd64? (
			cpu_flags_x86_sse2
		)
		cpu_flags_x86_sse? (
			cpu_flags_x86_sse2
		)
		cpu_flags_x86_sse2? (
			cpu_flags_x86_sse
		)
		cpudetection? (
			cpu_flags_x86_avx? (
				cpu_flags_x86_sse
			)
			cpu_flags_x86_avx2? (
				cpu_flags_x86_sse
			)
		)
		osl? (
			llvm
		)
		x86? (
			cpu_flags_x86_sse2
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
	cpu_flags_x86_avx512er? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_fma
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
	)
"

REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	${REQUIRED_USE_CYCLES}
	${REQUIRED_USE_EIGEN}
	${REQUIRED_USE_MINIMAL_CPU_FLAGS}
"

EXPORT_FUNCTIONS \
	pkg_pretend \
	pkg_setup \
	src_prepare \
	src_configure \
	src_compile \
	src_install \
	src_test \
	pkg_postinst \
	pkg_postrm

get_dest() {
	if [[ "${impl}" == "build_portable" ]] ; then
		echo "/usr/share/${PN}/${SLOT_MAJ}/${impl#*_}"
	else
		echo "/usr/$(get_libdir)/${PN}/${SLOT_MAJ}/${impl#*_}"
	fi
}

blender_check_requirements() {
	# tc-check-openmp does not print slot/version details.
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
	${CC} --version

	# Use /usr/include/omp.h instead of /usr/lib/gcc/${CHOST}/12/include/omp.h

	if use openmp ; then
		tc-check-openmp
	fi

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

blender_pkg_pretend() {
	blender_check_requirements
}

check_embree() {
	# There is no standard embree ebuild.  Assume other repo or local copy.

	if has embree ${IUSE_EFFECTIVE} && use embree ; then
		# The default for EMBREE_FILTER_FUNCTION is ON in embree.
		if grep -q -F -e "EMBREE_FILTER_FUNCTION=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*"/"*".ebuild" 2>/dev/null ; then
ewarn
ewarn "EMBREE_FILTER_FUNCTION should be set to ON for embree."
ewarn
		else
			if has_version 'media-libs/embree[-filter_function]' || \
			   has_version 'media-libs/embree[-filter-function]' || \
			   has_version 'media-libs/embree[-filterfunction]' ; then
ewarn
ewarn "EMBREE_FILTER_FUNCTION should be set to ON for embree."
ewarn
			fi
		fi

		# The default for EMBREE_BACKFACE_CULLING is OFF in embree.
		if grep -q -F -e "EMBREE_BACKFACE_CULLING=ON" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*"/"*".ebuild" 2>/dev/null ; then
ewarn
ewarn "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
ewarn
		else
			if has_version 'media-libs/embree[backface_culling]' || \
			   has_version 'media-libs/embree[backface-culling]' || \
			   has_version 'media-libs/embree[backfaceculling]' ; then
ewarn
ewarn "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
ewarn
			fi
		fi

		# The default for EMBREE_RAY_MASK is OFF in embree.
		if grep -q -F -e "EMBREE_RAY_MASK=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*"/"*".ebuild" 2>/dev/null ; then
ewarn
ewarn "EMBREE_RAY_MASK should be set to ON for embree."
ewarn
		else
			if   has_version 'media-libs/embree[-ray_mask]' || \
			     has_version 'media-libs/embree[-ray-mask]' || \
			     has_version 'media-libs/embree[-raymask]' ; then
ewarn
ewarn "EMBREE_RAY_MASK should be set to ON for embree."
ewarn
			elif has_version 'media-libs/embree[ray_mask]' || \
			     has_version 'media-libs/embree[ray-mask]' || \
			     has_version 'media-libs/embree[raymask]' ; then
				:;
			elif has_version 'media-libs/embree' ; then
ewarn
ewarn "EMBREE_RAY_MASK should be set to ON for embree."
ewarn
			fi
		fi
	fi
}

check_compiler() {
	if ! test-flags-CXX "-std=c++${CXXABI_VER}" 2>/dev/null 1>/dev/null ; then
eerror
eerror "Switch to a c++${CXXABI_VER} compatible compiler."
eerror
	fi
	if tc-is-gcc ; then
		if ver_test $(gcc-fullversion) -lt ${GCC_MIN} ; then
eerror
eerror "${PN} requires GCC >= ${GCC_MIN}"
eerror
			die
		fi
	elif tc-is-clang ; then
		if ver_test $(clang-version) -lt ${CLANG_MIN} ; then
eerror
eerror "${PN} requires Clang >= ${CLANG_MIN}"
eerror
			die
		fi
	else
eerror
eerror "Compiler is not supported"
eerror
		die
	fi
}

blender_pkg_setup() {
	llvm_pkg_setup
	blender_check_requirements
	python-single-r1_pkg_setup
	check_cpu
	check_optimal_compiler_for_cycles_x86
	check_embree
	check_compiler
	uopts_setup
	if declare -f _blender_pkg_setup > /dev/null ; then
		_blender_pkg_setup
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
				if [[ "${CXXFLAGS}" =~ "march=x86-64" ]] ; then
					:;
				else
ewarn
ewarn "The CXXFLAGs doesn't contain -march=x86-64.  It will not be portable"
ewarn "unless you change it."
ewarn
				fi
			fi
			if [[ "${ABI}" == "x86" ]] ; then
				if [[ "${CXXFLAGS}" =~ "march=i686" ]] ; then
					:;
				else
ewarn
ewarn "The CXXFLAGs doesn't contain -march=i686.  It will not be portable"
ewarn "unless you change it."
ewarn
				fi
			fi
			# These are .a libraries listed from the linking phase
			# of build_portable
			#
			# Mesa is listed because it was shipped in the Blender
			# binary distribution.  This may be required
			# when distributing games with Blender player.
			RDEPEND_279=(
				"dev-libs/boost"
				"dev-libs/libpcre"
				"dev-libs/libspnav"
				"media-gfx/openvdb"  # originally blender-libs/openvdb
				"media-libs/mesa"    # originally blender-libs/mesa
				"media-libs/opensubdiv"
				"media-libs/openjpeg"
				"media-libs/osl"     # originally blender-libs/osl
				"sci-libs/fftw"
				"sys-libs/zlib"
			)
			for p in ${RDEPEND_279[@]} ; do
				if ls "${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS \
					2>/dev/null 1>/dev/null ; then
					if [[ "${ABI}" == "amd64" ]] ; then
						if ! grep -q -F -e "march=x86-64" \
							"${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS ; then
ewarn
ewarn "${p} is not compiled with -march=x86-64.  It is not portable.  Recompile"
ewarn "the dependency."
ewarn
						fi
					fi
					if [[ "${ABI}" == "x86" ]] ; then
						if ! grep -q -F -e "march=i686" \
							"${EROOT}"/var/db/pkg/${p}-*/C{,XX}FLAGS ; then
ewarn
ewarn "${p} is not compiled with -march=i686.  It is not portable.  Recompile"
ewarn "the dependency"
ewarn
						fi
					fi
				fi
			done
		fi
	fi
}

check_cpu() {
	if use kernel_linux \
		&& [[ ! -e "${BROOT}/proc/cpuinfo" ]] ; then
ewarn
ewarn "Skipping cpu checks.  The compiled program may exhibit runtime failure."
ewarn
		return
	fi

	# Sorted by chronological order to be able to disable remaining
	# incompatible.
	grep -q -i -E -e 'mmx( |$)' "${BROOT}/proc/cpuinfo" # 1997
	local has_mmx="$?"
	grep -q -i -E -e 'sse( |$)' "${BROOT}/proc/cpuinfo" # 1999
	local has_sse="$?"
	grep -q -i -E -e 'sse2( |$)' "${BROOT}/proc/cpuinfo" # 2000
	local has_sse2="$?"
	grep -q -i -E -e 'sse3( |$)' "${BROOT}/proc/cpuinfo" # 2004
	local has_sse3="$?"
	grep -q -i -E -e 'pni( |$)' "${BROOT}/proc/cpuinfo" # 2004, equivalent to sse3
	local has_pni="$?"
	grep -q -i -E -e 'ssse3( |$)' "${BROOT}/proc/cpuinfo" # 2006
	local has_ssse3="$?"
	grep -q -i -E -e 'abm( |$)' "${BROOT}/proc/cpuinfo" # 2007
	local has_abm="$?"
	grep -q -i -E -e 'sse4_1( |$)' "${BROOT}/proc/cpuinfo" # 2008
	local has_sse4_1="$?"
	grep -q -i -E -e 'sse4_2( |$)' "${BROOT}/proc/cpuinfo" # 2008
	local has_sse4_2="$?"
	grep -q -i -E -e 'avx( |$)' "${BROOT}/proc/cpuinfo" # 2011
	local has_avx="$?"
	grep -q -i -E -e 'f16c( |$)' "${BROOT}/proc/cpuinfo" # 2011
	local has_f16c="$?"
	grep -q -i -E -e 'fma( |$)' "${BROOT}/proc/cpuinfo" # 2012
	local has_fma="$?"
	grep -q -i -E -e 'bmi1( |$)' "${BROOT}/proc/cpuinfo" # 2013
	local has_bmi1="$?"
	grep -q -i -E -e 'avx2( |$)' "${BROOT}/proc/cpuinfo" # 2013
	local has_avx2="$?"
	grep -q -i -E -e 'avx512f( |$)' "${BROOT}/proc/cpuinfo" # 2016 / 2017
	local has_avx512f="$?"
	grep -q -i -E -e 'avx512er( |$)' "${BROOT}/proc/cpuinfo" # 2016
	local has_avx512er="$?"
	grep -q -i -E -e 'avx512dq( |$)' "${BROOT}/proc/cpuinfo" # 2017
	local has_avx512dq="$?"
	grep -q -i -E -e 'avx512bf16( |$)' "${BROOT}/proc/cpuinfo" # 2020
	local has_avx512bf16="$?"

	# We cancel building to prevent runtime errors with dependencies
	# that may not do sufficient runtime checks for cpu types like eigen.

	cpuflag_die() {
		local flag="${1}"
eerror
eerror "${flag} may not be supported on your CPU and was enabled via the"
eerror "cpu_flags_x86_${flag}"
eerror
		die
	}

	if use cpu_flags_x86_mmx ; then
		if [[ "${has_mmx}" != "0" ]] ; then
			cpuflag_die "mmx"
		fi
	fi

	if use cpu_flags_x86_sse ; then
		if [[ "${has_sse}" != "0" ]] ; then
			cpuflag_die "sse"
		fi
	fi

	if use cpu_flags_x86_sse2 ; then
		if [[ "${has_sse2}" != "0" ]] ; then
			cpuflag_die "sse2"
		fi
	fi

	if use cpu_flags_x86_sse3 ; then
		if [[ "${has_sse3}" != "0" && "${has_pni}" != "0" ]] ; then
			cpuflag_die "sse3"
		fi
	fi

	if use cpu_flags_x86_ssse3 ; then
		if [[ "${has_ssse3}" != "0" ]] ; then
			cpuflag_die "ssse3"
		fi
	fi

	if use cpu_flags_x86_lzcnt ; then
		if [[ "${has_bmi1}" != "0" && "${has_abm}" != "0" ]] ; then
			cpuflag_die "lzcnt"
		fi
	fi

	if use cpu_flags_x86_sse4_1 ; then
		if [[ "${has_sse4_1}" != "0" ]] ; then
			cpuflag_die "sse4_1"
		fi
	fi

	if use cpu_flags_x86_sse4_2 ; then
		if [[ "${has_sse4_2}" != "0" ]] ; then
			cpuflag_die "sse4_2"
		fi
	fi

	if use cpu_flags_x86_avx ; then
		if [[ "${has_avx}" != "0" ]] ; then
			cpuflag_die "avx"
		fi
	fi

	if use cpu_flags_x86_f16c ; then
		if [[ "${has_f16c}" != "0" ]] ; then
			cpuflag_die "f16c"
		fi
	fi

	if use cpu_flags_x86_fma ; then
		if [[ "${has_fma}" != "0" ]] ; then
			cpuflag_die "fma"
		fi
	fi

	# For tzcnt
	if use cpu_flags_x86_bmi ; then
		if [[ "${has_bmi1}" != "0" ]] ; then
			cpuflag_die "bmi"
		fi
	fi

	if use cpu_flags_x86_avx2 ; then
		if [[ "${has_avx2}" != "0" ]] ; then
			cpuflag_die "avx2"
		fi
	fi

	if use cpu_flags_x86_avx512f ; then
		if [[ "${has_avx512f}" != "0" ]] ; then
			cpuflag_die "avx512f"
		fi
	fi

	if use cpu_flags_x86_avx512er ; then
		if [[ "${has_avx512er}" != "0" ]] ; then
			cpuflag_die "avx512er"
		fi
	fi

	if use cpu_flags_x86_avx512dq ; then
		if [[ "${has_avx512dq}" != "0" ]] ; then
			cpuflag_die "avx512dq"
		fi
	fi

	if use cpu_flags_x86_avx512bf16 ; then
		if [[ "${has_avx512bf16}" != "0" ]] ; then
			cpuflag_die "avx512bf16"
		fi
	fi
}

check_optimal_compiler_for_cycles_x86() {
	if [[ "${ABI}" == "x86" ]] ; then
		#
		# Cycles says that a bug might be in in gcc so use clang or icc.
		# If you use gcc, it will not optimize cycles except with maybe sse2.
		#
		if [[ -n "${BLENDER_CC_ALT}" && -n "${BLENDER_CXX_ALT}" ]] ; then
			export CC="${BLENDER_CC_ALT}"
			export CXX="${BLENDER_CXX_ALT}"
		elif [[ -n "${CC}" && -n "${CXX}" ]] \
			&& [[ ! ( "${CC}" =~ "gcc" ) ]] \
			&& [[ ! ( "${CXX}" =~ "g++" ) ]] ; then
			# Defined by user from per-package environmental variables.
			export CC
			export CXX
		elif has_version 'sys-devel/clang' ; then
			export CC="${CHOST}-clang"
			export CXX="${CHOST}-clang++"
		fi
	else
		if [[ ! -n "${CC}" || ! -n "${CXX}" ]] ; then
			export CC="$(tc-getCC ${CHOST})"
			export CXX="$(tc-getCXX ${CHOST})"
		fi
	fi
	strip-unsupported-flags

einfo
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
einfo
}

IMPLS=(
	build_creator
	build_headless
)
IUSE+=" ${IMPLS[@]} "
REQUIRED_USE+=" || ( ${IMPLS[@]} ) "

_get_impls() {
	use build_creator && echo "build_creator"
	use build_headless && echo "build_headless"
}

blender_src_prepare() {
	cd "${S}" || die
	cmake_src_prepare
	if declare -f _src_prepare_patches > /dev/null ; then
		_src_prepare_patches
	fi

	# we don't want static glew, but it's scattered across
	# multiple files that differ from version to version
	# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
	local file
	while IFS="" read -d $'\0' -r file ; do
		if grep -q -F -e "-DGLEW_STATIC" "${file}" ; then
einfo
einfo "Removing -DGLEW_STATIC from ${file}"
einfo
			sed -i -e '/-DGLEW_STATIC/d' "${file}"
		fi
	done < <(find . -type f -name "CMakeLists.txt" -print0)
	export IFS=$' \t\n'

	sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
		intern/cycles/app/CMakeLists.txt || die

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die

	if use cuda ; then
		cuda_add_sandbox -w
		cuda_src_prepare
	fi

	local impl
	for impl in $(_get_impls) ; do
		uopts_src_prepare
	done
}

blender_configure_eigen() {
	if use cpu_flags_x86_avx512f ; then
		if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
knl|knm|skylake-avx512|cannonlake|icelake-client|icelake-server|cascadelake|\
cooperlake|tigerlake|sapphirerapids|rocketlake) ]] \
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
skylake-avx512|cannonlake|icelake-client|icelake-server|cascadelake|cooperlake|\
tigerlake|sapphirerapids|rocketlake) ]] \
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

	if use usd && ldd "${ESYSROOT}/usr/$(get_libdir)/openusd/lib/libusd_ms.so" 2>/dev/null \
		| grep -q -e "libtbb.so.${LEGACY_TBB_SLOT} " ; then
einfo "Adding tbb:${LEGACY_TBB_SLOT} to rpath for USD (libusd_ms.so)"
		mycmakeargs+=(
			-DTBB_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
	fi

	if use usd && ldd "${ESYSROOT}/usr/$(get_libdir)/openusd/lib/libusd_usd_ms.so" 2>/dev/null \
		| grep -q -e "libtbb.so.${LEGACY_TBB_SLOT} " ; then
einfo "Adding tbb:${LEGACY_TBB_SLOT} to rpath for USD (libusd_usd_ms.so)"
		mycmakeargs+=(
			-DTBB_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
	fi

	if use openvdb && ldd "${ESYSROOT}/usr/$(get_libdir)/libopenvdb.so" 2>/dev/null \
		| grep -q -e "libtbb.so.${LEGACY_TBB_SLOT} " ; then
einfo "Adding tbb:${LEGACY_TBB_SLOT} to rpath for OpenVDB (libopenvdb.so)"
		mycmakeargs+=(
			-DTBB_LIB_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
	fi
}

blender_configure_simd_cycles() {
	if ver_test $(ver_cut 1-2 ${PV}) -ge 2.80 ; then
		if [[ -e "${ESYSROOT}/usr/$(get_libdir)/libembree_avx512.a" ]] ; then
			# Avoid missing symbols
			sed -i -e "/embree_avx2$/a    embree_avx512" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi

		if [[ ! -e "${ESYSROOT}/usr/$(get_libdir)/libembree_avx.a" ]] ; then
			sed -i -e "/embree_avx$/d" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi

		if [[ ! -e "${ESYSROOT}/usr/$(get_libdir)/libembree_avx2.a" ]] ; then
			sed -i -e "/embree_avx2$/d" \
				build_files/cmake/Modules/FindEmbree.cmake || die
		fi

		if [[ ! -e "${ESYSROOT}/usr/$(get_libdir)/libembree_sse42.a" ]] ; then
			sed -i -e "/embree_sse42$/d" \
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
			sed -i -e "/WITH_KERNEL_SSE2$/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse3 ; then
			sed -i -e "/WITH_KERNEL_SSE3$/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse4_1 ; then
			sed -i -e "/WITH_KERNEL_SSE41$/d" \
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
			sed -i -e "/WITH_KERNEL_SSE41$/d" \
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
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|alderlake|\
rocketlake|\
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
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|alderlake|\
rocketlake|\
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
alderlake|rocketlake|\
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
rocketlake|\
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
		export USD_ROOT_DIR="${ESYSROOT}/usr/$(get_libdir)/openusd/lib"
	fi
}

blender_configure_optix() {
	if use optix ; then
		mycmakeargs+=(
			-DOPTIX_ROOT_DIR="${ESYSROOT}/opt/optix"
		)
	fi
}

blender_src_configure() { :; }

_src_compile() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${BUILD_DIR}" || die

	cmake_src_compile
}

_src_compile_docs() {
	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

einfo
einfo "Generating Blender C/C++ API docs ..."
einfo
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		if ! doxygen ; then
eerror
eerror "doxygen failed to build API docs."
eerror
			die
		fi

		cd "${CMAKE_USE_DIR}" || die
einfo
einfo "Generating (BPY) Blender Python API docs ..."
einfo
		if ! "${BUILD_DIR}/bin/blender" \
			--background \
			--python "doc/python_api/sphinx_doc_gen.py" \
			-noaudio ; then
eerror
eerror "sphinx failed."
eerror
		fi

		cd "${CMAKE_USE_DIR}/doc/python_api" || die
		if ! sphinx-build sphinx-in BPY_API ; then
eerror
eerror "sphinx failed."
eerror
			die
		fi
	fi
}

# TODO
# orphaned / deadcode
_install() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${BUILD_DIR}" || die
einfo
einfo "Installing sandboxed copy"
einfo
	_src_install
}

_clean() {
einfo
einfo "Wiping sandboxed install"
einfo
	cd "${S}" || die
	rm -rf "${D}" || die
}

blender_src_compile() {
	local impl
	for impl in $(_get_impls) ; do
		_ORIG_PATH="${PATH}"
		export PGO_PHASE=$(epgo_get_phase)
einfo
einfo "PGO_PHASE:  ${PGO_PHASE}"
einfo
		uopts_src_configure
		_src_configure
		_src_compile
		if [[ "${impl}" == "build_creator" ]] ; then
			_src_compile_docs
		fi
		export PATH="${_ORIG_PATH}"
	done
}

_src_test() {
	use hip && check_amdgpu
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${BUILD_DIR}" || die
	if use test; then
einfo
einfo "Running Blender Unit Tests for ${impl} ..."
einfo
		cd "${BUILD_DIR}/bin/tests" || die
		local f
		for f in *_test; do
			"./${f}" || die
		done
	fi
}

blender_src_test() {
	local impl
	for impl in $(_get_impls) ; do
		_src_test
	done
}

_src_install_doc() {
	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}/doc/python_api/BPY_API/".

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}/doc/doxygen/html/".
	fi

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}/release/text/readme.html"
	rm -r "${ED}/usr/share/doc/blender" || die
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
			if [[ "${impl}" == "build_portable" ]] ; then
				insinto "${d_dest}/licenses/${d}"
				doins -r "${f}"
			elif [[ "${impl}" == "build_creator" \
			     || "${impl}" == "build_headless" ]] ; then
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
			if [[ "${impl}" == "build_portable" ]] ; then
				insinto "${d_dest}/readmes/${d}"
				doins -r "${f}"
			elif [[ "${impl}" == "build_creator" \
			     || "${impl}" == "build_headless" ]] ; then
				docinto "readmes/${d}"
				dodoc -r "${f}"
			fi
		fi
	done
}

_src_install() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${BUILD_DIR}" || die

	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}/bin/blender"

	cmake_src_install
	if [[ "${impl}" == "build_creator" ]] ; then
		_src_install_doc
	fi

	local d_dest=$(get_dest)
	if [[ "${impl}" == "build_creator" ]] ; then
		if [[ -e "${ED}${d_dest}/blender-thumbnailer.py" ]] ; then
			python_fix_shebang "${ED}${d_dest}/blender-thumbnailer.py"
		fi
		python_optimize "${ED}/usr/share/${PN}/${SLOT_MAJ}/scripts"
	fi

	local suffix=
	if [[ "${impl}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications/blender"{,-${SLOT_MAJ}}".desktop" || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT_MAJ}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=${EPREFIX}/usr/bin/${PN}-${SLOT_MAJ}|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT_MAJ}|g" "${menu_file}" || die
		if [[ -n "${IS_LTS}" && "${IS_LTS}" == "1" ]] ; then
			touch "${ED}${d_dest}/.lts"
		fi
	fi

	if [[ "${impl}" == "build_creator" || "${impl}" == "build_headless" ]] ; then
		if [[ "${impl}" == "build_creator" ]] ; then
			suffix=""
		elif [[ "${impl}" == "build_headless" ]] ; then
			suffix="-headless"
		fi
		cat <<EOF > "${T}/${PN}${suffix}-${SLOT_MAJ}"
#!${EPREFIX}/bin/bash
export PYTHONPATH="${EPREFIX}/usr/lib/${EPYTHON}:${EPREFIX}/usr/lib/${EPYTHON}/lib-dynload:${EPREFIX}/usr/lib/${EPYTHON}/site-packages:\${PYTHONPATH}"
BLENDER_EXTERN_DRACO_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)/${PN}/$(ver_cut 1-3 ${PV})/python/lib/${EPYTHON}/site-packages"
"${EPREFIX}${d_dest}/blender" --python-use-system-env "\$@"
EOF
		exeinto /usr/bin
		doexe "${T}/${PN}${suffix}-${SLOT_MAJ}"
	fi
	if [[ "${impl}" == "build_portable" ]] ; then
		fecho1() {
			echo "${@}" > "${ED}${d_dest}/README.3rdparty_deps" || die
		}
fecho1
fecho1 "# The following libraries were linked to blenderplayer as shared"
fecho1 "# libraries and need to be present on the other computer or distributed"
fecho1 "# with blenderplayer with licenses or built without such dependencies."
fecho1 "# The dependency of those direct shared dependencies may also be required."
fecho1
		if [[ ! -e "${T}/build-build_portable.log" ]] ; then
eerror
eerror "Missing build log."
eerror
			die
		fi

		# List direct dependencies
fecho1
fecho1 "# Direct shared dependencies:"
fecho1
		grep -E -e "-o .*blenderplayer " \
			"${T}"/build-build_portable.log \
			| grep -o -E -e "[^ ]+\.so(.[0-9]+)?" | sort | uniq \
			| sed -e "/^$/d" \
			>> "${ED}${d_dest}/README.3rdparty_deps" || die
fecho1
fecho1 "# Dependency of direct shared dependencies:"
fecho1

		# List dependency of those direct dependencies
		echo -e $(for f in $(cat "${ED}${d_dest}/README.3rdparty_deps" \
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
fecho1
fecho1
fecho1 "Place the shared libraries in the lib folder containing blenderplayer"
fecho1 "along with licenses."
fecho1
fecho1 "Blender adds mesa libs to their binary distribution.  You may need to"
fecho1 "do the same especially to avoid the multiple LLVM versions being loaded"
fecho1 "bug."
fecho1
	fi
	install_licenses
	use doc && install_readmes

	uopts_src_install
}

blender_src_install() {
	export STRIP="${BROOT}/usr/true" # preserve rpath
	local impl
	for impl in $(_get_impls) ; do
		_src_install
	done
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
	mv "${ED}/usr/share/man/man1/blender"{,-${SLOT_MAJ}}".1" || die
}

blender_pkg_postinst() {
ewarn
ewarn "Blender uses python integration. As such, may have some risks with"
ewarn "running unknown python scripts."
ewarn
ewarn "It is recommended to change your blender temp directory from /tmp to"
ewarn "/home/user/tmp or another tmp file under your home directory. This can"
ewarn "be done by starting blender, then dragging the main menu down do"
ewarn "display all paths."
ewarn
ewarn
ewarn "This ebuild does not unbundle the massive amount of 3rd party libraries"
ewarn "which are shipped with blender. Note that these have caused security"
ewarn "issues in the past.  If you are concerned about security, file a bug"
ewarn "to upstream at https://developer.blender.org."
ewarn

	xdg_pkg_postinst

	local d_src="${EROOT}/usr/$(get_libdir)/${PN}"
	local pv=""
	if [[ "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# The highest LTS
		pv=$(basename \
			$(dirname \
				$(dirname \
					$(ls \
						"${d_src}"/*/creator/.lts \
						| sort -V \
						| tail -n 1 \
					) \
				) \
			) \
		)
	elif [[ "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# The highest pv
		pv=$(ls "${d_src}/" \
			| sed -e "/^[a-z]/d" \
			| sort -V \
			| tail -n 1 \
		)
	elif [[ "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
		# A custom pv
		pv=$(echo "${BLENDER_MAIN_SYMLINK_MODE}" \
			| cut -f 2 -d "-")
	fi
	if [[ -n "${pv}" ]] ; then
		if use build_creator ; then
			ln -sf \
				"${EROOT}/usr/bin/${PN}-${pv}" \
				"${EROOT}/usr/bin/${PN}" \
				|| die
		fi
		if use build_headless ; then
			ln -sf \
				"${EROOT}/usr/bin/${PN}-headless-${pv}" \
				"${EROOT}/usr/bin/${PN}-headless" \
				|| die
		fi
	fi

	uopts_pkg_postinst

	if use openimagedenoise ; then
ewarn
ewarn "The CPU must support SSE4 or preview render doesn't work."
ewarn "If you do not have SSE4, disable the openimagedenoise USE flag."
ewarn
	fi
ewarn
ewarn "Invoking the blender binary directly may result in a segfault."
ewarn "Call it indirectly through the wrapper (/usr/bin/blender) instead."
ewarn
	if use cycles ; then
ewarn
ewarn "You must disable Render > Cycles > Denoise in order to render if the CPU"
ewarn "does not have SSE4.1 in order to render with cycles."
ewarn
	fi
}

blender_pkg_postrm() {
	xdg_pkg_postrm

ewarn
ewarn "You may want to remove the following directory."
ewarn "~/.config/${PN}/${SLOT_MAJ}/cache/"
ewarn "It may contain extra render kernels not tracked by portage"
ewarn
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

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
