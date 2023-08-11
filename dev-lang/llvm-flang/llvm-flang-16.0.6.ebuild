# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm.org python-any-r1

DESCRIPTION="LLVM Flang is a continuation of F18 to replace Classic Flang"
HOMEPAGE="
https://github.com/llvm/llvm-project/tree/main/flang
"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
"
KEYWORDS="~amd64"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="
offload test
"
REQUIRED_USE="
"
RDEPEND="
	>=sys-libs/openmp-${LLVM_MAJOR}[offload?]
	sys-devel/clang:${LLVM_MAJOR}
	sys-devel/llvm:${LLVM_MAJOR}
	sys-devel/mlir:${LLVM_MAJOR}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
	)
"
RESTRICT="
	test
"
PATCHES=(
)
LLVM_COMPONENTS=(
	"flang"
	"cmake"
)
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals

src_configure() {
	local user_choice=$(echo "${MAKEOPTS}" \
		| grep -E -e "-j[ ]*[0-9]+" \
		| grep -E -o "[0-9]+")
	local half_ncpus=$(python -c "print(int($(nproc)/2))")
	(( ${half_ncpus} == 0 )) && half_ncpus=1
	if [[ "${user_choice}" != "1" ]] ; then
		MAKEOPTS="-j${half_ncpus}" # Heavy swap
	fi
	local mycmakeargs=(
		-DCLANG_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/clang"
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_CXX_STANDARD=17
		-DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,${LD_LIBRARY_PATH}"
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm-flang/${LLVM_MAJOR}"
		-DFLANG_ENABLE_WERROR=ON
		-DFLANG_INCLUDE_TESTS=OFF
		-DLLVM_BUILD_MAIN_SRC_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/llvm"
		-DLLVM_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/llvm"
		-DLLVM_ENABLE_ASSERTIONS=ON
		-DLLVM_TARGETS_TO_BUILD="host"
		-DMLIR_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/mlir"
	)
	if use test ; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${ESYSROOT}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-v"
		)
	fi
	cmake_src_configure
}

pkg_postinst() {
einfo "Switching /usr/lib/llvm-flang/${LLVM_MAJOR}/bin/flang-new -> /usr/bin/flang"
	ln -sf \
		"${EROOT}/usr/lib/llvm-flang/${LLVM_MAJOR}/bin/flang-new" \
		"${EROOT}/usr/bin/flang" \
		|| die
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
