# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_ENV="development"
NODE_VERSION=18 # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}"

EPLAYRIGHT_ALLOW_BROWSERS=(
	"chromium"
	"firefox"
	"webkit"
)
inherit desktop npm playwright

DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
# There are more licenses.
THIRD_PARTY_LICENSES=""
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium? (
			BSD
			chromium-114.0.5735.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-tip-of-tree? (
			BSD
			chromium-115.0.5750.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-with-symbols"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-with-symbols? (
			BSD
			chromium-114.0.5735.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox? (
			BSD
			FF-113.0-THIRD-PARTY-LICENSES
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox-beta? (
			BSD
			FF-114.0-THIRD-PARTY-LICENSES
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		webkit? (
			BSD
		)
	"
fi
LICENSE="
	${THIRD_PARTY_LICENSES}
	MIT
"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+="clipboard r4"
REQUIRED_USE+="
	^^ (
		${PLAYWRIGHT_BROWSERS[@]}
	)
"
NODEJS_PV="18"
RDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	clipboard? (
		x11-misc/xclip
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
MY_PN="${PN//-cli/}"
# Initially generated from:
#   grep "resolved" ${NPM_INSTALL_PATH}/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.13.tgz -> npmpkg-@babel-code-frame-7.22.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.23.2.tgz -> npmpkg-@babel-compat-data-7.23.2.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz -> npmpkg-@babel-core-7.23.2.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.15.tgz -> npmpkg-@babel-helper-compilation-targets-7.22.15.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> npmpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.23.0.tgz -> npmpkg-@babel-helper-module-transforms-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz -> npmpkg-@babel-helper-simple-access-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz -> npmpkg-@babel-helper-string-parser-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.22.15.tgz -> npmpkg-@babel-helper-validator-option-7.22.15.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.23.2.tgz -> npmpkg-@babel-helpers-7.23.2.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.20.tgz -> npmpkg-@babel-highlight-7.22.20.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.0.tgz -> npmpkg-@babel-parser-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-bigint-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-typescript-7.22.5.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.23.2.tgz -> npmpkg-@babel-runtime-7.23.2.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.0.tgz -> npmpkg-regenerator-runtime-0.14.0.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.2.tgz -> npmpkg-@babel-traverse-7.23.2.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz -> npmpkg-@cspotcode-source-map-support-0.8.1.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.9.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jest/console/-/console-29.7.0.tgz -> npmpkg-@jest-console-29.7.0.tgz
https://registry.npmjs.org/@jest/core/-/core-29.7.0.tgz -> npmpkg-@jest-core-29.7.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/@jest/environment/-/environment-29.7.0.tgz -> npmpkg-@jest-environment-29.7.0.tgz
https://registry.npmjs.org/@jest/expect/-/expect-29.7.0.tgz -> npmpkg-@jest-expect-29.7.0.tgz
https://registry.npmjs.org/@jest/expect-utils/-/expect-utils-29.7.0.tgz -> npmpkg-@jest-expect-utils-29.7.0.tgz
https://registry.npmjs.org/@jest/fake-timers/-/fake-timers-29.7.0.tgz -> npmpkg-@jest-fake-timers-29.7.0.tgz
https://registry.npmjs.org/@jest/globals/-/globals-29.7.0.tgz -> npmpkg-@jest-globals-29.7.0.tgz
https://registry.npmjs.org/@jest/reporters/-/reporters-29.7.0.tgz -> npmpkg-@jest-reporters-29.7.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/source-map/-/source-map-29.6.3.tgz -> npmpkg-@jest-source-map-29.6.3.tgz
https://registry.npmjs.org/@jest/test-result/-/test-result-29.7.0.tgz -> npmpkg-@jest-test-result-29.7.0.tgz
https://registry.npmjs.org/@jest/test-sequencer/-/test-sequencer-29.7.0.tgz -> npmpkg-@jest-test-sequencer-29.7.0.tgz
https://registry.npmjs.org/@jest/transform/-/transform-29.7.0.tgz -> npmpkg-@jest-transform-29.7.0.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@jimp/bmp/-/bmp-0.14.0.tgz -> npmpkg-@jimp-bmp-0.14.0.tgz
https://registry.npmjs.org/@jimp/core/-/core-0.14.0.tgz -> npmpkg-@jimp-core-0.14.0.tgz
https://registry.npmjs.org/@jimp/custom/-/custom-0.14.0.tgz -> npmpkg-@jimp-custom-0.14.0.tgz
https://registry.npmjs.org/@jimp/gif/-/gif-0.14.0.tgz -> npmpkg-@jimp-gif-0.14.0.tgz
https://registry.npmjs.org/@jimp/jpeg/-/jpeg-0.14.0.tgz -> npmpkg-@jimp-jpeg-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-blit/-/plugin-blit-0.14.0.tgz -> npmpkg-@jimp-plugin-blit-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-blur/-/plugin-blur-0.14.0.tgz -> npmpkg-@jimp-plugin-blur-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-circle/-/plugin-circle-0.14.0.tgz -> npmpkg-@jimp-plugin-circle-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-color/-/plugin-color-0.14.0.tgz -> npmpkg-@jimp-plugin-color-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-contain/-/plugin-contain-0.14.0.tgz -> npmpkg-@jimp-plugin-contain-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-cover/-/plugin-cover-0.14.0.tgz -> npmpkg-@jimp-plugin-cover-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-crop/-/plugin-crop-0.14.0.tgz -> npmpkg-@jimp-plugin-crop-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-displace/-/plugin-displace-0.14.0.tgz -> npmpkg-@jimp-plugin-displace-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-dither/-/plugin-dither-0.14.0.tgz -> npmpkg-@jimp-plugin-dither-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-fisheye/-/plugin-fisheye-0.14.0.tgz -> npmpkg-@jimp-plugin-fisheye-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-flip/-/plugin-flip-0.14.0.tgz -> npmpkg-@jimp-plugin-flip-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-gaussian/-/plugin-gaussian-0.14.0.tgz -> npmpkg-@jimp-plugin-gaussian-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-invert/-/plugin-invert-0.14.0.tgz -> npmpkg-@jimp-plugin-invert-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-mask/-/plugin-mask-0.14.0.tgz -> npmpkg-@jimp-plugin-mask-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-normalize/-/plugin-normalize-0.14.0.tgz -> npmpkg-@jimp-plugin-normalize-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-print/-/plugin-print-0.14.0.tgz -> npmpkg-@jimp-plugin-print-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-resize/-/plugin-resize-0.14.0.tgz -> npmpkg-@jimp-plugin-resize-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-rotate/-/plugin-rotate-0.14.0.tgz -> npmpkg-@jimp-plugin-rotate-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-scale/-/plugin-scale-0.14.0.tgz -> npmpkg-@jimp-plugin-scale-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-shadow/-/plugin-shadow-0.14.0.tgz -> npmpkg-@jimp-plugin-shadow-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugin-threshold/-/plugin-threshold-0.14.0.tgz -> npmpkg-@jimp-plugin-threshold-0.14.0.tgz
https://registry.npmjs.org/@jimp/plugins/-/plugins-0.14.0.tgz -> npmpkg-@jimp-plugins-0.14.0.tgz
https://registry.npmjs.org/@jimp/png/-/png-0.14.0.tgz -> npmpkg-@jimp-png-0.14.0.tgz
https://registry.npmjs.org/@jimp/tiff/-/tiff-0.14.0.tgz -> npmpkg-@jimp-tiff-0.14.0.tgz
https://registry.npmjs.org/@jimp/types/-/types-0.14.0.tgz -> npmpkg-@jimp-types-0.14.0.tgz
https://registry.npmjs.org/@jimp/utils/-/utils-0.14.0.tgz -> npmpkg-@jimp-utils-0.14.0.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@playwright/test/-/test-1.39.0.tgz -> npmpkg-@playwright-test-1.39.0.tgz
https://registry.npmjs.org/@pnpm/config.env-replace/-/config.env-replace-1.1.0.tgz -> npmpkg-@pnpm-config.env-replace-1.1.0.tgz
https://registry.npmjs.org/@pnpm/network.ca-file/-/network.ca-file-1.0.2.tgz -> npmpkg-@pnpm-network.ca-file-1.0.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/@pnpm/npm-conf/-/npm-conf-2.2.2.tgz -> npmpkg-@pnpm-npm-conf-2.2.2.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@sindresorhus/chunkify/-/chunkify-0.2.0.tgz -> npmpkg-@sindresorhus-chunkify-0.2.0.tgz
https://registry.npmjs.org/@sindresorhus/df/-/df-3.1.1.tgz -> npmpkg-@sindresorhus-df-3.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/execa/-/execa-2.1.0.tgz -> npmpkg-execa-2.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-3.1.0.tgz -> npmpkg-npm-run-path-3.1.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-5.6.0.tgz -> npmpkg-@sindresorhus-is-5.6.0.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-3.0.0.tgz -> npmpkg-@sinonjs-commons-3.0.0.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-10.3.0.tgz -> npmpkg-@sinonjs-fake-timers-10.3.0.tgz
https://registry.npmjs.org/@stroncium/procfs/-/procfs-1.2.1.tgz -> npmpkg-@stroncium-procfs-1.2.1.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-5.0.1.tgz -> npmpkg-@szmarczak-http-timer-5.0.1.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.9.tgz -> npmpkg-@tsconfig-node10-1.0.9.tgz
https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz -> npmpkg-@tsconfig-node12-1.0.11.tgz
https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz -> npmpkg-@tsconfig-node14-1.0.3.tgz
https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz -> npmpkg-@tsconfig-node16-1.0.4.tgz
https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.3.tgz -> npmpkg-@types-babel__core-7.20.3.tgz
https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.6.tgz -> npmpkg-@types-babel__generator-7.6.6.tgz
https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.3.tgz -> npmpkg-@types-babel__template-7.4.3.tgz
https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.3.tgz -> npmpkg-@types-babel__traverse-7.20.3.tgz
https://registry.npmjs.org/@types/child-process-promise/-/child-process-promise-2.2.4.tgz -> npmpkg-@types-child-process-promise-2.2.4.tgz
https://registry.npmjs.org/@types/configstore/-/configstore-6.0.1.tgz -> npmpkg-@types-configstore-6.0.1.tgz
https://registry.npmjs.org/@types/file-exists/-/file-exists-5.0.2.tgz -> npmpkg-@types-file-exists-5.0.2.tgz
https://registry.npmjs.org/@types/graceful-fs/-/graceful-fs-4.1.8.tgz -> npmpkg-@types-graceful-fs-4.1.8.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.3.tgz -> npmpkg-@types-http-cache-semantics-4.0.3.tgz
https://registry.npmjs.org/@types/inquirer/-/inquirer-9.0.6.tgz -> npmpkg-@types-inquirer-9.0.6.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.5.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.5.tgz
https://registry.npmjs.org/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.2.tgz -> npmpkg-@types-istanbul-lib-report-3.0.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.3.tgz -> npmpkg-@types-istanbul-reports-3.0.3.tgz
https://registry.npmjs.org/@types/jest/-/jest-29.5.6.tgz -> npmpkg-@types-jest-29.5.6.tgz
https://registry.npmjs.org/@types/jsdom/-/jsdom-20.0.1.tgz -> npmpkg-@types-jsdom-20.0.1.tgz
https://registry.npmjs.org/@types/jsonfile/-/jsonfile-6.1.3.tgz -> npmpkg-@types-jsonfile-6.1.3.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.14.200.tgz -> npmpkg-@types-lodash-4.14.200.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.4.tgz -> npmpkg-@types-minimist-1.2.4.tgz
https://registry.npmjs.org/@types/mock-fs/-/mock-fs-4.13.3.tgz -> npmpkg-@types-mock-fs-4.13.3.tgz
https://registry.npmjs.org/@types/node/-/node-20.8.9.tgz -> npmpkg-@types-node-20.8.9.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.3.tgz -> npmpkg-@types-normalize-package-data-2.4.3.tgz
https://registry.npmjs.org/@types/stack-utils/-/stack-utils-2.0.2.tgz -> npmpkg-@types-stack-utils-2.0.2.tgz
https://registry.npmjs.org/@types/through/-/through-0.0.32.tgz -> npmpkg-@types-through-0.0.32.tgz
https://registry.npmjs.org/@types/tough-cookie/-/tough-cookie-4.0.4.tgz -> npmpkg-@types-tough-cookie-4.0.4.tgz
https://registry.npmjs.org/@types/update-notifier/-/update-notifier-6.0.6.tgz -> npmpkg-@types-update-notifier-6.0.6.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.29.tgz -> npmpkg-@types-yargs-17.0.29.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.2.tgz -> npmpkg-@types-yargs-parser-21.0.2.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.11.2.tgz -> npmpkg-acorn-8.11.2.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-7.0.1.tgz -> npmpkg-acorn-globals-7.0.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.0.tgz -> npmpkg-acorn-walk-8.3.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-3.0.1.tgz -> npmpkg-ansi-align-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/any-base/-/any-base-1.1.0.tgz -> npmpkg-any-base-1.1.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/app-path/-/app-path-3.3.0.tgz -> npmpkg-app-path-3.3.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/execa/-/execa-1.0.0.tgz -> npmpkg-execa-1.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/arch/-/arch-2.2.0.tgz -> npmpkg-arch-2.2.0.tgz
https://registry.npmjs.org/arg/-/arg-4.1.3.tgz -> npmpkg-arg-4.1.3.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/array-range/-/array-range-1.0.1.tgz -> npmpkg-array-range-1.0.1.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-29.7.0.tgz -> npmpkg-babel-jest-29.7.0.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> npmpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> npmpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-29.6.3.tgz -> npmpkg-babel-plugin-jest-hoist-29.6.3.tgz
https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz -> npmpkg-babel-preset-current-node-syntax-1.0.1.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-29.6.3.tgz -> npmpkg-babel-preset-jest-29.6.3.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bmp-js/-/bmp-js-0.1.0.tgz -> npmpkg-bmp-js-0.1.0.tgz
https://registry.npmjs.org/boxen/-/boxen-7.1.1.tgz -> npmpkg-boxen-7.1.1.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.22.1.tgz -> npmpkg-browserslist-4.22.1.tgz
https://registry.npmjs.org/bs-logger/-/bs-logger-0.2.6.tgz -> npmpkg-bs-logger-0.2.6.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz -> npmpkg-buffer-equal-0.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-7.0.0.tgz -> npmpkg-cacheable-lookup-7.0.0.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-10.2.14.tgz -> npmpkg-cacheable-request-10.2.14.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-7.0.1.tgz -> npmpkg-camelcase-7.0.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> npmpkg-camelcase-keys-6.2.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001555.tgz -> npmpkg-caniuse-lite-1.0.30001555.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz -> npmpkg-char-regex-1.0.2.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/child-process-promise/-/child-process-promise-2.2.1.tgz -> npmpkg-child-process-promise-2.2.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.3.tgz -> npmpkg-cjs-module-lexer-1.2.3.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-3.0.0.tgz -> npmpkg-cli-boxes-3.0.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-2.1.0.tgz -> npmpkg-cli-cursor-2.1.0.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-3.1.0.tgz -> npmpkg-cli-truncate-3.1.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-2.2.1.tgz -> npmpkg-cli-width-2.2.1.tgz
https://registry.npmjs.org/clipboard-sys/-/clipboard-sys-1.2.1.tgz -> npmpkg-clipboard-sys-1.2.1.tgz
https://registry.npmjs.org/clipboardy/-/clipboardy-2.3.0.tgz -> npmpkg-clipboardy-2.3.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/execa/-/execa-1.0.0.tgz -> npmpkg-execa-1.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collect-v8-coverage/-/collect-v8-coverage-1.0.2.tgz -> npmpkg-collect-v8-coverage-1.0.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz -> npmpkg-colorette-2.0.20.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/configstore/-/configstore-6.0.0.tgz -> npmpkg-configstore-6.0.0.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-4.0.0.tgz -> npmpkg-crypto-random-string-4.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-3.0.0.tgz -> npmpkg-unique-string-3.0.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/create-jest/-/create-jest-29.7.0.tgz -> npmpkg-create-jest-29.7.0.tgz
https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz -> npmpkg-create-require-1.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-4.0.2.tgz -> npmpkg-cross-spawn-4.0.2.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.5.0.tgz -> npmpkg-cssom-0.5.0.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/cycled/-/cycled-1.2.0.tgz -> npmpkg-cycled-1.2.0.tgz
https://registry.npmjs.org/data-urls/-/data-urls-3.0.2.tgz -> npmpkg-data-urls-3.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decode-gif/-/decode-gif-1.0.1.tgz -> npmpkg-decode-gif-1.0.1.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/dedent/-/dedent-1.5.1.tgz -> npmpkg-dedent-1.5.1.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/delay/-/delay-4.4.1.tgz -> npmpkg-delay-4.4.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-3.1.0.tgz -> npmpkg-detect-newline-3.1.0.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dom-walk/-/dom-walk-0.1.2.tgz -> npmpkg-dom-walk-0.1.2.tgz
https://registry.npmjs.org/domexception/-/domexception-4.0.0.tgz -> npmpkg-domexception-4.0.0.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-6.0.1.tgz -> npmpkg-dot-prop-6.0.1.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.569.tgz -> npmpkg-electron-to-chromium-1.4.569.tgz
https://registry.npmjs.org/emittery/-/emittery-0.13.1.tgz -> npmpkg-emittery-0.13.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-4.0.0.tgz -> npmpkg-escape-goat-4.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-5.0.1.tgz -> npmpkg-eventemitter3-5.0.1.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/exif-parser/-/exif-parser-0.1.12.tgz -> npmpkg-exif-parser-0.1.12.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expect/-/expect-29.7.0.tgz -> npmpkg-expect-29.7.0.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fastq/-/fastq-1.15.0.tgz -> npmpkg-fastq-1.15.0.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/file-exists/-/file-exists-5.0.1.tgz -> npmpkg-file-exists-5.0.1.tgz
https://registry.npmjs.org/file-extension/-/file-extension-4.0.5.tgz -> npmpkg-file-extension-4.0.5.tgz
https://registry.npmjs.org/file-type/-/file-type-9.0.0.tgz -> npmpkg-file-type-9.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/filter-obj/-/filter-obj-1.1.0.tgz -> npmpkg-filter-obj-1.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/form-data-encoder/-/form-data-encoder-2.1.4.tgz -> npmpkg-form-data-encoder-2.1.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-8.0.0.tgz -> npmpkg-get-stdin-8.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/gifwrap/-/gifwrap-0.9.4.tgz -> npmpkg-gifwrap-0.9.4.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/global/-/global-4.4.0.tgz -> npmpkg-global-4.4.0.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-3.0.1.tgz -> npmpkg-global-dirs-3.0.1.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/got/-/got-12.6.1.tgz -> npmpkg-got-12.6.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/hard-rejection/-/hard-rejection-2.1.0.tgz -> npmpkg-hard-rejection-2.1.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-3.0.0.tgz -> npmpkg-has-yarn-3.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> npmpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-2.2.0.tgz -> npmpkg-http2-wrapper-2.2.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/husky/-/husky-8.0.3.tgz -> npmpkg-husky-8.0.3.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/ignore-by-default/-/ignore-by-default-1.0.1.tgz -> npmpkg-ignore-by-default-1.0.1.tgz
https://registry.npmjs.org/image-q/-/image-q-4.0.0.tgz -> npmpkg-image-q-4.0.0.tgz
https://registry.npmjs.org/@types/node/-/node-16.9.1.tgz -> npmpkg-@types-node-16.9.1.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-4.0.0.tgz -> npmpkg-import-lazy-4.0.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz -> npmpkg-import-local-3.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-2.0.0.tgz -> npmpkg-ini-2.0.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-6.5.2.tgz -> npmpkg-inquirer-6.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-4.0.0.tgz -> npmpkg-is-fullwidth-code-point-4.0.0.tgz
https://registry.npmjs.org/is-function/-/is-function-1.0.2.tgz -> npmpkg-is-function-1.0.2.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-2.1.0.tgz -> npmpkg-is-generator-fn-2.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.4.0.tgz -> npmpkg-is-installed-globally-0.4.0.tgz
https://registry.npmjs.org/is-npm/-/is-npm-6.0.0.tgz -> npmpkg-is-npm-6.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/is-yarn-global/-/is-yarn-global-0.4.1.tgz -> npmpkg-is-yarn-global-0.4.1.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.0.tgz -> npmpkg-istanbul-lib-coverage-3.2.0.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-6.0.1.tgz -> npmpkg-istanbul-lib-instrument-6.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> npmpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.6.tgz -> npmpkg-istanbul-reports-3.1.6.tgz
https://registry.npmjs.org/iterm2-version/-/iterm2-version-4.2.0.tgz -> npmpkg-iterm2-version-4.2.0.tgz
https://registry.npmjs.org/jest/-/jest-29.7.0.tgz -> npmpkg-jest-29.7.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-29.7.0.tgz -> npmpkg-jest-changed-files-29.7.0.tgz
https://registry.npmjs.org/jest-circus/-/jest-circus-29.7.0.tgz -> npmpkg-jest-circus-29.7.0.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-29.7.0.tgz -> npmpkg-jest-cli-29.7.0.tgz
https://registry.npmjs.org/jest-config/-/jest-config-29.7.0.tgz -> npmpkg-jest-config-29.7.0.tgz
https://registry.npmjs.org/jest-diff/-/jest-diff-29.7.0.tgz -> npmpkg-jest-diff-29.7.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-29.7.0.tgz -> npmpkg-jest-docblock-29.7.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-29.7.0.tgz -> npmpkg-jest-each-29.7.0.tgz
https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-29.7.0.tgz -> npmpkg-jest-environment-jsdom-29.7.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-29.7.0.tgz -> npmpkg-jest-environment-node-29.7.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-29.6.3.tgz -> npmpkg-jest-get-type-29.6.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-29.7.0.tgz -> npmpkg-jest-haste-map-29.7.0.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-29.7.0.tgz -> npmpkg-jest-leak-detector-29.7.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-29.7.0.tgz -> npmpkg-jest-matcher-utils-29.7.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-29.7.0.tgz -> npmpkg-jest-message-util-29.7.0.tgz
https://registry.npmjs.org/jest-mock/-/jest-mock-29.7.0.tgz -> npmpkg-jest-mock-29.7.0.tgz
https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.3.tgz -> npmpkg-jest-pnp-resolver-1.2.3.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-29.7.0.tgz -> npmpkg-jest-resolve-29.7.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-29.7.0.tgz -> npmpkg-jest-resolve-dependencies-29.7.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-29.7.0.tgz -> npmpkg-jest-runner-29.7.0.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-29.7.0.tgz -> npmpkg-jest-runtime-29.7.0.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-29.7.0.tgz -> npmpkg-jest-snapshot-29.7.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-29.7.0.tgz -> npmpkg-jest-util-29.7.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-29.7.0.tgz -> npmpkg-jest-validate-29.7.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-29.7.0.tgz -> npmpkg-jest-watcher-29.7.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/jimp/-/jimp-0.14.0.tgz -> npmpkg-jimp-0.14.0.tgz
https://registry.npmjs.org/jpeg-js/-/jpeg-js-0.4.4.tgz -> npmpkg-jpeg-js-0.4.4.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsdom/-/jsdom-20.0.3.tgz -> npmpkg-jsdom-20.0.3.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz -> npmpkg-kleur-3.0.3.tgz
https://registry.npmjs.org/latest-version/-/latest-version-7.0.0.tgz -> npmpkg-latest-version-7.0.0.tgz
https://registry.npmjs.org/leven/-/leven-3.1.0.tgz -> npmpkg-leven-3.1.0.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/listr2/-/listr2-6.6.1.tgz -> npmpkg-listr2-6.6.1.tgz
https://registry.npmjs.org/load-bmfont/-/load-bmfont-1.4.1.tgz -> npmpkg-load-bmfont-1.4.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.memoize/-/lodash.memoize-4.1.2.tgz -> npmpkg-lodash.memoize-4.1.2.tgz
https://registry.npmjs.org/log-update/-/log-update-5.0.1.tgz -> npmpkg-log-update-5.0.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-5.0.0.tgz -> npmpkg-ansi-escapes-5.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-4.0.0.tgz -> npmpkg-cli-cursor-4.0.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-4.0.0.tgz -> npmpkg-restore-cursor-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-3.0.0.tgz -> npmpkg-lowercase-keys-3.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz -> npmpkg-make-error-1.3.6.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/map-obj/-/map-obj-4.3.0.tgz -> npmpkg-map-obj-4.3.0.tgz
https://registry.npmjs.org/meow/-/meow-9.0.0.tgz -> npmpkg-meow-9.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.18.1.tgz -> npmpkg-type-fest-0.18.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-4.0.0.tgz -> npmpkg-mimic-response-4.0.0.tgz
https://registry.npmjs.org/min-document/-/min-document-2.19.0.tgz -> npmpkg-min-document-2.19.0.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-4.1.0.tgz -> npmpkg-minimist-options-4.1.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mock-fs/-/mock-fs-5.2.0.tgz -> npmpkg-mock-fs-5.2.0.tgz
https://registry.npmjs.org/mock-os/-/mock-os-1.0.0.tgz -> npmpkg-mock-os-1.0.0.tgz
https://registry.npmjs.org/mount-point/-/mount-point-3.0.0.tgz -> npmpkg-mount-point-3.0.0.tgz
https://registry.npmjs.org/@sindresorhus/df/-/df-1.0.1.tgz -> npmpkg-@sindresorhus-df-1.0.1.tgz
https://registry.npmjs.org/move-file/-/move-file-3.1.0.tgz -> npmpkg-move-file-3.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.7.tgz -> npmpkg-mute-stream-0.0.7.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.6.tgz -> npmpkg-nanoid-3.3.6.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.13.tgz -> npmpkg-node-releases-2.0.13.tgz
https://registry.npmjs.org/node-version/-/node-version-1.2.0.tgz -> npmpkg-node-version-1.2.0.tgz
https://registry.npmjs.org/nodemon/-/nodemon-2.0.22.tgz -> npmpkg-nodemon-2.0.22.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz -> npmpkg-nopt-1.0.10.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> npmpkg-normalize-package-data-3.0.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-8.0.0.tgz -> npmpkg-normalize-url-8.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.7.tgz -> npmpkg-nwsapi-2.2.7.tgz
https://registry.npmjs.org/omggif/-/omggif-1.0.10.tgz -> npmpkg-omggif-1.0.10.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-3.0.0.tgz -> npmpkg-p-cancelable-3.0.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-2.0.1.tgz -> npmpkg-p-finally-2.0.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/package-json/-/package-json-8.1.1.tgz -> npmpkg-package-json-8.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> npmpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> npmpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz -> npmpkg-parse-bmfont-xml-1.1.4.tgz
https://registry.npmjs.org/parse-headers/-/parse-headers-2.0.5.tgz -> npmpkg-parse-headers-2.0.5.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/phin/-/phin-2.9.3.tgz -> npmpkg-phin-2.9.3.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.6.tgz -> npmpkg-pirates-4.0.6.tgz
https://registry.npmjs.org/pixelmatch/-/pixelmatch-4.0.2.tgz -> npmpkg-pixelmatch-4.0.2.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/playwright/-/playwright-1.39.0.tgz -> npmpkg-playwright-1.39.0.tgz
https://registry.npmjs.org/playwright-core/-/playwright-core-1.39.0.tgz -> npmpkg-playwright-core-1.39.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/promise-polyfill/-/promise-polyfill-6.1.0.tgz -> npmpkg-promise-polyfill-6.1.0.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz -> npmpkg-prompts-2.4.2.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/pstree.remy/-/pstree.remy-1.1.8.tgz -> npmpkg-pstree.remy-1.1.8.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/pupa/-/pupa-3.1.0.tgz -> npmpkg-pupa-3.1.0.tgz
https://registry.npmjs.org/pure-rand/-/pure-rand-6.0.4.tgz -> npmpkg-pure-rand-6.0.4.tgz
https://registry.npmjs.org/query-string/-/query-string-7.1.3.tgz -> npmpkg-query-string-7.1.3.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-4.0.1.tgz -> npmpkg-quick-lru-4.0.1.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/redent/-/redent-3.0.0.tgz -> npmpkg-redent-3.0.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> npmpkg-regenerator-runtime-0.13.11.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-5.0.2.tgz -> npmpkg-registry-auth-token-5.0.2.tgz
https://registry.npmjs.org/registry-url/-/registry-url-6.0.1.tgz -> npmpkg-registry-url-6.0.1.tgz
https://registry.npmjs.org/render-gif/-/render-gif-2.0.4.tgz -> npmpkg-render-gif-2.0.4.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve.exports/-/resolve.exports-2.0.2.tgz -> npmpkg-resolve.exports-2.0.2.tgz
https://registry.npmjs.org/responselike/-/responselike-3.0.0.tgz -> npmpkg-responselike-3.0.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-2.0.0.tgz -> npmpkg-restore-cursor-2.0.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-1.2.0.tgz -> npmpkg-mimic-fn-1.2.0.tgz
https://registry.npmjs.org/onetime/-/onetime-2.0.1.tgz -> npmpkg-onetime-2.0.1.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rfdc/-/rfdc-1.3.0.tgz -> npmpkg-rfdc-1.3.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/rxjs/-/rxjs-7.8.1.tgz -> npmpkg-rxjs-7.8.1.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.3.0.tgz -> npmpkg-sax-1.3.0.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz -> npmpkg-saxes-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-4.0.0.tgz -> npmpkg-semver-diff-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-1.1.0.tgz -> npmpkg-simple-update-notifier-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.0.0.tgz -> npmpkg-semver-7.0.0.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-5.0.0.tgz -> npmpkg-slice-ansi-5.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.13.tgz -> npmpkg-source-map-support-0.5.13.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.16.tgz -> npmpkg-spdx-license-ids-3.0.16.tgz
https://registry.npmjs.org/split-on-first/-/split-on-first-1.1.0.tgz -> npmpkg-split-on-first-1.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-2.0.6.tgz -> npmpkg-stack-utils-2.0.6.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/strict-uri-encode/-/strict-uri-encode-2.0.0.tgz -> npmpkg-strict-uri-encode-2.0.0.tgz
https://registry.npmjs.org/string-length/-/string-length-4.0.2.tgz -> npmpkg-string-length-4.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/strip-eof/-/strip-eof-1.0.0.tgz -> npmpkg-strip-eof-1.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-1.0.1.tgz -> npmpkg-tempy-1.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/term-img/-/term-img-5.0.0.tgz -> npmpkg-term-img-5.0.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/terminal-image/-/terminal-image-1.2.1.tgz -> npmpkg-terminal-image-1.2.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/log-update/-/log-update-4.0.0.tgz -> npmpkg-log-update-4.0.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/timm/-/timm-1.7.1.tgz -> npmpkg-timm-1.7.1.tgz
https://registry.npmjs.org/tinycolor2/-/tinycolor2-1.6.0.tgz -> npmpkg-tinycolor2-1.6.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/touch/-/touch-3.1.0.tgz -> npmpkg-touch-3.1.0.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.3.tgz -> npmpkg-tough-cookie-4.1.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/tr46/-/tr46-3.0.0.tgz -> npmpkg-tr46-3.0.0.tgz
https://registry.npmjs.org/trash/-/trash-8.1.1.tgz -> npmpkg-trash-8.1.1.tgz
https://registry.npmjs.org/trash-cli/-/trash-cli-5.0.0.tgz -> npmpkg-trash-cli-5.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-7.0.2.tgz -> npmpkg-camelcase-keys-7.0.2.tgz
https://registry.npmjs.org/decamelize/-/decamelize-5.0.1.tgz -> npmpkg-decamelize-5.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/meow/-/meow-10.1.5.tgz -> npmpkg-meow-10.1.5.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-6.0.0.tgz -> npmpkg-read-pkg-6.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-8.0.0.tgz -> npmpkg-read-pkg-up-8.0.0.tgz
https://registry.npmjs.org/redent/-/redent-4.0.0.tgz -> npmpkg-redent-4.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-4.0.0.tgz -> npmpkg-strip-indent-4.0.0.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-4.1.1.tgz -> npmpkg-trim-newlines-4.1.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-1.4.0.tgz -> npmpkg-type-fest-1.4.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-4.0.1.tgz -> npmpkg-aggregate-error-4.0.1.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-4.2.0.tgz -> npmpkg-clean-stack-4.2.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-2.2.2.tgz -> npmpkg-dir-glob-2.2.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/globby/-/globby-7.1.1.tgz -> npmpkg-globby-7.1.1.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/indent-string/-/indent-string-5.0.0.tgz -> npmpkg-indent-string-5.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-4.0.0.tgz -> npmpkg-is-path-inside-4.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-5.5.0.tgz -> npmpkg-p-map-5.5.0.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-3.0.1.tgz -> npmpkg-trim-newlines-3.0.1.tgz
https://registry.npmjs.org/ts-jest/-/ts-jest-29.1.1.tgz -> npmpkg-ts-jest-29.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/ts-node/-/ts-node-10.9.1.tgz -> npmpkg-ts-node-10.9.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.2.tgz -> npmpkg-tslib-2.6.2.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/undefsafe/-/undefsafe-2.0.5.tgz -> npmpkg-undefsafe-2.0.5.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> npmpkg-update-browserslist-db-1.0.13.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-6.0.2.tgz -> npmpkg-update-notifier-6.0.2.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz -> npmpkg-chalk-5.3.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/user-home/-/user-home-2.0.0.tgz -> npmpkg-user-home-2.0.0.tgz
https://registry.npmjs.org/utif/-/utif-2.0.1.tgz -> npmpkg-utif-2.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz -> npmpkg-uuid-8.3.2.tgz
https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz -> npmpkg-v8-compile-cache-lib-3.0.1.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.1.3.tgz -> npmpkg-v8-to-istanbul-9.1.3.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-4.0.0.tgz -> npmpkg-w3c-xmlserializer-4.0.0.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> npmpkg-webidl-conversions-7.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> npmpkg-whatwg-encoding-2.0.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz -> npmpkg-whatwg-mimetype-3.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-11.0.0.tgz -> npmpkg-whatwg-url-11.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/widest-line/-/widest-line-4.0.1.tgz -> npmpkg-widest-line-4.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.14.2.tgz -> npmpkg-ws-8.14.2.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-5.1.0.tgz -> npmpkg-xdg-basedir-5.1.0.tgz
https://registry.npmjs.org/xdg-trashdir/-/xdg-trashdir-3.1.0.tgz -> npmpkg-xdg-trashdir-3.1.0.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> npmpkg-xdg-basedir-4.0.0.tgz
https://registry.npmjs.org/xhr/-/xhr-2.6.0.tgz -> npmpkg-xhr-2.6.0.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-4.0.0.tgz -> npmpkg-xml-name-validator-4.0.0.tgz
https://registry.npmjs.org/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> npmpkg-xml-parse-from-string-1.0.1.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.4.23.tgz -> npmpkg-xml2js-0.4.23.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> npmpkg-xmlbuilder-11.0.1.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yn/-/yn-3.1.1.tgz -> npmpkg-yn-3.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
declare -A DL_REVISIONS=(
	["chromium-linux-glibc-amd64"]="1064"
	["chromium-with-symbols-linux-glibc-amd64"]="1064"
	["chromium-tip-of-tree-linux-glibc-amd64"]="1111"
	["ffmpeg-linux-glibc-amd64"]="1009"
	["firefox-linux-glibc-amd64-ubuntu-20_04"]="1408"
	["firefox-beta-linux-glibc-amd64-ubuntu-20_04"]="1410"
	["webkit-linux-glibc-amd64-ubuntu-20_04"]="1848"
)
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium" ]] ; then
	SRC_URI+="
		amd64? (
			kernel_linux? (
				elibc_glibc? (
https://playwright.azureedge.net/builds/ffmpeg/${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}/ffmpeg-linux.zip
	-> ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}-amd64.zip
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	SRC_URI+="
		chromium? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium/${DL_REVISIONS[chromium-linux-glibc-amd64]}/chromium-linux.zip
	-> chromium-linux-${DL_REVISIONS[chromium-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-with-symbols"( |$) ]] ; then
	SRC_URI+="
		chromium-with-symbols? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium/${DL_REVISIONS[chromium-with-symbols-linux-glibc-amd64]}/chromium-with-symbols-linux.zip
	-> chromium-with-symbols-linux-${DL_REVISIONS[chromium-with-symbols-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	SRC_URI+="
		chromium-tip-of-tree? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium-tip-of-tree/${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-amd64]}/chromium-tip-of-tree-linux.zip
	-> chromium-tip-of-tree-linux-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	SRC_URI+="
		firefox? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-20_04]}/firefox-ubuntu-20.04.zip
	-> firefox-ubuntu-20.04-${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	SRC_URI+="
		firefox-beta? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-20_04]}/firefox-beta-ubuntu-20.04.zip
	-> firefox-beta-ubuntu-20.04-${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	SRC_URI+="
		webkit? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/webkit/${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-20_04]}/webkit-ubuntu-20.04.zip
	-> webkit-ubuntu-20.04-${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
					)
				)
			)
		)
	"
fi

S="${WORKDIR}/${PN}-${PV}"

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download a web browser."
eerror
		die
	fi
}

pkg_setup() {
	check_network_sandbox
	npm_pkg_setup
}

npm_update_lock_install_pre() {
	# This is to prevent the sudden ***untrustworthy*** sudo prompt.
	sed -i -e "s|npx playwright|true npx playwright|g" package.json || die
}

enpx() {
einfo "Running:  npx ${@}"
	npx "${@}" || die
}

get_ffmpeg_tarball_name() {
	echo "ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-${ABI}]}-${ABI}.zip"
}

get_browser_tarball_name() {
	if has chromium ${IUSE} && use chromium ; then
		echo "chromium-linux-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has chromium-with-symbols ${IUSE} && use chromium-with-symbols ; then
		echo "chromium-with-symbols-linux-${DL_REVISIONS[chromium-with-symbols-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has chromium-tip-of-tree-linux ${IUSE} && use chromium-tip-of-tree-linux ; then
		echo "chromium-tip-of-tree-linux-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has firefox ${IUSE} && use firefox ; then
		echo "firefox-ubuntu-20.04-${DL_REVISIONS[firefox-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has firefox-beta ${IUSE} && use firefox-beta ; then
		echo "firefox-beta-ubuntu-20.04-${DL_REVISIONS[firefox-beta-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has webkit ${IUSE} && use webkit ; then
		echo "webkit-ubuntu-20.04-${DL_REVISIONS[webkit-linux-glibc-${ABI}]}-${ABI}.zip"
	else
eerror
eerror "Browser not supported or not selected"
eerror
		die
	fi
}

get_browser_folder_name() {
	if has chromium ${IUSE} && use chromium ; then
		echo "chromium-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}"
	elif has chromium-with-symbols ${IUSE} && use chromium-with-symbols ; then
		echo "chromium_with_symbols-${DL_REVISIONS[chromium-with-symbols-linux-glibc-${ABI}]}"
	elif has chromium-tip-of-tree-linux ${IUSE} && use chromium-tip-of-tree-linux ; then
		echo "chromium_tip_of_tree-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}"
	elif has firefox ${IUSE} && use firefox ; then
		echo "firefox-${DL_REVISIONS[firefox-linux-glibc-${ABI}]}"
	elif has firefox-beta ${IUSE} && use firefox-beta ; then
		echo "firefox_beta-${DL_REVISIONS[firefox-beta-linux-glibc-${ABI}]}"
	elif has webkit ${IUSE} && use webkit ; then
		echo "webkit-${DL_REVISIONS[webkit-linux-glibc-${ABI}]}"
	else
eerror
eerror "Browser not supported or not selected"
eerror
		die
	fi
}

npm_unpack_install_post() {
	# See
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/src/server/registry/index.ts#L232
	# https://github.com/microsoft/playwright/blob/v1.34.3/docs/src/browsers.md
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/src/server/registry/nativeDeps.ts
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/browsers.json

	local choice
	local x
	for x in ${PLAYWRIGHT_BROWSERS[@]} ; do
		if has ${x} ${IUSE} && use "${x}" ; then
			choice="${x}"
			break
		fi
	done

	if [[ -z "${choice}" ]] ; then
eerror "You must choose a web browser."
		die
	fi
einfo "choice: ${choice}"

	if use chromium ; then
		mkdir -p "node_modules/playwright-core/.local-browsers"
	fi

	# https://github.com/microsoft/playwright/blob/v1.34.3/docs/src/browsers.md#hermetic-install
	export PLAYWRIGHT_BROWSERS_PATH=0
	cd "${S}" || die
	# The sandbox doesn't want us to download even though it is permitted.
	export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
	export PLAYWRIGHT_SKIP_BROWSER_GC=1
	local d="node_modules/playwright-core/.local-browsers/$(get_browser_folder_name)"
	mkdir -p "${d}" || die
	touch "${d}/INSTALLATION_COMPLETE" || die

	cd "${S}/${d}" || die
	unpack $(get_browser_tarball_name)
	if use chromium \
		|| use chromium-with-symbols \
		|| use chromium-tip-of-tree ; then
		local d="node_modules/playwright-core/.local-browsers/ffmpeg-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}"
		mkdir -p "${d}" || die
		cd "${d}" || die
		touch "INSTALLATION_COMPLETE" || die
		unpack $(get_ffmpeg_tarball_name)
	fi
	cd "${S}" || die
	if [[ ! -e "node_modules/playwright-core/.local-browsers" ]] ; then
eerror
eerror "Missing node_modules/playwright-core/.local-browsers"
eerror
		die
	fi
	enpx playwright install ${choice}
}

src_compile() {
	enpm run build
}

src_install() {
	local NPM_EXE_LIST=(
		$(find . -executable -type f \
			| sort \
			| uniq \
			| grep -v "\.ts$" \
			| grep -v "\.png$" \
			| grep -v "\.fnt$" \
			| grep -v "\.md" \
			| grep -i -v "LICENSE" \
			| sed -e "s|^./||g" \
			| sed -e "/\.husky/d")
	)
	insinto "${NPM_INSTALL_PATH}"
	doins -r *

	local path
	for path in ${NPM_EXE_LIST[@]} ; do
		fperms 0755 "${path}"
	done

	cp "${FILESDIR}/${MY_PN}" "${T}" || die
	sed -i -e "s|__NODE_VERSION__|${NODE_VERSION}|g" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_SKIP_BROWSER_GC=1" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_BROWSERS_PATH=0" \
		"${T}/${MY_PN}" \
		|| die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	local path
	for path in ${NPM_EXE_LIST[@]} ; do
		fperms 0755 "${NPM_INSTALL_PATH}/${path}"
	done
ewarn
ewarn "This package should be re-installed every week since it uses an old browser."
ewarn
	fperms 0755 "${NPM_INSTALL_PATH}/dist/cli.js"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.0.0 (20230604)
