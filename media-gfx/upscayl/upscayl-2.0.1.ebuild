# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_MODE="yarn"
ELECTRON_APP_ELECTRON_PV="21.2.2"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_REACT_PV="18.2.0"
NODE_ENV="development"
NODE_VERSION="16"

inherit desktop electron-app git-r3 npm-utils
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/upscayl/upscayl/archive/refs/tags/v2.0.1.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Upscayl - Free and Open Source AI Image Upscaler for Linux, MacOS and Windows built with Linux-First philosophy."
HOMEPAGE="https://upscayl.github.io/"
# Upstream uses U 18.04.6 for CI
THIRD_PARTY_LICENSES="
	( Apache-2.0 all-rights-reserved )
	( custom MIT Unicode-DFS-2016 CC-BY-4.0 W3C-Software-and-Document-Notice-and-License-2015 W3C-Community-Final-Specification-Agreement )
	( MIT all-rights-reserved )
	( MIT CC0-1.0 )
	( MIT ISC BSD-2 BSD Apache-2.0 0BSD ( MIT all-rights-reserved ) )
	( WTFPL-2 ISC )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-4.0
	CC-BY-SA-4.0
	ISC
	GPL-3
	MIT
	PSF-2.4
	|| ( MIT GPL-2 )
	|| ( MIT CC0-1.0 )
"
LICENSE="
	AGPL-3
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
"

KEYWORDS="~amd64"
SLOT="0"
RDEPEND+="
	media-libs/vulkan-loader
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	sys-apps/yarn
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
	electron-app_pkg_setup
}

src_unpack() {
	electron-app_src_unpack
}

vrun() {
einfo "Running:\t${@}"
	"${@}" || die
	if grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "error Command \".*\" not found." "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

electron-app_src_prepare() {
	export NEXT_TELEMETRY_DISABLED=1
	electron-app_src_prepare_default
}

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	vrun yarn build
	vrun yarn electron-builder build --linux dir
	cd "${S}" || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install_program \
		"dist/linux-unpacked/*"
	npm-utils_install_licenses

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|\${INSTALL_DIR}|${ELECTRON_APP_INSTALL_PATH}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${PN}|${PN}|g" \
		"${ED}/usr/bin/${PN}" || die

        newicon "main/build/icon.png" "${PN}.png"
        make_desktop_entry ${PN} "${MY_PN}" ${PN} "Graphics"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}

pkg_postinst() {
	electron-app_pkg_postinst
ewarn
ewarn "You need vulkan drivers to use ${PN}."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
