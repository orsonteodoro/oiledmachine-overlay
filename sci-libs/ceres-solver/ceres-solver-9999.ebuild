# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream uses abseil-cpp 20250127
ABSEIL_CPP_SLOT="20260107" # Same as hyprtoolkit
CXX_STANDARD=17
PYTHON_COMPAT=( python3_{10..12} )
DOCS_BUILDER="sphinx"
DOCS_DEPEND="dev-python/sphinx-rtd-theme"
DOCS_DIR="docs/source"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_RUST[@]/llvm_slot_}"
)

inherit abseil-cpp cmake-multilib cuda flag-o-matic libcxx-slot libstdcxx-slot python-any-r1 docs

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="8a566fcc156322160b96f8ca5f0ff755241c2d33"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/ceres-solver/ceres-solver.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="http://ceres-solver.org/${P}.tar.gz"
fi

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="
	http://ceres-solver.org/
	https://github.com/ceres-solver/ceres-solver/
"

LICENSE="sparse? ( BSD ) !sparse? ( LGPL-2.1 )"
SLOT="0/1"
KEYWORDS="amd64 ~x86"
IUSE+="
examples cuda gflags lapack +schur sparse test
ebuild_revision_4
"

REQUIRED_USE="test? ( gflags ) sparse? ( lapack ) abi_x86_32? ( !sparse !lapack )"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.4:=
	lapack? ( virtual/pkgconfig )
	doc? ( <dev-libs/mathjax-3 )
"
RDEPEND="
	>=dev-cpp/abseil-cpp-20260107.1:${ABSEIL_CPP_SLOT}=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/glog:=[gflags?,${MULTILIB_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	lapack? ( virtual/lapack:* )
	sparse? (
		sci-libs/amd:=
		sci-libs/camd:=
		sci-libs/ccolamd:=
		sci-libs/cholmod:=[metis(+)]
		sci-libs/colamd:=
		sci-libs/spqr:=
	)
"
DEPEND="${RDEPEND}"

DOCS=( "README.md" )

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-system-mathjax.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare

	filter-lto

	# search paths work for prefix
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i cmake/*.cmake || die

	# remove Werror
	sed -e 's/-Werror=(all|extra)//g' \
		-i CMakeLists.txt || die

	# Prevent it from installing/colliding as monoslot abseil-cpp in /usr/lib64
	rm -rf "${S}/third_party/abseil-cpp"
}

src_configure() {
	abseil-cpp_src_configure

	local libdir=$(get_libdir)
	if ls "${ESYSROOT}/usr/${libdir}/libabsl"*".so"* >/dev/null 2>&1 ; then
eerror
eerror "Detected vendored libabsl*.so* libraries in ${libdir}."
eerror
eerror "Uninstall ceres-solver and all libs that depend on libabsl_base.so.*"
eerror "and all monoslot abseil-cpp ebuilds.  Use one of the following to find"
eerror "the ebuilds that link to vendored abseil-cpp."
eerror
eerror "ls /usr/${libdir}/libabsl_base.so*"
eerror "equery belongs /usr/${libdir}/libabsl_base.so.2501.0.0"
eerror
eerror "  or"
eerror
eerror "ls /usr/${libdir}/libabsl_base.so*"
eerror "scanelf -qR -N libabsl_base.so.2501.0.0 /usr/bin /usr/sbin /usr/${libdir}"
eerror
		die
	fi

	# CUSTOM_BLAS=OFF EIGENSPARSE=OFF MINIGLOG=OFF
	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DGFLAGS=$(usex gflags)
		-DLAPACK=$(usex lapack)
		-DSCHUR_SPECIALIZATIONS=$(usex schur)
		-DSUITESPARSE=$(usex sparse)
		-DEigen3_DIR=/usr/$(get_libdir)/cmake/eigen3

		-DBUILD_SHARED_LIBS="yes"
		-DEIGENMETIS="yes"
		-DEIGENSPARSE="yes"
		-DMINIGLOG="no"
		-DCUSTOM_BLAS="yes"
		-DWITH_CUDA="$(usex cuda)"

		-Dabsl_DIR="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)/cmake/absl"
	)

	if use cuda; then
		: "${CUDAHOSTCXX:=$(cuda_gccdir)}"
		: "${CUDAARCHS:=all}"
		export CUDAHOSTCXX
		export CUDAARCHS
	fi

	use sparse || mycmakeargs+=( -DEIGENSPARSE=ON )

	cmake-multilib_src_configure
}

src_test() {
	use cuda && cuda_add_sandbox -w
	cmake-multilib_src_test
}

src_install() {
	[[ -d "${S}/third_party/abseil-cpp" ]] && die "QA:  Fix vendored abseil-cpp removal"
	cmake-multilib_src_install

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r "examples" "data"
	fi
	[[ -e "${ED}/usr/$(get_libdir)/libabsl_base.so.2501.0.0" ]] && die "QA:  Fix abseil-cpp install"
}
