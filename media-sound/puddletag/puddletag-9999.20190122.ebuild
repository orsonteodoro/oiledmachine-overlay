# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime

COMMIT="8010f3341301ee36bb1782b21384ce1609de36ea" # pyqt5 branch
OWNER="keithgg"

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
SRC_URI="https://github.com/${OWNER}/${PN}/archive/${COMMIT}.zip"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid cover musicbrainz quodlibet"

DEPEND=""
RDEPEND="dev-python/PyQt5[${PYTHON_USEDEP},svg,gui,widgets]
	>=dev-python/pyparsing-1.5.1[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.21[${PYTHON_USEDEP}]
	>=dev-python/configobj-4.7.2-r1[${PYTHON_USEDEP}]
	acoustid? ( >=media-libs/chromaprint-0.6 )
	musicbrainz? ( >=dev-python/python-musicbrainz-0.7.4-r1[${PYTHON_USEDEP}] )
	quodlibet? ( >=media-sound/quodlibet-2.5[${PYTHON_USEDEP}] )
	>=dev-python/sip-4.14.2-r1:0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.0.1[${PYTHON_USEDEP}]"

DOCS=(changelog HACKING NEWS THANKS TODO)

S="${WORKDIR}/${PN}-${COMMIT}/source"
