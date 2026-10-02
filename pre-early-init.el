;;; pre-early-init.el --- Personal startup choices -*- no-byte-compile: t; lexical-binding: t; -*-

(setq minimal-emacs-package-initialize-and-refresh nil
      minimal-emacs-disable-mode-line-during-startup nil
      vc-handled-backends '(Git))

;; Set these before creating the first graphical frame (also covers daemons).
(dolist (parameter '((left-fringe . 0) (right-fringe . 0)
                     (alpha-background . 0.7)
                     (ns-background-blur . 30)
                     (ns-alpha-elements . (ns-alpha-all))))
  (add-to-list 'default-frame-alist parameter))
(when (eq system-type 'darwin)
  (setq ns-use-proxy-icon nil))
