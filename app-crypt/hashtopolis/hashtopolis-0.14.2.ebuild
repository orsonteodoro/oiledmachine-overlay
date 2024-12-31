# Copyrgiht 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To generate lockfiles do:
# PATH="${OILEDMACHINE_OVERLAY_PATH}/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="web-ui-0.14.2" NPM_UPDATER_VERSIONS="0.14.2" npm_updater_update_locks.sh

PYTHON_COMPAT=( python3_10 python3_11 )
HASTOPOLIS_WEBUI_PV="${PV}"
MY_ETCDIR="/etc/webapps/${PF}"
NODE_VERSION=18
NPM_AUDIT_FIX=1
WEBAPP_MANUAL_SLOT="yes"

inherit lcnr npm webapp

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@angular-devkit/architect/-/architect-0.1602.14.tgz -> npmpkg-@angular-devkit-architect-0.1602.14.tgz
https://registry.npmjs.org/@angular-devkit/build-angular/-/build-angular-16.2.14.tgz -> npmpkg-@angular-devkit-build-angular-16.2.14.tgz
https://registry.npmjs.org/@angular-devkit/build-webpack/-/build-webpack-0.1602.14.tgz -> npmpkg-@angular-devkit-build-webpack-0.1602.14.tgz
https://registry.npmjs.org/@angular-devkit/core/-/core-16.2.14.tgz -> npmpkg-@angular-devkit-core-16.2.14.tgz
https://registry.npmjs.org/@angular-devkit/schematics/-/schematics-16.2.14.tgz -> npmpkg-@angular-devkit-schematics-16.2.14.tgz
https://registry.npmjs.org/@angular-eslint/builder/-/builder-16.0.3.tgz -> npmpkg-@angular-eslint-builder-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/bundled-angular-compiler/-/bundled-angular-compiler-16.0.3.tgz -> npmpkg-@angular-eslint-bundled-angular-compiler-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/eslint-plugin-template/-/eslint-plugin-template-16.0.3.tgz -> npmpkg-@angular-eslint-eslint-plugin-template-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/eslint-plugin/-/eslint-plugin-16.0.3.tgz -> npmpkg-@angular-eslint-eslint-plugin-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/schematics/-/schematics-16.0.3.tgz -> npmpkg-@angular-eslint-schematics-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/template-parser/-/template-parser-16.0.3.tgz -> npmpkg-@angular-eslint-template-parser-16.0.3.tgz
https://registry.npmjs.org/@angular-eslint/utils/-/utils-16.0.3.tgz -> npmpkg-@angular-eslint-utils-16.0.3.tgz
https://registry.npmjs.org/@angular/animations/-/animations-16.2.12.tgz -> npmpkg-@angular-animations-16.2.12.tgz
https://registry.npmjs.org/@angular/cli/-/cli-16.2.14.tgz -> npmpkg-@angular-cli-16.2.14.tgz
https://registry.npmjs.org/@angular/common/-/common-16.2.12.tgz -> npmpkg-@angular-common-16.2.12.tgz
https://registry.npmjs.org/@angular/compiler-cli/-/compiler-cli-16.2.12.tgz -> npmpkg-@angular-compiler-cli-16.2.12.tgz
https://registry.npmjs.org/@angular/compiler/-/compiler-16.2.12.tgz -> npmpkg-@angular-compiler-16.2.12.tgz
https://registry.npmjs.org/@angular/core/-/core-16.2.12.tgz -> npmpkg-@angular-core-16.2.12.tgz
https://registry.npmjs.org/@angular/forms/-/forms-16.2.12.tgz -> npmpkg-@angular-forms-16.2.12.tgz
https://registry.npmjs.org/@angular/localize/-/localize-16.2.12.tgz -> npmpkg-@angular-localize-16.2.12.tgz
https://registry.npmjs.org/@angular/platform-browser-dynamic/-/platform-browser-dynamic-16.2.12.tgz -> npmpkg-@angular-platform-browser-dynamic-16.2.12.tgz
https://registry.npmjs.org/@angular/platform-browser/-/platform-browser-16.2.12.tgz -> npmpkg-@angular-platform-browser-16.2.12.tgz
https://registry.npmjs.org/@angular/router/-/router-16.2.12.tgz -> npmpkg-@angular-router-16.2.12.tgz
https://registry.npmjs.org/@assemblyscript/loader/-/loader-0.10.1.tgz -> npmpkg-@assemblyscript-loader-0.10.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.24.7.tgz -> npmpkg-@babel-code-frame-7.24.7.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.24.7.tgz -> npmpkg-@babel-compat-data-7.24.7.tgz
https://registry.npmjs.org/@babel/core/-/core-7.22.9.tgz -> npmpkg-@babel-core-7.22.9.tgz
https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz -> npmpkg-@babel-core-7.23.2.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.22.9.tgz -> npmpkg-@babel-generator-7.22.9.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.24.7.tgz -> npmpkg-@babel-generator-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.24.7.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.24.7.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.24.7.tgz -> npmpkg-@babel-helper-compilation-targets-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.24.7.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.24.7.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.4.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.4.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.5.0.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.5.0.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.6.2.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.6.2.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.24.7.tgz -> npmpkg-@babel-helper-environment-visitor-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.24.7.tgz -> npmpkg-@babel-helper-function-name-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.24.7.tgz -> npmpkg-@babel-helper-hoist-variables-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.24.7.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.24.7.tgz -> npmpkg-@babel-helper-module-imports-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.24.7.tgz -> npmpkg-@babel-helper-module-transforms-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.24.7.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.24.7.tgz -> npmpkg-@babel-helper-plugin-utils-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.24.7.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.24.7.tgz -> npmpkg-@babel-helper-replace-supers-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.24.7.tgz -> npmpkg-@babel-helper-simple-access-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.24.7.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.24.7.tgz -> npmpkg-@babel-helper-split-export-declaration-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.24.7.tgz -> npmpkg-@babel-helper-string-parser-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.24.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.24.7.tgz -> npmpkg-@babel-helper-validator-option-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.24.7.tgz -> npmpkg-@babel-helper-wrap-function-7.24.7.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.24.7.tgz -> npmpkg-@babel-helpers-7.24.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.24.7.tgz -> npmpkg-@babel-highlight-7.24.7.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.24.7.tgz -> npmpkg-@babel-parser-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.24.7.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.24.7.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-async-generator-functions-7.20.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> npmpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.24.7.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.24.7.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.24.7.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.24.7.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.24.7.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.24.7.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.24.7.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.24.7.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.24.7.tgz -> npmpkg-@babel-plugin-transform-classes-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.24.7.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.24.7.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.24.7.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.24.7.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.24.7.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.24.7.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.24.7.tgz -> npmpkg-@babel-plugin-transform-for-of-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.24.7.tgz -> npmpkg-@babel-plugin-transform-function-name-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.24.7.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.24.7.tgz -> npmpkg-@babel-plugin-transform-literals-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.24.7.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.24.7.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.24.7.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.24.7.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.24.7.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.24.7.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.24.7.tgz -> npmpkg-@babel-plugin-transform-new-target-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.24.7.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.24.7.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.24.7.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.24.7.tgz -> npmpkg-@babel-plugin-transform-object-super-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.24.7.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.24.7.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.24.7.tgz -> npmpkg-@babel-plugin-transform-parameters-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.24.7.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.24.7.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.24.7.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.24.7.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.24.7.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.22.9.tgz -> npmpkg-@babel-plugin-transform-runtime-7.22.9.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.24.7.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.24.7.tgz -> npmpkg-@babel-plugin-transform-spread-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.24.7.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.24.7.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.24.7.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.24.7.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.24.7.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.22.9.tgz -> npmpkg-@babel-preset-env-7.22.9.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6.tgz -> npmpkg-@babel-preset-modules-0.1.6.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.22.6.tgz -> npmpkg-@babel-runtime-7.22.6.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.5.tgz -> npmpkg-@babel-template-7.22.5.tgz
https://registry.npmjs.org/@babel/template/-/template-7.24.7.tgz -> npmpkg-@babel-template-7.24.7.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.24.7.tgz -> npmpkg-@babel-traverse-7.24.7.tgz
https://registry.npmjs.org/@babel/types/-/types-7.24.7.tgz -> npmpkg-@babel-types-7.24.7.tgz
https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz -> npmpkg-@colors-colors-1.5.0.tgz
https://registry.npmjs.org/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> npmpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.18.17.tgz -> npmpkg-@esbuild-android-arm-0.18.17.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.18.17.tgz -> npmpkg-@esbuild-android-arm64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.18.17.tgz -> npmpkg-@esbuild-android-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.18.17.tgz -> npmpkg-@esbuild-darwin-arm64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.18.17.tgz -> npmpkg-@esbuild-darwin-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.17.tgz -> npmpkg-@esbuild-freebsd-arm64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.18.17.tgz -> npmpkg-@esbuild-freebsd-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.18.17.tgz -> npmpkg-@esbuild-linux-arm-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.18.17.tgz -> npmpkg-@esbuild-linux-arm64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.18.17.tgz -> npmpkg-@esbuild-linux-ia32-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.18.17.tgz -> npmpkg-@esbuild-linux-loong64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.18.17.tgz -> npmpkg-@esbuild-linux-mips64el-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.18.17.tgz -> npmpkg-@esbuild-linux-ppc64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.18.17.tgz -> npmpkg-@esbuild-linux-riscv64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.18.17.tgz -> npmpkg-@esbuild-linux-s390x-0.18.17.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.18.17.tgz -> npmpkg-@esbuild-linux-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.17.tgz -> npmpkg-@esbuild-netbsd-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.17.tgz -> npmpkg-@esbuild-openbsd-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.17.tgz -> npmpkg-@esbuild-sunos-x64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.17.tgz -> npmpkg-@esbuild-win32-arm64-0.18.17.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.17.tgz -> npmpkg-@esbuild-win32-ia32-0.18.17.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.17.tgz -> npmpkg-@esbuild-win32-x64-0.18.17.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> npmpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.10.1.tgz -> npmpkg-@eslint-community-regexpp-4.10.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> npmpkg-@eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.57.0.tgz -> npmpkg-@eslint-js-8.57.0.tgz
https://registry.npmjs.org/@foliojs-fork/fontkit/-/fontkit-1.9.2.tgz -> npmpkg-@foliojs-fork-fontkit-1.9.2.tgz
https://registry.npmjs.org/@foliojs-fork/linebreak/-/linebreak-1.1.2.tgz -> npmpkg-@foliojs-fork-linebreak-1.1.2.tgz
https://registry.npmjs.org/@foliojs-fork/pdfkit/-/pdfkit-0.14.0.tgz -> npmpkg-@foliojs-fork-pdfkit-0.14.0.tgz
https://registry.npmjs.org/@foliojs-fork/restructure/-/restructure-2.0.2.tgz -> npmpkg-@foliojs-fork-restructure-2.0.2.tgz
https://registry.npmjs.org/@fortawesome/angular-fontawesome/-/angular-fontawesome-0.13.0.tgz -> npmpkg-@fortawesome-angular-fontawesome-0.13.0.tgz
https://registry.npmjs.org/@fortawesome/fontawesome-common-types/-/fontawesome-common-types-0.1.7.tgz -> npmpkg-@fortawesome-fontawesome-common-types-0.1.7.tgz
https://registry.npmjs.org/@fortawesome/fontawesome-common-types/-/fontawesome-common-types-6.5.2.tgz -> npmpkg-@fortawesome-fontawesome-common-types-6.5.2.tgz
https://registry.npmjs.org/@fortawesome/fontawesome-free-brands/-/fontawesome-free-brands-5.0.13.tgz -> npmpkg-@fortawesome-fontawesome-free-brands-5.0.13.tgz
https://registry.npmjs.org/@fortawesome/fontawesome-free-regular/-/fontawesome-free-regular-5.0.13.tgz -> npmpkg-@fortawesome-fontawesome-free-regular-5.0.13.tgz
https://registry.npmjs.org/@fortawesome/fontawesome-svg-core/-/fontawesome-svg-core-6.5.2.tgz -> npmpkg-@fortawesome-fontawesome-svg-core-6.5.2.tgz
https://registry.npmjs.org/@fortawesome/fontawesome/-/fontawesome-1.1.8.tgz -> npmpkg-@fortawesome-fontawesome-1.1.8.tgz
https://registry.npmjs.org/@fortawesome/free-brands-svg-icons/-/free-brands-svg-icons-6.5.2.tgz -> npmpkg-@fortawesome-free-brands-svg-icons-6.5.2.tgz
https://registry.npmjs.org/@fortawesome/free-regular-svg-icons/-/free-regular-svg-icons-6.5.2.tgz -> npmpkg-@fortawesome-free-regular-svg-icons-6.5.2.tgz
https://registry.npmjs.org/@fortawesome/free-solid-svg-icons/-/free-solid-svg-icons-6.5.2.tgz -> npmpkg-@fortawesome-free-solid-svg-icons-6.5.2.tgz
https://registry.npmjs.org/@gar/promisify/-/promisify-1.1.3.tgz -> npmpkg-@gar-promisify-1.1.3.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.11.14.tgz -> npmpkg-@humanwhocodes-config-array-0.11.14.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> npmpkg-@humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz -> npmpkg-@humanwhocodes-object-schema-2.0.3.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.6.tgz -> npmpkg-@jridgewell-source-map-0.3.6.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@leichtgewicht/ip-codec/-/ip-codec-2.0.5.tgz -> npmpkg-@leichtgewicht-ip-codec-2.0.5.tgz
https://registry.npmjs.org/@mapbox/node-pre-gyp/-/node-pre-gyp-1.0.11.tgz -> npmpkg-@mapbox-node-pre-gyp-1.0.11.tgz
https://registry.npmjs.org/@ng-bootstrap/ng-bootstrap/-/ng-bootstrap-15.1.2.tgz -> npmpkg-@ng-bootstrap-ng-bootstrap-15.1.2.tgz
https://registry.npmjs.org/@ng-idle/core/-/core-13.0.1.tgz -> npmpkg-@ng-idle-core-13.0.1.tgz
https://registry.npmjs.org/@ng-idle/keepalive/-/keepalive-13.0.1.tgz -> npmpkg-@ng-idle-keepalive-13.0.1.tgz
https://registry.npmjs.org/@ngrx/store/-/store-16.3.0.tgz -> npmpkg-@ngrx-store-16.3.0.tgz
https://registry.npmjs.org/@ngtools/webpack/-/webpack-16.2.14.tgz -> npmpkg-@ngtools-webpack-16.2.14.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-2.1.2.tgz -> npmpkg-@npmcli-fs-2.1.2.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-3.1.1.tgz -> npmpkg-@npmcli-fs-3.1.1.tgz
https://registry.npmjs.org/@npmcli/git/-/git-4.1.0.tgz -> npmpkg-@npmcli-git-4.1.0.tgz
https://registry.npmjs.org/@npmcli/installed-package-contents/-/installed-package-contents-2.1.0.tgz -> npmpkg-@npmcli-installed-package-contents-2.1.0.tgz
https://registry.npmjs.org/@npmcli/move-file/-/move-file-2.0.1.tgz -> npmpkg-@npmcli-move-file-2.0.1.tgz
https://registry.npmjs.org/@npmcli/node-gyp/-/node-gyp-3.0.0.tgz -> npmpkg-@npmcli-node-gyp-3.0.0.tgz
https://registry.npmjs.org/@npmcli/promise-spawn/-/promise-spawn-6.0.2.tgz -> npmpkg-@npmcli-promise-spawn-6.0.2.tgz
https://registry.npmjs.org/@npmcli/run-script/-/run-script-6.0.2.tgz -> npmpkg-@npmcli-run-script-6.0.2.tgz
https://registry.npmjs.org/@nrwl/devkit/-/devkit-16.2.2.tgz -> npmpkg-@nrwl-devkit-16.2.2.tgz
https://registry.npmjs.org/@nrwl/tao/-/tao-16.2.2.tgz -> npmpkg-@nrwl-tao-16.2.2.tgz
https://registry.npmjs.org/@nx/devkit/-/devkit-16.2.2.tgz -> npmpkg-@nx-devkit-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-darwin-arm64/-/nx-darwin-arm64-16.2.2.tgz -> npmpkg-@nx-nx-darwin-arm64-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-darwin-x64/-/nx-darwin-x64-16.2.2.tgz -> npmpkg-@nx-nx-darwin-x64-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-linux-arm-gnueabihf/-/nx-linux-arm-gnueabihf-16.2.2.tgz -> npmpkg-@nx-nx-linux-arm-gnueabihf-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-linux-arm64-gnu/-/nx-linux-arm64-gnu-16.2.2.tgz -> npmpkg-@nx-nx-linux-arm64-gnu-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-linux-arm64-musl/-/nx-linux-arm64-musl-16.2.2.tgz -> npmpkg-@nx-nx-linux-arm64-musl-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-linux-x64-gnu/-/nx-linux-x64-gnu-16.2.2.tgz -> npmpkg-@nx-nx-linux-x64-gnu-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-linux-x64-musl/-/nx-linux-x64-musl-16.2.2.tgz -> npmpkg-@nx-nx-linux-x64-musl-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-win32-arm64-msvc/-/nx-win32-arm64-msvc-16.2.2.tgz -> npmpkg-@nx-nx-win32-arm64-msvc-16.2.2.tgz
https://registry.npmjs.org/@nx/nx-win32-x64-msvc/-/nx-win32-x64-msvc-16.2.2.tgz -> npmpkg-@nx-nx-win32-x64-msvc-16.2.2.tgz
https://registry.npmjs.org/@parcel/watcher/-/watcher-2.0.4.tgz -> npmpkg-@parcel-watcher-2.0.4.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@popperjs/core/-/core-2.11.8.tgz -> npmpkg-@popperjs-core-2.11.8.tgz
https://registry.npmjs.org/@puppeteer/browsers/-/browsers-1.4.6.tgz -> npmpkg-@puppeteer-browsers-1.4.6.tgz
https://registry.npmjs.org/@scarf/scarf/-/scarf-1.3.0.tgz -> npmpkg-@scarf-scarf-1.3.0.tgz
https://registry.npmjs.org/@schematics/angular/-/angular-16.2.14.tgz -> npmpkg-@schematics-angular-16.2.14.tgz
https://registry.npmjs.org/@selectize/selectize/-/selectize-0.15.2.tgz -> npmpkg-@selectize-selectize-0.15.2.tgz
https://registry.npmjs.org/@sigstore/bundle/-/bundle-1.1.0.tgz -> npmpkg-@sigstore-bundle-1.1.0.tgz
https://registry.npmjs.org/@sigstore/protobuf-specs/-/protobuf-specs-0.2.1.tgz -> npmpkg-@sigstore-protobuf-specs-0.2.1.tgz
https://registry.npmjs.org/@sigstore/sign/-/sign-1.0.0.tgz -> npmpkg-@sigstore-sign-1.0.0.tgz
https://registry.npmjs.org/@sigstore/tuf/-/tuf-1.0.3.tgz -> npmpkg-@sigstore-tuf-1.0.3.tgz
https://registry.npmjs.org/@socket.io/component-emitter/-/component-emitter-3.1.2.tgz -> npmpkg-@socket.io-component-emitter-3.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-1.1.2.tgz -> npmpkg-@tootallnate-once-1.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@tootallnate/quickjs-emscripten/-/quickjs-emscripten-0.23.0.tgz -> npmpkg-@tootallnate-quickjs-emscripten-0.23.0.tgz
https://registry.npmjs.org/@tufjs/canonical-json/-/canonical-json-1.0.0.tgz -> npmpkg-@tufjs-canonical-json-1.0.0.tgz
https://registry.npmjs.org/@tufjs/models/-/models-1.0.4.tgz -> npmpkg-@tufjs-models-1.0.4.tgz
https://registry.npmjs.org/@types/body-parser/-/body-parser-1.19.5.tgz -> npmpkg-@types-body-parser-1.19.5.tgz
https://registry.npmjs.org/@types/bonjour/-/bonjour-3.5.13.tgz -> npmpkg-@types-bonjour-3.5.13.tgz
https://registry.npmjs.org/@types/connect-history-api-fallback/-/connect-history-api-fallback-1.5.4.tgz -> npmpkg-@types-connect-history-api-fallback-1.5.4.tgz
https://registry.npmjs.org/@types/connect/-/connect-3.4.38.tgz -> npmpkg-@types-connect-3.4.38.tgz
https://registry.npmjs.org/@types/cookie/-/cookie-0.4.1.tgz -> npmpkg-@types-cookie-0.4.1.tgz
https://registry.npmjs.org/@types/cors/-/cors-2.8.17.tgz -> npmpkg-@types-cors-2.8.17.tgz
https://registry.npmjs.org/@types/datatables.net-select/-/datatables.net-select-1.4.0.tgz -> npmpkg-@types-datatables.net-select-1.4.0.tgz
https://registry.npmjs.org/@types/datatables.net/-/datatables.net-1.12.0.tgz -> npmpkg-@types-datatables.net-1.12.0.tgz
https://registry.npmjs.org/@types/echarts/-/echarts-4.9.22.tgz -> npmpkg-@types-echarts-4.9.22.tgz
https://registry.npmjs.org/@types/eslint-scope/-/eslint-scope-3.7.7.tgz -> npmpkg-@types-eslint-scope-3.7.7.tgz
https://registry.npmjs.org/@types/eslint/-/eslint-8.56.10.tgz -> npmpkg-@types-eslint-8.56.10.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz -> npmpkg-@types-estree-1.0.5.tgz
https://registry.npmjs.org/@types/express-serve-static-core/-/express-serve-static-core-4.19.5.tgz -> npmpkg-@types-express-serve-static-core-4.19.5.tgz
https://registry.npmjs.org/@types/express/-/express-4.17.21.tgz -> npmpkg-@types-express-4.17.21.tgz
https://registry.npmjs.org/@types/http-errors/-/http-errors-2.0.4.tgz -> npmpkg-@types-http-errors-2.0.4.tgz
https://registry.npmjs.org/@types/http-proxy/-/http-proxy-1.17.14.tgz -> npmpkg-@types-http-proxy-1.17.14.tgz
https://registry.npmjs.org/@types/jasmine/-/jasmine-4.3.6.tgz -> npmpkg-@types-jasmine-4.3.6.tgz
https://registry.npmjs.org/@types/jquery/-/jquery-3.5.30.tgz -> npmpkg-@types-jquery-3.5.30.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/mime/-/mime-1.3.5.tgz -> npmpkg-@types-mime-1.3.5.tgz
https://registry.npmjs.org/@types/node-forge/-/node-forge-1.3.11.tgz -> npmpkg-@types-node-forge-1.3.11.tgz
https://registry.npmjs.org/@types/node/-/node-20.14.7.tgz -> npmpkg-@types-node-20.14.7.tgz
https://registry.npmjs.org/@types/qs/-/qs-6.9.15.tgz -> npmpkg-@types-qs-6.9.15.tgz
https://registry.npmjs.org/@types/raf/-/raf-3.4.3.tgz -> npmpkg-@types-raf-3.4.3.tgz
https://registry.npmjs.org/@types/range-parser/-/range-parser-1.2.7.tgz -> npmpkg-@types-range-parser-1.2.7.tgz
https://registry.npmjs.org/@types/retry/-/retry-0.12.0.tgz -> npmpkg-@types-retry-0.12.0.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.8.tgz -> npmpkg-@types-semver-7.5.8.tgz
https://registry.npmjs.org/@types/send/-/send-0.17.4.tgz -> npmpkg-@types-send-0.17.4.tgz
https://registry.npmjs.org/@types/serve-index/-/serve-index-1.9.4.tgz -> npmpkg-@types-serve-index-1.9.4.tgz
https://registry.npmjs.org/@types/serve-static/-/serve-static-1.15.7.tgz -> npmpkg-@types-serve-static-1.15.7.tgz
https://registry.npmjs.org/@types/sizzle/-/sizzle-2.3.8.tgz -> npmpkg-@types-sizzle-2.3.8.tgz
https://registry.npmjs.org/@types/sockjs/-/sockjs-0.3.36.tgz -> npmpkg-@types-sockjs-0.3.36.tgz
https://registry.npmjs.org/@types/ws/-/ws-8.5.10.tgz -> npmpkg-@types-ws-8.5.10.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.3.tgz -> npmpkg-@types-yauzl-2.10.3.tgz
https://registry.npmjs.org/@types/zrender/-/zrender-4.0.6.tgz -> npmpkg-@types-zrender-4.0.6.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.59.7.tgz -> npmpkg-@typescript-eslint-eslint-plugin-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-5.59.7.tgz -> npmpkg-@typescript-eslint-parser-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-5.59.7.tgz -> npmpkg-@typescript-eslint-scope-manager-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-5.59.7.tgz -> npmpkg-@typescript-eslint-type-utils-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-5.59.7.tgz -> npmpkg-@typescript-eslint-types-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-5.59.7.tgz -> npmpkg-@typescript-eslint-typescript-estree-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-5.59.7.tgz -> npmpkg-@typescript-eslint-utils-5.59.7.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-5.59.7.tgz -> npmpkg-@typescript-eslint-visitor-keys-5.59.7.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> npmpkg-@ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/@vitejs/plugin-basic-ssl/-/plugin-basic-ssl-1.0.1.tgz -> npmpkg-@vitejs-plugin-basic-ssl-1.0.1.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.12.1.tgz -> npmpkg-@webassemblyjs-ast-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.12.1.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.12.1.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> npmpkg-@webassemblyjs-ieee754-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> npmpkg-@webassemblyjs-leb128-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> npmpkg-@webassemblyjs-utf8-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.12.1.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.12.1.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.12.1.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.12.1.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.12.1.tgz -> npmpkg-@webassemblyjs-wast-printer-1.12.1.tgz
https://registry.npmjs.org/@wessberg/ts-evaluator/-/ts-evaluator-0.0.27.tgz -> npmpkg-@wessberg-ts-evaluator-0.0.27.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/@yarnpkg/parsers/-/parsers-3.0.2.tgz -> npmpkg-@yarnpkg-parsers-3.0.2.tgz
https://registry.npmjs.org/@zkochan/js-yaml/-/js-yaml-0.0.6.tgz -> npmpkg-@zkochan-js-yaml-0.0.6.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz -> npmpkg-accepts-1.3.8.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-6.0.0.tgz -> npmpkg-acorn-globals-6.0.0.tgz
https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.9.0.tgz -> npmpkg-acorn-import-assertions-1.9.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.2.0.tgz -> npmpkg-acorn-walk-7.2.0.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.0.tgz -> npmpkg-acorn-8.12.0.tgz
https://registry.npmjs.org/adjust-sourcemap-loader/-/adjust-sourcemap-loader-4.0.0.tgz -> npmpkg-adjust-sourcemap-loader-4.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/agentkeepalive/-/agentkeepalive-4.5.0.tgz -> npmpkg-agentkeepalive-4.5.0.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv-formats/-/ajv-formats-2.1.1.tgz -> npmpkg-ajv-formats-2.1.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> npmpkg-ajv-keywords-5.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/angular-datatables/-/angular-datatables-16.0.1.tgz -> npmpkg-angular-datatables-16.0.1.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.3.tgz -> npmpkg-ansi-colors-4.1.3.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-html-community/-/ansi-html-community-0.0.8.tgz -> npmpkg-ansi-html-community-0.0.8.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz -> npmpkg-ansi-regex-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/aproba/-/aproba-2.0.0.tgz -> npmpkg-aproba-2.0.0.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-3.0.1.tgz -> npmpkg-are-we-there-yet-3.0.1.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/aria-query/-/aria-query-5.1.3.tgz -> npmpkg-aria-query-5.1.3.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz -> npmpkg-array-flatten-1.1.1.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.4.tgz -> npmpkg-ast-types-0.13.4.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.1.tgz -> npmpkg-async-limiter-1.0.1.tgz
https://registry.npmjs.org/async/-/async-3.2.5.tgz -> npmpkg-async-3.2.5.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.14.tgz -> npmpkg-autoprefixer-10.4.14.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/axios/-/axios-1.7.2.tgz -> npmpkg-axios-1.7.2.tgz
https://registry.npmjs.org/axobject-query/-/axobject-query-3.1.1.tgz -> npmpkg-axobject-query-3.1.1.tgz
https://registry.npmjs.org/b4a/-/b4a-1.6.6.tgz -> npmpkg-b4a-1.6.6.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-9.1.3.tgz -> npmpkg-babel-loader-9.1.3.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> npmpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.11.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.11.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.7.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.7.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.5.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.5.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/bare-events/-/bare-events-2.4.2.tgz -> npmpkg-bare-events-2.4.2.tgz
https://registry.npmjs.org/base64-arraybuffer/-/base64-arraybuffer-1.0.2.tgz -> npmpkg-base64-arraybuffer-1.0.2.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.3.1.tgz -> npmpkg-base64-js-1.3.1.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/base64id/-/base64id-2.0.0.tgz -> npmpkg-base64id-2.0.0.tgz
https://registry.npmjs.org/basic-ftp/-/basic-ftp-5.0.5.tgz -> npmpkg-basic-ftp-5.0.5.tgz
https://registry.npmjs.org/batch/-/batch-0.6.1.tgz -> npmpkg-batch-0.6.1.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz -> npmpkg-big.js-5.2.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/body-parser/-/body-parser-1.20.2.tgz -> npmpkg-body-parser-1.20.2.tgz
https://registry.npmjs.org/bonjour-service/-/bonjour-service-1.2.1.tgz -> npmpkg-bonjour-service-1.2.1.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/bootstrap-darkmode/-/bootstrap-darkmode-5.0.1.tgz -> npmpkg-bootstrap-darkmode-5.0.1.tgz
https://registry.npmjs.org/bootstrap/-/bootstrap-5.3.3.tgz -> npmpkg-bootstrap-5.3.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/brotli/-/brotli-1.3.3.tgz -> npmpkg-brotli-1.3.3.tgz
https://registry.npmjs.org/browser-or-node/-/browser-or-node-1.3.0.tgz -> npmpkg-browser-or-node-1.3.0.tgz
https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> npmpkg-browser-process-hrtime-1.0.0.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.23.1.tgz -> npmpkg-browserslist-4.23.1.tgz
https://registry.npmjs.org/btoa/-/btoa-1.2.1.tgz -> npmpkg-btoa-1.2.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/bytes/-/bytes-3.0.0.tgz -> npmpkg-bytes-3.0.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/cacache/-/cacache-16.1.3.tgz -> npmpkg-cacache-16.1.3.tgz
https://registry.npmjs.org/cacache/-/cacache-17.1.4.tgz -> npmpkg-cacache-17.1.4.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001636.tgz -> npmpkg-caniuse-lite-1.0.30001636.tgz
https://registry.npmjs.org/canvas/-/canvas-2.11.2.tgz -> npmpkg-canvas-2.11.2.tgz
https://registry.npmjs.org/canvg/-/canvg-3.0.10.tgz -> npmpkg-canvg-3.0.10.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.4.tgz -> npmpkg-chrome-trace-event-1.0.4.tgz
https://registry.npmjs.org/chromium-bidi/-/chromium-bidi-0.4.16.tgz -> npmpkg-chromium-bidi-0.4.16.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.6.1.tgz -> npmpkg-cli-spinners-2.6.1.tgz
https://registry.npmjs.org/cli-width/-/cli-width-3.0.0.tgz -> npmpkg-cli-width-3.0.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz -> npmpkg-clone-deep-4.0.1.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz -> npmpkg-color-support-1.1.3.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz -> npmpkg-colorette-2.0.20.tgz
https://registry.npmjs.org/combine-errors/-/combine-errors-3.0.3.tgz -> npmpkg-combine-errors-3.0.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/common-path-prefix/-/common-path-prefix-3.0.0.tgz -> npmpkg-common-path-prefix-3.0.0.tgz
https://registry.npmjs.org/compressible/-/compressible-2.0.18.tgz -> npmpkg-compressible-2.0.18.tgz
https://registry.npmjs.org/compression/-/compression-1.7.4.tgz -> npmpkg-compression-1.7.4.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/connect-history-api-fallback/-/connect-history-api-fallback-2.0.0.tgz -> npmpkg-connect-history-api-fallback-2.0.0.tgz
https://registry.npmjs.org/connect/-/connect-3.7.0.tgz -> npmpkg-connect-3.7.0.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz -> npmpkg-content-disposition-0.5.4.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz -> npmpkg-content-type-1.0.5.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz -> npmpkg-cookie-signature-1.0.6.tgz
https://registry.npmjs.org/cookie/-/cookie-0.4.2.tgz -> npmpkg-cookie-0.4.2.tgz
https://registry.npmjs.org/cookie/-/cookie-0.6.0.tgz -> npmpkg-cookie-0.6.0.tgz
https://registry.npmjs.org/copy-anything/-/copy-anything-2.0.6.tgz -> npmpkg-copy-anything-2.0.6.tgz
https://registry.npmjs.org/copy-webpack-plugin/-/copy-webpack-plugin-11.0.0.tgz -> npmpkg-copy-webpack-plugin-11.0.0.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.37.1.tgz -> npmpkg-core-js-compat-3.37.1.tgz
https://registry.npmjs.org/core-js/-/core-js-3.37.1.tgz -> npmpkg-core-js-3.37.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/cors/-/cors-2.8.5.tgz -> npmpkg-cors-2.8.5.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.2.0.tgz -> npmpkg-cosmiconfig-8.2.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-8.3.6.tgz -> npmpkg-cosmiconfig-8.3.6.tgz
https://registry.npmjs.org/critters/-/critters-0.0.20.tgz -> npmpkg-critters-0.0.20.tgz
https://registry.npmjs.org/cross-fetch/-/cross-fetch-4.0.0.tgz -> npmpkg-cross-fetch-4.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-js/-/crypto-js-4.2.0.tgz -> npmpkg-crypto-js-4.2.0.tgz
https://registry.npmjs.org/css-line-break/-/css-line-break-2.1.0.tgz -> npmpkg-css-line-break-2.1.0.tgz
https://registry.npmjs.org/css-loader/-/css-loader-6.8.1.tgz -> npmpkg-css-loader-6.8.1.tgz
https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz -> npmpkg-css-select-5.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/cssom/-/cssom-0.4.4.tgz -> npmpkg-cssom-0.4.4.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/custom-error-instance/-/custom-error-instance-2.1.1.tgz -> npmpkg-custom-error-instance-2.1.1.tgz
https://registry.npmjs.org/custom-event/-/custom-event-1.0.1.tgz -> npmpkg-custom-event-1.0.1.tgz
https://registry.npmjs.org/data-uri-to-buffer/-/data-uri-to-buffer-6.0.2.tgz -> npmpkg-data-uri-to-buffer-6.0.2.tgz
https://registry.npmjs.org/data-urls/-/data-urls-2.0.0.tgz -> npmpkg-data-urls-2.0.0.tgz
https://registry.npmjs.org/datatables.net-bs5/-/datatables.net-bs5-1.13.11.tgz -> npmpkg-datatables.net-bs5-1.13.11.tgz
https://registry.npmjs.org/datatables.net-buttons-dt/-/datatables.net-buttons-dt-2.4.3.tgz -> npmpkg-datatables.net-buttons-dt-2.4.3.tgz
https://registry.npmjs.org/datatables.net-buttons/-/datatables.net-buttons-2.4.3.tgz -> npmpkg-datatables.net-buttons-2.4.3.tgz
https://registry.npmjs.org/datatables.net-dt/-/datatables.net-dt-1.13.11.tgz -> npmpkg-datatables.net-dt-1.13.11.tgz
https://registry.npmjs.org/datatables.net-responsive-dt/-/datatables.net-responsive-dt-2.5.1.tgz -> npmpkg-datatables.net-responsive-dt-2.5.1.tgz
https://registry.npmjs.org/datatables.net-responsive/-/datatables.net-responsive-2.5.1.tgz -> npmpkg-datatables.net-responsive-2.5.1.tgz
https://registry.npmjs.org/datatables.net-select-dt/-/datatables.net-select-dt-1.7.1.tgz -> npmpkg-datatables.net-select-dt-1.7.1.tgz
https://registry.npmjs.org/datatables.net-select/-/datatables.net-select-1.7.1.tgz -> npmpkg-datatables.net-select-1.7.1.tgz
https://registry.npmjs.org/datatables.net/-/datatables.net-1.13.11.tgz -> npmpkg-datatables.net-1.13.11.tgz
https://registry.npmjs.org/date-format/-/date-format-4.0.14.tgz -> npmpkg-date-format-4.0.14.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.5.tgz -> npmpkg-debug-4.3.5.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-4.2.1.tgz -> npmpkg-decompress-response-4.2.1.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-1.1.2.tgz -> npmpkg-deep-equal-1.1.2.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-2.2.3.tgz -> npmpkg-deep-equal-2.2.3.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/default-gateway/-/default-gateway-6.0.3.tgz -> npmpkg-default-gateway-6.0.3.tgz
https://registry.npmjs.org/defaults/-/defaults-1.0.4.tgz -> npmpkg-defaults-1.0.4.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> npmpkg-define-lazy-prop-2.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/degenerator/-/degenerator-5.0.1.tgz -> npmpkg-degenerator-5.0.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz -> npmpkg-destroy-1.2.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.0.3.tgz -> npmpkg-detect-libc-2.0.3.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/devtools-protocol/-/devtools-protocol-0.0.1147663.tgz -> npmpkg-devtools-protocol-0.0.1147663.tgz
https://registry.npmjs.org/dfa/-/dfa-1.2.0.tgz -> npmpkg-dfa-1.2.0.tgz
https://registry.npmjs.org/di/-/di-0.0.1.tgz -> npmpkg-di-0.0.1.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/dns-packet/-/dns-packet-5.6.1.tgz -> npmpkg-dns-packet-5.6.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-serialize/-/dom-serialize-2.2.1.tgz -> npmpkg-dom-serialize-2.2.1.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz -> npmpkg-dom-serializer-2.0.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domexception/-/domexception-2.0.1.tgz -> npmpkg-domexception-2.0.1.tgz
https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz -> npmpkg-domhandler-5.0.3.tgz
https://registry.npmjs.org/dompurify/-/dompurify-2.5.5.tgz -> npmpkg-dompurify-2.5.5.tgz
https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz -> npmpkg-domutils-3.1.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-10.0.0.tgz -> npmpkg-dotenv-10.0.0.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.2.tgz -> npmpkg-duplexer-0.1.2.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/echarts/-/echarts-5.5.0.tgz -> npmpkg-echarts-5.5.0.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.4.808.tgz -> npmpkg-electron-to-chromium-1.4.808.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz -> npmpkg-emojis-list-3.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz -> npmpkg-encoding-0.1.13.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/engine.io-parser/-/engine.io-parser-5.2.2.tgz -> npmpkg-engine.io-parser-5.2.2.tgz
https://registry.npmjs.org/engine.io/-/engine.io-6.5.5.tgz -> npmpkg-engine.io-6.5.5.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.17.0.tgz -> npmpkg-enhanced-resolve-5.17.0.tgz
https://registry.npmjs.org/enquirer/-/enquirer-2.3.6.tgz -> npmpkg-enquirer-2.3.6.tgz
https://registry.npmjs.org/ent/-/ent-2.2.1.tgz -> npmpkg-ent-2.2.1.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz -> npmpkg-entities-4.5.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/errno/-/errno-0.1.8.tgz -> npmpkg-errno-0.1.8.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-get-iterator/-/es-get-iterator-1.1.3.tgz -> npmpkg-es-get-iterator-1.1.3.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.5.3.tgz -> npmpkg-es-module-lexer-1.5.3.tgz
https://registry.npmjs.org/esbuild-wasm/-/esbuild-wasm-0.18.17.tgz -> npmpkg-esbuild-wasm-0.18.17.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.18.17.tgz -> npmpkg-esbuild-0.18.17.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.2.tgz -> npmpkg-escalade-3.1.2.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/eslint/-/eslint-8.57.0.tgz -> npmpkg-eslint-8.57.0.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz -> npmpkg-espree-9.6.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/eventemitter-asyncresource/-/eventemitter-asyncresource-1.0.0.tgz -> npmpkg-eventemitter-asyncresource-1.0.0.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/exponential-backoff/-/exponential-backoff-3.1.1.tgz -> npmpkg-exponential-backoff-3.1.1.tgz
https://registry.npmjs.org/express/-/express-4.19.2.tgz -> npmpkg-express-4.19.2.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-fifo/-/fast-fifo-1.3.2.tgz -> npmpkg-fast-fifo-1.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.2.7.tgz -> npmpkg-fast-glob-3.2.7.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.0.tgz -> npmpkg-fast-glob-3.3.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.1.tgz -> npmpkg-fast-glob-3.3.1.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.4.tgz -> npmpkg-faye-websocket-0.11.4.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.4.8.tgz -> npmpkg-fflate-0.4.8.tgz
https://registry.npmjs.org/figures/-/figures-3.2.0.tgz -> npmpkg-figures-3.2.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.1.2.tgz -> npmpkg-finalhandler-1.1.2.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.2.0.tgz -> npmpkg-finalhandler-1.2.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-4.0.0.tgz -> npmpkg-find-cache-dir-4.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-6.3.0.tgz -> npmpkg-find-up-6.3.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz -> npmpkg-flat-cache-3.2.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/flatted/-/flatted-3.3.1.tgz -> npmpkg-flatted-3.3.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.6.tgz -> npmpkg-follow-redirects-1.15.6.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.2.1.tgz -> npmpkg-foreground-child-3.2.1.tgz
https://registry.npmjs.org/form-data/-/form-data-3.0.1.tgz -> npmpkg-form-data-3.0.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/forwarded/-/forwarded-0.2.0.tgz -> npmpkg-forwarded-0.2.0.tgz
https://registry.npmjs.org/fraction.js/-/fraction.js-4.3.7.tgz -> npmpkg-fraction.js-4.3.7.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-3.0.3.tgz -> npmpkg-fs-minipass-3.0.3.tgz
https://registry.npmjs.org/fs-monkey/-/fs-monkey-1.0.6.tgz -> npmpkg-fs-monkey-1.0.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/gauge/-/gauge-4.0.4.tgz -> npmpkg-gauge-4.0.4.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/get-uri/-/get-uri-6.0.3.tgz -> npmpkg-get-uri-6.0.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz -> npmpkg-glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.2.tgz -> npmpkg-glob-10.4.2.tgz
https://registry.npmjs.org/glob/-/glob-7.1.4.tgz -> npmpkg-glob-7.1.4.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz -> npmpkg-glob-8.1.0.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/globby/-/globby-13.2.2.tgz -> npmpkg-globby-13.2.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/grapheme-splitter/-/grapheme-splitter-1.0.4.tgz -> npmpkg-grapheme-splitter-1.0.4.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz -> npmpkg-graphemer-1.4.0.tgz
https://registry.npmjs.org/guess-parser/-/guess-parser-0.4.22.tgz -> npmpkg-guess-parser-0.4.22.tgz
https://registry.npmjs.org/handle-thing/-/handle-thing-2.0.1.tgz -> npmpkg-handle-thing-2.0.1.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/hashtype-detector/-/hashtype-detector-0.0.6.tgz -> npmpkg-hashtype-detector-0.0.6.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hdr-histogram-js/-/hdr-histogram-js-2.0.3.tgz -> npmpkg-hdr-histogram-js-2.0.3.tgz
https://registry.npmjs.org/hdr-histogram-percentiles-obj/-/hdr-histogram-percentiles-obj-3.0.0.tgz -> npmpkg-hdr-histogram-percentiles-obj-3.0.0.tgz
https://registry.npmjs.org/hex2dec/-/hex2dec-1.1.2.tgz -> npmpkg-hex2dec-1.1.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-6.1.1.tgz -> npmpkg-hosted-git-info-6.1.1.tgz
https://registry.npmjs.org/hpack.js/-/hpack.js-2.1.6.tgz -> npmpkg-hpack.js-2.1.6.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz -> npmpkg-html-encoding-sniffer-2.0.1.tgz
https://registry.npmjs.org/html-entities/-/html-entities-2.5.2.tgz -> npmpkg-html-entities-2.5.2.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/html2canvas/-/html2canvas-1.4.1.tgz -> npmpkg-html2canvas-1.4.1.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-8.0.2.tgz -> npmpkg-htmlparser2-8.0.2.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-deceiver/-/http-deceiver-1.2.7.tgz -> npmpkg-http-deceiver-1.2.7.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.3.tgz -> npmpkg-http-errors-1.6.3.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz -> npmpkg-http-errors-2.0.0.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.5.8.tgz -> npmpkg-http-parser-js-0.5.8.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> npmpkg-http-proxy-agent-4.0.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> npmpkg-http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/http-proxy-middleware/-/http-proxy-middleware-2.0.6.tgz -> npmpkg-http-proxy-middleware-2.0.6.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.4.tgz -> npmpkg-https-proxy-agent-7.0.4.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/humanize-ms/-/humanize-ms-1.2.1.tgz -> npmpkg-humanize-ms-1.2.1.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-5.1.0.tgz -> npmpkg-icss-utils-5.1.0.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore-by-default/-/ignore-by-default-1.0.1.tgz -> npmpkg-ignore-by-default-1.0.1.tgz
https://registry.npmjs.org/ignore-walk/-/ignore-walk-6.0.5.tgz -> npmpkg-ignore-walk-6.0.5.tgz
https://registry.npmjs.org/ignore/-/ignore-5.2.4.tgz -> npmpkg-ignore-5.2.4.tgz
https://registry.npmjs.org/image-size/-/image-size-0.5.5.tgz -> npmpkg-image-size-0.5.5.tgz
https://registry.npmjs.org/immediate/-/immediate-3.0.6.tgz -> npmpkg-immediate-3.0.6.tgz
https://registry.npmjs.org/immutable/-/immutable-4.3.6.tgz -> npmpkg-immutable-4.3.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-4.1.1.tgz -> npmpkg-ini-4.1.1.tgz
https://registry.npmjs.org/inquirer/-/inquirer-8.2.4.tgz -> npmpkg-inquirer-8.2.4.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/ip-address/-/ip-address-9.0.5.tgz -> npmpkg-ip-address-9.0.5.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> npmpkg-ipaddr.js-1.9.1.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-2.2.0.tgz -> npmpkg-ipaddr.js-2.2.0.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.14.0.tgz -> npmpkg-is-core-module-2.14.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-1.0.0.tgz -> npmpkg-is-interactive-1.0.0.tgz
https://registry.npmjs.org/is-lambda/-/is-lambda-1.0.1.tgz -> npmpkg-is-lambda-1.0.1.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz -> npmpkg-is-map-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-3.0.0.tgz -> npmpkg-is-plain-obj-3.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz -> npmpkg-is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz -> npmpkg-is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.3.tgz -> npmpkg-is-weakset-2.0.3.tgz
https://registry.npmjs.org/is-what/-/is-what-3.14.1.tgz -> npmpkg-is-what-3.14.1.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isomorphic-ws/-/isomorphic-ws-4.0.1.tgz -> npmpkg-isomorphic-ws-4.0.1.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> npmpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> npmpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.7.tgz -> npmpkg-istanbul-reports-3.1.7.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.0.tgz -> npmpkg-jackspeak-3.4.0.tgz
https://registry.npmjs.org/jake/-/jake-10.9.1.tgz -> npmpkg-jake-10.9.1.tgz
https://registry.npmjs.org/jasmine-core/-/jasmine-core-4.6.1.tgz -> npmpkg-jasmine-core-4.6.1.tgz
https://registry.npmjs.org/jasmine-core/-/jasmine-core-5.0.1.tgz -> npmpkg-jasmine-core-5.0.1.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz -> npmpkg-jest-worker-27.5.1.tgz
https://registry.npmjs.org/jiti/-/jiti-1.21.6.tgz -> npmpkg-jiti-1.21.6.tgz
https://registry.npmjs.org/jquery-ui/-/jquery-ui-1.13.3.tgz -> npmpkg-jquery-ui-1.13.3.tgz
https://registry.npmjs.org/jquery/-/jquery-3.7.1.tgz -> npmpkg-jquery-3.7.1.tgz
https://registry.npmjs.org/js-base64/-/js-base64-3.7.7.tgz -> npmpkg-js-base64-3.7.7.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsbn/-/jsbn-1.1.0.tgz -> npmpkg-jsbn-1.1.0.tgz
https://registry.npmjs.org/jsdom/-/jsdom-16.7.0.tgz -> npmpkg-jsdom-16.7.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.2.tgz -> npmpkg-json-parse-even-better-errors-3.0.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.2.0.tgz -> npmpkg-jsonc-parser-3.2.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/jsonparse/-/jsonparse-1.3.1.tgz -> npmpkg-jsonparse-1.3.1.tgz
https://registry.npmjs.org/jspdf/-/jspdf-2.5.1.tgz -> npmpkg-jspdf-2.5.1.tgz
https://registry.npmjs.org/jszip/-/jszip-3.10.1.tgz -> npmpkg-jszip-3.10.1.tgz
https://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-3.2.0.tgz -> npmpkg-karma-chrome-launcher-3.2.0.tgz
https://registry.npmjs.org/karma-coverage/-/karma-coverage-2.2.1.tgz -> npmpkg-karma-coverage-2.2.1.tgz
https://registry.npmjs.org/karma-jasmine-html-reporter/-/karma-jasmine-html-reporter-2.1.0.tgz -> npmpkg-karma-jasmine-html-reporter-2.1.0.tgz
https://registry.npmjs.org/karma-jasmine/-/karma-jasmine-5.1.0.tgz -> npmpkg-karma-jasmine-5.1.0.tgz
https://registry.npmjs.org/karma-source-map-support/-/karma-source-map-support-1.4.0.tgz -> npmpkg-karma-source-map-support-1.4.0.tgz
https://registry.npmjs.org/karma/-/karma-6.4.3.tgz -> npmpkg-karma-6.4.3.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/klona/-/klona-2.0.6.tgz -> npmpkg-klona-2.0.6.tgz
https://registry.npmjs.org/launch-editor/-/launch-editor-2.8.0.tgz -> npmpkg-launch-editor-2.8.0.tgz
https://registry.npmjs.org/less-loader/-/less-loader-11.1.0.tgz -> npmpkg-less-loader-11.1.0.tgz
https://registry.npmjs.org/less/-/less-4.1.3.tgz -> npmpkg-less-4.1.3.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/license-webpack-plugin/-/license-webpack-plugin-4.0.2.tgz -> npmpkg-license-webpack-plugin-4.0.2.tgz
https://registry.npmjs.org/lie/-/lie-3.3.0.tgz -> npmpkg-lie-3.3.0.tgz
https://registry.npmjs.org/lightstep-tracer/-/lightstep-tracer-0.35.0-no-protobuf.tgz -> npmpkg-lightstep-tracer-0.35.0-no-protobuf.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-2.0.4.tgz -> npmpkg-lines-and-columns-2.0.4.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-3.2.1.tgz -> npmpkg-loader-utils-3.2.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-7.2.0.tgz -> npmpkg-locate-path-7.2.0.tgz
https://registry.npmjs.org/lodash._baseiteratee/-/lodash._baseiteratee-4.7.0.tgz -> npmpkg-lodash._baseiteratee-4.7.0.tgz
https://registry.npmjs.org/lodash._basetostring/-/lodash._basetostring-4.12.0.tgz -> npmpkg-lodash._basetostring-4.12.0.tgz
https://registry.npmjs.org/lodash._baseuniq/-/lodash._baseuniq-4.6.0.tgz -> npmpkg-lodash._baseuniq-4.6.0.tgz
https://registry.npmjs.org/lodash._createset/-/lodash._createset-4.0.3.tgz -> npmpkg-lodash._createset-4.0.3.tgz
https://registry.npmjs.org/lodash._root/-/lodash._root-3.0.1.tgz -> npmpkg-lodash._root-3.0.1.tgz
https://registry.npmjs.org/lodash._stringtopath/-/lodash._stringtopath-4.8.0.tgz -> npmpkg-lodash._stringtopath-4.8.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> npmpkg-lodash.throttle-4.1.1.tgz
https://registry.npmjs.org/lodash.uniqby/-/lodash.uniqby-4.5.0.tgz -> npmpkg-lodash.uniqby-4.5.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/log4js/-/log4js-6.9.1.tgz -> npmpkg-log4js-6.9.1.tgz
https://registry.npmjs.org/lottie-web/-/lottie-web-5.12.2.tgz -> npmpkg-lottie-web-5.12.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.2.2.tgz -> npmpkg-lru-cache-10.2.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz -> npmpkg-lru-cache-7.18.3.tgz
https://registry.npmjs.org/magic-string/-/magic-string-0.30.1.tgz -> npmpkg-magic-string-0.30.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> npmpkg-make-fetch-happen-10.2.1.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-11.1.1.tgz -> npmpkg-make-fetch-happen-11.1.1.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz -> npmpkg-media-typer-0.3.0.tgz
https://registry.npmjs.org/memfs/-/memfs-3.5.3.tgz -> npmpkg-memfs-3.5.3.tgz
https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz -> npmpkg-merge-descriptors-1.0.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/methods/-/methods-1.1.2.tgz -> npmpkg-methods-1.1.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.7.tgz -> npmpkg-micromatch-4.0.7.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-2.1.0.tgz -> npmpkg-mimic-response-2.1.0.tgz
https://registry.npmjs.org/mini-css-extract-plugin/-/mini-css-extract-plugin-2.7.6.tgz -> npmpkg-mini-css-extract-plugin-2.7.6.tgz
https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> npmpkg-minimalistic-assert-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-minimatch-3.0.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.4.tgz -> npmpkg-minimatch-9.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass-collect/-/minipass-collect-1.0.2.tgz -> npmpkg-minipass-collect-1.0.2.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> npmpkg-minipass-fetch-2.1.2.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-3.0.5.tgz -> npmpkg-minipass-fetch-3.0.5.tgz
https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz -> npmpkg-minipass-flush-1.0.5.tgz
https://registry.npmjs.org/minipass-json-stream/-/minipass-json-stream-1.0.1.tgz -> npmpkg-minipass-json-stream-1.0.1.tgz
https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> npmpkg-minipass-pipeline-1.2.4.tgz
https://registry.npmjs.org/minipass-sized/-/minipass-sized-1.0.3.tgz -> npmpkg-minipass-sized-1.0.3.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/mitt/-/mitt-3.0.0.tgz -> npmpkg-mitt-3.0.0.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/moment/-/moment-2.30.1.tgz -> npmpkg-moment-2.30.1.tgz
https://registry.npmjs.org/mrmime/-/mrmime-1.0.1.tgz -> npmpkg-mrmime-1.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/multicast-dns/-/multicast-dns-7.2.5.tgz -> npmpkg-multicast-dns-7.2.5.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.8.tgz -> npmpkg-mute-stream-0.0.8.tgz
https://registry.npmjs.org/nan/-/nan-2.20.0.tgz -> npmpkg-nan-2.20.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz -> npmpkg-natural-compare-lite-1.4.0.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/needle/-/needle-3.3.1.tgz -> npmpkg-needle-3.3.1.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz -> npmpkg-negotiator-0.6.3.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/netmask/-/netmask-2.0.2.tgz -> npmpkg-netmask-2.0.2.tgz
https://registry.npmjs.org/ngx-color-picker/-/ngx-color-picker-14.0.0.tgz -> npmpkg-ngx-color-picker-14.0.0.tgz
https://registry.npmjs.org/ngx-lottie/-/ngx-lottie-10.0.0.tgz -> npmpkg-ngx-lottie-10.0.0.tgz
https://registry.npmjs.org/ngx-moment/-/ngx-moment-6.0.2.tgz -> npmpkg-ngx-moment-6.0.2.tgz
https://registry.npmjs.org/nice-napi/-/nice-napi-1.0.2.tgz -> npmpkg-nice-napi-1.0.2.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-3.2.1.tgz -> npmpkg-node-addon-api-3.2.1.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz -> npmpkg-node-fetch-2.7.0.tgz
https://registry.npmjs.org/node-forge/-/node-forge-1.3.1.tgz -> npmpkg-node-forge-1.3.1.tgz
https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.8.1.tgz -> npmpkg-node-gyp-build-4.8.1.tgz
https://registry.npmjs.org/node-gyp/-/node-gyp-9.4.1.tgz -> npmpkg-node-gyp-9.4.1.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.14.tgz -> npmpkg-node-releases-2.0.14.tgz
https://registry.npmjs.org/nodemon/-/nodemon-3.1.4.tgz -> npmpkg-nodemon-3.1.4.tgz
https://registry.npmjs.org/nopt/-/nopt-5.0.0.tgz -> npmpkg-nopt-5.0.0.tgz
https://registry.npmjs.org/nopt/-/nopt-6.0.0.tgz -> npmpkg-nopt-6.0.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-5.0.0.tgz -> npmpkg-normalize-package-data-5.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz -> npmpkg-normalize-range-0.1.2.tgz
https://registry.npmjs.org/npm-bundled/-/npm-bundled-3.0.1.tgz -> npmpkg-npm-bundled-3.0.1.tgz
https://registry.npmjs.org/npm-install-checks/-/npm-install-checks-6.3.0.tgz -> npmpkg-npm-install-checks-6.3.0.tgz
https://registry.npmjs.org/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.1.tgz -> npmpkg-npm-normalize-package-bin-3.0.1.tgz
https://registry.npmjs.org/npm-package-arg/-/npm-package-arg-10.1.0.tgz -> npmpkg-npm-package-arg-10.1.0.tgz
https://registry.npmjs.org/npm-packlist/-/npm-packlist-7.0.4.tgz -> npmpkg-npm-packlist-7.0.4.tgz
https://registry.npmjs.org/npm-pick-manifest/-/npm-pick-manifest-8.0.1.tgz -> npmpkg-npm-pick-manifest-8.0.1.tgz
https://registry.npmjs.org/npm-registry-fetch/-/npm-registry-fetch-14.0.5.tgz -> npmpkg-npm-registry-fetch-14.0.5.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/npmlog/-/npmlog-6.0.2.tgz -> npmpkg-npmlog-6.0.2.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.10.tgz -> npmpkg-nwsapi-2.2.10.tgz
https://registry.npmjs.org/nx/-/nx-16.2.2.tgz -> npmpkg-nx-16.2.2.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.6.tgz -> npmpkg-object-is-1.1.6.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-path/-/object-path-0.11.8.tgz -> npmpkg-object-path-0.11.8.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/obuf/-/obuf-1.1.2.tgz -> npmpkg-obuf-1.1.2.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz -> npmpkg-on-finished-2.3.0.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz -> npmpkg-on-finished-2.4.1.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.0.2.tgz -> npmpkg-on-headers-1.0.2.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/opentracing/-/opentracing-0.14.7.tgz -> npmpkg-opentracing-0.14.7.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz -> npmpkg-optionator-0.9.4.tgz
https://registry.npmjs.org/ora/-/ora-5.4.1.tgz -> npmpkg-ora-5.4.1.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-4.0.0.tgz -> npmpkg-p-limit-4.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-6.0.0.tgz -> npmpkg-p-locate-6.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/p-retry/-/p-retry-4.6.2.tgz -> npmpkg-p-retry-4.6.2.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pac-proxy-agent/-/pac-proxy-agent-7.0.1.tgz -> npmpkg-pac-proxy-agent-7.0.1.tgz
https://registry.npmjs.org/pac-resolver/-/pac-resolver-7.0.1.tgz -> npmpkg-pac-resolver-7.0.1.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.0.tgz -> npmpkg-package-json-from-dist-1.0.0.tgz
https://registry.npmjs.org/pacote/-/pacote-15.2.0.tgz -> npmpkg-pacote-15.2.0.tgz
https://registry.npmjs.org/pako/-/pako-0.2.9.tgz -> npmpkg-pako-0.2.9.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse-node-version/-/parse-node-version-1.0.1.tgz -> npmpkg-parse-node-version-1.0.1.tgz
https://registry.npmjs.org/parse5-html-rewriting-stream/-/parse5-html-rewriting-stream-7.0.0.tgz -> npmpkg-parse5-html-rewriting-stream-7.0.0.tgz
https://registry.npmjs.org/parse5-sax-parser/-/parse5-sax-parser-7.0.0.tgz -> npmpkg-parse5-sax-parser-7.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz -> npmpkg-parse5-7.1.2.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> npmpkg-path-to-regexp-0.1.7.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pdfmake/-/pdfmake-0.2.10.tgz -> npmpkg-pdfmake-0.2.10.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.1.tgz -> npmpkg-picocolors-1.0.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/piscina/-/piscina-4.0.0.tgz -> npmpkg-piscina-4.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-7.0.0.tgz -> npmpkg-pkg-dir-7.0.0.tgz
https://registry.npmjs.org/png-js/-/png-js-1.0.0.tgz -> npmpkg-png-js-1.0.0.tgz
https://registry.npmjs.org/popper.js/-/popper.js-1.16.1.tgz -> npmpkg-popper.js-1.16.1.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss-loader/-/postcss-loader-7.3.3.tgz -> npmpkg-postcss-loader-7.3.3.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.1.0.tgz -> npmpkg-postcss-modules-extract-imports-3.1.0.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.5.tgz -> npmpkg-postcss-modules-local-by-default-4.0.5.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-3.2.0.tgz -> npmpkg-postcss-modules-scope-3.2.0.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> npmpkg-postcss-modules-values-4.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.0.tgz -> npmpkg-postcss-selector-parser-6.1.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> npmpkg-pretty-bytes-5.6.0.tgz
https://registry.npmjs.org/proc-log/-/proc-log-3.0.0.tgz -> npmpkg-proc-log-3.0.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/proper-lockfile/-/proper-lockfile-4.1.2.tgz -> npmpkg-proper-lockfile-4.1.2.tgz
https://registry.npmjs.org/proxy-addr/-/proxy-addr-2.0.7.tgz -> npmpkg-proxy-addr-2.0.7.tgz
https://registry.npmjs.org/proxy-agent/-/proxy-agent-6.3.0.tgz -> npmpkg-proxy-agent-6.3.0.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz -> npmpkg-prr-1.0.1.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/pstree.remy/-/pstree.remy-1.1.8.tgz -> npmpkg-pstree.remy-1.1.8.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/puppeteer-core/-/puppeteer-core-20.9.0.tgz -> npmpkg-puppeteer-core-20.9.0.tgz
https://registry.npmjs.org/puppeteer/-/puppeteer-20.9.0.tgz -> npmpkg-puppeteer-20.9.0.tgz
https://registry.npmjs.org/q/-/q-1.5.1.tgz -> npmpkg-q-1.5.1.tgz
https://registry.npmjs.org/qjobs/-/qjobs-1.2.0.tgz -> npmpkg-qjobs-1.2.0.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/queue-tick/-/queue-tick-1.0.1.tgz -> npmpkg-queue-tick-1.0.1.tgz
https://registry.npmjs.org/raf/-/raf-3.4.1.tgz -> npmpkg-raf-3.4.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.1.tgz -> npmpkg-range-parser-1.2.1.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.2.tgz -> npmpkg-raw-body-2.5.2.tgz
https://registry.npmjs.org/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz -> npmpkg-read-package-json-fast-3.0.2.tgz
https://registry.npmjs.org/read-package-json/-/read-package-json-6.0.4.tgz -> npmpkg-read-package-json-6.0.4.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/reflect-metadata/-/reflect-metadata-0.1.14.tgz -> npmpkg-reflect-metadata-0.1.14.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz -> npmpkg-regenerator-runtime-0.13.11.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regex-parser/-/regex-parser-2.3.0.tgz -> npmpkg-regex-parser-2.3.0.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz -> npmpkg-regexp.prototype.flags-1.5.2.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-url-loader/-/resolve-url-loader-5.0.0.tgz -> npmpkg-resolve-url-loader-5.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/retry/-/retry-0.13.1.tgz -> npmpkg-retry-0.13.1.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rfdc/-/rfdc-1.4.1.tgz -> npmpkg-rfdc-1.4.1.tgz
https://registry.npmjs.org/rgbcolor/-/rgbcolor-1.0.1.tgz -> npmpkg-rgbcolor-1.0.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/rollup/-/rollup-3.29.4.tgz -> npmpkg-rollup-3.29.4.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/rxjs/-/rxjs-7.8.1.tgz -> npmpkg-rxjs-7.8.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sass-loader/-/sass-loader-13.3.2.tgz -> npmpkg-sass-loader-13.3.2.tgz
https://registry.npmjs.org/sass/-/sass-1.64.1.tgz -> npmpkg-sass-1.64.1.tgz
https://registry.npmjs.org/sax/-/sax-1.4.1.tgz -> npmpkg-sax-1.4.1.tgz
https://registry.npmjs.org/saxes/-/saxes-5.0.1.tgz -> npmpkg-saxes-5.0.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-4.2.0.tgz -> npmpkg-schema-utils-4.2.0.tgz
https://registry.npmjs.org/select-hose/-/select-hose-2.0.0.tgz -> npmpkg-select-hose-2.0.0.tgz
https://registry.npmjs.org/selfsigned/-/selfsigned-2.4.1.tgz -> npmpkg-selfsigned-2.4.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver/-/semver-7.3.4.tgz -> npmpkg-semver-7.3.4.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/send/-/send-0.18.0.tgz -> npmpkg-send-0.18.0.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/serve-index/-/serve-index-1.9.1.tgz -> npmpkg-serve-index-1.9.1.tgz
https://registry.npmjs.org/serve-static/-/serve-static-1.15.0.tgz -> npmpkg-serve-static-1.15.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.1.0.tgz -> npmpkg-setprototypeof-1.1.0.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz -> npmpkg-shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.1.tgz -> npmpkg-shell-quote-1.8.1.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/sigstore/-/sigstore-1.9.0.tgz -> npmpkg-sigstore-1.9.0.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-3.1.1.tgz -> npmpkg-simple-get-3.1.1.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/slash/-/slash-4.0.0.tgz -> npmpkg-slash-4.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/socket.io-adapter/-/socket.io-adapter-2.5.5.tgz -> npmpkg-socket.io-adapter-2.5.5.tgz
https://registry.npmjs.org/socket.io-parser/-/socket.io-parser-4.2.4.tgz -> npmpkg-socket.io-parser-4.2.4.tgz
https://registry.npmjs.org/socket.io/-/socket.io-4.7.5.tgz -> npmpkg-socket.io-4.7.5.tgz
https://registry.npmjs.org/sockjs/-/sockjs-0.3.24.tgz -> npmpkg-sockjs-0.3.24.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> npmpkg-socks-proxy-agent-7.0.0.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-8.0.3.tgz -> npmpkg-socks-proxy-agent-8.0.3.tgz
https://registry.npmjs.org/socks/-/socks-2.8.3.tgz -> npmpkg-socks-2.8.3.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.0.tgz -> npmpkg-source-map-js-1.2.0.tgz
https://registry.npmjs.org/source-map-loader/-/source-map-loader-4.0.1.tgz -> npmpkg-source-map-loader-4.0.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.7.4.tgz -> npmpkg-source-map-0.7.4.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.18.tgz -> npmpkg-spdx-license-ids-3.0.18.tgz
https://registry.npmjs.org/spdy-transport/-/spdy-transport-3.0.0.tgz -> npmpkg-spdy-transport-3.0.0.tgz
https://registry.npmjs.org/spdy/-/spdy-4.0.2.tgz -> npmpkg-spdy-4.0.2.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/ssri/-/ssri-10.0.6.tgz -> npmpkg-ssri-10.0.6.tgz
https://registry.npmjs.org/ssri/-/ssri-9.0.1.tgz -> npmpkg-ssri-9.0.1.tgz
https://registry.npmjs.org/stackblur-canvas/-/stackblur-canvas-2.7.0.tgz -> npmpkg-stackblur-canvas-2.7.0.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.0.0.tgz -> npmpkg-stop-iteration-iterator-1.0.0.tgz
https://registry.npmjs.org/streamroller/-/streamroller-3.1.5.tgz -> npmpkg-streamroller-3.1.5.tgz
https://registry.npmjs.org/streamx/-/streamx-2.18.0.tgz -> npmpkg-streamx-2.18.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/strong-log-transformer/-/strong-log-transformer-2.1.0.tgz -> npmpkg-strong-log-transformer-2.1.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/svg-pathdata/-/svg-pathdata-6.0.3.tgz -> npmpkg-svg-pathdata-6.0.3.tgz
https://registry.npmjs.org/sweetalert2/-/sweetalert2-11.12.0.tgz -> npmpkg-sweetalert2-11.12.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-4.0.0.tgz -> npmpkg-symbol-observable-4.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-3.0.4.tgz -> npmpkg-tar-fs-3.0.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-3.1.7.tgz -> npmpkg-tar-stream-3.1.7.tgz
https://registry.npmjs.org/tar/-/tar-6.2.1.tgz -> npmpkg-tar-6.2.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz -> npmpkg-terser-webpack-plugin-5.3.10.tgz
https://registry.npmjs.org/terser/-/terser-5.19.2.tgz -> npmpkg-terser-5.19.2.tgz
https://registry.npmjs.org/terser/-/terser-5.31.1.tgz -> npmpkg-terser-5.31.1.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/text-decoder/-/text-decoder-1.1.0.tgz -> npmpkg-text-decoder-1.1.0.tgz
https://registry.npmjs.org/text-segmentation/-/text-segmentation-1.0.3.tgz -> npmpkg-text-segmentation-1.0.3.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/thrift/-/thrift-0.17.0.tgz -> npmpkg-thrift-0.17.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/thunky/-/thunky-1.1.0.tgz -> npmpkg-thunky-1.1.0.tgz
https://registry.npmjs.org/tiny-inflate/-/tiny-inflate-1.0.3.tgz -> npmpkg-tiny-inflate-1.0.3.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/touch/-/touch-3.1.1.tgz -> npmpkg-touch-3.1.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.4.tgz -> npmpkg-tough-cookie-4.1.4.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz -> npmpkg-tr46-2.1.0.tgz
https://registry.npmjs.org/tree-kill/-/tree-kill-1.2.2.tgz -> npmpkg-tree-kill-1.2.2.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-4.2.0.tgz -> npmpkg-tsconfig-paths-4.2.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.3.0.tgz -> npmpkg-tslib-2.3.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.1.tgz -> npmpkg-tslib-2.6.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.6.3.tgz -> npmpkg-tslib-2.6.3.tgz
https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz -> npmpkg-tsutils-3.21.0.tgz
https://registry.npmjs.org/tuf-js/-/tuf-js-1.1.7.tgz -> npmpkg-tuf-js-1.1.7.tgz
https://registry.npmjs.org/tus-js-client/-/tus-js-client-3.1.3.tgz -> npmpkg-tus-js-client-3.1.3.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz -> npmpkg-type-is-1.6.18.tgz
https://registry.npmjs.org/typed-assert/-/typed-assert-1.0.9.tgz -> npmpkg-typed-assert-1.0.9.tgz
https://registry.npmjs.org/typescript/-/typescript-5.1.6.tgz -> npmpkg-typescript-5.1.6.tgz
https://registry.npmjs.org/ua-parser-js/-/ua-parser-js-0.7.38.tgz -> npmpkg-ua-parser-js-0.7.38.tgz
https://registry.npmjs.org/unbzip2-stream/-/unbzip2-stream-1.4.3.tgz -> npmpkg-unbzip2-stream-1.4.3.tgz
https://registry.npmjs.org/undefsafe/-/undefsafe-2.0.5.tgz -> npmpkg-undefsafe-2.0.5.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-properties/-/unicode-properties-1.4.1.tgz -> npmpkg-unicode-properties-1.4.1.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-trie/-/unicode-trie-2.0.0.tgz -> npmpkg-unicode-trie-2.0.0.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-2.0.1.tgz -> npmpkg-unique-filename-2.0.1.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-3.0.0.tgz -> npmpkg-unique-filename-3.0.0.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-3.0.0.tgz -> npmpkg-unique-slug-3.0.0.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-4.0.0.tgz -> npmpkg-unique-slug-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.0.16.tgz -> npmpkg-update-browserslist-db-1.0.16.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz -> npmpkg-utils-merge-1.0.1.tgz
https://registry.npmjs.org/utrie/-/utrie-1.0.2.tgz -> npmpkg-utrie-1.0.2.tgz
https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz -> npmpkg-uuid-8.3.2.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz -> npmpkg-v8-compile-cache-2.3.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/validate-npm-package-name/-/validate-npm-package-name-5.0.1.tgz -> npmpkg-validate-npm-package-name-5.0.1.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/vite/-/vite-4.5.3.tgz -> npmpkg-vite-4.5.3.tgz
https://registry.npmjs.org/void-elements/-/void-elements-2.0.1.tgz -> npmpkg-void-elements-2.0.1.tgz
https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> npmpkg-w3c-hr-time-1.0.2.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz -> npmpkg-w3c-xmlserializer-2.0.0.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.1.tgz -> npmpkg-watchpack-2.4.1.tgz
https://registry.npmjs.org/wbuf/-/wbuf-1.7.3.tgz -> npmpkg-wbuf-1.7.3.tgz
https://registry.npmjs.org/wcwidth/-/wcwidth-1.0.1.tgz -> npmpkg-wcwidth-1.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-5.0.0.tgz -> npmpkg-webidl-conversions-5.0.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-6.1.0.tgz -> npmpkg-webidl-conversions-6.1.0.tgz
https://registry.npmjs.org/webpack-dev-middleware/-/webpack-dev-middleware-5.3.4.tgz -> npmpkg-webpack-dev-middleware-5.3.4.tgz
https://registry.npmjs.org/webpack-dev-middleware/-/webpack-dev-middleware-6.1.2.tgz -> npmpkg-webpack-dev-middleware-6.1.2.tgz
https://registry.npmjs.org/webpack-dev-server/-/webpack-dev-server-4.15.1.tgz -> npmpkg-webpack-dev-server-4.15.1.tgz
https://registry.npmjs.org/webpack-merge/-/webpack-merge-5.9.0.tgz -> npmpkg-webpack-merge-5.9.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/webpack-subresource-integrity/-/webpack-subresource-integrity-5.1.0.tgz -> npmpkg-webpack-subresource-integrity-5.1.0.tgz
https://registry.npmjs.org/webpack/-/webpack-5.88.2.tgz -> npmpkg-webpack-5.88.2.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.4.tgz -> npmpkg-websocket-driver-0.7.4.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> npmpkg-websocket-extensions-0.1.4.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> npmpkg-whatwg-encoding-1.0.5.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> npmpkg-whatwg-mimetype-2.3.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.7.0.tgz -> npmpkg-whatwg-url-8.7.0.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz -> npmpkg-which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which/-/which-3.0.1.tgz -> npmpkg-which-3.0.1.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz -> npmpkg-wide-align-1.1.5.tgz
https://registry.npmjs.org/wildcard/-/wildcard-2.0.1.tgz -> npmpkg-wildcard-2.0.1.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-5.2.4.tgz -> npmpkg-ws-5.2.4.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/ws/-/ws-8.13.0.tgz -> npmpkg-ws-8.13.0.tgz
https://registry.npmjs.org/ws/-/ws-8.17.1.tgz -> npmpkg-ws-8.17.1.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> npmpkg-xml-name-validator-3.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xmldoc/-/xmldoc-1.3.0.tgz -> npmpkg-xmldoc-1.3.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.1.tgz -> npmpkg-yargs-17.7.1.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.0.0.tgz -> npmpkg-yocto-queue-1.0.0.tgz
https://registry.npmjs.org/zone.js/-/zone.js-0.13.3.tgz -> npmpkg-zone.js-0.13.3.tgz
https://registry.npmjs.org/zrender/-/zrender-5.5.0.tgz -> npmpkg-zrender-5.5.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/server-9999"
	S_WEBUI="${WORKDIR}/web-ui-9999"
else
	KEYWORDS="~amd64" # Unfinished
	SRC_URI="
https://github.com/hashtopolis/server/archive/v${PV}.tar.gz -> hashtopolis-server-${PV}.tar.gz
		angular? (
			${NPM_EXTERNAL_URIS}
https://github.com/hashtopolis/web-ui/archive/refs/tags/v${HASTOPOLIS_WEBUI_PV}.tar.gz
	-> hashtopolis-webui-${HASTOPOLIS_WEBUI_PV}.tar.gz
		)
	"
	S="${WORKDIR}/server-${PV}"
	S_WEBUI="${WORKDIR}/web-ui-${HASTOPOLIS_WEBUI_PV}"
fi

DESCRIPTION="Hashtopolis is a Hashcat wrapper for distributed password recovery"
HOMEPAGE="https://github.com/hashtopolis/server"
WEB_UI_NODE_MODULES_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		CC-BY-4.0
		MIT
		OFL-1.1
	)
	(
		CC-BY-4.0
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		Apache-2.0
		BSD
		custom
		public-domain
	)
	(
		custom
		MIT
	)
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	CC-BY-4.0
	CC-BY-3.0
	custom
	ISC
	MIT
	PSF-2.2
	Unlicense
	|| (
		Apache-2.0
		MIT
	)
	|| (
		Apache-2.0
		MPL-2.0
	)
	|| (
		BSD
		GPL-2
	)
	|| (
		GPL-3
		MIT
	)
"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		GPL-2+
	)
	CC-BY-4.0
	BSD
	MIT
	OFL-1.1
	angular? (
		${WEB_UI_NODE_MODULES_LICENSES}
		(
			CC-BY-4.0
			MIT
		)
		0BSD
		Apache-2.0
		BSD
		CC0-1.0
		CC-BY-4.0
		GPL-3
		MIT
		OFL-1.1
	)
"
# The PSF-2.2 is similar to PSF-2.4 but shorter list
# static/7zr.bin - All Rights Reserved, GPL-2+
# web-ui-0.14.2/node_modules/@angular/localize/node_modules/convert-source-map/LICENSE - all-rights-reserved MIT
# web-ui-0.14.2/node_modules/atob/LICENSE || ( Apache-2.0 MIT )
# web-ui-0.14.2/node_modules/atob/LICENSE.DOCS - CC-BY-3.0
# web-ui-0.14.2/node_modules/caniuse-lite/LICENSE - CC-BY-4.0
# web-ui-0.14.2/node_modules/dompurify/LICENSE || ( Apache-2.0 MPL-2.0 )
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome-common-types/LICENSE.txt - custom
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome-free-regular/LICENSE.txt - CC-BY-4.0 MIT OFL-1.1
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome/LICENSE.txt - custom
# web-ui-0.14.2/node_modules/fs-monkey/LICENSE - Unlicense
# web-ui-0.14.2/node_modules/hashtype-detector/LICENSE - GPL-3
# web-ui-0.14.2/node_modules/jackspeak/LICENSE.md - custom "Blue Oak Model License" 1.0.0
# web-ui-0.14.2/node_modules/jsbn/LICENSE - custom ( MIT + retain copyright notice )
# web-ui-0.14.2/node_modules/jszip/lib/license_header.js - || ( GPL-3 MIT )
# web-ui-0.14.2/node_modules/jszip/LICENSE.markdown - || ( GPL-3 MIT )
# web-ui-0.14.2/node_modules/node-forge/LICENSE - || ( BSD GPL-2 )
# web-ui-0.14.2/node_modules/reflect-metadata/CopyrightNotice.txt - Apache-2.0 all-rights-reserved
# web-ui-0.14.2/node_modules/thrift/LICENSE - custom Apache-2.0 BSD public-domain
# web-ui-0.14.2/node_modules/typescript/ThirdPartyNoticeText.txt - CC-BY-4.0 MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement W3C-Software-and-Document-Notice-and-License
LICENSE="
	${THIRD_PARTY_LICENSES}
	GPL-3
"
SLOT="0"
IUSE+=" agent angular ssl"
# USE=angular is broken
REQUIRED_USE="
	!angular
"
RESTRICT="test"
# apache optional: apache2_modules_env, apache2_modules_log_config
RDEPEND="
	>=dev-lang/php-8.3.3:8.3[apache2,curl,filter,gd,mysql,pdo,session,simplexml,ssl,xmlwriter]
	>=dev-php/composer-2.7.1
	>=dev-vcs/git-2.43.0
	>=net-misc/curl-7.88.1
	>=www-servers/apache-2.4.57:2[apache2_modules_env,apache2_modules_log_config,ssl?]
	dev-php/pear
	virtual/mysql
"
DEPEND="
	${RDEPEND}
	>=app-arch/unzip-6.0
"
BDEPEND="
	angular? (
		>=net-libs/nodejs-18.15:18
	)
"
PDEPEND="
	agent? (
		>=app-crypt/hashtopolis-python-agent-0.7.1
	)
"
PATCHES=(
)

check_network_sandbox() {
	# For composer/npm
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

check_php_support_in_apache() {
	if has_version "www-servers/apache" ; then
		if ! grep -q -e "APACHE2_OPTS.*-D PHP" /etc/conf.d/apache2 ; then
ewarn "Apache is not configured for PHP.  Add \"-D PHP\" to APACHE2_OPTS in /etc/conf.d/apache2"
		fi
	fi
}

pkg_setup() {
	check_network_sandbox
	check_php_support_in_apache
	webapp_pkg_setup
	if use angular ; then
ewarn "The angular USE flag is currently broken."
		npm_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/server-9999"
		EGIT_REPO_URI="https://github.com/hashtopolis/server.git"
		use fallback-commit && EGIT_COMMIT="375f2ce022c4b3e0780abf9dcca1e6af8e966c1a"
		git-r3_fetch
		git-r3_checkout

		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/web-ui-9999"
		EGIT_REPO_URI="https://github.com/hashtopolis/web-ui.git"
		use fallback-commit && EGIT_COMMIT="4c9b30888fd1b1e48c469afc4884d0e427e22122"
		git-r3_fetch
		git-r3_checkout
	else
		unpack "hashtopolis-server-${PV}.tar.gz"
		use angular && unpack "hashtopolis-webui-${HASTOPOLIS_WEBUI_PV}.tar.gz"
	fi

	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		:
	else
		cd "${S}" || die
		composer install \
			--working-dir="${S}" \
			|| die
	fi

	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		use angular || die "Enable the angular USE flag before updating lockfile"
	fi

	if use angular ; then
		npm_hydrate
		cd "${S_WEBUI}" || die
		if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
			mkdir -p "${WORKDIR}/lockfile-image" || die
			local lockfile
			local lockfiles=(
				"package-lock.json"
			)
# Reduce version constraints caused by lockfiles.
			rm -vf ${lockfiles[@]}

einfo "Running \`npm install ${NPM_INSTALL_ARGS[@]}\` per package-lock.json"
			for lockfile in ${lockfiles[@]} ; do
				local d="$(dirname ${lockfile})"
				pushd "${S_WEBUI}/${d}" || die
					if [[ "${NPM_AUDIT_FIX}" == "1" ]] ; then
						enpm install \
							${NPM_INSTALL_ARGS[@]}
					fi
				popd
			done

einfo "Running \`npm audit fix ${NPM_AUDIT_FIX_ARGS[@]}\` per package-lock.json"
			if [[ "${NPM_AUDIT_FIX}" == "1" ]] ; then
				for lockfile in ${lockfiles[@]} ; do
					local d="$(dirname ${lockfile})"
					pushd "${S_WEBUI}/${d}" || die
						enpm audit fix \
							${NPM_AUDIT_FIX_ARGS[@]}
					popd
				done
			fi

einfo "Copying lockfiles"
			lockfiles_disabled=(
	# Disabled to prevent too many args for wget in relation to SRC_URI.
				$(find . -name "package-lock.json")
			)
			for lockfile in ${lockfiles[@]} ; do
				local d="$(dirname ${lockfile})"
				local dest="${WORKDIR}/lockfile-image/${d}"
				mkdir -p "${dest}"
einfo "${d}/package.json -> ${dest}"
				cp -a "${d}/package.json" "${dest}"
einfo "${d}/package-lock.json -> ${dest}"
				cp -a "${d}/package-lock.json" "${dest}"
			done

einfo "Lockfile update done"
			exit 0
		else
			_npm_cp_tarballs
			if [[ -e "${FILESDIR}/${PV}" ]] ; then
				cp -aT "${FILESDIR}/${PV}" "${S_WEBUI}" || die
			fi
			npm_hydrate
			local offline=${NPM_OFFLINE:-2}
			if [[ "${offline}" == "1" ]] ; then
				enpm install \
					--offline \
					${NPM_INSTALL_ARGS[@]}
			elif [[ "${offline}" == "1" ]] ; then
				enpm install \
					--prefer-offline \
					${NPM_INSTALL_ARGS[@]}
			else
				enpm install \
					${NPM_INSTALL_ARGS[@]}
			fi
			# Audit fix already done in NPM_UPDATE_LOCK=1
		fi
	fi
}

set_vhost_angular_config_with_ssl() {
#  MY_HTDOCSDIR:  /usr/share/webapps//hashtopolis/0.14.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}
Listen ${HASHTOPOLIS_FRONTEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

<VirtualHost *:${HASHTOPOLIS_FRONTEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-frontend"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-frontend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angular_config_without_ssl() {
#  MY_HTDOCSDIR:  /usr/share/webapps//hashtopolis/0.14.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}
Listen ${HASHTOPOLIS_FRONTEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

<VirtualHost *:${HASHTOPOLIS_FRONTEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-frontend"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-frontend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angularless_config_with_ssl() {
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf"
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angularless_config_without_ssl() {
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf"
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}


set_server_config() {
	local HASHTOPOLIS_ADDRESS=${HASHTOPOLIS_ADDRESS:-"localhost"}
	local HASHTOPOLIS_BACKEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-8080}
	local HASHTOPOLIS_FRONTEND_PORT=${HASHTOPOLIS_FRONTEND_PORT:-4200}

	if use vhosts ; then
		_VHOST_ROOT="/var/www/${HASHTOPOLIS_ADDRESS}"
	else
		_VHOST_ROOT="${VHOST_ROOT}"
	fi
	MY_HTDOCSDIR_VHOST="${_VHOST_ROOT}/htdocs/hashtopolis"
	MY_HTDOCSDIR_VHOST_BACKEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
	MY_HTDOCSDIR_VHOST_FRONTEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
einfo "MY_HTDOCSDIR_VHOST_BACKEND:  ${MY_HTDOCSDIR_VHOST_BACKEND}"
einfo "MY_HTDOCSDIR_VHOST_FRONTEND:  ${MY_HTDOCSDIR_VHOST_FRONTEND}"

	if use angular ; then
		cd "${S_WEBUI}" || die
		sed -i \
			-e 's/localhost:8080/${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/g' \
			src/config/default/app/main.ts \
			|| die

		if use ssl ; then
			set_vhost_angular_config_with_ssl
		else
			set_vhost_angular_config_without_ssl
		fi

		if use ssl ; then
			export HASHTOPOLIS_BACKEND_URL="https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/api/v2"
		else
			export HASHTOPOLIS_BACKEND_URL="http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/api/v2"
		fi
		envsubst \
			< "${S_WEBUI}/dist/assets/config.json.example" \
			> "${S_WEBUI}/dist/assets/config.json" \
			|| die
	else
		if use ssl ; then
			set_vhost_angularless_config_with_ssl
		else
			set_vhost_angularless_config_without_ssl
		fi
	fi

#	sed -i -e "30d" "src/inc/confv2.php" || die
#	sed -i -e "30i \"files\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/files\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"import\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/import\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"log\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/log\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"config\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/config\"," "src/inc/confv2.php" || die
}

src_compile() {
	if use angular ; then
		cd "${S_WEBUI}" || die

	# Avoid fatal: not a git repository
		git init || die
		touch dummy || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add dummy || die
		git commit -m "Dummy" || die
		git tag v${PV} || die

		npm_hydrate
		enpm run build

		# Prevent blank page
		sed -i -e "s| type=\"module\"||g" "dist/index.html" || die
	fi
	grep -F -e " ng: command not found" "${T}/build.log" && die "Detected error.  Try again."
}

src_install() {
	webapp_src_preinst

	cd "${S}" || die
	set_server_config
	cd "${S}" || die
	insinto "${MY_HTDOCSDIR}/hashtopolis-backend"
	doins -r src/*

	if use angular ; then
		pushd "${S_WEBUI}" || die
			insinto "${MY_HTDOCSDIR}/hashtopolis-frontend"
			doins -r dist/*
		popd
	fi

	chown -R root:root "${ED}${MY_HTDOCSDIR}/"

	fowners apache:apache "/etc/apache2/vhosts.d/40_hashtopolis-2.4.conf"
	fperms 0600 "/etc/apache2/vhosts.d/40_hashtopolis-2.4.conf"

	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/files/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/import/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/log/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/config/"

	# Ownership apache:apache required for login:
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/files/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/Encryption.class.php"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/load.php"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/install/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/lang/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/templates/"

	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	# TODO: fix permissions for admin to work

	webapp_hook_script "${FILESDIR}/permissions"

	dosym \
		"${MY_ETCDIR}/backend/php/inc/conf.php" \
		"${MY_HTDOCSDIR}/hashtopolis-backend/inc/conf.php"

	if use angular ; then
		LCNR_SOURCE="${S_WEBUI}"
		LCNR_TAG="web-ui-node_modules-third-party-licenses"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}/vendor"
	LCNR_TAG="composer-third-party-licenses"
	lcnr_install_files

	webapp_src_install
}

print_usage() {
	local HASHTOPOLIS_ADDRESS=${HASHTOPOLIS_ADDRESS:-"localhost"}
	local HASHTOPOLIS_BACKEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-8080}
	local HASHTOPOLIS_FRONTEND_PORT=${HASHTOPOLIS_FRONTEND_PORT:-4200}
	if use angular ; then
einfo
		if use ssl ; then
einfo "To add an admin, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access the backend, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
einfo "To access the frontend, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_FRONTEND_PORT}"
		else
einfo "To add an admin, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access the backend, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
einfo "To access the frontend, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_FRONTEND_PORT}"
		fi
einfo
	else
einfo
		if use ssl ; then
einfo "To add an admin, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
		else
einfo "To add an admin, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
		fi
einfo
	fi
ewarn
ewarn "Use user admin and password hashtopolis to enter http[s]://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
ewarn "You must change the password it or delete the account."
ewarn
ewarn
ewarn "When you are done setting up admin(s), delete the install folder."
ewarn
}

pkg_postinst() {
ewarn "Run \`emerge =hashtopolis-server-${PV} --config\` to complete installation."
	webapp_pkg_postinst
	print_usage
}

# See https://www.gentoo.org/glep/glep-0011.html
pkg_config() {
	if ! pgrep mysqld >/dev/null 2>&1 && ! pgrep mariadbd >/dev/null 2>&1 ; then
eerror
eerror "A SQL server has not been started!  Start it first!"
eerror
eerror "For OpenRC:  /etc/init.d/mysql restart"
eerror "For systemd:  systemctl restart mysqld.service"
eerror
		die
	fi
	check_php_support_in_apache

	if use vhosts ; then
		_VHOST_ROOT="/var/www/${HASHTOPOLIS_ADDRESS}"
	else
		_VHOST_ROOT="${VHOST_ROOT}"
	fi
	MY_HTDOCSDIR_VHOST="${_VHOST_ROOT}/htdocs/hashtopolis"
	MY_HTDOCSDIR_VHOST_BACKEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
	MY_HTDOCSDIR_VHOST_FRONTEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
einfo "MY_HTDOCSDIR_VHOST_BACKEND:  ${MY_HTDOCSDIR_VHOST_BACKEND}"
einfo "MY_HTDOCSDIR_VHOST_FRONTEND:  ${MY_HTDOCSDIR_VHOST_FRONTEND}"

	if [[ ! -e "/etc/hashtopolis/server/salt" ]] ; then
		mkdir -p "/etc/hashtopolis/server"
		local password_salt=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | sha256sum | base64 -w 0)
		echo "${password_salt}" > "/etc/hashtopolis/server/salt" || die
		chmod 0600 "/etc/hashtopolis/server/salt" || die
	fi

einfo "Enter a new password for the user hastopolis for SQL access:"
	read -s hashtopolis_password
	local hashtopolis_password_=$(echo -n "${hashtopolis_password}:$(cat /etc/hashtopolis/server/salt)" | sha256sum | cut -f 1 -d " ")
	hashtopolis_password=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

einfo "Clean install hashtopolis database and user? [Y/n]"
	read
	if [[ "${REPLY^^}" == "Y" || -z "${REPLY}" ]] ; then
einfo "Creating database and non-root user hashtopolis with SQL server and database user root..."
mysql -h "127.0.0.1" -u root -p <<EOF
DROP DATABASE IF EXISTS hashtopolis;
DROP USER IF EXISTS 'hashtopolis'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE hashtopolis;
CREATE USER 'hashtopolis'@'localhost' IDENTIFIED BY "${hashtopolis_password_}";
GRANT ALL PRIVILEGES ON hashtopolis.* TO 'hashtopolis'@'localhost' WITH GRANT OPTION;
EOF
	fi

einfo "Creating ${MY_ETCDIR}/backend/php/inc/conf.php"
	mkdir -p "${MY_ETCDIR}/backend/php/inc/"
	SQL_PORT=${SQL_PORT:-3306}
cat <<EOF > "${MY_ETCDIR}/backend/php/inc/conf.php"
<?php
//START CONFIG
\$CONN['user'] = 'hashtopolis';
\$CONN['pass'] = "${hashtopolis_password_}";
\$CONN['server'] = 'localhost';
\$CONN['db'] = 'hashtopolis';
\$CONN['port'] = "${SQL_PORT}";
//END CONFIG
EOF
	hashtopolis_password_=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

#einfo "Enter a new admin password for the Admin GUI:"
#	read -s hashtopolis_admin_password
#	HASHTOPOLIS_ADMIN_PASSWORD="${hashtopolis_admin_password}"

einfo "Protecting sensitive config"
	chown apache:apache "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend/inc/load.php" || die
	chown apache:apache "${MY_ETCDIR}/backend/php/inc/conf.php"
	chmod 0600 "${MY_ETCDIR}/backend/php/inc/conf.php"

info "Creating user admin and configuring database"
	php -f "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend/inc/load.php" || die

	hashtopolis_admin_password=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

ewarn "The apache2 server must be restarted."
	print_usage
}
