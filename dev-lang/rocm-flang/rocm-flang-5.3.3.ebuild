# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_MAX_SLOT=15 # Same as llvm-roc
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic llvm python-any-r1 rocm toolchain-funcs

SRC_URI="
https://github.com/ROCm-Developer-Tools/flang/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"
DESCRIPTION="ROCm's fork of Classic Flang."
HOMEPAGE="https://github.com/flang-compiler/flang"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		Apache-2.0
		CC0-1.0
	)
	(
		Apache-2.0-with-LLVM-exceptions
		BSD
		MIT
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		MIT
		UoI-NCSA
	)
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	(
		BSD
		ZLIB
	)
	Apache-2.0
	BSD
	ISC
	MIT
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	Apache-2.0-with-LLVM-exceptions
"
# all-rights-reserved, Apache-2.0 - flang-rocm-5.6.0/runtime/libpgmath/LICENSE.txt
# The Apache-2.0 license template does not have all rights reserved in the distro
# template but all rights reserved is explicit in Apache-1.0 and BSD licenses.
# Apache-2.0 - llvm-project-rocm-5.6.0/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - llvm-project-rocm-5.6.0/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - llvm-project-rocm-5.6.0/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
# BSD - llvm-project-rocm-5.6.0/third-party/unittest/googlemock/LICENSE.txt
# BSD - llvm-project-rocm-5.6.0/openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# CC0-1.0, Apache-2.0 - llvm-project-rocm-5.6.0/llvm/lib/Support/BLAKE3/LICENSE
# ISC - llvm-project-rocm-5.6.0/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm-project-rocm-5.6.0/polly/lib/External/isl/LICENSE
# ZLIB, BSD - llvm-project-rocm-5.6.0/llvm/lib/Support/COPYRIGHT.regex
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
aocc cuda doc offload test
"
REQUIRED_USE="
"
RDEPEND="
	sys-devel/gcc
	~sys-devel/llvm-roc-${PV}:${SLOT}
	~sys-libs/llvm-roc-libomp-${PV}:${SLOT}[offload?]
	aocc? (
		sys-devel/aocc
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.9.0
	doc? (
		app-doc/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
S="${WORKDIR}/flang-rocm-${PV}"
PATCHES=(
)

build_libpgmath() {
einfo "Building libpgmath"
	cd "${S}/runtime/libpgmath" || die
	mkdir -p build || die
	cd build || die
	ccmake \
		${mycmakeargs[@]} \
		..
	emake
	emake install
}

ccmake() {
einfo "Running:  cmake ${@}"
	cmake "${@}" || die
}

build_flang() {
einfo "Building flang"
	cd "${S}" || die
	mkdir -p build || die
	cd build || die
	local mycmakeargs_=(
		${mycmakeargs[@]}
		-DFLANG_LLVM_EXTENSIONS=ON
		-DFLANG_INCLUDE_DOCS=$(usex doc ON oFF)
		-DLIBQUADMATH_LOC="${ESYSROOT}/usr/lib/gcc/${CHOST}/$(gcc-major-version)"
		-DLLVM_ENABLE_DOXYGEN=$(usex doc ON oFF)
	)
einfo "GCC major version:  $(gcc-major-version)"
	append-flags -I"${ESYSROOT}/usr/lib/gcc/${CHOST}/$(gcc-major-version)/include"
	append-ldflags -L"${ESYSROOT}/usr/lib/gcc/${CHOST}/$(gcc-major-version)" -lquadmath
	filter-flags -Wl,--as-needed
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs_+=(
			-DFLANG_OPENMP_GPU_AMD=$(usex aocc ON OFF)
			-DFLANG_OPENMP_GPU_NVIDIA=$(usex cuda ON OFF)
		)
	else
		mycmakeargs_+=(
			-DFLANG_OPENMP_GPU_AMD=OFF
			-DFLANG_OPENMP_GPU_NVIDIA=OFF
		)
	fi
	ccmake \
		${mycmakeargs_[@]} \
		..
	emake
	emake install
}

pkg_setup() {
	llvm_pkg_setup
	python_setup
}

src_prepare() {
	cmake_src_prepare
	# Removed in >= 16.0.0-rc1
	sed -i -e "s|\"--src-root\"||g" \
		"${S}/CMakeLists.txt" \
		|| die
	if ! use offload ; then
		sed -i -e "s|-g -DOMP_OFFLOAD_LLVM|-g|g" \
			"CMakeLists.txt" \
			|| die
	fi
}

src_configure() {
	# Removed all clangs from path except for this vendored one.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${PWD}/install/bin:${ESYSROOT}/opt/rocm-${PV}/llvm/bin|g")
	einfo "PATH=${PATH} (after)"
}

src_compile() {
	local staging_prefix="${PWD}/install"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_C_COMPILER="${ESYSROOT}/opt/rocm-${PV}/llvm/bin/clang"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}/opt/rocm-${PV}/llvm/bin/clang++"
		-DCMAKE_Fortran_COMPILER="${staging_prefix}/bin/flang"
		-DCMAKE_Fortran_COMPILER_ID="Flang"
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}"
	)
	export VERBOSE=1
	build_libpgmath
	build_flang
}

hello_world_test() {
	local staging_prefix="${PWD}/install"
cat <<EOF > "${T}/hello.f90" || die
program hello
  print *, "hello world"
end program
EOF
	"${staging_prefix}/bin/flang" \
		"${T}/hello.f90" \
		-o "${T}/hello.exe" \
		|| die
	"${T}/hello.exe" || die
}

src_test() {
	hello_world_test
}

fix_file_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ \.sh$ ]] ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	local staging_prefix="${PWD}/install"
	local dest="/usr/lib/rocm-flang"
	insinto "${dest}"
	doins -r "${staging_prefix}/"*
	fix_file_permissions
	dosym \
		/usr/lib/rocm-flang/bin/flang \
		/usr/bin/rocm-flang
}

pkg_postinst() {
einfo "Switching ${EROOT}/usr/bin/rocm-flang -> ${EROOT}/usr/bin/flang"
	ln -sf \
		"${EROOT}/usr/bin/rocm-flang" \
		"${EROOT}/usr/bin/flang"
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
