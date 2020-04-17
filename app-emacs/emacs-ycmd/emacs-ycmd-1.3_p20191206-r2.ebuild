# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Emacs client for ycmd, the code completion system"
HOMEPAGE="https://github.com/abingham/emacs-ycmd"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
SLOT="0"
inherit python-single-r1
IUSE="builtin-completion +company-mode debug eldoc +flycheck next-error \
system-gocode system-godef system-racerd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
YCMD_SLOT="1"
RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-util/ycmd:'${YCMD_SLOT}'[${PYTHON_USEDEP}]' python3_{6,7,8} )"
DEPEND="${RDEPEND}"
BDEPEND="net-misc/curl"
inherit eutils elisp
EGIT_COMMIT="386f6101fec6975000ad724f117816c01ab55f16"
SRC_URI=\
"https://github.com/abingham/emacs-ycmd/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
SITEFILE="50emacs-ycmd-gentoo.el"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to download\n\
the internal dependencies."
	fi
	python-single-r1_pkg_setup
	elisp_pkg_setup
}

install_deps() {
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go \
		| python || die
	export PATH="${HOME}/.cask/bin:$PATH"
	cask install
	cask build
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	install_deps
}

src_configure() {
	default
	cp "${FILESDIR}/${SITEFILE}" "${WORKDIR}"
	local sitefile_path="${WORKDIR}/${SITEFILE}"
	local python_sitedir="$(python_get_sitedir)"

	sed -i -e "s|__EPYTHON__|${EPYTHON}|g" \
		"${sitefile_path}"  || die

	if use debug ; then
		sed -i -e "s|___YCMD-EMACS_DEBUG___|(setq debug-on-error t)|g" \
			"${sitefile_path}"  || die
	else
		sed -i -e "s|___YCMD-EMACS_DEBUG___||g" \
			"${sitefile_path}"  || die
	fi

	if use next-error; then
		sed -i -e "s#\
___YCMD-EMACS_NEXT_ERROR___#\
$(cat ${FILESDIR}/next-error.frag | sed ':a;N;$!ba;s/\n/\\n/g')#g" \
			"${sitefile_path}"  || die
	else
		sed -i -e "s|___YCMD-EMACS_NEXT_ERROR___||g" \
			"${sitefile_path}" || die
	fi
	if use builtin-completion ; then
		sed -i -e "s#\
___YCMD-EMACS_BUILTIN_COMPLETION___#\
$(cat ${FILESDIR}/builtin-completion.frag | sed ':a;N;$!ba;s/\n/\\n/g')#g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|___YCMD-EMACS_BUILTIN_COMPLETION___||g" \
			"${sitefile_path}" || die
	fi
	if use company-mode ; then
		sed -i -e "s#\
___YCMD-EMACS_COMPANY_MODE___#\
$(cat ${FILESDIR}/company-mode.frag | sed ':a;N;$!ba;s/\n/\\n/g')#g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|___YCMD-EMACS_COMPANY_MODE___||g" \
			"${sitefile_path}" || die
	fi
	if use flycheck ; then
		sed -i -e "s#\
___YCMD-EMACS_FLYCHECK___#\
$(cat ${FILESDIR}/flycheck.frag | sed ':a;N;$!ba;s/\n/\\n/g')#g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|___YCMD-EMACS_FLYCHECK___||g" \
			"${sitefile_path}" || die
	fi
	if use eldoc ; then
		sed -i -e "s#\
___YCMD-EMACS_ELDOC___#\
$(cat ${FILESDIR}/eldoc.frag | sed ':a;N;$!ba;s/\n/\\n/g')#g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|___YCMD-EMACS_ELDOC___||g" \
			"${sitefile_path}" || die
	fi

	if use system-gocode ; then
		sed -i -e "s|___YCMD-EMACS_GOCODE_ABSPATH___|/usr/bin/gocode|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GOCODE_ABSPATH___|\
${python_sitedir}/ycmd/${YCMD_SLOT}/third_party/gocode/gocode|g" \
			"${sitefile_path}" || die
	fi

	if use system-godef ; then
		sed -i -e "s|___YCMD-EMACS_GODEF_ABSPATH___|/usr/bin/godef|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GODEF_ABSPATH___|\
${python_sitedir}/ycmd/${YCMD_SLOT}/third_party/godef/godef|g" \
			"${sitefile_path}" || die
	fi

	if use system-racerd ; then
		sed -i -e "s|___YCMD-EMACS_RACERD_ABSPATH___|/usr/bin/racerd|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RACERD_ABSPATH___|\
${python_sitedir}/ycmd/${YCMD_SLOT}/third_party/racerd/racerd|g" \
			"${sitefile_path}" || die
	fi

	sed -i -e "s|___YCMD-EMACS_RUST_ABSPATH___|/usr/share/rust/src|g" \
		"${sitefile_path}" || die

	sed -i -e "s|___YCMD-EMACS-YCMD-DIR___|${python_sitedir}/ycmd/${YCMD_SLOT}/ycmd|g" \
		"${sitefile_path}" || die

	sed -i -e "s|___YCMD-EMACS_PYTHON_ABSPATH___|/usr/bin/${EPYTHON}|g" \
		"${sitefile_path}" || die

	sed -i -e "s|___YCMD-EMACS_GLOBAL_CONFIG_ABSPATH___|/tmp/.ycm_extra_conf.py|g" \
		"${sitefile_path}" || die
}


src_compile() {
	:;
}

src_install() {
	local sitefile_path="${WORKDIR}/${SITEFILE}"
	if ! use company-mode ; then
		rm -rf .cask/$(elisp-emacs-version)/elpa/flycheck* || die
	fi
	if ! use flycheck ; then
		rm -rf .cask/$(elisp-emacs-version)/elpa/company* || die
	fi
	elisp-install ${PN} -r *.el *elc .cask contrib || die
	elisp-site-file-install "${sitefile_path}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
