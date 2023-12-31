# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXXABI_V=11
TRAIN_USE_X=1
TRAIN_TEST_DURATION=120
inherit cmake flag-o-matic linux-info toolchain-funcs uopts

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
LICENSE="
	Apache-2.0
	static-libs? (
		BSD
		BZIP2
		MIT
		ZLIB
	)
	tutorials? (
		Apache-2.0
		MIT
	)
"
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT_MAJ="3"
SLOT="${SLOT_MAJ}/${PV}"

X86_CPU_FLAGS=(
	avx:avx
	avx2:avx2
	avx512f:avx512f
	avx512vl:avx512vl
	avx512bw:avx512bw
	avx512dq:avx512dq
	avx512cd:avx512cd
	sse2:sse2
	sse4_2:sse4_2
)
ARM_CPU_FLAGS=(
	neon:neon
	neon2x:neon2x
)
CPU_FLAGS=(
	${ARM_CPU_FLAGS[@]/#/cpu_flags_arm_}
	${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
)

IUSE+="
${CPU_FLAGS[@]%:*}
-allow-auto-vectorization -allow-strict-aliasing backface-culling clang
-compact-polys -custom-cflags custom-optimization debug doc doc-docfiles
doc-html doc-images doc-man +hardened +filter-function gcc ispc raymask -ssp
static-libs +tbb test tutorials
"
REQUIRED_USE+="
	^^ ( clang gcc )
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse2
	)
	pgo? (
		tutorials
	)
	|| (
		${CPU_FLAGS[@]%:*}
	)
"
# For ISAs, see https://github.com/embree/embree/blob/v3.13.4/common/sys/sysinfo.h#L153
# All flags required for proper reporting in
# https://github.com/embree/embree/blob/v3.13.4/common/cmake/check_isa.cpp

MIN_CLANG_V="3.3" # for c++11
MIN_CLANG_V_AVX512SKX="3.6" # for -march=skx
MIN_GCC_V="4.8.1" # for c++11
MIN_GCC_V_AVX512SKX="5.1.0" # for -mavx512vl
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
# 15.0.1 -xCOMMON-AVX512
BDEPEND+="
	>=dev-util/cmake-3.2.0
	virtual/pkgconfig
	clang? (
		>=sys-devel/clang-${MIN_CLANG_V}
		cpu_flags_x86_avx512dq? (
			>=sys-devel/clang-${MIN_CLANG_V_AVX512SKX}
		)
	)
	doc? (
		app-text/pandoc
		dev-texlive/texlive-xetex
	)
	doc-html? (
		app-text/pandoc
		media-gfx/imagemagick[jpeg]
	)
	doc-images? (
		media-gfx/imagemagick[jpeg]
		media-gfx/xfig
	)
	gcc? (
		>=sys-devel/gcc-${MIN_GCC_V}
		cpu_flags_x86_avx512dq? (
			>=sys-devel/gcc-${MIN_GCC_V_AVX512SKX}
		)
	)
	ispc? (
		>=dev-lang/ispc-1.17.0
	)
"
# See .gitlab-ci.yml (track: release-linux-x64-Release)
DEPEND+="
	media-libs/glfw
	virtual/opengl
	tbb? (
		|| (
			(
				!<dev-cpp/tbb-2021:0=
				<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
			)
			>=dev-cpp/tbb-2021.2.0:${ONETBB_SLOT}=
		)
	)
	tutorials? (
		<media-libs/openimageio-2.3.5.0[-cxx17(-),-abi8-compat,-abi9-compat]
		media-libs/libpng:0=
		virtual/jpeg:0
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	pgo? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"
SRC_URI="
https://github.com/embree/embree/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
DOCS=( CHANGELOG.md README.md readme.pdf )
CMAKE_BUILD_TYPE=Release
PATCHES=(
	"${FILESDIR}/${PN}-3.13.0-findtbb-more-debug-messages.patch"
	"${FILESDIR}/${PN}-3.13.0-findtbb-alt-lib-path.patch"
	"${FILESDIR}/${PN}-3.13.4-tbb-alt-config.patch"
	"${FILESDIR}/${PN}-3.13.5-customize-flags.patch"
)

chcxx() {
eerror
eerror "You need to switch your ${1} compiler to at least ${2} or higher for"
eerror "${3} support."
eerror
	die
}

pkg_setup() {
	export CMAKE_BUILD_TYPE=$(usex debug "RelWithDebInfo" "Release")
	if use kernel_linux ; then
		CONFIG_CHECK="~TRANSPARENT_HUGEPAGE"
		WARNING_TRANSPARENT_HUGEPAGE=\
"Not enabling Transparent Hugepages (CONFIG_TRANSPARENT_HUGEPAGE) will impact "\
"rendering performance."
		linux-info_pkg_setup

		if ! ( cat "${BROOT}/proc/cpuinfo" \
				| grep sse2 > "${BROOT}/dev/null" ) ; then
			die "You need a CPU with at least sse2 support."
		fi
	fi

	# This resolves multiple installed compilers or multiple version scenario.
	if use clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		local cc_v=$(clang-fullversion)
		if ver_test ${cc_v} -lt ${MIN_CLANG_V} ; then
			chcxx "Clang" "${MIN_CLANG_V}" "c++11"
		fi
		if ver_test ${cc_v} -lt ${MIN_CLANG_V_AVX512SKX} \
			&& use cpu_flags_x86_avx512dq ; then
			chcxx "Clang" "${MIN_CLANG_V_AVX512SKX}" "AVX512-SKX"
		fi
	else
		export CC="${CC_ALT:-${CHOST}-gcc}"
		export CXX="${CXX_ALT:-${CHOST}-g++}"
		if tc-is-gcc ; then
			local cc_v=$(gcc-fullversion)
			if ver_test ${cc_v} -lt ${MIN_GCC_V} ; then
				chcxx "GCC" "${MIN_GCC_V}" "c++11"
			fi
			if ver_test ${cc_v} -lt ${MIN_GCC_V_AVX512SKX} \
				&& use cpu_flags_x86_avx512dq ; then
				chcxx "GCC" "${MIN_GCC_V_AVX512SKX}" "AVX512-SKX"
			fi
		else
ewarn
ewarn "Unrecognized compiler"
ewarn
ewarn "CC:\t${CC}"
ewarn "CXX:\t${CXX}"
ewarn
		fi
	fi

	if use doc-html ; then
		if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES to be able to"
eerror "use MathJax for math rendering."
eerror
			die
		fi
ewarn
ewarn "Building package may exhibit random failures with doc-html USE flag."
ewarn "Emerge and try again."
ewarn
	fi
	uopts_setup
}

src_prepare() {
	cmake_src_prepare
	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
	uopts_src_prepare
}

src_configure() { :; }

_src_configure() {
einfo
einfo "PGO PHASE:  ${PGO_PHASE}"
einfo
	strip-unsupported-flags
	uopts_src_configure
	if tc-is-clang && ! use clang ; then
eerror
eerror "Enable the clang USE flag or switch to GCC."
eerror
		die
	fi

	PGO_CXX_FLAGS=""
	PGO_LDFLAGS=""
	if ! use custom-cflags ; then
		strip-flags
		filter-flags "-frecord-gcc-switches"
		filter-ldflags "-Wl,--as-needed"
		filter-ldflags "-Wl,-O1"
		filter-ldflags "-Wl,--defsym=__gentoo_check_ldflags__=0"
	fi

	# NOTE: You can make embree accept custom CXXFLAGS by turning off
	# EMBREE_IGNORE_CMAKE_CXX_FLAGS. However, the linking will fail if you use
	# any "march" compile flags. This is because embree builds modules for the
	# different supported ISAs and picks the correct one at runtime.
	# "march" will pull in cpu instructions that shouldn't be in specific modules
	# and it fails to link properly.
	# https://github.com/embree/embree/issues/115

	filter-flags -march=*

# FIXME:
#	any option with a comment # default at the end of the line is
#	currently set to use default value. Some of them could probably
#	be turned into USE flags.
#
#	EMBREE_CURVE_SELF_INTERSECTION_AVOIDANCE_FACTOR: leave it at 2.0f for now
#		0.0f disables self intersection avoidance.
#
# The build currently only works with their own C{,XX}FLAGS,
# not respecting user flags.
	local mycmakeargs=(
		# Both have the same numbers with or without optimization flag
		# with embree_test and embree_verify
		-DALLOW_AUTO_VECTORIZATION=$(usex allow-auto-vectorization)
		-DALLOW_STRICT_ALIASING=$(usex allow-strict-aliasing)
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON
		-DEMBREE_BACKFACE_CULLING=$(usex backface-culling)
		-DEMBREE_COMPACT_POLYS=$(usex compact-polys)
		-DEMBREE_FILTER_FUNCTION=$(usex filter-function)
		-DEMBREE_GEOMETRY_CURVE=ON			# default
		-DEMBREE_GEOMETRY_GRID=ON			# default
		-DEMBREE_GEOMETRY_INSTANCE=ON			# default
		-DEMBREE_GEOMETRY_POINT=ON			# default
		-DEMBREE_GEOMETRY_QUAD=ON			# default
		-DEMBREE_GEOMETRY_SUBDIVISION=ON		# default
		-DEMBREE_GEOMETRY_TRIANGLE=ON			# default
		-DEMBREE_GEOMETRY_USER=ON			# default
		-DEMBREE_IGNORE_CMAKE_CXX_FLAGS=$(use custom-cflags OFF ON)
		-DEMBREE_IGNORE_INVALID_RAYS=OFF		# default
		-DEMBREE_ISA_AVX=$(usex cpu_flags_x86_avx)
		-DEMBREE_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DEMBREE_ISA_AVX512=$(usex cpu_flags_x86_avx512f \
			$(usex cpu_flags_x86_avx512cd \
				$(usex cpu_flags_x86_avx512dq \
					$(usex cpu_flags_x86_avx512bw \
						$(usex cpu_flags_x86_avx512vl \
							ON \
							OFF \
						) \
						OFF \
					) \
					OFF \
				) \
				OFF \
			) \
			OFF \
				     )
		-DEMBREE_ISA_NEON=$(usex cpu_flags_arm_neon)
		-DEMBREE_ISA_NEON2X=$(usex cpu_flags_arm_neon2x)
		-DEMBREE_ISA_SSE2=$(usex cpu_flags_x86_sse2)
		-DEMBREE_ISA_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DEMBREE_ISPC_SUPPORT=$(usex ispc)
		-DEMBREE_RAY_MASK=$(usex raymask)
		-DEMBREE_RAY_PACKETS=ON				# default
		-DEMBREE_STACK_PROTECTOR=$(usex ssp)
		-DEMBREE_STATIC_LIB=$(usex static-libs)
		-DEMBREE_STAT_COUNTERS=OFF
		-DEMBREE_TASKING_SYSTEM:STRING=$(usex tbb "TBB" "INTERNAL")
		-DEMBREE_TUTORIALS=$(usex tutorials)
		-DHARDENED=$(usex hardened)
	)

	local last_o=$(echo "${CFLAGS}" \
		| tr " " "\n" \
		| grep -E -e "-O(0|1|2|3|4|Ofast)( |$)" \
		| tail -n 1)
	if use custom-optimization ; then
		mycmakeargs+=( -DCUSTOM_OPTIMIZATION_LEVEL="${last_o}" )
	fi

	if use pgo ; then
		mycmakeargs+=(
			-DPGO_CXX_FLAGS="${PGO_CXX_FLAGS}"
			-DPGO_LDFLAGS="${PGO_LDFLAGS}"
		)
	fi

	if use tutorials; then
		use ispc && \
		mycmakeargs+=( -DEMBREE_ISPC_ADDRESSING:STRING="64" )
		mycmakeargs+=(
			-DEMBREE_TUTORIALS_LIBJPEG=ON
			-DEMBREE_TUTORIALS_LIBPNG=ON
			-DEMBREE_TUTORIALS_OPENIMAGEIO=ON
		)
	fi

	if use cpu_flags_arm_neon2x ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="NEON2X" )
	elif use cpu_flags_arm_neon ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="NEON" )
	elif use cpu_flags_x86_avx512f \
		&& use cpu_flags_x86_avx512cd \
		&& use cpu_flags_x86_avx512dq \
		&& use cpu_flags_x86_avx512bw \
		&& use cpu_flags_x86_avx512vl
	then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX512" )
	elif use cpu_flags_x86_avx2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX2" )
	elif use cpu_flags_x86_avx ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX" )
	elif use cpu_flags_x86_sse4_2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="SSE4.2" )
	elif use cpu_flags_x86_sse2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="SSE2" )
	else
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="NONE" )
	fi

	if ! use tbb ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
			-DTBB_SOVER=$(echo $(basename $(realpath "${ESYSROOT}/usr/$(get_libdir)/libtbb.so")) | cut -f 3 -d ".")
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_SOVER="${LEGACY_TBB_SLOT}"
		)
	fi

	cmake_src_configure
}

