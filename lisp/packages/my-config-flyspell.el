;;; my-config-flyspell.el --- Personal flyspell configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package flyspell
  :after ispell
  :bind (("C-c i b" . flyspell-buffer)
         ("C-c i f" . flyspell-mode))
  :custom
  (flyspell-abbrev-p nil)
  (flyspell-use-meta-tab nil)
  )

(provide 'my-config-flyspell)
;;; my-config-flyspell.el ends here
