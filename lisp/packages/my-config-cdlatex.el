;;; my-config-cdlatex.el --- Personal cdlatex configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package cdlatex
  :defer t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (latex-mode . turn-on-cdlatex))
  )

(provide 'my-config-cdlatex)
;;; my-config-cdlatex.el ends here
