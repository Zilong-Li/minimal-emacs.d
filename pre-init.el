;;; pre-init.el --- Bootstrap Straight -*- no-byte-compile: t; lexical-binding: t; -*-

(when (version< emacs-version "29")
  (error "This personal configuration requires Emacs 29 or newer"))
(require 'use-package)
(setq use-package-always-ensure nil
      straight-use-package-by-default nil
      straight-check-for-modifications nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         (or (bound-and-true-p straight-base-dir)
                             user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (require 'url)
    (let ((buffer
           (url-retrieve-synchronously
            "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
            'silent 'inhibit-cookies)))
      (unless (buffer-live-p buffer)
        (error "Unable to download Straight bootstrap; check your connection"))
      (unwind-protect
          (with-current-buffer buffer
            (goto-char (point-max))
            (eval-print-last-sexp))
        (kill-buffer buffer))))
  (load bootstrap-file nil 'nomessage))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
