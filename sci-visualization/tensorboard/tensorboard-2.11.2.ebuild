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
# See https://github.com/tensorflow/tensorboard/blob/2.11.2/tensorboard/pip_package/requirements.txt
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
		>=dev-python/grpcio-1.24.3[${PYTHON_USEDEP}]
		testing-tensorflow? (
			<dev-python/grpcio-1.49.3[${PYTHON_USEDEP}]
		)
	)
	(
		<dev-python/protobuf-python-4[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.9.2[${PYTHON_USEDEP}]
		testing-tensorflow? (
			<dev-python/protobuf-python-3.21[${PYTHON_USEDEP}]
		)
	)
	(
		<dev-python/requests-3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
	)
	(
		<sci-visualization/tensorboard-data-server-0.7[${PYTHON_USEDEP},testing-tensorflow=]
		>=sci-visualization/tensorboard-data-server-0.6[${PYTHON_USEDEP},testing-tensorflow=]
	)
	>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.6.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
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
		<dev-util/bazel-6
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
https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.0.tgz -> yarnpkg-@ampproject-remapping-2.2.0.tgz
https://registry.yarnpkg.com/@angular-devkit/architect/-/architect-0.1202.17.tgz -> yarnpkg-@angular-devkit-architect-0.1202.17.tgz
https://registry.yarnpkg.com/@angular-devkit/core/-/core-12.2.17.tgz -> yarnpkg-@angular-devkit-core-12.2.17.tgz
https://registry.yarnpkg.com/@angular-devkit/schematics/-/schematics-12.2.17.tgz -> yarnpkg-@angular-devkit-schematics-12.2.17.tgz
https://registry.yarnpkg.com/@angular/animations/-/animations-12.2.16.tgz -> yarnpkg-@angular-animations-12.2.16.tgz
https://registry.yarnpkg.com/@angular/cdk/-/cdk-12.2.13.tgz -> yarnpkg-@angular-cdk-12.2.13.tgz
https://registry.yarnpkg.com/@angular/cli/-/cli-12.2.17.tgz -> yarnpkg-@angular-cli-12.2.17.tgz
https://registry.yarnpkg.com/@angular/common/-/common-12.2.16.tgz -> yarnpkg-@angular-common-12.2.16.tgz
https://registry.yarnpkg.com/@angular/compiler-cli/-/compiler-cli-12.2.16.tgz -> yarnpkg-@angular-compiler-cli-12.2.16.tgz
https://registry.yarnpkg.com/@angular/compiler/-/compiler-12.2.16.tgz -> yarnpkg-@angular-compiler-12.2.16.tgz
https://registry.yarnpkg.com/@angular/core/-/core-12.2.16.tgz -> yarnpkg-@angular-core-12.2.16.tgz
https://registry.yarnpkg.com/@angular/forms/-/forms-12.2.16.tgz -> yarnpkg-@angular-forms-12.2.16.tgz
https://registry.yarnpkg.com/@angular/localize/-/localize-12.2.16.tgz -> yarnpkg-@angular-localize-12.2.16.tgz
https://registry.yarnpkg.com/@angular/material/-/material-12.2.13.tgz -> yarnpkg-@angular-material-12.2.13.tgz
https://registry.yarnpkg.com/@angular/platform-browser-dynamic/-/platform-browser-dynamic-12.2.16.tgz -> yarnpkg-@angular-platform-browser-dynamic-12.2.16.tgz
https://registry.yarnpkg.com/@angular/platform-browser/-/platform-browser-12.2.16.tgz -> yarnpkg-@angular-platform-browser-12.2.16.tgz
https://registry.yarnpkg.com/@angular/router/-/router-12.2.16.tgz -> yarnpkg-@angular-router-12.2.16.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.18.6.tgz -> yarnpkg-@babel-code-frame-7.18.6.tgz
https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.18.6.tgz -> yarnpkg-@babel-compat-data-7.18.6.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.18.6.tgz -> yarnpkg-@babel-core-7.18.6.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.8.3.tgz -> yarnpkg-@babel-core-7.8.3.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.18.6.tgz -> yarnpkg-@babel-generator-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.18.6.tgz -> yarnpkg-@babel-helper-compilation-targets-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.18.6.tgz -> yarnpkg-@babel-helper-environment-visitor-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.18.6.tgz -> yarnpkg-@babel-helper-function-name-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.18.6.tgz -> yarnpkg-@babel-helper-hoist-variables-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.18.6.tgz -> yarnpkg-@babel-helper-module-imports-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.18.6.tgz -> yarnpkg-@babel-helper-module-transforms-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.18.6.tgz -> yarnpkg-@babel-helper-simple-access-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.18.6.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.18.6.tgz -> yarnpkg-@babel-helper-validator-identifier-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.18.6.tgz -> yarnpkg-@babel-helper-validator-option-7.18.6.tgz
https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.18.6.tgz -> yarnpkg-@babel-helpers-7.18.6.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz -> yarnpkg-@babel-highlight-7.18.6.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.18.6.tgz -> yarnpkg-@babel-parser-7.18.6.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.18.6.tgz -> yarnpkg-@babel-template-7.18.6.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.18.6.tgz -> yarnpkg-@babel-traverse-7.18.6.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.18.6.tgz -> yarnpkg-@babel-types-7.18.6.tgz
https://registry.yarnpkg.com/@bazel/concatjs/-/concatjs-5.7.0.tgz -> yarnpkg-@bazel-concatjs-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/esbuild/-/esbuild-5.7.0.tgz -> yarnpkg-@bazel-esbuild-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/ibazel/-/ibazel-0.15.10.tgz -> yarnpkg-@bazel-ibazel-0.15.10.tgz
https://registry.yarnpkg.com/@bazel/jasmine/-/jasmine-5.7.0.tgz -> yarnpkg-@bazel-jasmine-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/typescript/-/typescript-5.7.0.tgz -> yarnpkg-@bazel-typescript-5.7.0.tgz
https://registry.yarnpkg.com/@bazel/worker/-/worker-5.7.0.tgz -> yarnpkg-@bazel-worker-5.7.0.tgz
https://registry.yarnpkg.com/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> yarnpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.yarnpkg.com/@gar/promisify/-/promisify-1.1.3.tgz -> yarnpkg-@gar-promisify-1.1.3.tgz
https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.3.tgz -> yarnpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.1.1.tgz -> yarnpkg-@jridgewell-gen-mapping-0.1.1.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.2.tgz -> yarnpkg-@jridgewell-gen-mapping-0.3.2.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.0.8.tgz -> yarnpkg-@jridgewell-resolve-uri-3.0.8.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz -> yarnpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.14.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.14.tgz
https://registry.yarnpkg.com/@ngrx/effects/-/effects-12.5.1.tgz -> yarnpkg-@ngrx-effects-12.5.1.tgz
https://registry.yarnpkg.com/@ngrx/store/-/store-12.5.1.tgz -> yarnpkg-@ngrx-store-12.5.1.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-1.1.1.tgz -> yarnpkg-@npmcli-fs-1.1.1.tgz
https://registry.yarnpkg.com/@npmcli/git/-/git-2.1.0.tgz -> yarnpkg-@npmcli-git-2.1.0.tgz
https://registry.yarnpkg.com/@npmcli/installed-package-contents/-/installed-package-contents-1.0.7.tgz -> yarnpkg-@npmcli-installed-package-contents-1.0.7.tgz
https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-1.1.2.tgz -> yarnpkg-@npmcli-move-file-1.1.2.tgz
https://registry.yarnpkg.com/@npmcli/node-gyp/-/node-gyp-1.0.3.tgz -> yarnpkg-@npmcli-node-gyp-1.0.3.tgz
https://registry.yarnpkg.com/@npmcli/promise-spawn/-/promise-spawn-1.3.2.tgz -> yarnpkg-@npmcli-promise-spawn-1.3.2.tgz
https://registry.yarnpkg.com/@npmcli/run-script/-/run-script-2.0.0.tgz -> yarnpkg-@npmcli-run-script-2.0.0.tgz
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
https://registry.yarnpkg.com/@schematics/angular/-/angular-12.2.17.tgz -> yarnpkg-@schematics-angular-12.2.17.tgz
https://registry.yarnpkg.com/@socket.io/base64-arraybuffer/-/base64-arraybuffer-1.0.2.tgz -> yarnpkg-@socket.io-base64-arraybuffer-1.0.2.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-backend-cpu/-/tfjs-backend-cpu-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-backend-cpu-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-backend-webgl/-/tfjs-backend-webgl-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-backend-webgl-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-converter/-/tfjs-converter-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-converter-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-core/-/tfjs-core-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-core-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-data/-/tfjs-data-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-data-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs-layers/-/tfjs-layers-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-layers-3.4.0.tgz
https://registry.yarnpkg.com/@tensorflow/tfjs/-/tfjs-3.4.0.tgz -> yarnpkg-@tensorflow-tfjs-3.4.0.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-1.1.2.tgz -> yarnpkg-@tootallnate-once-1.1.2.tgz
https://registry.yarnpkg.com/@types/component-emitter/-/component-emitter-1.2.10.tgz -> yarnpkg-@types-component-emitter-1.2.10.tgz
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
https://registry.yarnpkg.com/@types/geojson/-/geojson-7946.0.7.tgz -> yarnpkg-@types-geojson-7946.0.7.tgz
https://registry.yarnpkg.com/@types/is-plain-object/-/is-plain-object-0.0.2.tgz -> yarnpkg-@types-is-plain-object-0.0.2.tgz
https://registry.yarnpkg.com/@types/is-windows/-/is-windows-1.0.0.tgz -> yarnpkg-@types-is-windows-1.0.0.tgz
https://registry.yarnpkg.com/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.3.tgz -> yarnpkg-@types-istanbul-lib-coverage-2.0.3.tgz
https://registry.yarnpkg.com/@types/jasmine/-/jasmine-3.8.2.tgz -> yarnpkg-@types-jasmine-3.8.2.tgz
https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.172.tgz -> yarnpkg-@types-lodash-4.14.172.tgz
https://registry.yarnpkg.com/@types/long/-/long-4.0.1.tgz -> yarnpkg-@types-long-4.0.1.tgz
https://registry.yarnpkg.com/@types/marked/-/marked-2.0.4.tgz -> yarnpkg-@types-marked-2.0.4.tgz
https://registry.yarnpkg.com/@types/node-fetch/-/node-fetch-2.5.10.tgz -> yarnpkg-@types-node-fetch-2.5.10.tgz
https://registry.yarnpkg.com/@types/node/-/node-10.17.60.tgz -> yarnpkg-@types-node-10.17.60.tgz
https://registry.yarnpkg.com/@types/node/-/node-16.6.0.tgz -> yarnpkg-@types-node-16.6.0.tgz
https://registry.yarnpkg.com/@types/offscreencanvas/-/offscreencanvas-2019.3.0.tgz -> yarnpkg-@types-offscreencanvas-2019.3.0.tgz
https://registry.yarnpkg.com/@types/offscreencanvas/-/offscreencanvas-2019.6.3.tgz -> yarnpkg-@types-offscreencanvas-2019.6.3.tgz
https://registry.yarnpkg.com/@types/requirejs/-/requirejs-2.1.33.tgz -> yarnpkg-@types-requirejs-2.1.33.tgz
https://registry.yarnpkg.com/@types/resize-observer-browser/-/resize-observer-browser-0.1.6.tgz -> yarnpkg-@types-resize-observer-browser-0.1.6.tgz
https://registry.yarnpkg.com/@types/seedrandom/-/seedrandom-2.4.27.tgz -> yarnpkg-@types-seedrandom-2.4.27.tgz
https://registry.yarnpkg.com/@types/three/-/three-0.131.0.tgz -> yarnpkg-@types-three-0.131.0.tgz
https://registry.yarnpkg.com/@types/webgl-ext/-/webgl-ext-0.0.30.tgz -> yarnpkg-@types-webgl-ext-0.0.30.tgz
https://registry.yarnpkg.com/@types/webgl2/-/webgl2-0.0.5.tgz -> yarnpkg-@types-webgl2-0.0.5.tgz
https://registry.yarnpkg.com/@types/webgl2/-/webgl2-0.0.6.tgz -> yarnpkg-@types-webgl2-0.0.6.tgz
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
https://registry.yarnpkg.com/@webcomponents/shadycss/-/shadycss-1.10.2.tgz -> yarnpkg-@webcomponents-shadycss-1.10.2.tgz
https://registry.yarnpkg.com/@xmldom/xmldom/-/xmldom-0.7.5.tgz -> yarnpkg-@xmldom-xmldom-0.7.5.tgz
https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> yarnpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/accepts/-/accepts-1.3.7.tgz -> yarnpkg-accepts-1.3.7.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/agentkeepalive/-/agentkeepalive-4.2.1.tgz -> yarnpkg-agentkeepalive-4.2.1.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv-formats/-/ajv-formats-2.1.0.tgz -> yarnpkg-ajv-formats-2.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.11.0.tgz -> yarnpkg-ajv-8.11.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.6.2.tgz -> yarnpkg-ajv-8.6.2.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> yarnpkg-ansi-escapes-4.3.2.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz -> yarnpkg-anymatch-3.1.2.tgz
https://registry.yarnpkg.com/aproba/-/aproba-2.0.0.tgz -> yarnpkg-aproba-2.0.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-3.0.0.tgz -> yarnpkg-are-we-there-yet-3.0.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/base64id/-/base64id-2.0.0.tgz -> yarnpkg-base64id-2.0.0.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/bl/-/bl-4.1.0.tgz -> yarnpkg-bl-4.1.0.tgz
https://registry.yarnpkg.com/body-parser/-/body-parser-1.19.0.tgz -> yarnpkg-body-parser-1.19.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.21.0.tgz -> yarnpkg-browserslist-4.21.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz -> yarnpkg-buffer-from-1.1.1.tgz
https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz -> yarnpkg-buffer-5.7.1.tgz
https://registry.yarnpkg.com/builtins/-/builtins-1.0.3.tgz -> yarnpkg-builtins-1.0.3.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.0.tgz -> yarnpkg-bytes-3.1.0.tgz
https://registry.yarnpkg.com/c8/-/c8-7.5.0.tgz -> yarnpkg-c8-7.5.0.tgz
https://registry.yarnpkg.com/cacache/-/cacache-15.3.0.tgz -> yarnpkg-cacache-15.3.0.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001359.tgz -> yarnpkg-caniuse-lite-1.0.30001359.tgz
https://registry.yarnpkg.com/canonical-path/-/canonical-path-1.0.0.tgz -> yarnpkg-canonical-path-1.0.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz -> yarnpkg-chownr-2.0.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-3.1.0.tgz -> yarnpkg-cli-cursor-3.1.0.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.6.1.tgz -> yarnpkg-cli-spinners-2.6.1.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-3.0.0.tgz -> yarnpkg-cli-width-3.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz -> yarnpkg-clone-1.0.4.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/colors/-/colors-1.4.0.tgz -> yarnpkg-colors-1.4.0.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-9.3.0.tgz -> yarnpkg-commander-9.3.0.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/connect/-/connect-3.7.0.tgz -> yarnpkg-connect-3.7.0.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/content-type/-/content-type-1.0.4.tgz -> yarnpkg-content-type-1.0.4.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.8.0.tgz -> yarnpkg-convert-source-map-1.8.0.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.4.1.tgz -> yarnpkg-cookie-0.4.1.tgz
https://registry.yarnpkg.com/core-js/-/core-js-3.12.1.tgz -> yarnpkg-core-js-3.12.1.tgz
https://registry.yarnpkg.com/cors/-/cors-2.8.5.tgz -> yarnpkg-cors-2.8.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
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
https://registry.yarnpkg.com/date-format/-/date-format-4.0.3.tgz -> yarnpkg-date-format-4.0.3.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.2.tgz -> yarnpkg-debug-4.3.2.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/defaults/-/defaults-1.0.3.tgz -> yarnpkg-defaults-1.0.3.tgz
https://registry.yarnpkg.com/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> yarnpkg-define-lazy-prop-2.0.0.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz -> yarnpkg-depd-1.1.2.tgz
https://registry.yarnpkg.com/dependency-graph/-/dependency-graph-0.11.0.tgz -> yarnpkg-dependency-graph-0.11.0.tgz
https://registry.yarnpkg.com/di/-/di-0.0.1.tgz -> yarnpkg-di-0.0.1.tgz
https://registry.yarnpkg.com/dom-serialize/-/dom-serialize-2.2.1.tgz -> yarnpkg-dom-serialize-2.2.1.tgz
https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz -> yarnpkg-ee-first-1.1.1.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.172.tgz -> yarnpkg-electron-to-chromium-1.4.172.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/encoding/-/encoding-0.1.13.tgz -> yarnpkg-encoding-0.1.13.tgz
https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-5.0.3.tgz -> yarnpkg-engine.io-parser-5.0.3.tgz
https://registry.yarnpkg.com/engine.io/-/engine.io-6.1.2.tgz -> yarnpkg-engine.io-6.1.2.tgz
https://registry.yarnpkg.com/ent/-/ent-2.2.0.tgz -> yarnpkg-ent-2.2.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/err-code/-/err-code-2.0.3.tgz -> yarnpkg-err-code-2.0.3.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz -> yarnpkg-escape-html-1.0.3.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.7.tgz -> yarnpkg-eventemitter3-4.0.7.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/figures/-/figures-3.2.0.tgz -> yarnpkg-figures-3.2.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.2.tgz -> yarnpkg-finalhandler-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> yarnpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.4.tgz -> yarnpkg-flatted-3.2.4.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.14.8.tgz -> yarnpkg-follow-redirects-1.14.8.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-2.0.0.tgz -> yarnpkg-foreground-child-2.0.0.tgz
https://registry.yarnpkg.com/form-data/-/form-data-3.0.1.tgz -> yarnpkg-form-data-3.0.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.0.0.tgz -> yarnpkg-fs-extra-10.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.1.tgz -> yarnpkg-fs-extra-7.0.1.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz -> yarnpkg-fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/furi/-/furi-2.0.0.tgz -> yarnpkg-furi-2.0.0.tgz
https://registry.yarnpkg.com/gauge/-/gauge-4.0.4.tgz -> yarnpkg-gauge-4.0.4.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz -> yarnpkg-glob-7.1.7.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/google-protobuf/-/google-protobuf-3.20.0.tgz -> yarnpkg-google-protobuf-3.20.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.10.tgz -> yarnpkg-graceful-fs-4.2.10.tgz
https://registry.yarnpkg.com/graphlib/-/graphlib-2.1.8.tgz -> yarnpkg-graphlib-2.1.8.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> yarnpkg-hosted-git-info-4.1.0.tgz
https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz -> yarnpkg-html-escaper-2.0.2.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz -> yarnpkg-http-cache-semantics-4.1.0.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.2.tgz -> yarnpkg-http-errors-1.7.2.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> yarnpkg-http-proxy-agent-4.0.1.tgz
https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.1.tgz -> yarnpkg-http-proxy-1.18.1.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/humanize-ms/-/humanize-ms-1.2.1.tgz -> yarnpkg-humanize-ms-1.2.1.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-4.0.1.tgz -> yarnpkg-ignore-walk-4.0.1.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz -> yarnpkg-inherits-2.0.3.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-2.0.0.tgz -> yarnpkg-ini-2.0.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-8.1.2.tgz -> yarnpkg-inquirer-8.1.2.tgz
https://registry.yarnpkg.com/ip/-/ip-1.1.8.tgz -> yarnpkg-ip-1.1.8.tgz
https://registry.yarnpkg.com/is-any-array/-/is-any-array-0.1.1.tgz -> yarnpkg-is-any-array-0.1.1.tgz
https://registry.yarnpkg.com/is-any-array/-/is-any-array-1.0.0.tgz -> yarnpkg-is-any-array-1.0.0.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.9.0.tgz -> yarnpkg-is-core-module-2.9.0.tgz
https://registry.yarnpkg.com/is-docker/-/is-docker-2.2.1.tgz -> yarnpkg-is-docker-2.2.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-interactive/-/is-interactive-1.0.0.tgz -> yarnpkg-is-interactive-1.0.0.tgz
https://registry.yarnpkg.com/is-lambda/-/is-lambda-1.0.1.tgz -> yarnpkg-is-lambda-1.0.1.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz -> yarnpkg-is-wsl-2.2.0.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.8.tgz -> yarnpkg-isbinaryfile-4.0.8.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.0.0.tgz -> yarnpkg-istanbul-lib-coverage-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> yarnpkg-istanbul-lib-report-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.0.2.tgz -> yarnpkg-istanbul-reports-3.0.2.tgz
https://registry.yarnpkg.com/jasmine-core/-/jasmine-core-3.8.0.tgz -> yarnpkg-jasmine-core-3.8.0.tgz
https://registry.yarnpkg.com/jasmine-reporters/-/jasmine-reporters-2.5.0.tgz -> yarnpkg-jasmine-reporters-2.5.0.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.1.tgz -> yarnpkg-json5-2.2.1.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.0.0.tgz -> yarnpkg-jsonc-parser-3.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz -> yarnpkg-jsonparse-1.3.1.tgz
https://registry.yarnpkg.com/karma-chrome-launcher/-/karma-chrome-launcher-3.1.0.tgz -> yarnpkg-karma-chrome-launcher-3.1.0.tgz
https://registry.yarnpkg.com/karma-firefox-launcher/-/karma-firefox-launcher-2.1.1.tgz -> yarnpkg-karma-firefox-launcher-2.1.1.tgz
https://registry.yarnpkg.com/karma-jasmine/-/karma-jasmine-4.0.1.tgz -> yarnpkg-karma-jasmine-4.0.1.tgz
https://registry.yarnpkg.com/karma-requirejs/-/karma-requirejs-1.1.0.tgz -> yarnpkg-karma-requirejs-1.1.0.tgz
https://registry.yarnpkg.com/karma-sourcemap-loader/-/karma-sourcemap-loader-0.3.8.tgz -> yarnpkg-karma-sourcemap-loader-0.3.8.tgz
https://registry.yarnpkg.com/karma/-/karma-6.3.16.tgz -> yarnpkg-karma-6.3.16.tgz
https://registry.yarnpkg.com/klaw-sync/-/klaw-sync-6.0.0.tgz -> yarnpkg-klaw-sync-6.0.0.tgz
https://registry.yarnpkg.com/lit-element/-/lit-element-2.5.1.tgz -> yarnpkg-lit-element-2.5.1.tgz
https://registry.yarnpkg.com/lit-html/-/lit-html-1.4.1.tgz -> yarnpkg-lit-html-1.4.1.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/log4js/-/log4js-6.4.1.tgz -> yarnpkg-log4js-6.4.1.tgz
https://registry.yarnpkg.com/long/-/long-4.0.0.tgz -> yarnpkg-long-4.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.25.7.tgz -> yarnpkg-magic-string-0.25.7.tgz
https://registry.yarnpkg.com/magic-string/-/magic-string-0.25.9.tgz -> yarnpkg-magic-string-0.25.9.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-9.1.0.tgz -> yarnpkg-make-fetch-happen-9.1.0.tgz
https://registry.yarnpkg.com/marked/-/marked-4.0.10.tgz -> yarnpkg-marked-4.0.10.tgz
https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz -> yarnpkg-media-typer-0.3.0.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-2.5.2.tgz -> yarnpkg-mime-2.5.2.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.6.tgz -> yarnpkg-minimist-1.2.6.tgz
https://registry.yarnpkg.com/minipass-collect/-/minipass-collect-1.0.2.tgz -> yarnpkg-minipass-collect-1.0.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-1.4.1.tgz -> yarnpkg-minipass-fetch-1.4.1.tgz
https://registry.yarnpkg.com/minipass-flush/-/minipass-flush-1.0.5.tgz -> yarnpkg-minipass-flush-1.0.5.tgz
https://registry.yarnpkg.com/minipass-json-stream/-/minipass-json-stream-1.0.1.tgz -> yarnpkg-minipass-json-stream-1.0.1.tgz
https://registry.yarnpkg.com/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> yarnpkg-minipass-pipeline-1.2.4.tgz
https://registry.yarnpkg.com/minipass-sized/-/minipass-sized-1.0.3.tgz -> yarnpkg-minipass-sized-1.0.3.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.3.tgz -> yarnpkg-minipass-3.3.3.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz -> yarnpkg-minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz -> yarnpkg-mkdirp-0.5.5.tgz
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
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.8.tgz -> yarnpkg-mute-stream-0.0.8.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.2.tgz -> yarnpkg-negotiator-0.6.2.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.3.tgz -> yarnpkg-negotiator-0.6.3.tgz
https://registry.yarnpkg.com/ngx-color-picker/-/ngx-color-picker-11.0.0.tgz -> yarnpkg-ngx-color-picker-11.0.0.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.7.tgz -> yarnpkg-node-fetch-2.6.7.tgz
https://registry.yarnpkg.com/node-gyp/-/node-gyp-8.4.1.tgz -> yarnpkg-node-gyp-8.4.1.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.5.tgz -> yarnpkg-node-releases-2.0.5.tgz
https://registry.yarnpkg.com/nopt/-/nopt-5.0.0.tgz -> yarnpkg-nopt-5.0.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.1.2.tgz -> yarnpkg-npm-bundled-1.1.2.tgz
https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-4.0.0.tgz -> yarnpkg-npm-install-checks-4.0.0.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz -> yarnpkg-npm-normalize-package-bin-1.0.1.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-8.1.5.tgz -> yarnpkg-npm-package-arg-8.1.5.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-3.0.0.tgz -> yarnpkg-npm-packlist-3.0.0.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-6.1.1.tgz -> yarnpkg-npm-pick-manifest-6.1.1.tgz
https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-11.0.0.tgz -> yarnpkg-npm-registry-fetch-11.0.0.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-6.0.2.tgz -> yarnpkg-npmlog-6.0.2.tgz
https://registry.yarnpkg.com/numeric/-/numeric-1.2.6.tgz -> yarnpkg-numeric-1.2.6.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz -> yarnpkg-on-finished-2.3.0.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/open/-/open-7.4.2.tgz -> yarnpkg-open-7.4.2.tgz
https://registry.yarnpkg.com/open/-/open-8.2.1.tgz -> yarnpkg-open-8.2.1.tgz
https://registry.yarnpkg.com/ora/-/ora-5.4.1.tgz -> yarnpkg-ora-5.4.1.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/pacote/-/pacote-12.0.2.tgz -> yarnpkg-pacote-12.0.2.tgz
https://registry.yarnpkg.com/parse5/-/parse5-5.1.1.tgz -> yarnpkg-parse5-5.1.1.tgz
https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz -> yarnpkg-parseurl-1.3.3.tgz
https://registry.yarnpkg.com/patch-package/-/patch-package-6.4.7.tgz -> yarnpkg-patch-package-6.4.7.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/plottable/-/plottable-3.9.0.tgz -> yarnpkg-plottable-3.9.0.tgz
https://registry.yarnpkg.com/postinstall-postinstall/-/postinstall-postinstall-2.1.0.tgz -> yarnpkg-postinstall-postinstall-2.1.0.tgz
https://registry.yarnpkg.com/prettier-plugin-organize-imports/-/prettier-plugin-organize-imports-2.3.4.tgz -> yarnpkg-prettier-plugin-organize-imports-2.3.4.tgz
https://registry.yarnpkg.com/prettier/-/prettier-2.4.1.tgz -> yarnpkg-prettier-2.4.1.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise-retry/-/promise-retry-2.0.1.tgz -> yarnpkg-promise-retry-2.0.1.tgz
https://registry.yarnpkg.com/protobufjs/-/protobufjs-6.8.8.tgz -> yarnpkg-protobufjs-6.8.8.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz -> yarnpkg-punycode-2.1.1.tgz
https://registry.yarnpkg.com/qjobs/-/qjobs-1.2.0.tgz -> yarnpkg-qjobs-1.2.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.7.0.tgz -> yarnpkg-qs-6.7.0.tgz
https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz -> yarnpkg-range-parser-1.2.1.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.4.0.tgz -> yarnpkg-raw-body-2.4.0.tgz
https://registry.yarnpkg.com/read-package-json-fast/-/read-package-json-fast-2.0.3.tgz -> yarnpkg-read-package-json-fast-2.0.3.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz -> yarnpkg-readable-stream-3.6.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/reflect-metadata/-/reflect-metadata-0.1.13.tgz -> yarnpkg-reflect-metadata-0.1.13.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.7.tgz -> yarnpkg-regenerator-runtime-0.13.7.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/requirejs/-/requirejs-2.3.6.tgz -> yarnpkg-requirejs-2.3.6.tgz
https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz -> yarnpkg-requires-port-1.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.20.0.tgz -> yarnpkg-resolve-1.20.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-3.1.0.tgz -> yarnpkg-restore-cursor-3.1.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz -> yarnpkg-retry-0.12.0.tgz
https://registry.yarnpkg.com/rfdc/-/rfdc-1.3.0.tgz -> yarnpkg-rfdc-1.3.0.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/rw/-/rw-1.3.3.tgz -> yarnpkg-rw-1.3.3.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.7.tgz -> yarnpkg-rxjs-6.6.7.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-7.5.5.tgz -> yarnpkg-rxjs-7.5.5.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/seedrandom/-/seedrandom-2.4.3.tgz -> yarnpkg-seedrandom-2.4.3.tgz
https://registry.yarnpkg.com/semver/-/semver-5.6.0.tgz -> yarnpkg-semver-5.6.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.5.tgz -> yarnpkg-semver-7.3.5.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.7.tgz -> yarnpkg-semver-7.3.7.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.1.tgz -> yarnpkg-setprototypeof-1.1.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz -> yarnpkg-smart-buffer-4.2.0.tgz
https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-2.3.3.tgz -> yarnpkg-socket.io-adapter-2.3.3.tgz
https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-4.0.4.tgz -> yarnpkg-socket.io-parser-4.0.4.tgz
https://registry.yarnpkg.com/socket.io/-/socket.io-4.4.1.tgz -> yarnpkg-socket.io-4.4.1.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-6.2.1.tgz -> yarnpkg-socks-proxy-agent-6.2.1.tgz
https://registry.yarnpkg.com/socks/-/socks-2.6.2.tgz -> yarnpkg-socks-2.6.2.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.9.tgz -> yarnpkg-source-map-support-0.5.9.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.7.3.tgz -> yarnpkg-source-map-0.7.3.tgz
https://registry.yarnpkg.com/sourcemap-codec/-/sourcemap-codec-1.4.8.tgz -> yarnpkg-sourcemap-codec-1.4.8.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/ssri/-/ssri-8.0.1.tgz -> yarnpkg-ssri-8.0.1.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz -> yarnpkg-statuses-1.5.0.tgz
https://registry.yarnpkg.com/streamroller/-/streamroller-3.0.2.tgz -> yarnpkg-streamroller-3.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-4.0.0.tgz -> yarnpkg-symbol-observable-4.0.0.tgz
https://registry.yarnpkg.com/tar/-/tar-6.1.11.tgz -> yarnpkg-tar-6.1.11.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz -> yarnpkg-test-exclude-6.0.0.tgz
https://registry.yarnpkg.com/three/-/three-0.137.0.tgz -> yarnpkg-three-0.137.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz -> yarnpkg-tmp-0.2.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.0.tgz -> yarnpkg-toidentifier-1.0.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.8.1.tgz -> yarnpkg-tslib-1.8.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.4.0.tgz -> yarnpkg-tslib-2.4.0.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.21.3.tgz -> yarnpkg-type-fest-0.21.3.tgz
https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz -> yarnpkg-type-is-1.6.18.tgz
https://registry.yarnpkg.com/typescript/-/typescript-4.5.4.tgz -> yarnpkg-typescript-4.5.4.tgz
https://registry.yarnpkg.com/typesettable/-/typesettable-4.1.0.tgz -> yarnpkg-typesettable-4.1.0.tgz
https://registry.yarnpkg.com/ua-parser-js/-/ua-parser-js-0.7.31.tgz -> yarnpkg-ua-parser-js-0.7.31.tgz
https://registry.yarnpkg.com/umap-js/-/umap-js-1.3.3.tgz -> yarnpkg-umap-js-1.3.3.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.1.tgz -> yarnpkg-unique-filename-1.1.1.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.2.tgz -> yarnpkg-unique-slug-2.0.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz -> yarnpkg-universalify-2.0.0.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.4.tgz -> yarnpkg-update-browserslist-db-1.0.4.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz -> yarnpkg-utils-merge-1.0.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-8.3.2.tgz -> yarnpkg-uuid-8.3.2.tgz
https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-7.1.2.tgz -> yarnpkg-v8-to-istanbul-7.1.2.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-3.0.0.tgz -> yarnpkg-validate-npm-package-name-3.0.0.tgz
https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz -> yarnpkg-vary-1.1.2.tgz
https://registry.yarnpkg.com/void-elements/-/void-elements-2.0.1.tgz -> yarnpkg-void-elements-2.0.1.tgz
https://registry.yarnpkg.com/wcwidth/-/wcwidth-1.0.1.tgz -> yarnpkg-wcwidth-1.0.1.tgz
https://registry.yarnpkg.com/web-animations-js/-/web-animations-js-2.3.2.tgz -> yarnpkg-web-animations-js-2.3.2.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.5.tgz -> yarnpkg-wide-align-1.1.5.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/ws/-/ws-8.2.3.tgz -> yarnpkg-ws-8.2.3.tgz
https://registry.yarnpkg.com/xmlhttprequest/-/xmlhttprequest-1.8.0.tgz -> yarnpkg-xmlhttprequest-1.8.0.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.0.1.tgz -> yarnpkg-yargs-parser-21.0.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.5.1.tgz -> yarnpkg-yargs-17.5.1.tgz
https://registry.yarnpkg.com/yarn-deduplicate/-/yarn-deduplicate-5.0.0.tgz -> yarnpkg-yarn-deduplicate-5.0.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
https://registry.yarnpkg.com/zone.js/-/zone.js-0.11.4.tgz -> yarnpkg-zone.js-0.11.4.tgz
https://registry.yarnpkg.com/@bazel/worker/-/worker-5.1.0.tgz -> yarnpkg-@bazel-worker-5.1.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz -> yarnpkg-anymatch-3.1.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.0.0.tgz -> yarnpkg-binary-extensions-2.0.0.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.1.tgz -> yarnpkg-chokidar-3.5.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/google-protobuf/-/google-protobuf-3.19.4.tgz -> yarnpkg-google-protobuf-3.19.4.tgz
https://registry.yarnpkg.com/immutable/-/immutable-4.0.0.tgz -> yarnpkg-immutable-4.0.0.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz -> yarnpkg-is-glob-4.0.1.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.0.7.tgz -> yarnpkg-picomatch-2.0.7.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.3.tgz -> yarnpkg-picomatch-2.2.3.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.5.0.tgz -> yarnpkg-readdirp-3.5.0.tgz
https://registry.yarnpkg.com/sass/-/sass-1.55.0.tgz -> yarnpkg-sass-1.55.0.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.1.tgz -> yarnpkg-source-map-js-1.0.1.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
"
# From:
# grep "resolved" /var/tmp/portage/sci-visualization/tensorboard-2.11.2/work/tensorboard-2.11.2/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# grep -o -E -r -e "https://registry.yarnpkg.com[^\"]+" /var/tmp/portage/sci-visualization/tensorboard-2.11.2/work/tensorboard-2.11.2-bazel-base/external/io_bazel_rules_sass/sass/yarn.lock | sed -r -e "s|#.*||g"
# Transformed with transform-uris.sh.

# The versions and commits were obtained from console.  To update, temporarily
# remove links in bazel_external_uris.
APPLE_SUPPORT_PV="0.7.1"
BAZEL_SKYLIB_PV="1.1.1"
BLEACH_PV="2.0"
CLOSURE_LIBRARY_PV="20191027"
CHROMEDRIVER_PV="2.41"
CHROMIUM_REV="768959"
COVERAGE_OUTPUT_GENERATOR_PV="2.5"
GO_PV="1.12.5"
GOOGLE_PROTOBUF_PV="3.19.4"
GUAVA_PV="25.1"
HTML5LIB_PYTHON_PV="1.1"
JSOUP_PV="1.11.3"
MARKDOWN_PV="2.6.8"
MATERIAL_DESIGN_ICONS_3_0_1_PV="3.0.1"
MATERIAL_DESIGN_ICONS_3_0_2_PV="3.0.2"
NODE_PV="16.15.0"
PROTOBUF_PV="3.9.2"
RULES_APPLE_PV="0.31.3"
RULES_GO_PV="0.18.5"
RULES_NODEJS_PV="5.7.0"
RULES_NODEJS_CORE_PV="5.7.0"
RULES_SASS_PV="1.55.0"
RULES_SWIFT_PV="0.21.0"
RULES_WEBTESTING_PV="0.3.3"
RUST_PV="1.58.1"
SIX_PV="1.13.0"
WEBENCODINGS_PV="0.5.1"
WERKZUG_PV="0.15.4"
YARN_PV="1.22.11"

AOPALLIANCE_PV="1.0"
ARGS4J_PV="2.0.26"
AUTO_COMMON_PV="0.7"
AUTO_FACTORY_PV="1.0-beta5"
AUTO_VALUE_PV="1.6"
AUTO_VALUE_ANNOTATIONS_PV="1.6"
ASM_ANALYSIS_PV="6.0"
ASM_COMMONS_PV="6.0"
ASM_PV="6.0"
ASM_TREE_PV="6.0"
ASM_UTIL_PV="6.0"
CLOSURE_COMPILER_UNSHADED_PV="20191027"
CLOSURE_STYLESHEETS_PV="1.5.0"
DAGGER_PV="2.14.1"
DAGGER_SPI_PV="2.14.1"
DAGGER_PRODUCERS_PV="2.14.1"
DAGGER_COMPILER_PV="2.14.1"
GOOGLE_JAVA_FORMAT_PV="1.5"
GSON_PV="2.7"
GUICE_ASSISTEDINJECT_PV="4.1.0"
GUICE_MULTIBINDINGS_PV="4.1.0"
GUICE_PV="4.1.0"
ERROR_PRONE_ANNOTATIONS_PV="2.1.3"
ICU4J_PV="57.1"
JAVA_TOOLS_PV="11.7.1"
JAVAC_SHADED_PV="9-dev-r4023-3"
JAVAPOET_PV="1.9.0"
JAVAX_INJECT_PV="1"
JSINTEROP_ANNOTATIONS_PV="1.0.1"
JSON_PV="20160212"
JSOUP_PV="1.11.3"
JSR250_API_PV="1.0"
JSR305_PV="2.0.3"
MAVEN2_TYPES_PV="1.0.7"
SOY_PV="2019-07-14"
TOMCAT_ANNOTATIONS_API_PV="8.0.5"
EGIT_RULES_PYTHON_COMMIT="4b84ad270387a7c439ebdccfd530e2339601ef27"
ZLIB_PV="1.2.11"
AZUL_ZULU_PV="11.50.19-ca-jdk11.0.12"
JAVA_TOOLS_PV="11.7.1"

EGIT_DATA_PLANE_API_COMMIT="c83ed7ea9eb5fb3b93d1ad52b59750f1958b8bde"
EGIT_GRPC_COMMIT="b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd"
EGIT_MATERIAL_DESIGN_ICONS_224895A_COMMIT="224895a86501195e7a7ff3dde18e39f00b8e3d5a"
EGIT_MATERIAL_DESIGN_ICONS_AB12F16_COMMIT="ab12f16d050ecb1886b606f08825d24b30acafea"
EGIT_MATERIAL_DESIGN_ICONS_B3F05BF_COMMIT="b3f05bfbf4329a5b63f50a720f867c2bac163f98"
EGIT_MATERIAL_DESIGN_ICONS_D3D4ACA_COMMIT="d3d4aca5a7cf50bc68bbd401cefa708e364194e8"
EGIT_ROBOTO_COMMIT="ba03b84b90b50afd99f9688059447bc545e5c0e1"
EGIT_RULES_CC_COMMIT="b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e"
EGIT_RULES_CLOSURE_COMMIT="db4683a2a1836ac8e265804ca5fa31852395185b"
EGIT_RULES_JAVA_COMMIT="981f06c3d2bd10225e85209904090eb7b5fb26bd"
EGIT_RULES_PROTO_COMMIT="97d8af4dc474595af3900dd85cb3a29ad28cc313"
EGIT_RULES_RUST_COMMIT="d5ab4143245af8b33d1947813d411a6cae838409"
EGIT_UPB_COMMIT="9effcbcb27f0a665f9f345030188c0b291e32482"

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
https://crates.io/api/v1/crates/bumpalo/3.6.0/download -> rust-crates--bumpalo-3.6.0.tar.gz
https://crates.io/api/v1/crates/byteorder/1.3.4/download -> rust-crates--byteorder-1.3.4.tar.gz
https://crates.io/api/v1/crates/bytes/0.5.6/download -> rust-crates--bytes-0.5.6.tar.gz
https://crates.io/api/v1/crates/bytes/1.0.1/download -> rust-crates--bytes-1.0.1.tar.gz
https://crates.io/api/v1/crates/cc/1.0.66/download -> rust-crates--cc-1.0.66.tar.gz
https://crates.io/api/v1/crates/cfg-if/0.1.10/download -> rust-crates--cfg-if-0.1.10.tar.gz
https://crates.io/api/v1/crates/cfg-if/1.0.0/download -> rust-crates--cfg-if-1.0.0.tar.gz
https://crates.io/api/v1/crates/clap/3.0.0-beta.2/download -> rust-crates--clap-3.0.0-beta.2.tar.gz
https://crates.io/api/v1/crates/clap_derive/3.0.0-beta.2/download -> rust-crates--clap_derive-3.0.0-beta.2.tar.gz
https://crates.io/api/v1/crates/const_fn/0.4.5/download -> rust-crates--const_fn-0.4.5.tar.gz
https://crates.io/api/v1/crates/crc/1.8.1/download -> rust-crates--crc-1.8.1.tar.gz
https://crates.io/api/v1/crates/crossbeam/0.8.0/download -> rust-crates--crossbeam-0.8.0.tar.gz
https://crates.io/api/v1/crates/crossbeam-channel/0.5.0/download -> rust-crates--crossbeam-channel-0.5.0.tar.gz
https://crates.io/api/v1/crates/crossbeam-deque/0.8.1/download -> rust-crates--crossbeam-deque-0.8.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-epoch/0.9.1/download -> rust-crates--crossbeam-epoch-0.9.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-queue/0.3.1/download -> rust-crates--crossbeam-queue-0.3.1.tar.gz
https://crates.io/api/v1/crates/crossbeam-utils/0.8.8/download -> rust-crates--crossbeam-utils-0.8.8.tar.gz
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
https://crates.io/api/v1/crates/log/0.4.11/download -> rust-crates--log-0.4.11.tar.gz
https://crates.io/api/v1/crates/matches/0.1.8/download -> rust-crates--matches-0.1.8.tar.gz
https://crates.io/api/v1/crates/memchr/2.5.0/download -> rust-crates--memchr-2.5.0.tar.gz
https://crates.io/api/v1/crates/memoffset/0.6.1/download -> rust-crates--memoffset-0.6.1.tar.gz
https://crates.io/api/v1/crates/mime/0.3.16/download -> rust-crates--mime-0.3.16.tar.gz
https://crates.io/api/v1/crates/mio/0.8.3/download -> rust-crates--mio-0.8.3.tar.gz
https://crates.io/api/v1/crates/multimap/0.8.2/download -> rust-crates--multimap-0.8.2.tar.gz
https://crates.io/api/v1/crates/num_cpus/1.13.0/download -> rust-crates--num_cpus-1.13.0.tar.gz
https://crates.io/api/v1/crates/once_cell/1.5.2/download -> rust-crates--once_cell-1.5.2.tar.gz
https://crates.io/api/v1/crates/os_str_bytes/2.4.0/download -> rust-crates--os_str_bytes-2.4.0.tar.gz
https://crates.io/api/v1/crates/percent-encoding/2.1.0/download -> rust-crates--percent-encoding-2.1.0.tar.gz
https://crates.io/api/v1/crates/petgraph/0.6.2/download -> rust-crates--petgraph-0.6.2.tar.gz
https://crates.io/api/v1/crates/pin-project/0.4.27/download -> rust-crates--pin-project-0.4.27.tar.gz
https://crates.io/api/v1/crates/pin-project/1.0.1/download -> rust-crates--pin-project-1.0.1.tar.gz
https://crates.io/api/v1/crates/pin-project-internal/0.4.27/download -> rust-crates--pin-project-internal-0.4.27.tar.gz
https://crates.io/api/v1/crates/pin-project-internal/1.0.1/download -> rust-crates--pin-project-internal-1.0.1.tar.gz
https://crates.io/api/v1/crates/pin-project-lite/0.2.9/download -> rust-crates--pin-project-lite-0.2.9.tar.gz
https://crates.io/api/v1/crates/pin-utils/0.1.0/download -> rust-crates--pin-utils-0.1.0.tar.gz
https://crates.io/api/v1/crates/ppv-lite86/0.2.10/download -> rust-crates--ppv-lite86-0.2.10.tar.gz
https://crates.io/api/v1/crates/proc-macro-error/1.0.4/download -> rust-crates--proc-macro-error-1.0.4.tar.gz
https://crates.io/api/v1/crates/proc-macro-error-attr/1.0.4/download -> rust-crates--proc-macro-error-attr-1.0.4.tar.gz
https://crates.io/api/v1/crates/proc-macro-hack/0.5.19/download -> rust-crates--proc-macro-hack-0.5.19.tar.gz
https://crates.io/api/v1/crates/proc-macro-nested/0.1.7/download -> rust-crates--proc-macro-nested-0.1.7.tar.gz
https://crates.io/api/v1/crates/proc-macro2/1.0.24/download -> rust-crates--proc-macro2-1.0.24.tar.gz
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
https://crates.io/api/v1/crates/regex/1.5.6/download -> rust-crates--regex-1.5.6.tar.gz
https://crates.io/api/v1/crates/regex-syntax/0.6.26/download -> rust-crates--regex-syntax-0.6.26.tar.gz
https://crates.io/api/v1/crates/remove_dir_all/0.5.3/download -> rust-crates--remove_dir_all-0.5.3.tar.gz
https://crates.io/api/v1/crates/reqwest/0.11.0/download -> rust-crates--reqwest-0.11.0.tar.gz
https://crates.io/api/v1/crates/ring/0.16.20/download -> rust-crates--ring-0.16.20.tar.gz
https://crates.io/api/v1/crates/rustls/0.19.0/download -> rust-crates--rustls-0.19.0.tar.gz
https://crates.io/api/v1/crates/ryu/1.0.5/download -> rust-crates--ryu-1.0.5.tar.gz
https://crates.io/api/v1/crates/same-file/1.0.6/download -> rust-crates--same-file-1.0.6.tar.gz
https://crates.io/api/v1/crates/scopeguard/1.1.0/download -> rust-crates--scopeguard-1.1.0.tar.gz
https://crates.io/api/v1/crates/sct/0.6.1/download -> rust-crates--sct-0.6.1.tar.gz
https://crates.io/api/v1/crates/serde/1.0.118/download -> rust-crates--serde-1.0.118.tar.gz
https://crates.io/api/v1/crates/serde_derive/1.0.118/download -> rust-crates--serde_derive-1.0.118.tar.gz
https://crates.io/api/v1/crates/serde_json/1.0.61/download -> rust-crates--serde_json-1.0.61.tar.gz
https://crates.io/api/v1/crates/serde_urlencoded/0.7.0/download -> rust-crates--serde_urlencoded-0.7.0.tar.gz
https://crates.io/api/v1/crates/slab/0.4.2/download -> rust-crates--slab-0.4.2.tar.gz
https://crates.io/api/v1/crates/socket2/0.4.4/download -> rust-crates--socket2-0.4.4.tar.gz
https://crates.io/api/v1/crates/spin/0.5.2/download -> rust-crates--spin-0.5.2.tar.gz
https://crates.io/api/v1/crates/strsim/0.10.0/download -> rust-crates--strsim-0.10.0.tar.gz
https://crates.io/api/v1/crates/syn/1.0.67/download -> rust-crates--syn-1.0.67.tar.gz
https://crates.io/api/v1/crates/tempfile/3.1.0/download -> rust-crates--tempfile-3.1.0.tar.gz
https://crates.io/api/v1/crates/termcolor/1.1.0/download -> rust-crates--termcolor-1.1.0.tar.gz
https://crates.io/api/v1/crates/textwrap/0.12.1/download -> rust-crates--textwrap-0.12.1.tar.gz
https://crates.io/api/v1/crates/thiserror/1.0.22/download -> rust-crates--thiserror-1.0.22.tar.gz
https://crates.io/api/v1/crates/thiserror-impl/1.0.22/download -> rust-crates--thiserror-impl-1.0.22.tar.gz
https://crates.io/api/v1/crates/tinyvec/1.1.1/download -> rust-crates--tinyvec-1.1.1.tar.gz
https://crates.io/api/v1/crates/tinyvec_macros/0.1.0/download -> rust-crates--tinyvec_macros-0.1.0.tar.gz
https://crates.io/api/v1/crates/tokio/1.19.2/download -> rust-crates--tokio-1.19.2.tar.gz
https://crates.io/api/v1/crates/tokio-io-timeout/1.2.0/download -> rust-crates--tokio-io-timeout-1.2.0.tar.gz
https://crates.io/api/v1/crates/tokio-macros/1.8.0/download -> rust-crates--tokio-macros-1.8.0.tar.gz
https://crates.io/api/v1/crates/tokio-rustls/0.22.0/download -> rust-crates--tokio-rustls-0.22.0.tar.gz
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
https://crates.io/api/v1/crates/tracing-futures/0.2.4/download -> rust-crates--tracing-futures-0.2.4.tar.gz
https://crates.io/api/v1/crates/try-lock/0.2.3/download -> rust-crates--try-lock-0.2.3.tar.gz
https://crates.io/api/v1/crates/unicode-bidi/0.3.4/download -> rust-crates--unicode-bidi-0.3.4.tar.gz
https://crates.io/api/v1/crates/unicode-normalization/0.1.16/download -> rust-crates--unicode-normalization-0.1.16.tar.gz
https://crates.io/api/v1/crates/unicode-segmentation/1.6.0/download -> rust-crates--unicode-segmentation-1.6.0.tar.gz
https://crates.io/api/v1/crates/unicode-width/0.1.8/download -> rust-crates--unicode-width-0.1.8.tar.gz
https://crates.io/api/v1/crates/unicode-xid/0.2.1/download -> rust-crates--unicode-xid-0.2.1.tar.gz
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
https://crates.io/api/v1/crates/webpki-roots/0.21.1/download -> rust-crates--webpki-roots-0.21.1.tar.gz
https://crates.io/api/v1/crates/which/4.0.2/download -> rust-crates--which-4.0.2.tar.gz
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
https://dl.google.com/go/go${GO_PV}.linux-amd64.tar.gz
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
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_RULES_CLOSURE_COMMIT}.tar.gz -> rules_closure-${EGIT_RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_go/releases/download/${RULES_GO_PV}/rules_go-${RULES_GO_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_RULES_JAVA_COMMIT}.tar.gz -> rules_java-${EGIT_RULES_JAVA_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_nodejs/releases/download/${RULES_NODEJS_PV}/rules_nodejs-${RULES_NODEJS_PV}.tar.gz
https://github.com/bazelbuild/rules_nodejs/releases/download/${RULES_NODEJS_CORE_PV}/rules_nodejs-core-${RULES_NODEJS_CORE_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_rust/archive/${EGIT_RULES_RUST_COMMIT}.tar.gz -> rules_rust-${EGIT_RULES_RUST_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_sass/archive/${RULES_SASS_PV}.zip -> rules_sass-${RULES_SASS_PV}.zip
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz
https://github.com/bazelbuild/rules_webtesting/releases/download/${RULES_WEBTESTING_PV}/rules_webtesting.tar.gz -> rules_webtesting-${RULES_WEBTESTING_PV}.tar.gz
https://github.com/envoyproxy/data-plane-api/archive/${EGIT_DATA_PLANE_API_COMMIT}.tar.gz -> data-plane-api-${EGIT_DATA_PLANE_API_COMMIT}.tar.gz
https://github.com/google/closure-library/archive/v${CLOSURE_LIBRARY_PV}.tar.gz -> closure-library-${CLOSURE_LIBRARY_PV}.tar.gz
https://github.com/mozilla/bleach/archive/v2.0.tar.gz -> bleach-${BLEACH_PV}.tar.gz
https://github.com/protocolbuffers/upb/archive/${EGIT_UPB_COMMIT}.tar.gz -> upb-${EGIT_UPB_COMMIT}.tar.gz
https://github.com/yarnpkg/yarn/releases/download/v${YARN_PV}/yarn-v${YARN_PV}.tar.gz
https://mirror.bazel.build/bazel_coverage_output_generator/releases/coverage_output_generator-v${COVERAGE_OUTPUT_GENERATOR_PV}.zip
http://mirror.tensorflow.org/github.com/bazelbuild/bazel-skylib/archive/${BAZEL_SKYLIB_PV}.tar.gz -> tf-bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
http://mirror.tensorflow.org/github.com/grpc/grpc/archive/${EGIT_GRPC_COMMIT}.tar.gz -> grpc-${EGIT_GRPC_COMMIT}.tar.gz
http://mirror.tensorflow.org/github.com/html5lib/html5lib-python/archive/${HTML5LIB_PYTHON_PV}.tar.gz -> html5lib-python-${HTML5LIB_PYTHON_PV}.tar.gz
http://mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.tar.gz -> protobuf-${PROTOBUF_PV}.tar.gz
https://nodejs.org/dist/v${NODE_PV}/node-v${NODE_PV}-linux-x64.tar.xz
https://pypi.python.org/packages/1d/25/3f6d2cb31ec42ca5bd3bfbea99b63892b735d76e26f20dd2dcc34ffe4f0d/Markdown-${MARKDOWN_PV}.tar.gz
https://pypi.python.org/packages/source/s/six/six-${SIX_PV}.tar.gz
https://raw.githubusercontent.com/google/roboto/${EGIT_ROBOTO_COMMIT}/LICENSE -> roboto-${EGIT_ROBOTO_COMMIT}-LICENSE
https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA_PV}-jre/guava-${GUAVA_PV}-jre.jar
https://static.rust-lang.org/dist/rust-${RUST_PV}-x86_64-unknown-linux-gnu.tar.gz

https://repo1.maven.org/maven2/aopalliance/aopalliance/${AOPALLIANCE_PV}/aopalliance-${AOPALLIANCE_PV}.jar
https://repo1.maven.org/maven2/args4j/args4j/${ARGS4J_PV}/args4j-${ARGS4J_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/auto-common/${AUTO_COMMON_PV}/auto-common-${AUTO_COMMON_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/factory/auto-factory/${AUTO_FACTORY_PV}/auto-factory-${AUTO_FACTORY_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/value/auto-value-annotations/${AUTO_VALUE_ANNOTATIONS_PV}/auto-value-annotations-${AUTO_VALUE_ANNOTATIONS_PV}.jar
https://repo1.maven.org/maven2/com/google/auto/value/auto-value/${AUTO_VALUE_PV}/auto-value-${AUTO_VALUE_PV}.jar
https://repo1.maven.org/maven2/com/google/closure-stylesheets/closure-stylesheets/${CLOSURE_STYLESHEETS_PV}/closure-stylesheets-${CLOSURE_STYLESHEETS_PV}.jar
https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${JSR305_PV}/jsr305-${JSR305_PV}.jar
https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_PV}/gson-${GSON_PV}.jar
https://repo1.maven.org/maven2/com/google/common/html/types/types/${MAVEN2_TYPES_PV}/types-${MAVEN2_TYPES_PV}.jar
https://repo1.maven.org/maven2/com/google/dagger/dagger-compiler/${DAGGER_COMPILER_PV}/dagger-compiler-${DAGGER_COMPILER_PV}.jar
https://repo1.maven.org/maven2/com/google/dagger/dagger-producers/${DAGGER_PRODUCERS_PV}/dagger-producers-${DAGGER_PRODUCERS_PV}.jar
https://repo1.maven.org/maven2/com/google/dagger/dagger-spi/${DAGGER_SPI_PV}/dagger-spi-${DAGGER_SPI_PV}.jar
https://repo1.maven.org/maven2/com/google/dagger/dagger/${DAGGER_PV}/dagger-${DAGGER_PV}.jar
https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/${ERROR_PRONE_ANNOTATIONS_PV}/error_prone_annotations-${ERROR_PRONE_ANNOTATIONS_PV}.jar
https://repo1.maven.org/maven2/com/google/errorprone/javac-shaded/${JAVAC_SHADED_PV}/javac-shaded-${JAVAC_SHADED_PV}.jar
https://repo1.maven.org/maven2/com/google/googlejavaformat/google-java-format/${GOOGLE_JAVA_FORMAT_PV}/google-java-format-${GOOGLE_JAVA_FORMAT_PV}.jar
https://repo1.maven.org/maven2/com/google/inject/extensions/guice-assistedinject/${GUICE_ASSISTEDINJECT_PV}/guice-assistedinject-${GUICE_ASSISTEDINJECT_PV}.jar
https://repo1.maven.org/maven2/com/google/inject/extensions/guice-multibindings/${GUICE_MULTIBINDINGS_PV}/guice-multibindings-${GUICE_MULTIBINDINGS_PV}.jar
https://repo1.maven.org/maven2/com/google/inject/guice/${GUICE_PV}/guice-${GUICE_PV}.jar
https://repo1.maven.org/maven2/com/google/jsinterop/jsinterop-annotations/${JSINTEROP_ANNOTATIONS_PV}/jsinterop-annotations-${JSINTEROP_ANNOTATIONS_PV}.jar
https://repo1.maven.org/maven2/com/google/template/soy/${SOY_PV}/soy-${SOY_PV}-jssrc_js.jar
https://repo1.maven.org/maven2/com/google/template/soy/${SOY_PV}/soy-${SOY_PV}.jar
https://repo1.maven.org/maven2/com/ibm/icu/icu4j/${ICU4J_PV}/icu4j-${ICU4J_PV}.jar
https://repo1.maven.org/maven2/com/squareup/javapoet/${JAVAPOET_PV}/javapoet-${JAVAPOET_PV}.jar
https://repo1.maven.org/maven2/javax/annotation/jsr250-api/${JSR250_API_PV}/jsr250-api-${JSR250_API_PV}.jar
https://repo1.maven.org/maven2/javax/inject/javax.inject/${JAVAX_INJECT_PV}/javax.inject-${JAVAX_INJECT_PV}.jar
https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-annotations-api/${TOMCAT_ANNOTATIONS_API_PV}/tomcat-annotations-api-${TOMCAT_ANNOTATIONS_API_PV}.jar
https://repo1.maven.org/maven2/org/json/json/${JSON_PV}/json-${JSON_PV}.jar
https://repo1.maven.org/maven2/org/jsoup/jsoup/${JSOUP_PV}/jsoup-${JSOUP_PV}.jar
https://repo1.maven.org/maven2/org/ow2/asm/asm-analysis/${ASM_ANALYSIS_PV}/asm-analysis-${ASM_ANALYSIS_PV}.jar
https://repo1.maven.org/maven2/org/ow2/asm/asm-commons/${ASM_COMMONS_PV}/asm-commons-${ASM_COMMONS_PV}.jar
https://repo1.maven.org/maven2/org/ow2/asm/asm-tree/${ASM_TREE_PV}/asm-tree-${ASM_TREE_PV}.jar
https://repo1.maven.org/maven2/org/ow2/asm/asm-util/${ASM_UTIL_PV}/asm-util-${ASM_UTIL_PV}.jar
https://repo1.maven.org/maven2/org/ow2/asm/asm/${ASM_PV}/asm-${ASM_PV}.jar

