# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

SRC_URI="https://bitbucket.org/blaze-lib/blaze/downloads/blaze-${PV}.tar.gz"
S="${WORKDIR}/${P}"

DESCRIPTION="A high performance C++ math library"
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/blaze-lib/blaze"
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
			sys-libs/libomp
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.5
	|| (
		sys-devel/clang
		sys-devel/gcc[cxx]
	)
"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DUSE_LAPACK=$(usex lapack)
	)
	if use boost || use cxx11threads || use hpx || use openmp ; then
		mycmakeargs+=(
			-DBLAZE_SHARED_MEMORY_PARALLELIZATION=ON
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
			-DBLAZE_SHARED_MEMORY_PARALLELIZATION=OFF
		)
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
