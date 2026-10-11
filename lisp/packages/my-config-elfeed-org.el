;;; my-config-elfeed-org.el --- Personal elfeed-org configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list (concat user-emacs-directory "elfeed.org") ))
  )

(provide 'my-config-elfeed-org)
;;; my-config-elfeed-org.el ends here
