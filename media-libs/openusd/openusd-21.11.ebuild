# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake python-single-r1 flag-o-matic

DESCRIPTION="Universal Scene Description"
HOMEPAGE="http://www.openusd.org"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
# test USE flag is enabled upstream
IUSE+=" -alembic -doc +draco -embree +examples -experimental +hdf5 +imaging
+jemalloc -monolithic -opencolorio +opengl -openimageio -openvdb openexr -osl
+ptex +python +safety-over-speed -static-libs +tutorials -test +tools +usdview
-vulkan"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	embree? ( imaging )
	hdf5? ( alembic )
	opencolorio? ( imaging )
	opengl? ( imaging )
	openimageio? ( imaging openexr )
	openvdb? ( imaging openexr )
	ptex? ( imaging )
	test? ( python )
	usdview? ( python opengl )"
# For dependencies, see https://github.com/PixarAnimationStudios/USD/blob/v21.11/VERSIONS.md
# https://github.com/PixarAnimationStudios/USD/blob/v21.11/build_scripts/build_usd.py#L2019
# TBB 2021 not ready yet.  tbb::task, tbb::empty_task references are the major hurdles
RDEPEND+="
	experimental? (
		>=dev-cpp/tbb-2021:12=
	)
	!experimental? (
		<dev-cpp/tbb-2021:0=
		>=dev-cpp/tbb-2018.6:0=
	)
	>=sys-libs/zlib-1.2.11
	draco? ( >=media-libs/draco-1.4.3 )
	alembic? ( >=media-gfx/alembic-1.7.10[hdf5?] )
	embree? ( >=media-libs/embree-3.2.2 )
	hdf5? ( >=sci-libs/hdf5-1.10[cxx,hl] )
	imaging? (
		>=media-libs/opensubdiv-3.4.3
		x11-libs/libX11
	)
	jemalloc? ( dev-libs/jemalloc-usd )
	opencolorio? ( >=media-libs/opencolorio-1.0.9 )
	openexr? ( >=media-libs/openexr-2.3.0 )
	opengl? ( >=media-libs/glew-2.0.0 )
	openimageio? (
		>=media-libs/libpng-1.6.29
		>=media-libs/openimageio-2.1.16.0:=
		>=media-libs/tiff-4.0.7
		virtual/jpeg
	)
	openvdb? (
		>=dev-libs/c-blosc-1.17
		>=media-gfx/openvdb-6.1.0
	)
	osl? ( >=media-libs/osl-1.8.12 )
	ptex? ( >=media-libs/ptex-2.1.33 )
	!python? (
		>=dev-libs/boost-1.70.0
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.70.0:=[python,${PYTHON_MULTI_USEDEP}]
			usdview? (
				(
					(
						dev-qt/qtquickcontrols2:5
						>=dev-python/pyside2-2.0.0[${PYTHON_MULTI_USEDEP},quickcontrols2(+),script,scripttools]
					)
					dev-python/shiboken2[${PYTHON_MULTI_USEDEP}]
				)
				dev-python/pyside2-tools[tools(+),${PYTHON_MULTI_USEDEP}]
				opengl? ( >=dev-python/pyopengl-3.1.5[${PYTHON_MULTI_USEDEP}] )
			)
		')
	)
        vulkan? ( >=dev-util/vulkan-headers-1.2.135.0 )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	$(python_gen_cond_dep '>=dev-python/jinja-2[${PYTHON_MULTI_USEDEP}]')
	dev-cpp/argparse
	>=dev-util/cmake-3.14.6
	dev-util/patchelf
	>=sys-devel/bison-2.4.1
	|| (
		(
			>=sys-devel/gcc-6.3.1
			<sys-devel/gcc-11
		)
		<sys-devel/clang-12
	)
	>=sys-devel/flex-2.5.39
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.8.14[dot] )"
SRC_URI="
https://github.com/PixarAnimationStudios/USD/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
PATCHES=(
	"${FILESDIR}/algorithm.patch"
	"${FILESDIR}/openusd-21.11-gcc-11-size_t.patch"
	"${FILESDIR}/openusd-21.11-gcc-11-numeric_limits.patch"
)
S="${WORKDIR}/USD-${PV}"
DOCS=( CHANGELOG.md README.md )
ONETBB_SLOT="12"
FORCE_LEGACY_TBB=0

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if use experimental ; then
		if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
			ewarn "Using oneTBB.  Support is experimental, incomplete, and in-development."
			eapply "${FILESDIR}/tbb.patch"
			eapply "${FILESDIR}/atomic-tbb.patch"
			eapply "${FILESDIR}/onetbb-compat.patch"
		else
			einfo "Using legacy TBB"
		fi
	else
		einfo "Using legacy TBB"
	fi
	cmake_src_prepare
	# make dummy pyside-uid
	if use usdview ; then
		cat > pyside2-uic <<'EOF'
