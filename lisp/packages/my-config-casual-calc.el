;;; my-config-casual-calc.el --- Personal casual-calc configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package casual-calc
  :after (calc)
  :bind (:map
         calc-mode-map
         ("C-M-l" . casual-calc-tmenu)
         :map
         calc-alg-map
         ("C-M-l" . casual-calc-tmenu))
  )

(provide 'my-config-casual-calc)
;;; my-config-casual-calc.el ends here
