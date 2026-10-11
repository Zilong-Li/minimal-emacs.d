;;; my-config-window-helpers.el --- Personal window-helpers configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq-default window-divider-default-right-width 24
              window-divider-default-places 'right-only
              left-margin-width 0
              right-margin-width 0
              window-combination-resize nil) ; Do not resize windows proportionally

(window-divider-mode 1)

;; Make a window dedicated
(defun my/toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
     (set-window-dedicated-p window (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer))
  (force-window-update))

(provide 'my-config-window-helpers)
;;; my-config-window-helpers.el ends here
