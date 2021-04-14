# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit elisp eutils python-single-r1

DESCRIPTION="Emacs client for ycmd, the code completion system"
HOMEPAGE="https://github.com/abingham/emacs-ycmd"
LICENSE="MIT GPL-3+
	company-mode? ( GPL-3+ )
	flycheck? ( GPL-3+ )
	go-mode? ( BSD )
	rust-mode? ( MIT Apache-2.0 )
	typescript-mode? ( GPL-3+ )"
# The required dependencies are GPL-3+ but scripts or package alone itself is MIT.
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" builtin-completion +company-mode debug eldoc +flycheck +go-mode next-error \
+rust-mode system-gocode system-godef system-gopls system-omnisharp system-racerd \
system-rls system-rustc system-typescript +typescript-mode +ycmd-43"
REQUIRED_USE+="  ${PYTHON_REQUIRED_USE}
	^^ ( ycmd-43 )"
DEPEND+=" ${PYTHON_DEPS}
	ycmd-43? ( $(python_gen_cond_dep 'dev-util/ycmd:43[${PYTHON_USEDEP}]' python3_{6,7,8,9} ) )"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" net-misc/curl"
EGIT_COMMIT="bc81b992f79100c98f56b7b83caf64cb8ea60477"
SRC_URI=\
"https://github.com/abingham/emacs-ycmd/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
SITEFILE="50emacs-ycmd-gentoo.el"
PATCHES=( "${FILESDIR}/${PN}-1.3_p20191206-support-core-version-43.patch" )
BD_REL="ycmd/${SLOT}"
BD_ABS=""

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
	if ! use flycheck ; then
		sed -i -e 's|(depends-on "flycheck")||g' Cask || die
	fi
	if ! use company-mode ; then
		sed -i -e 's|(depends-on "company")||g' Cask || die
	fi
	if ! use go-mode ; then
		sed -i -e 's|(depends-on "go-mode")||g' Cask || die
	fi
	if ! use rust-mode ; then
		sed -i -e 's|(depends-on "rust-mode")||g' Cask || die
	fi
	if ! use typescript-mode ; then
		sed -i -e 's|(depends-on "typescript-mode")||g' Cask || die
	fi
	cask install
	cask build
	local ycmd_slot
	if use ycmd-43 ; then
		ycmd_slot=2
	fi
	BD_REL="ycmd/${ycmd_slot}"
	BD_ABS="$(python_get_sitedir)/${BD_REL}"
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

	if use system-gopls ; then
		sed -i -e "s|___YCMD-EMACS_GOPLS_ABSPATH___|/usr/bin/gopls|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GOPLS_ABSPATH___|\
${BD_ABS}/third_party/go/bin/gopls|g" \
			"${sitefile_path}" || die
	fi

	if use system-gocode ; then
		sed -i -e "s|___YCMD-EMACS_GOCODE_ABSPATH___|/usr/bin/gocode|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GOCODE_ABSPATH___|\
${BD_ABS}/third_party/gocode/gocode|g" \
			"${sitefile_path}" || die
	fi

	if use system-godef ; then
		sed -i -e "s|___YCMD-EMACS_GODEF_ABSPATH___|/usr/bin/godef|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GODEF_ABSPATH___|\
${BD_ABS}/third_party/godef/godef|g" \
			"${sitefile_path}" || die
	fi

	if use system-omnisharp ; then
		sed -i -e "s|\
___YCMD-EMACS_ROSLYN_ABSPATH___|\
${BD_ABS}/ycmd/completers/cs/omnisharp.sh|g" \
			"${sitefile_path}" || die
	else
		if use ycmd-43 ; then
			sed -i -e "s|\
___YCMD-EMACS_ROSLYN_ABSPATH___|\
${BD_ABS}/third_party/omnisharp-roslyn/run|g" \
			"${sitefile_path}" || die
		else
			die "ycmd-slot- not supported."
		fi
	fi

	if use system-racerd ; then
		sed -i -e "s|___YCMD-EMACS_RACERD_ABSPATH___|/usr/bin/racerd|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RACERD_ABSPATH___|\
${BD_ABS}/third_party/racerd/racerd|g" \
			"${sitefile_path}" || die
	fi

	if use system-rls ; then
		sed -i -e "s|___YCMD-EMACS_RLS_ABSPATH___|/usr/bin/rls|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RLS_ABSPATH___|\
${BD_ABS}/third_party/rls/bin/rls|g" \
			"${sitefile_path}" || die
	fi

	if use system-rustc ; then
		sed -i -e "s|___YCMD-EMACS_RUSTC_ABSPATH___|/usr/bin/rustc|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RUSTC_ABSPATH___|\
${BD_ABS}/third_party/rls/bin/rustc|g" \
			"${sitefile_path}" || die
	fi

	if use system-typescript ; then
		sed -i -e "s|___YCMD-EMACS_TSSERVER_ABSPATH___|/usr/bin/tsserver|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_TSSERVER_ABSPATH___|\
${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver|g" \
			"${sitefile_path}" || die
	fi

	if use ycmd-43 ; then
		sed -i -e "s|___YCMD-EMACS_CORE_VERSION___|43|g" \
			"${sitefile_path}" || die
	else
		die "Unsupported ycmd slot"
	fi

	sed -i -e "s|___YCMD-EMACS_RUST_ABSPATH___|/usr/share/rust/src|g" \
		"${sitefile_path}" || die

	sed -i -e "s|___YCMD-EMACS-YCMD-DIR___|${BD_ABS}/ycmd|g" \
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
	elisp-install ${PN} -r *.el *elc .cask contrib || die
	elisp-site-file-install "${sitefile_path}" || die
}

pkg_postinst() {
        elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
