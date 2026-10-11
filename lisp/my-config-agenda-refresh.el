;;; my-config-agenda-refresh.el --- Personal agenda-refresh configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defvar my/org-agenda-update-delay 60)
(defvar my/org-agenda-update-timer nil)

(defun my/org-agenda-update ()
  "Refresh daily agenda view"

  (when my/org-agenda-update-timer
    (cancel-timer my/org-agenda-update-timer))

  (let ((window (get-buffer-window "*Org Agenda(a)*" t)))
    (when window
      (with-selected-window window
        (let ((inhibit-message t))
          (org-agenda-redo)))))

  (setq my/org-agenda-update-timer
    (run-with-idle-timer
     (time-add (current-idle-time) my/org-agenda-update-delay)
     nil
     'my/org-agenda-update)))

(run-with-idle-timer my/org-agenda-update-delay t 'my/org-agenda-update)

(provide 'my-config-agenda-refresh)
;;; my-config-agenda-refresh.el ends here
