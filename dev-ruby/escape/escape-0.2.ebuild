# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="escape"
HOMEPAGE="http://www.a-k-r.org/escape/"
LICENSE="BSD"
SRC_URI="http://www.a-k-r.org/escape/${PN}-${PV}.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

each_ruby_compile() {
        emake V=1 rdoc || die

        emake README || die

}

each_ruby_test() {
        ruby-ng_testrb-2 test/test_*.rb
}

each_ruby_install() {
        doruby escape.rb || die "doruby failed"

	dodoc README
}
