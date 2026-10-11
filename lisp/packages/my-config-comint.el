;;; my-config-comint.el --- Personal comint configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package comint
  :defer t
  :custom
  (comint-input-ring-size 1000)
  (comint-scroll-to-bottom-on-input t)
  (comint-process-echoes t)
  (comint-prompt-read-only t)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
  (add-hook 'comint-mode-hook (lambda () (setq-local corfu-auto nil)))
  )

(provide 'my-config-comint)
;;; my-config-comint.el ends here
