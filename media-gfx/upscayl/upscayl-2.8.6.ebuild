# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${PN}-${PV}-linux.AppImage"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_ELECTRON_PV="25.8.1"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY=1
ELECTRON_APP_REACT_PV="18.2.0"
NODE_ENV="development"
NODE_VERSION="16"

inherit desktop electron-app git-r3 lcnr npm
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	IUSE+=" fallback-commit"
else
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/upscayl-2.0.1/work/upscayl-2.0.1/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.1.0.tgz -> npmpkg-@electron-notarize-2.1.0.tgz
https://registry.npmjs.org/@next/swc-darwin-arm64/-/swc-darwin-arm64-13.5.6.tgz -> npmpkg-@next-swc-darwin-arm64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-darwin-x64/-/swc-darwin-x64-13.5.6.tgz -> npmpkg-@next-swc-darwin-x64-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-gnu/-/swc-linux-arm64-gnu-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-gnu-13.5.6.tgz
https://registry.npmjs.org/@next/swc-linux-arm64-musl/-/swc-linux-arm64-musl-13.5.6.tgz -> npmpkg-@next-swc-linux-arm64-musl-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-arm64-msvc/-/swc-win32-arm64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-arm64-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-ia32-msvc/-/swc-win32-ia32-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-ia32-msvc-13.5.6.tgz
https://registry.npmjs.org/@next/swc-win32-x64-msvc/-/swc-win32-x64-msvc-13.5.6.tgz -> npmpkg-@next-swc-win32-x64-msvc-13.5.6.tgz
https://registry.npmjs.org/@types/node/-/node-18.18.8.tgz -> npmpkg-@types-node-18.18.8.tgz
https://registry.npmjs.org/@types/react/-/react-18.2.36.tgz -> npmpkg-@types-react-18.2.36.tgz
https://registry.npmjs.org/@types/react-dom/-/react-dom-18.2.14.tgz -> npmpkg-@types-react-dom-18.2.14.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-24.6.4.tgz -> npmpkg-app-builder-lib-24.6.4.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.7.tgz -> npmpkg-@electron-asar-3.2.7.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.0.5.tgz -> npmpkg-@electron-osx-sign-1.0.5.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.4.1.tgz -> npmpkg-@electron-universal-1.4.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.9.tgz -> npmpkg-ejs-3.1.9.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-24.5.0.tgz -> npmpkg-electron-publish-24.5.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.0.tgz -> npmpkg-isbinaryfile-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.16.tgz -> npmpkg-autoprefixer-10.4.16.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.1.tgz -> npmpkg-browserslist-4.22.1.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.576.tgz -> npmpkg-electron-to-chromium-1.4.576.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.13.tgz -> npmpkg-node-releases-2.0.13.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.5.0.tgz -> npmpkg-builder-util-24.5.0.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.1.tgz -> npmpkg-builder-util-runtime-9.2.1.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001561.tgz -> npmpkg-caniuse-lite-1.0.30001561.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/cross-env/-/cross-env-7.0.3.tgz -> npmpkg-cross-env-7.0.3.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/css-selector-tokenizer/-/css-selector-tokenizer-0.8.0.tgz -> npmpkg-css-selector-tokenizer-0.8.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/fastparse/-/fastparse-1.1.2.tgz -> npmpkg-fastparse-1.1.2.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/daisyui/-/daisyui-3.9.4.tgz -> npmpkg-daisyui-3.9.4.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.6.4.tgz -> npmpkg-dmg-builder-24.6.4.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-16.3.1.tgz -> npmpkg-dotenv-16.3.1.tgz
https://registry.npmjs.org/electron/-/electron-25.9.3.tgz -> npmpkg-electron-25.9.3.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-24.6.4.tgz -> npmpkg-electron-builder-24.6.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-log/-/electron-log-5.0.0.tgz -> npmpkg-electron-log-5.0.0.tgz
https://registry.npmjs.org/electron-next/-/electron-next-3.1.5.tgz -> npmpkg-electron-next-3.1.5.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-6.1.4.tgz -> npmpkg-electron-updater-6.1.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/firebase/-/firebase-10.5.2.tgz -> npmpkg-firebase-10.5.2.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.3.7.tgz -> npmpkg-fraction.js-4.3.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/jotai/-/jotai-2.5.1.tgz -> npmpkg-jotai-2.5.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/next/-/next-13.5.6.tgz -> npmpkg-next-13.5.6.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-6.1.0.tgz -> npmpkg-node-addon-api-6.1.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz -> npmpkg-postcss-js-4.0.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prettier/-/prettier-3.0.3.tgz -> npmpkg-prettier-3.0.3.tgz
https://registry.npmjs.org/prettier-plugin-tailwindcss/-/prettier-plugin-tailwindcss-0.4.1.tgz -> npmpkg-prettier-plugin-tailwindcss-0.4.1.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/react/-/react-18.2.0.tgz -> npmpkg-react-18.2.0.tgz
https://registry.npmjs.org/react-compare-slider/-/react-compare-slider-2.2.0.tgz -> npmpkg-react-compare-slider-2.2.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-18.2.0.tgz -> npmpkg-react-dom-18.2.0.tgz
https://registry.npmjs.org/react-select/-/react-select-5.8.0.tgz -> npmpkg-react-select-5.8.0.tgz
https://registry.npmjs.org/react-tooltip/-/react-tooltip-5.22.0.tgz -> npmpkg-react-tooltip-5.22.0.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.3.2.tgz -> npmpkg-read-config-file-6.3.2.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/sharp/-/sharp-0.32.6.tgz -> npmpkg-sharp-0.32.6.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/tailwind-scrollbar/-/tailwind-scrollbar-3.0.5.tgz -> npmpkg-tailwind-scrollbar-3.0.5.tgz
https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.3.5.tgz -> npmpkg-tailwindcss-3.3.5.tgz
https://registry.npmjs.org/theme-change/-/theme-change-2.5.0.tgz -> npmpkg-theme-change-2.5.0.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
#$(electron-app_gen_electron_uris)
	SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/upscayl/upscayl/archive/refs/tags/v${PV}.tar.gz
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
IUSE+=" r2"
RDEPEND+="
	media-libs/vulkan-loader
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
	npm_pkg_setup
}

