;;; my-config-shell.el --- Personal shell configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/shell-setup ()
  "Setup custom modeline and auto-cleanup for shell mode."
  ;; Custom modeline
  (nano-modeline nano-modeline-format-terminal)
  (setq-local corfu-auto nil)
  (setq-local completion-styles '(basic)) ;; disable `orderless'
  (corfu-mode) ;; enable

  (require 'pcmpl-args) ; completion for linux commands

  ;; Auto-kill buffer when shell process exits
  (when-let* ((proc (get-buffer-process (current-buffer))))
    (set-process-sentinel proc
                          (lambda (process _event)
                            (when (memq (process-status process) '(exit signal))
                              (when-let* ((buf (process-buffer process)))
                                (when (buffer-live-p buf)
                                  (kill-buffer buf))))))))

(with-eval-after-load 'shell
  (native-complete-setup-bash)
  (add-hook 'shell-mode-hook 'my/shell-setup)
  )

(provide 'my-config-shell)
;;; my-config-shell.el ends here