_src_compile() {
	cmake_src_compile
	if [[ "${PGO_PHASE}" == "PGO" || "${PGO_PHASE}" == "NO_PGO" ]] \
		&& use doc ; then
		pushd doc || die
			if use doc-images ; then
				einfo "Building doc/images"
				emake images
			fi
			if use doc-docfiles ; then
				einfo "Building doc/doc"
				emake doc
			fi
			if use doc-html ; then
				einfo "Building doc/www"
				emake images www
			fi
			if use doc-man ; then
				einfo "Building doc/man"
				emake man
			fi
		popd || die
	fi
}

_get_cbuild_isas() {
	if use kernel_linux ; then
		if grep -q -E -e "sse2( |$)" "${BROOT}/proc/cpuinfo" && use cpu_flags_x86_sse2 ; then
			echo "sse2"
		elif grep -q -E -e "sse42( |$)" "${BROOT}/proc/cpuinfo" && use cpu_flags_x86_sse4_2 ; then
			echo "sse4.2"
		elif grep -q -E -e "avx( |$)" "${BROOT}/proc/cpuinfo" && use cpu_flags_x86_avx ; then
			echo "avx"
		elif grep -q -E -e "avx2( |$)" "${BROOT}/proc/cpuinfo" && use cpu_flags_x86_avx2 ; then
			echo "avx2"
		elif grep -q -E -e "avx512f( |$)" "${BROOT}/proc/cpuinfo" \
			&& grep -q -E -e "avx512vl( |$)" "${BROOT}/proc/cpuinfo" \
			&& grep -q -E -e "avx512bw( |$)" "${BROOT}/proc/cpuinfo" \
			&& grep -q -E -e "avx512dq( |$)" "${BROOT}/proc/cpuinfo" \
			&& grep -q -E -e "avx512cd( |$)" "${BROOT}/proc/cpuinfo" \
			&& use cpu_flags_x86_avx512f \
			&& use cpu_flags_x86_avx512bw \
			&& use cpu_flags_x86_avx512dq \
			&& use cpu_flags_x86_avx512cd
		then
			echo "avx512"
		fi
	else
eerror
eerror "Kernel of CPU not supported for GPU yet."
eerror
		die
	fi
}

