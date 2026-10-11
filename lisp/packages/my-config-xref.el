;;; my-config-xref.el --- Personal xref configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package xref
  :defer t
  :config
  (setq-default xref-history-storage 'xref-window-local-history))

(provide 'my-config-xref)
;;; my-config-xref.el ends here
