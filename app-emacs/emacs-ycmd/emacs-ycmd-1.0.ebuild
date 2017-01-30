# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils python-single-r1 elisp elisp-common

DESCRIPTION="A Geany plugin to support the ycmd code completion server"
HOMEPAGE=""
SRC_URI="https://github.com/abingham/emacs-ycmd/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-3"
IUSE="debug builtin company-mode flycheck eldoc next-error python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}/${PN}-${PV}"

DEPEND="${PYTHON_DEPS}
        dev-util/ycmd[${PYTHON_USEDEP}]
	company-mode? ( >=app-emacs/company-mode-0.9.0
                        app-emacs/f )
	flycheck? ( app-emacs/flycheck )
	eldoc? ( app-emacs/eldoc )
        app-emacs/let-alist
	app-emacs/s
	app-emacs/dash
	app-emacs/deferred
	app-emacs/request
	app-emacs/request-deferred"
RDEPEND="${DEPEND}"
SITEFILE="50emacs-ycmd-gentoo.el"

pkg_setup() {
	python-single-r1_pkg_setup
	elisp_pkg_setup
}

src_prepare() {
	cp "${FILESDIR}/${SITEFILE}" "${WORKDIR}"

	sed -i -e "s|python3.4|${EPYTHON}|g" "${WORKDIR}/${SITEFILE}"
	sed -i -e "s|lib64|$(get_libdir)|g" "${WORKDIR}/${SITEFILE}"

	if use debug ; then
		sed -i -e "s|GENTOO_DEBUG|(setq debug-on-error t)|g" "${WORKDIR}/${SITEFILE}"  || die
	else
		sed -i -e "s|GENTOO_DEBUG||g" "${WORKDIR}/${SITEFILE}"  || die
	fi

	if use next-error; then
		sed -i -e "s|GENTOO_NEXT_ERROR|$(cat ${FILESDIR}/next-error.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}"  || die
	else
		sed -i -e "s|GENTOO_NEXT_ERROR||g" "${WORKDIR}/${SITEFILE}" || die
	fi
	if use builtin ; then
		sed -i -e "s|GENTOO_BUILTIN|$(cat ${FILESDIR}/builtin.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}" || die
	else
		sed -i -e "s|GENTOO_BUILTIN||g" "${WORKDIR}/${SITEFILE}" || die
	fi
	if use company-mode ; then
		sed -i -e "s|GENTOO_COMPANY_MODE|$(cat ${FILESDIR}/company-mode.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}" || die
	else
		sed -i -e "s|GENTOO_COMPANY_MODE||g" "${WORKDIR}/${SITEFILE}" || die
	fi
	if use flycheck ; then
		sed -i -e "s|GENTOO_FLYCHECK|$(cat ${FILESDIR}/flycheck.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}" || die
	else
		sed -i -e "s|GENTOO_FLYCHECK||g" "${WORKDIR}/${SITEFILE}" || die
	fi
	if use eldoc ; then
		sed -i -e "s|GENTOO_ELDOC|$(cat ${FILESDIR}/eldoc.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}" || die
	else
		sed -i -e "s|GENTOO_ELDOC||g" "${WORKDIR}/${SITEFILE}" || die
	fi

	eapply_user
}

src_compile() {
	true
}

src_install() {
	elisp-install ${PN} *.el || die
	elisp-site-file-install "${WORKDIR}/${SITEFILE}" || die
	mkdir -p "${D}/${SITELISP}/${PN}"
	cp -a "contrib" "${D}/${SITELISP}/${PN}"
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
