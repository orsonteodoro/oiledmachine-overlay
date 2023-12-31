# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
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
ycmd-43 ycmd-44 ycmd-45 ycmd-46 +ycmd-47 r1
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
		if [[ -z "${EYCMD_JDTLS_WORKSPACE_ROOT_PATH}" ]] ; then
eerror
eerror "You need to define EYCMD_JDTLS_WORKSPACE_ROOT_PATH as a"
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
	BD_ABS="${PYTHON_SITEDIR}/ycmd/${YCMD_SLOT}"
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

	sed -i \
		-e "s|__EPYTHON__|${EPYTHON}|g" \
		"${sitefile_path}" \
		|| die

	local debug_str=""
	if use debug ; then
		debug_str="(setq debug-on-error t)"
	else
		debug_str=""
	fi
	sed -i \
		-e "s|___YCMD-EMACS_DEBUG___|${debug_str}|g" \
		"${sitefile_path}" \
		|| die

	local next_error_str=""
	if use next-error; then
		next_error_str=$(cat "${FILESDIR}/next-error.frag" \
			| sed ':a;N;$!ba;s/\n/\\n/g')
	else
		next_error_str=""
	fi
	sed -i \
		-e "s#___YCMD-EMACS_NEXT_ERROR___#${next_error_str}#g" \
		"${sitefile_path}" \
		|| die

	local builtin_completion_str=""
	if use builtin-completion ; then
		builtin_completion_str=$(cat "${FILESDIR}/builtin-completion.frag" \
			| sed ':a;N;$!ba;s/\n/\\n/g')
	else
		builtin_completion_str=""
	fi
	sed -i \
		-e "s#___YCMD-EMACS_BUILTIN_COMPLETION___#${builtin_completion_str}#g" \
		"${sitefile_path}" \
		|| die

	local company_mode_str=""
	if use company-mode ; then
		company_mode_str=$(cat "${FILESDIR}/company-mode.frag" \
			| sed ':a;N;$!ba;s/\n/\\n/g')
	else
		company_mode_str=""
	fi
	sed -i -e "s#___YCMD-EMACS_COMPANY_MODE___#${company_mode_str}#g" \
		"${sitefile_path}" \
		|| die

	local flycheck_str=""
	if use flycheck ; then
		flycheck_str=$(cat "${FILESDIR}/flycheck.frag" \
			| sed ':a;N;$!ba;s/\n/\\n/g')
	else
		flycheck_str=""
	fi
	sed -i -e "s#___YCMD-EMACS_FLYCHECK___#${flycheck_str}#g" \
		"${sitefile_path}" || die

	local eldoc_str=""
	if use eldoc ; then
		eldoc_str=$(cat "${FILESDIR}/eldoc.frag" \
			| sed ':a;N;$!ba;s/\n/\\n/g')
	else
		eldoc_str=""
	fi
	sed -i \
		-e "s#___YCMD-EMACS_ELDOC___#${eldoc_str}#g" \
		"${sitefile_path}" \
		|| die

	local gopls_str=""
	if use system-gopls ; then
		gopls_str="${EPREFIX}/usr/bin/gopls"
	else
		gopls_str="${BD_ABS}/third_party/go/bin/gopls"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_GOPLS_ABSPATH___|${gopls_str}|g" \
		"${sitefile_path}" \
		|| die

	local gocode_str=""
	if use system-gocode ; then
		gocode_str="${EPREFIX}/usr/bin/gocode"
	else
		gocode_str="${BD_ABS}/third_party/gocode/gocode"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_GOCODE_ABSPATH___|${gocode_str}|g" \
		"${sitefile_path}" \
		|| die

	local godef_str=""
	if use system-godef ; then
		godef_str="${EPREFIX}/usr/bin/godef"
	else
		godef_str="${BD_ABS}/third_party/godef/godef"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_GODEF_ABSPATH___|${godef_str}|g" \
		"${sitefile_path}" \
		|| die

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
		-e "s|___YCMD-EMACS_JAVA_ABSPATH___|${jp}|g" \
		"${sitefile_path}" \
		|| die

	local jdtls_workspace_root_abspath_str=""
	local jdtls_extension_abspath_str=""
	if use system-jdtls ; then
		jdtls_workspace_root_abspath_str="${EYCMD_JDTLS_WORKSPACE_ROOT_PATH}"
		jdtls_extension_abspath_str="${EYCMD_JDTLS_EXTENSION_PATH}"
	else
		jdtls_workspace_root_abspath_str="${BD_ABS}/third_party/eclipse.jdt.ls/workspace"
		jdtls_extension_abspath_str="${BD_ABS}/third_party/eclipse.jdt.ls/extensions"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_JDTLS_WORKSPACE_ROOT_ABSPATH___|${jdtls_workspace_root_abspath_str}|g" \
		"${sitefile_path}" \
		|| die
	sed -i \
		-e "s|___YCMD-EMACS_JDTLS_EXTENSION_ABSPATH___|\"${jdtls_extension_abspath_str}\"|g" \
		"${sitefile_path}" \
		|| die

	local system_mono_str=""
	if use system-mono ; then
		system_mono_str="${EPREFIX}/usr/bin/mono"
	else
		system_mono_str="${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_MONO_ABSPATH___|${system_mono_str}|g" \
		"${sitefile_path}" \
		|| die

	local rosyln_abspath_str=""
	if use system-omnisharp ; then
		rosyln_abspath_str="${BD_ABS}/ycmd/completers/cs/omnisharp.sh"
	else
		if use ycmd-43 || use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
			rosyln_abspath_str="${BD_ABS}/third_party/omnisharp-roslyn/run"
		else
			rosyln_abspath_str=""
		fi
	fi
	sed -i \
		-e "s|___YCMD-EMACS_ROSLYN_ABSPATH___|${rosyln_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local racerd_abspath_str=""
	if use system-racerd ; then
		racerd_abspath_str="${EPREFIX}/usr/bin/racerd"
	else
		racerd_abspath_str="${BD_ABS}/third_party/racerd/racerd"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_RACERD_ABSPATH___|${racerd_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local rls_abspath_str=""
	if use system-rust ; then
		rls_abspath_str="${EPREFIX}/usr/bin/rls"
	else
		rls_abspath_str="${BD_ABS}/third_party/rls/bin/rls"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_RLS_ABSPATH___|${rls_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local rustc_abspath_str=""
	if use system-rust ; then
		rustc_abspath_str="${EPREFIX}/usr/bin/rustc"
	else
		rustc_abspath_str="${BD_ABS}/third_party/rls/bin/rustc"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_RUSTC_ABSPATH___|${rustc_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local tsserver_abspath_str=""
	if use system-typescript ; then
		tsserver_abspath_str="${EPREFIX}/usr/bin/tsserver"
	else
		tsserver_abspath_str="${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_TSSERVER_ABSPATH___|${tsserver_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local rust_abspath_str="${EPREFIX}/usr/share/rust/src"
	sed -i \
		-e "s|___YCMD-EMACS_RUST_ABSPATH___|${rust_abspath_str}|g" \
		"${sitefile_path}" \
		|| die


	local ycmd_dir_str="${BD_ABS}/ycmd"
	sed -i \
		-e "s|___YCMD-EMACS-YCMD-DIR___|${ycmd_dir_str}|g" \
		"${sitefile_path}" \
		|| die

	local python_abspath_str="${EPREFIX}/usr/bin/${EPYTHON}"
	sed -i \
		-e "s|___YCMD-EMACS_PYTHON_ABSPATH___|${python_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local ycm_extra_conf_abspath_str=""
	if [[ -n "${EYCMD_GLOBAL_YCM_EXTRA_CONF_PATH}" ]] ; then
		ycm_extra_conf_abspath_str="${EYCMD_GLOBAL_YCM_EXTRA_CONF_PATH}"
	else
		ycm_extra_conf_abspath_str="~/.ycm_extra_conf.py"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_GLOBAL_CONFIG_ABSPATH___|${ycm_extra_conf_abspath_str}|g" \
		"${sitefile_path}" \
		|| die

	local rust_tc_dir_str=""
	if use system-rust ; then
		rust_tc_dir_str="/usr"
	else
		rust_tc_dir_str="${BD_ABS}/third_party/rust-analyzer"
	fi
	sed -i \
		-e "s|___YCMD-EMACS_RUST_TC_DIR___|${rust_tc_dir_str}|g" \
		"${sitefile_path}" \
		|| die

	local ycmd_slot_str="${YCMD_SLOT}"
	sed -i \
		-e "s|___YCMD-EMACS_CORE_VERSION___|${ycmd_slot_str}|g" \
		"${sitefile_path}" \
		|| die
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
	if [[ -z "${EYCMD_GLOBAL_YCM_EXTRA_CONF_PATH}" ]] ; then
einfo
einfo "The global .ycm_extra_conf.py is now referenced at ~/.ycm_extra_conf.py."
einfo "This can be changed by setting EYCMD_GLOBAL_YCM_EXTRA_CONF_PATH as a"
einfo "per-package environment variable."
einfo
	fi
}

pkg_postrm() {
	elisp-site-regen
ewarn
# Design not implemented correctly.
# It should show the document before prompting.
ewarn "SECURITY:  Before answering y for loading .ycm_extra_conf.py, you need to"
ewarn "manually inspect the contents of that script for malicious code outside"
ewarn "of emacs before ycmd executes it."
ewarn
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
