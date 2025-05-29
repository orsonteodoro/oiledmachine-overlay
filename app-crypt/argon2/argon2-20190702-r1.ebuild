# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data"

inherit cflags-hardened toolchain-funcs

# We don't list the 32 bit versions because of missing mitigations for those arches.
KEYWORDS="
~amd64 ~amd64-linux ~x64-macos
"
S="${WORKDIR}/phc-winner-${P}"
SRC_URI="
https://github.com/P-H-C/phc-winner-argon2/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Password hashing software that won the Password Hashing Competition (PHC)"
HOMEPAGE="https://github.com/P-H-C/phc-winner-argon2"
LICENSE="
	|| (
		Apache-2.0
		CC0-1.0
	)
"
SLOT="0/1"
IUSE="
static-libs
ebuild_revision_27
"
DOCS=(
	"argon2-specs.pdf" "CHANGELOG.md" "README.md"
)

src_prepare() {
	default
	if ! use static-libs; then
		sed -i \
			-e '/LIBRARIES =/s/\$(LIB_ST)//' \
			"Makefile" \
			|| die
	fi
	sed -i \
		-e 's/-g//' \
		-e 's/-march=\$(OPTTARGET)//' \
		-e 's/-O3//' \
		"Makefile" \
		|| die

	tc-export CC

	OPTTEST=1
	if use amd64 || use x86; then
		$(tc-getCPP) ${CFLAGS} ${CPPFLAGS} -P - <<-EOF &>/dev/null && OPTTEST=0
			#if defined(__SSE2__)
			true
			#else
			#error false
			#endif
		EOF
	fi
}

src_configure() {
	default
	cflags-hardened_append
}

src_compile() {
	emake \
		ARGON2_VERSION="0~${PV}" \
		LIBRARY_REL="$(get_libdir)" \
		OPTTEST="${OPTTEST}" \
		PREFIX="${EPREFIX}/usr"
}

src_test() {
	emake OPTTEST="${OPTTEST}" test
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		LIBRARY_REL="$(get_libdir)" \
		OPTTEST="${OPTTEST}" \
		install
	einstalldocs
	doman man/argon2.1
}