#!/bin/bash
uic -g python "$@"
EOF
		chmod +x pyside2-uic
	fi
}

src_configure() {
	if use experimental ; then
		if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
			append-cppflags -DTBB_ALLOCATOR_TRAITS_BROKEN
		fi
	fi

	export USD_PATH="/usr/$(get_libdir)/${PN}"
	if use draco; then
		append-cppflags -DDRACO_ATTRIBUTE_VALUES_DEDUPLICATION_SUPPORTED=ON \
			-DDRACO_ATTRIBUTE_INDICES_DEDUPLICATION_SUPPORTED=ON \
			-DTBB_SUPPRESS_DEPRECATED_MESSAGES=1
	fi
        # See https://github.com/PixarAnimationStudios/USD/blob/v21.05/cmake/defaults/Options.cmake
	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
#		-DCMAKE_DEBUG_POSTFIX=_d
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${USD_PATH}"
		-DPXR_BUILD_ALEMBIC_PLUGIN=$(usex alembic ON OFF)
		-DPXR_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DPXR_BUILD_DRACO_PLUGIN=$(usex draco ON OFF)
		-DPXR_BUILD_EMBREE_PLUGIN=$(usex embree ON OFF)
		-DPXR_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DPXR_BUILD_IMAGING=$(usex imaging ON OFF)
		-DPXR_BUILD_MATERIALX_PLUGIN=OFF
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
	if use usdview ; then
		mycmakeargs+=(
			-DPYSIDEUICBINARY:PATH="${S}/pyside2-uic"
		)
	fi
	if use jemalloc ; then
		mycmakeargs+=(
			-DPXR_MALLOC_LIBRARY="${EPREFIX}/usr/$(get_libdir)/${PN}/$(get_libdir)/libjemalloc.so"
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use usdview && dosym "${USD_PATH}/bin/usdview" /usr/bin/usdview
	dosym "${USD_PATH}"/include/pxr /usr/include/pxr
	echo "${USD_PATH}"/lib >> 99-${PN}.conf || die
	insinto /etc/ld.so.conf.d/
	doins 99-${PN}.conf
	for f in $(find "${ED}${USD_PATH}/lib" -name "*.so*") ; do
		einfo "Removing rpath from ${f}"
		 patchelf --remove-rpath "${f}" || die # triggers warning
	done
	if use jemalloc ; then
		for f in $(find "${ED}${USD_PATH}" -executable) ; do
			if ldd "${f}" 2>/dev/null | grep -q -e "libjemalloc.so.2" ; then
				einfo "Changing rpath for ${f} to use jemalloc-usd"
				local old_rpath=$(patchelf --print-rpath "${f}")
				if [[ -n "${old_rpath}" ]] ; then
					old_rpath=":${old_rpath}"
				fi
				patchelf --set-rpath "/usr/$(get_libdir)/openusd/$(get_libdir)${old_rpath}" "${f}" || die
			fi
		done

		mv "${ED}/usr/$(get_libdir)/${PN}/"{bin,.bin} || die

		UTILS_LIST=(
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
		for u in ${UTILS_LIST[@]} ; do
			einfo "Creating wrapper for ${u}"
			cat << EOF > "${T}/${u}"
#!/bin/bash
LD_PRELOAD="/usr/$(get_libdir)/openusd/$(get_libdir)/libjemalloc.so" /usr/$(get_libdir)/${PN}/.bin/${u} "\$@"
EOF
			doexe "${T}/${u}"
		done


	fi
	if use python ; then
		dodir /usr/lib/${EPYTHON}
		mv "${ED}/usr/lib64/openusd/lib/python/pxr" \
			"${ED}/usr/lib/${EPYTHON}" || die
	fi
	use doc && einstalldocs
	dodoc LICENSE.txt NOTICE.txt
	if use experimental ; then
		if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
			for f in $(find "${ED}") ; do
				test -L "${f}" && continue
				if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
					einfo "Old rpath for ${f}:"
					patchelf --print-rpath "${f}" || die
					einfo "Setting rpath for ${f}"
					patchelf --set-rpath "/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}" \
						"${f}" || die
				fi
			done
		fi
	fi
}