https://repo1.maven.org/maven2/com/google/javascript/closure-compiler-unshaded/v${CLOSURE_COMPILER_UNSHADED_PV}/closure-compiler-unshaded-v${CLOSURE_COMPILER_UNSHADED_PV}.jar
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools-v${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/rules_python/archive/${EGIT_RULES_PYTHON_COMMIT}.tar.gz -> rules_python-${EGIT_RULES_PYTHON_COMMIT}.tar.gz
https://zlib.net/zlib-${ZLIB_PV}.tar.gz
https://mirror.bazel.build/openjdk/azul-zulu${AZUL_ZULU_PV}/zulu${AZUL_ZULU_PV}-linux_x64.tar.gz
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools_linux-v${JAVA_TOOLS_PV}.zip
https://static.rust-lang.org/dist/rustfmt-${RUST_PV}-x86_64-unknown-linux-gnu.tar.gz
https://static.rust-lang.org/dist/llvm-tools-${RUST_PV}-x86_64-unknown-linux-gnu.tar.gz
https://static.rust-lang.org/dist/rust-std-${RUST_PV}-x86_64-unknown-linux-gnu.tar.gz
https://static.rust-lang.org/dist/rust-std-${RUST_PV}-wasm32-unknown-unknown.tar.gz
https://static.rust-lang.org/dist/rust-std-${RUST_PV}-wasm32-wasi.tar.gz

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

cp_raze_crates() {
	local L=(
aho-corasick/0.7.18
anyhow/1.0.34
async-stream/0.3.0
async-stream-impl/0.3.0
async-trait/0.1.41
atty/0.2.14
autocfg/1.0.1
base64/0.13.0
bitflags/1.2.1
build_const/0.2.1
bumpalo/3.6.0
byteorder/1.3.4
bytes/0.5.6
bytes/1.0.1
cc/1.0.66
cfg-if/0.1.10
cfg-if/1.0.0
clap/3.0.0-beta.2
clap_derive/3.0.0-beta.2
const_fn/0.4.5
crc/1.8.1
crossbeam/0.8.0
crossbeam-channel/0.5.0
crossbeam-deque/0.8.1
crossbeam-epoch/0.9.1
crossbeam-queue/0.3.1
crossbeam-utils/0.8.8
either/1.6.1
encoding_rs/0.8.26
env_logger/0.8.2
fixedbitset/0.4.1
fnv/1.0.7
form_urlencoded/1.0.0
futures-channel/0.3.8
futures-core/0.3.12
futures-io/0.3.12
futures-macro/0.3.8
futures-sink/0.3.8
futures-task/0.3.8
futures-util/0.3.8
getrandom/0.1.15
getrandom/0.2.1
h2/0.3.13
hashbrown/0.11.2
heck/0.3.1
hermit-abi/0.1.17
http/0.2.1
http-body/0.4.5
httparse/1.7.1
httpdate/1.0.2
humantime/2.0.1
hyper/0.14.19
hyper-rustls/0.22.1
hyper-timeout/0.4.1
idna/0.2.0
indexmap/1.8.2
ipnet/2.3.0
itertools/0.10.3
itoa/0.4.6
itoa/1.0.2
js-sys/0.3.47
lazy_static/1.4.0
libc/0.2.126
log/0.4.11
matches/0.1.8
memchr/2.5.0
memoffset/0.6.1
mime/0.3.16
mio/0.8.3
multimap/0.8.2
num_cpus/1.13.0
once_cell/1.5.2
os_str_bytes/2.4.0
percent-encoding/2.1.0
petgraph/0.6.2
pin-project/0.4.27
pin-project/1.0.1
pin-project-internal/0.4.27
pin-project-internal/1.0.1
pin-project-lite/0.2.9
pin-utils/0.1.0
ppv-lite86/0.2.10
proc-macro-error/1.0.4
proc-macro-error-attr/1.0.4
proc-macro-hack/0.5.19
proc-macro-nested/0.1.7
proc-macro2/1.0.24
prost/0.9.0
prost-build/0.9.0
prost-derive/0.9.0
prost-types/0.9.0
quote/1.0.7
rand/0.7.3
rand/0.8.2
rand_chacha/0.2.2
rand_chacha/0.3.0
rand_core/0.5.1
rand_core/0.6.1
rand_hc/0.2.0
rand_hc/0.3.0
rayon/1.5.0
rayon-core/1.9.0
redox_syscall/0.1.57
regex/1.5.6
regex-syntax/0.6.26
remove_dir_all/0.5.3
reqwest/0.11.0
ring/0.16.20
rustls/0.19.0
ryu/1.0.5
same-file/1.0.6
scopeguard/1.1.0
sct/0.6.1
serde/1.0.118
serde_derive/1.0.118
serde_json/1.0.61
serde_urlencoded/0.7.0
slab/0.4.2
socket2/0.4.4
spin/0.5.2
strsim/0.10.0
syn/1.0.67
tempfile/3.1.0
termcolor/1.1.0
textwrap/0.12.1
thiserror/1.0.22
thiserror-impl/1.0.22
tinyvec/1.1.1
tinyvec_macros/0.1.0
tokio/1.19.2
tokio-io-timeout/1.2.0
tokio-macros/1.8.0
tokio-rustls/0.22.0
tokio-stream/0.1.2
tokio-util/0.6.6
tokio-util/0.7.3
tonic/0.6.2
tonic-build/0.6.2
tonic-reflection/0.3.0
tower/0.4.11
tower-layer/0.3.1
tower-service/0.3.0
tracing/0.1.34
tracing-attributes/0.1.21
tracing-core/0.1.26
tracing-futures/0.2.4
try-lock/0.2.3
unicode-bidi/0.3.4
unicode-normalization/0.1.16
unicode-segmentation/1.6.0
unicode-width/0.1.8
unicode-xid/0.2.1
untrusted/0.7.1
url/2.2.0
vec_map/0.8.2
version_check/0.9.2
walkdir/2.3.1
want/0.3.0
wasi/0.10.1+wasi-snapshot-preview1
wasi/0.11.0+wasi-snapshot-preview1
wasi/0.9.0+wasi-snapshot-preview1
wasm-bindgen/0.2.70
wasm-bindgen-backend/0.2.70
wasm-bindgen-futures/0.4.20
wasm-bindgen-macro/0.2.70
wasm-bindgen-macro-support/0.2.70
wasm-bindgen-shared/0.2.70
web-sys/0.3.47
webpki/0.21.4
webpki-roots/0.21.1
which/4.0.2
winapi/0.3.9
winapi-i686-pc-windows-gnu/0.4.0
winapi-util/0.1.5
winapi-x86_64-pc-windows-gnu/0.4.0
windows-sys/0.36.1
windows_aarch64_msvc/0.36.1
windows_i686_gnu/0.36.1
windows_i686_msvc/0.36.1
windows_x86_64_gnu/0.36.1
windows_x86_64_msvc/0.36.1
winreg/0.7.0
	)
	local row
	for row in ${L[@]} ; do
		local pn=$(echo "${row}" \
			| cut -f 1 -d "/")
		local pv=$(echo "${row}" \
			| cut -f 2 -d "/")
		local spv="${pv}"
		spv="${spv//+/_}"
		spv="${spv//-/_}"
		spv="${spv//./_}"
		local folder="raze__${pn}__${pv}"
		local dist="${WORKDIR}/tensorboard-${PV}-bazel-base/external/${folder}/temp4412435098408312724"
		mkdir -p "${dist}" || die
einfo "Copying ${DISTDIR}/rust-crates--${pn}-${pv}.tar.gz -> ${dist}/download.tar.gz"
		cat "${DISTDIR}/rust-crates--${pn}-${pv}.tar.gz" > "${dist}/download.tar.gz" || die
	done
}

src_unpack() {
	unpack ${P}.tar.gz
	bazel_load_distfiles "${bazel_external_uris}"
	yarn-utils_cpy_yarn_tarballs
	cp_material_icons
	cp_rust_crates
#	cp_raze_crates
	cd "${S}" || die
	yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
	cp "${HOME}/.yarnrc" "${WORKDIR}" || die
}

src_prepare() {
	default
	export JAVA_HOME=$(java-config --jre-home)
	eapply "${FILESDIR}/tensorboard-2.11.2-yarn-local-cache.patch"
	sed -i -e "s|\.yarnrc|${WORKDIR}/.yarnrc|g" WORKSPACE || die
	sed -i -e "s|\.cache/yarn2|${HOME}/.cache/yarn2|g" WORKSPACE || die
	bazel_setup_bazelrc
}

src_configure() {
	mkdir -p "${WORKDIR}/bin"
	export PATH="${WORKDIR}/bin:${PATH}"
	local has_multislot_bazel=0
	local slot
	for slot in 5 4 ; do
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
ewarn "instead or downgrade to bazel < 6"
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
