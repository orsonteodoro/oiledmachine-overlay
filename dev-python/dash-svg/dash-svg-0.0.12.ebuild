# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Missing:
# sci-visualization/dash[testing]

NPM_TARBALL="${P}.tar.gz"
NODE_SLOTS=( 14 ) # Upstream uses node 12.
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12
REACT_PV="16.14.0" # Supports up to node 14 used for testing
#REACT_PV="18.3.1" # Supports up to node 17

inherit distutils-r1 edo npm

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.3.0.tgz -> npmpkg-@ampproject-remapping-2.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.25.7.tgz -> npmpkg-@babel-code-frame-7.25.7.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.25.7.tgz -> npmpkg-@babel-compat-data-7.25.7.tgz
https://registry.npmjs.org/@babel/core/-/core-7.25.7.tgz -> npmpkg-@babel-core-7.25.7.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.25.7.tgz -> npmpkg-@babel-generator-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.25.7.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.25.7.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.7.tgz -> npmpkg-@babel-helper-compilation-targets-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.25.7.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.25.7.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.6.2.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.6.2.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.25.7.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.25.7.tgz -> npmpkg-@babel-helper-module-imports-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.25.7.tgz -> npmpkg-@babel-helper-module-transforms-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.25.7.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.25.7.tgz -> npmpkg-@babel-helper-plugin-utils-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.25.7.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.25.7.tgz -> npmpkg-@babel-helper-replace-supers-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.25.7.tgz -> npmpkg-@babel-helper-simple-access-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.25.7.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.25.7.tgz -> npmpkg-@babel-helper-string-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.25.7.tgz -> npmpkg-@babel-helper-validator-option-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.25.7.tgz -> npmpkg-@babel-helper-wrap-function-7.25.7.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.25.7.tgz -> npmpkg-@babel-helpers-7.25.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.25.7.tgz -> npmpkg-@babel-highlight-7.25.7.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.25.7.tgz -> npmpkg-@babel-parser-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-firefox-class-in-computed-class-key/-/plugin-bugfix-firefox-class-in-computed-class-key-7.25.7.tgz -> npmpkg-@babel-plugin-bugfix-firefox-class-in-computed-class-key-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-class-field-initializer-scope/-/plugin-bugfix-safari-class-field-initializer-scope-7.25.7.tgz -> npmpkg-@babel-plugin-bugfix-safari-class-field-initializer-scope-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.25.7.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.25.7.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-static-class-fields-redefine-readonly/-/plugin-bugfix-v8-static-class-fields-redefine-readonly-7.25.7.tgz -> npmpkg-@babel-plugin-bugfix-v8-static-class-fields-redefine-readonly-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz -> npmpkg-@babel-plugin-proposal-object-rest-spread-7.20.7.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.25.7.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.25.7.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.25.7.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.25.7.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.25.7.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.25.7.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.25.7.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.25.7.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.25.7.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.25.7.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.25.7.tgz -> npmpkg-@babel-plugin-transform-classes-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.25.7.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.25.7.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.25.7.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-named-capturing-groups-regex/-/plugin-transform-duplicate-named-capturing-groups-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-duplicate-named-capturing-groups-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.25.7.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.25.7.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.25.7.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.25.7.tgz -> npmpkg-@babel-plugin-transform-for-of-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.25.7.tgz -> npmpkg-@babel-plugin-transform-function-name-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.25.7.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.25.7.tgz -> npmpkg-@babel-plugin-transform-literals-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.25.7.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.25.7.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.25.7.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.25.7.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.25.7.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.25.7.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.25.7.tgz -> npmpkg-@babel-plugin-transform-new-target-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.25.7.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.25.7.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.25.7.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.25.7.tgz -> npmpkg-@babel-plugin-transform-object-super-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.25.7.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.25.7.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.25.7.tgz -> npmpkg-@babel-plugin-transform-parameters-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.25.7.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.25.7.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.25.7.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-display-name/-/plugin-transform-react-display-name-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-display-name-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx/-/plugin-transform-react-jsx-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-jsx-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx-development/-/plugin-transform-react-jsx-development-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-jsx-development-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-pure-annotations/-/plugin-transform-react-pure-annotations-7.25.7.tgz -> npmpkg-@babel-plugin-transform-react-pure-annotations-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.25.7.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.25.7.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.25.7.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.25.7.tgz -> npmpkg-@babel-plugin-transform-spread-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.25.7.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.25.7.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.25.7.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.25.7.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.25.7.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.25.7.tgz -> npmpkg-@babel-preset-env-7.25.7.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> npmpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.npmjs.org/@babel/preset-react/-/preset-react-7.25.7.tgz -> npmpkg-@babel-preset-react-7.25.7.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.25.7.tgz -> npmpkg-@babel-runtime-7.25.7.tgz
https://registry.npmjs.org/@babel/template/-/template-7.25.7.tgz -> npmpkg-@babel-template-7.25.7.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.7.tgz -> npmpkg-@babel-traverse-7.25.7.tgz
https://registry.npmjs.org/@babel/types/-/types-7.25.7.tgz -> npmpkg-@babel-types-7.25.7.tgz
https://registry.npmjs.org/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> npmpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> npmpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> npmpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@plotly/dash-component-plugins/-/dash-component-plugins-1.2.3.tgz -> npmpkg-@plotly-dash-component-plugins-1.2.3.tgz
https://registry.npmjs.org/@plotly/webpack-dash-dynamic-import/-/webpack-dash-dynamic-import-1.3.0.tgz -> npmpkg-@plotly-webpack-dash-dynamic-import-1.3.0.tgz
https://registry.npmjs.org/@rtsao/scc/-/scc-1.1.0.tgz -> npmpkg-@rtsao-scc-1.1.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/http-proxy/-/http-proxy-1.17.15.tgz -> npmpkg-@types-http-proxy-1.17.15.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/node/-/node-22.7.4.tgz -> npmpkg-@types-node-22.7.4.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.9.0.tgz -> npmpkg-@webassemblyjs-ast-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-code-frame-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-fsm-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-module-context-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> npmpkg-@webassemblyjs-ieee754-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> npmpkg-@webassemblyjs-leb128-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> npmpkg-@webassemblyjs-utf8-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-printer-1.9.0.tgz
https://registry.npmjs.org/@webpack-cli/configtest/-/configtest-1.2.0.tgz -> npmpkg-@webpack-cli-configtest-1.2.0.tgz
https://registry.npmjs.org/@webpack-cli/info/-/info-1.5.0.tgz -> npmpkg-@webpack-cli-info-1.5.0.tgz
https://registry.npmjs.org/@webpack-cli/serve/-/serve-1.7.0.tgz -> npmpkg-@webpack-cli-serve-1.7.0.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz -> npmpkg-accepts-1.3.8.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> npmpkg-acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-errors/-/ajv-errors-1.0.1.tgz -> npmpkg-ajv-errors-1.0.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/aproba/-/aproba-1.2.0.tgz -> npmpkg-aproba-1.2.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> npmpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.8.tgz -> npmpkg-array-includes-3.1.8.tgz
https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz -> npmpkg-array-union-2.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/array.prototype.findlast/-/array.prototype.findlast-1.2.5.tgz -> npmpkg-array.prototype.findlast-1.2.5.tgz
https://registry.npmjs.org/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.5.tgz -> npmpkg-array.prototype.findlastindex-1.2.5.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.2.tgz -> npmpkg-array.prototype.flat-1.3.2.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.2.tgz -> npmpkg-array.prototype.flatmap-1.3.2.tgz
https://registry.npmjs.org/array.prototype.tosorted/-/array.prototype.tosorted-1.1.4.tgz -> npmpkg-array.prototype.tosorted-1.1.4.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> npmpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.6.tgz -> npmpkg-asn1-0.2.6.tgz
https://registry.npmjs.org/asn1.js/-/asn1.js-4.10.1.tgz -> npmpkg-asn1.js-4.10.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/assert/-/assert-1.5.1.tgz -> npmpkg-assert-1.5.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/util/-/util-0.10.4.tgz -> npmpkg-util-0.10.4.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.12.4.tgz -> npmpkg-ast-types-0.12.4.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-1.0.0.tgz -> npmpkg-astral-regex-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> npmpkg-available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.13.2.tgz -> npmpkg-aws4-1.13.2.tgz
https://registry.npmjs.org/babel-eslint/-/babel-eslint-10.1.0.tgz -> npmpkg-babel-eslint-10.1.0.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.4.1.tgz -> npmpkg-babel-loader-8.4.1.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.11.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.11.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.10.6.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.10.6.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.6.2.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.6.2.tgz
https://registry.npmjs.org/babel-plugin-syntax-jsx/-/babel-plugin-syntax-jsx-6.18.0.tgz -> npmpkg-babel-plugin-syntax-jsx-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> npmpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz -> npmpkg-big.js-5.2.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bn.js/-/bn.js-5.2.1.tgz -> npmpkg-bn.js-5.2.1.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/brorand/-/brorand-1.1.0.tgz -> npmpkg-brorand-1.1.0.tgz
https://registry.npmjs.org/browserify-aes/-/browserify-aes-1.2.0.tgz -> npmpkg-browserify-aes-1.2.0.tgz
https://registry.npmjs.org/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> npmpkg-browserify-cipher-1.0.1.tgz
https://registry.npmjs.org/browserify-des/-/browserify-des-1.0.2.tgz -> npmpkg-browserify-des-1.0.2.tgz
https://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.1.1.tgz -> npmpkg-browserify-rsa-4.1.1.tgz
https://registry.npmjs.org/browserify-sign/-/browserify-sign-4.2.3.tgz -> npmpkg-browserify-sign-4.2.3.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> npmpkg-browserify-zlib-0.2.0.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.0.tgz -> npmpkg-browserslist-4.24.0.tgz
https://registry.npmjs.org/buffer/-/buffer-4.9.2.tgz -> npmpkg-buffer-4.9.2.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer-xor/-/buffer-xor-1.0.3.tgz -> npmpkg-buffer-xor-1.0.3.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> npmpkg-builtin-status-codes-3.0.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/cacache/-/cacache-13.0.1.tgz -> npmpkg-cacache-13.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/cache-content-type/-/cache-content-type-1.0.1.tgz -> npmpkg-cache-content-type-1.0.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001667.tgz -> npmpkg-caniuse-lite-1.0.30001667.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/cheerio/-/cheerio-0.22.0.tgz -> npmpkg-cheerio-0.22.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.4.tgz -> npmpkg-chrome-trace-event-1.0.4.tgz
https://registry.npmjs.org/cipher-base/-/cipher-base-1.0.4.tgz -> npmpkg-cipher-base-1.0.4.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-3.0.0.tgz -> npmpkg-cli-width-3.0.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz -> npmpkg-clone-deep-4.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz -> npmpkg-colorette-2.0.20.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.1.tgz -> npmpkg-component-emitter-1.3.1.tgz
https://registry.npmjs.org/compressible/-/compressible-2.0.18.tgz -> npmpkg-compressible-2.0.18.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz -> npmpkg-connect-history-api-fallback-1.6.0.tgz
https://registry.npmjs.org/console-browserify/-/console-browserify-1.2.0.tgz -> npmpkg-console-browserify-1.2.0.tgz
https://registry.npmjs.org/constants-browserify/-/constants-browserify-1.0.0.tgz -> npmpkg-constants-browserify-1.0.0.tgz
https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz -> npmpkg-content-disposition-0.5.4.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz -> npmpkg-content-type-1.0.5.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/cookies/-/cookies-0.9.1.tgz -> npmpkg-cookies-0.9.1.tgz
https://registry.npmjs.org/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> npmpkg-copy-concurrently-1.0.5.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/copyfiles/-/copyfiles-2.4.1.tgz -> npmpkg-copyfiles-2.4.1.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.38.1.tgz -> npmpkg-core-js-compat-3.38.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/create-ecdh/-/create-ecdh-4.0.4.tgz -> npmpkg-create-ecdh-4.0.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/create-hash/-/create-hash-1.2.0.tgz -> npmpkg-create-hash-1.2.0.tgz
https://registry.npmjs.org/create-hmac/-/create-hmac-1.1.7.tgz -> npmpkg-create-hmac-1.1.7.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.12.0.tgz -> npmpkg-crypto-browserify-3.12.0.tgz
https://registry.npmjs.org/css-loader/-/css-loader-3.6.0.tgz -> npmpkg-css-loader-3.6.0.tgz
https://registry.npmjs.org/css-select/-/css-select-1.2.0.tgz -> npmpkg-css-select-1.2.0.tgz
https://registry.npmjs.org/css-what/-/css-what-2.1.3.tgz -> npmpkg-css-what-2.1.3.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cyclist/-/cyclist-1.0.2.tgz -> npmpkg-cyclist-1.0.2.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz -> npmpkg-data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz -> npmpkg-data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz -> npmpkg-data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/decamelize/-/decamelize-5.0.1.tgz -> npmpkg-decamelize-5.0.1.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-1.0.1.tgz -> npmpkg-deep-equal-1.0.1.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/des.js/-/des.js-1.1.0.tgz -> npmpkg-des.js-1.1.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz -> npmpkg-destroy-1.2.0.tgz
https://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> npmpkg-diffie-hellman-5.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz -> npmpkg-dir-glob-3.0.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.1.tgz -> npmpkg-dom-serializer-0.1.1.tgz
https://registry.npmjs.org/domain-browser/-/domain-browser-1.2.0.tgz -> npmpkg-domain-browser-1.2.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/domhandler/-/domhandler-2.4.2.tgz -> npmpkg-domhandler-2.4.2.tgz
https://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz -> npmpkg-domutils-1.5.1.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> npmpkg-ecc-jsbn-0.1.2.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.33.tgz -> npmpkg-electron-to-chromium-1.5.33.tgz
https://registry.npmjs.org/elliptic/-/elliptic-6.5.7.tgz -> npmpkg-elliptic-6.5.7.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz -> npmpkg-emojis-list-3.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> npmpkg-enhanced-resolve-4.5.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.5.0.tgz -> npmpkg-memory-fs-0.5.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/entities/-/entities-1.1.2.tgz -> npmpkg-entities-1.1.2.tgz
https://registry.npmjs.org/envinfo/-/envinfo-7.14.0.tgz -> npmpkg-envinfo-7.14.0.tgz
https://registry.npmjs.org/errno/-/errno-0.1.8.tgz -> npmpkg-errno-0.1.8.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.3.tgz -> npmpkg-es-abstract-1.23.3.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es-iterator-helpers/-/es-iterator-helpers-1.0.19.tgz -> npmpkg-es-iterator-helpers-1.0.19.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz -> npmpkg-es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> npmpkg-es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz -> npmpkg-es-shim-unscopables-1.0.2.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint/-/eslint-6.8.0.tgz -> npmpkg-eslint-6.8.0.tgz
https://registry.npmjs.org/eslint-config-prettier/-/eslint-config-prettier-6.15.0.tgz -> npmpkg-eslint-config-prettier-6.15.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz -> npmpkg-eslint-import-resolver-node-0.3.9.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.12.0.tgz -> npmpkg-eslint-module-utils-2.12.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.31.0.tgz -> npmpkg-eslint-plugin-import-2.31.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.37.1.tgz -> npmpkg-eslint-plugin-react-7.37.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.5.tgz -> npmpkg-resolve-2.0.0-next.5.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-1.4.3.tgz -> npmpkg-eslint-utils-1.4.3.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/globals/-/globals-12.4.0.tgz -> npmpkg-globals-12.4.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/espree/-/espree-6.2.1.tgz -> npmpkg-espree-6.2.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.6.0.tgz -> npmpkg-esquery-1.6.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> npmpkg-evp_bytestokey-1.0.3.tgz
https://registry.npmjs.org/execa/-/execa-4.1.0.tgz -> npmpkg-execa-4.1.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> npmpkg-fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz -> npmpkg-fastq-1.17.1.tgz
https://registry.npmjs.org/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> npmpkg-figgy-pudding-3.5.2.tgz
https://registry.npmjs.org/figures/-/figures-3.2.0.tgz -> npmpkg-figures-3.2.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-5.0.1.tgz -> npmpkg-file-entry-cache-5.0.1.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-2.0.1.tgz -> npmpkg-flat-cache-2.0.1.tgz
https://registry.npmjs.org/flatted/-/flatted-2.0.2.tgz -> npmpkg-flatted-2.0.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz -> npmpkg-rimraf-2.6.3.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz -> npmpkg-flat-5.0.2.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz -> npmpkg-flat-cache-3.2.0.tgz
https://registry.npmjs.org/flatted/-/flatted-3.3.1.tgz -> npmpkg-flatted-3.3.1.tgz
https://registry.npmjs.org/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> npmpkg-flush-write-stream-1.1.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.3.tgz -> npmpkg-form-data-2.3.3.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> npmpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> npmpkg-function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-6.0.0.tgz -> npmpkg-get-stdin-6.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> npmpkg-get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/globby/-/globby-11.1.0.tgz -> npmpkg-globby-11.1.0.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz -> npmpkg-ignore-5.3.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.1.5.tgz -> npmpkg-har-validator-5.1.5.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> npmpkg-has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/hash-base/-/hash-base-3.0.4.tgz -> npmpkg-hash-base-3.0.4.tgz
https://registry.npmjs.org/hash.js/-/hash.js-1.1.7.tgz -> npmpkg-hash.js-1.1.7.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> npmpkg-hmac-drbg-1.0.1.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-3.10.1.tgz -> npmpkg-htmlparser2-3.10.1.tgz
https://registry.npmjs.org/http-assert/-/http-assert-1.5.0.tgz -> npmpkg-http-assert-1.5.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.8.1.tgz -> npmpkg-http-errors-1.8.1.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-proxy-middleware/-/http-proxy-middleware-1.3.1.tgz -> npmpkg-http-proxy-middleware-1.3.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-browserify/-/https-browserify-1.0.0.tgz -> npmpkg-https-browserify-1.0.0.tgz
https://registry.npmjs.org/human-signals/-/human-signals-1.1.1.tgz -> npmpkg-human-signals-1.1.1.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-4.1.1.tgz -> npmpkg-icss-utils-4.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/iferr/-/iferr-0.1.5.tgz -> npmpkg-iferr-0.1.5.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.2.0.tgz -> npmpkg-import-local-3.2.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/inquirer/-/inquirer-7.3.3.tgz -> npmpkg-inquirer-7.3.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz -> npmpkg-internal-slot-1.0.7.tgz
https://registry.npmjs.org/interpret/-/interpret-2.2.0.tgz -> npmpkg-interpret-2.2.0.tgz
https://registry.npmjs.org/ip/-/ip-1.1.9.tgz -> npmpkg-ip-1.1.9.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.1.tgz -> npmpkg-is-accessor-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> npmpkg-is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-async-function/-/is-async-function-2.0.0.tgz -> npmpkg-is-async-function-2.0.0.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.1.tgz -> npmpkg-is-data-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz -> npmpkg-is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.3.tgz -> npmpkg-is-descriptor-1.0.3.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finalizationregistry/-/is-finalizationregistry-1.0.2.tgz -> npmpkg-is-finalizationregistry-1.0.2.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.0.10.tgz -> npmpkg-is-generator-function-1.0.10.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz -> npmpkg-is-map-2.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> npmpkg-is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-3.0.0.tgz -> npmpkg-is-plain-obj-3.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-promise/-/is-promise-4.0.0.tgz -> npmpkg-is-promise-4.0.0.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz -> npmpkg-is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> npmpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz -> npmpkg-is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz -> npmpkg-is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.3.tgz -> npmpkg-is-weakset-2.0.3.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/iterator.prototype/-/iterator.prototype-1.1.2.tgz -> npmpkg-iterator.prototype-1.1.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-25.5.0.tgz -> npmpkg-jest-worker-25.5.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-3.0.2.tgz -> npmpkg-jsesc-3.0.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.2.tgz -> npmpkg-jsprim-1.4.2.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.3.5.tgz -> npmpkg-jsx-ast-utils-3.3.5.tgz
https://registry.npmjs.org/keygrip/-/keygrip-1.1.0.tgz -> npmpkg-keygrip-1.1.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/koa/-/koa-2.15.3.tgz -> npmpkg-koa-2.15.3.tgz
https://registry.npmjs.org/koa-compose/-/koa-compose-4.1.0.tgz -> npmpkg-koa-compose-4.1.0.tgz
https://registry.npmjs.org/koa-compress/-/koa-compress-5.1.1.tgz -> npmpkg-koa-compress-5.1.1.tgz
https://registry.npmjs.org/koa-connect/-/koa-connect-2.1.0.tgz -> npmpkg-koa-connect-2.1.0.tgz
https://registry.npmjs.org/koa-convert/-/koa-convert-2.0.0.tgz -> npmpkg-koa-convert-2.0.0.tgz
https://registry.npmjs.org/koa-is-json/-/koa-is-json-1.0.0.tgz -> npmpkg-koa-is-json-1.0.0.tgz
https://registry.npmjs.org/koa-route/-/koa-route-3.2.0.tgz -> npmpkg-koa-route-3.2.0.tgz
https://registry.npmjs.org/koa-send/-/koa-send-5.0.1.tgz -> npmpkg-koa-send-5.0.1.tgz
https://registry.npmjs.org/koa-static/-/koa-static-5.0.0.tgz -> npmpkg-koa-static-5.0.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-5.3.0.tgz -> npmpkg-load-json-file-5.3.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz -> npmpkg-type-fest-0.3.1.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-2.4.0.tgz -> npmpkg-loader-runner-2.4.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.assignin/-/lodash.assignin-4.2.0.tgz -> npmpkg-lodash.assignin-4.2.0.tgz
https://registry.npmjs.org/lodash.bind/-/lodash.bind-4.2.1.tgz -> npmpkg-lodash.bind-4.2.1.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.filter/-/lodash.filter-4.6.0.tgz -> npmpkg-lodash.filter-4.6.0.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.foreach/-/lodash.foreach-4.5.0.tgz -> npmpkg-lodash.foreach-4.5.0.tgz
https://registry.npmjs.org/lodash.map/-/lodash.map-4.6.0.tgz -> npmpkg-lodash.map-4.6.0.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.pick/-/lodash.pick-4.4.0.tgz -> npmpkg-lodash.pick-4.4.0.tgz
https://registry.npmjs.org/lodash.reduce/-/lodash.reduce-4.6.0.tgz -> npmpkg-lodash.reduce-4.6.0.tgz
https://registry.npmjs.org/lodash.reject/-/lodash.reject-4.6.0.tgz -> npmpkg-lodash.reject-4.6.0.tgz
https://registry.npmjs.org/lodash.some/-/lodash.some-4.6.0.tgz -> npmpkg-lodash.some-4.6.0.tgz
https://registry.npmjs.org/loglevelnext/-/loglevelnext-4.0.1.tgz -> npmpkg-loglevelnext-4.0.1.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/md5.js/-/md5.js-1.3.5.tgz -> npmpkg-md5.js-1.3.5.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz -> npmpkg-media-typer-0.3.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/methods/-/methods-1.1.2.tgz -> npmpkg-methods-1.1.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/miller-rabin/-/miller-rabin-4.0.1.tgz -> npmpkg-miller-rabin-4.0.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> npmpkg-minimalistic-assert-1.0.1.tgz
https://registry.npmjs.org/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> npmpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/minipass-collect/-/minipass-collect-1.0.2.tgz -> npmpkg-minipass-collect-1.0.2.tgz
https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz -> npmpkg-minipass-flush-1.0.5.tgz
https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> npmpkg-minipass-pipeline-1.2.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/mississippi/-/mississippi-3.0.0.tgz -> npmpkg-mississippi-3.0.0.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/move-concurrently/-/move-concurrently-1.0.1.tgz -> npmpkg-move-concurrently-1.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.8.tgz -> npmpkg-mute-stream-0.0.8.tgz
https://registry.npmjs.org/nan/-/nan-2.20.0.tgz -> npmpkg-nan-2.20.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz -> npmpkg-negotiator-0.6.3.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-dir/-/node-dir-0.1.17.tgz -> npmpkg-node-dir-0.1.17.tgz
https://registry.npmjs.org/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> npmpkg-node-libs-browser-2.2.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/noms/-/noms-0.0.0.tgz -> npmpkg-noms-0.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz -> npmpkg-readable-stream-1.0.34.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/npm/-/npm-8.12.2.tgz -> npmpkg-npm-8.12.2.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/nth-check/-/nth-check-1.0.2.tgz -> npmpkg-nth-check-1.0.2.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.9.0.tgz -> npmpkg-oauth-sign-0.9.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-path/-/object-path-0.11.8.tgz -> npmpkg-object-path-0.11.8.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.8.tgz -> npmpkg-object.entries-1.1.8.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.8.tgz -> npmpkg-object.fromentries-2.0.8.tgz
https://registry.npmjs.org/object.groupby/-/object.groupby-1.0.3.tgz -> npmpkg-object.groupby-1.0.3.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/object.values/-/object.values-1.2.0.tgz -> npmpkg-object.values-1.2.0.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz -> npmpkg-on-finished-2.4.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/only/-/only-0.0.2.tgz -> npmpkg-only-0.0.2.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/os-browserify/-/os-browserify-0.3.0.tgz -> npmpkg-os-browserify-0.3.0.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/p-defer/-/p-defer-3.0.0.tgz -> npmpkg-p-defer-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-3.0.0.tgz -> npmpkg-p-map-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parallel-transform/-/parallel-transform-1.2.0.tgz -> npmpkg-parallel-transform-1.2.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-asn1/-/parse-asn1-5.1.7.tgz -> npmpkg-parse-asn1-5.1.7.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-0.0.1.tgz -> npmpkg-path-browserify-0.0.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-1.9.0.tgz -> npmpkg-path-to-regexp-1.9.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/pbkdf2/-/pbkdf2-3.1.2.tgz -> npmpkg-pbkdf2-3.1.2.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-3.1.0.tgz -> npmpkg-pkg-conf-3.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> npmpkg-possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.47.tgz -> npmpkg-postcss-8.4.47.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-2.0.0.tgz -> npmpkg-postcss-modules-extract-imports-2.0.0.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-3.0.3.tgz -> npmpkg-postcss-modules-local-by-default-3.0.3.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-2.2.0.tgz -> npmpkg-postcss-modules-scope-2.2.0.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-3.0.0.tgz -> npmpkg-postcss-modules-values-3.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz -> npmpkg-prop-types-15.8.1.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz -> npmpkg-prr-1.0.1.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/public-encrypt/-/public-encrypt-4.0.3.tgz -> npmpkg-public-encrypt-4.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/qs/-/qs-6.5.3.tgz -> npmpkg-qs-6.5.3.tgz
https://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz -> npmpkg-querystring-es3-0.2.1.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz -> npmpkg-queue-microtask-1.2.3.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/ramda/-/ramda-0.26.1.tgz -> npmpkg-ramda-0.26.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/randomfill/-/randomfill-1.0.4.tgz -> npmpkg-randomfill-1.0.4.tgz
https://registry.npmjs.org/react/-/react-16.14.0.tgz -> npmpkg-react-16.14.0.tgz
https://registry.npmjs.org/react-docgen/-/react-docgen-4.1.1.tgz -> npmpkg-react-docgen-4.1.1.tgz
https://registry.npmjs.org/react-dom/-/react-dom-16.14.0.tgz -> npmpkg-react-dom-16.14.0.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/recast/-/recast-0.17.6.tgz -> npmpkg-recast-0.17.6.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.7.1.tgz -> npmpkg-rechoir-0.7.1.tgz
https://registry.npmjs.org/reflect.getprototypeof/-/reflect.getprototypeof-1.0.6.tgz -> npmpkg-reflect.getprototypeof-1.0.6.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.2.0.tgz -> npmpkg-regenerate-unicode-properties-10.2.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> npmpkg-regenerator-runtime-0.14.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.3.tgz -> npmpkg-regexp.prototype.flags-1.5.3.tgz
https://registry.npmjs.org/regexpp/-/regexpp-2.0.1.tgz -> npmpkg-regexpp-2.0.1.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-6.1.1.tgz -> npmpkg-regexpu-core-6.1.1.tgz
https://registry.npmjs.org/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-regjsgen-0.8.0.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.11.1.tgz -> npmpkg-regjsparser-0.11.1.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/request/-/request-2.88.2.tgz -> npmpkg-request-2.88.2.tgz
https://registry.npmjs.org/request-promise/-/request-promise-4.2.6.tgz -> npmpkg-request-promise-4.2.6.tgz
https://registry.npmjs.org/request-promise-core/-/request-promise-core-1.1.4.tgz -> npmpkg-request-promise-core-1.1.4.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-path/-/resolve-path-1.4.0.tgz -> npmpkg-resolve-path-1.4.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.3.tgz -> npmpkg-http-errors-1.6.3.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.1.0.tgz -> npmpkg-setprototypeof-1.1.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz -> npmpkg-reusify-1.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/ripemd160/-/ripemd160-2.0.2.tgz -> npmpkg-ripemd160-2.0.2.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz -> npmpkg-run-parallel-1.2.0.tgz
https://registry.npmjs.org/run-queue/-/run-queue-1.0.3.tgz -> npmpkg-run-queue-1.0.3.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz -> npmpkg-safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> npmpkg-safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.19.1.tgz -> npmpkg-scheduler-0.19.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz -> npmpkg-set-function-name-2.0.2.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/sha.js/-/sha.js-2.4.11.tgz -> npmpkg-sha.js-2.4.11.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz -> npmpkg-shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-2.1.0.tgz -> npmpkg-slice-ansi-2.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.18.0.tgz -> npmpkg-sshpk-1.18.0.tgz
https://registry.npmjs.org/ssri/-/ssri-7.1.1.tgz -> npmpkg-ssri-7.1.1.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/stealthy-require/-/stealthy-require-1.1.1.tgz -> npmpkg-stealthy-require-1.1.1.tgz
https://registry.npmjs.org/stream-browserify/-/stream-browserify-2.0.2.tgz -> npmpkg-stream-browserify-2.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/stream-each/-/stream-each-1.2.3.tgz -> npmpkg-stream-each-1.2.3.tgz
https://registry.npmjs.org/stream-http/-/stream-http-2.8.3.tgz -> npmpkg-stream-http-2.8.3.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.3.tgz -> npmpkg-stream-shift-1.0.3.tgz
https://registry.npmjs.org/string/-/string-3.3.3.tgz -> npmpkg-string-3.3.3.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string-hash/-/string-hash-1.1.3.tgz -> npmpkg-string-hash-1.1.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.11.tgz -> npmpkg-string.prototype.matchall-4.0.11.tgz
https://registry.npmjs.org/string.prototype.repeat/-/string.prototype.repeat-1.0.0.tgz -> npmpkg-string.prototype.repeat-1.0.0.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz -> npmpkg-string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz -> npmpkg-string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz -> npmpkg-string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/style-loader/-/style-loader-0.23.1.tgz -> npmpkg-style-loader-0.23.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/styled-jsx/-/styled-jsx-3.4.7.tgz -> npmpkg-styled-jsx-3.4.7.tgz
https://registry.npmjs.org/@babel/types/-/types-7.8.3.tgz -> npmpkg-@babel-types-7.8.3.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.7.0.tgz -> npmpkg-convert-source-map-1.7.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.7.3.tgz -> npmpkg-source-map-0.7.3.tgz
https://registry.npmjs.org/stylis/-/stylis-3.5.4.tgz -> npmpkg-stylis-3.5.4.tgz
https://registry.npmjs.org/stylis-rule-sheet/-/stylis-rule-sheet-0.0.10.tgz -> npmpkg-stylis-rule-sheet-0.0.10.tgz
https://registry.npmjs.org/superstruct/-/superstruct-0.12.2.tgz -> npmpkg-superstruct-0.12.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/table/-/table-5.4.6.tgz -> npmpkg-table-5.4.6.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz -> npmpkg-tapable-1.1.3.tgz
https://registry.npmjs.org/terser/-/terser-4.8.1.tgz -> npmpkg-terser-4.8.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-2.3.8.tgz -> npmpkg-terser-webpack-plugin-2.3.8.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/timers-browserify/-/timers-browserify-2.0.12.tgz -> npmpkg-timers-browserify-2.0.12.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> npmpkg-to-arraybuffer-1.0.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.4.tgz -> npmpkg-tough-cookie-4.1.4.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz -> npmpkg-tsconfig-paths-3.15.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tsscmp/-/tsscmp-1.0.6.tgz -> npmpkg-tsscmp-1.0.6.tgz
https://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz -> npmpkg-tty-browserify-0.0.0.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz -> npmpkg-type-is-1.6.18.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> npmpkg-typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> npmpkg-typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz -> npmpkg-typed-array-byte-offset-1.0.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.6.tgz -> npmpkg-typed-array-length-1.0.6.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz -> npmpkg-undici-types-6.19.8.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.1.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.1.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.2.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.2.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-1.1.1.tgz -> npmpkg-unique-filename-1.1.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-2.0.2.tgz -> npmpkg-unique-slug-2.0.2.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/untildify/-/untildify-4.0.0.tgz -> npmpkg-untildify-4.0.0.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url/-/url-0.11.4.tgz -> npmpkg-url-0.11.4.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/qs/-/qs-6.13.0.tgz -> npmpkg-qs-6.13.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util/-/util-0.11.1.tgz -> npmpkg-util-0.11.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.4.0.tgz -> npmpkg-v8-compile-cache-2.4.0.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/vm-browserify/-/vm-browserify-1.1.2.tgz -> npmpkg-vm-browserify-1.1.2.tgz
https://registry.npmjs.org/watchpack/-/watchpack-1.7.5.tgz -> npmpkg-watchpack-1.7.5.tgz
https://registry.npmjs.org/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> npmpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/webpack/-/webpack-4.47.0.tgz -> npmpkg-webpack-4.47.0.tgz
https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.10.0.tgz -> npmpkg-webpack-cli-4.10.0.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/webpack-merge/-/webpack-merge-5.10.0.tgz -> npmpkg-webpack-merge-5.10.0.tgz
https://registry.npmjs.org/webpack-plugin-ramdisk/-/webpack-plugin-ramdisk-0.2.0.tgz -> npmpkg-webpack-plugin-ramdisk-0.2.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/webpack-plugin-serve/-/webpack-plugin-serve-1.6.0.tgz -> npmpkg-webpack-plugin-serve-1.6.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/webpack-serve/-/webpack-serve-4.0.0.tgz -> npmpkg-webpack-serve-4.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/ssri/-/ssri-6.0.2.tgz -> npmpkg-ssri-6.0.2.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-1.4.6.tgz -> npmpkg-terser-webpack-plugin-1.4.6.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-builtin-type/-/which-builtin-type-1.1.4.tgz -> npmpkg-which-builtin-type-1.1.4.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz -> npmpkg-which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz -> npmpkg-which-typed-array-1.1.15.tgz
https://registry.npmjs.org/wildcard/-/wildcard-2.0.1.tgz -> npmpkg-wildcard-2.0.1.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/worker-farm/-/worker-farm-1.7.0.tgz -> npmpkg-worker-farm-1.7.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write/-/write-1.0.3.tgz -> npmpkg-write-1.0.3.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz -> npmpkg-yargs-parser-20.2.9.tgz
https://registry.npmjs.org/ylru/-/ylru-1.4.0.tgz -> npmpkg-ylru-1.4.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/stevej2608/dash-svg/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="SVG support library for Plotly/Dash"
HOMEPAGE="
https://github.com/stevej2608/dash-svg
https://pypi.org/project/dash-svg/
"
LICENSE="MIT" # https://github.com/stevej2608/dash-svg/blob/0.0.12/DESCRIPTION#L8
RESTRICT="mirror test" # Missing sci-visualization/dash[testing]
SLOT="0"
IUSE="test ebuild_revision_2"
RDEPEND+="
	>=dev-python/twine-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/keyrings-alt-4.1.0[${PYTHON_USEDEP}]
	>=sci-visualization/dash-1.15.0[${PYTHON_USEDEP},dev(+)]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

