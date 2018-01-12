# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

DESCRIPTION="Like ruby's abbrev module, but in js"

SRC_URI="https://github.com/isaacs/abbrev-js/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC MIT"  #no license on this version.
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-js-${PV}"

DEPEND="${DEPEND}"

DOCS=( README.md )

