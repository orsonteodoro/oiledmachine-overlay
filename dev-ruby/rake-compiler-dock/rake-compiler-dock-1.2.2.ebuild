# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# RUBY_FAKEGEM_EXTENSIONS=(test/rcd_test/ext/mri/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_TW_DISABLE="1"
USE_RUBY="ruby26 ruby27 ruby30 ruby31"
inherit ruby-fakegem ruby-tw

DESCRIPTION="Common protocol buffer types used by Google APIs"
HOMEPAGE="https://github.com/rake-compiler/rake-compiler-dock"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
ruby_add_bdepend "
	$(tw dev-ruby/test-unit 3.0)
	(
		>=dev-ruby/bundler-1.7
		<dev-ruby/bundler-3
	)
	>=dev-ruby/rake-12
"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
