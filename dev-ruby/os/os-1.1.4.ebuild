# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_TW_DISABLE="1"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"
inherit ruby-fakegem ruby-tw

DESCRIPTION="The OS gem allows for some useful and easy functions, like OS.linux? (=> true or false) OS.bits ( => 32 or 64) etc"
HOMEPAGE="https://github.com/rdp/os"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
ruby_add_bdepend "
	$(tw dev-ruby/rake 0.8)
	$(tw dev-ruby/test-unit 3)
	>=dev-ruby/rspec-2:2
"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
