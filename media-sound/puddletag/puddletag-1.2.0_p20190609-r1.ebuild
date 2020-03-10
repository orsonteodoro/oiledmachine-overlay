# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 fdo-mime

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
LICENSE="GPL-2 GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
EGIT_COMMIT="8010f3341301ee36bb1782b21384ce1609de36ea" # pyqt5 branch
DOCS=( changelog HACKING NEWS THANKS TODO )
RESTRICT="mirror"
SLOT="0"
# version string contained in puddletag/source/puddlestuff/__init__.py
SRC_URI="https://github.com/keithgg/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PF}.tar.gz"
IUSE="acoustid cover musicbrainz quodlibet"
RDEPEND="acoustid? ( >=media-libs/chromaprint-0.6 )
	 dev-python/PyQt5[${PYTHON_USEDEP},svg,gui,widgets]
	 >=dev-python/configobj-4.7.2-r1[${PYTHON_USEDEP}]
	 >=dev-python/lxml-3.0.1[${PYTHON_USEDEP}]
	 >=dev-python/pyparsing-1.5.1[${PYTHON_USEDEP}]
	 dev-python/python-levenshtein[${PYTHON_USEDEP}]
	 >=dev-python/sip-4.14.2-r1:0[${PYTHON_USEDEP}]
	 >=media-libs/mutagen-1.21[${PYTHON_USEDEP}]
	 musicbrainz? ( >=dev-python/python-musicbrainz-0.7.4-r1[${PYTHON_USEDEP}] )
	 quodlibet? ( >=media-sound/quodlibet-2.5[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}/source"

src_prepare() {
	default
	futurize -w -v -0 "${S}" || die
}

pkg_postinst() {
	einfo "The package saves autosaves metadata, but the file commands to explicitly save are disabled."
	einfo "In other words, it still works."
}
