# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PV1="$(ver_cut 1)"
PV2="$(ver_cut 2)"
MY_PV="${PV1}_U${PV2}"
SLOT_MAJOR="2" # Same as SONAME_SUFFIX, See https://github.com/oneapi-src/oneTBB/blob/2019_U7/include/tbb/tbb_stddef.h#L30
SOVER_MINOR="."$(ver_cut 2 ${PV}) # The distro messes up on this component.
SOVER_TBB="2" # See https://github.com/oneapi-src/oneTBB/blob/2019_U7/build/linux.inc#L114
SOVER_TBBMALLOC="2" # See https://github.com/oneapi-src/oneTBB/blob/2019_U7/build/linux.inc#L126
SOVER_TBBBIND="2" # See https://github.com/oneapi-src/oneTBB/blob/2019_U7/build/linux.inc#L119

inherit flag-o-matic multilib-minimal multilib toolchain-funcs

# Ebuild provided for testing compatibility only.  For production use latest.
#KEYWORDS="~amd64"
S="${WORKDIR}/oneTBB-${MY_PV}"
SRC_URI="
https://github.com/intel/${PN}/archive/${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Threading Building Blocks (TBB)"
HOMEPAGE="https://www.threadingbuildingblocks.org"
LICENSE="Apache-2.0"
RESTRICT="mirror"
SLOT="${SLOT_MAJOR}/${SOVER_TBB}-${SOVER_TBBMALLOC}-${SOVER_TBBBIND}"
IUSE+=" debug examples numa rml ebuild_revision_8"
DEPEND+="
	!<dev-cpp/tbb-2021:0
"
RDEPEND+="
	${DEPEND}
	numa? (
		sys-apps/hwloc:=
	)
"
BDEPEND+="
	dev-build/cmake
	dev-util/patchelf
"
DOCS=( "CHANGES" "README" "README.md" "doc/Release_Notes.txt" )
PATCHES=(
	"${FILESDIR}/${PN}-2019.7-makefile-debug.patch"
	"${FILESDIR}/${PN}-2019.7-fix-cmake-config.patch"
)

src_prepare() {
	default

	find include -name \*.html -delete || die

	# Give it a soname on FreeBSD
	echo 'LIB_LINK_FLAGS += -Wl,-soname=$(BUILDING_LIBRARY)' \
		>> build/FreeBSD.gcc.inc

	# Set proper versionning on FreeBSD
	sed -i -e '/.DLL =/s/$/.1/' build/FreeBSD.inc || die

	use debug || sed -i -e '/_debug/d' Makefile
}

multilib_src_configure() {
	# The pc files are for debian and fedora compatibility.
	# Some dependencies use them.

cat <<-EOF > ${PN}.pc.template
prefix=${EPREFIX}/usr
libdir=\${prefix}/$(get_libdir)/${PN}/${SLOT_MAJOR}
includedir=\${prefix}/include/${PN}/${SLOT_MAJOR}
Name: ${PN}
Description: ${DESCRIPTION}
Version: ${PV}
URL: ${HOMEPAGE}
Cflags: -I\${includedir}
EOF

	cp ${PN}.pc.template ${PN}-${SLOT_MAJOR}.pc || die

cat <<-EOF >> ${PN}-${SLOT_MAJOR}.pc
Libs: -L\${libdir} -ltbb
Libs.private: -lm -lrt
EOF
	cp ${PN}.pc.template ${PN}malloc-${SLOT_MAJOR}.pc || die

cat <<-EOF >> ${PN}malloc-${SLOT_MAJOR}.pc
Libs: -L\${libdir} -ltbbmalloc
Libs.private: -lm -lrt
EOF

	cp ${PN}.pc.template ${PN}malloc_proxy-${SLOT_MAJOR}.pc || die

cat <<-EOF >> ${PN}malloc_proxy-${SLOT_MAJOR}.pc
Libs: -L\${libdir} -ltbbmalloc_proxy
Libs.private: -lrt
Requires: tbbmalloc
EOF

}

local_src_compile() {
	cd "${S}"

	local comp arch
	local bt buildtypes=()

	case ${MULTILIB_ABI_FLAG} in
		abi_x86_64) arch=x86_64 ;;
		abi_x86_32) arch=ia32 ;;
#		abi_ppc_64) arch=ppc64 ;;
#		abi_ppc_32) arch=ppc32 ;;
	esac

	case "$(tc-getCXX)" in
		*clang*) comp="clang" ;;
		*g++*) comp="gcc" ;;
		*ic*c) comp="icc" ;;
		*) die "compiler $(tc-getCXX) not supported by build system" ;;
	esac

	if use debug ; then
		buildtypes=( "release" "debug" )
	else
		buildtypes=( "release" )
	fi

	for bt in ${buildtypes[@]}; do
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		AS="$(tc-getAS)" \
		arch=${arch} \
		CPLUS_FLAGS="${CXXFLAGS}" \
		emake \
			compiler=${comp} \
			work_dir="${BUILD_DIR}" \
			tbb_root="${S}" \
			cfg=${bt} \
			$@
	done
}

multilib_src_compile() {
	local targets=(
		"tbb"
		"tbbmalloc"
		"tbbproxy"
	)
	use numa && targets+=( "tbbbind" )
	use rml && targets+=( "rml" )
	local_src_compile ${targets[@]}
}

multilib_src_test() {
	local_src_compile test
}

multilib_src_install() {
	local bt
	local buildtypes=()
	if use debug ; then
		buildtypes=( "release" "debug" )
	else
		buildtypes=( "release" )
	fi
	exeinto /usr/$(get_libdir)/${PN}/${SLOT_MAJOR}
	for bt in ${buildtypes[@]}; do
		cd "${BUILD_DIR}_${bt}" || die
		local l
		for l in $(find . -name lib\*$(get_libname \*)); do
			doexe "${l}"
			local bl=$(basename ${l})
			dosym \
				"${bl}" \
				"/usr/$(get_libdir)/${PN}/${SLOT_MAJOR}/${bl%%.*}$(get_libname)"
		done
	done

	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins *.pc

	pushd "${S}" >/dev/null 2>&1 || die
		insinto "/usr/include/${PN}/${SLOT_MAJOR}"
		doins -r "include/"*

		export LIBDIR=$(get_libdir)
		cmake -DTBB_ROOT="${ED}/usr" -DTBB_OS="Linux" -P "cmake/tbb_config_generator.cmake" || die
	popd >/dev/null 2>&1 || die
}

# Fix for
# ldd /usr/lib64/tbb/2/libtbbmalloc_proxy.so.2
#	libtbbmalloc.so.2 => /usr/lib64/libtbbmalloc.so.2 (0x00007f423f1a7000)
fix_rpath() {
	local x
	for x in $(find "${ED}" -name "*.so*") ; do
		[[ -L "${x}" ]] && continue
einfo "Fixing RPATH for ${x}"
		patchelf --set-rpath '$ORIGIN' "${x}" || die
	done
}

multilib_src_install_all() {
	einstalldocs

	if use examples ; then
		insinto "/usr/share/doc/${PF}/examples/build"
		doins "build/"*".inc"
		insinto "/usr/share/doc/${PF}/examples"
		doins -r "examples"
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	fix_rpath
}

pkg_postinst()
{
einfo
einfo "Packages that depend on ${CATEGORY}/${PN}:${SLOT_MAJOR} must"
einfo "either set the RPATH or add a LD_LIBRARY_PATH wrapper to use"
einfo "this slot.  You must verify that the linking is proper via ldd."
einfo
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot
