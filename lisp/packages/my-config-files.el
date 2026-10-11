;;; my-config-files.el --- Personal files configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package files
  :defer t
  :bind
  (:map global-map
        ("C-c f f" . find-file)
        ("C-c f c" . copy-file)
        ("C-c f C" . my/copy-file-to-download-folder)
        ("C-c f u" . my/upload-file-to-remote-folder)
        ("C-c f d" . delete-file)
        ("C-c f m" . rename-file)
        ("C-c f g" . find-file-at-point)
        ("C-c f p" . camdez/show-buffer-file-name)
        ("C-c f t" . find-file-other-tab)
        ("C-c f r" . consult-recent-file)
        ("C-c f R" . find-file-read-only)
        )
  :init

  (defun camdez/show-buffer-file-name ()
    "Show the full path to the current file in the minibuffer."
    (interactive)
    (let ((file-name (buffer-file-name)))
      (if file-name
          (progn
            (message file-name)
            (kill-new file-name))
        (error "Buffer not visiting a file"))))
  )

(provide 'my-config-files)
;;; my-config-files.el ends here
