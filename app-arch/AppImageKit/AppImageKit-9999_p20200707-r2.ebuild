# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# versioning based on src/appimagetoolnoglib.c, tag release, and current commit date
# upstream uses the commit as the version.

# The AppImageKit project currently is just the non Go version of appimagetool.
# AppImageKit is the set of utils and assets used for appimagetool.

EAPI=7
DESCRIPTION="appimagetool -- Generate, extract, and inspect AppImages"
HOMEPAGE="https://github.com/AppImage/AppImageKit"
LICENSE="MIT" # project's default license
LICENSE+=" all-rights-reserved" # src/appimagetool.c ; The vanilla MIT license doesn't have all-rights-reserved
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="additional-tools appstream appimagetool runtime"
RDEPEND="additional-tools? ( dev-libs/openssl )
	app-arch/xz-utils:=[static-libs]
	appimagetool? ( app-arch/go-appimage[-appimagetool] )
	appstream? ( dev-libs/appstream:= )
	dev-libs/libffi:=
	net-misc/zsync2:=
	sys-fs/squashfuse:=
	sys-fs/squashfs-tools:=
	dev-libs/libappimage:=[static-libs]"
DEPEND="${RDEPEND}
	dev-util/sanitizers-cmake
	sys-devel/binutils"
REQUIRED_USE=""
SLOT="0/${PV}"
EGIT_COMMIT="08800854de05f4f6f7c1f3901dc165b8518822e1"
SRC_URI=\
"https://github.com/AppImage/AppImageKit/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror strip"
inherit cmake-utils
PATCHES=(
	"${FILESDIR}/${PN}-9999_p20200707-set-commit.patch"
	"${FILESDIR}/${PN}-9999_p20200707-use-system-libs-and-headers.patch"
	"${FILESDIR}/${PN}-9999_p20200707-extern-appimage_get_elf_size.patch"
)
CMAKE_MAKEFILE_GENERATOR="emake"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
internal dependencies."
	fi
}

_src_prepare_appimagekit() {
	cmake-utils_src_prepare
	sed -i -e "s|\
/usr/lib64/cmake/sanitizers-cmake|\
/usr/$(get_libdir)/cmake/sanitizers-cmake|g" \
		src/CMakeLists.txt || die
}

src_prepare() {
	_src_prepare_appimagekit
}

_src_configure_appimagekit() {
	local mycmakeargs=(
		-DUSE_SYSTEM_MKSQUASHFS=ON
	)
	cmake-utils_src_configure
}


src_configure() {
	_src_configure_appimagekit
}

_src_compile_appimagekit_cmake() {
	cmake-utils_src_compile
	# redirect output
	mkdir -p "${WORKDIR}/install_prefix"
	pushd "${BUILD_DIR}" || die
	emake install DESTDIR="${WORKDIR}/install_prefix"
	popd
}

_src_compile_appdir() {
	local d_out="${WORKDIR}"
	local d="${d_out}/appdirs/appimagetool.AppDir"
	local d_appimagekit="${d}/usr/lib/appimagekit"
	local d_bin="${d}/usr/bin"
	local d_lib="${d}/usr/lib"
	mkdir -p "${d_appimagekit}" || die
	mkdir -p "${d_bin}" || die
	DESTDIR="${d}" "${CMAKE_BINARY}" -DCOMPONENT=appimagetool -P "${BUILD_DIR}/src/cmake_install.cmake" || die
	cp -a resources/AppRun "${d}" || die
	if "${WORKDIR}/install_prefix/usr/lib/appimagekit/mksquashfs" ; then
		cp -a "${WORKDIR}/install_prefix/usr/lib/appimagekit/mksquashfs" \
			"${d_appimagekit}" || die
	else
		cp -a $(which mksquashfs) "${d_appimagekit}" || die
	fi
	PATH="${WORKDIR}/deps/bin:${PATH}" \
	cp -a $(which desktop-file-validate) "${d_bin}" || die
	PATH="${WORKDIR}/deps/bin:${PATH}" \
	cp -a $(which zsyncmake2) "${d_bin}/zsyncmake" || die
	cp -a "${EROOT}/usr/$(get_libdir)/libcpr.so" "${d_lib}" || die
	cp -a "${EROOT}/usr/$(get_libdir)/libzsync.so" "${d_lib}" || die
	if use appstream ; then
		cp -a $(which appstreamcli) "${d_bin}" || die
	fi
	cp -a resources/appimagetool.desktop "${d}" || die
	cp -a resources/appimagetool.png "${d}" || die
	if [[ -d "${WORKDIR}/deps" ]] ; then
		mkdir -p "${d_lib}" || die
		cp -a "${WORKDIR}/deps/lib/"lib*.so* \
			"${ROOT}/usr/$(get_libdir)/libffi.so.6" \
			"${d_lib}" || die
	fi
}

_src_compile_merge() {
	mkdir "${WORKDIR}/out" || die
	cd "${WORKDIR}" || die
	cp -a install_prefix/usr/bin/* out || die
	if ls install_prefix/usr/lib/appimagekit/ 2>/dev/null 1>/dev/null; then
		cp -a install_prefix/usr/lib/appimagekit/* out || die
	fi
	cp -a appdirs/*.AppDir out || die
	cp -a "${BUILD_DIR}/src/runtime" out || die
}

_src_compile_appimagekit_binaries() {
	_src_compile_appimagekit_cmake
	_src_compile_appdir
	_src_compile_merge
}

src_compile_appimagekit() {
	_src_compile_appimagekit_binaries
}

src_compile_appimage() {
	einfo "Running src_compile_appimage"
	cd "${WORKDIR}/out" || die
	# cannot sign because key ($KEY referenced in travis-build.sh) is (implied private and) out of reach
	#local sign_arg="-s"
	local sign_arg=""
	export PATH="${WORKDIR}/out:${PATH}"
	ln -s "${WORKDIR}/out/appimagetool.AppDir/usr/lib" "${WORKDIR}/lib" || die
	./appimagetool.AppDir/AppRun ./appimagetool.AppDir/ ${sign_arg} -v \
	        -u "gh-releases-zsync|AppImage|AppImageKit|continuous|appimagetool-$ARCH.AppImage.zsync" \
	        appimagetool-"$ARCH".AppImage || die
}

src_compile_cleanup() {
	cd "${WORKDIR}" || die
	rm -r out/{appimagetool,*.AppDir} || die
	if ! use additional-tools ; then
		rm -r out/{validate,digest} || die
	fi
	rm -rf out/*.AppDir || die
	if ls out/*.AppImage.digest 2>/dev/null 1>/dev/null ; then
		rm -rf out/*.AppImage.digest || die
	fi
	mv out/runtime out/runtime-${ARCH} || die
	mv out/AppRun out/AppRun-${ARCH} || die
}

src_compile() {
	mkdir -p "${WORKDIR}/build"
	src_compile_appimagekit
	src_compile_appimage
	src_compile_cleanup
}

src_install() {
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	exeinto /usr/bin
	if use appimagetool ; then
		doexe "${WORKDIR}/out/appimagetool-${ABI}.AppImage"
	fi
	# already embedded
	#doexe "${WORKDIR}/out/AppRun-${ABI}"
	if use runtime ; then
		exeinto /usr/$(get_libdir)/${PN}
		# exposed for go-appimage
		doexe "${WORKDIR}/out/runtime-${ABI}"
	fi
	dosym /usr/bin/appimagetool-${ABI}.AppImage /usr/bin/appimagetool
}
