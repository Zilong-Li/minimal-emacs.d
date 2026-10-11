;;; my-config-autorevert.el --- Personal autorevert configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package autorevert
  :custom
  (auto-revert-use-notify nil)
  :config
  (global-auto-revert-mode t))

(provide 'my-config-autorevert)
;;; my-config-autorevert.el ends here
