(let ((default-directory  "@SITELISP@/.cask/"))
  (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'load-path "@SITELISP@")

___YCMD-EMACS_DEBUG___

___YCMD-EMACS_NEXT_ERROR___

;; This assumes at the last commit of the CORE_VERSION.
;; You may need to change ycmd.el for the ycmd-core-version conditional.

(set-variable 'ycmd-core-version ___YCMD-EMACS_CORE_VERSION___)
(set-variable 'ycmd-server-command '("__EPYTHON__" "___YCMD-EMACS-YCMD-DIR___"))
(set-variable 'ycmd-global-config "___YCMD-EMACS_GLOBAL_CONFIG_ABSPATH___")
(set-variable 'ycmd-python-binary-path "___YCMD-EMACS_PYTHON_ABSPATH___")

;; core version <42
(set-variable 'ycmd-gocode-binary-path "___YCMD-EMACS_GOCODE_ABSPATH___")
(set-variable 'ycmd-godef-binary-path "___YCMD-EMACS_GODEF_ABSPATH___")
(set-variable 'ycmd-rust-src-path "___YCMD-EMACS_RUST_ABSPATH___")
(set-variable 'ycmd-racerd-binary-path "___YCMD-EMACS_RACERD_ABSPATH___")

;; core version >=42
(set-variable 'ycmd-clangd-binary-path "___YCMD-EMACS_CLANGD_ABSPATH___")
(set-variable 'ycmd-gopls-binary-path "___YCMD-EMACS_GOPLS_ABSPATH___")
(set-variable 'ycmd-rls-binary-path "___YCMD-EMACS_RLS_ABSPATH___")
(set-variable 'ycmd-roslyn-binary-path "___YCMD-EMACS_ROSLYN_ABSPATH___")
(set-variable 'ycmd-rustc-binary-path "___YCMD-EMACS_RUSTC_ABSPATH___")
(set-variable 'ycmd-tsserver-binary-path "___YCMD-EMACS_TSSERVER_ABSPATH___")
(set-variable 'ycmd-java-jdtls-workspace-root-path "___YCMD-EMACS_JDTLS_WORKSPACE_ROOT_ABSPATH___")
(set-variable 'ycmd-java-jdtls-extension-path [___YCMD-EMACS_JDTLS_EXTENSION_ABSPATH___])

;; core version >=43
(set-variable 'ycmd-mono-binary-path "___YCMD-EMACS_MONO_ABSPATH___")

;; core version >=44
(set-variable 'ycmd-rust-toolchain-root "___YCMD-EMACS_RUST_TC_ABSPATH___")
(set-variable 'ycmd-java-binary-path "___YCMD-EMACS_JAVA_ABSPATH___")

(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)


___YCMD-EMACS_BUILTIN_COMPLETION___

___YCMD-EMACS_COMPANY_MODE___

___YCMD-EMACS_FLYCHECK___

___YCMD-EMACS_ELDOC___

