;;; my-config-hl-line.el --- Personal hl-line configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package hl-line
  :commands hl-line-mode
  :hook (prog-mode . hl-line-mode)
  )

(provide 'my-config-hl-line)
;;; my-config-hl-line.el ends here
