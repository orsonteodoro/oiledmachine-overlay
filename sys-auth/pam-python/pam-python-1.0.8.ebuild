# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Enables PAM modules to be written in Python"
HOMEPAGE="http://pam-python.sourceforge.net/"
LICENSE="AGPL-3+"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Still needs testing
SLOT="0/${PV}"
IUSE+=" doc"
#IUSE+=" test"
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
"
BDEPEND_DISABLED+="
	test? (
		dev-util/cmake
		sys-devel/gcc
	)
" # test modifies ${BROOT}/etc/pam.d
SRC_URI=" mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( agpl-3.0.txt ChangeLog.txt README.txt )
# See also https://github.com/castlabs/pam-python/commits/master/src/pam_python.c
PATCHES=(
	"${FILESDIR}/${PN}-1.0.8-no-sudo.patch"
	"${FILESDIR}/${PN}-1.0.8-compiler-agnostic.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyType_Check.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyObject_Call.patch"
	"${FILESDIR}/${PN}-1.0.8-cast-value-as-char-ptr.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyUnicode_GET_LENGTH.patch"
	"${FILESDIR}/${PN}-1.0.8-self-assign-check.patch"
	"${FILESDIR}/${PN}-1.0.8-use-PyBytes_Size.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	for x in $(grep -r -l -F -e '#!/usr/bin/python2' "${S}") ; do
		einfo "Editing ${x}"
		sed -i -e "s|/usr/bin/python2|/usr/bin/python3|g" "${x}" || die
	done
	einfo "Futurizing py2 -> py3"
	futurize -0 -w . || die
}

src_configure() {
	sed -i -e "s|-O0|-O1|g" "src/Makefile" || die
	export CC=$(tc-getCC)
}

src_compile() {
	if use doc ; then
		emake doc
	fi
	emake lib
	cd src/build/lib.linux-$(uname -m)-${EPYTHON/python} || die
	cp -a pam_python*.so pam_python.so || die
}

src_test() {
	addwrite /etc/pam.d
	addwrite /etc/pam.d/test-pam_python.pam
	addwrite /etc/pam.d/test-pam_python-installed.pam
	emake test
}

src_install() {
#	These should be immediately removed on build error.
#	if use test ; then
#		[[ -e "/etc/pam.d/test-pam_python.pam" ]] && rm "/etc/pam.d/test-pam_python.pam"
#		[[ -e "/etc/pam.d/test-pam_python-installed.pam" ]] && rm "/etc/pam.d/test-pam_python-installed.pam"
#	fi
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
