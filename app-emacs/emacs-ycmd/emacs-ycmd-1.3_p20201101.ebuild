# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.2"
EMACS_SLOT="${NEED_EMACS%%.*}"
PYTHON_COMPAT=( python3_{8..11} )
inherit elisp java-pkg-opt-2 python-single-r1

DESCRIPTION="Emacs client for ycmd, the code completion system"
HOMEPAGE="https://github.com/abingham/emacs-ycmd"
LICENSE="
	MIT
	GPL-3+
	company-mode? (
		GPL-3+
	)
	flycheck? (
		GPL-3+
	)
	go-mode? (
		BSD
	)
	rust-mode? (
		Apache-2.0
		MIT
	)
	typescript-mode? (
		GPL-3+
	)
"
# The required dependencies are GPL-3+ but scripts or package alone itself is MIT.
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+="
builtin-completion +company-mode debug eldoc +flycheck +go-mode next-error
+rust-mode system-gocode system-godef system-gopls system-jdtls system-mono
system-omnisharp system-racerd system-rust system-typescript +typescript-mode
ycmd-43 ycmd-44 ycmd-45 ycmd-46 +ycmd-47
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	company-mode
	^^ (
		ycmd-43
		ycmd-44
		ycmd-45
		ycmd-47
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	>=app-editors/emacs-${NEED_EMACS}:${EMACS_SLOT}
	ycmd-43? (
		$(python_gen_cond_dep 'dev-util/ycmd:43[${PYTHON_USEDEP}]')
	)
	ycmd-44? (
		$(python_gen_cond_dep 'dev-util/ycmd:44[${PYTHON_USEDEP}]')
	)
	ycmd-45? (
		$(python_gen_cond_dep 'dev-util/ycmd:45[${PYTHON_USEDEP}]')
	)
	ycmd-46? (
		$(python_gen_cond_dep 'dev-util/ycmd:46[${PYTHON_USEDEP}]')
	)
	ycmd-47? (
		$(python_gen_cond_dep 'dev-util/ycmd:47[${PYTHON_USEDEP}]')
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-vcs/git
	net-libs/gnutls[tools]
"
EGIT_COMMIT="c17ff9e0250a9b39d23af37015a2b300e2f36fed"
SRC_URI="
https://github.com/abingham/emacs-ycmd/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
SITEFILE="50emacs-ycmd-gentoo.el"
BD_REL="ycmd/${SLOT}"
BD_ABS=""
PATCHES=(
	"${FILESDIR}/${PN}-1.3_p20191206-support-core-version-44.patch"
)

pkg_setup() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download the internal dependencies."
eerror
		die
	fi

	# No standard ebuild yet.
	if use system-jdtls ; then
		if [[ -z "${EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH}" ]] ; then
eerror
eerror "You need to define EYCMD_JDTLS_LANGUAGE_SERVER_HOME_PATH as a"
eerror "per-package envvar."
eerror
			die
		fi
	fi

	if use java ; then
		java-pkg-opt-2_pkg_setup
		local java_vendor=$(java-pkg_get-vm-vendor)
		if ! [[ "${java_vendor}" =~ "openjdk" ]] ; then
ewarn
ewarn "Java vendor mismatch.  Runtime failure or quirks may show."
ewarn
ewarn "Actual Java vendor:  ${java_vendor}"
ewarn "Expected java vendor:  openjdk"
ewarn
		fi
	fi

	python-single-r1_pkg_setup
	elisp_pkg_setup
	local actual_emacs_slot=$(ver_cut 1 $(elisp-emacs-version))
	local expected_emacs_slot="${EMACS_SLOT}"
	if ver_test ${actual_emacs_slot} -ne ${expected_emacs_slot} ; then
eerror
eerror "Change emacs slot via eselect emacs"
eerror
eerror "Actual slot:    ${actual_emacs_slot}"
eerror "Expected slot:  ${expected_emacs_slot}"
eerror
		die
	fi
}

install_deps() {
	git clone https://github.com/cask/cask ~/.cask
	export PATH="${HOME}/.cask/bin:$PATH"
	if ! use flycheck ; then
		sed -i -e 's|(depends-on "flycheck")||g' Cask || die
		sed -i -e 's|"flycheck-ycmd.el"||' Cask || die
	fi
	if ! use company-mode ; then
		sed -i -e 's|(depends-on "company")||g' Cask || die
		sed -i -e 's|"company-ycmd.el"||' Cask || die
	fi
	if ! use eldoc ; then
		sed -i -e 's|"ycmd-eldoc.el"||' Cask || die
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
	if ! use next-error ; then
		sed -i -e 's|"contrib/ycmd-next-error.el"||' Cask || die
		rm -rf "contrib/ycmd-next-error.el" || die
	fi
	cask install
	cask build
	if use ycmd-43 ; then
		export YCMD_SLOT=43
	elif use ycmd-44 ; then
		export YCMD_SLOT=44
	elif use ycmd-45 ; then
		export YCMD_SLOT=45
	elif use ycmd-46 ; then
		export YCMD_SLOT=46
	elif use ycmd-47 ; then
		export YCMD_SLOT=47
	fi
	BD_REL="ycmd/${YCMD_SLOT}"
	BD_ABS="$(python_get_sitedir)/${BD_REL}"
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	install_deps
}

src_configure() {
	default
	cp "${FILESDIR}/${SITEFILE}" "${WORKDIR}"
	local sitefile_path="${WORKDIR}/${SITEFILE}"

	sed -i -e "s|__EPYTHON__|${EPYTHON}|g" \
		"${sitefile_path}"  || die

	if use debug ; then
		sed -i -e "s|\
___YCMD-EMACS_DEBUG___|\
(setq debug-on-error t)|g" \
			"${sitefile_path}"  || die
	else
		sed -i -e "s|\
___YCMD-EMACS_DEBUG___|\
|g" \
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
		sed -i -e "s|\
___YCMD-EMACS_ELDOC___|\
|g" \
			"${sitefile_path}" || die
	fi

	if use system-gopls ; then
		sed -i -e "s|\
___YCMD-EMACS_GOPLS_ABSPATH___|\
${EPREFIX}/usr/bin/gopls|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GOPLS_ABSPATH___|\
${BD_ABS}/third_party/go/bin/gopls|g" \
			"${sitefile_path}" || die
	fi

	if use system-gocode ; then
		sed -i -e "s|\
___YCMD-EMACS_GOCODE_ABSPATH___|\
${EPREFIX}/usr/bin/gocode|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GOCODE_ABSPATH___|\
${BD_ABS}/third_party/gocode/gocode|g" \
			"${sitefile_path}" || die
	fi

	if use system-godef ; then
		sed -i -e "s|\
___YCMD-EMACS_GODEF_ABSPATH___|\
${EPREFIX}/usr/bin/godef|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_GODEF_ABSPATH___|\
${BD_ABS}/third_party/godef/godef|g" \
			"${sitefile_path}" || die
	fi

	local jp=""

	if use java ; then
		local java_vendor=$(java-pkg_get-vm-vendor)
		local java_slot
		if use ycmd-46 || use ycmd-47 ; then
			java_slot=17
		elif use ycmd-44 || use ycmd-45 ; then
			java_slot=11
		else
			java_slot=8
		fi
		  if [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}"
		elif [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}"
		fi
		[[ -n "${jp}" ]] && jp="${jp}/bin/java"
	fi
	sed -i \
		-e "s|\
___YCMD-EMACS_JAVA_ABSPATH___|\
${jp}|g" \
		"${sitefile_path}" \
		|| die

	if use system-jdtls ; then
		sed -i \
			-e "s|\
___YCMD-EMACS_JDTLS_WORKSPACE_ROOT_ABSPATH___|\
${EYCMD_JDTLS_WORKSPACE_ROOT_PATH}|g" \
			"${sitefile_path}" \
			|| die
		sed -i \
			-e "s|\
___YCMD-EMACS_JDTLS_EXTENSION_ABSPATH___|\
${EYCMD_JDTLS_EXTENSION_PATH}|g" \
			"${sitefile_path}" \
			|| die
	else
		sed -i \
			-e "s|\
___YCMD-EMACS_JDTLS_WORKSPACE_ROOT_ABSPATH___|\
${BD_ABS}/third_party/eclipse.jdt.ls/workspace|g" \
			"${sitefile_path}" \
			|| die
		sed -i \
			-e "s|\
___YCMD-EMACS_JDTLS_EXTENSION_ABSPATH___|\
\"${BD_ABS}/third_party/eclipse.jdt.ls/extensions\"|g" \
			"${sitefile_path}" \
			|| die
	fi

	if use system-mono ; then
		sed -i \
			-e "s|\
___YCMD-EMACS_MONO_ABSPATH___|\
${EPREFIX}/usr/bin/mono|g" \
			"${sitefile_path}" \
			|| die
	else
		sed -i \
			-e "s|\
___YCMD-EMACS_MONO_ABSPATH___|\
${BD_ABS}/third_party/omnisharp-roslyn/bin/mono|g" \
			"${sitefile_path}" \
			|| die
	fi

	if use system-omnisharp ; then
		sed -i -e "s|\
___YCMD-EMACS_ROSLYN_ABSPATH___|\
${BD_ABS}/ycmd/completers/cs/omnisharp.sh|g" \
			"${sitefile_path}" \
			|| die
	else
		if use ycmd-43 || use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
			sed -i -e "s|\
___YCMD-EMACS_ROSLYN_ABSPATH___|\
${BD_ABS}/third_party/omnisharp-roslyn/run|g" \
				"${sitefile_path}" \
				|| die
		else
			die "ycmd-slot- not supported."
		fi
	fi

	if use system-racerd ; then
		sed -i -e "s|\
___YCMD-EMACS_RACERD_ABSPATH___|\
${EPREFIX}/usr/bin/racerd|g" \
			"${sitefile_path}" \
			|| die
	else
		sed -i -e "s|\
___YCMD-EMACS_RACERD_ABSPATH___|\
${BD_ABS}/third_party/racerd/racerd|g" \
			"${sitefile_path}" || die
	fi

	if use system-rust ; then
		sed -i -e "s|\
___YCMD-EMACS_RLS_ABSPATH___|\
${EPREFIX}/usr/bin/rls|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RLS_ABSPATH___|\
${BD_ABS}/third_party/rls/bin/rls|g" \
			"${sitefile_path}" || die
	fi

	if use system-rust ; then
		sed -i -e "s|\
___YCMD-EMACS_RUSTC_ABSPATH___|\
${EPREFIX}/usr/bin/rustc|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RUSTC_ABSPATH___|\
${BD_ABS}/third_party/rls/bin/rustc|g" \
			"${sitefile_path}" || die
	fi

	if use system-typescript ; then
		sed -i -e "s|\
___YCMD-EMACS_TSSERVER_ABSPATH___|\
${EPREFIX}/usr/bin/tsserver|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_TSSERVER_ABSPATH___|\
${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver|g" \
			"${sitefile_path}" || die
	fi

	sed -i -e "s|\
___YCMD-EMACS_RUST_ABSPATH___|\
${EPREFIX}/usr/share/rust/src|g" \
		"${sitefile_path}" || die

	sed -i -e "s|\
___YCMD-EMACS-YCMD-DIR___|\
${BD_ABS}/ycmd|g" \
		"${sitefile_path}" || die

	sed -i -e "s|\
___YCMD-EMACS_PYTHON_ABSPATH___|\
${EPREFIX}/usr/bin/${EPYTHON}|g" \
		"${sitefile_path}" || die

	sed -i -e "s|\
___YCMD-EMACS_GLOBAL_CONFIG_ABSPATH___|\
/tmp/.ycm_extra_conf.py|g" \
		"${sitefile_path}" || die

	if use system-rust ; then
		sed -i -e "s|\
___YCMD-EMACS_RUST_TC_DIR___|\
/usr|g" \
			"${sitefile_path}" || die
	else
		sed -i -e "s|\
___YCMD-EMACS_RUST_TC_DIR___|\
${BD_ABS}/third_party/rust-analyzer|g" \
			"${sitefile_path}" || die
	fi

	sed -i -e "s|\
___YCMD-EMACS_CORE_VERSION___|\
${YCMD_SLOT}|g" \
		"${sitefile_path}" || die
}


src_compile() {
	:;
}

src_install() {
	local sitefile_path="${WORKDIR}/${SITEFILE}"
	elisp-install ${PN} -r *.el *elc .cask contrib || die
	elisp-site-file-install "${sitefile_path}" || die
	dosym /usr/bin/emacs-${EMACS_SLOT} /usr/bin/${PN}
}

pkg_postinst() {
        elisp-site-regen
	if ! use company-mode ; then
ewarn
ewarn "company-mode is strongly recommended for popup suggestions."
ewarn
	fi
einfo
einfo "Keybindings can be found in"
einfo
einfo "  https://github.com/abingham/emacs-ycmd/blob/master/ycmd.el#L610"
einfo
ewarn
ewarn "You must use /usr/bin/emacs-${EMACS_SLOT} or /usr/bin/${PN} in order for"
ewarn "${PN} to work."
ewarn
}

pkg_postrm() {
	elisp-site-regen
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.3_p20201101 c17ff9e (20230629) with emacs 27.2, ycmd-47
# USE="company-mode ycmd-47 -builtin-completion (-debug) -eldoc -flycheck
# -go-mode -java -next-error -rust-mode -system-gocode -system-godef
# -system-gopls -system-jdtls -system-mono -system-omnisharp -system-racerd
# -system-rust -system-typescript -typescript-mode -ycmd-43 -ycmd-44 -ycmd-45
# -ycmd-46"
# PYTHON_SINGLE_TARGET="python3_10 -python3_11"
# popup - passed
# python completion - passed
# python arg documentation - passed
# GoToDefinition - passed			# Use C-c Y gD
# GetDoc - passed				# Use C-c Y x GetDoc /usr/bin/python3.10
