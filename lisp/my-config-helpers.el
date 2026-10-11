;;; my-config-helpers.el --- Personal helpers configuration -*- no-byte-compile: t; lexical-binding: t; -*-

;; Straight installs and activates each package before returning, so direct
;; package module require calls can use the packages immediately.

(defun my-ensure (feature)
  "Make sure FEATURE is required."
  (unless (featurep feature)
    (condition-case nil
        (require feature)
      (error nil))))

;; (setq my-disable-idle-timer t)
;; Light weight mode, fewer packages are used.
(setq my-lightweight-mode-p (and (boundp 'startup-now) (eq startup-now t)))

(defvar my-disable-idle-timer (daemonp)
  "Function passed to `my-run-with-idle-timer' is run immediately.")

(defun my-run-with-idle-timer (seconds func)
  "After SECONDS, run function FUNC once."
  (cond
   ((or my-disable-idle-timer my-lightweight-mode-p)
    (funcall func))
   (t
    (run-with-idle-timer seconds nil func))))

(provide 'my-config-helpers)
;;; my-config-helpers.el ends here
