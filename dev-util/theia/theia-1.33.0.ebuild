# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="15.5.7"
#ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="18.2.0"
NODE_ENV="development"
NODE_VERSION=16 # Upstream uses in CI
PYTHON_COMPAT=( python3_{8..11} )

inherit desktop electron-app npm-utils python-r1

DESCRIPTION="Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript."
HOMEPAGE="http://theia-ide.org/"
THIRD_PARTY_LICENSES="
	( Apache-2.0 all-rights-reserved )
	( custom Apache-2.0 all-rights-reserved )
	( custom MIT all-rights-reserved no-advertising )
	( \
		custom \
		MIT \
		Unicode-DFS-2016 \
		W3C-Software-and-Document-Notice-and-License \
		W3C-Community-Final-Specification-Agreement \
	)
	( \
		custom \
		( \
			( LGPL-2.1 LGPL-2.1+ ) \
			|| ( MIT GPL-2.0 ) \
		) \
		( \
			AFL-2.0 \
			Apache-2.0 \
			BSD \
			BSD-2 \
			BSD-2 \
			CC-BY-3.0 \
			ISC \
			MIT \
			MPL-2.0 \
			public-domain \
			Unlicense \
			|| ( BSD-2 MIT Apache-2.0 ) \
			|| ( BSD MPL-2.0 ) \
			|| ( MIT GPL-2 ) \
		) \
		( \
			Apache-2.0 \
			Artistic-2.0 \
			BSD \
			BSD-2 \
			CC-BY-3.0 \
			CC-BY-4.0 \
			CC-BY-SA-2.5 \
			CC0-1.0 \
			GPL-2-with-autoconf-exception \
			MPL-2.0 \
			|| ( AFL-2.1 BSD ) \
			|| ( MIT Apache-2.0 ) \
			|| ( BSD MIT ) \
		) \
		( \
			Boost-1.0 \
			Unlicense \
			Apache-2.0 \
			Artist \
			BSD \
			BSD-2 \
			CC-BY-3.0 \
			CC0-1.0 \
			ISC \
			MIT \
			MPL-2.0 \
			OFL-1.1 \
			ZLIB \
			|| ( AFL-2.0 BSD ) \
			|| ( MIT GPL-3 ) \
			|| ( MIT Apache-2.0 ) \
		) \
		( \
			BSD \
			BSD-2 \
		) \
		( \
			CC-BY-4.0 \
			MIT \
		) \
		( \
			custom \
			GPL-2.0+ \
			LGPL-2.1+ \
		) \
		( \
			BSD \
			MIT \
			public-domain \
		) \
		Apache-2.0 \
		MIT \
		EPL-1.0 \
		ISC \
		LGPL-2.1+ \
		W3C \
		|| ( EPL-2.0 GPL-2.0-with-classpath-exception ) \
		|| ( LGPL-2.1 LGPL-2.1+ ) \
	)
	( ISC CC-BY-SA-4.0 )
	( MIT all-rights-reserved )
	( MIT Apache-2.0 )
	( MIT CC0-1.0 )
	0BSD
	Apache-2.0
	Artistic-2
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC0-1.0
	custom
	MIT
	ISC
	LGPL-2.1
	LGPL-3
	PSF-2.4
	Unlicense
	|| ( BSD AFL-2.1 )
	|| ( Apache-2.0 MPL-2.0 )
