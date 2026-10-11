;;; my-config-org-timegrid.el --- Personal org-timegrid configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package org-timegrid
  :ensure nil
  :demand t
  :bind ("C-c g" . org-timegrid-week)
  :init
  ;; The symbol `agenda' means: read events from `org-agenda-files'.
  (setq org-timegrid-org-files 'agenda
        org-timegrid-org-capture-file
        (expand-file-name "calendar.org" org-directory)
        org-timegrid-org-capture-template
        '(:target file
                  :template "* %{title}\n%{time-range}\n%?")

        ;; Save Org buffers immediately after edits made in the calendar.
        org-timegrid-org-auto-save t

        ;; Set this to nil if repeating entries should be hidden.
        org-timegrid-org-show-repeaters t

        ;; The first matching tag supplies an event's colour.
        org-timegrid-org-tag-color-alist
        '(("work"     . indigo)
          ("personal" . green)
          ("reading"  . yellow)
          ("errand"   . cyan)))
  :config
  ;; This is part of the same package. It adds a read-only day strip to Org
  ;; Agenda; pressing RET on the strip opens the editable week view.
  (require 'my-config-org-timegrid-agenda "packages/my-config-org-timegrid-agenda")
  )

(provide 'my-config-org-timegrid)
;;; my-config-org-timegrid.el ends here
