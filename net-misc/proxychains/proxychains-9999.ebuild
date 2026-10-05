# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}-ng"
MY_P="${MY_PN}-${PV}"

inherit toolchain-funcs

if [[ "${PV}" == "9999" ]] ; then
	INTERNAL_PV="4.17"
	SOVER=$(ver_cut "1" "${INTERNAL_PV}")
	FALLBACK_COMMIT="afc3612b4142f17bb05c4ad2ebfed5e7f0939646"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/rofl0r/proxychains-ng.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut "1" "${PV}")
	KEYWORDS="~amd64 ~ppc ~riscv ~sparc ~x86"
	SRC_URI="
https://github.com/rofl0r/proxychains-ng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_P}"

DESCRIPTION="force any tcp connections to flow through a proxy (or proxy chain)"
HOMEPAGE="https://github.com/rofl0r/proxychains-ng/"
LICENSE="GPL-2"
SLOT="0/${SOVER}"
DOCS=( "README" "TODO" )
PATCHES=(
	"${FILESDIR}/${PN}-4.17-makefile.patch"
)

src_unpack() {
	if [[ "${PV}" == "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	if [[ "${PV}" == "9999" ]] ; then
		local actual_pv=$(cat "${S}/VERSION")
		local expected_pv="${INTERNAL_PV}"
		if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
eerror "QA:  Update INTERNAL_PV"
eerror "Actual PV:  ${actual_pv}"
eerror "Expected PV:  ${expected_pv}"
			die
		fi
	fi
	local actual_sover=$(cat "${S}/VERSION" | cut -f 1 -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump SOVER, PV, INTERNAL_PV"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default
	sed -i "s/^\(LDSO_SUFFIX\).*/\1 = so.${PV}/" Makefile || die
	mv completions/zsh/_proxychains4 completions/zsh/_proxychains || die
	tc-export CC
}

src_configure() {
	# not autotools
	./configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		|| die
}

src_install() {
	dobin "${PN}"
	dobin "${PN}-daemon"
	use docs && einstalldocs
	dodoc "AUTHORS"

	local libdir=$(get_libdir)
	local pv=""
	if [[ "${PV}" == "9999" ]] ; then
		pv="${INTERNAL_PV}"
	else
		pv="${PV}"
	fi
	dolib.so "lib${PN}.so.${pv}"
	dosym "lib${PN}.so.${pv}" "/usr/${libdir}/lib${PN}.so.${SOVER}"
	dosym "lib${PN}.so.${pv}" "/usr/${libdir}/lib${PN}.so"

	insinto "/etc"
	doins "src/${PN}.conf"
}
