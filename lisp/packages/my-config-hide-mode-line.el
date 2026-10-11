;;; my-config-hide-mode-line.el --- Personal hide-mode-line configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(require 'hide-mode-line)
;; we hide the emacs mode-line but not the nano-modeline
(global-hide-mode-line-mode)

(defun my/toggle-emacs-mode-line ()
  "toggle hide-mode-line-mode"
  (interactive)
  (if hide-mode-line-format
      (progn
        (setq-local hide-mode-line--old-format hide-mode-line-format
                    hide-mode-line-format nil)
        (turn-on-hide-mode-line-mode))
    (progn
      (setq-local hide-mode-line-format hide-mode-line--old-format
                  hide-mode-line--old-format nil)
      (turn-on-hide-mode-line-mode))
    )
  )

(bind-key "C-c l s" #'my/toggle-emacs-mode-line)
(my/report-time "Theme")

(setq my/section-start-time (current-time))

(provide 'my-config-hide-mode-line)
;;; my-config-hide-mode-line.el ends here
