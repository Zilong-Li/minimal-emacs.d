;;; my-config-casual.el --- Personal casual configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package casual
  :defer t
  :custom
  (casual-lib-use-unicode t)
  :config
  (require 'my-config-casual-calc "packages/my-config-casual-calc")

  (require 'my-config-casual-ibuffer "packages/my-config-casual-ibuffer")
  )

(provide 'my-config-casual)
;;; my-config-casual.el ends here
