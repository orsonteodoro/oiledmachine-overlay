# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_EXTRA_FILES="fs.js legacy-streams.js polyfills.js"

inherit node-module

DESCRIPTION="A drop-in replacement for fs, making various improvements"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
