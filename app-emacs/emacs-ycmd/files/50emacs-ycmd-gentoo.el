(add-to-list 'load-path "@SITELISP@")

GENTOO_DEBUG

GENTOO_NEXT_ERROR

(set-variable 'ycmd-server-command '("python3.4" "/usr/lib64/python3.4/site-packages/ycmd"))
(set-variable 'ycmd-global-config "/tmp/.ycm_extra_conf.py")
(set-variable 'ycmd-gocode-binary-path "/usr/bin/gocode")
(set-variable 'ycmd-godef-binary-path "/usr/bin/godef")
(set-variable 'ycmd-rust-src-path "/usr/share/rust/src")
(set-variable 'ycmd-racerd-binary-path "/usr/bin/racerd")
(set-variable 'ycmd-python-binary-path "/usr/bin/python3.4")

(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)


GENTOO_BUILTIN

GENTOO_COMPANY_MODE

GENTOO_FLYCHECK

GENTOO_ELDOC

