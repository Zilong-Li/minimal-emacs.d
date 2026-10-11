;;; my-config-nov.el --- Personal nov configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package nov
  :bind (:map nov-mode-map
              ("M-." . dictionary-lookup-definition))
  :config
  (setq nov-text-width t)
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'variable-pitch-mode) ;; use variable-pitch font
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (defun my/nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "ETBembo"
                             :height 1.0))
  )

(provide 'my-config-nov)
;;; my-config-nov.el ends here
