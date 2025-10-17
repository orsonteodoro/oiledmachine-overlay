# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit flag-o-matic meson libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/imageworks/pystring.git"
	FALLBACK_COMMIT="76a2024e132bcc83bec1ecfebeacd5d20d490bfe" # Jul 22, 2023
	inherit git-r3
else
	SRC_URI="FIXME"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="C++ functions matching the interface and behavior of Python string \
methods"
HOMEPAGE="https://github.com/imageworks/pystring"
LICENSE="BSD"
# Live ebuild snapshots do not get keyworded
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" custom-cflags doc test"
RDEPEND+="
	|| (
		sys-devel/gcc[cxx]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/libtool
	sys-apps/grep
	|| (
		sys-devel/gcc[cxx]
	)
"
DOCS=( "README.md" )

pkg_setup() {
	if use test ; then
		if [[ "${FEATURES}" =~ "test" ]] ; then
			:
		else
eerror
eerror "You need to add FEATURES=test before running emerge/ebuild to run"
eerror "tests."
eerror
			die
		fi
	fi
	local gcc_pv=$(\
		gcc --version \
		| head -n 1 \
		| grep -E -o "[0-9]+\.[0-9]+\.[0-9]+" \
		| head -n 1)
	if ver_test ${gcc_pv} -ge 11 ; then
		gcc_pv=$(ver_cut 1 ${gcc_pv})
	fi
	if libtool --config | grep -q -e "linux-gnu/${gcc_pv}" ; then
einfo
einfo "Libtool & GCC compatibility:  Pass"
einfo
	else
eerror
eerror "Libtool & GCC compatibility:  Fail"
eerror
eerror "Everytime GCC is updated, you need to..."
eerror "emerge -1o libtool && emerge -1O libtool"
eerror
		die
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
}

src_configure() {
	if use custom-cflags ; then
		:
	else
		strip-flags
		filter-flags -O*
	fi
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install
	docinto "licenses"
	dodoc "LICENSE"
	use doc && einstalldocs
}
