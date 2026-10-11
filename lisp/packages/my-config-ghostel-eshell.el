;;; my-config-ghostel-eshell.el --- Personal ghostel-eshell configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ghostel-eshell
  :hook (eshell-load . ghostel-eshell-visual-command-mode))

(provide 'my-config-ghostel-eshell)
;;; my-config-ghostel-eshell.el ends here