_get_time_override() {
	local trainer="${1}"
	local time_override=(
		"bvh_builder:86"
		"embree_verify:$((21*60))"
	) # exename:seconds
	local duration=${TRAIN_TEST_DURATION}
	for entry in ${time_override[@]} ; do
		local name="${entry%:*}"
		local time="${entry#*:}"
		if [[ "${trainer%:*}" =~ "${name}" ]] ; then
			duration=${time}
			break
		fi
	done
	echo "${duration}"
}

train_trainer_list() {
	local isa
	local f
	for f in $(find "${BUILD_DIR}" -maxdepth 1 -executable -type f | sort) ; do
		for isa in $(_get_cbuild_isas) ; do
			echo "${f}:${isa}"
		done
	done
}

train_get_trainer_exe() {
	local trainer="${1}"
	echo "${trainer%:*}"
}

train_get_trainer_args() {
	local trainer="${1}"
	local isa="${trainer#*:}"
	local ncpus=$(lscpu | grep "CPU(s)" | head -n 1 | grep -E -o -e "[0-9]+")
	local tpc=$(lscpu | grep "Thread(s) per core" | head -n 1 | grep -E -o -e "[0-9]+")
	local threads=$(( ${ncpus} * ${tpc} ))
#	einfo "Threads Per Core (TPC):  ${tpc}"
#	einfo "nCPUS:  ${ncpus}"
#	einfo "Threads:  ${threads}"
	echo --isa ${isa} --threads ${threads}
}

