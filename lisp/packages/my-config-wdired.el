;;; my-config-wdired.el --- Personal wdired configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package wdired
  :defer t
  :after dired
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t)

  :bind
  (:map dired-mode-map
        ("K" . wdired-change-to-wdired-mode)))

(provide 'my-config-wdired)
;;; my-config-wdired.el ends here
