(let ((default-directory  "@SITELISP@/.cask/"))
  (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'load-path "@SITELISP@")

___YCMD-EMACS_DEBUG___

___YCMD-EMACS_NEXT_ERROR___

(set-variable 'ycmd-server-command '("python3.4" "___YCMD-EMACS-YCMD-DIR___"))
(set-variable 'ycmd-global-config "___YCMD-EMACS_GLOBAL_CONFIG_ABSPATH___")
(set-variable 'ycmd-gocode-binary-path "___YCMD-EMACS_GOCODE_ABSPATH___")
(set-variable 'ycmd-godef-binary-path "___YCMD-EMACS_GODEF_ABSPATH___")
(set-variable 'ycmd-rust-src-path "___YCMD-EMACS_RUST_ABSPATH___")
(set-variable 'ycmd-racerd-binary-path "___YCMD-EMACS_RACERD_ABSPATH___")
(set-variable 'ycmd-python-binary-path "___YCMD-EMACS_PYTHON_ABSPATH___")

(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)


___YCMD-EMACS_BUILTIN_COMPLETION___

___YCMD-EMACS_COMPANY_MODE___

___YCMD-EMACS_FLYCHECK___

___YCMD-EMACS_ELDOC___