train_override_duration() {
	local trainer="${1}"
	local duration=$(_get_time_override "${trainer}")
	echo "${duration}"
}

src_compile() {
	uopts_src_compile
}

src_test() {
# All tests passed (15 assertions in 13 test cases)
	einfo "Running embree_tests"
	"embree_tests" || die
	if use tutorials ; then
ewarn
ewarn "The embree_verify is expected to fail.  To install, add test-fail-continue to"
ewarn "FEATURES as a per package envvar."
ewarn
# SSE2.ray_masks  [FAILED]
# SSE2.sphere_filter_multi_hit_tests ... [FAILED]
# Tests passed: 5110
# Tests failed: 521
# Tests failed and ignored: 48
		einfo "Running embree_verify"
		"embree_verify" || die
	fi
}

src_install() {
	cmake_src_install
	cat <<EOF > "${T}/99${PN}${SLOT_MAJ}"
CPATH="${EPREFIX}/usr/include/embree${SLOT_MAJ}"
PATH="${EPREFIX}/usr/bin/embree${SLOT_MAJ}"
EOF
	doenvd "${T}/99${PN}${SLOT_MAJ}"
	docinto docs
	if use doc ; then
		einstalldocs
		doman man/man3/*
	fi
	use doc-docfiles && dodoc -r doc/doc
	use doc-images && dodoc -r doc/images
	use doc-man && dodoc -r doc/man/man3
	use doc-html && dodoc -r doc/www
	if use tutorials ; then
		insinto /usr/share/${PN}/tutorials
		doins -r tutorials/*
	fi
	docinto licenses
	dodoc LICENSE.txt third-party-programs-TBB.txt \
		third-party-programs.txt
	if ! use tbb ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
	uopts_src_install
}

pkg_postinst() {
	if use tutorials ; then
einfo
einfo "The tutorial sources have been installed at /usr/share/${PN}/tutorials"
einfo
	fi
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb, pgo, test
# OILEDMACHINE-OVERLAY-META-TAGS:  profile-guided-optimization
