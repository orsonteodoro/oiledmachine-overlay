# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="https://bitbucket.org/blaze-lib/blaze/downloads/blaze-${PV}.tar.gz"

DESCRIPTION="A high performance C++ math library"
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/blaze-lib/blaze"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" boost cxx11threads hpx +lapack +openmp"
RDEPEND+="
	boost? (
		dev-libs/boost
	)
	hpx? (
		sys-cluster/hpx
	)
	lapack? (
		|| (
			sci-libs/mkl-rt
			sci-libs/openblas
			virtual/lapack
		)
	)
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			llvm-runtimes/openmp
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.5
	|| (
		llvm-core/clang
		sys-devel/gcc[cxx]
	)
"

src_configure() {
	local mycmakeargs=(
		-DUSE_LAPACK=$(usex lapack)
	)
	if use boost || use cxx11threads || use hpx || use openmp ; then
		mycmakeargs+=(
			-DBLAZE_SHARED_MEMORY_PARALLELIZATION="ON"
		)
		if use openmp ; then
			mycmakeargs+=(
				-DBLAZE_SMP_THREADS="OpenMP"
			)
		elif use cxx11threads ; then
			mycmakeargs+=(
				-DBLAZE_SMP_THREADS="C++11"
			)
		elif use boost ; then
			mycmakeargs+=(
				-DBLAZE_SMP_THREADS="Boost"
			)
		elif use hpx ; then
			mycmakeargs+=(
				-DBLAZE_SMP_THREADS="HPX"
			)
		fi
	else
		mycmakeargs+=(
			-DBLAZE_SHARED_MEMORY_PARALLELIZATION="OFF"
		)
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
