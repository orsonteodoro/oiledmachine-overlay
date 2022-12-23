# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md SECURITY.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_TW_DISABLE="1"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"
inherit ruby-fakegem ruby-tw

DESCRIPTION="Shared style guide for Google's ruby projects"
HOMEPAGE="https://github.com/googleapis/ruby-style/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
ruby_add_rdepend "
	$(tw dev-ruby/rubocop 1.31)
"
RESTRICT="mirror"
SRC_URI="
https://github.com/googleapis/ruby-style/archive/refs/tags/${PN}/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RUBY_S="ruby-style-${PN}-v${PV}"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
