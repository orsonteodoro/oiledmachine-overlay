# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
		~sci-libs/lightning-app-${PV}:${SLOT}
	)
	fabric? (
		~sci-libs/lightning-fabric-${PV}:${SLOT}
	)
	pytorch? (
		~sci-libs/pytorch-lightning-${PV}:${SLOT}
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
