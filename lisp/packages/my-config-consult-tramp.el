;;; my-config-consult-tramp.el --- Personal consult-tramp configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package consult-tramp
  :commands consult-tramp
  :bind ("C-c t r" . consult-tramp)
  :custom
  (consult-tramp-method "ssh")
  (consult-tramp-enable-shosts nil)
  )

(provide 'my-config-consult-tramp)
;;; my-config-consult-tramp.el ends here
