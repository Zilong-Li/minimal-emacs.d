;;; my-config-org-agenda.el --- Personal org-agenda configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package org-agenda
  :defer t
  :commands org-agenda
  :bind (("C-c a" . org-agenda))
  :custom
  (org-agenda-window-setup 'current-window)
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-show-all-dates nil)
  (org-agenda-time-in-grid t)
  (org-agenda-show-current-time-in-grid t)
  (org-agenda-start-on-weekday 1)
  (org-agenda-span 7)
  (org-agenda-hide-tags-regexp ".") ; No tags
  (org-agenda-tags-column 0)
  (org-agenda-block-separator nil)
  (org-agenda-category-icon-alist nil)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-sticky t)
  ;; files
  (org-agenda-files (list (expand-file-name "inbox.org" org-directory)
                          (expand-file-name "bookmarks.org" org-directory)
                          (expand-file-name "life.org" org-directory)
                          (expand-file-name "projects.org" org-directory)))
  ;; prefix
  (org-agenda-prefix-format
   '((agenda . "%i %?-12t%s")
     (todo .   "%i")
     (tags .   "%i")
     (search . "%i")))
  ;; sorting strategy
  (org-agenda-sorting-strategy
   '((agenda deadline-down scheduled-down todo-state-up time-up
             habit-down priority-down category-keep)
     (todo   priority-down category-keep)
     (tags   timestamp-up priority-down category-keep)
     (search category-keep)))
  ;; grid looking
  (org-agenda-time-grid
   '((daily today require-timed)
     ()
     "......" "----------------"))
  (org-agenda-current-time-string "   now")

  (org-agenda-custom-commands
   '(
     ("d" "Get Things Done (GTD)"
      (
       (todo "NEXT|TODO"
             ( (org-agenda-todo-keyword-format ":%s:")
               (org-agenda-prefix-format '((todo   . " ")))
               ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
               (org-agenda-overriding-header (propertize "📅 TODO \n" 'face 'nano-strong))))

       (tags "DEADLINE>=\"<today>\""
             ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
              (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
              (org-agenda-overriding-header "\n🔔 Upcoming deadlines \n")))

       ;; (tags "events"
       ;;       ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
       ;;        (org-agenda-overriding-header "\n🫂 Upcoming events \n")))

       ;; (tags-todo "travel+SCHEDULED>=\"<today>\""
       ;;            ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
       ;;             (org-agenda-overriding-header "\n✈ Upcoming travels \n")))

       (tags-todo "DEADLINE<\"<today>\""
                  ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
                   (org-agenda-overriding-header "\n🦀 Overdue \n")))

       ))))

  :init

  ;; Save the corresponding buffers
  (defun gtd-save-org-buffers ()
    "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
    (interactive)
    (message "Saving org-agenda-files buffers...")
    (save-some-buffers t (lambda ()
                                       (when (member (buffer-file-name) org-agenda-files)
                                         t)))
    (message "Saving org-agenda-files buffers... done"))

  ;; Add it after refile
  (advice-add 'org-refile :after
                  (lambda (&rest _)
                    (gtd-save-org-buffers)))
  ;; save buffers after agenda quit
  (advice-add 'org-agenda-quit :before 'gtd-save-org-buffers)

  )



(defun my/org-agenda-highlight-todo (x)
  (let* ((done (string-match-p (regexp-quote ":DONE:") x))
         (canceled (string-match-p (regexp-quote "~") x))
         (x (replace-regexp-in-string ":TODO:" "" x))
         (x (replace-regexp-in-string ":NEXT:" "" x))
         (x (replace-regexp-in-string ":IDEA:" "" x))
         (x (replace-regexp-in-string ":DONE:" "" x))
         (x (replace-regexp-in-string "~" "" x))
         (x (if (and (boundp 'org-agenda-dim) org-agenda-dim)
                (propertize x 'face 'nano-faded) x))
         (x (if done (propertize x 'face 'nano-faded) x))
         (x (if canceled (propertize x 'face 'nano-faded) x)))
    x))

(advice-add 'org-agenda-highlight-todo
            :filter-return #'my/org-agenda-highlight-todo)


(defun my/org-agenda-custom-date ()
  "Return the entry's date without requiring SVG packages."
  (let ((timestamp (or (org-entry-get nil "TIMESTAMP")
                       (org-entry-get nil "SCHEDULED")
                       (org-entry-get nil "DEADLINE"))))
    (if timestamp
        (propertize (format-time-string "%d/%m"
                                        (org-time-string-to-time timestamp))
                    'face 'nano-popout)
      "     ")))

;; Package installation is declared in my-config-bootstrap.el.

(provide 'my-config-org-agenda)
;;; my-config-org-agenda.el ends here
