# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit bazel python-r1

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="
https://www.tensorflow.org/
https://github.com/tensorflow/tensorboard
"
LICENSE="
	all-rights-reserved
	Apache-2.0
" # The distro Apache-2.0 template doesn't have all-rights-reserved
SLOT="0"
#KEYWORDS="~amd64" # Ebuild not finished.  See TODO list.
IUSE+=" test testing-tensorflow"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
# See https://github.com/tensorflow/tensorboard/blob/2.12.0/tensorboard/pip_package/requirements.txt
# Not used:
#	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
RDEPEND="
	${PYTHON_DEPS}
	(
		<dev-python/google-auth-3[${PYTHON_USEDEP}]
		>=dev-python/google-auth-1.6.3[${PYTHON_USEDEP}]
	)
	(
		<dev-python/google-auth-oauthlib-0.5[${PYTHON_USEDEP}]
		>=dev-python/google-auth-oauthlib-0.4.1[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/grpcio-1.48.2[${PYTHON_USEDEP}]
		testing-tensorflow? (
			<dev-python/grpcio-1.49.3[${PYTHON_USEDEP}]
		)
	)
	(
		<dev-python/requests-3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
	)
	(
		<sci-visualization/tensorboard-data-server-0.8[${PYTHON_USEDEP},testing-tensorflow=]
		>=sci-visualization/tensorboard-data-server-0.7[${PYTHON_USEDEP},testing-tensorflow=]
	)
	>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.6.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.6[${PYTHON_USEDEP}]
	>=dev-python/tensorboard-plugin-wit-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-1.0.1[${PYTHON_USEDEP}]

	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]

	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	${PYTHON_DEPS}
	(
		<dev-util/bazel-7
		>=dev-util/bazel-4.2.2
	)
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.26[${PYTHON_USEDEP}]
	>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
	>=dev-python/flake8-3.7.8[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.31[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.17.0[${PYTHON_USEDEP}]
	app-arch/unzip
	dev-java/java-config
	sys-apps/yarn
	test? (
		>=dev-python/boto3-1.9.86[${PYTHON_USEDEP}]
		>=dev-python/fsspec-0.7.4[${PYTHON_USEDEP}]
		>=dev-python/grpcio-testing-1.24.3[${PYTHON_USEDEP}]
		>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.0[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	=sci-libs/tensorflow-$(ver_cut 1-2 ${PV})*[${PYTHON_USEDEP},python]
"
YARN_EXTERNAL_URIS="
https://github.com/angular/dev-infra-private-build-tooling-builds/archive/fb42478534df7d48ec23a6834fea94a776cb89a0.tar.gz -> yarnpkg-dev-infra-private-build-tooling-builds.git-fb42478534df7d48ec23a6834fea94a776cb89a0.tgz
https://registry.yarnpkg.com/@adobe/css-tools/-/css-tools-4.0.1.tgz -> yarnpkg-@adobe-css-tools-4.0.1.tgz
https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.0.tgz -> yarnpkg-@ampproject-remapping-2.2.0.tgz
https://registry.yarnpkg.com/@angular-devkit/architect/-/architect-0.1402.10.tgz -> yarnpkg-@angular-devkit-architect-0.1402.10.tgz
https://registry.yarnpkg.com/@angular-devkit/architect/-/architect-0.1402.9.tgz -> yarnpkg-@angular-devkit-architect-0.1402.9.tgz
https://registry.yarnpkg.com/@angular-devkit/architect/-/architect-0.1500.0-rc.2.tgz -> yarnpkg-@angular-devkit-architect-0.1500.0-rc.2.tgz
https://registry.yarnpkg.com/@angular-devkit/build-angular/-/build-angular-14.2.10.tgz -> yarnpkg-@angular-devkit-build-angular-14.2.10.tgz
https://registry.yarnpkg.com/@angular-devkit/build-angular/-/build-angular-15.0.0-rc.2.tgz -> yarnpkg-@angular-devkit-build-angular-15.0.0-rc.2.tgz
https://registry.yarnpkg.com/@angular-devkit/build-webpack/-/build-webpack-0.1402.10.tgz -> yarnpkg-@angular-devkit-build-webpack-0.1402.10.tgz
https://registry.yarnpkg.com/@angular-devkit/build-webpack/-/build-webpack-0.1500.0-rc.2.tgz -> yarnpkg-@angular-devkit-build-webpack-0.1500.0-rc.2.tgz
https://registry.yarnpkg.com/@angular-devkit/core/-/core-14.2.10.tgz -> yarnpkg-@angular-devkit-core-14.2.10.tgz
https://registry.yarnpkg.com/@angular-devkit/core/-/core-14.2.9.tgz -> yarnpkg-@angular-devkit-core-14.2.9.tgz
https://registry.yarnpkg.com/@angular-devkit/core/-/core-15.0.0-rc.2.tgz -> yarnpkg-@angular-devkit-core-15.0.0-rc.2.tgz
https://registry.yarnpkg.com/@angular-devkit/schematics/-/schematics-14.2.9.tgz -> yarnpkg-@angular-devkit-schematics-14.2.9.tgz
https://registry.yarnpkg.com/@angular/animations/-/animations-14.2.11.tgz -> yarnpkg-@angular-animations-14.2.11.tgz
https://registry.yarnpkg.com/@angular/benchpress/-/benchpress-0.3.0.tgz -> yarnpkg-@angular-benchpress-0.3.0.tgz
https://registry.yarnpkg.com/@angular/cdk/-/cdk-14.2.7.tgz -> yarnpkg-@angular-cdk-14.2.7.tgz
https://registry.yarnpkg.com/@angular/cli/-/cli-14.2.9.tgz -> yarnpkg-@angular-cli-14.2.9.tgz
https://registry.yarnpkg.com/@angular/common/-/common-14.2.11.tgz -> yarnpkg-@angular-common-14.2.11.tgz
https://registry.yarnpkg.com/@angular/compiler-cli/-/compiler-cli-14.2.11.tgz -> yarnpkg-@angular-compiler-cli-14.2.11.tgz
https://registry.yarnpkg.com/@angular/compiler/-/compiler-14.2.11.tgz -> yarnpkg-@angular-compiler-14.2.11.tgz
https://registry.yarnpkg.com/@angular/core/-/core-14.2.11.tgz -> yarnpkg-@angular-core-14.2.11.tgz
https://registry.yarnpkg.com/@angular/forms/-/forms-14.2.11.tgz -> yarnpkg-@angular-forms-14.2.11.tgz
https://registry.yarnpkg.com/@angular/localize/-/localize-14.2.11.tgz -> yarnpkg-@angular-localize-14.2.11.tgz
https://registry.yarnpkg.com/@angular/material/-/material-14.2.7.tgz -> yarnpkg-@angular-material-14.2.7.tgz
https://registry.yarnpkg.com/@angular/platform-browser-dynamic/-/platform-browser-dynamic-14.2.11.tgz -> yarnpkg-@angular-platform-browser-dynamic-14.2.11.tgz
https://registry.yarnpkg.com/@angular/platform-browser/-/platform-browser-14.2.11.tgz -> yarnpkg-@angular-platform-browser-14.2.11.tgz
https://registry.yarnpkg.com/@angular/router/-/router-14.2.11.tgz -> yarnpkg-@angular-router-14.2.11.tgz
https://registry.yarnpkg.com/@assemblyscript/loader/-/loader-0.10.1.tgz -> yarnpkg-@assemblyscript-loader-0.10.1.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.18.6.tgz -> yarnpkg-@babel-code-frame-7.18.6.tgz
https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.20.1.tgz -> yarnpkg-@babel-compat-data-7.20.1.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.18.10.tgz -> yarnpkg-@babel-core-7.18.10.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.18.9.tgz -> yarnpkg-@babel-core-7.18.9.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.19.6.tgz -> yarnpkg-@babel-core-7.19.6.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.20.2.tgz -> yarnpkg-@babel-core-7.20.2.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.18.12.tgz -> yarnpkg-@babel-generator-7.18.12.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.20.1.tgz -> yarnpkg-@babel-generator-7.20.1.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.20.4.tgz -> yarnpkg-@babel-generator-7.20.4.tgz
https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.18.6.tgz -> yarnpkg-@babel-helper-annotate-as-pure-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.18.9.tgz -> yarnpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.20.0.tgz -> yarnpkg-@babel-helper-compilation-targets-7.20.0.tgz
https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.20.2.tgz -> yarnpkg-@babel-helper-create-class-features-plugin-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.19.0.tgz -> yarnpkg-@babel-helper-create-regexp-features-plugin-7.19.0.tgz
https://registry.yarnpkg.com/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.3.tgz -> yarnpkg-@babel-helper-define-polyfill-provider-0.3.3.tgz
https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.18.9.tgz -> yarnpkg-@babel-helper-environment-visitor-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-explode-assignable-expression/-/helper-explode-assignable-expression-7.18.6.tgz -> yarnpkg-@babel-helper-explode-assignable-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.19.0.tgz -> yarnpkg-@babel-helper-function-name-7.19.0.tgz
https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.18.6.tgz -> yarnpkg-@babel-helper-hoist-variables-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.18.9.tgz -> yarnpkg-@babel-helper-member-expression-to-functions-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.18.6.tgz -> yarnpkg-@babel-helper-module-imports-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.20.2.tgz -> yarnpkg-@babel-helper-module-transforms-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.18.6.tgz -> yarnpkg-@babel-helper-optimise-call-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.20.2.tgz -> yarnpkg-@babel-helper-plugin-utils-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.18.9.tgz -> yarnpkg-@babel-helper-remap-async-to-generator-7.18.9.tgz
https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.19.1.tgz -> yarnpkg-@babel-helper-replace-supers-7.19.1.tgz
https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.20.2.tgz -> yarnpkg-@babel-helper-simple-access-7.20.2.tgz
https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.20.0.tgz -> yarnpkg-@babel-helper-skip-transparent-expression-wrappers-7.20.0.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.18.6.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-string-parser/-/helper-string-parser-7.19.4.tgz -> yarnpkg-@babel-helper-string-parser-7.19.4.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz -> yarnpkg-@babel-helper-validator-identifier-7.19.1.tgz
https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.18.6.tgz -> yarnpkg-@babel-helper-validator-option-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.19.0.tgz -> yarnpkg-@babel-helper-wrap-function-7.19.0.tgz
https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.20.1.tgz -> yarnpkg-@babel-helpers-7.20.1.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz -> yarnpkg-@babel-highlight-7.18.6.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.20.3.tgz -> yarnpkg-@babel-parser-7.20.3.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.18.6.tgz -> yarnpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.18.9.tgz -> yarnpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.18.10.tgz -> yarnpkg-@babel-plugin-proposal-async-generator-functions-7.18.10.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.1.tgz -> yarnpkg-@babel-plugin-proposal-async-generator-functions-7.20.1.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-class-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-class-static-block/-/plugin-proposal-class-static-block-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-class-static-block-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-dynamic-import/-/plugin-proposal-dynamic-import-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-dynamic-import-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-export-namespace-from/-/plugin-proposal-export-namespace-from-7.18.9.tgz -> yarnpkg-@babel-plugin-proposal-export-namespace-from-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-json-strings-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-logical-assignment-operators/-/plugin-proposal-logical-assignment-operators-7.18.9.tgz -> yarnpkg-@babel-plugin-proposal-logical-assignment-operators-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-nullish-coalescing-operator/-/plugin-proposal-nullish-coalescing-operator-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-nullish-coalescing-operator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-numeric-separator/-/plugin-proposal-numeric-separator-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-numeric-separator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.2.tgz -> yarnpkg-@babel-plugin-proposal-object-rest-spread-7.20.2.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-optional-catch-binding-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.18.9.tgz -> yarnpkg-@babel-plugin-proposal-optional-chaining-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-private-methods/-/plugin-proposal-private-methods-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-private-methods-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-private-property-in-object-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-proposal-unicode-property-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> yarnpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> yarnpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.20.0.tgz -> yarnpkg-@babel-plugin-syntax-import-assertions-7.20.0.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-arrow-functions-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-async-to-generator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-block-scoped-functions-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.20.2.tgz -> yarnpkg-@babel-plugin-transform-block-scoping-7.20.2.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.20.2.tgz -> yarnpkg-@babel-plugin-transform-classes-7.20.2.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-computed-properties-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.20.2.tgz -> yarnpkg-@babel-plugin-transform-destructuring-7.20.2.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-dotall-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-duplicate-keys-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-exponentiation-operator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.18.8.tgz -> yarnpkg-@babel-plugin-transform-for-of-7.18.8.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-function-name-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-literals-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-member-expression-literals-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.19.6.tgz -> yarnpkg-@babel-plugin-transform-modules-amd-7.19.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.19.6.tgz -> yarnpkg-@babel-plugin-transform-modules-commonjs-7.19.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.19.6.tgz -> yarnpkg-@babel-plugin-transform-modules-systemjs-7.19.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-modules-umd-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.19.1.tgz -> yarnpkg-@babel-plugin-transform-named-capturing-groups-regex-7.19.1.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-new-target-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-object-super-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.20.3.tgz -> yarnpkg-@babel-plugin-transform-parameters-7.20.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-property-literals-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-regenerator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-reserved-words-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.18.10.tgz -> yarnpkg-@babel-plugin-transform-runtime-7.18.10.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.19.6.tgz -> yarnpkg-@babel-plugin-transform-runtime-7.19.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-shorthand-properties-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.19.0.tgz -> yarnpkg-@babel-plugin-transform-spread-7.19.0.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-sticky-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-template-literals-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.18.9.tgz -> yarnpkg-@babel-plugin-transform-typeof-symbol-7.18.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.18.10.tgz -> yarnpkg-@babel-plugin-transform-unicode-escapes-7.18.10.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-transform-unicode-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.18.10.tgz -> yarnpkg-@babel-preset-env-7.18.10.tgz
https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.19.4.tgz -> yarnpkg-@babel-preset-env-7.19.4.tgz
https://registry.yarnpkg.com/@babel/preset-modules/-/preset-modules-0.1.5.tgz -> yarnpkg-@babel-preset-modules-0.1.5.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.18.9.tgz -> yarnpkg-@babel-runtime-7.18.9.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.20.1.tgz -> yarnpkg-@babel-runtime-7.20.1.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.18.10.tgz -> yarnpkg-@babel-template-7.18.10.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.20.1.tgz -> yarnpkg-@babel-traverse-7.20.1.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.20.2.tgz -> yarnpkg-@babel-types-7.20.2.tgz
https://registry.yarnpkg.com/@bazel/buildifier/-/buildifier-5.1.0.tgz -> yarnpkg-@bazel-buildifier-5.1.0.tgz
https://registry.yarnpkg.com/@bazel/concatjs/-/concatjs-5.7.0.tgz -> yarnpkg-@bazel-concatjs-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/concatjs/-/concatjs-5.7.1.tgz -> yarnpkg-@bazel-concatjs-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/esbuild/-/esbuild-5.7.0.tgz -> yarnpkg-@bazel-esbuild-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/esbuild/-/esbuild-5.7.1.tgz -> yarnpkg-@bazel-esbuild-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/ibazel/-/ibazel-0.15.10.tgz -> yarnpkg-@bazel-ibazel-0.15.10.tgz
https://registry.yarnpkg.com/@bazel/jasmine/-/jasmine-5.7.0.tgz -> yarnpkg-@bazel-jasmine-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/protractor/-/protractor-5.7.1.tgz -> yarnpkg-@bazel-protractor-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/runfiles/-/runfiles-5.7.1.tgz -> yarnpkg-@bazel-runfiles-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/terser/-/terser-5.7.0.tgz -> yarnpkg-@bazel-terser-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/terser/-/terser-5.7.1.tgz -> yarnpkg-@bazel-terser-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/typescript/-/typescript-5.7.0.tgz -> yarnpkg-@bazel-typescript-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/typescript/-/typescript-5.7.1.tgz -> yarnpkg-@bazel-typescript-5.7.1.tgz
https://registry.yarnpkg.com/@bazel/worker/-/worker-5.7.0.tgz -> yarnpkg-@bazel-worker-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/worker/-/worker-5.7.1.tgz -> yarnpkg-@bazel-worker-5.7.1.tgz
https://registry.yarnpkg.com/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> yarnpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.yarnpkg.com/@csstools/postcss-cascade-layers/-/postcss-cascade-layers-1.1.1.tgz -> yarnpkg-@csstools-postcss-cascade-layers-1.1.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-color-function/-/postcss-color-function-1.1.1.tgz -> yarnpkg-@csstools-postcss-color-function-1.1.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-font-format-keywords/-/postcss-font-format-keywords-1.0.1.tgz -> yarnpkg-@csstools-postcss-font-format-keywords-1.0.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-hwb-function/-/postcss-hwb-function-1.0.2.tgz -> yarnpkg-@csstools-postcss-hwb-function-1.0.2.tgz
https://registry.yarnpkg.com/@csstools/postcss-ic-unit/-/postcss-ic-unit-1.0.1.tgz -> yarnpkg-@csstools-postcss-ic-unit-1.0.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-is-pseudo-class/-/postcss-is-pseudo-class-2.0.7.tgz -> yarnpkg-@csstools-postcss-is-pseudo-class-2.0.7.tgz
https://registry.yarnpkg.com/@csstools/postcss-nested-calc/-/postcss-nested-calc-1.0.0.tgz -> yarnpkg-@csstools-postcss-nested-calc-1.0.0.tgz
https://registry.yarnpkg.com/@csstools/postcss-normalize-display-values/-/postcss-normalize-display-values-1.0.1.tgz -> yarnpkg-@csstools-postcss-normalize-display-values-1.0.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-oklab-function/-/postcss-oklab-function-1.1.1.tgz -> yarnpkg-@csstools-postcss-oklab-function-1.1.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-progressive-custom-properties/-/postcss-progressive-custom-properties-1.3.0.tgz -> yarnpkg-@csstools-postcss-progressive-custom-properties-1.3.0.tgz
https://registry.yarnpkg.com/@csstools/postcss-stepped-value-functions/-/postcss-stepped-value-functions-1.0.1.tgz -> yarnpkg-@csstools-postcss-stepped-value-functions-1.0.1.tgz
https://registry.yarnpkg.com/@csstools/postcss-text-decoration-shorthand/-/postcss-text-decoration-shorthand-1.0.0.tgz -> yarnpkg-@csstools-postcss-text-decoration-shorthand-1.0.0.tgz
https://registry.yarnpkg.com/@csstools/postcss-trigonometric-functions/-/postcss-trigonometric-functions-1.0.2.tgz -> yarnpkg-@csstools-postcss-trigonometric-functions-1.0.2.tgz
https://registry.yarnpkg.com/@csstools/postcss-unset-value/-/postcss-unset-value-1.0.2.tgz -> yarnpkg-@csstools-postcss-unset-value-1.0.2.tgz
https://registry.yarnpkg.com/@csstools/selector-specificity/-/selector-specificity-2.0.2.tgz -> yarnpkg-@csstools-selector-specificity-2.0.2.tgz
https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> yarnpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.yarnpkg.com/@esbuild/android-arm/-/android-arm-0.15.12.tgz -> yarnpkg-@esbuild-android-arm-0.15.12.tgz
https://registry.yarnpkg.com/@esbuild/linux-loong64/-/linux-loong64-0.15.12.tgz -> yarnpkg-@esbuild-linux-loong64-0.15.12.tgz
https://registry.yarnpkg.com/@esbuild/linux-loong64/-/linux-loong64-0.15.5.tgz -> yarnpkg-@esbuild-linux-loong64-0.15.5.tgz
https://registry.yarnpkg.com/@gar/promisify/-/promisify-1.1.3.tgz -> yarnpkg-@gar-promisify-1.1.3.tgz
https://registry.yarnpkg.com/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> yarnpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.3.tgz -> yarnpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.1.1.tgz -> yarnpkg-@jridgewell-gen-mapping-0.1.1.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.2.tgz -> yarnpkg-@jridgewell-gen-mapping-0.3.2.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz -> yarnpkg-@jridgewell-resolve-uri-3.1.0.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz -> yarnpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/source-map/-/source-map-0.3.2.tgz -> yarnpkg-@jridgewell-source-map-0.3.2.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.17.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.17.tgz
https://registry.yarnpkg.com/@leichtgewicht/ip-codec/-/ip-codec-2.0.4.tgz -> yarnpkg-@leichtgewicht-ip-codec-2.0.4.tgz
https://registry.yarnpkg.com/@microsoft/api-extractor-model/-/api-extractor-model-7.24.0.tgz -> yarnpkg-@microsoft-api-extractor-model-7.24.0.tgz
https://registry.yarnpkg.com/@microsoft/api-extractor/-/api-extractor-7.31.0.tgz -> yarnpkg-@microsoft-api-extractor-7.31.0.tgz
https://registry.yarnpkg.com/@microsoft/tsdoc-config/-/tsdoc-config-0.16.2.tgz -> yarnpkg-@microsoft-tsdoc-config-0.16.2.tgz
https://registry.yarnpkg.com/@microsoft/tsdoc/-/tsdoc-0.14.1.tgz -> yarnpkg-@microsoft-tsdoc-0.14.1.tgz
https://registry.yarnpkg.com/@microsoft/tsdoc/-/tsdoc-0.14.2.tgz -> yarnpkg-@microsoft-tsdoc-0.14.2.tgz
https://registry.yarnpkg.com/@ngrx/effects/-/effects-14.3.2.tgz -> yarnpkg-@ngrx-effects-14.3.2.tgz
https://registry.yarnpkg.com/@ngrx/store/-/store-14.3.2.tgz -> yarnpkg-@ngrx-store-14.3.2.tgz
https://registry.yarnpkg.com/@ngtools/webpack/-/webpack-14.2.10.tgz -> yarnpkg-@ngtools-webpack-14.2.10.tgz
https://registry.yarnpkg.com/@ngtools/webpack/-/webpack-15.0.0-rc.2.tgz -> yarnpkg-@ngtools-webpack-15.0.0-rc.2.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-2.1.2.tgz -> yarnpkg-@npmcli-fs-2.1.2.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-3.1.0.tgz -> yarnpkg-@npmcli-fs-3.1.0.tgz
https://registry.yarnpkg.com/@npmcli/git/-/git-3.0.2.tgz -> yarnpkg-@npmcli-git-3.0.2.tgz
https://registry.yarnpkg.com/@npmcli/installed-package-contents/-/installed-package-contents-1.0.7.tgz -> yarnpkg-@npmcli-installed-package-contents-1.0.7.tgz
https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-2.0.1.tgz -> yarnpkg-@npmcli-move-file-2.0.1.tgz
https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-3.0.0.tgz -> yarnpkg-@npmcli-move-file-3.0.0.tgz
https://registry.yarnpkg.com/@npmcli/node-gyp/-/node-gyp-2.0.0.tgz -> yarnpkg-@npmcli-node-gyp-2.0.0.tgz
https://registry.yarnpkg.com/@npmcli/promise-spawn/-/promise-spawn-3.0.0.tgz -> yarnpkg-@npmcli-promise-spawn-3.0.0.tgz
https://registry.yarnpkg.com/@npmcli/run-script/-/run-script-4.2.1.tgz -> yarnpkg-@npmcli-run-script-4.2.1.tgz
https://registry.yarnpkg.com/@polymer/decorators/-/decorators-3.0.0.tgz -> yarnpkg-@polymer-decorators-3.0.0.tgz
https://registry.yarnpkg.com/@polymer/font-roboto/-/font-roboto-3.0.2.tgz -> yarnpkg-@polymer-font-roboto-3.0.2.tgz
https://registry.yarnpkg.com/@polymer/iron-a11y-announcer/-/iron-a11y-announcer-3.2.0.tgz -> yarnpkg-@polymer-iron-a11y-announcer-3.2.0.tgz
https://registry.yarnpkg.com/@polymer/iron-a11y-keys-behavior/-/iron-a11y-keys-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-a11y-keys-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-autogrow-textarea/-/iron-autogrow-textarea-3.0.3.tgz -> yarnpkg-@polymer-iron-autogrow-textarea-3.0.3.tgz
https://registry.yarnpkg.com/@polymer/iron-behaviors/-/iron-behaviors-3.0.1.tgz -> yarnpkg-@polymer-iron-behaviors-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-checked-element-behavior/-/iron-checked-element-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-checked-element-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-collapse/-/iron-collapse-3.0.1.tgz -> yarnpkg-@polymer-iron-collapse-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-dropdown/-/iron-dropdown-3.0.1.tgz -> yarnpkg-@polymer-iron-dropdown-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-fit-behavior/-/iron-fit-behavior-3.1.0.tgz -> yarnpkg-@polymer-iron-fit-behavior-3.1.0.tgz
https://registry.yarnpkg.com/@polymer/iron-flex-layout/-/iron-flex-layout-3.0.1.tgz -> yarnpkg-@polymer-iron-flex-layout-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-form-element-behavior/-/iron-form-element-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-form-element-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-icon/-/iron-icon-3.0.1.tgz -> yarnpkg-@polymer-iron-icon-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-icons/-/iron-icons-3.0.1.tgz -> yarnpkg-@polymer-iron-icons-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-iconset-svg/-/iron-iconset-svg-3.0.1.tgz -> yarnpkg-@polymer-iron-iconset-svg-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-input/-/iron-input-3.0.1.tgz -> yarnpkg-@polymer-iron-input-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-list/-/iron-list-3.1.0.tgz -> yarnpkg-@polymer-iron-list-3.1.0.tgz
https://registry.yarnpkg.com/@polymer/iron-menu-behavior/-/iron-menu-behavior-3.0.2.tgz -> yarnpkg-@polymer-iron-menu-behavior-3.0.2.tgz
https://registry.yarnpkg.com/@polymer/iron-meta/-/iron-meta-3.0.1.tgz -> yarnpkg-@polymer-iron-meta-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-overlay-behavior/-/iron-overlay-behavior-3.0.3.tgz -> yarnpkg-@polymer-iron-overlay-behavior-3.0.3.tgz
https://registry.yarnpkg.com/@polymer/iron-pages/-/iron-pages-3.0.1.tgz -> yarnpkg-@polymer-iron-pages-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-range-behavior/-/iron-range-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-range-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-resizable-behavior/-/iron-resizable-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-resizable-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-scroll-target-behavior/-/iron-scroll-target-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-scroll-target-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-selector/-/iron-selector-3.0.1.tgz -> yarnpkg-@polymer-iron-selector-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/iron-validatable-behavior/-/iron-validatable-behavior-3.0.1.tgz -> yarnpkg-@polymer-iron-validatable-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/neon-animation/-/neon-animation-3.0.1.tgz -> yarnpkg-@polymer-neon-animation-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-behaviors/-/paper-behaviors-3.0.1.tgz -> yarnpkg-@polymer-paper-behaviors-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-button/-/paper-button-3.0.1.tgz -> yarnpkg-@polymer-paper-button-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-checkbox/-/paper-checkbox-3.1.0.tgz -> yarnpkg-@polymer-paper-checkbox-3.1.0.tgz
https://registry.yarnpkg.com/@polymer/paper-dialog-behavior/-/paper-dialog-behavior-3.0.1.tgz -> yarnpkg-@polymer-paper-dialog-behavior-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-dialog-scrollable/-/paper-dialog-scrollable-3.0.1.tgz -> yarnpkg-@polymer-paper-dialog-scrollable-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-dialog/-/paper-dialog-3.0.1.tgz -> yarnpkg-@polymer-paper-dialog-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-dropdown-menu/-/paper-dropdown-menu-3.2.0.tgz -> yarnpkg-@polymer-paper-dropdown-menu-3.2.0.tgz
https://registry.yarnpkg.com/@polymer/paper-header-panel/-/paper-header-panel-3.0.1.tgz -> yarnpkg-@polymer-paper-header-panel-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-icon-button/-/paper-icon-button-3.0.2.tgz -> yarnpkg-@polymer-paper-icon-button-3.0.2.tgz
https://registry.yarnpkg.com/@polymer/paper-input/-/paper-input-3.2.1.tgz -> yarnpkg-@polymer-paper-input-3.2.1.tgz
https://registry.yarnpkg.com/@polymer/paper-item/-/paper-item-3.0.1.tgz -> yarnpkg-@polymer-paper-item-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-listbox/-/paper-listbox-3.0.1.tgz -> yarnpkg-@polymer-paper-listbox-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-material/-/paper-material-3.0.1.tgz -> yarnpkg-@polymer-paper-material-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-menu-button/-/paper-menu-button-3.1.0.tgz -> yarnpkg-@polymer-paper-menu-button-3.1.0.tgz
https://registry.yarnpkg.com/@polymer/paper-progress/-/paper-progress-3.0.1.tgz -> yarnpkg-@polymer-paper-progress-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-radio-button/-/paper-radio-button-3.0.1.tgz -> yarnpkg-@polymer-paper-radio-button-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-radio-group/-/paper-radio-group-3.0.1.tgz -> yarnpkg-@polymer-paper-radio-group-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-ripple/-/paper-ripple-3.0.2.tgz -> yarnpkg-@polymer-paper-ripple-3.0.2.tgz
https://registry.yarnpkg.com/@polymer/paper-slider/-/paper-slider-3.0.1.tgz -> yarnpkg-@polymer-paper-slider-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-spinner/-/paper-spinner-3.0.2.tgz -> yarnpkg-@polymer-paper-spinner-3.0.2.tgz
https://registry.yarnpkg.com/@polymer/paper-styles/-/paper-styles-3.0.1.tgz -> yarnpkg-@polymer-paper-styles-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-tabs/-/paper-tabs-3.1.0.tgz -> yarnpkg-@polymer-paper-tabs-3.1.0.tgz
https://registry.yarnpkg.com/@polymer/paper-toast/-/paper-toast-3.0.1.tgz -> yarnpkg-@polymer-paper-toast-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-toggle-button/-/paper-toggle-button-3.0.1.tgz -> yarnpkg-@polymer-paper-toggle-button-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-toolbar/-/paper-toolbar-3.0.1.tgz -> yarnpkg-@polymer-paper-toolbar-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/paper-tooltip/-/paper-tooltip-3.0.1.tgz -> yarnpkg-@polymer-paper-tooltip-3.0.1.tgz
https://registry.yarnpkg.com/@polymer/polymer/-/polymer-3.4.1.tgz -> yarnpkg-@polymer-polymer-3.4.1.tgz
https://registry.yarnpkg.com/@protobufjs/aspromise/-/aspromise-1.1.2.tgz -> yarnpkg-@protobufjs-aspromise-1.1.2.tgz
https://registry.yarnpkg.com/@protobufjs/base64/-/base64-1.1.2.tgz -> yarnpkg-@protobufjs-base64-1.1.2.tgz
https://registry.yarnpkg.com/@protobufjs/codegen/-/codegen-2.0.4.tgz -> yarnpkg-@protobufjs-codegen-2.0.4.tgz
https://registry.yarnpkg.com/@protobufjs/eventemitter/-/eventemitter-1.1.0.tgz -> yarnpkg-@protobufjs-eventemitter-1.1.0.tgz
https://registry.yarnpkg.com/@protobufjs/fetch/-/fetch-1.1.0.tgz -> yarnpkg-@protobufjs-fetch-1.1.0.tgz
https://registry.yarnpkg.com/@protobufjs/float/-/float-1.0.2.tgz -> yarnpkg-@protobufjs-float-1.0.2.tgz
https://registry.yarnpkg.com/@protobufjs/inquire/-/inquire-1.1.0.tgz -> yarnpkg-@protobufjs-inquire-1.1.0.tgz
https://registry.yarnpkg.com/@protobufjs/path/-/path-1.1.2.tgz -> yarnpkg-@protobufjs-path-1.1.2.tgz
https://registry.yarnpkg.com/@protobufjs/pool/-/pool-1.1.0.tgz -> yarnpkg-@protobufjs-pool-1.1.0.tgz
https://registry.yarnpkg.com/@protobufjs/utf8/-/utf8-1.1.0.tgz -> yarnpkg-@protobufjs-utf8-1.1.0.tgz
https://registry.yarnpkg.com/@rushstack/node-core-library/-/node-core-library-3.51.1.tgz -> yarnpkg-@rushstack-node-core-library-3.51.1.tgz
https://registry.yarnpkg.com/@rushstack/rig-package/-/rig-package-0.3.14.tgz -> yarnpkg-@rushstack-rig-package-0.3.14.tgz
https://registry.yarnpkg.com/@rushstack/ts-command-line/-/ts-command-line-4.12.2.tgz -> yarnpkg-@rushstack-ts-command-line-4.12.2.tgz
https://registry.yarnpkg.com/@schematics/angular/-/angular-14.2.9.tgz -> yarnpkg-@schematics-angular-14.2.9.tgz
https://registry.yarnpkg.com/@socket.io/component-emitter/-/component-emitter-3.1.0.tgz -> yarnpkg-@socket.io-component-emitter-3.1.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-backend-cpu/-/tfjs-backend-cpu-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-backend-cpu-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-backend-webgl/-/tfjs-backend-webgl-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-backend-webgl-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-converter/-/tfjs-converter-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-converter-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-core/-/tfjs-core-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-core-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-data/-/tfjs-data-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-data-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-layers/-/tfjs-layers-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-layers-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs/-/tfjs-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-3.4.0.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-2.0.0.tgz -> yarnpkg-@tootallnate-once-2.0.0.tgz
https://registry.yarnpkg.com/@types/argparse/-/argparse-1.0.38.tgz -> yarnpkg-@types-argparse-1.0.38.tgz
https://registry.yarnpkg.com/@types/body-parser/-/body-parser-1.19.2.tgz -> yarnpkg-@types-body-parser-1.19.2.tgz
https://registry.yarnpkg.com/@types/bonjour/-/bonjour-3.5.10.tgz -> yarnpkg-@types-bonjour-3.5.10.tgz
https://registry.yarnpkg.com/@types/browser-sync/-/browser-sync-2.26.3.tgz -> yarnpkg-@types-browser-sync-2.26.3.tgz
https://registry.yarnpkg.com/@types/connect-history-api-fallback/-/connect-history-api-fallback-1.3.5.tgz -> yarnpkg-@types-connect-history-api-fallback-1.3.5.tgz
https://registry.yarnpkg.com/@types/connect/-/connect-3.4.35.tgz -> yarnpkg-@types-connect-3.4.35.tgz
https://registry.yarnpkg.com/@types/cookie/-/cookie-0.4.1.tgz -> yarnpkg-@types-cookie-0.4.1.tgz
https://registry.yarnpkg.com/@types/cors/-/cors-2.8.12.tgz -> yarnpkg-@types-cors-2.8.12.tgz
https://registry.yarnpkg.com/@types/d3-array/-/d3-array-1.2.7.tgz -> yarnpkg-@types-d3-array-1.2.7.tgz
https://registry.yarnpkg.com/@types/d3-array/-/d3-array-2.0.0.tgz -> yarnpkg-@types-d3-array-2.0.0.tgz
https://registry.yarnpkg.com/@types/d3-axis/-/d3-axis-1.0.12.tgz -> yarnpkg-@types-d3-axis-1.0.12.tgz
https://registry.yarnpkg.com/@types/d3-brush/-/d3-brush-1.1.1.tgz -> yarnpkg-@types-d3-brush-1.1.1.tgz
https://registry.yarnpkg.com/@types/d3-chord/-/d3-chord-1.0.9.tgz -> yarnpkg-@types-d3-chord-1.0.9.tgz
https://registry.yarnpkg.com/@types/d3-collection/-/d3-collection-1.0.8.tgz -> yarnpkg-@types-d3-collection-1.0.8.tgz
https://registry.yarnpkg.com/@types/d3-color/-/d3-color-1.2.2.tgz -> yarnpkg-@types-d3-color-1.2.2.tgz
https://registry.yarnpkg.com/@types/d3-contour/-/d3-contour-1.3.0.tgz -> yarnpkg-@types-d3-contour-1.3.0.tgz
https://registry.yarnpkg.com/@types/d3-dispatch/-/d3-dispatch-1.0.8.tgz -> yarnpkg-@types-d3-dispatch-1.0.8.tgz
https://registry.yarnpkg.com/@types/d3-drag/-/d3-drag-1.2.3.tgz -> yarnpkg-@types-d3-drag-1.2.3.tgz
https://registry.yarnpkg.com/@types/d3-dsv/-/d3-dsv-1.0.36.tgz -> yarnpkg-@types-d3-dsv-1.0.36.tgz
https://registry.yarnpkg.com/@types/d3-ease/-/d3-ease-1.0.9.tgz -> yarnpkg-@types-d3-ease-1.0.9.tgz
https://registry.yarnpkg.com/@types/d3-fetch/-/d3-fetch-1.1.5.tgz -> yarnpkg-@types-d3-fetch-1.1.5.tgz
https://registry.yarnpkg.com/@types/d3-force/-/d3-force-1.2.1.tgz -> yarnpkg-@types-d3-force-1.2.1.tgz
https://registry.yarnpkg.com/@types/d3-format/-/d3-format-1.3.1.tgz -> yarnpkg-@types-d3-format-1.3.1.tgz
https://registry.yarnpkg.com/@types/d3-geo/-/d3-geo-1.11.1.tgz -> yarnpkg-@types-d3-geo-1.11.1.tgz
https://registry.yarnpkg.com/@types/d3-hierarchy/-/d3-hierarchy-1.1.6.tgz -> yarnpkg-@types-d3-hierarchy-1.1.6.tgz
https://registry.yarnpkg.com/@types/d3-interpolate/-/d3-interpolate-1.3.1.tgz -> yarnpkg-@types-d3-interpolate-1.3.1.tgz
https://registry.yarnpkg.com/@types/d3-path/-/d3-path-1.0.8.tgz -> yarnpkg-@types-d3-path-1.0.8.tgz
https://registry.yarnpkg.com/@types/d3-polygon/-/d3-polygon-1.0.7.tgz -> yarnpkg-@types-d3-polygon-1.0.7.tgz
https://registry.yarnpkg.com/@types/d3-quadtree/-/d3-quadtree-1.0.7.tgz -> yarnpkg-@types-d3-quadtree-1.0.7.tgz
https://registry.yarnpkg.com/@types/d3-queue/-/d3-queue-3.0.8.tgz -> yarnpkg-@types-d3-queue-3.0.8.tgz
https://registry.yarnpkg.com/@types/d3-random/-/d3-random-1.1.2.tgz -> yarnpkg-@types-d3-random-1.1.2.tgz
https://registry.yarnpkg.com/@types/d3-request/-/d3-request-1.0.5.tgz -> yarnpkg-@types-d3-request-1.0.5.tgz
https://registry.yarnpkg.com/@types/d3-scale-chromatic/-/d3-scale-chromatic-1.5.0.tgz -> yarnpkg-@types-d3-scale-chromatic-1.5.0.tgz
https://registry.yarnpkg.com/@types/d3-scale/-/d3-scale-1.0.14.tgz -> yarnpkg-@types-d3-scale-1.0.14.tgz
https://registry.yarnpkg.com/@types/d3-scale/-/d3-scale-2.2.0.tgz -> yarnpkg-@types-d3-scale-2.2.0.tgz
https://registry.yarnpkg.com/@types/d3-selection/-/d3-selection-1.4.2.tgz -> yarnpkg-@types-d3-selection-1.4.2.tgz
https://registry.yarnpkg.com/@types/d3-shape/-/d3-shape-1.3.2.tgz -> yarnpkg-@types-d3-shape-1.3.2.tgz
https://registry.yarnpkg.com/@types/d3-time-format/-/d3-time-format-2.1.1.tgz -> yarnpkg-@types-d3-time-format-2.1.1.tgz
https://registry.yarnpkg.com/@types/d3-time/-/d3-time-1.0.10.tgz -> yarnpkg-@types-d3-time-1.0.10.tgz
https://registry.yarnpkg.com/@types/d3-timer/-/d3-timer-1.0.9.tgz -> yarnpkg-@types-d3-timer-1.0.9.tgz
https://registry.yarnpkg.com/@types/d3-transition/-/d3-transition-1.1.6.tgz -> yarnpkg-@types-d3-transition-1.1.6.tgz
https://registry.yarnpkg.com/@types/d3-voronoi/-/d3-voronoi-1.1.9.tgz -> yarnpkg-@types-d3-voronoi-1.1.9.tgz
https://registry.yarnpkg.com/@types/d3-zoom/-/d3-zoom-1.7.4.tgz -> yarnpkg-@types-d3-zoom-1.7.4.tgz
https://registry.yarnpkg.com/@types/d3/-/d3-4.13.2.tgz -> yarnpkg-@types-d3-4.13.2.tgz
https://registry.yarnpkg.com/@types/d3/-/d3-5.7.2.tgz -> yarnpkg-@types-d3-5.7.2.tgz
https://registry.yarnpkg.com/@types/eslint-scope/-/eslint-scope-3.7.4.tgz -> yarnpkg-@types-eslint-scope-3.7.4.tgz
https://registry.yarnpkg.com/@types/eslint/-/eslint-8.4.10.tgz -> yarnpkg-@types-eslint-8.4.10.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-0.0.51.tgz -> yarnpkg-@types-estree-0.0.51.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.0.tgz -> yarnpkg-@types-estree-1.0.0.tgz
https://registry.yarnpkg.com/@types/express-serve-static-core/-/express-serve-static-core-4.17.31.tgz -> yarnpkg-@types-express-serve-static-core-4.17.31.tgz
https://registry.yarnpkg.com/@types/express/-/express-4.17.14.tgz -> yarnpkg-@types-express-4.17.14.tgz
https://registry.yarnpkg.com/@types/geojson/-/geojson-7946.0.7.tgz -> yarnpkg-@types-geojson-7946.0.7.tgz
https://registry.yarnpkg.com/@types/http-proxy/-/http-proxy-1.17.9.tgz -> yarnpkg-@types-http-proxy-1.17.9.tgz
https://registry.yarnpkg.com/@types/is-plain-object/-/is-plain-object-0.0.2.tgz -> yarnpkg-@types-is-plain-object-0.0.2.tgz
https://registry.yarnpkg.com/@types/is-windows/-/is-windows-1.0.0.tgz -> yarnpkg-@types-is-windows-1.0.0.tgz
https://registry.yarnpkg.com/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.3.tgz -> yarnpkg-@types-istanbul-lib-coverage-2.0.3.tgz
https://registry.yarnpkg.com/@types/jasmine/-/jasmine-3.8.2.tgz -> yarnpkg-@types-jasmine-3.8.2.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz -> yarnpkg-@types-json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.172.tgz -> yarnpkg-@types-lodash-4.14.172.tgz
https://registry.yarnpkg.com/@types/long/-/long-4.0.1.tgz -> yarnpkg-@types-long-4.0.1.tgz
https://registry.yarnpkg.com/@types/marked/-/marked-2.0.4.tgz -> yarnpkg-@types-marked-2.0.4.tgz
https://registry.yarnpkg.com/@types/micromatch/-/micromatch-2.3.31.tgz -> yarnpkg-@types-micromatch-2.3.31.tgz
https://registry.yarnpkg.com/@types/mime/-/mime-1.3.2.tgz -> yarnpkg-@types-mime-1.3.2.tgz
https://registry.yarnpkg.com/@types/mime/-/mime-3.0.1.tgz -> yarnpkg-@types-mime-3.0.1.tgz
https://registry.yarnpkg.com/@types/node-fetch/-/node-fetch-2.5.10.tgz -> yarnpkg-@types-node-fetch-2.5.10.tgz
https://registry.yarnpkg.com/@types/node/-/node-10.17.60.tgz -> yarnpkg-@types-node-10.17.60.tgz
https://registry.yarnpkg.com/@types/node/-/node-12.20.24.tgz -> yarnpkg-@types-node-12.20.24.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.10.9.tgz -> yarnpkg-@types-node-16.10.9.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.11.9.tgz -> yarnpkg-@types-node-18.11.9.tgz
https://registry.yarnpkg.com/@types/offscreencanvas/-/offscreencanvas-2019.3.0.tgz -> yarnpkg-@types-offscreencanvas-2019.3.0.tgz
https://registry.yarnpkg.com/@types/offscreencanvas/-/offscreencanvas-2019.6.3.tgz -> yarnpkg-@types-offscreencanvas-2019.6.3.tgz
https://registry.yarnpkg.com/@types/parse-glob/-/parse-glob-3.0.29.tgz -> yarnpkg-@types-parse-glob-3.0.29.tgz
https://registry.yarnpkg.com/@types/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-@types-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/@types/q/-/q-0.0.32.tgz -> yarnpkg-@types-q-0.0.32.tgz
https://registry.yarnpkg.com/@types/qs/-/qs-6.9.7.tgz -> yarnpkg-@types-qs-6.9.7.tgz
https://registry.yarnpkg.com/@types/range-parser/-/range-parser-1.2.4.tgz -> yarnpkg-@types-range-parser-1.2.4.tgz
https://registry.yarnpkg.com/@types/requirejs/-/requirejs-2.1.33.tgz -> yarnpkg-@types-requirejs-2.1.33.tgz
https://registry.yarnpkg.com/@types/resize-observer-browser/-/resize-observer-browser-0.1.6.tgz -> yarnpkg-@types-resize-observer-browser-0.1.6.tgz
https://registry.yarnpkg.com/@types/retry/-/retry-0.12.0.tgz -> yarnpkg-@types-retry-0.12.0.tgz
https://registry.yarnpkg.com/@types/seedrandom/-/seedrandom-2.4.27.tgz -> yarnpkg-@types-seedrandom-2.4.27.tgz
https://registry.yarnpkg.com/@types/selenium-webdriver/-/selenium-webdriver-3.0.20.tgz -> yarnpkg-@types-selenium-webdriver-3.0.20.tgz
https://registry.yarnpkg.com/@types/selenium-webdriver/-/selenium-webdriver-4.1.9.tgz -> yarnpkg-@types-selenium-webdriver-4.1.9.tgz
https://registry.yarnpkg.com/@types/send/-/send-0.17.1.tgz -> yarnpkg-@types-send-0.17.1.tgz
https://registry.yarnpkg.com/@types/serve-index/-/serve-index-1.9.1.tgz -> yarnpkg-@types-serve-index-1.9.1.tgz
https://registry.yarnpkg.com/@types/serve-static/-/serve-static-1.15.0.tgz -> yarnpkg-@types-serve-static-1.15.0.tgz
https://registry.yarnpkg.com/@types/sockjs/-/sockjs-0.3.33.tgz -> yarnpkg-@types-sockjs-0.3.33.tgz
https://registry.yarnpkg.com/@types/three/-/three-0.131.0.tgz -> yarnpkg-@types-three-0.131.0.tgz
https://registry.yarnpkg.com/@types/tmp/-/tmp-0.2.3.tgz -> yarnpkg-@types-tmp-0.2.3.tgz
https://registry.yarnpkg.com/@types/uuid/-/uuid-8.3.4.tgz -> yarnpkg-@types-uuid-8.3.4.tgz
https://registry.yarnpkg.com/@types/webgl-ext/-/webgl-ext-0.0.30.tgz -> yarnpkg-@types-webgl-ext-0.0.30.tgz
https://registry.yarnpkg.com/@types/webgl2/-/webgl2-0.0.5.tgz -> yarnpkg-@types-webgl2-0.0.5.tgz
https://registry.yarnpkg.com/@types/webgl2/-/webgl2-0.0.6.tgz -> yarnpkg-@types-webgl2-0.0.6.tgz
https://registry.yarnpkg.com/@types/ws/-/ws-8.5.3.tgz -> yarnpkg-@types-ws-8.5.3.tgz
https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-21.0.0.tgz -> yarnpkg-@types-yargs-parser-21.0.0.tgz
https://registry.yarnpkg.com/@types/yargs/-/yargs-17.0.13.tgz -> yarnpkg-@types-yargs-17.0.13.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-checkbox/-/vaadin-checkbox-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-checkbox-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-control-state-mixin/-/vaadin-control-state-mixin-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-control-state-mixin-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-development-mode-detector/-/vaadin-development-mode-detector-2.0.4.tgz -> yarnpkg-@vaadin-vaadin-development-mode-detector-2.0.4.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-element-mixin/-/vaadin-element-mixin-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-element-mixin-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-grid/-/vaadin-grid-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-grid-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-lumo-styles/-/vaadin-lumo-styles-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-lumo-styles-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-material-styles/-/vaadin-material-styles-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-material-styles-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-text-field/-/vaadin-text-field-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-text-field-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-themable-mixin/-/vaadin-themable-mixin-20.0.2.tgz -> yarnpkg-@vaadin-vaadin-themable-mixin-20.0.2.tgz
https://registry.yarnpkg.com/@vaadin/vaadin-usage-statistics/-/vaadin-usage-statistics-2.1.0.tgz -> yarnpkg-@vaadin-vaadin-usage-statistics-2.1.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.11.1.tgz -> yarnpkg-@webassemblyjs-ast-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.1.tgz -> yarnpkg-@webassemblyjs-floating-point-hex-parser-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-api-error-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-buffer-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-numbers-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-wasm-bytecode-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.1.tgz -> yarnpkg-@webassemblyjs-helper-wasm-section-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.11.1.tgz -> yarnpkg-@webassemblyjs-ieee754-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.11.1.tgz -> yarnpkg-@webassemblyjs-leb128-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.11.1.tgz -> yarnpkg-@webassemblyjs-utf8-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-edit-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-gen-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-opt-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.1.tgz -> yarnpkg-@webassemblyjs-wasm-parser-1.11.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.11.1.tgz -> yarnpkg-@webassemblyjs-wast-printer-1.11.1.tgz
https://registry.yarnpkg.com/@webcomponents/shadycss/-/shadycss-1.10.2.tgz -> yarnpkg-@webcomponents-shadycss-1.10.2.tgz
https://registry.yarnpkg.com/@xmldom/xmldom/-/xmldom-0.7.5.tgz -> yarnpkg-@xmldom-xmldom-0.7.5.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> yarnpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> yarnpkg-@xtuc-long-4.2.2.tgz
https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> yarnpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.yarnpkg.com/abab/-/abab-2.0.6.tgz -> yarnpkg-abab-2.0.6.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/accepts/-/accepts-1.3.8.tgz -> yarnpkg-accepts-1.3.8.tgz
https://registry.yarnpkg.com/acorn-import-assertions/-/acorn-import-assertions-1.8.0.tgz -> yarnpkg-acorn-import-assertions-1.8.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.8.1.tgz -> yarnpkg-acorn-8.8.1.tgz
https://registry.yarnpkg.com/adjust-sourcemap-loader/-/adjust-sourcemap-loader-4.0.0.tgz -> yarnpkg-adjust-sourcemap-loader-4.0.0.tgz
https://registry.yarnpkg.com/adm-zip/-/adm-zip-0.4.16.tgz -> yarnpkg-adm-zip-0.4.16.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-4.3.0.tgz -> yarnpkg-agent-base-4.3.0.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/agentkeepalive/-/agentkeepalive-4.2.1.tgz -> yarnpkg-agentkeepalive-4.2.1.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv-formats/-/ajv-formats-2.1.1.tgz -> yarnpkg-ajv-formats-2.1.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> yarnpkg-ajv-keywords-5.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.11.0.tgz -> yarnpkg-ajv-8.11.0.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.3.tgz -> yarnpkg-ansi-colors-4.1.3.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> yarnpkg-ansi-escapes-4.3.2.tgz
https://registry.yarnpkg.com/ansi-html-community/-/ansi-html-community-0.0.8.tgz -> yarnpkg-ansi-html-community-0.0.8.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz -> yarnpkg-ansi-styles-2.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz -> yarnpkg-anymatch-3.1.2.tgz
https://registry.yarnpkg.com/aproba/-/aproba-2.0.0.tgz -> yarnpkg-aproba-2.0.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-3.0.0.tgz -> yarnpkg-are-we-there-yet-3.0.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz -> yarnpkg-array-flatten-1.1.1.tgz
https://registry.yarnpkg.com/array-flatten/-/array-flatten-2.1.2.tgz -> yarnpkg-array-flatten-2.1.2.tgz
https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz -> yarnpkg-array-union-1.0.2.tgz
https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz -> yarnpkg-array-uniq-1.0.3.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz -> yarnpkg-arrify-1.0.1.tgz
https://registry.yarnpkg.com/asn1/-/asn1-0.2.6.tgz -> yarnpkg-asn1-0.2.6.tgz
https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz -> yarnpkg-assert-plus-1.0.0.tgz
https://registry.yarnpkg.com/async-each-series/-/async-each-series-0.1.1.tgz -> yarnpkg-async-each-series-0.1.1.tgz
https://registry.yarnpkg.com/async/-/async-2.6.4.tgz -> yarnpkg-async-2.6.4.tgz
https://registry.yarnpkg.com/async/-/async-3.2.4.tgz -> yarnpkg-async-3.2.4.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-10.4.13.tgz -> yarnpkg-autoprefixer-10.4.13.tgz
https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz -> yarnpkg-aws-sign2-0.7.0.tgz
https://registry.yarnpkg.com/aws4/-/aws4-1.11.0.tgz -> yarnpkg-aws4-1.11.0.tgz
https://registry.yarnpkg.com/axios/-/axios-0.21.4.tgz -> yarnpkg-axios-0.21.4.tgz
https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.2.5.tgz -> yarnpkg-babel-loader-8.2.5.tgz
https://registry.yarnpkg.com/babel-loader/-/babel-loader-9.0.1.tgz -> yarnpkg-babel-loader-9.0.1.tgz
https://registry.yarnpkg.com/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> yarnpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.3.tgz -> yarnpkg-babel-plugin-polyfill-corejs2-0.3.3.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.5.3.tgz -> yarnpkg-babel-plugin-polyfill-corejs3-0.5.3.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.6.0.tgz -> yarnpkg-babel-plugin-polyfill-corejs3-0.6.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.4.1.tgz -> yarnpkg-babel-plugin-polyfill-regenerator-0.4.1.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/base64id/-/base64id-2.0.0.tgz -> yarnpkg-base64id-2.0.0.tgz
https://registry.yarnpkg.com/batch/-/batch-0.6.1.tgz -> yarnpkg-batch-0.6.1.tgz
https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> yarnpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz -> yarnpkg-big.js-5.2.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/bl/-/bl-4.1.0.tgz -> yarnpkg-bl-4.1.0.tgz
https://registry.yarnpkg.com/blocking-proxy/-/blocking-proxy-1.0.1.tgz -> yarnpkg-blocking-proxy-1.0.1.tgz
https://registry.yarnpkg.com/body-parser/-/body-parser-1.20.1.tgz -> yarnpkg-body-parser-1.20.1.tgz
https://registry.yarnpkg.com/bonjour-service/-/bonjour-service-1.0.14.tgz -> yarnpkg-bonjour-service-1.0.14.tgz
https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz -> yarnpkg-boolbase-1.0.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/browser-sync-client/-/browser-sync-client-2.27.10.tgz -> yarnpkg-browser-sync-client-2.27.10.tgz
https://registry.yarnpkg.com/browser-sync-ui/-/browser-sync-ui-2.27.10.tgz -> yarnpkg-browser-sync-ui-2.27.10.tgz
https://registry.yarnpkg.com/browser-sync/-/browser-sync-2.27.10.tgz -> yarnpkg-browser-sync-2.27.10.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.21.4.tgz -> yarnpkg-browserslist-4.21.4.tgz
https://registry.yarnpkg.com/browserstack/-/browserstack-1.6.1.tgz -> yarnpkg-browserstack-1.6.1.tgz
https://registry.yarnpkg.com/bs-recipes/-/bs-recipes-1.3.4.tgz -> yarnpkg-bs-recipes-1.3.4.tgz
https://registry.yarnpkg.com/bs-snippet-injector/-/bs-snippet-injector-2.0.1.tgz -> yarnpkg-bs-snippet-injector-2.0.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz -> yarnpkg-buffer-from-1.1.1.tgz
https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz -> yarnpkg-buffer-5.7.1.tgz
https://registry.yarnpkg.com/builtins/-/builtins-5.0.1.tgz -> yarnpkg-builtins-5.0.1.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.0.0.tgz -> yarnpkg-bytes-3.0.0.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.2.tgz -> yarnpkg-bytes-3.1.2.tgz
https://registry.yarnpkg.com/c8/-/c8-7.5.0.tgz -> yarnpkg-c8-7.5.0.tgz
https://registry.yarnpkg.com/cacache/-/cacache-16.1.2.tgz -> yarnpkg-cacache-16.1.2.tgz
https://registry.yarnpkg.com/cacache/-/cacache-16.1.3.tgz -> yarnpkg-cacache-16.1.3.tgz
https://registry.yarnpkg.com/cacache/-/cacache-17.0.1.tgz -> yarnpkg-cacache-17.0.1.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001431.tgz -> yarnpkg-caniuse-lite-1.0.30001431.tgz
https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz -> yarnpkg-caseless-0.12.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz -> yarnpkg-chalk-1.1.3.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz -> yarnpkg-chownr-2.0.0.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> yarnpkg-chrome-trace-event-1.0.3.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/clang-format/-/clang-format-1.8.0.tgz -> yarnpkg-clang-format-1.8.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-3.1.0.tgz -> yarnpkg-cli-cursor-3.1.0.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.6.1.tgz -> yarnpkg-cli-spinners-2.6.1.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-3.0.0.tgz -> yarnpkg-cli-width-3.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz -> yarnpkg-cliui-6.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/cliui/-/cliui-8.0.1.tgz -> yarnpkg-cliui-8.0.1.tgz
https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz -> yarnpkg-clone-deep-4.0.1.tgz
https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz -> yarnpkg-clone-1.0.4.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/colorette/-/colorette-2.0.19.tgz -> yarnpkg-colorette-2.0.19.tgz
https://registry.yarnpkg.com/colors/-/colors-1.2.5.tgz -> yarnpkg-colors-1.2.5.tgz
https://registry.yarnpkg.com/colors/-/colors-1.4.0.tgz -> yarnpkg-colors-1.4.0.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-9.3.0.tgz -> yarnpkg-commander-9.3.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/compressible/-/compressible-2.0.18.tgz -> yarnpkg-compressible-2.0.18.tgz
https://registry.yarnpkg.com/compression/-/compression-1.7.4.tgz -> yarnpkg-compression-1.7.4.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz -> yarnpkg-connect-history-api-fallback-1.6.0.tgz
https://registry.yarnpkg.com/connect-history-api-fallback/-/connect-history-api-fallback-2.0.0.tgz -> yarnpkg-connect-history-api-fallback-2.0.0.tgz
https://registry.yarnpkg.com/connect/-/connect-3.6.6.tgz -> yarnpkg-connect-3.6.6.tgz
https://registry.yarnpkg.com/connect/-/connect-3.7.0.tgz -> yarnpkg-connect-3.7.0.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.4.tgz -> yarnpkg-content-disposition-0.5.4.tgz
https://registry.yarnpkg.com/content-type/-/content-type-1.0.4.tgz -> yarnpkg-content-type-1.0.4.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.8.0.tgz -> yarnpkg-convert-source-map-1.8.0.tgz
https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz -> yarnpkg-cookie-signature-1.0.6.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.4.2.tgz -> yarnpkg-cookie-0.4.2.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.5.0.tgz -> yarnpkg-cookie-0.5.0.tgz
https://registry.yarnpkg.com/copy-anything/-/copy-anything-2.0.6.tgz -> yarnpkg-copy-anything-2.0.6.tgz
https://registry.yarnpkg.com/copy-webpack-plugin/-/copy-webpack-plugin-11.0.0.tgz -> yarnpkg-copy-webpack-plugin-11.0.0.tgz
https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.26.1.tgz -> yarnpkg-core-js-compat-3.26.1.tgz
https://registry.yarnpkg.com/core-js/-/core-js-3.21.1.tgz -> yarnpkg-core-js-3.21.1.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cors/-/cors-2.8.5.tgz -> yarnpkg-cors-2.8.5.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-7.0.1.tgz -> yarnpkg-cosmiconfig-7.0.1.tgz
https://registry.yarnpkg.com/critters/-/critters-0.0.16.tgz -> yarnpkg-critters-0.0.16.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/css-blank-pseudo/-/css-blank-pseudo-3.0.3.tgz -> yarnpkg-css-blank-pseudo-3.0.3.tgz
https://registry.yarnpkg.com/css-has-pseudo/-/css-has-pseudo-3.0.4.tgz -> yarnpkg-css-has-pseudo-3.0.4.tgz
https://registry.yarnpkg.com/css-loader/-/css-loader-6.7.1.tgz -> yarnpkg-css-loader-6.7.1.tgz
https://registry.yarnpkg.com/css-prefers-color-scheme/-/css-prefers-color-scheme-6.0.3.tgz -> yarnpkg-css-prefers-color-scheme-6.0.3.tgz
https://registry.yarnpkg.com/css-select/-/css-select-4.3.0.tgz -> yarnpkg-css-select-4.3.0.tgz
https://registry.yarnpkg.com/css-what/-/css-what-6.1.0.tgz -> yarnpkg-css-what-6.1.0.tgz
https://registry.yarnpkg.com/cssdb/-/cssdb-7.1.0.tgz -> yarnpkg-cssdb-7.1.0.tgz
https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz -> yarnpkg-cssesc-3.0.0.tgz
https://registry.yarnpkg.com/custom-event/-/custom-event-1.0.1.tgz -> yarnpkg-custom-event-1.0.1.tgz
https://registry.yarnpkg.com/d3-array/-/d3-array-1.2.1.tgz -> yarnpkg-d3-array-1.2.1.tgz
https://registry.yarnpkg.com/d3-array/-/d3-array-1.2.4.tgz -> yarnpkg-d3-array-1.2.4.tgz
https://registry.yarnpkg.com/d3-axis/-/d3-axis-1.0.12.tgz -> yarnpkg-d3-axis-1.0.12.tgz
https://registry.yarnpkg.com/d3-axis/-/d3-axis-1.0.8.tgz -> yarnpkg-d3-axis-1.0.8.tgz
https://registry.yarnpkg.com/d3-brush/-/d3-brush-1.0.4.tgz -> yarnpkg-d3-brush-1.0.4.tgz
https://registry.yarnpkg.com/d3-brush/-/d3-brush-1.1.6.tgz -> yarnpkg-d3-brush-1.1.6.tgz
https://registry.yarnpkg.com/d3-chord/-/d3-chord-1.0.4.tgz -> yarnpkg-d3-chord-1.0.4.tgz
https://registry.yarnpkg.com/d3-chord/-/d3-chord-1.0.6.tgz -> yarnpkg-d3-chord-1.0.6.tgz
https://registry.yarnpkg.com/d3-collection/-/d3-collection-1.0.4.tgz -> yarnpkg-d3-collection-1.0.4.tgz
https://registry.yarnpkg.com/d3-collection/-/d3-collection-1.0.7.tgz -> yarnpkg-d3-collection-1.0.7.tgz
https://registry.yarnpkg.com/d3-color/-/d3-color-1.0.3.tgz -> yarnpkg-d3-color-1.0.3.tgz
https://registry.yarnpkg.com/d3-color/-/d3-color-1.4.1.tgz -> yarnpkg-d3-color-1.4.1.tgz
https://registry.yarnpkg.com/d3-contour/-/d3-contour-1.3.2.tgz -> yarnpkg-d3-contour-1.3.2.tgz
https://registry.yarnpkg.com/d3-dispatch/-/d3-dispatch-1.0.3.tgz -> yarnpkg-d3-dispatch-1.0.3.tgz
https://registry.yarnpkg.com/d3-dispatch/-/d3-dispatch-1.0.6.tgz -> yarnpkg-d3-dispatch-1.0.6.tgz
https://registry.yarnpkg.com/d3-drag/-/d3-drag-1.2.1.tgz -> yarnpkg-d3-drag-1.2.1.tgz
https://registry.yarnpkg.com/d3-drag/-/d3-drag-1.2.5.tgz -> yarnpkg-d3-drag-1.2.5.tgz
https://registry.yarnpkg.com/d3-dsv/-/d3-dsv-1.0.8.tgz -> yarnpkg-d3-dsv-1.0.8.tgz
https://registry.yarnpkg.com/d3-dsv/-/d3-dsv-1.2.0.tgz -> yarnpkg-d3-dsv-1.2.0.tgz
https://registry.yarnpkg.com/d3-ease/-/d3-ease-1.0.3.tgz -> yarnpkg-d3-ease-1.0.3.tgz
https://registry.yarnpkg.com/d3-ease/-/d3-ease-1.0.7.tgz -> yarnpkg-d3-ease-1.0.7.tgz
https://registry.yarnpkg.com/d3-fetch/-/d3-fetch-1.2.0.tgz -> yarnpkg-d3-fetch-1.2.0.tgz
https://registry.yarnpkg.com/d3-force/-/d3-force-1.1.0.tgz -> yarnpkg-d3-force-1.1.0.tgz
https://registry.yarnpkg.com/d3-force/-/d3-force-1.2.1.tgz -> yarnpkg-d3-force-1.2.1.tgz
https://registry.yarnpkg.com/d3-format/-/d3-format-1.2.2.tgz -> yarnpkg-d3-format-1.2.2.tgz
https://registry.yarnpkg.com/d3-format/-/d3-format-1.4.5.tgz -> yarnpkg-d3-format-1.4.5.tgz
https://registry.yarnpkg.com/d3-geo/-/d3-geo-1.12.1.tgz -> yarnpkg-d3-geo-1.12.1.tgz
https://registry.yarnpkg.com/d3-geo/-/d3-geo-1.9.1.tgz -> yarnpkg-d3-geo-1.9.1.tgz
https://registry.yarnpkg.com/d3-hierarchy/-/d3-hierarchy-1.1.5.tgz -> yarnpkg-d3-hierarchy-1.1.5.tgz
https://registry.yarnpkg.com/d3-hierarchy/-/d3-hierarchy-1.1.9.tgz -> yarnpkg-d3-hierarchy-1.1.9.tgz
https://registry.yarnpkg.com/d3-interpolate/-/d3-interpolate-1.1.6.tgz -> yarnpkg-d3-interpolate-1.1.6.tgz
https://registry.yarnpkg.com/d3-interpolate/-/d3-interpolate-1.4.0.tgz -> yarnpkg-d3-interpolate-1.4.0.tgz
https://registry.yarnpkg.com/d3-path/-/d3-path-1.0.5.tgz -> yarnpkg-d3-path-1.0.5.tgz
https://registry.yarnpkg.com/d3-path/-/d3-path-1.0.9.tgz -> yarnpkg-d3-path-1.0.9.tgz
https://registry.yarnpkg.com/d3-polygon/-/d3-polygon-1.0.3.tgz -> yarnpkg-d3-polygon-1.0.3.tgz
https://registry.yarnpkg.com/d3-polygon/-/d3-polygon-1.0.6.tgz -> yarnpkg-d3-polygon-1.0.6.tgz
https://registry.yarnpkg.com/d3-quadtree/-/d3-quadtree-1.0.3.tgz -> yarnpkg-d3-quadtree-1.0.3.tgz
https://registry.yarnpkg.com/d3-quadtree/-/d3-quadtree-1.0.7.tgz -> yarnpkg-d3-quadtree-1.0.7.tgz
https://registry.yarnpkg.com/d3-queue/-/d3-queue-3.0.7.tgz -> yarnpkg-d3-queue-3.0.7.tgz
https://registry.yarnpkg.com/d3-random/-/d3-random-1.1.0.tgz -> yarnpkg-d3-random-1.1.0.tgz
https://registry.yarnpkg.com/d3-random/-/d3-random-1.1.2.tgz -> yarnpkg-d3-random-1.1.2.tgz
https://registry.yarnpkg.com/d3-request/-/d3-request-1.0.6.tgz -> yarnpkg-d3-request-1.0.6.tgz
https://registry.yarnpkg.com/d3-scale-chromatic/-/d3-scale-chromatic-1.5.0.tgz -> yarnpkg-d3-scale-chromatic-1.5.0.tgz
https://registry.yarnpkg.com/d3-scale/-/d3-scale-1.0.7.tgz -> yarnpkg-d3-scale-1.0.7.tgz
https://registry.yarnpkg.com/d3-scale/-/d3-scale-2.2.2.tgz -> yarnpkg-d3-scale-2.2.2.tgz
https://registry.yarnpkg.com/d3-selection/-/d3-selection-1.3.0.tgz -> yarnpkg-d3-selection-1.3.0.tgz
https://registry.yarnpkg.com/d3-selection/-/d3-selection-1.4.2.tgz -> yarnpkg-d3-selection-1.4.2.tgz
https://registry.yarnpkg.com/d3-shape/-/d3-shape-1.2.0.tgz -> yarnpkg-d3-shape-1.2.0.tgz
https://registry.yarnpkg.com/d3-shape/-/d3-shape-1.3.7.tgz -> yarnpkg-d3-shape-1.3.7.tgz
https://registry.yarnpkg.com/d3-time-format/-/d3-time-format-2.1.1.tgz -> yarnpkg-d3-time-format-2.1.1.tgz
https://registry.yarnpkg.com/d3-time-format/-/d3-time-format-2.3.0.tgz -> yarnpkg-d3-time-format-2.3.0.tgz
https://registry.yarnpkg.com/d3-time/-/d3-time-1.0.8.tgz -> yarnpkg-d3-time-1.0.8.tgz
https://registry.yarnpkg.com/d3-time/-/d3-time-1.1.0.tgz -> yarnpkg-d3-time-1.1.0.tgz
https://registry.yarnpkg.com/d3-timer/-/d3-timer-1.0.10.tgz -> yarnpkg-d3-timer-1.0.10.tgz
https://registry.yarnpkg.com/d3-timer/-/d3-timer-1.0.7.tgz -> yarnpkg-d3-timer-1.0.7.tgz
https://registry.yarnpkg.com/d3-transition/-/d3-transition-1.1.1.tgz -> yarnpkg-d3-transition-1.1.1.tgz
https://registry.yarnpkg.com/d3-transition/-/d3-transition-1.3.2.tgz -> yarnpkg-d3-transition-1.3.2.tgz
https://registry.yarnpkg.com/d3-voronoi/-/d3-voronoi-1.1.2.tgz -> yarnpkg-d3-voronoi-1.1.2.tgz
https://registry.yarnpkg.com/d3-voronoi/-/d3-voronoi-1.1.4.tgz -> yarnpkg-d3-voronoi-1.1.4.tgz
https://registry.yarnpkg.com/d3-zoom/-/d3-zoom-1.7.1.tgz -> yarnpkg-d3-zoom-1.7.1.tgz
https://registry.yarnpkg.com/d3-zoom/-/d3-zoom-1.8.3.tgz -> yarnpkg-d3-zoom-1.8.3.tgz
https://registry.yarnpkg.com/d3/-/d3-4.13.0.tgz -> yarnpkg-d3-4.13.0.tgz
https://registry.yarnpkg.com/d3/-/d3-5.7.0.tgz -> yarnpkg-d3-5.7.0.tgz
https://registry.yarnpkg.com/dagre/-/dagre-0.8.5.tgz -> yarnpkg-dagre-0.8.5.tgz
https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz -> yarnpkg-dashdash-1.14.1.tgz
https://registry.yarnpkg.com/date-format/-/date-format-4.0.3.tgz -> yarnpkg-date-format-4.0.3.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.2.tgz -> yarnpkg-debug-4.3.2.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/default-gateway/-/default-gateway-6.0.3.tgz -> yarnpkg-default-gateway-6.0.3.tgz
https://registry.yarnpkg.com/defaults/-/defaults-1.0.3.tgz -> yarnpkg-defaults-1.0.3.tgz
https://registry.yarnpkg.com/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> yarnpkg-define-lazy-prop-2.0.0.tgz
https://registry.yarnpkg.com/del/-/del-2.2.2.tgz -> yarnpkg-del-2.2.2.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz -> yarnpkg-depd-1.1.2.tgz
https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz -> yarnpkg-depd-2.0.0.tgz
https://registry.yarnpkg.com/dependency-graph/-/dependency-graph-0.11.0.tgz -> yarnpkg-dependency-graph-0.11.0.tgz
https://registry.yarnpkg.com/destroy/-/destroy-1.0.4.tgz -> yarnpkg-destroy-1.0.4.tgz
https://registry.yarnpkg.com/destroy/-/destroy-1.2.0.tgz -> yarnpkg-destroy-1.2.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/dev-ip/-/dev-ip-1.0.1.tgz -> yarnpkg-dev-ip-1.0.1.tgz
https://registry.yarnpkg.com/di/-/di-0.0.1.tgz -> yarnpkg-di-0.0.1.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/dlv/-/dlv-1.1.3.tgz -> yarnpkg-dlv-1.1.3.tgz
https://registry.yarnpkg.com/dns-equal/-/dns-equal-1.0.0.tgz -> yarnpkg-dns-equal-1.0.0.tgz
https://registry.yarnpkg.com/dns-packet/-/dns-packet-5.4.0.tgz -> yarnpkg-dns-packet-5.4.0.tgz
https://registry.yarnpkg.com/dom-serialize/-/dom-serialize-2.2.1.tgz -> yarnpkg-dom-serialize-2.2.1.tgz
https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-1.4.1.tgz -> yarnpkg-dom-serializer-1.4.1.tgz
https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.3.0.tgz -> yarnpkg-domelementtype-2.3.0.tgz
https://registry.yarnpkg.com/domhandler/-/domhandler-4.3.1.tgz -> yarnpkg-domhandler-4.3.1.tgz
https://registry.yarnpkg.com/domutils/-/domutils-2.8.0.tgz -> yarnpkg-domutils-2.8.0.tgz
https://registry.yarnpkg.com/easy-extender/-/easy-extender-2.3.4.tgz -> yarnpkg-easy-extender-2.3.4.tgz
https://registry.yarnpkg.com/eazy-logger/-/eazy-logger-3.1.0.tgz -> yarnpkg-eazy-logger-3.1.0.tgz
https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> yarnpkg-ecc-jsbn-0.1.2.tgz
https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz -> yarnpkg-ee-first-1.1.1.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.284.tgz -> yarnpkg-electron-to-chromium-1.4.284.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz -> yarnpkg-emojis-list-3.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/encoding/-/encoding-0.1.13.tgz -> yarnpkg-encoding-0.1.13.tgz
https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-6.2.3.tgz -> yarnpkg-engine.io-client-6.2.3.tgz
https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-5.0.4.tgz -> yarnpkg-engine.io-parser-5.0.4.tgz
https://registry.yarnpkg.com/engine.io/-/engine.io-6.2.1.tgz -> yarnpkg-engine.io-6.2.1.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.10.0.tgz -> yarnpkg-enhanced-resolve-5.10.0.tgz
https://registry.yarnpkg.com/ent/-/ent-2.2.0.tgz -> yarnpkg-ent-2.2.0.tgz
https://registry.yarnpkg.com/entities/-/entities-2.2.0.tgz -> yarnpkg-entities-2.2.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/err-code/-/err-code-2.0.3.tgz -> yarnpkg-err-code-2.0.3.tgz
https://registry.yarnpkg.com/errno/-/errno-0.1.8.tgz -> yarnpkg-errno-0.1.8.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-module-lexer/-/es-module-lexer-0.9.3.tgz -> yarnpkg-es-module-lexer-0.9.3.tgz
https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.8.tgz -> yarnpkg-es6-promise-4.2.8.tgz
https://registry.yarnpkg.com/es6-promisify/-/es6-promisify-5.0.0.tgz -> yarnpkg-es6-promisify-5.0.0.tgz
https://registry.yarnpkg.com/esbuild-android-64/-/esbuild-android-64-0.15.12.tgz -> yarnpkg-esbuild-android-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-android-64/-/esbuild-android-64-0.15.5.tgz -> yarnpkg-esbuild-android-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-android-arm64/-/esbuild-android-arm64-0.15.12.tgz -> yarnpkg-esbuild-android-arm64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-android-arm64/-/esbuild-android-arm64-0.15.5.tgz -> yarnpkg-esbuild-android-arm64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-darwin-64/-/esbuild-darwin-64-0.15.12.tgz -> yarnpkg-esbuild-darwin-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-darwin-64/-/esbuild-darwin-64-0.15.5.tgz -> yarnpkg-esbuild-darwin-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-darwin-arm64/-/esbuild-darwin-arm64-0.15.12.tgz -> yarnpkg-esbuild-darwin-arm64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-darwin-arm64/-/esbuild-darwin-arm64-0.15.5.tgz -> yarnpkg-esbuild-darwin-arm64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-freebsd-64/-/esbuild-freebsd-64-0.15.12.tgz -> yarnpkg-esbuild-freebsd-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-freebsd-64/-/esbuild-freebsd-64-0.15.5.tgz -> yarnpkg-esbuild-freebsd-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-freebsd-arm64/-/esbuild-freebsd-arm64-0.15.12.tgz -> yarnpkg-esbuild-freebsd-arm64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-freebsd-arm64/-/esbuild-freebsd-arm64-0.15.5.tgz -> yarnpkg-esbuild-freebsd-arm64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-32/-/esbuild-linux-32-0.15.12.tgz -> yarnpkg-esbuild-linux-32-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-32/-/esbuild-linux-32-0.15.5.tgz -> yarnpkg-esbuild-linux-32-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-64/-/esbuild-linux-64-0.15.12.tgz -> yarnpkg-esbuild-linux-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-64/-/esbuild-linux-64-0.15.5.tgz -> yarnpkg-esbuild-linux-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-arm/-/esbuild-linux-arm-0.15.12.tgz -> yarnpkg-esbuild-linux-arm-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-arm/-/esbuild-linux-arm-0.15.5.tgz -> yarnpkg-esbuild-linux-arm-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-arm64/-/esbuild-linux-arm64-0.15.12.tgz -> yarnpkg-esbuild-linux-arm64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-arm64/-/esbuild-linux-arm64-0.15.5.tgz -> yarnpkg-esbuild-linux-arm64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-mips64le/-/esbuild-linux-mips64le-0.15.12.tgz -> yarnpkg-esbuild-linux-mips64le-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-mips64le/-/esbuild-linux-mips64le-0.15.5.tgz -> yarnpkg-esbuild-linux-mips64le-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-ppc64le/-/esbuild-linux-ppc64le-0.15.12.tgz -> yarnpkg-esbuild-linux-ppc64le-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-ppc64le/-/esbuild-linux-ppc64le-0.15.5.tgz -> yarnpkg-esbuild-linux-ppc64le-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-riscv64/-/esbuild-linux-riscv64-0.15.12.tgz -> yarnpkg-esbuild-linux-riscv64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-riscv64/-/esbuild-linux-riscv64-0.15.5.tgz -> yarnpkg-esbuild-linux-riscv64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-linux-s390x/-/esbuild-linux-s390x-0.15.12.tgz -> yarnpkg-esbuild-linux-s390x-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-linux-s390x/-/esbuild-linux-s390x-0.15.5.tgz -> yarnpkg-esbuild-linux-s390x-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-netbsd-64/-/esbuild-netbsd-64-0.15.12.tgz -> yarnpkg-esbuild-netbsd-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-netbsd-64/-/esbuild-netbsd-64-0.15.5.tgz -> yarnpkg-esbuild-netbsd-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-openbsd-64/-/esbuild-openbsd-64-0.15.12.tgz -> yarnpkg-esbuild-openbsd-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-openbsd-64/-/esbuild-openbsd-64-0.15.5.tgz -> yarnpkg-esbuild-openbsd-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-sunos-64/-/esbuild-sunos-64-0.15.12.tgz -> yarnpkg-esbuild-sunos-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-sunos-64/-/esbuild-sunos-64-0.15.5.tgz -> yarnpkg-esbuild-sunos-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-wasm/-/esbuild-wasm-0.15.12.tgz -> yarnpkg-esbuild-wasm-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-wasm/-/esbuild-wasm-0.15.5.tgz -> yarnpkg-esbuild-wasm-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-windows-32/-/esbuild-windows-32-0.15.12.tgz -> yarnpkg-esbuild-windows-32-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-windows-32/-/esbuild-windows-32-0.15.5.tgz -> yarnpkg-esbuild-windows-32-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-windows-64/-/esbuild-windows-64-0.15.12.tgz -> yarnpkg-esbuild-windows-64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-windows-64/-/esbuild-windows-64-0.15.5.tgz -> yarnpkg-esbuild-windows-64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild-windows-arm64/-/esbuild-windows-arm64-0.15.12.tgz -> yarnpkg-esbuild-windows-arm64-0.15.12.tgz
https://registry.yarnpkg.com/esbuild-windows-arm64/-/esbuild-windows-arm64-0.15.5.tgz -> yarnpkg-esbuild-windows-arm64-0.15.5.tgz
https://registry.yarnpkg.com/esbuild/-/esbuild-0.15.12.tgz -> yarnpkg-esbuild-0.15.12.tgz
https://registry.yarnpkg.com/esbuild/-/esbuild-0.15.5.tgz -> yarnpkg-esbuild-0.15.5.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz -> yarnpkg-escape-html-1.0.3.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz -> yarnpkg-etag-1.8.1.tgz
https://registry.yarnpkg.com/eventemitter-asyncresource/-/eventemitter-asyncresource-1.0.0.tgz -> yarnpkg-eventemitter-asyncresource-1.0.0.tgz
https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.7.tgz -> yarnpkg-eventemitter3-4.0.7.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz -> yarnpkg-events-3.3.0.tgz
https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz -> yarnpkg-execa-5.1.1.tgz
https://registry.yarnpkg.com/exit/-/exit-0.1.2.tgz -> yarnpkg-exit-0.1.2.tgz
https://registry.yarnpkg.com/express/-/express-4.18.2.tgz -> yarnpkg-express-4.18.2.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz -> yarnpkg-extsprintf-1.3.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.1.tgz -> yarnpkg-extsprintf-1.4.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz -> yarnpkg-fast-glob-3.2.12.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.13.0.tgz -> yarnpkg-fastq-1.13.0.tgz
https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.11.4.tgz -> yarnpkg-faye-websocket-0.11.4.tgz
https://registry.yarnpkg.com/figures/-/figures-3.2.0.tgz -> yarnpkg-figures-3.2.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.0.tgz -> yarnpkg-finalhandler-1.1.0.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.2.tgz -> yarnpkg-finalhandler-1.1.2.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.2.0.tgz -> yarnpkg-finalhandler-1.2.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> yarnpkg-find-cache-dir-3.3.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> yarnpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.4.tgz -> yarnpkg-flatted-3.2.4.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.2.tgz -> yarnpkg-follow-redirects-1.15.2.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-2.0.0.tgz -> yarnpkg-foreground-child-2.0.0.tgz
https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz -> yarnpkg-forever-agent-0.6.1.tgz
https://registry.yarnpkg.com/form-data/-/form-data-2.3.3.tgz -> yarnpkg-form-data-2.3.3.tgz
https://registry.yarnpkg.com/form-data/-/form-data-3.0.1.tgz -> yarnpkg-form-data-3.0.1.tgz
https://registry.yarnpkg.com/forwarded/-/forwarded-0.2.0.tgz -> yarnpkg-forwarded-0.2.0.tgz
https://registry.yarnpkg.com/fraction.js/-/fraction.js-4.2.0.tgz -> yarnpkg-fraction.js-4.2.0.tgz
https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz -> yarnpkg-fresh-0.5.2.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.0.0.tgz -> yarnpkg-fs-extra-10.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-3.0.1.tgz -> yarnpkg-fs-extra-3.0.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.1.tgz -> yarnpkg-fs-extra-7.0.1.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz -> yarnpkg-fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs-monkey/-/fs-monkey-1.0.3.tgz -> yarnpkg-fs-monkey-1.0.3.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/furi/-/furi-2.0.0.tgz -> yarnpkg-furi-2.0.0.tgz
https://registry.yarnpkg.com/gauge/-/gauge-4.0.4.tgz -> yarnpkg-gauge-4.0.4.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.3.tgz -> yarnpkg-get-intrinsic-1.1.3.tgz
https://registry.yarnpkg.com/get-package-type/-/get-package-type-0.1.0.tgz -> yarnpkg-get-package-type-0.1.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz -> yarnpkg-get-stream-6.0.1.tgz
https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz -> yarnpkg-getpass-0.1.7.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz -> yarnpkg-glob-parent-6.0.2.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> yarnpkg-glob-to-regexp-0.4.1.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-8.0.3.tgz -> yarnpkg-glob-8.0.3.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globby/-/globby-13.1.2.tgz -> yarnpkg-globby-13.1.2.tgz
https://registry.yarnpkg.com/globby/-/globby-5.0.0.tgz -> yarnpkg-globby-5.0.0.tgz
https://registry.yarnpkg.com/google-protobuf/-/google-protobuf-3.20.0.tgz -> yarnpkg-google-protobuf-3.20.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.10.tgz -> yarnpkg-graceful-fs-4.2.10.tgz
https://registry.yarnpkg.com/graphlib/-/graphlib-2.1.8.tgz -> yarnpkg-graphlib-2.1.8.tgz
https://registry.yarnpkg.com/handle-thing/-/handle-thing-2.0.1.tgz -> yarnpkg-handle-thing-2.0.1.tgz
https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz -> yarnpkg-har-schema-2.0.0.tgz
https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.5.tgz -> yarnpkg-har-validator-5.1.5.tgz
https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz -> yarnpkg-has-ansi-2.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hdr-histogram-js/-/hdr-histogram-js-2.0.3.tgz -> yarnpkg-hdr-histogram-js-2.0.3.tgz
https://registry.yarnpkg.com/hdr-histogram-percentiles-obj/-/hdr-histogram-percentiles-obj-3.0.0.tgz -> yarnpkg-hdr-histogram-percentiles-obj-3.0.0.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-5.2.1.tgz -> yarnpkg-hosted-git-info-5.2.1.tgz
https://registry.yarnpkg.com/hpack.js/-/hpack.js-2.1.6.tgz -> yarnpkg-hpack.js-2.1.6.tgz
https://registry.yarnpkg.com/html-entities/-/html-entities-2.3.3.tgz -> yarnpkg-html-entities-2.3.3.tgz
https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz -> yarnpkg-html-escaper-2.0.2.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-deceiver/-/http-deceiver-1.2.7.tgz -> yarnpkg-http-deceiver-1.2.7.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.3.tgz -> yarnpkg-http-errors-1.6.3.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-2.0.0.tgz -> yarnpkg-http-errors-2.0.0.tgz
https://registry.yarnpkg.com/http-parser-js/-/http-parser-js-0.5.8.tgz -> yarnpkg-http-parser-js-0.5.8.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> yarnpkg-http-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/http-proxy-middleware/-/http-proxy-middleware-2.0.6.tgz -> yarnpkg-http-proxy-middleware-2.0.6.tgz
https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.1.tgz -> yarnpkg-http-proxy-1.18.1.tgz
https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz -> yarnpkg-http-signature-1.2.0.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-2.2.4.tgz -> yarnpkg-https-proxy-agent-2.2.4.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz -> yarnpkg-human-signals-2.1.0.tgz
https://registry.yarnpkg.com/humanize-ms/-/humanize-ms-1.2.1.tgz -> yarnpkg-humanize-ms-1.2.1.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/icss-utils/-/icss-utils-5.1.0.tgz -> yarnpkg-icss-utils-5.1.0.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-5.0.1.tgz -> yarnpkg-ignore-walk-5.0.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.2.0.tgz -> yarnpkg-ignore-5.2.0.tgz
https://registry.yarnpkg.com/image-size/-/image-size-0.5.5.tgz -> yarnpkg-image-size-0.5.5.tgz
https://registry.yarnpkg.com/immediate/-/immediate-3.0.6.tgz -> yarnpkg-immediate-3.0.6.tgz
https://registry.yarnpkg.com/immutable/-/immutable-3.8.2.tgz -> yarnpkg-immutable-3.8.2.tgz
https://registry.yarnpkg.com/immutable/-/immutable-4.1.0.tgz -> yarnpkg-immutable-4.1.0.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-4.0.0.tgz -> yarnpkg-import-lazy-4.0.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz -> yarnpkg-inherits-2.0.3.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/ini/-/ini-3.0.0.tgz -> yarnpkg-ini-3.0.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-8.2.4.tgz -> yarnpkg-inquirer-8.2.4.tgz
https://registry.yarnpkg.com/ip/-/ip-1.1.8.tgz -> yarnpkg-ip-1.1.8.tgz
https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> yarnpkg-ipaddr.js-1.9.1.tgz
https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-2.0.1.tgz -> yarnpkg-ipaddr.js-2.0.1.tgz
https://registry.yarnpkg.com/is-any-array/-/is-any-array-0.1.1.tgz -> yarnpkg-is-any-array-0.1.1.tgz
https://registry.yarnpkg.com/is-any-array/-/is-any-array-1.0.0.tgz -> yarnpkg-is-any-array-1.0.0.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-docker/-/is-docker-2.2.1.tgz -> yarnpkg-is-docker-2.2.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-interactive/-/is-interactive-1.0.0.tgz -> yarnpkg-is-interactive-1.0.0.tgz
https://registry.yarnpkg.com/is-lambda/-/is-lambda-1.0.1.tgz -> yarnpkg-is-lambda-1.0.1.tgz
https://registry.yarnpkg.com/is-number-like/-/is-number-like-1.0.8.tgz -> yarnpkg-is-number-like-1.0.8.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-1.0.0.tgz -> yarnpkg-is-path-cwd-1.0.0.tgz
https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-1.0.1.tgz -> yarnpkg-is-path-in-cwd-1.0.1.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.1.tgz -> yarnpkg-is-path-inside-1.0.1.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-3.0.0.tgz -> yarnpkg-is-plain-obj-3.0.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-what/-/is-what-3.14.1.tgz -> yarnpkg-is-what-3.14.1.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz -> yarnpkg-is-wsl-1.1.0.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz -> yarnpkg-is-wsl-2.2.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.8.tgz -> yarnpkg-isbinaryfile-4.0.8.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz -> yarnpkg-isstream-0.1.2.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.0.tgz -> yarnpkg-istanbul-lib-coverage-3.2.0.tgz
https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> yarnpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> yarnpkg-istanbul-lib-report-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.0.2.tgz -> yarnpkg-istanbul-reports-3.0.2.tgz
https://registry.yarnpkg.com/jasmine-core/-/jasmine-core-2.8.0.tgz -> yarnpkg-jasmine-core-2.8.0.tgz
https://registry.yarnpkg.com/jasmine-core/-/jasmine-core-3.8.0.tgz -> yarnpkg-jasmine-core-3.8.0.tgz
https://registry.yarnpkg.com/jasmine-reporters/-/jasmine-reporters-2.5.0.tgz -> yarnpkg-jasmine-reporters-2.5.0.tgz
https://registry.yarnpkg.com/jasmine/-/jasmine-2.8.0.tgz -> yarnpkg-jasmine-2.8.0.tgz
https://registry.yarnpkg.com/jasminewd2/-/jasminewd2-2.2.0.tgz -> yarnpkg-jasminewd2-2.2.0.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.5.1.tgz -> yarnpkg-jest-worker-27.5.1.tgz
https://registry.yarnpkg.com/jju/-/jju-1.4.0.tgz -> yarnpkg-jju-1.4.0.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz -> yarnpkg-js-yaml-3.14.1.tgz
https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz -> yarnpkg-jsbn-0.1.1.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-schema/-/json-schema-0.4.0.tgz -> yarnpkg-json-schema-0.4.0.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz -> yarnpkg-json5-2.2.3.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.1.0.tgz -> yarnpkg-jsonc-parser-3.1.0.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.2.0.tgz -> yarnpkg-jsonc-parser-3.2.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-3.0.1.tgz -> yarnpkg-jsonfile-3.0.1.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz -> yarnpkg-jsonparse-1.3.1.tgz
https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.2.tgz -> yarnpkg-jsprim-1.4.2.tgz
https://registry.yarnpkg.com/jszip/-/jszip-3.10.1.tgz -> yarnpkg-jszip-3.10.1.tgz
https://registry.yarnpkg.com/karma-chrome-launcher/-/karma-chrome-launcher-3.1.0.tgz -> yarnpkg-karma-chrome-launcher-3.1.0.tgz
https://registry.yarnpkg.com/karma-firefox-launcher/-/karma-firefox-launcher-2.1.1.tgz -> yarnpkg-karma-firefox-launcher-2.1.1.tgz
https://registry.yarnpkg.com/karma-jasmine/-/karma-jasmine-4.0.1.tgz -> yarnpkg-karma-jasmine-4.0.1.tgz
https://registry.yarnpkg.com/karma-requirejs/-/karma-requirejs-1.1.0.tgz -> yarnpkg-karma-requirejs-1.1.0.tgz
https://registry.yarnpkg.com/karma-source-map-support/-/karma-source-map-support-1.4.0.tgz -> yarnpkg-karma-source-map-support-1.4.0.tgz
https://registry.yarnpkg.com/karma-sourcemap-loader/-/karma-sourcemap-loader-0.3.8.tgz -> yarnpkg-karma-sourcemap-loader-0.3.8.tgz
https://registry.yarnpkg.com/karma/-/karma-6.3.16.tgz -> yarnpkg-karma-6.3.16.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/klaw-sync/-/klaw-sync-6.0.0.tgz -> yarnpkg-klaw-sync-6.0.0.tgz
https://registry.yarnpkg.com/klona/-/klona-2.0.5.tgz -> yarnpkg-klona-2.0.5.tgz
https://registry.yarnpkg.com/less-loader/-/less-loader-11.0.0.tgz -> yarnpkg-less-loader-11.0.0.tgz
https://registry.yarnpkg.com/less-loader/-/less-loader-11.1.0.tgz -> yarnpkg-less-loader-11.1.0.tgz
https://registry.yarnpkg.com/less/-/less-4.1.3.tgz -> yarnpkg-less-4.1.3.tgz
https://registry.yarnpkg.com/license-webpack-plugin/-/license-webpack-plugin-4.0.2.tgz -> yarnpkg-license-webpack-plugin-4.0.2.tgz
https://registry.yarnpkg.com/lie/-/lie-3.3.0.tgz -> yarnpkg-lie-3.3.0.tgz
https://registry.yarnpkg.com/limiter/-/limiter-1.1.5.tgz -> yarnpkg-limiter-1.1.5.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> yarnpkg-lines-and-columns-1.2.4.tgz
https://registry.yarnpkg.com/lit-element/-/lit-element-2.5.1.tgz -> yarnpkg-lit-element-2.5.1.tgz
https://registry.yarnpkg.com/lit-html/-/lit-html-1.4.1.tgz -> yarnpkg-lit-html-1.4.1.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.3.0.tgz -> yarnpkg-loader-runner-4.3.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.4.tgz -> yarnpkg-loader-utils-2.0.4.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-3.2.0.tgz -> yarnpkg-loader-utils-3.2.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-3.2.1.tgz -> yarnpkg-loader-utils-3.2.1.tgz
https://registry.yarnpkg.com/localtunnel/-/localtunnel-2.0.2.tgz -> yarnpkg-localtunnel-2.0.2.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> yarnpkg-lodash.isequal-4.5.0.tgz
https://registry.yarnpkg.com/lodash.isfinite/-/lodash.isfinite-3.3.2.tgz -> yarnpkg-lodash.isfinite-3.3.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/log4js/-/log4js-6.4.1.tgz -> yarnpkg-log4js-6.4.1.tgz
https://registry.yarnpkg.com/long/-/long-4.0.0.tgz -> yarnpkg-long-4.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-7.14.1.tgz -> yarnpkg-lru-cache-7.14.1.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.26.2.tgz -> yarnpkg-magic-string-0.26.2.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.26.7.tgz -> yarnpkg-magic-string-0.26.7.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-2.1.0.tgz -> yarnpkg-make-dir-2.1.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> yarnpkg-make-fetch-happen-10.2.1.tgz
https://registry.yarnpkg.com/marked/-/marked-4.0.10.tgz -> yarnpkg-marked-4.0.10.tgz
https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz -> yarnpkg-media-typer-0.3.0.tgz
https://registry.yarnpkg.com/memfs/-/memfs-3.4.11.tgz -> yarnpkg-memfs-3.4.11.tgz
https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz -> yarnpkg-merge-descriptors-1.0.1.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz -> yarnpkg-methods-1.1.2.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-1.4.1.tgz -> yarnpkg-mime-1.4.1.tgz
https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz -> yarnpkg-mime-1.6.0.tgz
https://registry.yarnpkg.com/mime/-/mime-2.5.2.tgz -> yarnpkg-mime-2.5.2.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/mini-css-extract-plugin/-/mini-css-extract-plugin-2.6.1.tgz -> yarnpkg-mini-css-extract-plugin-2.6.1.tgz
https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> yarnpkg-minimalistic-assert-1.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.0.tgz -> yarnpkg-minimatch-5.1.0.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.7.tgz -> yarnpkg-minimist-1.2.7.tgz
https://registry.yarnpkg.com/minipass-collect/-/minipass-collect-1.0.2.tgz -> yarnpkg-minipass-collect-1.0.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> yarnpkg-minipass-fetch-2.1.2.tgz
https://registry.yarnpkg.com/minipass-flush/-/minipass-flush-1.0.5.tgz -> yarnpkg-minipass-flush-1.0.5.tgz
https://registry.yarnpkg.com/minipass-json-stream/-/minipass-json-stream-1.0.1.tgz -> yarnpkg-minipass-json-stream-1.0.1.tgz
https://registry.yarnpkg.com/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> yarnpkg-minipass-pipeline-1.2.4.tgz
https://registry.yarnpkg.com/minipass-sized/-/minipass-sized-1.0.3.tgz -> yarnpkg-minipass-sized-1.0.3.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.4.tgz -> yarnpkg-minipass-3.3.4.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz -> yarnpkg-minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mitt/-/mitt-1.2.0.tgz -> yarnpkg-mitt-1.2.0.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz -> yarnpkg-mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/ml-array-max/-/ml-array-max-1.2.3.tgz -> yarnpkg-ml-array-max-1.2.3.tgz
https://registry.yarnpkg.com/ml-array-min/-/ml-array-min-1.2.2.tgz -> yarnpkg-ml-array-min-1.2.2.tgz
https://registry.yarnpkg.com/ml-array-rescale/-/ml-array-rescale-1.3.5.tgz -> yarnpkg-ml-array-rescale-1.3.5.tgz
https://registry.yarnpkg.com/ml-levenberg-marquardt/-/ml-levenberg-marquardt-2.1.1.tgz -> yarnpkg-ml-levenberg-marquardt-2.1.1.tgz
https://registry.yarnpkg.com/ml-matrix/-/ml-matrix-6.8.0.tgz -> yarnpkg-ml-matrix-6.8.0.tgz
https://registry.yarnpkg.com/monaco-editor-core/-/monaco-editor-core-0.26.0.tgz -> yarnpkg-monaco-editor-core-0.26.0.tgz
https://registry.yarnpkg.com/monaco-languages/-/monaco-languages-2.6.0.tgz -> yarnpkg-monaco-languages-2.6.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/multicast-dns/-/multicast-dns-7.2.5.tgz -> yarnpkg-multicast-dns-7.2.5.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.8.tgz -> yarnpkg-mute-stream-0.0.8.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.4.tgz -> yarnpkg-nanoid-3.3.4.tgz
https://registry.yarnpkg.com/needle/-/needle-3.1.0.tgz -> yarnpkg-needle-3.1.0.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.3.tgz -> yarnpkg-negotiator-0.6.3.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz -> yarnpkg-neo-async-2.6.2.tgz
https://registry.yarnpkg.com/ngx-color-picker/-/ngx-color-picker-13.0.0.tgz -> yarnpkg-ngx-color-picker-13.0.0.tgz
https://registry.yarnpkg.com/nice-napi/-/nice-napi-1.0.2.tgz -> yarnpkg-nice-napi-1.0.2.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-3.2.1.tgz -> yarnpkg-node-addon-api-3.2.1.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.7.tgz -> yarnpkg-node-fetch-2.6.7.tgz
https://registry.yarnpkg.com/node-forge/-/node-forge-1.3.1.tgz -> yarnpkg-node-forge-1.3.1.tgz
https://registry.yarnpkg.com/node-gyp-build/-/node-gyp-build-4.5.0.tgz -> yarnpkg-node-gyp-build-4.5.0.tgz
https://registry.yarnpkg.com/node-gyp/-/node-gyp-9.3.0.tgz -> yarnpkg-node-gyp-9.3.0.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.6.tgz -> yarnpkg-node-releases-2.0.6.tgz
https://registry.yarnpkg.com/nopt/-/nopt-6.0.0.tgz -> yarnpkg-nopt-6.0.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-4.0.1.tgz -> yarnpkg-normalize-package-data-4.0.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz -> yarnpkg-normalize-range-0.1.2.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.1.2.tgz -> yarnpkg-npm-bundled-1.1.2.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-2.0.1.tgz -> yarnpkg-npm-bundled-2.0.1.tgz
https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-5.0.0.tgz -> yarnpkg-npm-install-checks-5.0.0.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz -> yarnpkg-npm-normalize-package-bin-1.0.1.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-2.0.0.tgz -> yarnpkg-npm-normalize-package-bin-2.0.0.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-9.1.0.tgz -> yarnpkg-npm-package-arg-9.1.0.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-9.1.2.tgz -> yarnpkg-npm-package-arg-9.1.2.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-5.1.3.tgz -> yarnpkg-npm-packlist-5.1.3.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-7.0.1.tgz -> yarnpkg-npm-pick-manifest-7.0.1.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-7.0.2.tgz -> yarnpkg-npm-pick-manifest-7.0.2.tgz
https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-13.3.1.tgz -> yarnpkg-npm-registry-fetch-13.3.1.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-6.0.2.tgz -> yarnpkg-npmlog-6.0.2.tgz
https://registry.yarnpkg.com/nth-check/-/nth-check-2.1.1.tgz -> yarnpkg-nth-check-2.1.1.tgz
https://registry.yarnpkg.com/numeric/-/numeric-1.2.6.tgz -> yarnpkg-numeric-1.2.6.tgz
https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz -> yarnpkg-oauth-sign-0.9.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.2.tgz -> yarnpkg-object-inspect-1.12.2.tgz
https://registry.yarnpkg.com/obuf/-/obuf-1.1.2.tgz -> yarnpkg-obuf-1.1.2.tgz
https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz -> yarnpkg-on-finished-2.3.0.tgz
https://registry.yarnpkg.com/on-finished/-/on-finished-2.4.1.tgz -> yarnpkg-on-finished-2.4.1.tgz
https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.2.tgz -> yarnpkg-on-headers-1.0.2.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/open/-/open-7.4.2.tgz -> yarnpkg-open-7.4.2.tgz
https://registry.yarnpkg.com/open/-/open-8.4.0.tgz -> yarnpkg-open-8.4.0.tgz
https://registry.yarnpkg.com/openurl/-/openurl-1.1.1.tgz -> yarnpkg-openurl-1.1.1.tgz
https://registry.yarnpkg.com/opn/-/opn-5.3.0.tgz -> yarnpkg-opn-5.3.0.tgz
https://registry.yarnpkg.com/ora/-/ora-5.4.1.tgz -> yarnpkg-ora-5.4.1.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/p-retry/-/p-retry-4.6.2.tgz -> yarnpkg-p-retry-4.6.2.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/pacote/-/pacote-13.6.2.tgz -> yarnpkg-pacote-13.6.2.tgz
https://registry.yarnpkg.com/pako/-/pako-1.0.11.tgz -> yarnpkg-pako-1.0.11.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz -> yarnpkg-parse-json-5.2.0.tgz
https://registry.yarnpkg.com/parse-node-version/-/parse-node-version-1.0.1.tgz -> yarnpkg-parse-node-version-1.0.1.tgz
https://registry.yarnpkg.com/parse5-html-rewriting-stream/-/parse5-html-rewriting-stream-6.0.1.tgz -> yarnpkg-parse5-html-rewriting-stream-6.0.1.tgz
https://registry.yarnpkg.com/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-6.0.1.tgz -> yarnpkg-parse5-htmlparser2-tree-adapter-6.0.1.tgz
https://registry.yarnpkg.com/parse5-sax-parser/-/parse5-sax-parser-6.0.1.tgz -> yarnpkg-parse5-sax-parser-6.0.1.tgz
https://registry.yarnpkg.com/parse5/-/parse5-5.1.1.tgz -> yarnpkg-parse5-5.1.1.tgz
https://registry.yarnpkg.com/parse5/-/parse5-6.0.1.tgz -> yarnpkg-parse5-6.0.1.tgz
https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz -> yarnpkg-parseurl-1.3.3.tgz
https://registry.yarnpkg.com/patch-package/-/patch-package-6.4.7.tgz -> yarnpkg-patch-package-6.4.7.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz -> yarnpkg-path-is-inside-1.0.2.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> yarnpkg-path-to-regexp-0.1.7.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz -> yarnpkg-performance-now-2.1.0.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz -> yarnpkg-pify-4.0.1.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/piscina/-/piscina-3.2.0.tgz -> yarnpkg-piscina-3.2.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/plottable/-/plottable-3.9.0.tgz -> yarnpkg-plottable-3.9.0.tgz
https://registry.yarnpkg.com/portscanner/-/portscanner-2.2.0.tgz -> yarnpkg-portscanner-2.2.0.tgz
https://registry.yarnpkg.com/postcss-attribute-case-insensitive/-/postcss-attribute-case-insensitive-5.0.2.tgz -> yarnpkg-postcss-attribute-case-insensitive-5.0.2.tgz
https://registry.yarnpkg.com/postcss-clamp/-/postcss-clamp-4.1.0.tgz -> yarnpkg-postcss-clamp-4.1.0.tgz
https://registry.yarnpkg.com/postcss-color-functional-notation/-/postcss-color-functional-notation-4.2.4.tgz -> yarnpkg-postcss-color-functional-notation-4.2.4.tgz
https://registry.yarnpkg.com/postcss-color-hex-alpha/-/postcss-color-hex-alpha-8.0.4.tgz -> yarnpkg-postcss-color-hex-alpha-8.0.4.tgz
https://registry.yarnpkg.com/postcss-color-rebeccapurple/-/postcss-color-rebeccapurple-7.1.1.tgz -> yarnpkg-postcss-color-rebeccapurple-7.1.1.tgz
https://registry.yarnpkg.com/postcss-custom-media/-/postcss-custom-media-8.0.2.tgz -> yarnpkg-postcss-custom-media-8.0.2.tgz
https://registry.yarnpkg.com/postcss-custom-properties/-/postcss-custom-properties-12.1.10.tgz -> yarnpkg-postcss-custom-properties-12.1.10.tgz
https://registry.yarnpkg.com/postcss-custom-selectors/-/postcss-custom-selectors-6.0.3.tgz -> yarnpkg-postcss-custom-selectors-6.0.3.tgz
https://registry.yarnpkg.com/postcss-dir-pseudo-class/-/postcss-dir-pseudo-class-6.0.5.tgz -> yarnpkg-postcss-dir-pseudo-class-6.0.5.tgz
https://registry.yarnpkg.com/postcss-double-position-gradients/-/postcss-double-position-gradients-3.1.2.tgz -> yarnpkg-postcss-double-position-gradients-3.1.2.tgz
https://registry.yarnpkg.com/postcss-env-function/-/postcss-env-function-4.0.6.tgz -> yarnpkg-postcss-env-function-4.0.6.tgz
https://registry.yarnpkg.com/postcss-focus-visible/-/postcss-focus-visible-6.0.4.tgz -> yarnpkg-postcss-focus-visible-6.0.4.tgz
https://registry.yarnpkg.com/postcss-focus-within/-/postcss-focus-within-5.0.4.tgz -> yarnpkg-postcss-focus-within-5.0.4.tgz
https://registry.yarnpkg.com/postcss-font-variant/-/postcss-font-variant-5.0.0.tgz -> yarnpkg-postcss-font-variant-5.0.0.tgz
https://registry.yarnpkg.com/postcss-gap-properties/-/postcss-gap-properties-3.0.5.tgz -> yarnpkg-postcss-gap-properties-3.0.5.tgz
https://registry.yarnpkg.com/postcss-image-set-function/-/postcss-image-set-function-4.0.7.tgz -> yarnpkg-postcss-image-set-function-4.0.7.tgz
https://registry.yarnpkg.com/postcss-import/-/postcss-import-15.0.0.tgz -> yarnpkg-postcss-import-15.0.0.tgz
https://registry.yarnpkg.com/postcss-initial/-/postcss-initial-4.0.1.tgz -> yarnpkg-postcss-initial-4.0.1.tgz
https://registry.yarnpkg.com/postcss-lab-function/-/postcss-lab-function-4.2.1.tgz -> yarnpkg-postcss-lab-function-4.2.1.tgz
https://registry.yarnpkg.com/postcss-loader/-/postcss-loader-7.0.1.tgz -> yarnpkg-postcss-loader-7.0.1.tgz
https://registry.yarnpkg.com/postcss-logical/-/postcss-logical-5.0.4.tgz -> yarnpkg-postcss-logical-5.0.4.tgz
https://registry.yarnpkg.com/postcss-media-minmax/-/postcss-media-minmax-5.0.0.tgz -> yarnpkg-postcss-media-minmax-5.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz -> yarnpkg-postcss-modules-extract-imports-3.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.0.tgz -> yarnpkg-postcss-modules-local-by-default-4.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-3.0.0.tgz -> yarnpkg-postcss-modules-scope-3.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> yarnpkg-postcss-modules-values-4.0.0.tgz
https://registry.yarnpkg.com/postcss-nesting/-/postcss-nesting-10.2.0.tgz -> yarnpkg-postcss-nesting-10.2.0.tgz
https://registry.yarnpkg.com/postcss-opacity-percentage/-/postcss-opacity-percentage-1.1.2.tgz -> yarnpkg-postcss-opacity-percentage-1.1.2.tgz
https://registry.yarnpkg.com/postcss-overflow-shorthand/-/postcss-overflow-shorthand-3.0.4.tgz -> yarnpkg-postcss-overflow-shorthand-3.0.4.tgz
https://registry.yarnpkg.com/postcss-page-break/-/postcss-page-break-3.0.4.tgz -> yarnpkg-postcss-page-break-3.0.4.tgz
https://registry.yarnpkg.com/postcss-place/-/postcss-place-7.0.5.tgz -> yarnpkg-postcss-place-7.0.5.tgz
https://registry.yarnpkg.com/postcss-preset-env/-/postcss-preset-env-7.8.0.tgz -> yarnpkg-postcss-preset-env-7.8.0.tgz
https://registry.yarnpkg.com/postcss-pseudo-class-any-link/-/postcss-pseudo-class-any-link-7.1.6.tgz -> yarnpkg-postcss-pseudo-class-any-link-7.1.6.tgz
https://registry.yarnpkg.com/postcss-replace-overflow-wrap/-/postcss-replace-overflow-wrap-4.0.0.tgz -> yarnpkg-postcss-replace-overflow-wrap-4.0.0.tgz
https://registry.yarnpkg.com/postcss-selector-not/-/postcss-selector-not-6.0.1.tgz -> yarnpkg-postcss-selector-not-6.0.1.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.10.tgz -> yarnpkg-postcss-selector-parser-6.0.10.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> yarnpkg-postcss-value-parser-4.2.0.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.16.tgz -> yarnpkg-postcss-8.4.16.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.18.tgz -> yarnpkg-postcss-8.4.18.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.19.tgz -> yarnpkg-postcss-8.4.19.tgz
https://registry.yarnpkg.com/postinstall-postinstall/-/postinstall-postinstall-2.1.0.tgz -> yarnpkg-postinstall-postinstall-2.1.0.tgz
https://registry.yarnpkg.com/prettier-plugin-organize-imports/-/prettier-plugin-organize-imports-2.3.4.tgz -> yarnpkg-prettier-plugin-organize-imports-2.3.4.tgz
https://registry.yarnpkg.com/prettier/-/prettier-2.4.1.tgz -> yarnpkg-prettier-2.4.1.tgz
https://registry.yarnpkg.com/prettier/-/prettier-2.7.1.tgz -> yarnpkg-prettier-2.7.1.tgz
https://registry.yarnpkg.com/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> yarnpkg-pretty-bytes-5.6.0.tgz
https://registry.yarnpkg.com/proc-log/-/proc-log-2.0.1.tgz -> yarnpkg-proc-log-2.0.1.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise-retry/-/promise-retry-2.0.1.tgz -> yarnpkg-promise-retry-2.0.1.tgz
https://registry.yarnpkg.com/protobufjs/-/protobufjs-6.8.8.tgz -> yarnpkg-protobufjs-6.8.8.tgz
https://registry.yarnpkg.com/protractor/-/protractor-7.0.0.tgz -> yarnpkg-protractor-7.0.0.tgz
https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.7.tgz -> yarnpkg-proxy-addr-2.0.7.tgz
https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz -> yarnpkg-prr-1.0.1.tgz
https://registry.yarnpkg.com/psl/-/psl-1.9.0.tgz -> yarnpkg-psl-1.9.0.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz -> yarnpkg-punycode-2.1.1.tgz
https://registry.yarnpkg.com/q/-/q-1.4.1.tgz -> yarnpkg-q-1.4.1.tgz
https://registry.yarnpkg.com/q/-/q-1.5.1.tgz -> yarnpkg-q-1.5.1.tgz
https://registry.yarnpkg.com/qjobs/-/qjobs-1.2.0.tgz -> yarnpkg-qjobs-1.2.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.0.tgz -> yarnpkg-qs-6.11.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.2.3.tgz -> yarnpkg-qs-6.2.3.tgz
https://registry.yarnpkg.com/qs/-/qs-6.5.3.tgz -> yarnpkg-qs-6.5.3.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz -> yarnpkg-range-parser-1.2.1.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.5.1.tgz -> yarnpkg-raw-body-2.5.1.tgz
https://registry.yarnpkg.com/read-cache/-/read-cache-1.0.0.tgz -> yarnpkg-read-cache-1.0.0.tgz
https://registry.yarnpkg.com/read-package-json-fast/-/read-package-json-fast-2.0.3.tgz -> yarnpkg-read-package-json-fast-2.0.3.tgz
https://registry.yarnpkg.com/read-package-json/-/read-package-json-5.0.2.tgz -> yarnpkg-read-package-json-5.0.2.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz -> yarnpkg-readable-stream-2.3.7.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz -> yarnpkg-readable-stream-3.6.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/reflect-metadata/-/reflect-metadata-0.1.13.tgz -> yarnpkg-reflect-metadata-0.1.13.tgz
https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.0.tgz -> yarnpkg-regenerate-unicode-properties-10.1.0.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz -> yarnpkg-regenerate-1.4.2.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.10.tgz -> yarnpkg-regenerator-runtime-0.13.10.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.9.tgz -> yarnpkg-regenerator-runtime-0.13.9.tgz
https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.15.0.tgz -> yarnpkg-regenerator-transform-0.15.0.tgz
https://registry.yarnpkg.com/regex-parser/-/regex-parser-2.2.11.tgz -> yarnpkg-regex-parser-2.2.11.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-5.2.1.tgz -> yarnpkg-regexpu-core-5.2.1.tgz
https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.7.1.tgz -> yarnpkg-regjsgen-0.7.1.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.9.1.tgz -> yarnpkg-regjsparser-0.9.1.tgz
https://registry.yarnpkg.com/request/-/request-2.88.2.tgz -> yarnpkg-request-2.88.2.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz -> yarnpkg-require-main-filename-2.0.0.tgz
https://registry.yarnpkg.com/requirejs/-/requirejs-2.3.6.tgz -> yarnpkg-requirejs-2.3.6.tgz
https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz -> yarnpkg-requires-port-1.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz -> yarnpkg-resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve-url-loader/-/resolve-url-loader-5.0.0.tgz -> yarnpkg-resolve-url-loader-5.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.17.0.tgz -> yarnpkg-resolve-1.17.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.19.0.tgz -> yarnpkg-resolve-1.19.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/resp-modifier/-/resp-modifier-6.0.2.tgz -> yarnpkg-resp-modifier-6.0.2.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-3.1.0.tgz -> yarnpkg-restore-cursor-3.1.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz -> yarnpkg-retry-0.12.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.13.1.tgz -> yarnpkg-retry-0.13.1.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rfdc/-/rfdc-1.3.0.tgz -> yarnpkg-rfdc-1.3.0.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/rw/-/rw-1.3.3.tgz -> yarnpkg-rw-1.3.3.tgz
https://registry.yarnpkg.com/rx/-/rx-4.1.0.tgz -> yarnpkg-rx-4.1.0.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-5.5.12.tgz -> yarnpkg-rxjs-5.5.12.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.7.tgz -> yarnpkg-rxjs-6.6.7.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-7.5.7.tgz -> yarnpkg-rxjs-7.5.7.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sass-loader/-/sass-loader-13.0.2.tgz -> yarnpkg-sass-loader-13.0.2.tgz
https://registry.yarnpkg.com/sass-loader/-/sass-loader-13.1.0.tgz -> yarnpkg-sass-loader-13.1.0.tgz
https://registry.yarnpkg.com/sass/-/sass-1.54.4.tgz -> yarnpkg-sass-1.54.4.tgz
https://registry.yarnpkg.com/sass/-/sass-1.55.0.tgz -> yarnpkg-sass-1.55.0.tgz
https://registry.yarnpkg.com/saucelabs/-/saucelabs-1.5.0.tgz -> yarnpkg-saucelabs-1.5.0.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.1.tgz -> yarnpkg-schema-utils-2.7.1.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.1.1.tgz -> yarnpkg-schema-utils-3.1.1.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-4.0.0.tgz -> yarnpkg-schema-utils-4.0.0.tgz
https://registry.yarnpkg.com/seedrandom/-/seedrandom-2.4.3.tgz -> yarnpkg-seedrandom-2.4.3.tgz
https://registry.yarnpkg.com/select-hose/-/select-hose-2.0.0.tgz -> yarnpkg-select-hose-2.0.0.tgz
https://registry.yarnpkg.com/selenium-webdriver/-/selenium-webdriver-3.6.0.tgz -> yarnpkg-selenium-webdriver-3.6.0.tgz
https://registry.yarnpkg.com/selenium-webdriver/-/selenium-webdriver-4.4.0.tgz -> yarnpkg-selenium-webdriver-4.4.0.tgz
https://registry.yarnpkg.com/selfsigned/-/selfsigned-2.1.1.tgz -> yarnpkg-selfsigned-2.1.1.tgz
https://registry.yarnpkg.com/semver/-/semver-5.6.0.tgz -> yarnpkg-semver-5.6.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.7.tgz -> yarnpkg-semver-7.3.7.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.8.tgz -> yarnpkg-semver-7.3.8.tgz
https://registry.yarnpkg.com/send/-/send-0.16.2.tgz -> yarnpkg-send-0.16.2.tgz
https://registry.yarnpkg.com/send/-/send-0.18.0.tgz -> yarnpkg-send-0.18.0.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> yarnpkg-serialize-javascript-6.0.0.tgz
https://registry.yarnpkg.com/serve-index/-/serve-index-1.9.1.tgz -> yarnpkg-serve-index-1.9.1.tgz
https://registry.yarnpkg.com/serve-static/-/serve-static-1.13.2.tgz -> yarnpkg-serve-static-1.13.2.tgz
https://registry.yarnpkg.com/serve-static/-/serve-static-1.15.0.tgz -> yarnpkg-serve-static-1.15.0.tgz
https://registry.yarnpkg.com/server-destroy/-/server-destroy-1.0.1.tgz -> yarnpkg-server-destroy-1.0.1.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz -> yarnpkg-setimmediate-1.0.5.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.0.tgz -> yarnpkg-setprototypeof-1.1.0.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.2.0.tgz -> yarnpkg-setprototypeof-1.2.0.tgz
https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz -> yarnpkg-shallow-clone-3.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-4.0.0.tgz -> yarnpkg-slash-4.0.0.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz -> yarnpkg-smart-buffer-4.2.0.tgz
https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-2.4.0.tgz -> yarnpkg-socket.io-adapter-2.4.0.tgz
https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-4.5.3.tgz -> yarnpkg-socket.io-client-4.5.3.tgz
https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-4.2.1.tgz -> yarnpkg-socket.io-parser-4.2.1.tgz
https://registry.yarnpkg.com/socket.io/-/socket.io-4.5.3.tgz -> yarnpkg-socket.io-4.5.3.tgz
https://registry.yarnpkg.com/sockjs/-/sockjs-0.3.24.tgz -> yarnpkg-sockjs-0.3.24.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> yarnpkg-socks-proxy-agent-7.0.0.tgz
https://registry.yarnpkg.com/socks/-/socks-2.6.2.tgz -> yarnpkg-socks-2.6.2.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz -> yarnpkg-source-map-js-1.0.2.tgz
https://registry.yarnpkg.com/source-map-loader/-/source-map-loader-4.0.0.tgz -> yarnpkg-source-map-loader-4.0.0.tgz
https://registry.yarnpkg.com/source-map-loader/-/source-map-loader-4.0.1.tgz -> yarnpkg-source-map-loader-4.0.1.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz -> yarnpkg-source-map-support-0.4.18.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.9.tgz -> yarnpkg-source-map-support-0.5.9.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.7.4.tgz -> yarnpkg-source-map-0.7.4.tgz
https://registry.yarnpkg.com/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> yarnpkg-sourcemap-codec-1.4.8.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz -> yarnpkg-spdx-correct-3.1.1.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.12.tgz -> yarnpkg-spdx-license-ids-3.0.12.tgz
https://registry.yarnpkg.com/spdy-transport/-/spdy-transport-3.0.0.tgz -> yarnpkg-spdy-transport-3.0.0.tgz
https://registry.yarnpkg.com/spdy/-/spdy-4.0.2.tgz -> yarnpkg-spdy-4.0.2.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/sshpk/-/sshpk-1.17.0.tgz -> yarnpkg-sshpk-1.17.0.tgz
https://registry.yarnpkg.com/ssri/-/ssri-10.0.0.tgz -> yarnpkg-ssri-10.0.0.tgz
https://registry.yarnpkg.com/ssri/-/ssri-9.0.1.tgz -> yarnpkg-ssri-9.0.1.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.3.1.tgz -> yarnpkg-statuses-1.3.1.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.4.0.tgz -> yarnpkg-statuses-1.4.0.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz -> yarnpkg-statuses-1.5.0.tgz
https://registry.yarnpkg.com/statuses/-/statuses-2.0.1.tgz -> yarnpkg-statuses-2.0.1.tgz
https://registry.yarnpkg.com/stream-throttle/-/stream-throttle-0.1.3.tgz -> yarnpkg-stream-throttle-0.1.3.tgz
https://registry.yarnpkg.com/streamroller/-/streamroller-3.0.2.tgz -> yarnpkg-streamroller-3.0.2.tgz
https://registry.yarnpkg.com/string-argv/-/string-argv-0.3.1.tgz -> yarnpkg-string-argv-0.3.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/stylus-loader/-/stylus-loader-7.0.0.tgz -> yarnpkg-stylus-loader-7.0.0.tgz
https://registry.yarnpkg.com/stylus/-/stylus-0.59.0.tgz -> yarnpkg-stylus-0.59.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz -> yarnpkg-supports-color-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.0.1.tgz -> yarnpkg-symbol-observable-1.0.1.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-4.0.0.tgz -> yarnpkg-symbol-observable-4.0.0.tgz
https://registry.yarnpkg.com/tapable/-/tapable-2.2.1.tgz -> yarnpkg-tapable-2.2.1.tgz
https://registry.yarnpkg.com/tar/-/tar-6.1.12.tgz -> yarnpkg-tar-6.1.12.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.6.tgz -> yarnpkg-terser-webpack-plugin-5.3.6.tgz
https://registry.yarnpkg.com/terser/-/terser-5.14.2.tgz -> yarnpkg-terser-5.14.2.tgz
https://registry.yarnpkg.com/terser/-/terser-5.15.1.tgz -> yarnpkg-terser-5.15.1.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz -> yarnpkg-test-exclude-6.0.0.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/tfunk/-/tfunk-4.0.0.tgz -> yarnpkg-tfunk-4.0.0.tgz
https://registry.yarnpkg.com/three/-/three-0.137.0.tgz -> yarnpkg-three-0.137.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/thunky/-/thunky-1.1.0.tgz -> yarnpkg-thunky-1.1.0.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.30.tgz -> yarnpkg-tmp-0.0.30.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz -> yarnpkg-tmp-0.2.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.1.tgz -> yarnpkg-toidentifier-1.0.1.tgz
https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.5.0.tgz -> yarnpkg-tough-cookie-2.5.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/tree-kill/-/tree-kill-1.2.2.tgz -> yarnpkg-tree-kill-1.2.2.tgz
https://registry.yarnpkg.com/true-case-path/-/true-case-path-2.2.1.tgz -> yarnpkg-true-case-path-2.2.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.8.1.tgz -> yarnpkg-tslib-1.8.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.4.0.tgz -> yarnpkg-tslib-2.4.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.4.1.tgz -> yarnpkg-tslib-2.4.1.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> yarnpkg-tunnel-agent-0.6.0.tgz
https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz -> yarnpkg-tweetnacl-0.14.5.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.21.3.tgz -> yarnpkg-type-fest-0.21.3.tgz
https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz -> yarnpkg-type-is-1.6.18.tgz
https://registry.yarnpkg.com/typed-assert/-/typed-assert-1.0.9.tgz -> yarnpkg-typed-assert-1.0.9.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.7.4.tgz -> yarnpkg-typescript-4.7.4.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.8.4.tgz -> yarnpkg-typescript-4.8.4.tgz
https://registry.yarnpkg.com/typesettable/-/typesettable-4.1.0.tgz -> yarnpkg-typesettable-4.1.0.tgz
https://registry.yarnpkg.com/ua-parser-js/-/ua-parser-js-0.7.33.tgz -> yarnpkg-ua-parser-js-0.7.33.tgz
https://registry.yarnpkg.com/ua-parser-js/-/ua-parser-js-1.0.2.tgz -> yarnpkg-ua-parser-js-1.0.2.tgz
https://registry.yarnpkg.com/umap-js/-/umap-js-1.3.3.tgz -> yarnpkg-umap-js-1.3.3.tgz
https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> yarnpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> yarnpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.0.0.tgz -> yarnpkg-unicode-match-property-value-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> yarnpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.1.tgz -> yarnpkg-unique-filename-1.1.1.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-2.0.1.tgz -> yarnpkg-unique-filename-2.0.1.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-3.0.0.tgz -> yarnpkg-unique-filename-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.2.tgz -> yarnpkg-unique-slug-2.0.2.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-3.0.0.tgz -> yarnpkg-unique-slug-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-4.0.0.tgz -> yarnpkg-unique-slug-4.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.10.tgz -> yarnpkg-update-browserslist-db-1.0.10.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz -> yarnpkg-utils-merge-1.0.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz -> yarnpkg-uuid-3.4.0.tgz
https://registry.yarnpkg.com/uuid/-/uuid-8.3.2.tgz -> yarnpkg-uuid-8.3.2.tgz
https://registry.yarnpkg.com/uuid/-/uuid-9.0.0.tgz -> yarnpkg-uuid-9.0.0.tgz
https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-7.1.2.tgz -> yarnpkg-v8-to-istanbul-7.1.2.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-4.0.0.tgz -> yarnpkg-validate-npm-package-name-4.0.0.tgz
https://registry.yarnpkg.com/validator/-/validator-13.7.0.tgz -> yarnpkg-validator-13.7.0.tgz
https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz -> yarnpkg-vary-1.1.2.tgz
https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz -> yarnpkg-verror-1.10.0.tgz
https://registry.yarnpkg.com/void-elements/-/void-elements-2.0.1.tgz -> yarnpkg-void-elements-2.0.1.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-2.4.0.tgz -> yarnpkg-watchpack-2.4.0.tgz
https://registry.yarnpkg.com/wbuf/-/wbuf-1.7.3.tgz -> yarnpkg-wbuf-1.7.3.tgz
https://registry.yarnpkg.com/wcwidth/-/wcwidth-1.0.1.tgz -> yarnpkg-wcwidth-1.0.1.tgz
https://registry.yarnpkg.com/web-animations-js/-/web-animations-js-2.3.2.tgz -> yarnpkg-web-animations-js-2.3.2.tgz
https://registry.yarnpkg.com/webdriver-js-extender/-/webdriver-js-extender-2.1.0.tgz -> yarnpkg-webdriver-js-extender-2.1.0.tgz
https://registry.yarnpkg.com/webdriver-manager/-/webdriver-manager-12.1.8.tgz -> yarnpkg-webdriver-manager-12.1.8.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/webpack-dev-middleware/-/webpack-dev-middleware-5.3.3.tgz -> yarnpkg-webpack-dev-middleware-5.3.3.tgz
https://registry.yarnpkg.com/webpack-dev-server/-/webpack-dev-server-4.11.0.tgz -> yarnpkg-webpack-dev-server-4.11.0.tgz
https://registry.yarnpkg.com/webpack-dev-server/-/webpack-dev-server-4.11.1.tgz -> yarnpkg-webpack-dev-server-4.11.1.tgz
https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-5.8.0.tgz -> yarnpkg-webpack-merge-5.8.0.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-3.2.3.tgz -> yarnpkg-webpack-sources-3.2.3.tgz
https://registry.yarnpkg.com/webpack-subresource-integrity/-/webpack-subresource-integrity-5.1.0.tgz -> yarnpkg-webpack-subresource-integrity-5.1.0.tgz
https://registry.yarnpkg.com/webpack/-/webpack-5.74.0.tgz -> yarnpkg-webpack-5.74.0.tgz
https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.7.4.tgz -> yarnpkg-websocket-driver-0.7.4.tgz
https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> yarnpkg-websocket-extensions-0.1.4.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz -> yarnpkg-which-module-2.0.0.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.5.tgz -> yarnpkg-wide-align-1.1.5.tgz
https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.0.tgz -> yarnpkg-wildcard-2.0.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> yarnpkg-wrap-ansi-6.2.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/ws/-/ws-8.11.0.tgz -> yarnpkg-ws-8.11.0.tgz
https://registry.yarnpkg.com/ws/-/ws-8.2.3.tgz -> yarnpkg-ws-8.2.3.tgz
https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.23.tgz -> yarnpkg-xml2js-0.4.23.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> yarnpkg-xmlbuilder-11.0.1.tgz
https://registry.yarnpkg.com/xmlhttprequest-ssl/-/xmlhttprequest-ssl-2.0.0.tgz -> yarnpkg-xmlhttprequest-ssl-2.0.0.tgz
https://registry.yarnpkg.com/xmlhttprequest/-/xmlhttprequest-1.8.0.tgz -> yarnpkg-xmlhttprequest-1.8.0.tgz
https://registry.yarnpkg.com/y18n/-/y18n-4.0.3.tgz -> yarnpkg-y18n-4.0.3.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yaml/-/yaml-1.10.2.tgz -> yarnpkg-yaml-1.10.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-18.1.3.tgz -> yarnpkg-yargs-parser-18.1.3.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.1.1.tgz -> yarnpkg-yargs-parser-21.1.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-15.4.1.tgz -> yarnpkg-yargs-15.4.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.1.1.tgz -> yarnpkg-yargs-17.1.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.5.1.tgz -> yarnpkg-yargs-17.5.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.6.2.tgz -> yarnpkg-yargs-17.6.2.tgz
https://registry.yarnpkg.com/yarn-deduplicate/-/yarn-deduplicate-5.0.0.tgz -> yarnpkg-yarn-deduplicate-5.0.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
https://registry.yarnpkg.com/z-schema/-/z-schema-5.0.4.tgz -> yarnpkg-z-schema-5.0.4.tgz
https://registry.yarnpkg.com/zone.js/-/zone.js-0.12.0.tgz -> yarnpkg-zone.js-0.12.0.tgz
"
# List initially from:
# grep "resolved" /var/tmp/portage/sci-visualization/tensorboard-2.12.0/work/tensorboard-2.12.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# grep -o -E -r -e "https://registry.yarnpkg.com[^\"]+" /var/tmp/portage/sci-visualization/tensorboard-2.12.0/work/tensorboard-2.11.2-bazel-base/external/io_bazel_rules_sass/sass/yarn.lock | sed -r -e "s|#.*||g"
# Transformed with transform-uris.sh.

# The versions and commits were obtained from console.  To update, temporarily
# remove links in bazel_external_uris.
APPLE_SUPPORT_PV="0.11.0"
BAZEL_GAZELLE_PV="0.24.0"
BAZEL_SKYLIB_PV="1.1.1"
BLEACH_PV="2.0"
CHROMEDRIVER_PV="2.41"
CHROMIUM_REV="768959"
CLOSURE_LIBRARY_PV="20191027"
GRPC_PV="1.48.2"
HTML5LIB_PYTHON_PV="1.1"
MARKDOWN_PV="2.6.8"
MATERIAL_DESIGN_ICONS_3_0_1_PV="3.0.1"
MATERIAL_DESIGN_ICONS_3_0_2_PV="3.0.2"
NODE_PV="16.15.0"
PLATFORMS_PV="0.0.4"
PROTOBUF_PV="3.19.6"
RULES_APPLE_PV="0.31.3"
RULES_GO_PV="0.27.0"
RULES_NODEJS_PV="5.7.0"
RULES_NODEJS_CORE_PV="5.7.0"
RULES_SASS_PV="1.55.0"
RULES_WEBTESTING_PV="0.3.3"
WEBENCODINGS_PV="0.5.1"
WERKZUG_PV="0.15.4"
YARN_PV="1.22.11"
EGIT_DATA_PLANE_API_COMMIT="9c42588c956220b48eb3099d186487c2f04d32ec"
EGIT_GOOGLEAPIS_COMMIT="2f9af297c84c55c8b871ba4495e01ade42476c92"
EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT="224895a86501195e7a7ff3dde18e39f00b8e3d5a"
EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT="ab12f16d050ecb1886b606f08825d24b30acafea"
EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT="b3f05bfbf4329a5b63f50a720f867c2bac163f98"
EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT="d3d4aca5a7cf50bc68bbd401cefa708e364194e8"
EGIT_PROTOC_GEN_VALIDATE_COMMIT="4694024279bdac52b77e22dc87808bd0fd732b69"
EGIT_ROBOTO_COMMIT="ba03b84b90b50afd99f9688059447bc545e5c0e1"
EGIT_RULES_CC_COMMIT="b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e"
EGIT_RULES_CLOSURE_COMMIT="db4683a2a1836ac8e265804ca5fa31852395185b"
EGIT_RULES_JAVA_COMMIT="981f06c3d2bd10225e85209904090eb7b5fb26bd"
EGIT_RULES_PROTO_COMMIT="97d8af4dc474595af3900dd85cb3a29ad28cc313"
EGIT_RULES_PYTHON_COMMIT="4b84ad270387a7c439ebdccfd530e2339601ef27"
EGIT_RULES_RUST_COMMIT="d5ab4143245af8b33d1947813d411a6cae838409"
EGIT_UPB_COMMIT="bef53686ec702607971bd3ea4d4fefd80c6cc6e8"

rust_crates_uris="
https://crates.io/api/v1/crates/aho-corasick/0.7.18/download -> rust-crates--aho-corasick-0.7.18.tar.gz
https://crates.io/api/v1/crates/anyhow/1.0.34/download -> rust-crates--anyhow-1.0.34.tar.gz
https://crates.io/api/v1/crates/async-stream/0.3.0/download -> rust-crates--async-stream-0.3.0.tar.gz
https://crates.io/api/v1/crates/async-stream-impl/0.3.0/download -> rust-crates--async-stream-impl-0.3.0.tar.gz
https://crates.io/api/v1/crates/async-trait/0.1.41/download -> rust-crates--async-trait-0.1.41.tar.gz
https://crates.io/api/v1/crates/atty/0.2.14/download -> rust-crates--atty-0.2.14.tar.gz
https://crates.io/api/v1/crates/autocfg/1.0.1/download -> rust-crates--autocfg-1.0.1.tar.gz
https://crates.io/api/v1/crates/base64/0.13.0/download -> rust-crates--base64-0.13.0.tar.gz
https://crates.io/api/v1/crates/bitflags/1.2.1/download -> rust-crates--bitflags-1.2.1.tar.gz
https://crates.io/api/v1/crates/build_const/0.2.1/download -> rust-crates--build_const-0.2.1.tar.gz
https://crates.io/api/v1/crates/bumpalo/3.12.0/download -> rust-crates--bumpalo-3.12.0.tar.gz
https://crates.io/api/v1/crates/byteorder/1.3.4/download -> rust-crates--byteorder-1.3.4.tar.gz
https://crates.io/api/v1/crates/bytes/0.5.6/download -> rust-crates--bytes-0.5.6.tar.gz
https://crates.io/api/v1/crates/bytes/1.0.1/download -> rust-crates--bytes-1.0.1.tar.gz
https://crates.io/api/v1/crates/cc/1.0.66/download -> rust-crates--cc-1.0.66.tar.gz
https://crates.io/api/v1/crates/cfg-if/0.1.10/download -> rust-crates--cfg-if-0.1.10.tar.gz
https://crates.io/api/v1/crates/cfg-if/1.0.0/download -> rust-crates--cfg-if-1.0.0.tar.gz
https://crates.io/api/v1/crates/clap/3.0.0-beta.2/download -> rust-crates--clap-3.0.0-beta.2.tar.gz
https://crates.io/api/v1/crates/clap_derive/3.0.0-beta.2/download -> rust-crates--clap_derive-3.0.0-beta.2.tar.gz
https://crates.io/api/v1/crates/const_fn/0.4.5/download -> rust-crates--const_fn-0.4.5.tar.gz
https://crates.io/api/v1/crates/core-foundation/0.9.3/download -> rust-crates--core-foundation-0.9.3.tar.gz
https://crates.io/api/v1/crates/core-foundation-sys/0.8.3/download -> rust-crates--core-foundation-sys-0.8.3.tar.gz
https://crates.io/api/v1/crates/crc/1.8.1/download -> rust-crates--crc-1.8.1.tar.gz
https://crates.io/api/v1/crates/crossbeam/0.8.0/download -> rust-crates--crossbeam-0.8.0.tar.gz
https://crates.io/api/v1/crates/crossbeam-channel/0.5.0/download -> rust-crates--crossbeam-channel-0.5.0.tar.gz
https://crates.io/api/v1/crates/crossbeam-deque/0.8.1/download -> rust-crates--crossbeam-deque-0.8.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-epoch/0.9.1/download -> rust-crates--crossbeam-epoch-0.9.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-queue/0.3.1/download -> rust-crates--crossbeam-queue-0.3.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-utils/0.8.8/download -> rust-crates--crossbeam-utils-0.8.8.tar.gz
https://crates.io/api/v1/crates/dirs-next/2.0.0/download -> rust-crates--dirs-next-2.0.0.tar.gz
https://crates.io/api/v1/crates/dirs-sys-next/0.1.2/download -> rust-crates--dirs-sys-next-0.1.2.tar.gz
https://crates.io/api/v1/crates/either/1.6.1/download -> rust-crates--either-1.6.1.tar.gz
https://crates.io/api/v1/crates/encoding_rs/0.8.26/download -> rust-crates--encoding_rs-0.8.26.tar.gz
https://crates.io/api/v1/crates/env_logger/0.8.2/download -> rust-crates--env_logger-0.8.2.tar.gz
https://crates.io/api/v1/crates/fixedbitset/0.4.1/download -> rust-crates--fixedbitset-0.4.1.tar.gz
https://crates.io/api/v1/crates/fnv/1.0.7/download -> rust-crates--fnv-1.0.7.tar.gz
https://crates.io/api/v1/crates/form_urlencoded/1.0.0/download -> rust-crates--form_urlencoded-1.0.0.tar.gz
https://crates.io/api/v1/crates/futures-channel/0.3.8/download -> rust-crates--futures-channel-0.3.8.tar.gz
https://crates.io/api/v1/crates/futures-core/0.3.12/download -> rust-crates--futures-core-0.3.12.tar.gz
https://crates.io/api/v1/crates/futures-io/0.3.12/download -> rust-crates--futures-io-0.3.12.tar.gz
https://crates.io/api/v1/crates/futures-macro/0.3.8/download -> rust-crates--futures-macro-0.3.8.tar.gz
https://crates.io/api/v1/crates/futures-sink/0.3.8/download -> rust-crates--futures-sink-0.3.8.tar.gz
https://crates.io/api/v1/crates/futures-task/0.3.8/download -> rust-crates--futures-task-0.3.8.tar.gz
https://crates.io/api/v1/crates/futures-util/0.3.8/download -> rust-crates--futures-util-0.3.8.tar.gz
https://crates.io/api/v1/crates/gcp_auth/0.7.4/download -> rust-crates--gcp_auth-0.7.4.tar.gz
https://crates.io/api/v1/crates/getrandom/0.1.15/download -> rust-crates--getrandom-0.1.15.tar.gz
https://crates.io/api/v1/crates/getrandom/0.2.1/download -> rust-crates--getrandom-0.2.1.tar.gz
https://crates.io/api/v1/crates/h2/0.3.13/download -> rust-crates--h2-0.3.13.tar.gz
https://crates.io/api/v1/crates/hashbrown/0.11.2/download -> rust-crates--hashbrown-0.11.2.tar.gz
https://crates.io/api/v1/crates/heck/0.3.1/download -> rust-crates--heck-0.3.1.tar.gz
https://crates.io/api/v1/crates/hermit-abi/0.1.17/download -> rust-crates--hermit-abi-0.1.17.tar.gz
https://crates.io/api/v1/crates/http/0.2.1/download -> rust-crates--http-0.2.1.tar.gz
https://crates.io/api/v1/crates/http-body/0.4.5/download -> rust-crates--http-body-0.4.5.tar.gz
https://crates.io/api/v1/crates/httparse/1.7.1/download -> rust-crates--httparse-1.7.1.tar.gz
https://crates.io/api/v1/crates/httpdate/1.0.2/download -> rust-crates--httpdate-1.0.2.tar.gz
https://crates.io/api/v1/crates/humantime/2.0.1/download -> rust-crates--humantime-2.0.1.tar.gz
https://crates.io/api/v1/crates/hyper/0.14.19/download -> rust-crates--hyper-0.14.19.tar.gz
https://crates.io/api/v1/crates/hyper-rustls/0.22.1/download -> rust-crates--hyper-rustls-0.22.1.tar.gz
https://crates.io/api/v1/crates/hyper-rustls/0.23.0/download -> rust-crates--hyper-rustls-0.23.0.tar.gz
https://crates.io/api/v1/crates/hyper-timeout/0.4.1/download -> rust-crates--hyper-timeout-0.4.1.tar.gz
https://crates.io/api/v1/crates/idna/0.2.0/download -> rust-crates--idna-0.2.0.tar.gz
https://crates.io/api/v1/crates/indexmap/1.8.2/download -> rust-crates--indexmap-1.8.2.tar.gz
https://crates.io/api/v1/crates/ipnet/2.3.0/download -> rust-crates--ipnet-2.3.0.tar.gz
https://crates.io/api/v1/crates/itertools/0.10.3/download -> rust-crates--itertools-0.10.3.tar.gz
https://crates.io/api/v1/crates/itoa/0.4.6/download -> rust-crates--itoa-0.4.6.tar.gz
https://crates.io/api/v1/crates/itoa/1.0.2/download -> rust-crates--itoa-1.0.2.tar.gz
https://crates.io/api/v1/crates/js-sys/0.3.47/download -> rust-crates--js-sys-0.3.47.tar.gz
https://crates.io/api/v1/crates/lazy_static/1.4.0/download -> rust-crates--lazy_static-1.4.0.tar.gz
https://crates.io/api/v1/crates/libc/0.2.126/download -> rust-crates--libc-0.2.126.tar.gz
https://crates.io/api/v1/crates/lock_api/0.4.6/download -> rust-crates--lock_api-0.4.6.tar.gz
https://crates.io/api/v1/crates/log/0.4.11/download -> rust-crates--log-0.4.11.tar.gz
https://crates.io/api/v1/crates/matches/0.1.8/download -> rust-crates--matches-0.1.8.tar.gz
https://crates.io/api/v1/crates/memchr/2.5.0/download -> rust-crates--memchr-2.5.0.tar.gz
https://crates.io/api/v1/crates/memoffset/0.6.1/download -> rust-crates--memoffset-0.6.1.tar.gz
https://crates.io/api/v1/crates/mime/0.3.16/download -> rust-crates--mime-0.3.16.tar.gz
https://crates.io/api/v1/crates/mio/0.8.3/download -> rust-crates--mio-0.8.3.tar.gz
https://crates.io/api/v1/crates/multimap/0.8.2/download -> rust-crates--multimap-0.8.2.tar.gz
https://crates.io/api/v1/crates/num_cpus/1.13.0/download -> rust-crates--num_cpus-1.13.0.tar.gz
https://crates.io/api/v1/crates/num_threads/0.1.6/download -> rust-crates--num_threads-0.1.6.tar.gz
https://crates.io/api/v1/crates/once_cell/1.5.2/download -> rust-crates--once_cell-1.5.2.tar.gz
https://crates.io/api/v1/crates/openssl-probe/0.1.5/download -> rust-crates--openssl-probe-0.1.5.tar.gz
https://crates.io/api/v1/crates/os_str_bytes/2.4.0/download -> rust-crates--os_str_bytes-2.4.0.tar.gz
https://crates.io/api/v1/crates/parking_lot/0.12.1/download -> rust-crates--parking_lot-0.12.1.tar.gz
https://crates.io/api/v1/crates/parking_lot_core/0.9.3/download -> rust-crates--parking_lot_core-0.9.3.tar.gz
https://crates.io/api/v1/crates/percent-encoding/2.1.0/download -> rust-crates--percent-encoding-2.1.0.tar.gz
https://crates.io/api/v1/crates/petgraph/0.6.2/download -> rust-crates--petgraph-0.6.2.tar.gz
https://crates.io/api/v1/crates/pin-project/1.0.12/download -> rust-crates--pin-project-1.0.12.tar.gz
https://crates.io/api/v1/crates/pin-project-internal/1.0.12/download -> rust-crates--pin-project-internal-1.0.12.tar.gz
https://crates.io/api/v1/crates/pin-project-lite/0.2.9/download -> rust-crates--pin-project-lite-0.2.9.tar.gz
https://crates.io/api/v1/crates/pin-utils/0.1.0/download -> rust-crates--pin-utils-0.1.0.tar.gz
https://crates.io/api/v1/crates/ppv-lite86/0.2.10/download -> rust-crates--ppv-lite86-0.2.10.tar.gz
https://crates.io/api/v1/crates/proc-macro-error/1.0.4/download -> rust-crates--proc-macro-error-1.0.4.tar.gz
https://crates.io/api/v1/crates/proc-macro-error-attr/1.0.4/download -> rust-crates--proc-macro-error-attr-1.0.4.tar.gz
https://crates.io/api/v1/crates/proc-macro-hack/0.5.19/download -> rust-crates--proc-macro-hack-0.5.19.tar.gz
https://crates.io/api/v1/crates/proc-macro-nested/0.1.7/download -> rust-crates--proc-macro-nested-0.1.7.tar.gz
https://crates.io/api/v1/crates/proc-macro2/1.0.43/download -> rust-crates--proc-macro2-1.0.43.tar.gz
https://crates.io/api/v1/crates/prost/0.9.0/download -> rust-crates--prost-0.9.0.tar.gz
https://crates.io/api/v1/crates/prost-build/0.9.0/download -> rust-crates--prost-build-0.9.0.tar.gz
https://crates.io/api/v1/crates/prost-derive/0.9.0/download -> rust-crates--prost-derive-0.9.0.tar.gz
https://crates.io/api/v1/crates/prost-types/0.9.0/download -> rust-crates--prost-types-0.9.0.tar.gz
https://crates.io/api/v1/crates/quote/1.0.7/download -> rust-crates--quote-1.0.7.tar.gz
https://crates.io/api/v1/crates/rand/0.7.3/download -> rust-crates--rand-0.7.3.tar.gz
https://crates.io/api/v1/crates/rand/0.8.2/download -> rust-crates--rand-0.8.2.tar.gz
https://crates.io/api/v1/crates/rand_chacha/0.2.2/download -> rust-crates--rand_chacha-0.2.2.tar.gz
https://crates.io/api/v1/crates/rand_chacha/0.3.0/download -> rust-crates--rand_chacha-0.3.0.tar.gz
https://crates.io/api/v1/crates/rand_core/0.5.1/download -> rust-crates--rand_core-0.5.1.tar.gz
https://crates.io/api/v1/crates/rand_core/0.6.1/download -> rust-crates--rand_core-0.6.1.tar.gz
https://crates.io/api/v1/crates/rand_hc/0.2.0/download -> rust-crates--rand_hc-0.2.0.tar.gz
https://crates.io/api/v1/crates/rand_hc/0.3.0/download -> rust-crates--rand_hc-0.3.0.tar.gz
https://crates.io/api/v1/crates/rayon/1.5.0/download -> rust-crates--rayon-1.5.0.tar.gz
https://crates.io/api/v1/crates/rayon-core/1.9.0/download -> rust-crates--rayon-core-1.9.0.tar.gz
https://crates.io/api/v1/crates/redox_syscall/0.1.57/download -> rust-crates--redox_syscall-0.1.57.tar.gz
https://crates.io/api/v1/crates/redox_syscall/0.2.16/download -> rust-crates--redox_syscall-0.2.16.tar.gz
https://crates.io/api/v1/crates/redox_users/0.4.3/download -> rust-crates--redox_users-0.4.3.tar.gz
https://crates.io/api/v1/crates/regex/1.5.6/download -> rust-crates--regex-1.5.6.tar.gz
https://crates.io/api/v1/crates/regex-syntax/0.6.26/download -> rust-crates--regex-syntax-0.6.26.tar.gz
https://crates.io/api/v1/crates/remove_dir_all/0.5.3/download -> rust-crates--remove_dir_all-0.5.3.tar.gz
https://crates.io/api/v1/crates/reqwest/0.11.0/download -> rust-crates--reqwest-0.11.0.tar.gz
https://crates.io/api/v1/crates/ring/0.16.20/download -> rust-crates--ring-0.16.20.tar.gz
https://crates.io/api/v1/crates/rustls/0.19.0/download -> rust-crates--rustls-0.19.0.tar.gz
https://crates.io/api/v1/crates/rustls/0.20.6/download -> rust-crates--rustls-0.20.6.tar.gz
https://crates.io/api/v1/crates/rustls-native-certs/0.6.2/download -> rust-crates--rustls-native-certs-0.6.2.tar.gz
https://crates.io/api/v1/crates/rustls-pemfile/1.0.1/download -> rust-crates--rustls-pemfile-1.0.1.tar.gz
https://crates.io/api/v1/crates/ryu/1.0.5/download -> rust-crates--ryu-1.0.5.tar.gz
https://crates.io/api/v1/crates/same-file/1.0.6/download -> rust-crates--same-file-1.0.6.tar.gz
https://crates.io/api/v1/crates/schannel/0.1.20/download -> rust-crates--schannel-0.1.20.tar.gz
https://crates.io/api/v1/crates/scopeguard/1.1.0/download -> rust-crates--scopeguard-1.1.0.tar.gz
https://crates.io/api/v1/crates/sct/0.6.1/download -> rust-crates--sct-0.6.1.tar.gz
https://crates.io/api/v1/crates/sct/0.7.0/download -> rust-crates--sct-0.7.0.tar.gz
https://crates.io/api/v1/crates/security-framework/2.3.1/download -> rust-crates--security-framework-2.3.1.tar.gz
https://crates.io/api/v1/crates/security-framework-sys/2.6.1/download -> rust-crates--security-framework-sys-2.6.1.tar.gz
https://crates.io/api/v1/crates/serde/1.0.144/download -> rust-crates--serde-1.0.144.tar.gz
https://crates.io/api/v1/crates/serde_derive/1.0.144/download -> rust-crates--serde_derive-1.0.144.tar.gz
https://crates.io/api/v1/crates/serde_json/1.0.61/download -> rust-crates--serde_json-1.0.61.tar.gz
https://crates.io/api/v1/crates/serde_urlencoded/0.7.0/download -> rust-crates--serde_urlencoded-0.7.0.tar.gz
https://crates.io/api/v1/crates/slab/0.4.2/download -> rust-crates--slab-0.4.2.tar.gz
https://crates.io/api/v1/crates/smallvec/1.10.0/download -> rust-crates--smallvec-1.10.0.tar.gz
https://crates.io/api/v1/crates/socket2/0.4.4/download -> rust-crates--socket2-0.4.4.tar.gz
https://crates.io/api/v1/crates/spin/0.5.2/download -> rust-crates--spin-0.5.2.tar.gz
https://crates.io/api/v1/crates/strsim/0.10.0/download -> rust-crates--strsim-0.10.0.tar.gz
https://crates.io/api/v1/crates/syn/1.0.99/download -> rust-crates--syn-1.0.99.tar.gz
https://crates.io/api/v1/crates/tempfile/3.1.0/download -> rust-crates--tempfile-3.1.0.tar.gz
https://crates.io/api/v1/crates/termcolor/1.1.0/download -> rust-crates--termcolor-1.1.0.tar.gz
https://crates.io/api/v1/crates/textwrap/0.12.1/download -> rust-crates--textwrap-0.12.1.tar.gz
https://crates.io/api/v1/crates/thiserror/1.0.22/download -> rust-crates--thiserror-1.0.22.tar.gz
https://crates.io/api/v1/crates/thiserror-impl/1.0.22/download -> rust-crates--thiserror-impl-1.0.22.tar.gz
https://crates.io/api/v1/crates/time/0.3.14/download -> rust-crates--time-0.3.14.tar.gz
https://crates.io/api/v1/crates/tinyvec/1.1.1/download -> rust-crates--tinyvec-1.1.1.tar.gz
https://crates.io/api/v1/crates/tinyvec_macros/0.1.0/download -> rust-crates--tinyvec_macros-0.1.0.tar.gz
https://crates.io/api/v1/crates/tokio/1.19.2/download -> rust-crates--tokio-1.19.2.tar.gz
https://crates.io/api/v1/crates/tokio-io-timeout/1.2.0/download -> rust-crates--tokio-io-timeout-1.2.0.tar.gz
https://crates.io/api/v1/crates/tokio-macros/1.8.0/download -> rust-crates--tokio-macros-1.8.0.tar.gz
https://crates.io/api/v1/crates/tokio-rustls/0.22.0/download -> rust-crates--tokio-rustls-0.22.0.tar.gz
https://crates.io/api/v1/crates/tokio-rustls/0.23.4/download -> rust-crates--tokio-rustls-0.23.4.tar.gz
https://crates.io/api/v1/crates/tokio-stream/0.1.2/download -> rust-crates--tokio-stream-0.1.2.tar.gz
https://crates.io/api/v1/crates/tokio-util/0.6.6/download -> rust-crates--tokio-util-0.6.6.tar.gz
https://crates.io/api/v1/crates/tokio-util/0.7.3/download -> rust-crates--tokio-util-0.7.3.tar.gz
https://crates.io/api/v1/crates/tonic/0.6.2/download -> rust-crates--tonic-0.6.2.tar.gz
https://crates.io/api/v1/crates/tonic-build/0.6.2/download -> rust-crates--tonic-build-0.6.2.tar.gz
https://crates.io/api/v1/crates/tonic-reflection/0.3.0/download -> rust-crates--tonic-reflection-0.3.0.tar.gz
https://crates.io/api/v1/crates/tower/0.4.11/download -> rust-crates--tower-0.4.11.tar.gz
https://crates.io/api/v1/crates/tower-layer/0.3.1/download -> rust-crates--tower-layer-0.3.1.tar.gz
https://crates.io/api/v1/crates/tower-service/0.3.0/download -> rust-crates--tower-service-0.3.0.tar.gz
https://crates.io/api/v1/crates/tracing/0.1.34/download -> rust-crates--tracing-0.1.34.tar.gz
https://crates.io/api/v1/crates/tracing-attributes/0.1.21/download -> rust-crates--tracing-attributes-0.1.21.tar.gz
https://crates.io/api/v1/crates/tracing-core/0.1.26/download -> rust-crates--tracing-core-0.1.26.tar.gz
https://crates.io/api/v1/crates/tracing-futures/0.2.5/download -> rust-crates--tracing-futures-0.2.5.tar.gz
https://crates.io/api/v1/crates/try-lock/0.2.3/download -> rust-crates--try-lock-0.2.3.tar.gz
https://crates.io/api/v1/crates/unicode-bidi/0.3.4/download -> rust-crates--unicode-bidi-0.3.4.tar.gz
https://crates.io/api/v1/crates/unicode-ident/1.0.3/download -> rust-crates--unicode-ident-1.0.3.tar.gz
https://crates.io/api/v1/crates/unicode-normalization/0.1.16/download -> rust-crates--unicode-normalization-0.1.16.tar.gz
https://crates.io/api/v1/crates/unicode-segmentation/1.6.0/download -> rust-crates--unicode-segmentation-1.6.0.tar.gz
https://crates.io/api/v1/crates/unicode-width/0.1.8/download -> rust-crates--unicode-width-0.1.8.tar.gz
https://crates.io/api/v1/crates/untrusted/0.7.1/download -> rust-crates--untrusted-0.7.1.tar.gz
https://crates.io/api/v1/crates/url/2.2.0/download -> rust-crates--url-2.2.0.tar.gz
https://crates.io/api/v1/crates/vec_map/0.8.2/download -> rust-crates--vec_map-0.8.2.tar.gz
https://crates.io/api/v1/crates/version_check/0.9.2/download -> rust-crates--version_check-0.9.2.tar.gz
https://crates.io/api/v1/crates/walkdir/2.3.1/download -> rust-crates--walkdir-2.3.1.tar.gz
https://crates.io/api/v1/crates/want/0.3.0/download -> rust-crates--want-0.3.0.tar.gz
https://crates.io/api/v1/crates/wasi/0.10.1+wasi-snapshot-preview1/download -> rust-crates--wasi-0.10.1+wasi-snapshot-preview1.tar.gz
https://crates.io/api/v1/crates/wasi/0.11.0+wasi-snapshot-preview1/download -> rust-crates--wasi-0.11.0+wasi-snapshot-preview1.tar.gz
https://crates.io/api/v1/crates/wasi/0.9.0+wasi-snapshot-preview1/download -> rust-crates--wasi-0.9.0+wasi-snapshot-preview1.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen/0.2.70/download -> rust-crates--wasm-bindgen-0.2.70.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen-backend/0.2.70/download -> rust-crates--wasm-bindgen-backend-0.2.70.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen-futures/0.4.20/download -> rust-crates--wasm-bindgen-futures-0.4.20.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen-macro/0.2.70/download -> rust-crates--wasm-bindgen-macro-0.2.70.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen-macro-support/0.2.70/download -> rust-crates--wasm-bindgen-macro-support-0.2.70.tar.gz
https://crates.io/api/v1/crates/wasm-bindgen-shared/0.2.70/download -> rust-crates--wasm-bindgen-shared-0.2.70.tar.gz
https://crates.io/api/v1/crates/web-sys/0.3.47/download -> rust-crates--web-sys-0.3.47.tar.gz
https://crates.io/api/v1/crates/webpki/0.21.4/download -> rust-crates--webpki-0.21.4.tar.gz
https://crates.io/api/v1/crates/webpki/0.22.0/download -> rust-crates--webpki-0.22.0.tar.gz
https://crates.io/api/v1/crates/webpki-roots/0.21.1/download -> rust-crates--webpki-roots-0.21.1.tar.gz
https://crates.io/api/v1/crates/which/4.3.0/download -> rust-crates--which-4.3.0.tar.gz
https://crates.io/api/v1/crates/winapi/0.3.9/download -> rust-crates--winapi-0.3.9.tar.gz
https://crates.io/api/v1/crates/winapi-i686-pc-windows-gnu/0.4.0/download -> rust-crates--winapi-i686-pc-windows-gnu-0.4.0.tar.gz
https://crates.io/api/v1/crates/winapi-util/0.1.5/download -> rust-crates--winapi-util-0.1.5.tar.gz
https://crates.io/api/v1/crates/winapi-x86_64-pc-windows-gnu/0.4.0/download -> rust-crates--winapi-x86_64-pc-windows-gnu-0.4.0.tar.gz
https://crates.io/api/v1/crates/windows-sys/0.36.1/download -> rust-crates--windows-sys-0.36.1.tar.gz
https://crates.io/api/v1/crates/windows_aarch64_msvc/0.36.1/download -> rust-crates--windows_aarch64_msvc-0.36.1.tar.gz
https://crates.io/api/v1/crates/windows_i686_gnu/0.36.1/download -> rust-crates--windows_i686_gnu-0.36.1.tar.gz
https://crates.io/api/v1/crates/windows_i686_msvc/0.36.1/download -> rust-crates--windows_i686_msvc-0.36.1.tar.gz
https://crates.io/api/v1/crates/windows_x86_64_gnu/0.36.1/download -> rust-crates--windows_x86_64_gnu-0.36.1.tar.gz
https://crates.io/api/v1/crates/windows_x86_64_msvc/0.36.1/download -> rust-crates--windows_x86_64_msvc-0.36.1.tar.gz
https://crates.io/api/v1/crates/winreg/0.7.0/download -> rust-crates--winreg-0.7.0.tar.gz
"

bazel_external_uris2="
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/action/svg/production/ic_get_app_24px.svg -> material-design-icons-action-svg-production--ic_get_app_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/action/svg/production/ic_visibility_off_24px.svg -> material-design-icons-action-svg-production--ic_visibility_off_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/content/svg/production/ic_clear_24px.svg -> material-design-icons-content-svg-production--ic_clear_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/content/svg/production/ic_flag_24px.svg -> material-design-icons-content-svg-production--ic_flag_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/navigation/svg/production/ic_cancel_24px.svg -> material-design-icons-navigation-svg-production--ic_cancel_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/navigation/svg/production/ic_chevron_left_24px.svg -> material-design-icons-navigation-svg-production--ic_chevron_left_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/navigation/svg/production/ic_chevron_right_24px.svg -> material-design-icons-navigation-svg-production--ic_chevron_right_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/navigation/svg/production/ic_expand_less_24px.svg -> material-design-icons-navigation-svg-production--ic_expand_less_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}/navigation/svg/production/ic_expand_more_24px.svg -> material-design-icons-navigation-svg-production--ic_expand_more_24px-${EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_change_history_24px.svg -> material-design-icons-action-svg-production--ic_change_history_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_group_work_24px.svg -> material-design-icons-action-svg-production--ic_group_work_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_help_outline_24px.svg -> material-design-icons-action-svg-production--ic_help_outline_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_info_outline_24px.svg -> material-design-icons-action-svg-production--ic_info_outline_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_search_24px.svg -> material-design-icons-action-svg-production--ic_search_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/action/svg/production/ic_settings_24px.svg -> material-design-icons-action-svg-production--ic_settings_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/alert/svg/production/ic_error_24px.svg -> material-design-icons-alert-svg-production--ic_error_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/content/svg/production/ic_content_copy_24px.svg -> material-design-icons-content-svg-production--ic_content_copy_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/navigation/svg/production/ic_arrow_downward_24px.svg -> material-design-icons-navigation-svg-production--ic_arrow_downward_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/navigation/svg/production/ic_arrow_upward_24px.svg -> material-design-icons-navigation-svg-production--ic_arrow_upward_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_1_PV}/navigation/svg/production/ic_refresh_24px.svg -> material-design-icons-navigation-svg-production--ic_refresh_24px-${MATERIAL_DESIGN_ICONS_3_0_1_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_2_PV}/action/svg/production/ic_done_24px.svg -> material-design-icons-action-svg-production--ic_done_24px-${MATERIAL_DESIGN_ICONS_3_0_2_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${MATERIAL_DESIGN_ICONS_3_0_2_PV}/image/svg/production/ic_palette_24px.svg -> material-design-icons-image-svg-production--ic_palette_24px-${MATERIAL_DESIGN_ICONS_3_0_2_PV}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT}/src/device/dark_mode/materialicons/24px.svg -> material-design-icons-src-device-dark_mode-materialicons--dark_mode_24px-${EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT}/src/device/light_mode/materialicons/24px.svg -> material-design-icons-src-device-light_mode-materialicons--light_mode_24px-${EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/action/bug_report/materialicons/24px.svg -> material-design-icons-src-action-bug_report-materialicons--bug_report_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/action/filter_alt/materialicons/24px.svg -> material-design-icons-src-action-filter_alt-materialicons--filter_alt_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/action/line_weight/materialicons/24px.svg -> material-design-icons-src-action-line_weight-materialicons--line_weight_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/action/settings_backup_restore/materialicons/24px.svg -> material-design-icons-src-action-settings_backup_restore-materialicons--settings_backup_restore_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/action/settings_overscan/materialicons/24px.svg -> material-design-icons-src-action-settings_overscan-materialicons--settings_overscan_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/alert/warning/materialicons/24px.svg -> material-design-icons-src-alert-warning-materialicons--warning_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/content/push_pin/materialicons/24px.svg -> material-design-icons-src-content-push_pin-materialicons--keep_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/content/push_pin/materialiconsoutlined/24px.svg -> material-design-icons-src-content-push_pin-materialiconsoutlined--keep_outline_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/image/image_search/materialicons/24px.svg -> material-design-icons-src-image-image_search-materialicons--image_search_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/navigation/close/materialicons/24px.svg -> material-design-icons-src-navigation-close-materialicons--close_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/navigation/fullscreen/materialicons/24px.svg -> material-design-icons-src-navigation-fullscreen-materialicons--fullscreen_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/navigation/fullscreen_exit/materialicons/24px.svg -> material-design-icons-src-navigation-fullscreen_exit-materialicons--fullscreen_exit_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}/src/navigation/more_vert/materialicons/24px.svg -> material-design-icons-src-navigation-more_vert-materialicons--more_vert_24px-${EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}/src/action/drag_indicator/materialicons/24px.svg -> material-design-icons-src-action-drag_indicator-materialicons--drag_indicator_24px-${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}/src/image/brightness_6/materialicons/24px.svg -> material-design-icons-src-image-brightness_6-materialicons--brightness_6_24px-${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}/src/image/edit/materialicons/24px.svg -> material-design-icons-src-image-edit-materialicons--edit_24px-${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}.svg
https://raw.githubusercontent.com/google/material-design-icons/${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}/src/social/notifications_none/materialicons/24px.svg -> material-design-icons-src-social-notifications_none-materialicons--notifications_none_24px-${EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT}.svg
"
bazel_external_uris="
https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_PV}/chromedriver_linux64.zip -> chromedriver_linux64-${CHROMEDRIVER_PV}.zip
https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${CHROMIUM_REV}/chrome-linux.zip -> chrome-linux-x64-${CHROMIUM_REV}.zip
https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-${WEBENCODINGS_PV}.tar.gz
https://files.pythonhosted.org/packages/59/2d/b24bab64b409e22f026fee6705b035cb0698399a7b69449c49442b30af47/Werkzeug-${WERKZUG_PV}.tar.gz
https://fonts.gstatic.com/s/roboto/v18/-L14Jk06m6pUHB-5mXQQnYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/0eC6fl06luXEYWpBSJvXCIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/1hZf02POANh32k2VkgEoUBkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/roboto/v18/77FXFjRbGzN4aCrSFhlh3oX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at14sYYdJg5dU2qzJEVSuta0.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at1BW26QxpSj-_ZKm_xT4hWw.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at4gp9Q8gbYrhqGlRav_IXfk.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at6E8kM4xWR1_1bYURRojRGc.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at9DiNsR5a-9Oe_Ivpu8XWlY.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0at_ZraR2Tg8w2lzm7kLNL0-w.woff2
https://fonts.gstatic.com/s/roboto/v18/7m8l7TlFO-S3VkhHuR0atwt_Rm691LTebKfY2ZkKSmI.woff2
https://fonts.gstatic.com/s/roboto/v18/97uahxiqZRoncBaCEI3aW4X0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/Fl4y0QdOxyyTHEGMXX8kcYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/Hgo13k-tfSpn0qi1SFdUfZBw1xU1rKptJj_0jans920.woff2
https://fonts.gstatic.com/s/roboto/v18/I3S1wsgSg9YCurV6PUkTOYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/K23cxWVTrIFD6DJsEVi07RkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/roboto/v18/Ks_cVxiCiwUWVsFWFA3Bjn-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/NJ4vxlgWwWbEsv18dAhqnn-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/NYDWBdD4gIq26G5XYbHsFIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0Qt_Rm691LTebKfY2ZkKSmI.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0V4sYYdJg5dU2qzJEVSuta0.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0VBW26QxpSj-_ZKm_xT4hWw.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0Ygp9Q8gbYrhqGlRav_IXfk.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0aE8kM4xWR1_1bYURRojRGc.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0dDiNsR5a-9Oe_Ivpu8XWlY.woff2
https://fonts.gstatic.com/s/roboto/v18/OLffGBTaF0XFOW1gnuHF0fZraR2Tg8w2lzm7kLNL0-w.woff2
https://fonts.gstatic.com/s/roboto/v18/OpXUqTo0UgQQhGj_SFdLWBkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/roboto/v18/Pru33qjShpZSmG3z6VYwnYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/PwZc-YbIL414wB9rB1IAPYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/RxZJdnzeo3R5zSexge8UUZBw1xU1rKptJj_0jans920.woff2
https://fonts.gstatic.com/s/roboto/v18/UX6i4JxQDm3fVTc1CPuwqoX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/WxrXJa0C3KdtC7lMafG4dRkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/roboto/v18/ZLqKeelYbATG60EpZBSDy4X0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/_VYFx-s824kXq_Ul2BHqYH-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/cDKhRaXnQTOVbaoxwdOr9xkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/roboto/v18/d-6IYplOFocCacKzxwXSOJBw1xU1rKptJj_0jans920.woff2
https://fonts.gstatic.com/s/roboto/v18/isZ-wbCXNKAbnjo6_TwHToX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/jSN2CGVDbcVyCnfJfjSdfIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/mbmhprMH69Zi6eEPBYVFhYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/mx9Uck6uB63VIKFYnEMXrYX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/oHi30kwQWvpCWqAhzHcCSIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/oMMgfZMQthOryQo9n22dcuvvDin1pK8aKteLpeZ5c0A.woff2
https://fonts.gstatic.com/s/roboto/v18/oOeFwZNlrTefzLYmlVV1UIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/rGvHdJnr2l75qb0YND9NyIX0hVgzZQUfRDuZrPvH3D8.woff2
https://fonts.gstatic.com/s/roboto/v18/sTdaA6j0Psb920Vjv-mrzH-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC14sYYdJg5dU2qzJEVSuta0.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC1BW26QxpSj-_ZKm_xT4hWw.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC4gp9Q8gbYrhqGlRav_IXfk.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC6E8kM4xWR1_1bYURRojRGc.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC9DiNsR5a-9Oe_Ivpu8XWlY.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcC_ZraR2Tg8w2lzm7kLNL0-w.woff2
https://fonts.gstatic.com/s/roboto/v18/t6Nd4cfPRhZP44Q5QAjcCwt_Rm691LTebKfY2ZkKSmI.woff2
https://fonts.gstatic.com/s/roboto/v18/tnj4SB6DNbdaQnsM8CFqBX-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/uYECMKoHcO9x1wdmbyHIm3-_kf6ByYO6CLYdB4HQE-Y.woff2
https://fonts.gstatic.com/s/roboto/v18/vPcynSL0qHq_6dX7lKVByXYhjbSpvc47ee6xR_80Hnw.woff2
https://fonts.gstatic.com/s/roboto/v18/vSzulfKSK0LLjjfeaxcREhkAz4rYn47Zy2rvigWQf6w.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fz1T7aJLK6nKpn36IMwTcMMc.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fz1x-M1I1w5OMiqnVF8xBLhU.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fz4gd9OEPUCN3AdYW0e8tat4.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fz8bIQSYZnWLaWC9QNCpTK_U.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fz_79_ZuUxCigM2DespTnFaw.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59FzwXaAXup5mZlfK6xRLrhsco.woff2
https://fonts.gstatic.com/s/robotomono/v5/N4duVc9C58uwPiY8_59Fzwn6Wqxo-xwxilDXPU8chVU.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY14sYYdJg5dU2qzJEVSuta0.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY1BW26QxpSj-_ZKm_xT4hWw.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY4gp9Q8gbYrhqGlRav_IXfk.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY6E8kM4xWR1_1bYURRojRGc.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY9DiNsR5a-9Oe_Ivpu8XWlY.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpY_ZraR2Tg8w2lzm7kLNL0-w.woff2
https://fonts.gstatic.com/s/robotomono/v5/hMqPNLsu_dywMa4C_DEpYwt_Rm691LTebKfY2ZkKSmI.woff2
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-gazelle/releases/download/v${BAZEL_GAZELLE_PV}/bazel-gazelle-v${BAZEL_GAZELLE_PV}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_RULES_CLOSURE_COMMIT}.tar.gz -> rules_closure-${EGIT_RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_go/releases/download/v${RULES_GO_PV}/rules_go-v${RULES_GO_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_RULES_JAVA_COMMIT}.tar.gz -> rules_java-${EGIT_RULES_JAVA_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_nodejs/releases/download/${RULES_NODEJS_PV}/rules_nodejs-${RULES_NODEJS_PV}.tar.gz
https://github.com/bazelbuild/rules_nodejs/releases/download/${RULES_NODEJS_CORE_PV}/rules_nodejs-core-${RULES_NODEJS_CORE_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_python/archive/${EGIT_RULES_PYTHON_COMMIT}.tar.gz -> rules_python-${EGIT_RULES_PYTHON_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_rust/archive/${EGIT_RULES_RUST_COMMIT}.tar.gz -> rules_rust-${EGIT_RULES_RUST_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_sass/archive/${RULES_SASS_PV}.zip -> rules_sass-${RULES_SASS_PV}.zip
https://github.com/bazelbuild/rules_webtesting/releases/download/${RULES_WEBTESTING_PV}/rules_webtesting.tar.gz -> rules_webtesting-${RULES_WEBTESTING_PV}.tar.gz
https://github.com/envoyproxy/data-plane-api/archive/${EGIT_DATA_PLANE_API_COMMIT}.tar.gz -> data-plane-api-${EGIT_DATA_PLANE_API_COMMIT}.tar.gz
https://github.com/envoyproxy/protoc-gen-validate/archive/${EGIT_PROTOC_GEN_VALIDATE_COMMIT}.tar.gz -> protoc-gen-validate-${EGIT_PROTOC_GEN_VALIDATE_COMMIT}.tar.gz
https://github.com/google/closure-library/archive/v20191027.tar.gz -> closure-library-${CLOSURE_LIBRARY_PV}.tar.gz
https://github.com/googleapis/googleapis/archive/${EGIT_GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${EGIT_GOOGLEAPIS_COMMIT}.tar.gz
https://github.com/mozilla/bleach/archive/v2.0.tar.gz -> bleach-${BLEACH_PV}.tar.gz
https://github.com/protocolbuffers/upb/archive/${EGIT_UPB_COMMIT}.tar.gz -> upb-${EGIT_UPB_COMMIT}.tar.gz
https://github.com/yarnpkg/yarn/releases/download/v${YARN_PV}/yarn-v${YARN_PV}.tar.gz
http://mirror.tensorflow.org/github.com/bazelbuild/bazel-skylib/archive/${BAZEL_SKYLIB_PV}.tar.gz -> tf-bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
http://mirror.tensorflow.org/github.com/grpc/grpc/archive/v${GRPC_PV}.tar.gz -> grpc-${GRPC_PV}.tar.gz
http://mirror.tensorflow.org/github.com/html5lib/html5lib-python/archive/${HTML5LIB_PYTHON_PV}.tar.gz -> html5lib-python-${HTML5LIB_PYTHON_PV}.tar.gz
http://mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.tar.gz -> protobuf-${PROTOBUF_PV}.tar.gz
https://nodejs.org/dist/v${NODE_PV}/node-v${NODE_PV}-linux-x64.tar.xz
https://pypi.python.org/packages/1d/25/3f6d2cb31ec42ca5bd3bfbea99b63892b735d76e26f20dd2dcc34ffe4f0d/Markdown-${MARKDOWN_PV}.tar.gz
https://raw.githubusercontent.com/google/roboto/${EGIT_ROBOTO_COMMIT}/LICENSE -> roboto-${EGIT_ROBOTO_COMMIT}-LICENSE
"
SRC_URI="
	${YARN_EXTERNAL_URIS}
	${bazel_external_uris}
	${bazel_external_uris2}
	${rust_crates_uris}
https://github.com/tensorflow/tensorboard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

yarn-utils_cpy_yarn_tarballs() {
	local dest="${WORKDIR}/npm-packages-offline-cache"
	mkdir -p "${dest}" || die
	IFS=$'\n'
	local uri
	for uri in ${YARN_EXTERNAL_URIS} ; do
		local bn
		if [[ "${uri}" =~ "->" && "${uri}" =~ ".git" ]] ; then
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			local fn="${bn/yarnpkg-}"
			fn="${fn/.tgz}"
			local path=$(mktemp -d -p "${T}")
			pushd "${path}" || die
				tar --strip-components=1 -xvf "${DISTDIR}/${bn}" || die
				tar -cf "${dest}/${fn}" * || die
			popd
			rm -rf "${path}" || die
		else
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			cat "${DISTDIR}/${bn}" > "${dest}/${bn/yarnpkg-}" || die
		fi
	done
	IFS=$' \t\n'
}

cp_material_icons() {
	local dest="${T}/bazel-distdir"
	IFS=$'\n'
	local path
	for path in ${bazel_external_uris2} ; do
		local srcfn=$(echo "${path}" \
			| cut -f 3 -d " ")
		local destfn=$(echo "${path}" \
			| cut -f 3 -d " " \
			| sed -E \
				-e "s|.*--||g" \
				-e "s|-[0-9]\.[0-9]\.[0-9]||g" \
				-e "s|-[a-zA-Z0-9]{40}||g")
einfo "Copying ${DISTDIR}/${srcfn} -> ${dest}/${destfn}"
		cat "${DISTDIR}/${srcfn}" > "${dest}/${destfn}" || die
	done
	IFS=$' \t\n'
}

cp_rust_crates() {
	local dest="${T}/bazel-distdir"
	mkdir -p "${dest}" || die
	IFS=$'\n'
	local path
	for path in ${rust_crates_uris} ; do
		local srcfn=$(echo "${path}" \
			| cut -f 3 -d " ")
		local destfn=$(echo "${path}" \
			| cut -f 3 -d " " \
			| sed -E \
				-e "s|.*--||g")
einfo "Copying ${DISTDIR}/${srcfn} -> ${dest}/${destfn}"
		cat "${DISTDIR}/${srcfn}" > "${dest}/${destfn}" || die
	done
	IFS=$' \t\n'

}

src_unpack() {
	unpack ${P}.tar.gz
	bazel_load_distfiles "${bazel_external_uris}"
	yarn-utils_cpy_yarn_tarballs
	cp_material_icons
	cp_rust_crates
	cd "${S}" || die
	yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
	cp "${HOME}/.yarnrc" "${WORKDIR}" || die
}

src_prepare() {
	default
	export JAVA_HOME=$(java-config --jre-home)
	eapply "${FILESDIR}/tensorboard-2.11.2-yarn-local-cache.patch"
	eapply "${FILESDIR}/tensorboard-2.11.2-use-system-go.patch"
	sed -i -e "s|\.yarnrc|${WORKDIR}/.yarnrc|g" WORKSPACE || die
	sed -i -e "s|\.cache/yarn2|${HOME}/.cache/yarn2|g" WORKSPACE || die
	bazel_setup_bazelrc
}

src_configure() {
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local slot
	for slot in 6 5 4 ; do
		if has_version "dev-util/bazel:${slot}" ; then
einfo "Detected dev-util/bazel:${slot} (multislot)"
			ln -sf \
				"${ESYSROOT}/usr/bin/bazel-${slot}" \
				"${WORKDIR}/bin/bazel" \
				|| die
			has_multislot_bazel=1
			bazel --version || die
			break
		fi
	done
	if (( ${has_multislot_bazel} == 0 )) ; then
ewarn
ewarn "Using unslotted bazel.  Use the one from the oiledmachine-overlay"
ewarn "instead or downgrade to bazel < 7"
ewarn
	fi
}

# From bazel.eclass
_ebazel() {
	# Use different build folders for each multibuild variant.
	local output_base="${BUILD_DIR:-${S}}"
	output_base="${output_base%/}-bazel-base"
	mkdir -p "${output_base}" || die

	export GOROOT="${ESYSROOT}/usr/lib/go"
	echo 'build --noshow_progress' >> "${T}/bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${T}/bazelrc" || die # Increase verbosity

	echo "build --action_env=GOROOT=\"${GOROOT}\"" >> "${T}/bazelrc" || die
	echo "build --host_action_env=GOROOT=\"${GOROOT}\"" >> "${T}/bazelrc" || die
	echo "build --@io_bazel_rules_go//go/toolchain:sdk_version=\"1.14.15\"" >> "${T}/bazelrc" || die

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		local ccache_dir=$(ccache -sv \
			| grep "Cache directory" \
			| cut -f 2 -d ":" \
			| sed -r -e "s|^[ ]+||g")
		echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to ${T}/bazelrc"
		echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc" || die
		echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc" || die
		echo "build --sandbox_writable_path=${ccache_dir}" >> "${T}/bazelrc" || die
		export CCACHE_DIR="${ccache_dir}"
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
	fi

	cat "${S}/.bazelrc" >> "${T}/bazelrc" || die
	rm "${S}/.bazelrc" || die

	set -- bazel --bazelrc="${T}/bazelrc" --output_base="${output_base}" ${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

src_compile() {
	_ebazel build \
		//tensorboard/...
}

# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
