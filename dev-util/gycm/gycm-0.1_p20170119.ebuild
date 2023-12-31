# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See gycm.cpp for versioning.

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake java-pkg-opt-2 python-single-r1 toolchain-funcs

DESCRIPTION="A Geany plugin to support the ycmd code completion server"
LICENSE="GPL-3"
HOMEPAGE="https://github.com/jakeanq/gycm"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="3abe1419d22ad19acbd96f66864ec00a0a256689"
SLOT="0"
IUSE+="
debug system-clangd system-gopls system-mono system-rust system-typescript
system-omnisharp +ycmd-47
r16
"
YCMD_SLOT_47_LLVM_PV=16.0.1
YCMD_SLOT_47_LLVM_PV_MAJ=$(ver_cut 1 ${YCMD_SLOT_47_LLVM_PV})
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	^^ (
		ycmd-47
	)
"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-libs/openssl-3
	dev-libs/jsoncpp
	dev-util/geany
	net-libs/libssh
	net-libs/neon
	system-clangd? (
		sys-devel/clang:${YCMD_SLOT_47_LLVM_PV_MAJ}
		sys-devel/llvm:${YCMD_SLOT_47_LLVM_PV_MAJ}
	)
	ycmd-47? (
		$(python_gen_cond_dep 'dev-util/ycmd:47[${PYTHON_USEDEP}]')
	)
"
RDEPEND+="
	${DEPEND}
"
SRC_URI="
https://github.com/jakeanq/gycm/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup() {
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
}

src_prepare() {
	cmake_src_prepare

	eapply "${FILESDIR}/${PN}-9999.20141216-missing-iostream.patch"
	eapply "${FILESDIR}/${PN}-0.1_p20170119-confirm-ycm-extra-conf.patch"
	local python_bin_path="${EPREFIX}/usr/bin/${EPYTHON}"
	sed -i \
		-e "s|\"python\"|\"${python_bin_path}\"|g" \
		ycmd.cpp \
		|| die
	sed -i \
		-e "s|\"/usr/bin/python\"|\"/${python_bin_path}\"|g" \
		config.cpp \
		|| die

	eapply "${FILESDIR}/${PN}-0.1_p20170119-python-unbuffered-io.patch"

	if use debug ; then
		eapply "${FILESDIR}/${PN}-9999-20141216-enable-debug-spew.patch"
		eapply "${FILESDIR}/${PN}-0.1_p20170119-enable-debug-spew-2.patch"
		eapply "${FILESDIR}/${PN}-9999.20141216-null-exception-check.patch"
		eapply "${FILESDIR}/${PN}-9999-20141216-debug-keep-log-files.patch"
	fi

	if use ycmd-47 ; then
		src_prepare_ycmd-47
	fi
}

