;;; my-prog.el --- Programming and writing modes -*- lexical-binding: t; -*-

;;; Tree-sitter

;; Use tree-sitter modes everywhere; Emacs asks once before installing a
;; missing grammar into the tree-sitter/ directory.
(setopt treesit-enabled-modes t
        treesit-font-lock-level 3)

(add-to-list 'auto-mode-alist '("\\.cuh?\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\(h?\\|xx\\|pp\\)\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.m\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-ts-mode))

;;; Shared programming setup

(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'prog-mode-hook (lambda () (ignore-errors (hs-minor-mode 1))))
(setq hs-isearch-open t)

(defvar my/todo-keywords
  '(("TODO" . warning) ("FIXME" . error) ("HACK" . font-lock-constant-face)
    ("BUG" . font-lock-keyword-face) ("NOTE" . success)
    ("DEPRECATED" . font-lock-doc-face))
  "Comment keywords highlighted in programming modes, with their faces.")

(defun my/highlight-todo-keywords ()
  "Highlight `my/todo-keywords' followed by a colon."
  (font-lock-add-keywords
   nil (mapcar (lambda (keyword)
                 `(,(concat "\\<" (car keyword) ":") 0 '(,(cdr keyword) bold) prepend))
               my/todo-keywords)))
(add-hook 'prog-mode-hook #'my/highlight-todo-keywords)

;;; Eglot and Flymake

(use-package eglot
  :bind (("C-c l e" . eglot)
         :map eglot-mode-map
         ("C-x C-t" . eglot-format)
         ("C-x C-w" . eglot-rename)
         ("C-c C-." . eglot-code-actions))
  :hook (eglot-managed-mode . my/eglot-setup)
  :config
  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["ruff"]
                             :plugins (:ruff (:enabled t :lineLength 88)
                                       :pycodestyle (:enabled :json-false)
                                       :mccabe (:enabled :json-false)
                                       :pyflakes (:enabled :json-false)
                                       :flake8 (:enabled :json-false :maxLineLength 88)
                                       :autopep8 (:enabled :json-false)
                                       :yapf (:enabled :json-false)
                                       :pydocstyle (:enabled :json-false :convention "numpy"))))))

  (defun my/eglot-setup ()
    "Show diagnostics first in ElDoc; format Python and Rust on save."
    (setq-local eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly
                eldoc-documentation-functions
                (cons #'flymake-eldoc-function
                      (remove #'flymake-eldoc-function eldoc-documentation-functions)))
    (when (derived-mode-p 'python-base-mode 'rust-ts-mode)
      (if (eglot-managed-p)
          (add-hook 'before-save-hook #'eglot-format-buffer nil t)
        (remove-hook 'before-save-hook #'eglot-format-buffer t)))))

;;; Python

(use-package python
  :bind (:map python-base-mode-map
              ("<C-return>" . my/python-send-dwim)
              ("C-c C-p" . my/run-python-at-project-root))
  :hook (python-base-mode . flymake-mode)
  :custom
  (python-interpreter "python3")
  (python-shell-interpreter "python3")
  (python-shell-completion-native-enable nil)
  ;; Ruff lints without a language server.
  (python-flymake-command '("ruff" "check" "--quiet" "--exit-zero"
                            "--output-format=concise" "--stdin-filename=stdin" "-"))
  :config
  (defun my/run-python-at-project-root ()
    "Run a Python REPL at the project root and pop to it."
    (interactive)
    (let ((default-directory (if-let* ((project (project-current)))
                                 (project-root project)
                               default-directory)))
      (run-python (python-shell-calculate-command) nil nil)
      (pop-to-buffer (process-buffer (python-shell-get-process)))))

  (defun my/python-send-dwim ()
    "Send the region, the current definition or the statement to the REPL."
    (interactive)
    (cond ((use-region-p) (python-shell-send-region (region-beginning) (region-end)))
          ((python-info-current-defun) (python-shell-send-defun nil))
          (t (python-shell-send-statement)))))

;;; R

(use-package ess-r-mode
  :ensure ess
  :bind (:map ess-r-mode-map
              ("C-c C-k" . ess-help)
              ("C-c C-f" . my/ess-R-object-popup-fed)
              ("C-c C-s" . my/ess-R-object-popup-str)
              ("C-c C-r" . my/ess-R-object-popup-interactive))
  :hook (inferior-ess-mode . my/inferior-ess-setup)
  :init
  (setq ess-eval-visibly 'nowait
        inferior-ess-r-program-name "~/.local/bin/R"
        ess-use-company nil
        ess-history-file nil
        ess-history-directory nil
        ess-style 'RStudio)
  :config
  (require 'ess-r-package)

  (defun my/ess-R-object-popup (r-func)
    "Run R-FUNC on the object at point and show the result in a help window."
    (interactive "sR function to execute: ")
    (when-let* ((object (current-word)))
      (let ((buffer (get-buffer-create " *ess-R-object-popup*")))
        (ess-command (format "class(%s)\n" object) buffer)
        (unless (string-match-p "object .* not found\\|unexpected"
                                (with-current-buffer buffer (buffer-string)))
          (ess-command (format "%s(%s)\n" r-func object) buffer)
          (let ((output (with-current-buffer buffer (buffer-string))))
            (with-help-window "*ESS Object*" (princ output))))
        (kill-buffer buffer))))
  (defun my/ess-R-object-popup-fed () (interactive) (my/ess-R-object-popup "fed"))
  (defun my/ess-R-object-popup-str () (interactive) (my/ess-R-object-popup "str"))
  (defalias 'my/ess-R-object-popup-interactive #'my/ess-R-object-popup)

  (defun my/ess-quit-or-delete-char (arg)
    "Delete ARG characters, or quit R at an empty prompt."
    (interactive "p")
    (if (and (eolp) (looking-back "^[>+] " (line-beginning-position)))
        (ess-quit)
      (delete-forward-char arg)))

  (defun my/inferior-ess-setup ()
    (local-set-key (kbd "C-d") #'my/ess-quit-or-delete-char))

  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:modifiers . t)
          (ess-R-fl-keyword:fun-defs . t)
          (ess-R-fl-keyword:keywords . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:constants . t)
          (ess-R-fl-keyword:F&T . t)
          (ess-R-fl-keyword:%op% . t)
          (ess-fl-keyword:fun-calls . t)
          (ess-fl-keyword:numbers . t)
          (ess-fl-keyword:operators . t)
          (ess-fl-keyword:delimiters . nil)
          (ess-fl-keyword:= . nil))))

;;; C and C++

(use-package cc-mode
  :defer t
  :bind (:map c-mode-base-map
              ("<return>" . c-context-line-break)
              ("M-q" . c-fill-paragraph))
  :hook (c-mode-common . my/c-mode-setup)
  :custom
  (c-default-style '((java-mode . "gnu") (awk-mode . "awk") (other . "gnu")))
  :config
  (defun my/c-mode-setup ()
    "Plain characters (no electric keys), hungry delete, aligned #define."
    (c-toggle-electric-state -1)
    (c-toggle-hungry-state 1)
    (setq-local parens-require-spaces nil
                c-backspace-function #'delete-backward-char
                c-electric-pound-behavior '(alignleft)
                cc-search-directories '("." "/usr/include" "/usr/local/include/*"
                                        "../*/include" "$WXWIN/include"))))

;;; Shell scripts

(use-package sh-script
  :defer t
  :bind (:map sh-base-mode-map
              ("<C-return>" . my/sh-send-line-or-region-and-step)
              ("C-c C-c" . my/sh-send-paragraph-and-step))
  :custom
  (sh-basic-offset 2)
  (sh-indent-comment t)
  (sh-shell-file "/bin/bash")
  :config
  (defun my/project-shell ()
    "Return the shell buffer of the current project, creating it if needed."
    (let* ((default-directory (project-root (project-current t)))
           (name (project-prefixed-buffer-name "shell")))
      (unless (get-buffer name) (shell name))
      name))

  (defun my/sh-send-line-or-region-and-step ()
    (interactive)
    (my/repl-send-line-or-region (my/project-shell) t))

  (defun my/sh-send-paragraph-and-step ()
    (interactive)
    (let ((shell (my/project-shell)))
      (mark-paragraph 1)
      (my/repl-send-line-or-region shell t))))

;;; LaTeX (built-in tex-mode and RefTeX)

(add-hook 'latex-mode-hook #'flyspell-mode)
(add-hook 'latex-mode-hook #'reftex-mode)

(provide 'my-prog)
;;; my-prog.el ends here
