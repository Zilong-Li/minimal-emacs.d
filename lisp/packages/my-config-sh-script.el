;;; my-config-sh-script.el --- Personal sh-script configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq my/section-start-time (current-time))

(use-package sh-script
  :defer t
  :init
  (defun my/get-or-create-project-shell ()
    "Get or create a shell buffer for current project."
    (let* ((default-directory (project-root (project-current t)))
           (repl-name (project-prefixed-buffer-name "shell")))
      (unless (get-buffer repl-name) (shell repl-name))
      repl-name))

  (defun my/sh-send-line-or-region-and-step ()
    (interactive)
    (let ((repl-name (my/get-or-create-project-shell)))
      (my/repl-send-line-or-region repl-name t)
      )
    )

  (defun my/sh-send-paragraph-and-step ()
    (interactive)
    (let ((repl-name (my/get-or-create-project-shell)))
      (mark-paragraph 1)
      (my/repl-send-line-or-region repl-name t)
      )
    )
  :bind
  ( :map sh-base-mode-map
    ("<C-return>" . my/sh-send-line-or-region-and-step)
    ("C-c C-c" . my/sh-send-paragraph-and-step)
    )
  :custom
  (sh-basic-offset 2)
  (sh-indent-comment t)
  )

(provide 'my-config-sh-script)
;;; my-config-sh-script.el ends here
