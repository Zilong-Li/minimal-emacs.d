;;; my-config-ansi-color.el --- Personal ansi-color configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ansi-color
  :defer t
  :config
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  )

(setq my/section-start-time (current-time))

(provide 'my-config-ansi-color)
;;; my-config-ansi-color.el ends here
