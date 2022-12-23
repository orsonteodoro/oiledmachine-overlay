# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md SECURITY.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_TW_DISABLE="1"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"
inherit ruby-fakegem ruby-tw

DESCRIPTION="Signet is an OAuth 1.0 / OAuth 2.0 implementation."
HOMEPAGE="https://github.com/googleapis/signet"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
SRC_URI="
https://github.com/googleapis/${PN}/archive/refs/tags/${PN}/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RUBY_S="${PN}-${PN}-v${PV}"

ruby_add_rdepend "
	$(tw dev-ruby/addressable 2.3)
	$(tw dev-ruby/multi_json 1.10)
	(
		>=dev-ruby/faraday-0.9
		<dev-ruby/faraday-3a
	)
	(
		>=dev-ruby/jwt-1.5
		<dev-ruby/jwt-3
	)
"
# TODO packaging:
#   dev-ruby/google-style
ruby_add_bdepend "
	$(tw dev-ruby/google-style 1.26.0)
	$(tw dev-ruby/kramdown 1.5)
	$(tw dev-ruby/launchy 2.4)
	$(tw dev-ruby/rake 13.0)
	$(tw dev-ruby/redcarpet 3.0)
	(
		$(tw dev-ruby/rspec 3.1)
		dev-ruby/rspec:3
	)
	(
		$(tw dev-ruby/yard 0.9)
		>=dev-ruby/yard-0.9.12
	)
	>=dev-ruby/rubygems-1.3.5
"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
