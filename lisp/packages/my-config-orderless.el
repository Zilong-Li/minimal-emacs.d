;;; my-config-orderless.el --- Personal orderless configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil) ; this the default used by the below
  (completion-category-overrides '((file (styles  partial-completion))))
  (completion-pcm-leading-wildcard t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  )

(provide 'my-config-orderless)
;;; my-config-orderless.el ends here
