# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="Koala is a Facebook library for Ruby"
HOMEPAGE="https://github.com/arsduo/koala"
LICENSE="MIT"
SRC_URI="https://github.com/arsduo/${PN}/archive/v2.5.0rc1.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""
RUBY_S="${PN}-${PV//_/}"

DEPEND="dev-ruby/faraday
        dev-ruby/addressable"

RDEPEND="${DEPEND}"

each_ruby_install() {
	pushd ${S}/lib &>/dev/null
	doruby -r *
	popd &>/dev/null
}
