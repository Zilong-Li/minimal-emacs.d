;;; my-config-ace-link.el --- Personal ace-link configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ace-link
  :bind ("C-j" . ace-link)
  :config
  (ace-link-setup-default)
  )

(provide 'my-config-ace-link)
;;; my-config-ace-link.el ends here
