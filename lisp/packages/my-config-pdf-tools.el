;;; my-config-pdf-tools.el --- Personal pdf-tools configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/pdf-view-open-file ()
  (interactive)
  (shell-command (format "open \"%s\"" (buffer-file-name))))

(use-package pdf-tools
  :ensure nil
  :magic ("%PDF" . pdf-view-mode)
  :bind (:map
         pdf-view-mode-map
         ("O" . my/pdf-view-open-file))
  :config
  ;; Install the epdfinfo server if not already built
  (pdf-tools-install :no-query)

  ;; Use pdf-loader-install instead for faster startup:
  ;; (pdf-loader-install)

  ;; Disable incompatible modes in pdf-view buffers
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (display-line-numbers-mode -1)))

  ;; Optional: enable continuous scroll mode by default
  ;; (add-hook 'pdf-view-mode-hook #'pdf-view-roll-minor-mode)

  ;; Optional: fix rendering on non-HiDPI screens
  ;; (setq pdf-view-use-scaling nil)
  )

(provide 'my-config-pdf-tools)
;;; my-config-pdf-tools.el ends here
