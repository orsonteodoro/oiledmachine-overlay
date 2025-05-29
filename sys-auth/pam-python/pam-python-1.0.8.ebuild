# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Verified working with Python 3.10
# Verified working with Python 3.11

# Still needs testing.  Not confirmed working.
# It requires manual setup which has not been documented.

CFLAGS_HARDENED_VULNERABILITY_HISTORY="PE"
PYTHON_COMPAT=( "python3_"{8..11} ) # Originally for 2.7

inherit flag-o-matic python-single-r1 toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI=" mirror://sourceforge/${PN}/${P}.tar.gz"

DESCRIPTION="Enables PAM modules to be written in Python"
HOMEPAGE="http://pam-python.sourceforge.net/"
LICENSE="AGPL-3+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc test
ebuild_revision_7
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	sys-libs/pam
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/pypam[${PYTHON_USEDEP}]
		')
		dev-build/cmake
		sys-devel/gcc
	)
"
# The test modifies ${BROOT}/etc/pam.d.
DOCS=( "agpl-3.0.txt" "ChangeLog.txt" "README.txt" )
PATCHES=(
	"${FILESDIR}/${PN}-1.0.8-no-sudo.patch"
	"${FILESDIR}/${PN}-1.0.8-compiler-agnostic.patch"
	"${FILESDIR}/${PN}-1.0.8-agnostic-shebang.patch"
	"${FILESDIR}/${PN}-1.0.8-Makefile.patch"

	# python3.8 compat
	"${FILESDIR}/${PN}-1.0.8-cast-value-as-char-ptr.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyUnicode_GET_LENGTH.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyType_Check.patch"

	# python3.9 compat
	"${FILESDIR}/${PN}-1.0.8-use-PyObject_Call.patch"
)

pkg_setup() {
	addwrite "/etc/pam.d"
	python-single-r1_pkg_setup
	if use test ; then
		if [[ "${FEATURES}" =~ (^|" "|"user")"sandbox" ]] ; then
eerror "FEATURES require per-package -sandbox and -usersandbox for testing"
eerror "FEATURES:  ${FEATURES}"
			die
		fi
	fi
}

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

src_compile() {
	if use doc ; then
		emake doc
	fi
	emake lib
}

src_test() {
ewarn
ewarn "Tests only work with python2.7 and must be ran outside of emerge."
ewarn "Run test with \`EPYTHON=python2.7 make test\`."
ewarn "After completion, \`make clean\` to remove symlinks."
ewarn
ewarn "If the test fail, the following need to be manually removed:"
ewarn
ewarn "  /etc/pam.d/test-pam_python.pam"
ewarn "  /etc/pam.d/test-pam_python-installed.pam"
ewarn
	emake test
}

src_install() {
	if use doc ; then
		emake install-doc \
			DESTDIR="${D}" \
			DOCDIR="${EPREFIX}/usr/share/${P}"
	fi
	emake install-lib \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}/$(get_libdir)/security"
	einstalldocs
ewarn
ewarn "This package may require manual configuration which has not been"
ewarn "documented well."
ewarn
ewarn "Also, when you play with the pam.d files, it may break login, so be"
ewarn "careful and take precautions and make backups of the previous"
ewarn "setting(s)."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD PYTHON-NO-CHANGE
# OILEDMACHINE-OVERLAY-META-REVDEP:  howdy
