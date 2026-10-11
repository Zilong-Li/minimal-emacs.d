;;; my-config-org-timegrid-agenda.el --- Personal org-timegrid-agenda configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package org-timegrid-agenda
  :ensure nil
  :after org-agenda
  :demand t
  :init
  ;; nil inserts the strip at the top. To place it after a particular custom
  ;; agenda block, use a regexp matching that block's heading instead.
  (setq org-timegrid-agenda-insert-after nil
        org-timegrid-agenda-separator t
        org-timegrid-agenda-minutes-before 180
        org-timegrid-agenda-minutes-after 180)
  :config
  (org-timegrid-agenda-mode 1))

(provide 'my-config-org-timegrid-agenda)
;;; my-config-org-timegrid-agenda.el ends here
