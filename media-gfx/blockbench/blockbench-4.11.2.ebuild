# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

export NPM_INSTALL_PATH="/opt/${PN}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}_${PV}.AppImage"
ELECTRON_APP_ELECTRON_PV="34.0.0-beta.7" # Cr 132.0.6834.15, node 20.18.1
ELECTRON_APP_MODE="npm"
NODE_ENV="development"
NODE_VERSION=20 # This corresponds to the node major version in releases.json.
if [[ "${NPM_UPDATE_LOCK}" != "1" ]] ; then
	NPM_INSTALL_ARGS="--force"
fi
# See https://releases.electronjs.org/releases.json

inherit desktop edo electron-app lcnr npm

# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/blockbench-4.10.2/work/blockbench-4.10.2/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.3.0.tgz -> npmpkg-@ampproject-remapping-2.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.26.2.tgz -> npmpkg-@babel-code-frame-7.26.2.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.26.2.tgz -> npmpkg-@babel-compat-data-7.26.2.tgz
https://registry.npmjs.org/@babel/core/-/core-7.26.0.tgz -> npmpkg-@babel-core-7.26.0.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.26.2.tgz -> npmpkg-@babel-generator-7.26.2.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.25.9.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.25.9.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.9.tgz -> npmpkg-@babel-helper-compilation-targets-7.25.9.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.25.9.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.25.9.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.6.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.6.3.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.25.9.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.25.9.tgz -> npmpkg-@babel-helper-module-imports-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.26.0.tgz -> npmpkg-@babel-helper-module-transforms-7.26.0.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.25.9.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.25.9.tgz -> npmpkg-@babel-helper-plugin-utils-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.25.9.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.25.9.tgz -> npmpkg-@babel-helper-replace-supers-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.25.9.tgz -> npmpkg-@babel-helper-simple-access-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.25.9.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.25.9.tgz -> npmpkg-@babel-helper-string-parser-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.9.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.25.9.tgz -> npmpkg-@babel-helper-validator-option-7.25.9.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.25.9.tgz -> npmpkg-@babel-helper-wrap-function-7.25.9.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.26.0.tgz -> npmpkg-@babel-helpers-7.26.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.26.2.tgz -> npmpkg-@babel-parser-7.26.2.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-firefox-class-in-computed-class-key/-/plugin-bugfix-firefox-class-in-computed-class-key-7.25.9.tgz -> npmpkg-@babel-plugin-bugfix-firefox-class-in-computed-class-key-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-class-field-initializer-scope/-/plugin-bugfix-safari-class-field-initializer-scope-7.25.9.tgz -> npmpkg-@babel-plugin-bugfix-safari-class-field-initializer-scope-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.25.9.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.25.9.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-static-class-fields-redefine-readonly/-/plugin-bugfix-v8-static-class-fields-redefine-readonly-7.25.9.tgz -> npmpkg-@babel-plugin-bugfix-v8-static-class-fields-redefine-readonly-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.26.0.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.26.0.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.26.0.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.26.0.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.25.9.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.25.9.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.25.9.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.25.9.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.25.9.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.25.9.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.26.0.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.26.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.25.9.tgz -> npmpkg-@babel-plugin-transform-classes-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.25.9.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.25.9.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.25.9.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-named-capturing-groups-regex/-/plugin-transform-duplicate-named-capturing-groups-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-duplicate-named-capturing-groups-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.25.9.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.25.9.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.25.9.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.25.9.tgz -> npmpkg-@babel-plugin-transform-for-of-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.25.9.tgz -> npmpkg-@babel-plugin-transform-function-name-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.25.9.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.25.9.tgz -> npmpkg-@babel-plugin-transform-literals-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.25.9.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.25.9.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.25.9.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.25.9.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.25.9.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.25.9.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.25.9.tgz -> npmpkg-@babel-plugin-transform-new-target-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.25.9.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.25.9.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.25.9.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.25.9.tgz -> npmpkg-@babel-plugin-transform-object-super-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.25.9.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.25.9.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.25.9.tgz -> npmpkg-@babel-plugin-transform-parameters-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.25.9.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.25.9.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.25.9.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.25.9.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-regexp-modifiers/-/plugin-transform-regexp-modifiers-7.26.0.tgz -> npmpkg-@babel-plugin-transform-regexp-modifiers-7.26.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.25.9.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.25.9.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.25.9.tgz -> npmpkg-@babel-plugin-transform-spread-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.25.9.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.25.9.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.25.9.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.25.9.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.25.9.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.26.0.tgz -> npmpkg-@babel-preset-env-7.26.0.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> npmpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.26.0.tgz -> npmpkg-@babel-runtime-7.26.0.tgz
https://registry.npmjs.org/@babel/template/-/template-7.25.9.tgz -> npmpkg-@babel-template-7.25.9.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.9.tgz -> npmpkg-@babel-traverse-7.25.9.tgz
https://registry.npmjs.org/@babel/types/-/types-7.26.0.tgz -> npmpkg-@babel-types-7.26.0.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> npmpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.17.tgz -> npmpkg-@electron-asar-3.2.17.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.5.0.tgz -> npmpkg-@electron-notarize-2.5.0.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.3.1.tgz -> npmpkg-@electron-osx-sign-1.3.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/@electron/rebuild/-/rebuild-3.6.1.tgz -> npmpkg-@electron-rebuild-3.6.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.1.2.tgz -> npmpkg-@electron-remote-2.1.2.tgz
https://registry.npmjs.org/@electron/universal/-/universal-2.0.1.tgz -> npmpkg-@electron-universal-2.0.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/@gar/promisify/-/promisify-1.1.3.tgz -> npmpkg-@gar-promisify-1.1.3.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.6.tgz -> npmpkg-@jridgewell-source-map-0.3.6.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-2.0.0.tgz -> npmpkg-@malept-cross-spawn-promise-2.0.0.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-2.1.2.tgz -> npmpkg-@npmcli-fs-2.1.2.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/@npmcli/move-file/-/move-file-2.0.1.tgz -> npmpkg-@npmcli-move-file-2.0.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@rollup/plugin-babel/-/plugin-babel-5.3.1.tgz -> npmpkg-@rollup-plugin-babel-5.3.1.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-11.2.1.tgz -> npmpkg-@rollup-plugin-node-resolve-11.2.1.tgz
https://registry.npmjs.org/@rollup/plugin-replace/-/plugin-replace-2.4.2.tgz -> npmpkg-@rollup-plugin-replace-2.4.2.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-3.1.0.tgz -> npmpkg-@rollup-pluginutils-3.1.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-0.0.39.tgz -> npmpkg-@types-estree-0.0.39.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@surma/rollup-plugin-off-main-thread/-/rollup-plugin-off-main-thread-2.2.3.tgz -> npmpkg-@surma-rollup-plugin-off-main-thread-2.2.3.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/dompurify/-/dompurify-3.2.0.tgz -> npmpkg-@types-dompurify-3.2.0.tgz
https://registry.npmjs.org/@types/eslint/-/eslint-9.6.1.tgz -> npmpkg-@types-eslint-9.6.1.tgz
https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.7.tgz -> npmpkg-@types-eslint-scope-3.7.7.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/jquery/-/jquery-3.5.32.tgz -> npmpkg-@types-jquery-3.5.32.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-20.17.9.tgz -> npmpkg-@types-node-20.17.9.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.5.tgz -> npmpkg-@types-plist-3.0.5.tgz
https://registry.npmjs.org/@types/prismjs/-/prismjs-1.26.5.tgz -> npmpkg-@types-prismjs-1.26.5.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.17.1.tgz -> npmpkg-@types-resolve-1.17.1.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/sizzle/-/sizzle-2.3.9.tgz -> npmpkg-@types-sizzle-2.3.9.tgz
https://registry.npmjs.org/@types/three/-/three-0.129.2.tgz -> npmpkg-@types-three-0.129.2.tgz
https://registry.npmjs.org/@types/tinycolor2/-/tinycolor2-1.4.6.tgz -> npmpkg-@types-tinycolor2-1.4.6.tgz
https://registry.npmjs.org/@types/trusted-types/-/trusted-types-2.0.7.tgz -> npmpkg-@types-trusted-types-2.0.7.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.10.tgz -> npmpkg-@types-verror-1.10.10.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.3.tgz -> npmpkg-@types-yauzl-2.10.3.tgz
https://registry.npmjs.org/@vue/compiler-sfc/-/compiler-sfc-2.7.14.tgz -> npmpkg-@vue-compiler-sfc-2.7.14.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.14.1.tgz -> npmpkg-@webassemblyjs-ast-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.13.2.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.14.1.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.13.2.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.14.1.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.13.2.tgz -> npmpkg-@webassemblyjs-ieee754-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.13.2.tgz -> npmpkg-@webassemblyjs-leb128-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.13.2.tgz -> npmpkg-@webassemblyjs-utf8-1.13.2.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.14.1.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.14.1.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.14.1.tgz -> npmpkg-@webassemblyjs-wast-printer-1.14.1.tgz
https://registry.npmjs.org/@webpack-cli/configtest/-/configtest-1.2.0.tgz -> npmpkg-@webpack-cli-configtest-1.2.0.tgz
https://registry.npmjs.org/@webpack-cli/info/-/info-1.5.0.tgz -> npmpkg-@webpack-cli-info-1.5.0.tgz
https://registry.npmjs.org/@webpack-cli/serve/-/serve-1.7.0.tgz -> npmpkg-@webpack-cli-serve-1.7.0.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.2.0.tgz -> npmpkg-7zip-bin-5.2.0.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.14.0.tgz -> npmpkg-acorn-8.14.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/agentkeepalive/-/agentkeepalive-4.5.0.tgz -> npmpkg-agentkeepalive-4.5.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-5.0.0-alpha.10.tgz -> npmpkg-app-builder-bin-5.0.0-alpha.10.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-25.1.8.tgz -> npmpkg-app-builder-lib-25.1.8.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-10.0.1.tgz -> npmpkg-minimatch-10.0.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/aproba/-/aproba-2.0.0.tgz -> npmpkg-aproba-2.0.0.tgz
https://registry.npmjs.org/archiver/-/archiver-5.3.2.tgz -> npmpkg-archiver-5.3.2.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-2.1.0.tgz -> npmpkg-archiver-utils-2.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-3.0.1.tgz -> npmpkg-are-we-there-yet-3.0.1.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.12.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.12.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.10.6.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.10.6.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.6.3.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.6.3.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/blockbench-types/-/blockbench-types-4.11.1.tgz -> npmpkg-blockbench-types-4.11.1.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.2.tgz -> npmpkg-browserslist-4.24.2.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-25.1.7.tgz -> npmpkg-builder-util-25.1.7.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.10.tgz -> npmpkg-builder-util-runtime-9.2.10.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz -> npmpkg-builtin-modules-3.3.0.tgz
https://registry.npmjs.org/cacache/-/cacache-16.1.3.tgz -> npmpkg-cacache-16.1.3.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001684.tgz -> npmpkg-caniuse-lite-1.0.30001684.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.4.tgz -> npmpkg-chrome-trace-event-1.0.4.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.9.2.tgz -> npmpkg-cli-spinners-2.9.2.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz -> npmpkg-clone-deep-4.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz -> npmpkg-color-support-1.1.3.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz -> npmpkg-colorette-2.0.20.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/common-tags/-/common-tags-1.8.2.tgz -> npmpkg-common-tags-1.8.2.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-4.1.2.tgz -> npmpkg-compress-commons-4.1.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-file-ts/-/config-file-ts-0.2.8-rc1.tgz -> npmpkg-config-file-ts-0.2.8-rc1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/typescript/-/typescript-5.7.2.tgz -> npmpkg-typescript-5.7.2.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.39.0.tgz -> npmpkg-core-js-compat-3.39.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc-32/-/crc-32-1.2.2.tgz -> npmpkg-crc-32-1.2.2.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-4.0.3.tgz -> npmpkg-crc32-stream-4.0.3.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz -> npmpkg-cross-spawn-7.0.6.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/defaults/-/defaults-1.0.4.tgz -> npmpkg-defaults-1.0.4.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.3.tgz -> npmpkg-detect-libc-2.0.3.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-4.2.0.tgz -> npmpkg-dir-compare-4.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-25.1.8.tgz -> npmpkg-dmg-builder-25.1.8.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dompurify/-/dompurify-3.2.2.tgz -> npmpkg-dompurify-3.2.2.tgz
https://registry.npmjs.org/dotenv/-/dotenv-16.4.5.tgz -> npmpkg-dotenv-16.4.5.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-11.0.7.tgz -> npmpkg-dotenv-expand-11.0.7.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron/-/electron-31.7.5.tgz -> npmpkg-electron-31.7.5.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-25.1.8.tgz -> npmpkg-electron-builder-25.1.8.tgz
https://registry.npmjs.org/electron-builder-squirrel-windows/-/electron-builder-squirrel-windows-25.1.8.tgz -> npmpkg-electron-builder-squirrel-windows-25.1.8.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/electron-color-picker/-/electron-color-picker-0.2.0.tgz -> npmpkg-electron-color-picker-0.2.0.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-25.1.7.tgz -> npmpkg-electron-publish-25.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.67.tgz -> npmpkg-electron-to-chromium-1.5.67.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-6.3.9.tgz -> npmpkg-electron-updater-6.3.9.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz -> npmpkg-encoding-0.1.13.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.17.1.tgz -> npmpkg-enhanced-resolve-5.17.1.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/envinfo/-/envinfo-7.14.0.tgz -> npmpkg-envinfo-7.14.0.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.5.tgz -> npmpkg-es-abstract-1.23.5.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.5.4.tgz -> npmpkg-es-module-lexer-1.5.4.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz -> npmpkg-es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> npmpkg-es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.3.0.tgz -> npmpkg-es-to-primitive-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-1.0.1.tgz -> npmpkg-estree-walker-1.0.1.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/exponential-backoff/-/exponential-backoff-3.1.1.tgz -> npmpkg-exponential-backoff-3.1.1.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.0.3.tgz -> npmpkg-fast-uri-3.0.3.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.1.tgz -> npmpkg-form-data-4.0.1.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gauge/-/gauge-4.0.4.tgz -> npmpkg-gauge-4.0.4.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.2.tgz -> npmpkg-get-own-enumerable-property-symbols-3.0.2.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/gifenc/-/gifenc-1.0.3.tgz -> npmpkg-gifenc-1.0.3.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.1.0.tgz -> npmpkg-gopd-1.1.0.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> npmpkg-https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/humanize-ms/-/humanize-ms-1.2.1.tgz -> npmpkg-humanize-ms-1.2.1.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/import-local/-/import-local-3.2.0.tgz -> npmpkg-import-local-3.2.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/interpret/-/interpret-2.2.0.tgz -> npmpkg-interpret-2.2.0.tgz
https://registry.npmjs.org/ip-address/-/ip-address-9.0.5.tgz -> npmpkg-ip-address-9.0.5.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-async-function/-/is-async-function-2.0.0.tgz -> npmpkg-is-async-function-2.0.0.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-finalizationregistry/-/is-finalizationregistry-1.1.0.tgz -> npmpkg-is-finalizationregistry-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.0.10.tgz -> npmpkg-is-generator-function-1.0.10.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-1.0.0.tgz -> npmpkg-is-interactive-1.0.0.tgz
https://registry.npmjs.org/is-lambda/-/is-lambda-1.0.1.tgz -> npmpkg-is-lambda-1.0.1.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz -> npmpkg-is-map-2.0.3.tgz
https://registry.npmjs.org/is-module/-/is-module-1.0.0.tgz -> npmpkg-is-module-1.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-1.0.1.tgz -> npmpkg-is-obj-1.0.1.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.2.0.tgz -> npmpkg-is-regex-1.2.0.tgz
https://registry.npmjs.org/is-regexp/-/is-regexp-1.0.0.tgz -> npmpkg-is-regexp-1.0.0.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz -> npmpkg-is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz -> npmpkg-is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.3.tgz -> npmpkg-is-weakset-2.0.3.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.4.tgz -> npmpkg-isbinaryfile-5.0.4.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/jake/-/jake-10.9.2.tgz -> npmpkg-jake-10.9.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz -> npmpkg-jest-worker-27.5.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsbn/-/jsbn-1.1.0.tgz -> npmpkg-jsbn-1.1.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-3.0.2.tgz -> npmpkg-jsesc-3.0.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonpointer/-/jsonpointer-5.0.1.tgz -> npmpkg-jsonpointer-5.0.1.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/leven/-/leven-3.1.0.tgz -> npmpkg-leven-3.1.0.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.escaperegexp/-/lodash.escaperegexp-4.1.2.tgz -> npmpkg-lodash.escaperegexp-4.1.2.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> npmpkg-lodash.sortby-4.7.0.tgz
https://registry.npmjs.org/lodash.union/-/lodash.union-4.6.0.tgz -> npmpkg-lodash.union-4.6.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.25.9.tgz -> npmpkg-magic-string-0.25.9.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> npmpkg-make-fetch-happen-10.2.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-collect/-/minipass-collect-1.0.2.tgz -> npmpkg-minipass-collect-1.0.2.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> npmpkg-minipass-fetch-2.1.2.tgz
https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz -> npmpkg-minipass-flush-1.0.5.tgz
https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> npmpkg-minipass-pipeline-1.2.4.tgz
https://registry.npmjs.org/minipass-sized/-/minipass-sized-1.0.3.tgz -> npmpkg-minipass-sized-1.0.3.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/molangjs/-/molangjs-1.6.5.tgz -> npmpkg-molangjs-1.6.5.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.8.tgz -> npmpkg-nanoid-3.3.8.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.4.tgz -> npmpkg-negotiator-0.6.4.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/node-abi/-/node-abi-3.71.0.tgz -> npmpkg-node-abi-3.71.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-api-version/-/node-api-version-0.2.0.tgz -> npmpkg-node-api-version-0.2.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/node-gyp/-/node-gyp-9.4.1.tgz -> npmpkg-node-gyp-9.4.1.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/nopt/-/nopt-6.0.0.tgz -> npmpkg-nopt-6.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-6.0.2.tgz -> npmpkg-npmlog-6.0.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.3.tgz -> npmpkg-object-inspect-1.13.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/ora/-/ora-5.4.1.tgz -> npmpkg-ora-5.4.1.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/pe-library/-/pe-library-0.4.1.tgz -> npmpkg-pe-library-0.4.1.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz -> npmpkg-picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.49.tgz -> npmpkg-postcss-8.4.49.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> npmpkg-pretty-bytes-5.6.0.tgz
https://registry.npmjs.org/prismjs/-/prismjs-1.29.0.tgz -> npmpkg-prismjs-1.29.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/read-binary-file-arch/-/read-binary-file-arch-1.0.6.tgz -> npmpkg-read-binary-file-arch-1.0.6.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdir-glob/-/readdir-glob-1.1.3.tgz -> npmpkg-readdir-glob-1.1.3.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.7.1.tgz -> npmpkg-rechoir-0.7.1.tgz
https://registry.npmjs.org/reflect.getprototypeof/-/reflect.getprototypeof-1.0.7.tgz -> npmpkg-reflect.getprototypeof-1.0.7.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.2.0.tgz -> npmpkg-regenerate-unicode-properties-10.2.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> npmpkg-regenerator-runtime-0.14.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.3.tgz -> npmpkg-regexp.prototype.flags-1.5.3.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-6.2.0.tgz -> npmpkg-regexpu-core-6.2.0.tgz
https://registry.npmjs.org/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-regjsgen-0.8.0.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.12.0.tgz -> npmpkg-regjsparser-0.12.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/resedit/-/resedit-1.7.2.tgz -> npmpkg-resedit-1.7.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/rollup/-/rollup-2.79.2.tgz -> npmpkg-rollup-2.79.2.tgz
https://registry.npmjs.org/rollup-plugin-terser/-/rollup-plugin-terser-7.0.2.tgz -> npmpkg-rollup-plugin-terser-7.0.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.4.1.tgz -> npmpkg-sax-1.4.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz -> npmpkg-shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/socks/-/socks-2.8.3.tgz -> npmpkg-socks-2.8.3.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> npmpkg-socks-proxy-agent-7.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> npmpkg-sourcemap-codec-1.4.8.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/ssri/-/ssri-9.0.1.tgz -> npmpkg-ssri-9.0.1.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz -> npmpkg-string_decoder-1.3.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.11.tgz -> npmpkg-string.prototype.matchall-4.0.11.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/stringify-object/-/stringify-object-3.3.0.tgz -> npmpkg-stringify-object-3.3.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-comments/-/strip-comments-2.0.1.tgz -> npmpkg-strip-comments-2.0.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/tar/-/tar-6.2.1.tgz -> npmpkg-tar-6.2.1.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-2.0.0.tgz -> npmpkg-temp-dir-2.0.0.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/tempy/-/tempy-0.6.0.tgz -> npmpkg-tempy-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/terser/-/terser-5.36.0.tgz -> npmpkg-terser-5.36.0.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz -> npmpkg-terser-webpack-plugin-5.3.10.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/three/-/three-0.134.0.tgz -> npmpkg-three-0.134.0.tgz
https://registry.npmjs.org/tiny-typed-emitter/-/tiny-typed-emitter-2.1.0.tgz -> npmpkg-tiny-typed-emitter-2.1.0.tgz
https://registry.npmjs.org/tinycolor2/-/tinycolor2-1.6.0.tgz -> npmpkg-tinycolor2-1.6.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz -> npmpkg-tmp-0.2.3.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.3.tgz -> npmpkg-typed-array-byte-offset-1.0.3.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.7.tgz -> npmpkg-typed-array-length-1.0.7.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz -> npmpkg-undici-types-6.19.8.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.1.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.1.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.2.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.2.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-2.0.1.tgz -> npmpkg-unique-filename-2.0.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-3.0.0.tgz -> npmpkg-unique-slug-3.0.0.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.5.tgz -> npmpkg-utf8-byte-length-1.0.5.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/vue/-/vue-2.7.14.tgz -> npmpkg-vue-2.7.14.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.2.tgz -> npmpkg-watchpack-2.4.2.tgz
https://registry.npmjs.org/wcwidth/-/wcwidth-1.0.1.tgz -> npmpkg-wcwidth-1.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/webpack/-/webpack-5.96.1.tgz -> npmpkg-webpack-5.96.1.tgz
https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.10.0.tgz -> npmpkg-webpack-cli-4.10.0.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/webpack-merge/-/webpack-merge-5.10.0.tgz -> npmpkg-webpack-merge-5.10.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-builtin-type/-/which-builtin-type-1.2.0.tgz -> npmpkg-which-builtin-type-1.2.0.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz -> npmpkg-which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.16.tgz -> npmpkg-which-typed-array-1.1.16.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz -> npmpkg-wide-align-1.1.5.tgz
https://registry.npmjs.org/wildcard/-/wildcard-2.0.1.tgz -> npmpkg-wildcard-2.0.1.tgz
https://registry.npmjs.org/wintersky/-/wintersky-1.3.2.tgz -> npmpkg-wintersky-1.3.2.tgz
https://registry.npmjs.org/workbox-background-sync/-/workbox-background-sync-6.6.0.tgz -> npmpkg-workbox-background-sync-6.6.0.tgz
https://registry.npmjs.org/workbox-broadcast-update/-/workbox-broadcast-update-6.6.0.tgz -> npmpkg-workbox-broadcast-update-6.6.0.tgz
https://registry.npmjs.org/workbox-build/-/workbox-build-6.6.0.tgz -> npmpkg-workbox-build-6.6.0.tgz
https://registry.npmjs.org/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> npmpkg-@apideck-better-ajv-errors-0.3.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.8.0-beta.0.tgz -> npmpkg-source-map-0.8.0-beta.0.tgz
https://registry.npmjs.org/workbox-cacheable-response/-/workbox-cacheable-response-6.6.0.tgz -> npmpkg-workbox-cacheable-response-6.6.0.tgz
https://registry.npmjs.org/workbox-core/-/workbox-core-6.6.0.tgz -> npmpkg-workbox-core-6.6.0.tgz
https://registry.npmjs.org/workbox-expiration/-/workbox-expiration-6.6.0.tgz -> npmpkg-workbox-expiration-6.6.0.tgz
https://registry.npmjs.org/workbox-google-analytics/-/workbox-google-analytics-6.6.0.tgz -> npmpkg-workbox-google-analytics-6.6.0.tgz
https://registry.npmjs.org/workbox-navigation-preload/-/workbox-navigation-preload-6.6.0.tgz -> npmpkg-workbox-navigation-preload-6.6.0.tgz
https://registry.npmjs.org/workbox-precaching/-/workbox-precaching-6.6.0.tgz -> npmpkg-workbox-precaching-6.6.0.tgz
https://registry.npmjs.org/workbox-range-requests/-/workbox-range-requests-6.6.0.tgz -> npmpkg-workbox-range-requests-6.6.0.tgz
https://registry.npmjs.org/workbox-recipes/-/workbox-recipes-6.6.0.tgz -> npmpkg-workbox-recipes-6.6.0.tgz
https://registry.npmjs.org/workbox-routing/-/workbox-routing-6.6.0.tgz -> npmpkg-workbox-routing-6.6.0.tgz
https://registry.npmjs.org/workbox-strategies/-/workbox-strategies-6.6.0.tgz -> npmpkg-workbox-strategies-6.6.0.tgz
https://registry.npmjs.org/workbox-streams/-/workbox-streams-6.6.0.tgz -> npmpkg-workbox-streams-6.6.0.tgz
https://registry.npmjs.org/workbox-sw/-/workbox-sw-6.6.0.tgz -> npmpkg-workbox-sw-6.6.0.tgz
https://registry.npmjs.org/workbox-window/-/workbox-window-6.6.0.tgz -> npmpkg-workbox-window-6.6.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-4.1.1.tgz -> npmpkg-zip-stream-4.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-3.0.4.tgz -> npmpkg-archiver-utils-3.0.4.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/JannisX11/blockbench/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"

