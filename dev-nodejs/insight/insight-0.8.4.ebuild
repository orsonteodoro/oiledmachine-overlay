# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="async:1.4.2 chalk:1.0.0 configstore:1.0.0 inquirer:0.10.0 lodash-debounce:3.0.1 object-assign:4.0.1 os-name:1.0.0 request:2.74.0 tough-cookie:2.0.0 uuid:3.0.0"

inherit node-module

DESCRIPTION="Understand how your tool is being used by anonymously reporting usage metrics to Google Analytics or Yandex.Metrica"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

