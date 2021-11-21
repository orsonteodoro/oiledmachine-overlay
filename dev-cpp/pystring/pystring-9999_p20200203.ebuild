# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="C++ functions matching the interface and behavior of python string methods"
HOMEPAGE="https://github.com/imageworks/pystring"
LICENSE="BSD"

# Live ebuild snapshots do not get keyworded

SLOT="0/${PV}"
IUSE+=" custom-cflags doc test"
RDEPEND+="
	|| (
		sys-devel/gcc[cxx]
		sys-libs/libcxx
	)"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	|| (
		sys-devel/gcc[cxx]
		sys-devel/clang
	)
	sys-apps/grep
	sys-devel/libtool"
EGIT_COMMIT="281419de2f91f9e0f2df6acddfea3b06a43436be"
SRC_URI="
https://github.com/imageworks/pystring/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
DOCS=( README )

pkg_setup() {
	if use test ; then
		if [[ ${FEATURES} =~ test ]] ; then
			:;
		else
			die \
"You need to add FEATURES=test before running emerge/ebuild to run tests."
		fi
	fi
	if libtool --config | grep -q -e "linux-gnu/10.3.0" ; then
		einfo "Libtool & GCC compatibility:  Pass"
	else
		eerror "Libtool & GCC compatibility:  Fail"
		die "You need to \`emerge -1 libtool\` everytime GCC is updated."
	fi
}

src_prepare() {
	default
	sed -i -e '/.\/test/d' Makefile || die
}

src_configure() {
	sed -i -e "s|/usr/lib|/usr/$(get_libdir)|g" Makefile || die
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
