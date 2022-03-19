# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 xdg

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
LICENSE="GPL-2 GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
EGIT_COMMIT="e0d35889d70507dfd0a8dc00cf7c8e5361deba0f"
DOCS=( changelog NEWS THANKS TODO )
RESTRICT="mirror"
SLOT="0"
# version string contained in puddletag/source/puddlestuff/__init__.py
SRC_URI="https://github.com/puddletag/puddletag/archive/refs/tags/${PV}.tar.gz -> ${PV}.tar.gz"
IUSE+=" acoustid amg audioread cover fpcalc fuzz-matching musicbrainz pyacoustid quodlibet"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	acoustid? ( ^^ ( audioread fpcalc pyacoustid ) )
"
RDEPEND+=" ${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/wheel[${PYTHON_USEDEP}]')
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.15.6[${PYTHON_USEDEP},svg,gui,widgets]
	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/sip-4.14.2-r1:0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-bootstrap-theme-0.4.13[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.4.8[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.45.1[${PYTHON_USEDEP}]
	amg? ( >=dev-python/lxml-3.0.1[${PYTHON_USEDEP}] )
	audioread? (
		>=dev-python/audioread-2.1.9[${PYTHON_USEDEP},gstreamer]
		  dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		>=media-libs/chromaprint-0.6
		  media-libs/gst-plugins-bad:1.0
	)
	fpcalc? (
		>=media-libs/chromaprint-0.6[tools]
	)
	fuzz-matching? ( >=dev-python/python-levenshtein-0.16.0[${PYTHON_USEDEP}] )
	musicbrainz? ( >=dev-python/python-musicbrainz-0.7.4-r1[${PYTHON_USEDEP}] )
	pyacoustid? ( >=dev-python/pyacoustid-1.2.2[${PYTHON_USEDEP}] )
	quodlibet? ( >=media-sound/quodlibet-2.5[${PYTHON_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
S="${WORKDIR}/${PN}-${PV}"
