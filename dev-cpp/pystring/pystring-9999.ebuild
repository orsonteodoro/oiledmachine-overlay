# Copyright 2020-2021,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/imageworks/pystring.git"
inherit flag-o-matic git-r3

DESCRIPTION="C++ functions matching the interface and behavior of python string \
methods"
LICENSE="BSD"
# Live ebuild snapshots do not get keyworded
HOMEPAGE="https://github.com/imageworks/pystring"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" custom-cflags doc test"
RDEPEND+="
	|| (
		sys-devel/gcc[cxx]
		sys-libs/libcxx
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	|| (
		sys-devel/gcc[cxx]
		sys-devel/clang
	)
	sys-apps/grep
	sys-devel/libtool
"
RESTRICT="mirror"
S="${WORKDIR}/${P}"
DOCS=( README )

pkg_setup() {
	if use test ; then
		if [[ ${FEATURES} =~ test ]] ; then
			:;
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
eerror "You need to \`emerge -1 libtool\` everytime GCC is updated."
eerror
		die
	fi
}

src_prepare() {
	default
	sed -i -e '/.\/test/d' Makefile || die
}

src_configure() {
	sed -i -e "s|/usr/lib|${ESYSROOT}/usr/$(get_libdir)|g" Makefile || die
	if use custom-cflags ; then
		sed -i -e "s|-O3|${CXXFLAGS}|g" \
		-e "s|CXXFLAGS =|CXXFLAGS = ${CXXFLAGS}|g" Makefile || die
	else
		strip-flags
		filter-flags -O*
	fi
}

src_compile() {
	emake LIBDIR="${S}" install
	use test && emake LIBDIR="${S}" test
	# Fix header location
	mkdir "${S}/pystring" || die
	mv "${S}/pystring.h" "${S}/pystring" || die
}

src_test() {
	cd "${S}" || die
	./test || die
}

src_install() {
	dolib.so "${S}/libpystring.so"{,.0{,.0.0}}
	doheader -r "${S}/pystring"
	docinto licenses
	dodoc LICENSE
	use doc && einstalldocs
}
