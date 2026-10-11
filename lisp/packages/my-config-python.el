;;; my-config-python.el --- Personal python configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package python
  :bind
  ( :map python-mode-map
    ("<C-return>" . my/python-send-dwim)
    ("C-c C-p" . my/run-python-at-project-root)
    :map python-ts-mode-map
    ("<C-return>" . my/python-send-dwim)
    ("C-c C-p" . my/run-python-at-project-root)
    :map inferior-python-mode-map
    ("<up>" . cape-history)
    )

  :hook
  (python-base-mode . my/python-init)

  :hook
  (inferior-python-mode . (lambda ()
                            (buffer-box-on)
                            (setq-local completion-at-point-functions '(cape-file
                                                                        cape-dabbrev
                                                                        python-completion-at-point))))
  :init

  (defun my/python-init ()
    (setq-local completion-at-point-functions
                '(tempel-expand
                  cape-file
                  cape-dabbrev
                  python-completion-at-point))
    (my/ruff-format-on-save-mode +1)
    ;; (my/ruff-sort-on-save-mode +1)
    )

  (defun my/run-python-at-project-root ()
    "Run Python REPL at project root and pop to it."
    (interactive)
    (let ((default-directory
           (or (when-let* ((project (project-current)))
                 (project-root project))
               default-directory)))
      (run-python (python-shell-calculate-command) nil nil)
      (pop-to-buffer (process-buffer (python-shell-get-process)))))

  (defun my/python-send-dwim ()
    "Send the appropriate Python code to REPL based on context."
    (interactive)
    (cond
     ;; If region is active, send region
     ((use-region-p)
      (python-shell-send-region (region-beginning) (region-end)))
     ;; If in a function/class, send the whole definition
     ((python-info-current-defun)
      (python-shell-send-defun nil))
     ;; Otherwise send current line
     (t
      (python-shell-send-statement))))

  (setq python-interpreter "python3") ; for non-interactive
  (setq python-shell-interpreter "python3")
  (setq python-shell-completion-native-enable nil) ; disable readline completion
  ;; Let Emacs guess Python indent silently
  (setq python-indent-guess-indent-offset t
        python-indent-guess-indent-offset-verbose nil)
  (setq python-flymake-command "ruff")

  )

(provide 'my-config-python)
;;; my-config-python.el ends here
