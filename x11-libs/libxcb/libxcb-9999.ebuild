# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="xml(+)"

XORG_MULTILIB=yes
XORG_DOC=doc

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="aa7f3256060451ad65a38feeccf792f44181a4e0"
fi

CHKL_TIMESTAMPS=(
	"x11-base/xcb-proto-9999"
)

inherit chkl python-any-r1 secure-version xorg-3

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb"

SLOT="0/1.12"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="
doc selinux test +xkb
ebuild_revision_1
"
RESTRICT="!test? ( test )"

XCB_PROTO_DEP=">=x11-base/xcb-proto-${PV}:="
RDEPEND="
	>=x11-libs/libXau-1.0.7-r1:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-${LIBXDMCP_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto:=
	${XCB_PROTO_DEP}
	elibc_Darwin? ( dev-libs/libpthread-stubs:= )
	test? ( dev-libs/check:=[${MULTILIB_USEDEP}] )
"
# Note: ${PYTHON_USEDEP} needs to go verbatim
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep "${XCB_PROTO_DEP}"'[${PYTHON_USEDEP}]')
	doc? ( app-text/doxygen[dot] )
	test? ( >=dev-libs/libxslt-${LIBXSLT_PV} )
"

python_check_deps() {
	python_has_version "${XCB_PROTO_DEP}[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	xorg-3_pkg_setup
}

src_configure() {
	chkl_check_many_timestamps
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc devel-docs)
		$(use_enable selinux)
	)
	xorg-3_src_configure
}
