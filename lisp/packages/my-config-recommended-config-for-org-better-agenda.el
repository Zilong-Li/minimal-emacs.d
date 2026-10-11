;;; my-config-recommended-config-for-org-better-agenda.el --- Personal recommended-config-for-org-better-agenda configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package recommended-config-for-org-better-agenda
  :custom
  (org-better-agenda-inbox-file (expand-file-name "inbox.org" org-directory))
  :after org-better-agenda)

(provide 'my-config-recommended-config-for-org-better-agenda)
;;; my-config-recommended-config-for-org-better-agenda.el ends here
