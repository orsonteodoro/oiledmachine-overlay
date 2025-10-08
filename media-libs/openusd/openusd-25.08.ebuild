# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# For dependencies, see
# https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.08/VERSIONS.md
# https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.08/build_scripts/build_usd.py#L2019
# https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.08/build_scripts/build_usd.py#L763

BOOST_PV="1.80.0"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO ID MC OOB OOBA UAF"
CMAKE_BUILD_TYPE="Release"
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)
ONETBB_SLOT="0"
OPENEXR_V3_PV=(
	# openexr:imath
	#"3.4.0:9999"
	"3.3.5:3.1.12"
	"3.3.4:3.1.12"
	"3.3.3:3.1.12"
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
	"3.2.0:3.1.9"
	"3.1.13:3.1.9"
)
PYTHON_COMPAT=( "python3_"{9..13} )
VULKAN_PV="1.3.296.0"

inherit cflags-hardened check-compiler-switch cmake libstdcxx-slot python-single-r1 flag-o-matic

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/OpenUSD-${PV}"
SRC_URI="
https://github.com/PixarAnimationStudios/OpenUSD/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Universal Scene Description is a system for 3D scene interexchange between apps"
HOMEPAGE="http://www.openusd.org"
LICENSE="
	(
		Apache-2.0
		custom
	)
	(
		all-rights-reserved
		MIT
	)
	(
		public-domain
		Unlicense
	)
	Apache-2.0
	BSD
	BSD-2
	custom
	JSON
	MIT
	OpenUSD-23.11
"
# custom - https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.08/pxr/usdImaging/usdImaging/drawModeStandin.cpp#L9
# custom - search "In consideration of your agreement"
# MIT - the distro MIT license template does not have all rights reserved.
SLOT="0"
# test USE flag is enabled upstream
IUSE+="
-alembic -doc +draco -embree +examples -experimental +hdf5 +imaging +jemalloc
-materialx -monolithic -opencolorio +opengl -openimageio -openvdb openexr -osl
-ptex +python +safety-over-speed -static-libs +tutorials -test +tools +usdview
-vulkan
ebuild_revision_5
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	alembic? (
		openexr
	)
	embree? (
		imaging
	)
	hdf5? (
		alembic
	)
	opencolorio? (
		imaging
	)
	opengl? (
		imaging
	)
	openimageio? (
		imaging
	)
	openvdb? (
		imaging
		openexr
	)
	osl? (
		openexr
	)
	ptex? (
		imaging
	)
	test? (
		python
	)
	usdview? (
		opengl
		python
	)
"

gen_openexr_pairs() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}[${LIBSTDCXX_USEDEP}]
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}[${LIBSTDCXX_USEDEP}]
				dev-libs/imath:=
			)
		"
	done
}

