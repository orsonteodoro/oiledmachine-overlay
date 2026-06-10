# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22 - numpy 1.21 - python 3.10 - G23 distro dropped
# D12 - numpy 1.24 - python 3.11 - G23 distro dropped
# U24 - numpy 1.26 - python 3.12
# D13 - numpy 2.2  - python 3.13
# U26 - numpy 2.3  - python 3.14

# Prune EOL Python versions or distro dropped versions.
# Only bump for newest LTS releases.

# For upstream dropped versions, see also https://devguide.python.org/versions/
# For dropped FAFO distro versions, see https://github.com/gentoo/gentoo/blob/master/eclass/python-utils-r1.eclass#L55

DISTUTILS_USE_PEP517="no"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1

S="${WORKDIR}"

DESCRIPTION="Numpy LTS alignment"
HOMEPAGE="
"
LICENSE="
	metapackage
"
RESTRICT="mirror"
SLOT="0/2.4" # Bump subslot to the latest major-minor version
IUSE+=" +lts"
RDEPEND+="
	python_targets_python3_11? (
		=dev-python/numpy-1.21*[${PYTHON_USEDEP}]
	)
	python_targets_python3_11? (
		=dev-python/numpy-1.24*[${PYTHON_USEDEP}]
	)
	python_targets_python3_12? (
		=dev-python/numpy-1.26*[${PYTHON_USEDEP}]
	)
	python_targets_python3_13? (
		=dev-python/numpy-2.2*[${PYTHON_USEDEP}]
	)
	python_targets_python3_14? (
		lts? (
			=dev-python/numpy-2.3*[${PYTHON_USEDEP}]
		)
		!lts? (
			=dev-python/numpy-2.4*[${PYTHON_USEDEP}]
		)
	)
	dev-python/numpy:=
"
DEPEND+="
	${RDEPEND}
"

src_install() {
	:
}
