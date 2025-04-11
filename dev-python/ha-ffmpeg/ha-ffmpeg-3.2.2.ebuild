# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# pylint-strict-informational

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )

inherit distutils-r1

KEYWORDS="amd64 arm arm64 x86"
SRC_URI="
https://github.com/home-assistant-libs/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${PV}.gh.tar.gz
"

DESCRIPTION="A library that handles FFmpeg for home-assistant"
HOMEPAGE="
	https://github.com/home-assistant-libs/ha-ffmpeg
	https://pypi.org/project/ha-ffmpeg/
"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
IUSE="dev lint test"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/async-timeout-5.0.0[${PYTHON_USEDEP}]
	')
	|| (
		>=media-video/ffmpeg-6.1.1:0[${PYTHON_SINGLE_USEDEP}]
		>=media-video/ffmpeg-7.1.1:0/59.61.61[${PYTHON_SINGLE_USEDEP}]
	)
	media-video/ffmpeg:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/tox-4.23.2[${PYTHON_USEDEP}]
		)
		lint? (
			>=dev-python/flake8-7.1.1[${PYTHON_USEDEP}]
			>=dev-python/pylint-3.1.0[${PYTHON_USEDEP}]
			>=dev-python/pylint-strict-informational-0.1[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

