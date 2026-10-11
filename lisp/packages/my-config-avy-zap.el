;;; my-config-avy-zap.el --- Personal avy-zap configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package avy-zap
  :bind (("M-z" . avy-zap-up-to-char-dwim)
         ("M-Z" . avy-zap-to-char-dwim)))

(provide 'my-config-avy-zap)
;;; my-config-avy-zap.el ends here
