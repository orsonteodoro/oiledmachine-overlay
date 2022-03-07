# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See gycm.cpp for versioning.

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-utils eutils python-single-r1 toolchain-funcs

DESCRIPTION="A Geany plugin to support the ycmd code completion server"
LICENSE="GPL-3"
HOMEPAGE="https://github.com/jakeanq/gycm"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="3abe1419d22ad19acbd96f66864ec00a0a256689"
SLOT="0"
IUSE+=" debug system-clangd system-gocode system-godef system-libclang
system-racerd ycmd-43"
YCMD_SLOT_43_LLVM_V=10.0
YCMD_SLOT_43_LLVM_V_MAJ=$(ver_cut 1 ${YCMD_SLOT_43_LLVM_V})
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	^^ ( ycmd-43 )"
DEPEND+=" ${PYTHON_DEPS}
        dev-libs/jsoncpp
        dev-libs/openssl
	dev-util/geany
        net-libs/libssh
        net-libs/neon
	system-libclang? (
		sys-devel/clang:${YCMD_SLOT_43_LLVM_V_MAJ}
		sys-devel/llvm:${YCMD_SLOT_43_LLVM_V_MAJ}
	)
	ycmd-43? ( $(python_gen_cond_dep 'dev-util/ycmd:43[${PYTHON_USEDEP}]') )"
RDEPEND+=" ${DEPEND}"
SRC_URI="
https://github.com/jakeanq/gycm/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	cmake-utils_src_prepare

	eapply "${FILESDIR}/${PN}-9999.20141216-missing-iostream.patch"
	sed -i -e "s|\
\"python\"|\
\"/usr/bin/${EPYTHON}\"|g" ycmd.cpp || die
	sed -i -e "s|\
\"/usr/bin/python\"|\
\"/usr/bin/${EPYTHON}\"|g" config.cpp || die

	eapply "${FILESDIR}/${PN}-0.1_p20170119-python-unbuffered-io.patch"

	if use debug ; then
		eapply "${FILESDIR}/${PN}-9999-20141216-enable-debug-spew.patch"
		eapply "${FILESDIR}/${PN}-0.1_p20170119-enable-debug-spew-2.patch"
		eapply "${FILESDIR}/${PN}-9999.20141216-null-exception-check.patch"
		eapply "${FILESDIR}/${PN}-9999-20141216-debug-keep-log-files.patch"
	fi

	if use ycmd-43 ; then
		src_prepare_ycmd-43
	fi
}

src_prepare_ycmd-43() {
	local sitedir=$(python_get_sitedir)
	local ycmd_slot=2
	local ycmd_dir="${sitedir}/ycmd/${ycmd_slot}"
	eapply \
"${FILESDIR}/gycm-0.1_p20170119-init-struct-for-ycmd-core-version-42.patch"
	if use system-libclang ; then
		sed -i -e "s|\
../llvm/tools/clang/include|\
$(realpath /usr/lib/clang/${YCMD_SLOT_43_LLVM_V_MAJ}.*/include \
			| sort | tail -n 1)|g" \
			.ycm_extra_conf.py || die
	else
		sed -i -e "s|\
../llvm/tools/clang/include|\
${ycmd_dir}/third_party/clang/lib/clang/9.0.0/include|g" \
			.ycm_extra_conf.py || die
	fi
	local json_config="${S}/ycmd.json"
	cat "${FILESDIR}/default_settings.json.42_p20200108" > "${json_config}"
	sed -i -e "s|___PYTHON_BIN_PATH___|/usr/bin/${EPYTHON}|g" \
		"${json_config}" || die
	sed -i -e "s|___GLOBAL_YCMD_EXTRA_CONF___|/tmp/.ycm_extra_conf.py|g" \
		"${json_config}" || die
	sed -i -e "s|___YCMD_PATH___|${ycmd_dir}|g" \
		"${json_config}" || die
	if use system-clangd ; then
		sed -i -e "s|\
___CLANGD_BIN_PATH___|\
/usr/lib/llvm/9/bin/clangd|g" \
			"${json_config}" || die
	else
		sed -i -e "s|\
___CLANGD_BIN_PATH___|\
${ycmd_dir}/third_party/clangd/output/bin/clangd|g" \
			"${json_config}" || die
	fi
	#todo
	sed -i -e "s|___JAVA_JDTLS_WORKSPACE_ROOT_PATH___||g" \
		"${json_config}" || die
}

src_install() {
	exeinto "/usr/lib/geany"
	doexe "${WORKDIR}/${PN}-${PV}_build/${PN}.so"
	insinto "/usr/share/${PN}"
	doins .ycm_extra_conf.py ycmd.json
}

pkg_postinst() {
	einfo \
"You need two files .ycm_extra_conf.py and ycmd.json.\n\
\n\
A .ycm_extra_conf.py template is copied to your /usr/share/${PN} and should\n\
be modified per project.  This file needs to be copied to your project's
root containing your main configure script.\n\
\n\
A copy of ycmd.json can be found as /usr/share/gycm/ycmd.json and should be\n\
copied to /home/<user>/.config/geany/plugins/gycm/ycmd.json.\n\
C/C++/Objective C/Objective C++ users need to define\n\
/home/<user>/.config/geany/plugins/gycm/ycmd.json which the\n\
global_ycm_extra_conf property should be the full path pointing to your\n\
project's .ycm_extra_conf.py.\n\
\n\
Consider emerging ycm-generator to generate a .ycm_extra_conf.py for your\n\
project.  This generated .ycm_extra_conf.py may need to be sligtly modified.\n\
\n\
It may also crash Geany on startup if there is an undeclared variable.  Fix\n\
the errors first.\n\
\n\
Geany may need to be restarted in order for completion to work after enabling\n\
the plugin."
}
