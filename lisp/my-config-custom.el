;;; my-config-custom.el --- Personal custom configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file nil t))

(provide 'my-config-custom)
;;; my-config-custom.el ends here
