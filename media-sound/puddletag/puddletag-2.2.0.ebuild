# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 xdg

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
LICENSE="
	GPL-2
	GPL-3
	GPL-3+
"
# GPL-2 - puddlestuff/functions.py
# GPL-2 - translations/puddletag_ru_RU.ts
# GPL-3 - translations/puddletag_es_ES.ts
# GPL-3+ - setup.py
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
# Version string contained in puddletag/source/puddlestuff/__init__.py
SRC_URI="
https://github.com/puddletag/puddletag/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
IUSE+="
acoustid amg audioread cover doc fpcalc fuzz-matching pyacoustid
quodlibet
"
REQUIRED_USE+="
	acoustid? (
		^^ (
			audioread
			fpcalc
			pyacoustid
		)
	)
"
RDEPEND+="
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.15.7[${PYTHON_USEDEP},svg,gui,widgets]
	>=dev-python/PyQt5-sip-12.11.0[${PYTHON_USEDEP}]
	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.45.1[${PYTHON_USEDEP}]
	amg? (
		>=dev-python/lxml-4.9.1[${PYTHON_USEDEP}]
	)
	audioread? (
		>=dev-python/audioread-2.1.9[${PYTHON_USEDEP},gstreamer]
		>=media-libs/chromaprint-0.5
		dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		media-libs/gst-plugins-bad:1.0
	)
	doc? (
		>=dev-python/sphinx-1.4.8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-bootstrap-theme-0.4.13[${PYTHON_USEDEP}]
	)
	fpcalc? (
		>=media-libs/chromaprint-0.5[tools]
	)
	fuzz-matching? (
		>=dev-python/Levenshtein-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/RapidFuzz-2.0.2[${PYTHON_USEDEP}]
	)
	pyacoustid? (
		>=dev-python/pyacoustid-1.2.2[${PYTHON_USEDEP}]
	)
	quodlibet? (
		>=media-sound/quodlibet-2.5[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
S="${WORKDIR}/${PN}-${PV}"
DOCS=( changelog NEWS THANKS TODO )
RESTRICT="mirror"

distutils_enable_sphinx "docsrc"

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  install-depends-for-complete-support
# OILEDMACHINE-OVERLAY-META-TAGS:  feature-complete-support
