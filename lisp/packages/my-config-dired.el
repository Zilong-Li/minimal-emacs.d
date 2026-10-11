;;; my-config-dired.el --- Personal dired configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package dired
  :defer t
  :bind
  (:map dired-mode-map
        ("a" . other-window)
        ("n" . dired-goto-file)
        ("/" . find-name-dired) ; reads arguments DIRECTORY and PATTERN
        ("," . dired-create-directory)
        ("v" . +dired-slideshow) ; remap `dired-view-file'
        ("p" . dired-up-directory)     ; remap `dired-previous-line'
        )
  :config
  (defun +dired-slideshow ()
    (interactive)
    (start-process "dired-slideshow" nil "~/.local/bin/s" (dired-current-directory)))

  (setq mouse-1-click-follows-link nil)
  (setq dired-mouse-drag-files t)                   ; added in Emacs 29
  (setq mouse-drag-and-drop-region-cross-program t) ; added in Emacs 29

  (setq-default dired-listing-switches "-lGh1v --group-directories-first")

  (setq-default dired-listing-switches
                (combine-and-quote-strings '("-l"
                                             "-v"
                                             "--group-directories"
                                             "--no-group"
                                             "--human-readable"
                                             "--time-style=+%Y-%m-%d"
                                             "--almost-all")))

  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil)

  (setq dired-clean-up-buffers-too t
        ;; split the window, open the destination in dired, then quick copy to that dir
        dired-dwim-target t
        ;; dired-use-ls-dired nil
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        global-auto-revert-non-file-buffers t
        auto-revert-verbose nil)

  )

;; use emacs-async to run commands in the background

(provide 'my-config-dired)
;;; my-config-dired.el ends here
