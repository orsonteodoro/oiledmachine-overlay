# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE CRSH DOS HO IO OOBW"

PYTHON_COMPAT=( python3_{10..14} )

inherit autotools cflags-hardened python-any-r1 secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="6ecb04980813d693234190021bd1cf874c05b1b4"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/ArtifexSoftware/jbig2dec.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
https://github.com/ArtifexSoftware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
https://jbig2dec.sourceforge.net/ubc/jb2streams.zip
	)
	"
fi

DESCRIPTION="A decoder implementation of the JBIG2 image compression format"
HOMEPAGE="https://jbig2dec.com/"

LICENSE="AGPL-3"
SLOT="0/$(ver_cut 1-2)" #698428
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+=" png static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/unzip
		${PYTHON_DEPS}
	)
"
RDEPEND="png? ( >=media-libs/libpng-${LIBPNG_PV}:= )"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

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
	default

	if use test; then
		mkdir "${WORKDIR}/ubc" || die
		mv -v "${WORKDIR}"/*.jb2 "${WORKDIR}/ubc/" || die
		mv -v "${WORKDIR}"/*.bmp "${WORKDIR}/ubc/" || die
	fi

	# We only need configure.ac and config_types.h.in
	sed -i \
		-e '/^# do we need automake?/,/^autoheader/d' \
		-e '/echo "  $AUTOM.*/,$d' \
		autogen.sh \
		|| die "failed to modify autogen.sh"

	./autogen.sh || die
	eautoreconf
}

src_configure() {
	cflags-hardened_append
	econf \
		$(use_enable static-libs static) \
		$(use_with png libpng)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm {} + || die
}
