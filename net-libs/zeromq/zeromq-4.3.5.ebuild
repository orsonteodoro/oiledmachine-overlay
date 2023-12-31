# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib multilib-minimal

DESCRIPTION="A brokerless kernel"
HOMEPAGE="https://zeromq.org/"
LICENSE="MPL-2.0"
KEYWORDS="
~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390
sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
asan +curve curve_keygen doc drafts eventfd intrinsics +libbsd norm nss pgm
radix-tree +sodium static-libs test tls tsan tweetnacl ubsan vmci websockets
"
REQUIRED_USE+="
	!drafts? (
		!radix-tree
		!websockets
	)
	curve? (
		^^ (
			sodium
			tweetnacl
		)
	)
	curve_keygen? (
		curve
	)
	sodium? (
		curve
	)
	tls? (
		websockets
	)
	tweetnacl? (
		curve
	)
"
# U 22.04
RDEPEND+="
	libbsd? (
		>=dev-libs/libbsd-0.11.5[${MULTILIB_USEDEP}]
	)
	pgm? (
		>=net-libs/openpgm-5.3.128[${MULTILIB_USEDEP}]
	)
	norm? (
		>=net-libs/norm-1.5.9[${MULTILIB_USEDEP}]
	)
	nss? (
		>=dev-libs/nss-3[${MULTILIB_USEDEP}]
	)
	sodium? (
		>=dev-libs/libsodium-1.0.18:=[${MULTILIB_USEDEP},static-libs?]
	)
	tls? (
		>=net-libs/gnutls-3.7.3[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-util/cmake-3.22.1
	doc? (
		>=app-text/asciidoc-10.1.2
		>=app-text/xmlto-0.0.28
	)
"
SRC_URI="
https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz
"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.5-c99.patch"
)
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED=ON
		-DBUILD_STATIC=$(usex static-libs)
		-DENABLE_ASAN=$(usex asan)
		-DENABLE_CURVE=$(usex curve)
		-DENABLE_DRAFTS=$(usex drafts)
		-DENABLE_EVENTFD=$(usex eventfd)
		-DENABLE_INTRINSICS=$(usex intrinsics)
		-DENABLE_RADIX_TREE=$(usex radix-tree)
		-DENABLE_TSAN=$(usex asan)
		-DENABLE_UBSAN=$(usex ubsan)
		-DENABLE_WS=$(usex websockets)
		-DWITH_CURVE_KEYGEN=$(usex curve_keygen)
		-DWITH_DOCS=$(usex doc)
		-DWITH_LIBBSD=$(usex libbsd)
		-DWITH_LIBSODIUM=$(\
			usex curve \
				$(usex sodium) \
				"OFF" \
		)
		-DWITH_LIBSODIUM_STATIC=$(\
			usex curve \
				$(usex static-libs \
					$(usex sodium) \
					"OFF") \
				"OFF" \
		)
		-DWITH_NORM=$(usex norm)
		-DWITH_OPENPGM=$(usex pgm)
		-DWITH_VMCI=$(usex vmci)
	)

	if use websockets ; then
		mycmakeargs+=( -DWITH_TLS=$(usex tls) )
	fi

	cmake-multilib_src_configure
}

src_test() {
	# Restricting to one job because multiple tests are using the same port.
	# Upstream knows the problem and says it doesn't support parallel test
	# execution, see ${S}/INSTALL.
	MAKEOPTS="-j1" \
	cmake-multilib_src_test
}

src_install() {
	cmake-multilib_src_install
	find "${ED}" -type f -name '*.la' -delete || die
}
