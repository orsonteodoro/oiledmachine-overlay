# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem ruby-tw

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}-ruby.tar.gz"
RUBY_S="protobuf-${PV}/ruby"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""
PATCHES=(
	"${FILESDIR}/${PN}-3.21.9-utf8_range-header.patch"
	"${FILESDIR}/${PN}-3.21.9-utf8_range-libs.patch"
)

ruby_add_rdepend "
	$(tw dev-ruby/rake-compiler 1.1.0)
	(
		$(tw dev-ruby/test-unit 3.0)
		>=dev-ruby/test-unit-3.0.9
	)
	>=dev-ruby/rake-compiler-dock-1.2.1
"
# Upstream uses =dev-ruby/rake-compiler-dock-1.2.1

RDEPEND+="
	dev-libs/utf8_range:=
"
DEPEND+="
	test? (
		>=dev-libs/protobuf-${PV}
	)
"

all_ruby_prepare() {
	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's:../src/protoc:protoc:' \
		-e 's/:compile,//' \
		-e '/:test/ s/:build,//' \
		-i Rakefile || die
}
