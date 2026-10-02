;;; pre-init.el --- Bootstrap Elpaca -*- no-byte-compile: t; lexical-binding: t; -*-

(when (version< emacs-version "29")
  (error "This personal configuration requires Emacs 29 or newer"))
(require 'use-package)
(setq use-package-always-ensure nil)

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order
  '(elpaca :repo "https://github.com/progfolio/elpaca.git"
           :ref nil :depth 1 :inherit ignore
           :files (:defaults "elpaca-test.el" (:exclude "extensions"))
           :build (:not elpaca-activate)))

(let* ((repo (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory)))
  (unless (file-exists-p (expand-file-name "elpaca.el" repo))
    (make-directory elpaca-sources-directory t)
    (with-current-buffer (get-buffer-create "*elpaca-bootstrap*")
      (unless (zerop (call-process "git" nil t t "clone" "--depth=1"
                                  "--no-single-branch"
                                  (plist-get (cdr elpaca-order) :repo) repo))
        (error "Elpaca clone failed; see *elpaca-bootstrap*. Remove the incomplete clone before retrying"))))
  (add-to-list 'load-path (if (file-directory-p build) build repo))
  (require 'elpaca)
  (unless (require 'elpaca-autoloads nil t)
    (elpaca-generate-autoloads "elpaca" repo)
    (load (expand-file-name "elpaca-autoloads.el" repo) nil t)))

(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))
(elpaca (elpaca-use-package :wait nil)
  (elpaca-use-package-mode 1))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
