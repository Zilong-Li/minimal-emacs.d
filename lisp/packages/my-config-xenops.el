;;; my-config-xenops.el --- Personal xenops configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package xenops
  :defer t
  :hook (latex-mode . xenops-mode)
  :custom
  ;; Automatically show raw LaTeX when cursor enters a math block
  (xenops-reveal-on-entry t)
  ;; Keep math/diagram rendering crisp
  (xenops-math-image-scale-factor 1.2))

(provide 'my-config-xenops)
;;; my-config-xenops.el ends here
