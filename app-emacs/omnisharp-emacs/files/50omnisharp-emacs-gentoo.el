GENTOO_DEBUG

(add-to-list 'load-path "@SITELISP@")

(setq omnisharp-server-executable-path "GENTOO_OMNISHARP_PATH")
(setq omnisharp--curl-executable-path "GENTOO_CURL_PATH")

(load-file "@SITELISP@/omnisharp.el")

(add-hook 'csharp-mode-hook 'omnisharp-mode)

GENTOO_COMPANY_MODE

GENTOO_COMPANY_MODE_INTEGRATION

GENTOO_EXAMPLE_CONFIG
