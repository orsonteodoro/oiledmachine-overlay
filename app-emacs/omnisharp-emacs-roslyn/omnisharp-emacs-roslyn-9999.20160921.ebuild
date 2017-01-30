# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp elisp-common git-r3

DESCRIPTION="omnisharp-emacs is a port of the awesome omnisharp-roslyn server to the Emacs text editor.  This is the Roslyn feature branch."
HOMEPAGE=""
SRC_URI=""
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="debug company-mode example-config net46 netcore10"
REQUIRED_USE="^^ ( net46 netcore10 ) "
EGIT_REPO_URI="https://github.com/OmniSharp/omnisharp-emacs.git"
EGIT_BRANCH="feature-omnisharp-roslyn-support"
EGIT_COMMIT="b9014a1655ce0d62712591688f3f3885551beb0b"
S="${WORKDIR}/${PN}-${PV}"

DEPEND="!dev-dotnet/omnisharp-emacs
	company-mode? ( >=app-emacs/company-mode-0.9.0 )
	app-emacs/flycheck
	app-emacs/s
	app-emacs/dash
	app-emacs/deferred
        app-emacs/csharp-mode
	app-emacs/popup-el
	app-emacs/shut-up
	=dev-dotnet/omnisharp-roslyn-9999.20170111
	=dev-dotnet/dotnet-cli-1.0.0.2.2.0.003131
        app-emacs/auto-complete
	example-config? ( app-emacs/evil )
	net-misc/curl"
RDEPEND="${DEPEND}"
SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	ewarn "This package is for package developers only and future package maintainer.  It functions but doesn't work."
	elisp_pkg_setup
}

src_prepare() {
	cp "${FILESDIR}/${SITEFILE}" "${WORKDIR}"

	if use debug ; then
		sed -i -e "s|GENTOO_DEBUG|(setq debug-on-error t)\n(setq omnisharp-debug t)\n|g" "${WORKDIR}/${SITEFILE}"  || die
	else
		sed -i -e "s|GENTOO_DEBUG||g" "${WORKDIR}/${SITEFILE}"  || die
	fi

	sed -i -e "s|GENTOO_OMNISHARP_PATH|/usr/share/emacs/site-lisp/${PN}/omnisharp.sh|" "${WORKDIR}/${SITEFILE}"
	sed -i -e "s|GENTOO_CURL_PATH|/usr/bin/curl|" "${WORKDIR}/${SITEFILE}"

	if use company-mode ; then
		sed -i -e "s|GENTOO_COMPANY_MODE_INTEGRATION|$(cat ${FILESDIR}/company-mode-integration.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}"  || die
		sed -i -e "s|GENTOO_COMPANY_MODE|$(cat ${FILESDIR}/company-mode.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}" || die
	else
		sed -i -e "s|GENTOO_COMPANY_MODE_INTEGRATION||g" "${WORKDIR}/${SITEFILE}"  || die
		sed -i -e "s|GENTOO_COMPANY_MODE||g" "${WORKDIR}/${SITEFILE}" || die
	fi

	if use example-config ; then
		sed -i -e "s|GENTOO_EXAMPLE_CONFIG|$(cat ${FILESDIR}/example-config.frag | sed ':a;N;$!ba;s/\n/\\n/g')|g" "${WORKDIR}/${SITEFILE}"  || die
	else
		sed -i -e "s|GENTOO_EXAMPLE_CONFIG||g" "${WORKDIR}/${SITEFILE}"  || die
	fi

	if use net46 ; then
		FRAMEWORK_FOLDER="net46"
		cp "${FILESDIR}/omnisharp.sh.net46" "${WORKDIR}"/omnisharp.sh
		sed -i -e "s|GENTOO_OMNISHARP_ROSLYN_NET46_PATH|/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" "${WORKDIR}"/omnisharp.sh
	elif use netcore10 ; then
		NETCORE_VERSION="1.0.1"
		FRAMEWORK_FOLDER="netcoreapp1.0"
		cp "${FILESDIR}/omnisharp.sh.netcore10" "${WORKDIR}"/omnisharp.sh
		sed -i -e "s|GENTOO_DOTNET_CLI_NETCORE_PATH|/opt/dotnet_cli/shared/Microsoft.NETCore.App/${NETCORE_VERSION}|g" "${WORKDIR}"/omnisharp.sh
		sed -i -e "s|GENTOO_OMNISHARP_ROSLYN_NETCORE10_PATH|/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" "${WORKDIR}"/omnisharp.sh
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
	cp -a "src" "${D}/${SITELISP}/${PN}"
	cp -a "${WORKDIR}/omnisharp.sh" "${D}/${SITELISP}/${PN}"
	chmod 755 "${D}/${SITELISP}/${PN}/omnisharp.sh"
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