"
LICENSE="
	EPL-2.0
	GPL-2-with-classpath-exception
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( Apache-2.0 all-rights-reserved ) - node_modules/rx/license.txt
# ( custom Apache-2.0 all-rights-reserved ) - node_modules/typescript/CopyrightNotice.txt
# ( custom MIT all-rights-reserved no-advertising ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( \
#   custom \
#   MIT \
#   Unicode-DFS-2016 \
#   W3C-Software-and-Document-Notice-and-License \
#   W3C-Community-Final-Specification-Agreement \
# ) - node_modules/typescript/ThirdPartyNoticeText.txt
# ( \
#   custom \
#   ( \
#     ( LGPL-2.1 LGPL-2.1+ ) \
#     || ( MIT GPL-2.0 ) \
#   ) \
#   ( \
#     AFL-2.0 \
#     Apache-2.0 \
#     BSD \
#     BSD-2 \
#     BSD-2 \
#     CC-BY-3.0 \
#     ISC \
#     MIT \
#     MPL-2.0 \
#     public-domain \
#     Unlicense \
#     X11 [see distro MIT license file] \
#     || ( BSD-2 MIT Apache-2.0 ) \
#     || ( BSD MPL-2.0 ) \
#     || ( MIT GPL-2 ) \
#   ) \
#   ( \
#     Apache-2.0 \
#     Artistic-2.0 \
#     BSD \
#     BSD-2 \
#     CC-BY-3.0 \
#     CC-BY-4.0 \
#     CC-BY-SA-2.5 \
#     CC0-1.0 \
#     GPL-2-with-autoconf-exception \
#     MPL-2.0 \
#     || ( AFL-2.1 BSD ) \
#     || ( MIT Apache-2.0 ) \
#     || ( BSD MIT ) \
#   ) \
#   ( \
#     Boost-1.0 \
#     Unlicense \
#     Apache-2.0 \
#     Artist \
#     BSD \
#     BSD-2 \
#     CC-BY-3.0 \
#     CC0-1.0 \
#     ISC \
#     MIT \
#     MPL-2.0 \
#     OFL-1.1 \
#     ZLIB \
#     || ( AFL-2.0 BSD ) \
#     || ( MIT GPL-3 ) \
#     || ( MIT Apache-2.0 ) \
#   ) \
#   ( \
#     BSD \
#     BSD-2 \
#   ) \
#   ( \
#     CC-BY-4.0 \
#     MIT \
#   ) \
#   ( \
#     custom \
#     GPL-2.0+ \
#     LGPL-2.1+ \
#   ) \
#   ( \
#     BSD \
#     MIT \
#     public-domain \
#   ) \
#   Apache-2.0 \
#   MIT \
#   EPL-1.0 \
#   ISC \
#   LGPL-2.1+ \
#   W3C \
#   || ( EPL-2.0 GPL-2.0-with-classpath-exception ) \
#   || ( LGPL-2.1 LGPL-2.1+ ) \
# ) - NOTICE.md
# ( ISC CC-BY-SA-4.0 ) - node_modules/glob/LICENSE
# ( MIT all-rights-reserved ) - node_modules/minizlib/LICENSE
# ( MIT all-rights-reserved ) - node_modules/@vscode/debugprotocol/License.txt
# ( MIT Apache-2.0 ) - node_modules/pause-stream/LICENSE
# ( MIT CC0-1.0 ) - node_modules/lodash.throttle/LICENSE
# 0BSD - node_modules/tslib/CopyrightNotice.txt
# Apache-2.0 - node_modules/ts-clean/node_modules/typescript/LICENSE.txt
# Apache-2.0 - node_modules/playwright-core/LICENSE
# Artistic-2 - node_modules/npm-lifecycle/LICENSE
# BSD - node_modules/entities/LICENSE
# BSD-2 - node_modules/eslint-scope/node_modules/estraverse/LICENSE.BSD
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# CC0-1.0 - node_modules/@stroncium/procfs/LICENSE
# custom - node_modules/vscode-languageserver-textdocument/thirdpartynotices.txt
# MIT - node_modules/simple-get/LICENSE
# ISC - node_modules/at-least-node/LICENSE
# LGPL-2.1 - node_modules/jschardet/LICENSE
# LGPL-3 - node_modules/eslint-plugin-deprecation/LICENSE
# PSF-2.4 - node_modules/markdown-it/node_modules/argparse/LICENSE
# Unlicense - node_modules/markdown-it-anchor/UNLICENSE
# || ( BSD AFL-2.1 ) - node_modules/json-schema/LICENSE
# || ( Apache-2.0 MPL-2.0 ) - node_modules/dompurify/LICENSE

KEYWORDS="~amd64"
SLOT="0/monthly"
IUSE+=" git"
# Upstream uses U 22.04.1
RDEPEND+="
	>=app-crypt/libsecret-0.20.5
	>=x11-libs/libX11-1.7.5
	>=x11-libs/libxkbfile-1.1.0
	git? (
		>=dev-vcs/git-2.34.1
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=net-libs/nodejs-14.18.0:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	>=sys-devel/gcc-11.2.0
	>=sys-devel/make-4.3
	virtual/pkgconfig
	(
		>=sys-apps/yarn-1.7.0
		<sys-apps/yarn-2
	)
"
if [[ "${SLOT}" =~ "community" ]] ; then
	SUFFIX="-community"
fi
SRC_URI="
https://github.com/eclipse-theia/theia/archive/refs/tags/v${PV}${SUFFIX}.tar.gz
	-> ${P}${SUFFIX}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}${SUFFIX}"
RESTRICT="mirror"

pkg_setup() {
	einfo "This is the monthly release."
	python_setup
	electron-app_pkg_setup
}

vrun() {
einfo "Running:\t${@}"
	"${@}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
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

electron-app_src_postunpack() {
	electron-app_src_postunpack_default
	vrun yarn add ts-clean --dev -W
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	vrun yarn
	vrun yarn download:plugins
}

electron-app_src_compile() {
	vrun yarn electron build
	vrun yarn electron rebuild
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"*" \
		"logo/theia.svg" \
		"${PN^}" \
		"Development" \
		"/usr/bin/${PN}" # Wrapper overwritten below
	cat "${FILESDIR}/${PN}" > "${T}/${PN}" || die
	sed -i \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${INSTALL_PATH}|${ELECTRON_APP_INSTALL_PATH}|g" \
		"${T}/${PN}" \
		|| die
	exeinto /usr/bin
	doexe "${T}/${PN}"
	LCNR_SOURCE="${WORKDIR}/${PN}-${PV}${SUFFIX}"
	npm-utils_install_licenses
	electron-app_src_install_finalize
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
