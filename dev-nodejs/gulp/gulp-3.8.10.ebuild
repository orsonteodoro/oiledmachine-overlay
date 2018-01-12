# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.9.0"
NODE_MODULE_DEPEND="archy:1.0.0 chalk:0.5.0 deprecated:0.0.1 gulp-util:3.0.0 interpret:0.3.2 liftoff:0.13.2 minimist:1.1.0 orchestrator:0.3.0 pretty-hrtime:0.2.0 semver:4.1.0 tildify:1.0.0 v8flags:1.0.1 vinyl-fs:0.3.0"
NODE_MODULE_EXTRA_FILES="bin completion"

inherit node-module

DESCRIPTION="The streaming build system"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )
