# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Koala is a Facebook library for Ruby"
HOMEPAGE="https://github.com/arsduo/koala"
LICENSE="MIT"
KEYWORDS="~arm ~arm64 ~amd64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
EGIT_COMMIT="3c7037eea67062f05eccb16836bebec403ddbfec"
SLOT="0/${PV}"
DEPEND="dev-ruby/addressable
	dev-ruby/faraday
	>=dev-ruby/json-1.8"
RDEPEND="${DEPEND}"
USE_RUBY="ruby24 ruby25 ruby26 ruby27"
RUBY_S="${PN}-${EGIT_COMMIT}"
inherit ruby-ng
SRC_URI="https://github.com/arsduo/koala/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

each_ruby_install() {
	pushd ${S}/lib &>/dev/null
		doruby -r *
	popd &>/dev/null
}