src_prepare_ycmd-47() {
	local sitedir=$(python_get_sitedir)
	local ycmd_slot=47
	local ycmd_dir="${sitedir}/ycmd/${ycmd_slot}"
	eapply "${FILESDIR}/gycm-0.1_p20170119-init-struct-for-ycmd-core-version-47.patch"
	local json_config="${S}/ycmd.json"
	cat "${FILESDIR}/default_settings.json.47_7d8791d.json" > "${json_config}"

	local clang_includes_path=""
	if use system-clangd ; then
		clang_includes_path=$(realpath \
			${EPREFIX}/usr/lib/clang/${YCMD_SLOT_47_LLVM_PV_MAJ}*/include \
                        | sort \
			| tail -n 1)
	else
		clang_includes_path="${ycmd_dir}/third_party/clang/lib/clang/${YCMD_SLOT_47_LLVM_PV}/include"
	fi
	sed -i \
		-e "s|../llvm/tools/clang/include|${clang_includes_path}|g" \
		.ycm_extra_conf.py || die

	local global_ycmd_extra_conf=""
	if [[ -n "${GYCM_GLOBAL_YCMD_EXTRA_CONF}" ]] ; then
		global_ycmd_extra_conf="${GYCM_GLOBAL_YCMD_EXTRA_CONF}"
	else
		global_ycmd_extra_conf="~/.ycm_extra_conf.py"
	fi
	sed -i \
		-e "s|___GLOBAL_YCMD_EXTRA_CONF___|${global_ycmd_extra_conf}|g" \
		"${json_config}" \
		|| die

	local python_bin_path="${EPREFIX}/usr/bin/${EPYTHON}"
	sed -i \
		-e "s|___PYTHON_BIN_PATH___|${python_bin_path}|g" \
		"${json_config}" \
		|| die

	einfo "GYCM_JDTLS_WORKSPACE_ROOT_PATH:  ${GYCM_JDTLS_WORKSPACE_ROOT_PATH} (from package.env)"
	local java_jdtls_workspace_root_path="${GYCM_JDTLS_WORKSPACE_ROOT_PATH}"
	sed -i \
		-e "s|___JAVA_JDTLS_WORKSPACE_ROOT_PATH___|${java_jdtls_workspace_root_path}|g" \
		"${json_config}" \
		|| die

	local clangd_bin_path=""
	if use system-clangd ; then
		clangd_bin_path="/usr/lib/llvm/${YCMD_SLOT_47_LLVM_PV_MAJ}/bin/clangd"
	else
		clangd_bin_path="${ycmd_dir}/third_party/clangd/output/bin/clangd"
	fi
	sed -i \
		-e "s|___CLANGD_BIN_PATH___|${clangd_bin_path}|g" \
		"${json_config}" \
		|| die

	local gopls_bin_path=""
	if use system-gopls ; then
		gopls_bin_path="${EPREFIX}/usr/bin/gopls"
	else
		gopls_bin_path="${ycmd_dir}/third_party/go/bin/gopls"
	fi
	sed -i \
		-e "s|___GOPLS_BIN_PATH___|${gopls_bin_path}|g" \
		"${json_config}" \
		|| die

	local rust_toolchain_root=""
	if use system-rust ; then
		rust_toolchain_root="${EPREFIX}/usr/bin/rls"
	else
		rust_toolchain_root=""
	fi
	sed -i \
		-e "s|___RUST_TOOLCHAIN_ROOT___|${rust_toolchain_root}|g" \
		"${json_config}" \
		|| die

	local tsserver_bin_path=""
	if use system-typescript ; then
		tsserver_bin_path="${EPREFIX}/usr/bin/tsserver"
	else
		tsserver_bin_path="${ycmd_dir}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
	fi
	sed -i \
		-e "s|___TSSERVER_BIN_PATH___|${tsserver_bin_path}|g" \
		"${json_config}" \
		|| die

	local roslyn_bin_path=""
	if use system-omnisharp ; then
		roslyn_bin_path="${ycmd_dir}/ycmd/completers/cs/omnisharp.sh"
	else
		roslyn_bin_path="${ycmd_dir}/third_party/omnisharp-roslyn/run"
	fi
	sed -i \
		-e "s|___ROSLYN_BIN_PATH___|${roslyn_bin_path}|g" \
		"${json_config}" \
		|| die

	local mono_bin_path=""
	if use system-mono ; then
		mono_bin_path="${EPREFIX}/usr/bin/mono"
	else
		mono_bin_path="${ycmd_dir}/third_party/omnisharp-roslyn/bin/mono"
	fi
	sed -i \
		-e "s|___MONO_BIN_PATH___|${mono_bin_path}|g" \
		"${json_config}" \
		|| die

	local java_bin_path=""
        if use java ; then
                local java_vendor=$(java-pkg_get-vm-vendor)
                local java_slot
                if use ycmd-47 ; then
                        java_slot=17
		fi
		  if [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}"
		elif [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}"
		fi
		[[ -n "${jp}" ]] && jp="${jp}/bin/java"
		java_bin_path="${jp}"
	fi
	sed -i \
		-e "s|___JAVA_BIN_PATH___|${java_bin_path}|g" \
		"${json_config}" \
		|| die

	# Required by plugin.  DO NOT REMOVE.
	local ycmd_path="${ycmd_dir}"
	sed -i -e "s|___YCMD_PATH___|${ycmd_path}|g" \
		"${json_config}" \
		|| die
}

src_install() {
	exeinto "/usr/$(get_libdir)/geany"
	doexe "${S}_build/${PN}.so"
	insinto "/usr/share/${PN}"
	doins .ycm_extra_conf.py ycmd.json
}

pkg_postinst() {
einfo
einfo "You need two files .ycm_extra_conf.py and ycmd.json."
einfo
einfo "A .ycm_extra_conf.py template is copied to your /usr/share/${PN} and"
einfo "should be modified per project.  This file needs to be copied to your"
einfo "project's root containing your main configure script."
einfo
einfo "A copy of ycmd.json can be found as /usr/share/gycm/ycmd.json and should"
einfo "be copied to /home/<user>/.config/geany/plugins/gycm/ycmd.json."
einfo "C/C++/Objective C/Objective C++ users need to define"
einfo "/home/<user>/.config/geany/plugins/gycm/ycmd.json which the"
einfo "global_ycm_extra_conf property should be the full path pointing to your"
einfo "project's .ycm_extra_conf.py."
einfo
einfo "Consider emerging ycm-generator to generate a .ycm_extra_conf.py for"
einfo "your project.  This generated .ycm_extra_conf.py may need to be sligtly"
einfo "modified."
einfo
einfo "It may also crash Geany on startup if there is an undeclared variable."
einfo "Fix the errors first."
einfo
einfo "Geany may need to be restarted in order for completion to work after"
einfo "enabling the plugin."
einfo
	if [[ -z "${GYCM_GLOBAL_YCMD_EXTRA_CONF}" ]] ; then
einfo
einfo "The global .ycm_extra_conf.py path has been moved to"
einfo "~/.ycm_extra_conf.py.  This can be changed with the"
einfo "GYCM_GLOBAL_YCMD_EXTRA_CONF provided via package.env."
einfo
	fi

ewarn
ewarn "SECURITY:"
ewarn
ewarn "Please manually check .ycm_extra_conf.py every time before running geany"
ewarn "to avoid auto-running malicious code."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.1_p20170119 3abe141 with ycmd-47
# Note:  There is duplicate functionality so it is difficult to say if it is working.
# connect to ycmd - passed
# autocompletion (python) - passed
