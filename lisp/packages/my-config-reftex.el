;;; my-config-reftex.el --- Personal reftex configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package reftex
  :defer t
  :hook (LaTeX-mode . reftex-mode)
  :custom
  (reftex-plug-into-AUCTeX t)
  )

;; (add-hook 'org-mode-hook #'turn-on-org-cdlatex) ; enable org-cdlatex-mode

(provide 'my-config-reftex)
;;; my-config-reftex.el ends here
