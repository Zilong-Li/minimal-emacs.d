;;; my-config-startup.el --- Personal startup configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defvar my/init-start-time (current-time) "Time when init.el was started")
(defvar my/section-start-time (current-time) "Time when section was started")
(defun my/report-time (section)
  (message "%-36s %.2fs"
           (concat section " " "section time: ")
           (float-time (time-subtract (current-time) my/section-start-time))))
(message "===================================================================")
;; Load native tree-sitter and personal setup before the Meow integration.
(require 'my-treesit)

(provide 'my-config-startup)
;;; my-config-startup.el ends here
