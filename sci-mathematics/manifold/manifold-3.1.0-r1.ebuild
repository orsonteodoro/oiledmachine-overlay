# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, ROCm-6.2, ROCm-6.3, ROCm-6.4, ROCm-7.0, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)
PYTHON_COMPAT=( python3_{11..13} )
inherit cmake libstdcxx-slot python-single-r1

DESCRIPTION="Geometry library for topological robustness"
HOMEPAGE="https://github.com/elalish/manifold"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/elalish/manifold.git"
else
	if [[ ${PV} = *pre* ]] ; then
		COMMIT="e7e0780114881dcf6e5ad934323f2595966865f9"
		SRC_URI="https://github.com/elalish/manifold/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		SRC_URI="https://github.com/elalish/manifold/releases/download/v${PV}/${P}.tar.gz"
	fi

	KEYWORDS="amd64"
fi

LICENSE="Apache-2.0"
SLOT="0/1"

IUSE="
debug python +tbb test
ebuild_revision_1
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="
	sci-mathematics/clipper2[${LIBSTDCXX_USEDEP}]
	sci-mathematics/clipper2:=
	python? ( ${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	tbb? (
		dev-cpp/tbb[${LIBSTDCXX_USEDEP}]
		dev-cpp/tbb:=
	)
"
DEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/nanobind-2.1.0[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-cpp/gtest )
	${RDEPEND}
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare

	sed \
		-e "/list(APPEND MANIFOLD_FLAGS/s/^/# DONOTSET /" \
		-i CMakeLists.txt || die

	sed \
		-e '/<memory>/a#include <cstdint>' \
		-i include/manifold/manifold.h || die
}

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CROSS_SECTION="yes"
		-DMANIFOLD_DEBUG="$(usex debug)"
		-DMANIFOLD_DOWNLOADS="no"
		-DMANIFOLD_EXPORT="no"
		-DMANIFOLD_JSBIND="no"
		-DMANIFOLD_PAR="$(usex tbb ON OFF)"
		-DMANIFOLD_PYBIND="$(usex python)"
		-DMANIFOLD_TEST="$(usex test)"
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}/test/manifold_test" || die
}
