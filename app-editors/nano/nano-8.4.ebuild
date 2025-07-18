# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="gas inline"
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_USE_CASES="sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="PE"
# gnulib FPs \
QA_CONFIG_IMPL_DECL_SKIP=( "unreachable" "MIN" "static_assert" )

inherit cflags-hardened

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/nano.git"
	inherit autotools git-r3
else
	MY_P="${PN}-${PV/_}"
	SRC_URI="https://www.nano-editor.org/dist/v${PV:0:1}/${MY_P}.tar.xz"
	KEYWORDS="
~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc
x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
	"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="https://www.nano-editor.org/ https://wiki.gentoo.org/wiki/Nano/Guide"
LICENSE="
	GPL-3+
	LGPL-2.1+
	|| (
		GPL-3+
		FDL-1.2+
	)
"
SLOT="0"
IUSE="
debug justify magic minimal ncurses nls +spell unicode
ebuild_revision_16
"
REQUIRED_USE="
	magic? (
		!minimal
	)
"
RDEPEND="
	>=sys-libs/ncurses-5.9-r1:=[unicode(+)?]
	magic? (
		sys-apps/file
	)
	nls? (
		virtual/libintl
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	nls? (
		sys-devel/gettext
	)
	virtual/pkgconfig
"

src_prepare() {
	default

	if [[ "${PV}" == "9999" ]] ; then
		eautoreconf
	fi
}

src_configure() {
	cflags-hardened_append
	local myconfargs=(
		--bindir="${EPREFIX}/bin"
		--htmldir="/trash"
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable magic libmagic)
		$(use_enable spell speller)
		$(use_enable justify)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable unicode utf8)
		$(use_enable minimal tiny)
	)

	econf "${myconfargs[@]}"
}

src_install() {
	default

	# Don't use "${ED}" here or things break (#654534)
	rm -r "${D}/trash" || die

	dodoc "doc/sample.nanorc"
	docinto "html"
	dodoc "doc/faq.html"
	insinto "/etc"
	newins "doc/sample.nanorc" "nanorc"

	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}/etc/nanorc" || die

		# Since nano-5.0 these are no longer being "enabled" by default
		# (bug #736848)
		local rcdir="/usr/share/nano"
		mv "${ED}${rcdir}/extra/"* "${ED}/${rcdir}/" || die
		rmdir "${ED}${rcdir}/extra" || die

		insinto "${rcdir}"
		newins "${FILESDIR}/gentoo.nanorc-r1" "gentoo.nanorc"
	fi
}

pkg_postrm() {
	[[ -n ${REPLACED_BY_VERSION} ]] && return

	local e
	e=$(unset EDITOR; . "${EROOT}/etc/profile" &>/dev/null; echo "${EDITOR}")
	if [[ "${e##*/}" == "nano" ]]; then
ewarn "The EDITOR variable is still set to ${e}."
ewarn "You can update it with \"eselect editor\"."
	fi
}