DESCRIPTION="Blockbench is a boxy 3D model editor"
HOMEPAGE="https://www.blockbench.net"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	0BSD
	BSD
	BSD-2
	CC-BY-4.0
	CC0-1.0
	ISC
	MIT
	|| (
		AFL-2.1
		BSD
	)
" # ^^ (mutual exclusion) is not supported. \
# || assumes that user chooses outside of computer.
LICENSE="
	${THIRD_PARTY_LICENSES}
	(
		${ELECTRON_APP_LICENSES}
		Artistic-2
		electron-34.0.0-beta.7-chromium.html
	)
	GPL-3+
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ^^ ( BSD AFL-2.1 ) - node_modules/json-schema/LICENSE
# Apache-2.0 - node_modules/wintersky/node_modules/three/examples/fonts/droid/NOTICE
# 0BSD - node_modules/rxjs/node_modules/tslib/CopyrightNotice.txt
# BSD - node_modules/json-schema/LICENSE
# BSD-2 - node_modules/configstore/license
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# ISC - node_modules/webpack/node_modules/graceful-fs/LICENSE
# MIT - node_modules/p-locate/node_modules/p-limit/license
# MIT all-rights-reserved - work/blockbench-4.5.2/node_modules/minizlib/LICENSE
# MIT, CC0-1.0 - node_modules/lodash.sortby/LICENSE
# GPL-3 - LICENSE.MD

