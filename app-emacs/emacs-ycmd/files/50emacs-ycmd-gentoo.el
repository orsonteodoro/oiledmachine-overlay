(add-to-list 'load-path "@SITELISP@")

GENTOO_DEBUG

GENTOO_NEXT_ERROR

(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)
(set-variable 'ycmd-server-command '("python3_4" "/usr/lib64/python3.4/site-packages/ycmd"))

GENTOO_BUILTIN

GENTOO_COMPANY_MODE

GENTOO_FLYCHECK

GENTOO_ELDOC

