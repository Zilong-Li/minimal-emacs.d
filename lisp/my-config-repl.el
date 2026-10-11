;;; my-config-repl.el --- Personal repl configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/repl-send-line-or-region (repl &optional step)
  "Send current line or region to REPL buffer."
  (let ((proc (get-buffer-process repl))
        pbuf min max command)
    (unless proc
      (error "No process found for buffer %s" repl))
    (setq pbuf (process-buffer proc))  ; Fixed typo: pbuff -> pbuf
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (line-beginning-position)  ; More reliable than point-at-bol
            max (line-end-position)))      ; More reliable than point-at-eol
    (setq command (buffer-substring min max))
    (with-current-buffer pbuf
      (goto-char (process-mark proc))
      (insert command "\n")  ; Insert newline separately for clarity
      (set-marker (process-mark proc) (point))
      (setq comint-scroll-to-bottom-on-output t))
    (process-send-string proc (concat command "\n"))
    (display-buffer pbuf)
    (when step
      (goto-char max)
      (forward-line 1))  ; Use forward-line instead of next-line
    ;; Deactivate region
    (when (use-region-p)
      (deactivate-mark))))

(provide 'my-config-repl)
;;; my-config-repl.el ends here
