# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_MODE="yarn"
ELECTRON_APP_ELECTRON_PV="11.0.3"
ELECTRON_APP_REACT_NATIVE_PV="0.64.0_rc1"
NODE_DEV="development"
NODE_VERSION="14" # Upstream uses 12

inherit desktop electron-app git-r3 npm-utils
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/devhubapp/devhub/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="GitHub Notifications Manager & Activity Watcher - Web, Mobile & \
Desktop"
HOMEPAGE="https://devhubapp.com"
THIRD_PARTY_LICENSES="
	( WTFPL-2 MIT )
	( all-rights-reserved OFL-1.1 )
	( custom MIT )
	( Apache-2.0 all-rights-reserved )
	( Apache-2.0 CC-BY-3.0 )
	( MIT all-rights-reserved )
	( MIT all-rights-reserved )
	( MIT CC0-1.0 )
	( Unicode-DFS-2016 W3C-Software-and-Document-Notice-and-License W3C-Community-Final-Specification-Agreement CC-BY-4.0 MIT )
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	ISC
	MIT
	MPL-2.0
	CC-BY-SA-4.0
	CC-BY-3.0
	LGPL-3.0
	ODC-By
"
LICENSE="
	AGPL-3
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( WTFPL-2 MIT ) - homedir/yarn/v6/npm-path-is-inside-1.0.2-365417dede44430d1c11af61027facf074bdfc53-integrity/node_modules/path-is-inside/LICENSE.txt
# ( all-rights-reserved OFL-1.1 ) - homedir/yarn/v6/npm-polished-3.4.1-1eb5597ec1792206365635811d465751f5cbf71c-integrity/node_modules/polished/docs/assets/fonts/LICENSE.txt
# ( Apache-2.0 all-rights-reserved ) - homedir/yarn/v6/npm-typescript-4.3.4-3f85b986945bcf31071decdd96cf8bfa65f9dcbc-integrity/node_modules/typescript/CopyrightNotice.txt
# ( Apache-2.0 CC-BY-3.0 ) - yarn/v6/npm-@react-native-firebase-app-10.1.0-4242933c52b4b753ba48216092c0447677118342-integrity/node_modules/@react-native-firebase/app/LICENSE
# ( MIT all-rights-reserved ) - homedir/yarn/v6/npm-http-parser-js-0.5.2-da2e31d237b393aae72ace43882dd7e270a8ff77-integrity/node_modules/http-parser-js/LICENSE.md
# ( MIT all-rights-reserved ) - homedir/yarn/v6/npm-minizlib-2.1.2-e90d3466ba209b932451508a11ce3d3632145931-integrity/node_modules/minizlib/LICENSE
# ( MIT CC0-1.0 )
# ( Unicode-DFS-2016 W3C-Software-and-Document-Notice-and-License W3C-Community-Final-Specification-Agreement CC-BY-4.0 MIT ) - homedir/yarn/v6/npm-typescript-4.3.4-3f85b986945bcf31071decdd96cf8bfa65f9dcbc-integrity/node_modules/typescript/ThirdPartyNoticeText.txt
# Apache-2.0
# BSD
# BSD-2
# CC0-1.0
# custom, MIT - homedir/yarn/v6/npm-node-notifier-8.0.0-a7eee2d51da6d0f7ff5094bc7108c911240c1620-integrity/node_modules/node-notifier/vendor/terminal-notifier-LICENSE
# custom, MIT with no advertising clause - homedir/yarn/v6/npm-ecc-jsbn-0.1.2-3a83a904e54353287874c564b7549386849a98c9-integrity/node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ISC
# MIT
# MPL-2.0 - homedir/yarn/v6/npm-axe-core-4.1.1-70a7855888e287f7add66002211a423937063eaf-integrity/node_modules/axe-core/LICENSE
# CC-BY-SA-4.0 - homedir/yarn/v6/npm-glob-7.1.6-141f33b81a7c2492e125594307480c46679278a6-integrity/node_modules/glob/LICENSE
# CC-BY-3.0 - homedir/yarn/v6/npm-@react-native-firebase-app-10.1.0-4242933c52b4b753ba48216092c0447677118342-integrity/node_modules/@react-native-firebase/app/LICENSE
# LGPL-3.0 - homedir/yarn/v6/npm-node-notifier-8.0.0-a7eee2d51da6d0f7ff5094bc7108c911240c1620-integrity/node_modules/node-notifier/vendor/snoreToast/LICENSE
# ODC-By - homedir/yarn/v6/npm-language-subtag-registry-0.3.21-04ac218bea46f04cb039084602c6da9e788dd45a-integrity/node_modules/language-subtag-registry/LICENSE.md

KEYWORDS="~amd64"
SLOT="0"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	>=sys-apps/yarn-1.13.0
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/devhub-0.102.0-icontheme-tsx-changes.patch"
)

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
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="6e31725a63f42986eb040153aec7eb11723b8289"
		EGIT_REPO_URI="https://github.com/devhubapp/devhub.git"
		EGIT_BRANCH="master"
		EGIT_COMMIT="HEAD"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_pv=$(grep "version" "${S}/package.json" | cut -f 4 -d '"')
	local expected_pv=$(ver_cut 1-3 ${PV})
	if ver_test ${actual_pv} -ne ${expected_pv} ; then
eerror
eerror "A version bump was detected"
eerror
eerror "Expected:\t${expected_pv}"
eerror "Actual:\t${actual_pv}"
eerror
eerror "This means to bump the version in the ebuild and update ebuild"
eerror "version variables and *DEPENDs."
eerror
		die
	fi
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
}

