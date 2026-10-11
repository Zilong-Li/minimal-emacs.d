;;; my-config-startup-report.el --- Personal startup-report configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(let ((init-time (float-time (time-subtract (current-time) my/init-start-time)))
      (total-time (string-to-number (emacs-init-time "%f"))))

  (message "---------------------------------------------------------------")
  (message "Initialization time:                 %.2fs (+ %.2f system time)"
           init-time (- total-time init-time)))
  (message "---------------------------------------------------------------")

(provide 'my-config-startup-report)
;;; my-config-startup-report.el ends here
