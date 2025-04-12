# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Build is broken

# FIXME:
# offline cargo crates
#
#error: failed to get `bstr` as a dependency of package `tiktoken v0.8.0 (/var/tmp/portage/dev-python/tiktoken-0.8.0/work/tiktoken-0.8.0)`
#
#Caused by:
#  download of config.json failed
#
#Caused by:
#  failed to download from `https://index.crates.io/config.json`
#
#Caused by:
#  [6] Could not resolve hostname (Could not resolve host: index.crates.io)


DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_COMPAT=( 16 )
PYTHON_COMPAT=( "python3_"{10..13} )
RUST_MAX_VER="1.71.1" # Inclusive.  Corresponds to llvm 18
RUST_MIN_VER="1.71.0" # Corresponds to llvm 17
RUST_NEEDS_LLVM=1

inherit distutils-r1 pypi rust

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
	python_targets_python3_10? (
		elibc_musl? (
			amd64? (
https://files.pythonhosted.org/packages/c7/6c/9c1a4cc51573e8867c9381db1814223c09ebb4716779c7f845d48688b9c8/tiktoken-0.9.0-cp310-cp310-musllinux_1_2_x86_64.whl
			)
		)
		elibc_glibc? (
			amd64? (
https://files.pythonhosted.org/packages/f1/95/cc2c6d79df8f113bdc6c99cdec985a878768120d87d839a34da4bd3ff90a/tiktoken-0.9.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
			)
			arm64? (
https://files.pythonhosted.org/packages/bc/20/3ed4cfff8f809cb902900ae686069e029db74567ee10d017cb254df1d598/tiktoken-0.9.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
			)
		)
	)
	python_targets_python3_11? (
		elibc_musl? (
			amd64? (
https://files.pythonhosted.org/packages/7d/7c/1069f25521c8f01a1a182f362e5c8e0337907fae91b368b7da9c3e39b810/tiktoken-0.9.0-cp311-cp311-musllinux_1_2_x86_64.whl
			)
		)
		elibc_glibc? (
			amd64? (
https://files.pythonhosted.org/packages/b1/73/41591c525680cd460a6becf56c9b17468d3711b1df242c53d2c7b2183d16/tiktoken-0.9.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
			)
			arm64? (
https://files.pythonhosted.org/packages/03/58/01fb6240df083b7c1916d1dcb024e2b761213c95d576e9f780dfb5625a76/tiktoken-0.9.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
			)
		)
	)
	python_targets_python3_12? (
		elibc_musl? (
			amd64? (
https://files.pythonhosted.org/packages/5c/41/1e59dddaae270ba20187ceb8aa52c75b24ffc09f547233991d5fd822838b/tiktoken-0.9.0-cp312-cp312-musllinux_1_2_x86_64.whl
			)
		)
		elibc_glibc? (
			amd64? (
https://files.pythonhosted.org/packages/1b/40/da42522018ca496432ffd02793c3a72a739ac04c3794a4914570c9bb2925/tiktoken-0.9.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
			)
			arm64? (
https://files.pythonhosted.org/packages/40/10/1305bb02a561595088235a513ec73e50b32e74364fef4de519da69bc8010/tiktoken-0.9.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
			)
		)
	)
	python_targets_python3_13? (
		elibc_musl? (
			amd64? (
https://files.pythonhosted.org/packages/fa/5c/74e4c137530dd8504e97e3a41729b1103a4ac29036cbfd3250b11fd29451/tiktoken-0.9.0-cp313-cp313-musllinux_1_2_x86_64.whl
			)
		)
		elibc_glibc? (
			amd64? (
https://files.pythonhosted.org/packages/f2/bb/4513da71cac187383541facd0291c4572b03ec23c561de5811781bbd988f/tiktoken-0.9.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
			)
			arm64? (
https://files.pythonhosted.org/packages/fe/82/9197f77421e2a01373e27a79dd36efdd99e6b4115746ecc553318ecafbf0/tiktoken-0.9.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
			)
		)
	)

"

DESCRIPTION="tiktoken is a fast BPE tokeniser for use with OpenAI's models"
HOMEPAGE="
	https://github.com/openai/tiktoken
	https://pypi.org/project/tiktoken
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" blobfile dev"
RDEPEND+="
	>=dev-python/regex-2022.1.18[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	blobfile? (
		>=dev-python/blobfile-2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-62.4[${PYTHON_USEDEP}]
	>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=()

pkg_setup() {
	python_setup
	rust_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		:
		#unpack ${A}
		mkdir -p "${S}"
	fi
}

python_compile() {
einfo "EPYTHON:  ${EPYTHON}"
	local wheel_path
	local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install"
	mkdir -p "${d}" || die

	local pv="${EPYTHON/python/}"
	pv="${pv/./}"

	local wheel_name
	if use elibc_musl ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			wheel_name="${PN}-${PV}-cp${pv}-cp${pv}-musllinux_1_2_x86_64.whl"
		else
eerror "${ABI} is not supported."
			die
		fi
	elif use elibc_glibc ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			wheel_name="${PN}-${PV}-cp${pv}-cp${pv}-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
		elif [[ "${ABI}" == "arm64" ]] ; then
			wheel_name="${PN}-${PV}-cp${pv}-cp${pv}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
		else
eerror "${ABI} is not supported."
			die
		fi
	else
eerror "${LIBC} is not supported."
			die
	fi

	wheel_path=$(realpath "${DISTDIR}/${wheel_name}")
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
