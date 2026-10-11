;;; my-config-agenda-navigation.el --- Personal agenda-navigation configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(add-hook 'org-agenda-after-show-hook 'org-narrow-to-subtree)

(defun my/org-agenda-goto (buffer args)
  "Open a headline in a window below the current window, reusing an existing window if possible."

  (setq-local mode-line-format nil)

  (let ((display-buffer-overriding-action nil) ;; Prevent recursion
        (target-window (or (window-in-direction 'below (selected-window))
                           (and (not (one-window-p)) (next-window))
                           (split-window-below -15))))  ;; Only split if no other window is available
    (select-window target-window)
    (switch-to-buffer buffer)

    ;; Set custom header line
    (setq-local header-line-format
                '((:eval
                   (let ((nano-modeline-prefix 'none)
                         (nano-modeline-prefix-padding 0)
                         (outline-path (org-with-point-at (org-get-at-bol 'org-marker)
                                         (org-display-outline-path nil nil " » " t))))
                     (nano-modeline-render
                      ""
                      (file-name-nondirectory
                       (buffer-file-name (buffer-base-buffer)))
                      (format "/ %s" (substring-no-properties outline-path))
                      "")))))
    (selected-window)))

;; Install the new function as an advice around org-agenda-goto and apply a narrow to subtree buffer
(define-advice org-agenda-goto (:around (orig-fn &rest args) "my/org-agenda-goto")
  (let ((display-buffer-overriding-action '(my/org-agenda-goto)))  ;; Prevent recursion
    (apply orig-fn args)
    (org-narrow-to-subtree)))

;; Disable org-agenda-show-outline-path since this is now in the header line
(setq org-agenda-show-outline-path nil)

(my/report-time "Agenda")

(provide 'my-config-agenda-navigation)
;;; my-config-agenda-navigation.el ends here
