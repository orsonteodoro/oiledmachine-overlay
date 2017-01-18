# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils cmake-utils python-single-r1 toolchain-funcs

DESCRIPTION="A Geany plugin to support the ycmd code completion server"
HOMEPAGE=""
COMMIT="1963a9f6b51a3aff7c44780dcb13d056a8659b21"
SRC_URI="https://github.com/jakeanq/gycm/archive/${COMMIT}.zip -> ${P}.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE=""
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}/${PN}-${COMMIT}"

DEPEND="${PYTHON_DEPS}
        net-libs/neon
        dev-libs/jsoncpp
        dev-libs/openssl
	python_single_target_python2_7? ( =dev-util/ycmd-9999.20141214[${PYTHON_USEDEP}] )
	!python_single_target_python2_7? ( >=dev-util/ycmd--9999.20170107[${PYTHON_USEDEP}] )
        net-libs/libssh
	dev-util/geany"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	if use python_single_target_python3_4 || use python_single_target_python3_5 ; then
		ewarn "ycmd is broken for python 3.x. Emerging anyway for ebuild developer."
	fi

	eapply "${FILESDIR}/${PN}-9999.20141216-missing-iostream.ebuild"
	eapply "${FILESDIR}/${PN}-9999-20141216-update-ycmd-default-values.patch"
	sed -i -e "s|\[\"ycmd_path\"\] = \"\"|\[\"ycmd_path\"\] = \"/usr/$(get_libdir)/${EPYTHON}/site-packages\"|g" config.cpp || die

	sed -i -e "s|\"python\"|\"/usr/bin/${EPYTHON}\"|g" ycmd.cpp || die
	sed -i -e "s|\"/usr/bin/python\"|\"/usr/bin/${EPYTHON}\"|g" config.cpp || die

	#needs to be defiend per package
	#sed -i -e "s|global_ycm_extra_conf\"\] = \"\"|global_ycm_extra_conf\"] = \"$(python_get_sitedir)/ycmd/.ycm_extra_conf.py\"|" config.cpp || die

	if use debug ; then
		eapply "${FILESDIR}/${PN}-9999-20141216-enable-debug-spew.patch"
		eapply "${FILESDIR}/${PN}-9999.20141216-enable-debug-spew-2.patch"
		eapply "${FILESDIR}/${PN}-9999.20141216-null-exception-check.patch"
		eapply "${FILESDIR}/${PN}-9999-20141216-debug-keep-log-files.patch"
	fi

	sed -i -e "s|../llvm/tools/clang/include|/usr/lib/clang/$(clang-fullversion)/include|g" .ycm_extra_conf.py

	cp -a "${FILESDIR}/ycmd.json" "${WORKDIR}"
	sed -i -e "s|VdI8w36i6ACZBxmkTz3cSQ==|$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" "${WORKDIR}/ycmd.json" || die
	sed -i -e "s|/usr/lib64/python3.4/site-packages|/usr/$(get_libdir)/${EPYTHON}/site-packages|g" "${WORKDIR}/ycmd.json" || die
	sed -i -e "s|/usr/lib64/python3.4/site-packages|/usr/$(get_libdir)/${EPYTHON}/site-packages|g" "${WORKDIR}/ycmd.json" || die
	sed -i -e "s|/usr/bin/python3.4|/usr/bin/${EPYTHON}|g" "${WORKDIR}/ycmd.json" || die

	eapply "${FILESDIR}/gycm-9999.20141216-new-hmac-header-calculation.patch"

	eapply_user
}

src_configure() {
	local mycmakeargs=(
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	mkdir -p "${D}/usr/lib/geany"
	cp "${WORKDIR}/${PN}-${PV}_build/${PN}.so" "${D}/usr/lib/geany"

	mkdir -p "${D}/usr/share/${PN}"
	cp -a .ycm_extra_conf.py "${D}/usr/share/${PN}"
	cp -a "${WORKDIR}/ycmd.json" "${D}/usr/share/${PN}"
}

pkg_postinst() {
	einfo "You need two files .ycm_extra_conf.py and ycmd.json."
	einfo "A .ycm_extra_conf.py template is copied to your /usr/share/${PN} and should be modified per project."
	einfo "A copy of ycmd.json can be found as /usr/share/gycm/ycmd.json and should be copied to /home/<user>/.config/geany/plugins/gycm/ycmd.json."
	einfo "C/C++/Objective C/Objective C++ users need to define /home/<user>/.config/geany/plugins/gycm/ycmd.json which the global_ycm_extra_conf property should be the full path pointing to your project's .ycm_extra_conf.py."
	einfo ""
	einfo "Consider emerging ycm-generator to generate a .ycm_extra_conf.py for your project."
	einfo "This generated .ycm_extra_conf.py may need to be sligtly modified."
	einfo ""
	einfo "You must generate a 16 byte HMAC secret wrapped in base64 for the hmac_secret property of your .json file:"
	einfo "Do: openssl rand -base64 16"
	einfo "or"
	einfo "Do: < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64"
}
