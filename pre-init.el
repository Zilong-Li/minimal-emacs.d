;;; pre-init.el --- Personal load path -*- no-byte-compile: t; lexical-binding: t; -*-

(when (version< emacs-version "31")
  (error "This personal configuration requires Emacs 31 or newer"))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Activate installed packages from `package-quickstart-file' instead of the
;; much slower `package-initialize'.  package.el itself is only loaded when a
;; declared package is missing and has to be installed.
(package-activate-all)

(defun my/package-installed-p (name)
  "Return non-nil if package NAME is installed, without loading package.el."
  (or (memq name (bound-and-true-p package-activated-list))
      (file-directory-p (locate-user-emacs-file (format "elpa/%s" name)))))

(setq use-package-ensure-function
      (lambda (name args state &optional no-refresh)
        (unless (my/package-installed-p (if (eq (car args) t) name (car args)))
          (use-package-ensure-elpa name args state no-refresh))))
(advice-add 'use-package-vc-install :before-until
            (lambda (arg &rest _) (my/package-installed-p (car arg))))

;;; pre-init.el ends here
