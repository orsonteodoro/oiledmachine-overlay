# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Note: company-mode supports many backends, and we refrain from including
# them all in RDEPEND. Only depend on things that are needed at build time.
DEPEND=""
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md NEWS.md"
