# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

DISTUTILS_USE_PEP517="no"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit distutils-r1 fix-rpath

S="${WORKDIR}"
KEYWORDS="~amd64 ~arm64"
SRC_URI="
	kernel_linux? (
		amd64? (
https://files.pythonhosted.org/packages/d3/82/41d9b80f09b82e066894d9b508af07b7b0fa325ce0322980674de49106a0/milvus_lite-2.5.1-py3-none-manylinux2014_x86_64.whl
		)
		arm64? (
https://files.pythonhosted.org/packages/2e/cf/3d1fee5c16c7661cf53977067a34820f7269ed8ba99fe9cf35efc1700866/milvus_lite-2.5.1-py3-none-manylinux2014_aarch64.whl
		)
	)
"

DESCRIPTION="A lightweight version of Milvus"
HOMEPAGE="
	https://github.com/milvus-io/milvus-lite
	https://pypi.org/project/milvus-lite
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	>=dev-cpp/gflags-2.2.2
	>=dev-cpp/glog-0.6.0
	>=dev-cpp/tbb-2021.9.0:0
	>=dev-libs/double-conversion-3.2.1
	>=sci-libs/openblas-0.3.27
	>=sys-devel/gcc-9.3.0[cxx]
	>=sys-libs/glibc-2.31
	>=sys-libs/zlib-1.2.13
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-75.3.2[${PYTHON_USEDEP}]
"
DOCS=( )

pkg_setup() {
	python_setup
}

src_unpack() {
	:
}

get_arch() {
	if use arm64 ; then
		echo "aarch64"
	elif use amd64 ; then
		echo "x86_64"
	fi
}

python_compile() {
	:
}

python_install() {
	local arch=$(get_arch)
	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	local wheel_path=$(realpath "${DISTDIR}/milvus_lite-${PV}-py3-none-manylinux2014_${arch}.whl")
	distutils_wheel_install "${d}" \
		"${wheel_path}"

}

src_install() {
	distutils-r1_src_install
	# The distutils eclass is broken.
	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	multibuild_merge_root "${d}" "${D%/}"

	fix_rpath(){
		local RPATH_FIXES=(
			"${ED}/usr/lib/${EPYTHON}/site-packages/milvus_lite/lib/milvus:/usr/lib/${EPYTHON}/site-packages/milvus_lite/lib"
		)
		fix-rpath_repair
	}
	python_foreach_impl fix_rpath
	fix-rpath_verify
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