npm_update_lock_install_post() {
	enpm uninstall "@types/electron"
}

src_compile() {
	export NEXT_TELEMETRY_DISABLED=1
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	npm_hydrate
	electron-app_cp_electron
	enpm run build
	electron-builder build --linux dir
	cd "${S}" || die
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"
	sed -i \
		-e "s|\${INSTALL_DIR}|${NPM_INSTALL_PATH}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${PN}|${PN}|g" \
		"${ED}/usr/bin/${PN}" || die
        newicon "main/build/icon.png" "${PN}.png"
        make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		 "Graphics"
	# Generated from:
	# find "${S}/dist" -executable -type f | cut -f 11- -d "/" | sort
	local L=(
chrome-sandbox
chrome_crashpad_handler
libEGL.so
libGLESv2.so
libffmpeg.so
libvk_swiftshader.so
libvulkan.so.1
resources/bin/upscayl-realesrgan
upscayl
	)
	for f in ${L[@]} ; do
		fperms 0755 "${NPM_INSTALL_PATH}/${f}"
	done
	lcnr_install_files
}

pkg_postinst() {
ewarn
ewarn "You need vulkan drivers to use ${PN}."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.5.5 (20230608)
# USE="X unpacked wayland -r2"
# X:  passed
# wayland:  passed
# digital art:  passed
# real-esrgan:  passed
# fast real-esrgan:  passed
# ultramix balanced:  passed
# color theme (randomly chosen):  passed
