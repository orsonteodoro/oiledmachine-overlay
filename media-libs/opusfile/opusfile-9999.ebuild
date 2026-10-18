# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"media-libs/libogg-9999"
	"media-libs/opus-9999"
)

inherit autotools cflags-hardened check-compiler-switch chkl flag-o-matic secure-version multilib-minimal

if [[ "${PV}" == "9999" ]] ; then
	FALLBACK_COMMIT="6dfd29e7adb87f2e193575fc3fa88cbf1a0b27df"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/opusfile.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"
fi

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="https://www.opus-codec.org/"
LICENSE="BSD"
SLOT="0/"$(ver_cut "1-2" "${PV}")
KEYWORDS="~amd64"
IUSE+="
doc fixed-point +float +http libressl static-libs
ebuild_revision_26
"
RDEPEND="
	>=media-libs/libogg-${LIBOGG_PV}:=[${MULTILIB_USEDEP}]
	>=media-libs/opus-${OPUS_PV}:=[${MULTILIB_USEDEP}]
	http? (
		!libressl? (
			$(secure-version_gen_openssl_depends)
		)
		libressl? (
			>=dev-libs/libressl-${LIBRESSL_PV}:=[${MULTILIB_USEDEP}]
		)
	)
"
DEPEND="
	${RDEPEND}
	doc? (
		app-text/doxygen
	)
"
REQUIRED_USE="
	^^ (
		fixed-point
		float
	)
"

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

}

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	chkl_check_many_timestamps
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable fixed-point)
		$(use_enable float)
		$(use_enable http)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
