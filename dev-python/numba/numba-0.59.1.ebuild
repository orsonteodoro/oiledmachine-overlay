# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1
PYTHON_COMPAT=( "python3_"{10..12} )
LLVM_COMPAT=( {15..14} )

inherit check-compiler-switch distutils-r1 flag-o-matic toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/numba/numba.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	FALLBACK_COMMIT="9ce83ef5c35d7f68a547bf2fd1266b9a88d3a00d" # Mar 18, 2024
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/numba/numba/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="
	https://github.com/numba/numba
	https://pypi.org/project/numba/
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
doc clang cuda openmp tbb
ebuild_revision_5
"
REQUIRED_USE="
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	?? (
		openmp
		tbb
	)
"
RDEPEND+="
	(
		>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
		<dev-python/numpy-1.27[${PYTHON_USEDEP}]
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-11.2
		dev-python/cuda-python[${PYTHON_USEDEP}]
	)
	llvm_slot_15? (
		=dev-python/llvmlite-0.43*[${PYTHON_USEDEP}]
	)
	llvm_slot_14? (
		=dev-python/llvmlite-0.42*[${PYTHON_USEDEP}]
	)
	tbb? (
		>=dev-cpp/tbb-2021.1
	)
"
DEPEND+="
	${RDEPEND}
"
gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/clang-runtime:${s}[openmp]
				>=llvm-runtimes/openmp-${s}
			)
		"
	done
}
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	!clang? (
		sys-devel/gcc[openmp]
	)
	clang? (
		$(gen_clang_bdepend)
	)
	doc? (
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGE_LOG" "README.rst" )
PATCHES=(
	"${FILESDIR}/${PN}-0.59.1-tbb-libdir.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '${PV%_*}'" "${S}/dm_env/_metadata.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

python_configure() {
	if use clang ; then
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
			        export PATH=$(echo "${PATH}" \
			                | tr ":" "\n" \
			                | sed -E -e "/llvm\/[0-9]+/d" \
			                | tr "\n" ":" \
			                | sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${s}/bin|g")
				export CC="${CHOST}-clang-${s}"
				export CXX="${CHOST}-clang++-${s}"
				export CPP="${CC} -E"
				clang --version || die
				break
			fi
		done
	else
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CC} -E"
	fi
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use tbb ; then
		unset NUMBA_DISABLE_TBB
		export TBBROOT="${ESYSROOT}/usr"
	else
		export NUMBA_DISABLE_TBB=1
	fi
	if use openmp ; then
		unset NUMBA_DISABLE_OPENMP
		if tc-is-gcc ; then
			local s=$(gcc-major-version)
			if ! has_version "=sys-devel/gcc-${s}*[openmp]" ; then
eerror "You must enable =sys-devel/gcc-${s}[openmp] or disable the openmp USE flag."
				die
			fi
		fi
		if tc-is-clang ; then
			local s=$(clang-major-version)
			if ! has_version ">=llvm-runtimes/openmp-${s}" ; then
eerror "You must emerge >=llvm-runtimes/openmp-${s} or disable the openmp USE flag."
				die
			fi
		fi
		tc-check-openmp
	else
		export NUMBA_DISABLE_OPENMP=1
	fi
	if use cuda ; then
		export NUMBA_CUDA_USE_NVIDIA_BINDING=1
		export CUDA_HOME="/opt/cuda"
	else
		export NUMBA_CUDA_USE_NVIDIA_BINDING=0
	fi
}

gen_envd() {
	local arch=$(get_arch)
newenvd - "60${PN}" <<-_EOF_
CUDA_HOME="/opt/cuda"
NUMBA_CUDA_USE_NVIDIA_BINDING=1
_EOF_
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	einstalldocs
	gen_envd
}
