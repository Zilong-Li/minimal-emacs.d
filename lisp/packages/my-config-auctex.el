;;; my-config-auctex.el --- Personal auctex configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package auctex
  :defer t
  :hook (LaTeX-mode . flyspell-mode)
  :hook (LaTeX-mode . xenops-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil))

;; RefTeX for managing references

(provide 'my-config-auctex)
;;; my-config-auctex.el ends here
