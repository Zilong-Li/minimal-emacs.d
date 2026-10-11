;;; my-config-org-todo.el --- Personal org-todo configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq my/section-start-time (current-time))


(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))

(with-eval-after-load 'org
  (add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date))

(provide 'my-config-org-todo)
;;; my-config-org-todo.el ends here
