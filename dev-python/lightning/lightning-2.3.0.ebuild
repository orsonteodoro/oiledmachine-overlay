# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_11" )

inherit python-single-r1

DESCRIPTION="The Deep Learning framework to train, deploy, and ship AI \
products Lightning fast."
HOMEPAGE="
	https://github.com/Lightning-AI/pytorch-lightning
	https://pypi.org/project/lightning
"
LICENSE="
	metapackage
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" app fabric pytorch"
RDEPEND+="
	app? (
		~dev-python/lightning-app-${PV}:${SLOT}[${PYTHON_SINGLE_USEDEP}]
	)
	fabric? (
		~dev-python/lightning-fabric-${PV}:${SLOT}[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		~dev-python/pytorch-lightning-${PV}:${SLOT}[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
