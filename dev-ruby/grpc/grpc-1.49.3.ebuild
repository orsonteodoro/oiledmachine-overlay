# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_FAKEGEM_EXTENSIONS=(src/ruby/ext/grpc/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="AUTHORS LICENSE NOTICE.txt README.md"
RUBY_FAKEGEM_GEMSPEC="grpc.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_TW_DISABLE="1"
RUBY_PV=(2.7 3.0 3.1)
USE_RUBY=("${RUBY_PV[@]/.}")
USE_RUBY=("${USE_RUBY[@]/#/ruby}")
USE_RUBY="${USE_RUBY[@]}"
inherit ruby-fakegem ruby-tw

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"
BORINGSSL_LICENSES="
	Apache-2.0
	BoringSSL-ECC
	BoringSSL-PSK
	BSD
	BSD-2
	ISC
	MIT
	MPL-2.0
	openssl
"
LICENSE="
	Apache-2.0
	${BORINGSSL_LICENSES}
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
ruby_add_rdepend "
	$(tw dev-ruby/google-protobuf 3.21)
	$(tw dev-ruby/googleapis-common-protos-types 1.0)
"
gen_ruby_bdepend() {
	local pv
	for pv in ${RUBY_PV[@]} ; do
		echo "
			ruby_targets_ruby${pv/.}? (
				=dev-lang/ruby-${pv}*[ssl]
			)
		"
	done
}
# Upstream uses facter-2.4
ruby_add_bdepend "
	$(tw dev-ruby/facter 3)
	$(tw dev-ruby/logging 2.0)
	$(tw dev-ruby/rake 13.0)
	$(tw dev-ruby/rake-compiler-dock 1.2)
	$(tw dev-ruby/rubocop 0.49.1)
	$(tw dev-ruby/signet 0.7)
	$(tw dev-ruby/simplecov 0.14.1)
	(
		<dev-ruby/googleauth-0.10
		>=dev-ruby/googleauth-0.5.1
	)
	(
		$(tw dev-ruby/rspec 3.6)
		dev-ruby/rspec:3
	)
	<=dev-ruby/rake-compiler-1.1.1
	test? (
		>=dev-ruby/bundler-1.9
	)
"
RDEPEND+="
	>=dev-libs/re2-0.2021.09.01
	>=net-dns/c-ares-1.17.2
	>=sys-libs/zlib-1.2.13
	~dev-cpp/abseil-cpp-20220623.0:=
"
BDEPEND+="
	$(gen_ruby_bdepend)
"
RESTRICT="mirror"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
EGIT_BORINGSSL_COMMIT="6195bf8242156c9a2fa75702eee058f91b86a88b"
SRC_URI="
https://github.com/grpc/grpc/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/google/boringssl/archive/${EGIT_BORINGSSL_COMMIT}.tar.gz
	-> boringssl-${EGIT_BORINGSSL_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/all/${GRPC_P}"
EGIT_REPO_URI="https://github.com/grpc/grpc.git"
EGIT_BRANCH="master"
EGIT_COMMIT="v${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-1.49.2-ruby-unvendor.patch"
	"${FILESDIR}/${PN}-1.51.1-ruby-embed-changes.patch"
	"${FILESDIR}/${PN}-1.51.1-ruby-unvendor-re2.patch"
	"${FILESDIR}/${PN}-1.51.1-ruby-unvendor-abseil.patch"
)

src_unpack() {
	ruby-ng_src_unpack
	cp -aT "${WORKDIR}/all/boringssl-${EGIT_BORINGSSL_COMMIT}" \
		"${WORKDIR}/all/${PN}-${PV}/third_party/boringssl-with-bazel" || die
}

all_ruby_prepare() {
	rm Gemfile || die
        sed -i \
		-e "/third_party/d" \
		-e "/bundler/d" \
		-e "/bundle /d" \
		Rakefile || die
}

src_install() {
	ruby-ng_src_install
	mv "${ED}/usr/share/doc/grpc-${PV}" \
		"${ED}/usr/share/doc/grpc-ruby-${PV}" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
