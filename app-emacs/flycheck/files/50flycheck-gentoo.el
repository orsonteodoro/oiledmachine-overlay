(add-to-list 'load-path "@SITELISP@")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
