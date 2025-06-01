# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-compiler-switch flag-o-matic python-single-r1 cmake rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/omniperf/"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Missing dependencies
	S="${WORKDIR}/rocprofiler-compute-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/omniperf/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Advanced Profiling and Analytics for AMD Hardware"
HOMEPAGE="
	https://rocm.docs.amd.com/projects/omniperf/en/latest/
	https://github.com/ROCm/omniperf
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_3"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/astunparse-1.6.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17.5[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.4.3[${PYTHON_USEDEP}]
		>=sci-visualization/dash-1.12.0[${PYTHON_USEDEP}]
		dev-python/colorlover[${PYTHON_USEDEP}]
		dev-python/kaleido[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/plotille[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/dash-bootstrap-components[${PYTHON_USEDEP}]
		dev-python/dash-svg[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		test? (
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.19
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-6.2.0-conditional-version-sha-install.patch"
)
DOCS=( "AUTHORS" "CHANGES" )

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	dodoc "LICENSE"
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