npm_update_lock_audit_post() {
	localfile_edits() {
		sed -i -e "s|\"loader-utils\": \"^1.1.0\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"^1.2.3\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"1.2.3\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die

		sed -i -e "s|\"ansi-regex\": \"^4.1.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die
		sed -i -e "s|\"ansi-regex\": \"^3.0.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die
		sed -i -e "s|\"ansi-regex\": \"^2.0.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die

		sed -i -e "s|\"postcss\": \"^7.0.32\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.14\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.5\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.6\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die

		sed -i -e "s|\"tough-cookie\": \"~2.5.0\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"tough-cookie\": \"^2.3.3\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die

		sed -i -e "s|\"got\": \"^6.7.1\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die

		# Use v8 which is backwards compatible with v1 lockfile
		sed -i -e "s|\"npm\": \"^6.1.0\"|\"npm\": \"8.12.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"ip\": \"1.1.5\"|\"ip\": \"1.1.9\"|g" "package-lock.json" || die
		sed -i -e "s|\"ip\": \"^1.1.5\"|\"ip\": \"1.1.9\"|g" "package-lock.json" || die
	}
	localfile_edits

	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure

	# webpack
	enpm install "loader-utils@^1.4.2" -D	# CVE-2022-37601	# DoS, DT, ID

	# watchpack
	enpm install "braces@^3.0.3" -D		# CVE-2024-4068		# DoS

	# npm
	enpm install "ansi-regex@^4.1.1" -D	# CVE-2021-3807		# DoS
	enpm install "tough-cookie@^4.1.3" -D	# CVE-2023-26136	# DT, ID
	enpm install "got@^11.8.5" -D		# CVE-2022-33987	# DT
	enpm install "ip@^1.1.9" -D		# CVE-2023-42282	# DoS, DT, ID # For npm
	# request EOL				# CVE-2023-28155	# DT, ID

	# css loader
	enpm install "postcss@^8.4.31" -D	# CVE-2023-44270	# DT

	# cheerio, parent webpack
	# lodash.pick				# CVE-2020-8203		# DT, ID

	# Bump parent packages to remove vulnerable dependencies while node 14.x compatible
	enpm install "npm@8.12.2" -D
	enpm install "webpack@^4.47.0" -D
	enpm install "webpack-cli@^4.10.0" -D
	enpm install "webpack-serve@^4.0.0" -D


	# Reapply

	localfile_edits

	enpm dedupe

	# When `npm install <package>` or `npm dedupe` gets called, it may undo lockfile edits.
	localfile_edits

	# Same vulnerability count before and after
	enpm audit
}

src_unpack() {
	npm_src_unpack
}

src_compile() {
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.dev.js" | grep -q "dash_svg.dev.js" || die
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.min.js" | grep -q "dash_svg.min.js" || die
}

src_test() {
	pytest || die
}

src_install() {
	distutils-r1_src_install
}