# For Electron 21.2.2: \
# custom \
#   search "with the mathematical derivations" \
# ( LGPL-2.1+ MIT BSD GPL-2+ ) \
# ( MPL2 || ( BSD LGPL ) ) \
# ( MIT SGI-Free-B SGI-copyright LGPL Mark's-copyright BSD ) \
# ( MIT all-rights-reserved ) \
# ( HPND all-rights-reserved ) \
# ( CC-BY-3.0 MIT CC-BY public-domain ) \
# ( BSD BSD-2 ) \
# android \
# AFL-2.0 \
# Apache-2.0 \
# Apache-2.0-with-LLVM-exceptions \
# APSL-2 \
# Artistic-2 \
# BitstreamVera \
# Boost-1.0 \
# BSD \
# BSD-2 \
# BSD-4 \
# BSD-Protection  \
# CC∅ Public Domain Affirmation and Waiver 1.0 United States (https://www.creativecommons.org/licenses/zero-waive/1.0/us/legalcode) \
# CPL-1.0 \
# curl \
# EPL-1.0 \
# FLEX \
# FTL \
# GPL-2 \
# GPL-2+ \
# GPL-2-with-classpath-exception \
# GPL-3 \
# GPL-3+ \
# HPND \
# icu-70.1 \
# icu-1.8.1 \
# IJG \
# ISC \
# Khronos-CLHPP \
# libpng \
# libpng2 \
# libstdc++ \
# LGPL-2.1 \
# LGPL-3 \
# MIT \
# MPL-1.1 \
# MPL-2.0 \
# Ms-PL \
# neon_2_sse \
# NEWLIB-extra \
# OFL-1.1 \
# ooura \
# openssl \
# public-domain \
# PCRE8 (BSD) \
# SunPro \
# unicode \
# Unicode-DFS-2016 \
# UoI-NCSA \
# unRAR \
# libwebm-PATENTS \
# ZLIB \
# || ( MIT public-domain ( MIT public-domain )) \
# || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
# - node_modules/electron/dist/LICENSES.chromium.html

