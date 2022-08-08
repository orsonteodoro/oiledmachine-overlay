# Copyright 2022 Orson Teodoro <orsonteododoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Enables PAM modules to be written in Python"
HOMEPAGE="http://pam-python.sourceforge.net/"
LICENSE="AGPL-3+"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Still needs testing
SLOT="0/${PV}"
IUSE+=" doc test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	sys-libs/pam
"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/future
	$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	doc? (
		$(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	)
	test? (
		$(python_gen_cond_dep 'dev-python/pypam[${PYTHON_USEDEP}]')
		dev-util/cmake
		sys-devel/gcc
	)
"
# The test modifies ${BROOT}/etc/pam.d.
SRC_URI=" mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( agpl-3.0.txt ChangeLog.txt README.txt )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.8-no-sudo.patch"
	"${FILESDIR}/${PN}-1.0.8-compiler-agnostic.patch"
	"${FILESDIR}/${PN}-1.0.8-agnostic-shebang.patch"
	"${FILESDIR}/${PN}-1.0.8-fix-build-dir.patch"
	"${FILESDIR}/${PN}-1.0.8-Makefile-EPYTHON.patch"

	# python3.8 compat
	"${FILESDIR}/${PN}-1.0.8-cast-value-as-char-ptr.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyUnicode_GET_LENGTH.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyType_Check.patch"

	# python3.9 compat
	"${FILESDIR}/${PN}-1.0.8-use-PyObject_Call.patch"
)

pkg_setup() {
	addwrite /etc/pam.d
	python-single-r1_pkg_setup
	if use test ; then
		if [[ "${FEATURES}" =~ (^| |"user")"sandbox" ]] ; then
eerror "FEATURES require per-package -sandbox and -usersandbox for testing"
eerror "FEATURES:  ${FEATURES}"
			die
		fi
	fi
}

src_prepare() {
	default
	# Breaks with python2.7
#	einfo "Futurizing py2 -> py3"
#	futurize -0 -w . || die
}

src_configure() {
#	sed -i -e "s|-O0|-O1|g" "src/Makefile" || die
	export CC=$(tc-getCC)
}

src_compile() {
	if use doc ; then
		emake doc
	fi
	emake lib
}

src_test() {
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD PYTHON-NO-CHANGE
