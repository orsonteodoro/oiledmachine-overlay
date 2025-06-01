# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools check-compiler-switch flag-o-matic git-r3 multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
	FALLBACK_COMMIT="36cfdc18ed1fea1132cc4145e32b3645fcfb132b" # Feb 29, 2024
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/ianlancetaylor/libbacktrace.git"
else
	EGIT_COMMIT="14818b7783eeb9a56c3f0fca78cefd3143f8c5f6"
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/ianlancetaylor/libbacktrace/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"
LICENSE="
	custom
	BSD
	FSFULLRWD
	GPL-2+
	GPL-3+
	Libtool-exception
	MIT
	public-domain
"
# MIT, public-domain - master/install-sh
# FSFULLRWD - aclocal.m4
# GPL-2+ - test-driver
# GPL-3+ - move-if-change
SLOT="0"
IUSE+=" static-libs +system-libunwind test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	sys-devel/gcc
	virtual/libc
	system-libunwind? (
		sys-libs/libunwind[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		app-arch/xz-utils[${MULTILIB_USEDEP}]
		app-arch/zstd[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"
PATCHES=(
)
DOCS=( README.md )

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -r -e "This is version 1.0." "${S}/README.md" || die "Bump version"
	else
		unpack ${A}
	fi
	multilib_copy_sources
}

multilib_src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mymakeargs=(
		--enable-shared
		$(use_enable static{-libs,})
	)
	if use system-libunwind ; then
		mymakeargs+=(
			--with-system-libunwind
		)
	fi
	econf "${mymakeargs[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	einstalldocs
	docinto licenses
	dodoc LICENSE
}
