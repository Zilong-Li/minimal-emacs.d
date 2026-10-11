;;; my-config-vertico-directory.el --- Personal vertico-directory configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package vertico-directory
  :after vertico
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("TAB" . vertico-insert)
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(provide 'my-config-vertico-directory)
;;; my-config-vertico-directory.el ends here
