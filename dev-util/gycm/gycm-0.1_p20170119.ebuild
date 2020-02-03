# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See gycm.cpp for versioning.

EAPI=7
DESCRIPTION="A Geany plugin to support the ycmd code completion server"
LICENSE="GPL-3"
HOMEPAGE="https://github.com/jakeanq/gycm"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="1963a9f6b51a3aff7c44780dcb13d056a8659b21"
PYTHON_COMPAT=( python3_{6,7,8} )
SLOT="0"
IUSE="debug system-clangd system-gocode system-godef \
system-libclang system-racerd ycmd-slot-1 ycmd-slot-2"
inherit python-single-r1
YCMD_SLOT_1_LLVM_V=6.0
YCMD_SLOT_1_LLVM_V_MAJ=$(ver_cut 1 ${YCMD_SLOT_1_LLVM_V})
YCMD_SLOT_2_LLVM_V=9.0
YCMD_SLOT_2_LLVM_V_MAJ=$(ver_cut 1 ${YCMD_SLOT_2_LLVM_V})
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( ycmd-slot-1
		ycmd-slot-2 )"
DEPEND="${PYTHON_DEPS}
        dev-libs/jsoncpp
        dev-libs/openssl
	ycmd-slot-1? ( dev-util/ycmd:1[${PYTHON_USEDEP}] )
	ycmd-slot-2? ( dev-util/ycmd:2[${PYTHON_USEDEP}] )
	dev-util/geany
        net-libs/libssh
        net-libs/neon"
RDEPEND="${DEPEND}"
SRC_URI=\
"https://github.com/jakeanq/gycm/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit cmake-utils eutils toolchain-funcs
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	ewarn \
"This ebuild is currently undergoing maintenance and is a Work In Progress.\n\
It will not work."
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
		eapply "${FILESDIR}/${PN}-9999.20141216-enable-debug-spew-2.patch"
		eapply "${FILESDIR}/${PN}-9999.20141216-null-exception-check.patch"
		eapply "${FILESDIR}/${PN}-9999-20141216-debug-keep-log-files.patch"
	fi

	if use ycmd-slot-1 ; then
		src_prepare_ycmd-slot-1
	elif use ycmd-slot-2 ; then
		src_prepare_ycmd-slot-2
	fi
}

src_prepare_ycmd-slot-1() {
	local sitedir=$(python_get_sitedir)
	local ycmd_slot=1
	local ycmd_dir="${sitedir}/ycmd/${ycmd_slot}"
	eapply \
"${FILESDIR}/gycm-0.1_p20170119-init-struct-for-ycmd-core-version-39.patch"
	if use system-libclang ; then
		sed -i -e "s|\
../llvm/tools/clang/include|\
$(realpath /usr/lib/clang/${YCMD_SLOT_1_LLVM_V_MAJ}.*/include \
			| sort | tail -n 1)|g" \
			.ycm_extra_conf.py || die
	else
		sed -i -e "s|\
../llvm/tools/clang/include|\
${ycmd_dir}/clang_includes/include|g" \
			.ycm_extra_conf.py || die
	fi
	local json_config="${S}/ycmd.json"
	cat "${FILESDIR}/default_settings.json.39_p20180821" > "${json_config}"
	sed -i -e "s|\
___HMAC_SECRET___|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
		"${json_config}" || die
	sed -i -e "s|___PYTHON_BIN_PATH___|/usr/bin/${EPYTHON}|g" \
		"${json_config}" || die
	sed -i -e "s|___GLOBAL_YCMD_EXTRA_CONF___|/tmp/.ycm_extra_conf.py|g" \
		"${json_config}" || die
	sed -i -e "s|___YCMD_PATH___|${ycmd_dir}|g" \
		"${json_config}" || die
	sed -i -e "s|___RUST_SRC_PATH___|/usr/share/rust/src|g" \
		"${json_config}" || die
	if use system-gocode ; then
		sed -i -e "s|___GOCODE_BIN_PATH___|/usr/bin/gocode|g" \
			"${json_config}" || die
	else
		sed -i -e "s|\
___GOCODE_BIN_PATH___|\
${ycmd_dir}/third_party/gocode/gocode|g" \
			"${json_config}" || die
	fi
	if use system-godef ; then
		sed -i -e "s|___GODEF_BIN_PATH___|/usr/bin/godef|g" \
			"${json_config}" || die
	else
		sed -i -e "s|\
___GODEF_BIN_PATH___|\
${ycmd_dir}/third_party/godef/godef|g" \
			"${json_config}" || die
	fi
	if use system-racerd ; then
		sed -i -e "s|___RACERD_BIN_PATH___|/usr/bin/racerd|g" \
			"${json_config}" || die
	else
		sed -i -e "s|\
___RACERD_BIN_PATH___|\
${ycmd_dir}/third_party/racerd/racerd|g" \
			"${json_config}" || die
	fi
}

src_prepare_ycmd-slot-2() {
	local sitedir=$(python_get_sitedir)
	local ycmd_slot=2
	local ycmd_dir="${sitedir}/ycmd/${ycmd_slot}"
	eapply \
"${FILESDIR}/gycm-0.1_p20170119-init-struct-for-ycmd-core-version-42.patch"
	if use system-libclang ; then
		sed -i -e "s|\
../llvm/tools/clang/include|\
$(realpath /usr/lib/clang/${YCMD_SLOT_2_LLVM_V_MAJ}.*/include \
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
	sed -i -e "s|\
___HMAC_SECRET___|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
		"${json_config}" || die
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
You must generate a 16 byte HMAC secret wrapped in base64 for the\n\
hmac_secret property of your .json file.\n\
\n\
Do: openssl rand -base64 16\n\
\n\
or\n\
\n\
Do: cat < /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c 16 | base64"
}
