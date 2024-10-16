# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Cuda is still beta, default to opencl

MYPN="CLBlast"

inherit hip-versions

ROCM_SLOTS=(
	"4.1"
	"4.5"
	"5.1"
	"5.2"
	"5.3"
	"5.4"
	"5.5"
	"5.6"
	"5.7"
	"6.0"
	"6.1"
	"6.2"
)
declare -A ROCM_VERSIONS=(
	["4_1"]="${HIP_4_1_VERSION}"
	["4_5"]="${HIP_4_5_VERSION}"
	["5_1"]="${HIP_5_1_VERSION}"
	["5_2"]="${HIP_5_2_VERSION}"
	["5_3"]="${HIP_5_3_VERSION}"
	["5_4"]="${HIP_5_4_VERSION}"
	["5_5"]="${HIP_5_5_VERSION}"
	["5_6"]="${HIP_5_6_VERSION}"
	["5_7"]="${HIP_5_7_VERSION}"
	["6_0"]="${HIP_6_0_VERSION}"
	["6_1"]="${HIP_6_1_VERSION}"
	["6_2"]="${HIP_6_2_VERSION}"
)
gen_rocm_iuse() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}
		"
	done
}
ROCM_IUSE=( $(gen_rocm_iuse) )

inherit cmake rocm

KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${MYPN}-${PV}"
SRC_URI="
https://github.com/CNugteren/${MYPN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tuned OpenCL BLAS"
HOMEPAGE="https://github.com/CNugteren/CLBlast"
LICENSE="Apache-2.0"
# Tests require write access to /dev/dri/renderD...
RESTRICT="
	test
"
#RESTRICT="
#	!test? ( test )
#"
SLOT="0"
IUSE="
${ROCM_IUSE[@]}
client cuda examples rocm +opencl test
"
gen_rocm_required_use() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			rocm_${s/./_}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	^^ (
		cuda
		opencl
	)
	rocm? (
		opencl
		|| (
			${ROCM_IUSE[@]}
		)
	)
	test? (
		client
	)
"
gen_rocm_rdepend() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s1="${s/./_}"
		local rocm_version="${ROCM_VERSIONS[${s1}]}"
		echo "
			rocm_${s1}? (
				~dev-libs/rocm-opencl-runtime-${rocm_version}:${s}
			)
		"
	done
}
RDEPEND="
	client? (
		virtual/cblas
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	opencl? (
		rocm? (
			$(gen_rocm_rdepend)
			dev-libs/rocm-opencl-runtime:=
		)
		virtual/opencl
	)
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}/level2_xtrsv.patch"
	"${FILESDIR}/level3_xtrsv.patch"
	"${FILESDIR}/${PN}-1.6.3-hardcoded-paths"
)
DOCS=(
	"CHANGELOG"
	"README.md"
)

pkg_setup() {
	if use rocm ; then
		rocm_pkg_setup
	fi
}

src_prepare() {
	# No forced optimization
	# Fix libdir for multilib.
	sed \
		-e 's/-O3//g' \
		-e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g' \
		-i "CMakeLists.txt" \
		|| die
	cmake_src_prepare
	if use rocm ; then
        # Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
		PATCH_PATHS=(
			"${S}/cmake/Modules/FindOpenCL.cmake"
		)
		rocm_src_prepare
	fi
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DCLIENTS="$(usex client)"
		-DCUDA="$(usex cuda)"
		-DNETLIB="$(usex client)"
		-DOPENCL="$(usex opencl)"
		-DSAMPLES="$(usex examples)"
		-DTESTS="$(usex test)"
	)
	if use rocm ; then
		rocm_src_configure
	else
		cmake_src_configure
	fi
}

src_install() {
	cmake_src_install
	dodoc -r "doc"
}
