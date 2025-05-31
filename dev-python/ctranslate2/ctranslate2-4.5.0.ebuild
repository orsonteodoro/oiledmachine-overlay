# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CTranslate2"

CUB_COMMIT="ed040d585c3237d706973d7ad290bfee40958270"
CPUINFO_COMMIT="082deffc80ce517f81dc2f3aebe6ba671fcd09c9"
CPU_FEATURES_COMMIT="8a494eb1e158ec2050e5f699a504fbc9b896a43b"
CUTLASS_COMMIT="bbe579a9e3beb6ea6626d9227ec32d0dae119a49"
CXXOPTS_COMMIT="c74846a891b3cc3bfa992d588b1295f528d43039"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
GOOGLETEST_COMMIT_1="f8d7d77c06936315286eb55f8de22cd23c188571"
GOOGLETEST_COMMIT_2="6c58c11d5497b6ee1df3cb400ce30deb72fc28c0"
PYTHON_COMPAT=( "python3_"{10..12} )
RUY_COMMIT="363f252289fb7a1fba1703d99196524698cb884d"
SPDLOG_COMMIT="76fb40d95455f249bd70824ecfcae7a8f0930fa3"
THRUST_COMMIT="d997cd37a95b0fa2f1a0cd4697fd1188a842fbc8"

inherit check-compiler-switch dep-prepare distutils-r1 flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/OpenNMT/CTranslate2.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	S_PROJ="${WORKDIR}/${P}"
	S_PYTHON="${WORKDIR}/${P}/python"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	S_PROJ="${WORKDIR}/${MY_PN}-${PV}"
	S_PYTHON="${WORKDIR}/${MY_PN}-${PV}/python"
	SRC_URI="
https://github.com/OpenNMT/CTranslate2/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/cpu_features/archive/${CPU_FEATURES_COMMIT}.tar.gz
	-> cpu_features-${CPU_FEATURES_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz
	-> cxxopts-${CXXOPTS_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/ruy/archive/${RUY_COMMIT}.tar.gz
	-> ruy-${RUY_COMMIT:0:7}.tar.gz
https://github.com/gabime/spdlog/archive/${SPDLOG_COMMIT}.tar.gz
	-> spdlog-${SPDLOG_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/thrust/archive/${THRUST_COMMIT}.tar.gz
	-> thrust-${THRUST_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT}.tar.gz
	-> cpuinfo-${CPUINFO_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
	"
fi

DESCRIPTION="Fast inference engine for Transformer models"
HOMEPAGE="
	https://opennmt.net/CTranslate2
	https://github.com/OpenNMT/CTranslate2
	https://pypi.org/project/ctranslate2
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# OPENMP_RUNTIME=INTEL iomp is default ON but OPENMP_RUNTIME=COMP is used instead as USE flag default.
IUSE+="
+cli +cpu-dispatch -cuda -cudnn -dnnl dev -flash +openmp -tensor-parallel
+mkl -openblas -profiling +python -ruy test
ebuild_revision_2
"
REQUIRED_USE="
	flash? (
		cuda
	)
	tensor-parallel? (
		cuda
	)
"
RDEPEND+="
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-11.0
		dev-util/nvidia-cuda-toolkit:=
	)
	mkl? (
		sci-libs/mkl
	)
	openblas? (
		sci-libs/openblas
	)
	python? (
		$(python_gen_cond_dep '
			>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	tensor-parallel? (
		dev-libs/nccl
		virtual/mpi
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	openmp? (
		sys-devel/gcc[openmp]
	)
	python? (
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.11.1[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		')
	)
"
DOCS=( "${S_PROJ}/README.md" )

pkg_setup() {
	check-compiler-switch_start
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/cpu_features-${CPU_FEATURES_COMMIT}" "${S}/third_party/cpu_features"
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT}" "${S}/third_party/cutlass"
		dep_prepare_mv "${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}" "${S}/third_party/cxxopts"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/third_party/googletest"

		dep_prepare_mv "${WORKDIR}/ruy-${RUY_COMMIT}" "${S}/third_party/ruy"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_2}" "${S}/third_party/ruy/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}" "${S}/third_party/ruy/third_party/cpuinfo"

		dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/third_party/spdlog"

		dep_prepare_mv "${WORKDIR}/thrust-${THRUST_COMMIT}" "${S}/third_party/thrust"
		dep_prepare_mv "${WORKDIR}/cub-${CUB_COMMIT}" "${S}/third_party/thrust/dependencies/cub"
	fi
	S="${S_PYTHON}"
}

src_configure() {
	# Simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	cd "${S_PROJ}" || die
	docinto "licenses"
	dodoc "LICENSE"

	# Avoid collisions
	rm -rf "${ED}/usr/include/nlohmann" || die
	mv "${ED}/usr/share/doc/"{"","python-"}"ctranslate2-${PV}" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
