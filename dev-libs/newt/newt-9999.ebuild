# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="r$(ver_rs 1- -)"

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

PYTHON_COMPAT=( python3_{10..14} )

inherit autotools cflags-hardened python-r1 secure-version toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="facb7a34a7a36623c2c419a24aac83a5cffffba5"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${MY_PV}"
	EGIT_REPO_URI="https://pagure.io/newt.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/mlichvar/newt/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Redhat's Newt windowing toolkit development files"
HOMEPAGE="https://pagure.io/newt"

S=${WORKDIR}/${PN}-${MY_PV}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE+=" gpm python nls tcl"
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/popt-${POPT_PV}:=
	>=sys-libs/slang-${SLANG_PV}:=
	gpm? ( sys-libs/gpm:= )
	python? ( ${PYTHON_DEPS} )
	tcl? ( >=dev-lang/tcl-8.5:= )
	"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.52.23-gold.patch
	"${FILESDIR}"/${PN}-0.52.24-c99-fix.patch
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	sed -i Makefile.in \
		-e 's|-g -o|$(CFLAGS) $(LDFLAGS) -o|g' \
		-e 's|-shared -o|$(CFLAGS) $(LDFLAGS) &|g' \
		-e 's|instroot|DESTDIR|g' \
		-e 's|	make |	$(MAKE) |g' \
		-e "s|	ar |	$(tc-getAR) |g" \
		|| die "sed Makefile.in"

	if [[ -n ${LINGUAS} ]]; then
		local lang langs
		for lang in ${LINGUAS}; do
			test -r po/${lang}.po && langs="${langs} ${lang}.po"
		done
		sed -i po/Makefile \
			-e "/^CATALOGS = /cCATALOGS = ${langs}" \
			|| die "sed po/Makefile"
	fi

	default
	eautoreconf
}

src_configure() {
	cflags-hardened_append
	local versions=
	getversions() {
		versions+="${EPYTHON} "
	}
	use python && python_foreach_impl getversions

	econf \
		"$(use_with python '' "${versions}")" \
		$(use_with gpm gpm-support) \
		$(use_with tcl) \
		$(use_enable nls)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install
	use python && python_foreach_impl python_optimize

	dodoc peanuts.py popcorn.py tutorial.sgml
	doman whiptail.1
	einstalldocs

	# don't want static archives
	rm "${ED}"/usr/$(get_libdir)/libnewt.a || die
}
