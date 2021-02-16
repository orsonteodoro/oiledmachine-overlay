# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib
inherit multilib-minimal

DESCRIPTION="A brokerless kernel"
HOMEPAGE="https://zeromq.org/"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 \
~amd64-linux ~x86-linux ~x64-macos"
SLOT="0/5"
IUSE+=" asan +curve curve_keygen doc drafts eventfd intrinsics +libbsd norm \
nss pgm radix-tree +sodium static-libs test tls tsan tweetnacl ubsan vmci \
websockets"
REQUIRED_USE+=" !drafts? ( !radix-tree !websockets )
		curve? ( ^^ ( sodium tweetnacl ) )
		curve_keygen? ( curve )
		sodium? ( curve )
		tweetnacl? ( curve )
		tls? ( websockets )"
RESTRICT="!test? ( test )"
RDEPEND+=" libbsd? ( dev-libs/libbsd[${MULTILIB_USEDEP}] )
	pgm? ( ~net-libs/openpgm-5.2.122[${MULTILIB_USEDEP}] )
	sodium? ( dev-libs/libsodium:=[${MULTILIB_USEDEP},static-libs?] )
	norm? ( net-libs/norm[${MULTILIB_USEDEP}] )
	nss? ( >=dev-libs/nss-3[${MULTILIB_USEDEP}] )
	tls? ( >=net-libs/gnutls-3.6.7[${MULTILIB_USEDEP}] )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" >=dev-util/cmake-2.8.12
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	pgm? ( virtual/pkgconfig[${MULTILIB_USEDEP}] )"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

PATCHES=( "${FILESDIR}/zeromq-4.3.4-build-curve_keygen.patch" )

src_prepare() {
	cmake-utils_src_prepare
	multilib_copy_sources
}

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
		-DWITH_LIBSODIUM=$(usex curve $(usex sodium) "OFF")
		-DWITH_LIBSODIUM_STATIC=$(usex curve $(usex static-libs $(usex sodium) "OFF") "OFF")
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
	find "${ED}"/usr/lib* -name '*.la' -delete || die
}
