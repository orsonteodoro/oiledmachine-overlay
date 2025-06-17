# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools check-compiler-switch flag-o-matic

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/rurban/safeclib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="safec libc extension with all C11 Annex K functions"
HOMEPAGE="
	https://rurban.github.io/safeclib/
	https://github.com/rurban/safeclib
"
LICENSE="MIT"
SLOT="0"
IUSE="
doc static-libs memmax-512mb strmax-8k
"
RDEPEND="
"
DEPEND="
"
BDEPEND="
	dev-build/autoconf:2.69
	dev-build/automake
	dev-build/libtool
	dev-build/make
	dev-perl/Text-Diff
	sys-apps/file
	sys-devel/gcc
	virtual/pkgconfig
"

pkg_setup() {
	check-compiler-switch_start
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Removing LTO."
		filter-lto
	fi
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Dedupe flags
	filter-flags \
		"-fstack-protector-strong" \
		"-fstack-clash-protection" \
		"-fcf-protection" \
		"-fno-strict-overflow" \
		"-fno-delete-null-pointer-checks" \
		"-fno-lifetime-dse"
	strip-flags
	replace-flags '-O*' '-O2'
	local myconf=(
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	if [[ -n "${SAFECLIB_MEMMAX}" ]] ; then
einfo "SAFECLIB_MEMMAX=${SAFECLIB_MEMMAX}"
		myconf+=(
			--enable-memmax=${SAFECLIB_MEMMAX}
		)
	elif use memmax-512mb ; then
einfo "SAFECLIB_MEMMAX=512MB"
		myconf+=(
			--enable-memmax=512MB
		)
	else
einfo "SAFECLIB_MEMMAX=256MB"
	fi

	if [[ -n "${SAFECLIB_STRMAX}" ]] ; then
einfo "SAFECLIB_STRMAX=${SAFECLIB_STRMAX}"
		myconf+=(
			--enable-strmax=${SAFECLIB_STRMAX}
		)
	elif use strmax-8k ; then
einfo "SAFECLIB_STRMAX=8K"
		myconf+=(
			--enable-strmax=8K
		)
	else
einfo "SAFECLIB_STRMAX=4K"
	fi
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
