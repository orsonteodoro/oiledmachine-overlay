# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO"
PYTHON_COMPAT=( python3_{8..11} )

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
)

inherit cflags-hardened cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot python-any-r1

SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="
	Apache-2.0
	test? (
		BSD
	)
"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="${PV%%.*}/${PV}"
IUSE+="
test
ebuild_revision_15
"
BDEPEND+="
	${PYTHON_DEPS}
	test? (
		=dev-cpp/gtest-9999[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		sys-libs/timezone-data
	)
"
RESTRICT="
	test
	mirror
" # Configure time error with test
PATCHES=(
)

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare
	# Un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die
	# Now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_PROPAGATE_CXX_STD=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=TRUE
		-DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${PV%%.*}"
	)

	if \
		   use gcc_slot_12_5 \
		|| use gcc_slot_13_4 \
		|| use gcc_slot_14_3 \
	; then
		mycmakeargs+=(
			-DCMAKE_CXX_STANDARD=14
		)
	fi

	cmake-multilib_src_configure
}

