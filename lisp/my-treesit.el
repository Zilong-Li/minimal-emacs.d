;;; my-treesit.el --- Optional native tree-sitter for Emacs 29+ -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'treesit)

(defvar my/treesit-modes
  '((bash-ts-mode (bash) (sh-mode bash-mode))
    (c-ts-mode (c cpp) (c-mode))
    (c++-ts-mode (c cpp) (c++-mode))
    (cmake-ts-mode (cmake) (cmake-mode))
    (makefile-ts-mode (make) (makefile-mode))
    (css-ts-mode (css) (css-mode))
    (java-ts-mode (java) (java-mode))
    (js-ts-mode (javascript) (js-mode javascript-mode js2-mode))
    (json-ts-mode (json) (js-json-mode json-mode))
    (python-ts-mode (python) (python-mode))
    (ruby-ts-mode (ruby) (ruby-mode))
    ;; These modes share libraries containing queries for both grammars.
    (go-ts-mode (go gomod) (go-mode))
    (go-mod-ts-mode (go gomod) (go-mod-mode))
    (typescript-ts-mode (typescript tsx) (typescript-mode))
    (tsx-ts-mode (typescript tsx) (typescript-tsx-mode))
    (toml-ts-mode (toml) (conf-toml-mode toml-mode))
    (yaml-ts-mode (yaml) (yaml-mode)))
  "Entries (TS-MODE GRAMMARS CLASSIC-MODES) eligible for automatic remapping.
Only modes supplied by the running Emacs or installed packages are used.
Rust stays in `rust-mode' to preserve its rustfmt-on-save integration.")

(defvar my/treesit-file-modes
  '(("\\.tsx\\'" tsx-ts-mode js-mode)
    ("\\.ts\\'" typescript-ts-mode js-mode)
    ("/go\\.mod\\'" go-mod-ts-mode fundamental-mode))
  "File associations without a built-in classic mode: (REGEXP TS FALLBACK).")

(defvar my/treesit-sources
  '((bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3")
    (c "https://github.com/tree-sitter/tree-sitter-c" "v0.23.6")
    (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")
    (cmake "https://github.com/uyha/tree-sitter-cmake")
    (make "https://github.com/tree-sitter-grammars/tree-sitter-make" "v1.1.1")
    (css "https://github.com/tree-sitter/tree-sitter-css" "v0.23.2")
    (java "https://github.com/tree-sitter/tree-sitter-java" "v0.23.5")
    (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1")
    (json "https://github.com/tree-sitter/tree-sitter-json" "v0.24.8")
    (python "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
    (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
    (go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4")
    (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.1.0")
    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src")
    (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src")
    (toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
    (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "v0.7.2"))
  "Grammar recipes, with ABI 14 revisions for grammars now generated for ABI 15.
Keep the same revisions on newer Emacs to avoid unexpected schema changes.
Existing entries in `treesit-language-source-alist' take precedence.")

(defvar my/treesit--remaps nil "Remappings owned by this configuration.")
(defvar my/treesit--file-associations nil "File associations owned by this configuration.")

(defun my/treesit-mode-ready-p (mode)
  "Return non-nil when MODE exists and all its grammars are loadable."
  (let ((entry (assq mode my/treesit-modes)))
    (and entry (fboundp mode) (treesit-available-p)
         (cl-every #'treesit-language-available-p (nth 1 entry)))))

(defun my/treesit-refresh (&rest _)
  "Refresh conditional mode mappings after grammar installation.
Preserve unrelated mappings and prefer explicit user mappings.
Existing buffers keep their current major mode."
  (interactive)
  (setq major-mode-remap-alist
        (cl-remove-if (lambda (entry) (member entry my/treesit--remaps))
                      major-mode-remap-alist)
        auto-mode-alist
        (cl-remove-if (lambda (entry) (member entry my/treesit--file-associations))
                      auto-mode-alist)
        my/treesit--remaps nil
        my/treesit--file-associations nil)
  (dolist (entry my/treesit-modes)
    (if (my/treesit-mode-ready-p (car entry))
        (dolist (classic (nth 2 entry))
          (unless (assq classic major-mode-remap-alist)
            (let ((mapping (cons classic (car entry))))
              (push mapping major-mode-remap-alist)
              (push mapping my/treesit--remaps))))
      ;; Built-in libraries can also add direct TS file associations.  Make
      ;; those fall back if their grammar is no longer loadable.
      (let ((classic (cl-find-if #'fboundp (nth 2 entry))))
        (when (and classic (not (assq (car entry) major-mode-remap-alist)))
          (let ((mapping (cons (car entry) classic)))
            (push mapping major-mode-remap-alist)
            (push mapping my/treesit--remaps))))))
  (dolist (entry my/treesit-file-modes)
    (let ((mapping (cons (car entry)
                         (if (my/treesit-mode-ready-p (nth 1 entry))
                             (nth 1 entry) (nth 2 entry)))))
      (unless (assoc (car entry) auto-mode-alist)
        (push mapping auto-mode-alist)
        (push mapping my/treesit--file-associations)))))

(defun my/treesit-install-all-missing ()
  "Install missing or incompatible grammars needed by available modes.
Use the one-argument installer supported by Emacs 29 and newer.
Never download grammars during startup or when opening a file."
  (interactive)
  (unless (treesit-available-p)
    (user-error "This Emacs was built without native tree-sitter support"))
  (let ((languages (delete-dups
                    (cl-loop for entry in my/treesit-modes
                             when (fboundp (car entry))
                             append (copy-sequence (nth 1 entry)))))
        installed failed)
    (dolist (language languages)
      (unless (treesit-language-available-p language)
        (condition-case err
            (progn
              (treesit-install-language-grammar language)
              ;; The built-in installer may warn instead of signalling errors.
              (if (treesit-language-available-p language)
                  (push language installed)
                (push language failed)
                (display-warning 'my-treesit
                                 (format "%s is still unavailable; see *Warnings*" language))))
          (error
           (push language failed)
           (display-warning 'my-treesit
                            (format "%s: %s" language (error-message-string err)))))))
    (my/treesit-refresh)
    (message "Tree-sitter: installed %s; failed %s"
             (or (nreverse installed) "none") (or (nreverse failed) "none"))))

(defun my/treesit-status ()
  "Show supported modes and grammar availability, including ABI errors."
  (interactive)
  (with-help-window "*Tree-sitter status*"
    (princ (format "Emacs %s; native tree-sitter: %s\n\n"
                   emacs-version (if (treesit-available-p) "available" "unavailable")))
    (dolist (entry my/treesit-modes)
      (princ (format "%s: %s\n" (car entry)
                     (cond ((not (fboundp (car entry))) "mode not installed")
                           ((my/treesit-mode-ready-p (car entry)) "ready")
                           (t "using classic mode"))))
      (dolist (language (nth 1 entry))
        (princ (format "  %s: %S\n" language
                       (if (treesit-available-p)
                           (treesit-language-available-p language t)
                         "native tree-sitter unavailable")))))
    (princ "\nM-x my/treesit-install-all-missing installs needed grammars.\n")
    (princ "M-x my/treesit-refresh refreshes mode selection; reopen files afterward.\n")))

(setq treesit-font-lock-level 3)
(dolist (source my/treesit-sources)
  (unless (assq (car source) treesit-language-source-alist)
    (push source treesit-language-source-alist)))
(my/treesit-refresh)
(unless (advice-member-p #'my/treesit-refresh #'treesit-install-language-grammar)
  (advice-add 'treesit-install-language-grammar :after #'my/treesit-refresh))

(provide 'my-treesit)
;;; my-treesit.el ends here
