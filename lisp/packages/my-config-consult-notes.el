;;; my-config-consult-notes.el --- Personal consult-notes configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package consult-notes
  :commands (consult-notes
             consult-notes-search-in-all-notes)
  :config
  ;; (consult-notes-org-headings-mode)
  (when (locate-library "denote")
    (consult-notes-denote-mode))
  ;; search only for text files in denote dir
  (setq consult-notes-denote-files-function (lambda () (denote-directory-files nil t t)))
  ;; set extra dirs
  (setq consult-notes-file-dir-sources
      '(("Zll Books"  ?b "~/Dropbox/Zll/Datahub/002-Books/")))
  )

(provide 'my-config-consult-notes)
;;; my-config-consult-notes.el ends here
