# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_TW_DISABLE="1"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"
inherit ruby-fakegem ruby-tw

DESCRIPTION="Google Auth Library for Ruby"
HOMEPAGE="https://github.com/googleapis/google-auth-library-ruby"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
SRC_URI="
https://github.com/googleapis/google-auth-library-ruby/archive/refs/tags/${PN}/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
RUBY_S="google-auth-library-ruby-${PN}-v${PV}"

ruby_add_rdepend "
	$(tw dev-ruby/memoist 0.16)
	$(tw dev-ruby/multi_json 1.11)
	(
		>=dev-ruby/faraday-0.9
		<dev-ruby/faraday-3a
	)
	(
		>=dev-ruby/jwt-1.4
		<dev-ruby/jwt-3
	)
	(
		>=dev-ruby/os-0.9
		<dev-ruby/os-2
	)
	(
		>=dev-ruby/signet-0.6
		<dev-ruby/signet-2a
	)
"
ruby_add_bdepend "
	$(tw dev-ruby/yard 0.9)
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