RESTRICT="mirror"
SLOT="0"
IUSE+=" ebuild_revision_2"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"

src_unpack() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		npm_hydrate
		unpack ${P}.tar.gz
		cd "${S}" || die

		rm -vf package-lock.json
		enpm install \
			${NPM_INSTALL_ARGS[@]}

		enpm install "electron-builder@25.1.8"

		enpm audit fix \
			${NPM_AUDIT_FIX_ARGS[@]}

		_npm_check_errors
einfo "Updating lockfile done."
		exit 0
	else
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		npm_src_unpack
if false ; then
		cd "${S}" || die
		local pos
		pos=$(grep -n -e "appId" "package.json" \
			| cut -f 1 -d ":")
einfo "DEBUG: pos: ${pos}"
		[[ -z "${pos}" ]] && die
		pos=$(( ${pos} + 1 ))
		sed -i -e "${pos}a \\\t\t\"npmRebuild\": false," "package.json" || die
fi
	fi
}

src_compile() {
	npm_hydrate
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"

	export ELECTRON_CUSTOM_DIR="v${ELECTRON_APP_ELECTRON_PV}"

	# The zip gets wiped for some reason in src_unpack.
	electron-app_cp_electron

	edo electron-builder \
		$(electron-app_get_electron_platarch_args) \
		-l dir \
		-c.electronDownload.customFilename="electron-v${ELECTRON_APP_ELECTRON_PV}-$(electron-app_get_electron_platarch).zip" \
		|| die
}

src_install() {
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "icon.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Graphics;3DGraphics"
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/blockbench"
	lcnr_install_files
	electron-app_set_sandbox_suid "/opt/blockbench/chrome-sandbox"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.11.2 (20241130)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.7.4 (20230528)
# preview (saved screenshot):  passed (vertically stacked rotated cubes)
