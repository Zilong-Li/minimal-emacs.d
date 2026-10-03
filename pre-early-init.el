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
  (setq ns-use-proxy-icon nil)

  ;; Homebrew GCC keeps the emulated TLS library below a target/version
  ;; directory.  libgccjit needs that directory when linking native code,
  ;; including the trampolines used to advise primitives such as recursive-edit.
  (let ((library
         (car (append
               (file-expand-wildcards
                "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/*/*/libemutls_w.a")
               (file-expand-wildcards
                "/usr/local/opt/gcc/lib/gcc/current/gcc/*/*/libemutls_w.a")))))
    (when library
      (let* ((directory (directory-file-name (file-name-directory library)))
             (paths (split-string (or (getenv "LIBRARY_PATH") "")
                                  path-separator t)))
        (unless (member directory paths)
          (setenv "LIBRARY_PATH"
                  (mapconcat #'identity (cons directory paths)
                             path-separator)))))))