deps_live() {
	vrun yarn workspace @devhub/web add "@brunolemos/react-window-without-virtualization@1.8.5-withoutvirtualization.1" || die
	vrun yarn workspace @devhub/web add "@types/fbemitter@2.0.32" || die
	vrun yarn workspace @devhub/web add "@types/gravatar@1.8.0" || die
	vrun yarn workspace @devhub/web add "@types/google.analytics@0.0.40" || die
	vrun yarn workspace @devhub/web add "@types/lodash@4.14.165" || die
	vrun yarn workspace @devhub/web add "@types/qs@6.9.0" || die
	vrun yarn workspace @devhub/web add "@types/react@17.0.0" || die
	vrun yarn workspace @devhub/web add "@types/react-dom@17.0.0" || die
	vrun yarn workspace @devhub/web add "@types/react-native@0.64.10" || die
	vrun yarn workspace @devhub/web add "@types/react-native-vector-icons@6.4.4" || die
	vrun yarn workspace @devhub/web add "@types/react-redux@7.1.11" || die
	vrun yarn workspace @devhub/web add "@types/react-stripe-elements@1.3.5" || die
	vrun yarn workspace @devhub/web add "@types/react-window@1.8.1" || die
	vrun yarn workspace @devhub/web add "@types/yup@0.26.24" || die
	vrun yarn workspace @devhub/web add "@octokit/webhooks@7.0.0" || die
	vrun yarn workspace @devhub/web add "babel-plugin-react-native-web@0.14.9" || die
	vrun yarn workspace @devhub/web add "lodash@4.17.20" || die
	vrun yarn workspace @devhub/web add "react-app-rewired@2.1.7" || die
	vrun yarn workspace @devhub/web add "react-native-vector-icons@7.1.0" || die
	vrun yarn workspace @devhub/web add "redux-flipper@1.4.2" || die
	vrun yarn workspace @devhub/web add "reselect-tools@0.0.7" || die
	vrun yarn workspace @devhub/web add "typescript@4.3.4" || die
	vrun yarn workspace @devhub/web add "yup@0.27.0" || die
	vrun yarn workspace @devhub/web add "webpack-bundle-analyzer@3.5.2" || die
}

deps_0_102() {
	vrun yarn workspace @devhub/web add "@brunolemos/react-window-without-virtualization@1.8.5-withoutvirtualization.1" || die
	vrun yarn workspace @devhub/web add "@types/fbemitter@2.0.32" || die
	vrun yarn workspace @devhub/web add "@types/gravatar@1.8.0" || die
	vrun yarn workspace @devhub/web add "@types/google.analytics@0.0.40" || die
	vrun yarn workspace @devhub/web add "@types/lodash@4.14.165" || die
	vrun yarn workspace @devhub/web add "@types/qs@6.9.0" || die
	vrun yarn workspace @devhub/web add "@types/react@17.0.0" || die
	vrun yarn workspace @devhub/web add "@types/react-dom@17.0.0" || die
	vrun yarn workspace @devhub/web add "@types/react-native@0.63.37" || die
	vrun yarn workspace @devhub/web add "@types/react-native-vector-icons@6.4.4" || die
	vrun yarn workspace @devhub/web add "@types/react-redux@7.1.11" || die
	vrun yarn workspace @devhub/web add "@types/react-stripe-elements@1.3.5" || die
	vrun yarn workspace @devhub/web add "@types/react-window@1.8.1" || die
	vrun yarn workspace @devhub/web add "@types/yup@0.26.24" || die
	vrun yarn workspace @devhub/web add "@octokit/webhooks@7.0.0" || die
	vrun yarn workspace @devhub/web add "babel-plugin-react-native-web@0.14.9" || die
	vrun yarn workspace @devhub/web add "lodash@4.17.20" || die
	vrun yarn workspace @devhub/web add "react-app-rewired@2.1.7s" || die
	vrun yarn workspace @devhub/web add "react-native-vector-icons@7.1.0" || die
	vrun yarn workspace @devhub/web add "redux-flipper@1.4.2" || die
	vrun yarn workspace @devhub/web add "reselect-tools@0.0.7" || die
	vrun yarn workspace @devhub/web add "typescript@4.1.2" || die
	vrun yarn workspace @devhub/web add "yup@0.27.0" || die
	vrun yarn workspace @devhub/web add "webpack-bundle-analyzer@3.5.2" || die
}

electron-app_src_prepare() {
	ewarn "This ebuild is a Work In Progress (WIP) and incomplete."

	eapply ${PATCHES[@]}
	if [[ ${PV} =~ 9999 ]] ; then
		deps_live
	else
		deps_0_102
	fi

#	vrun yarn workspace @devhub/web add "" || die
	electron-app_src_prepare_default
}

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	vrun yarn workspace @devhub/web build
	vrun yarn workspace @devhub/desktop build:base
	vrun yarn workspace @devhub/desktop build:web:post
	vrun yarn workspace @devhub/desktop build:electron --linux dir
	cd "${S}" || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install_program \
		"packages/desktop/build/linux-unpacked/*"
	npm-utils_install_licenses

	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		"${ED}/usr/bin/${PN}" || die

        newicon "node_modules/@devhub/desktop/assets/icons/icon.png" "${PN}.png"
        make_desktop_entry ${PN} "${MY_PN}" ${PN} "Development"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
