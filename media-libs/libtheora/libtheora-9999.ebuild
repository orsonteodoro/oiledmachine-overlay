# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DOS IO"

CHKL_TIMESTAMPS=(
	"media-libs/libogg-9999"
	"media-libs/libpng-9999"
	"media-libs/libvorbis-9999"
)

inherit autotools cflags-hardened chkl multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="28fd5ec77f0ad0e07a371cef1047828116f6bd8a"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/theora.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/${P/_}"
	SRC_URI="
https://downloads.xiph.org/releases/theora/${P/_}.tar.xz
https://gitlab.xiph.org/xiph/theora/-/raw/v${PV}/lib/arm/armenc.c -> ${P}-armenc.c
https://gitlab.xiph.org/xiph/theora/-/raw/v${PV}/lib/arm/armloop.s -> ${P}-armloop.s
	"
fi

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="https://www.theora.org"
# Workaround for https://gitlab.xiph.org/xiph/theora/-/issues/2338 (arm
# files missing from dist tarball):

LICENSE="BSD"
SOVER="2"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE+="
doc +encode examples static-libs
ebuild_revision_9
"

REQUIRED_USE="examples? ( encode )" # bug #285895

RDEPEND="
	>=media-libs/libogg-9999:=[${MULTILIB_USEDEP}]
	encode? ( >=media-libs/libvorbis-9999:=[${MULTILIB_USEDEP}] )
	examples? (
		>=media-libs/libpng-1.6.57:=
		>=media-libs/libsdl-0.11.0:=
		>=media-libs/libvorbis-9999:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

VARTEXFONTS=${T}/fonts

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-flags.patch
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
	local c=$(grep "THDEC_LIB_CURRENT" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "=")
	local a=$(grep "THDEC_LIB_AGE" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "=")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if [[ "${actual_sover}" != "${expected_sover}" ]] ; then
eerror "QA:  Bump the subslot to ${actual_sover}"
eerror "Actual sover:  ${actual_sover}"
eerror "Expected sover:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default

	if ! [[ "${PV}" =~ "9999" ]] ; then
		# Workaround for broken 1.2.0 dist tarball
		cp "${DISTDIR}"/${P}-armenc.c lib/arm/armenc.c || die
		cp "${DISTDIR}"/${P}-armloop.s lib/arm/armloop.s || die
	fi

	eautoreconf
}

multilib_src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	local myconf=(
		# --disable-spec because LaTeX documentation has been prebuilt
		# ditto docs
		--disable-doc
		--disable-spec
		$(use_enable encode)
		$(multilib_native_use_enable examples)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if multilib_is_native_abi && use examples ; then
		dobin examples/.libs/png2theora

		local bin
		for bin in dump_{psnr,video} {encoder,player}_example; do
			newbin examples/.libs/${bin} theora_${bin}
		done
	fi
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	einstalldocs

	if use examples ; then
		docinto examples
		dodoc examples/*.[ch]
		docompress -x /usr/share/doc/${PF}/examples
		docinto .
	fi
}
