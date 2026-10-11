;;; my-config-casual-ibuffer.el --- Personal casual-ibuffer configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package casual-ibuffer
  :after (ibuffer)
  :bind (:map
         ibuffer-mode-map
         ("C-M-l" . casual-ibuffer-tmenu)
         ("F" . casual-ibuffer-filter-tmenu)
         ("s" . casual-ibuffer-sortby-tmenu)))

(provide 'my-config-casual-ibuffer)
;;; my-config-casual-ibuffer.el ends here
