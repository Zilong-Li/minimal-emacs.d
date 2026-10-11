;;; my-config-eglot-orderless.el --- Personal eglot-orderless configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package eglot-orderless
  :no-require t
  :after (eglot orderless)
  :config
  ;; Option 1: Specify explicitly to use Orderless for Eglot
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless))))
  )
(my/report-time "languages")

(provide 'my-config-eglot-orderless)
;;; my-config-eglot-orderless.el ends here