# TODO experimental
RDEPEND+="
	>=sys-libs/zlib-1.2.11
	>=dev-cpp/tbb-2021:${ONETBB_SLOT}[${LIBSTDCXX_USEDEP}]
	dev-cpp/tbb:=
	!python? (
		>=dev-libs/boost-${BOOST_PV}[${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
	)
	alembic? (
		>=media-gfx/alembic-1.8.5[${LIBSTDCXX_USEDEP},hdf5?]
		media-gfx/alembic:=
	)
	draco? (
		>=media-libs/draco-1.4.3
	)
	embree? (
		>=media-libs/embree-3.2.2
	)
	hdf5? (
		>=sci-libs/hdf5-1.10[cxx,hl]
	)
	imaging? (
		>=media-libs/opensubdiv-3.6.0[${LIBSTDCXX_USEDEP}]
		media-libs/opensubdiv:=
		x11-libs/libX11
	)
	jemalloc? (
		dev-libs/jemalloc-usd[${LIBSTDCXX_USEDEP}]
		dev-libs/jemalloc-usd:=
	)
	materialx? (
		>=media-libs/materialx-1.39.3[${LIBSTDCXX_USEDEP}]
		media-libs/materialx:=
	)
	opencolorio? (
		>=media-libs/opencolorio-2.2.1[${LIBSTDCXX_USEDEP}]
		media-libs/opencolorio:=
	)
	openexr? (
		|| (
			$(gen_openexr_pairs)
		)
	)
	opengl? (
		>=media-libs/glew-2.0.0
	)
	openimageio? (
		>=media-libs/libpng-1.6.29
		>=media-libs/openimageio-2.5.16.0[${LIBSTDCXX_USEDEP}]
		media-libs/openimageio:=
		>=media-libs/tiff-4.0.7
		virtual/jpeg
	)
	openvdb? (
		>=dev-libs/c-blosc-1.17
		>=media-gfx/openvdb-10.1.0[${LIBSTDCXX_USEDEP}]
		media-gfx/openvdb:=
	)
	osl? (
		>=media-libs/osl-1.13.11
	)
	ptex? (
		>=media-libs/ptex-2.4.2[${LIBSTDCXX_USEDEP}]
		media-libs/ptex:=
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-'"${BOOST_PV}"'[${PYTHON_USEDEP},python]
			usdview? (
				(
					>=dev-python/pyside2-5.15.2.1[${PYTHON_USEDEP},quickcontrols2(+),script,scripttools]
					dev-qt/qtquickcontrols2:5
				)
				dev-python/pyside2-tools[${PYTHON_USEDEP},tools(+)]
				dev-python/shiboken2[${PYTHON_USEDEP}]
				opengl? (
					>=dev-python/pyopengl-3.1.5[${PYTHON_USEDEP}]
				)
			)
		')
		>=dev-libs/boost-${BOOST_PV}[${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
	)
        vulkan? (
		>=dev-util/vulkan-headers-${VULKAN_PV}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-3.26.5
	>=sys-devel/bison-2.4.1
	>=sys-devel/flex-2.5.39
	dev-cpp/argparse
	dev-util/patchelf
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.9.6[dot]
	)
	|| (
		>=sys-devel/gcc-11
		>=llvm-core/clang-16
	)
"
PATCHES=(
	"${FILESDIR}/algorithm.patch"
	"${FILESDIR}/openusd-21.11-gcc-11-numeric_limits.patch"
#	"${FILESDIR}/openusd-21.11-glibc-2.34.patch"
#	"${FILESDIR}/openusd-21.11-clang-14-compat.patch"
	"${FILESDIR}/openusd-21.11-use-whole-archive-for-lld.patch"
	"${FILESDIR}/openusd-25.08-replace-fix.patch"
)
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

gen_pyside2_uic_file() {
cat > pyside2-uic <<'EOF'
#!${EPREFIX}/bin/bash
uic -g python "$@"
EOF
}

src_prepare() {
	# Fix for #2351
	sed -i 's|CMAKE_CXX_STANDARD 14|CMAKE_CXX_STANDARD 17|g' \
		cmake/defaults/CXXDefaults.cmake || die

	cmake_src_prepare
	# make dummy pyside-uid
	if use usdview ; then
		gen_pyside2_uic_file
		chmod +x pyside2-uic
	fi
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	if has_version "media-libs/openusd" ; then
ewarn "Uninstall ${PN} to avoid build failure."
		die
	fi

	export USD_PATH="/usr/$(get_libdir)/${PN}"
	if use draco; then
		append-cppflags \
			-DDRACO_ATTRIBUTE_INDICES_DEDUPLICATION_SUPPORTED=ON \
			-DDRACO_ATTRIBUTE_VALUES_DEDUPLICATION_SUPPORTED=ON \
			-DTBB_SUPPRESS_DEPRECATED_MESSAGES=1
	fi
        # See https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.08/cmake/defaults/Options.cmake
	local mycmakeargs+=(
		$(usex jemalloc "-DPXR_MALLOC_LIBRARY=${ESYSROOT}/usr/$(get_libdir)/${PN}/$(get_libdir)/libjemalloc.so" "")
		$(usex usdview "-DPYSIDEUICBINARY:PATH=${S}/pyside2-uic" "")
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_CXX_STANDARD=17
#		-DCMAKE_DEBUG_POSTFIX=_d
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${USD_PATH}"
		-DPXR_BUILD_ALEMBIC_PLUGIN=$(usex alembic ON OFF)
		-DPXR_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DPXR_BUILD_DRACO_PLUGIN=$(usex draco ON OFF)
		-DPXR_BUILD_EMBREE_PLUGIN=$(usex embree ON OFF)
		-DPXR_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DPXR_BUILD_IMAGING=$(usex imaging ON OFF)
		-DPXR_BUILD_MONOLITHIC=$(usex monolithic ON OFF)
		-DPXR_BUILD_OPENCOLORIO_PLUGIN=$(usex opencolorio ON OFF)
		-DPXR_BUILD_OPENIMAGEIO_PLUGIN=$(usex openimageio ON OFF)
		-DPXR_BUILD_PRMAN_PLUGIN=OFF
		-DPXR_BUILD_TESTS=$(usex test ON OFF)
		-DPXR_BUILD_TUTORIALS=$(usex tutorials ON OFF)
		-DPXR_BUILD_USD_IMAGING=$(usex imaging ON OFF)
		-DPXR_BUILD_USD_TOOLS=$(usex tools ON OFF)
		-DPXR_BUILD_USDVIEW=$(usex usdview ON OFF)
		-DPXR_ENABLE_GL_SUPPORT=$(usex opengl ON OFF)
		-DPXR_ENABLE_HDF5_SUPPORT=$(usex hdf5 ON OFF)
		-DPXR_ENABLE_MATERIALX_SUPPORT=$(usex materialx)
		-DPXR_ENABLE_OPENVDB_SUPPORT=$(usex openvdb ON OFF)
		-DPXR_ENABLE_OSL_SUPPORT=$(usex osl ON OFF)
		-DPXR_ENABLE_PTEX_SUPPORT=$(usex ptex ON OFF)
		-DPXR_ENABLE_PYTHON_SUPPORT=$(usex python ON OFF)
		-DPXR_ENABLE_VULKAN_SUPPORT=$(usex vulkan ON OFF)
		-DPXR_INSTALL_LOCATION="${EPREFIX}${USD_PATH}"
		-DPXR_PREFER_SAFETY_OVER_SPEED=$(usex safety-over-speed ON OFF)
		-DPXR_PYTHON_SHEBANG="${PYTHON}"
		-DPXR_SET_INTERNAL_NAMESPACE="usdBlender"
		-DPXR_USE_PYTHON_3=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use usdview && dosym "${USD_PATH}/bin/usdview" /usr/bin/usdview
	dosym "${USD_PATH}"/include/pxr /usr/include/pxr
	echo "${USD_PATH}"/lib >> 99-${PN}.conf || die
	insinto /etc/ld.so.conf.d/
	doins 99-${PN}.conf
	local f
	for f in $(find "${ED}${USD_PATH}/lib" -name "*.so*") ; do
einfo "Removing rpath from ${f}"
		patchelf --remove-rpath "${f}" || die # triggers warning
	done
	export STRIP="${BROOT}/bin/true" # strip breaks rpath
	if use jemalloc ; then
		for f in $(find "${ED}${USD_PATH}" -executable) ; do
			if ldd "${f}" 2>/dev/null | grep -q -e "libjemalloc.so.2" ; then
einfo "Changing rpath for ${f} to use jemalloc-usd"
				local old_rpath=$(patchelf --print-rpath "${f}")
				if [[ -n "${old_rpath}" ]] ; then
					old_rpath=":${old_rpath}"
				fi
				patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/openusd/$(get_libdir)${old_rpath}" "${f}" || die
			fi
		done

		if [[ -d "${ED}/usr/$(get_libdir)/${PN}/bin" ]] ; then
			mv "${ED}/usr/$(get_libdir)/${PN}/"{bin,.bin} || die
		fi

		local UTILS_LIST=(
			sdffilter
			testusdview
			usdGenSchema
			usdcat
			usdchecker
			usdcompress
			usddiff
			usddumpcrate
			usdedit
			usdrecord
			usdresolve
			usdstitch
			usdstitchclips
			usdtree
			usdview
			usdzip
		)

		# Setting LD_PRELOAD for jemalloc is still required or you may get a segfault
		exeinto /usr/lib64/openusd/bin
		local u
		for u in ${UTILS_LIST[@]} ; do
			if [[ -e "${ED}/usr/$(get_libdir)/${PN}/.bin/${u}" ]] ; then
einfo "Creating wrapper for ${u}"
cat << EOF > "${T}/${u}"
#!${EPREFIX}/bin/bash
LD_PRELOAD="${EPREFIX}/usr/$(get_libdir)/openusd/$(get_libdir)/libjemalloc.so" "${EPREFIX}/usr/$(get_libdir)/${PN}/.bin/${u}" "\$@"
EOF
				doexe "${T}/${u}"
			fi
		done


	fi
	if use python ; then
		dodir /usr/lib/${EPYTHON}
		mv "${ED}/usr/lib64/openusd/lib/python/pxr" \
			"${ED}/usr/lib/${EPYTHON}" || die
	fi
	use doc && einstalldocs
	dodoc "LICENSE.txt" "NOTICE.txt"
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-jemalloc-usd, link-to-multislot-tbb
