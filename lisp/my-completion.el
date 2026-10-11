;;; my-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;;; Minibuffer

(use-package vertico
  :ensure t
  :demand t
  :custom
  (vertico-count 8)
  (vertico-resize nil)
  (vertico-count-format nil)
  (vertico-cycle t)
  :bind (:map vertico-map
              ("<backtab>" . minibuffer-complete)
              ("TAB" . vertico-insert)
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :config
  (vertico-mode 1)

  ;; In-buffer completion from the minibuffer goes through Consult;
  ;; Corfu handles ordinary buffers.
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode #'consult-completion-in-region
                   #'completion--in-region)
                 args)))

  ;; NANO look: indent candidates, highlight the input.
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand _prefix suffix index start)
                (funcall orig cand (if (= vertico--index index) "  " "   ")
                         suffix index start)))
  (defun vertico--prompt-selection ()
    "Highlight the prompt."
    (let ((inhibit-modification-hooks t))
      (set-text-properties (minibuffer-prompt-end) (point-max)
                           '(face (nano-strong nano-salient)))))

  (setq vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                                display (space :align-to (- right (-1 . right-margin) (- +1)))))))
  (set-face-attribute 'vertico-group-separator nil :strike-through t)
  (set-face-attribute 'vertico-current nil :inherit '(nano-strong nano-subtle))
  (set-face-attribute 'completions-first-difference nil :inherit '(nano-default)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map ("M-c" . marginalia-cycle))
  :init
  (setq marginalia-align 'right
        marginalia-align-offset -1)
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind (("C-c l l" . my/consult-goto-line)
         ("C-c l m" . consult-global-mark)
         ("C-c b b" . consult-bookmark)
         ("C-c b m" . my/consult-my-bookmark)
         ("C-c f r" . consult-recent-file))
  :custom
  (consult-preview-key nil)             ; No live preview by default
  (consult-narrow-key "<")
  (consult-line-start-from-top t)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :init
  (defun my/consult-outline ()
    "Jump to a heading; narrow to it in Org."
    (interactive)
    (consult-outline)
    (when (derived-mode-p 'org-mode)
      (org-narrow-to-subtree)))

  (defun my/consult-goto-line ()
    "Go to a line with live preview."
    (interactive)
    (let ((consult-preview-key 'any))
      (consult-goto-line)))

  (defun my/consult-ripgrep ()
    "Search the project for the symbol at point."
    (interactive)
    (consult-ripgrep nil (thing-at-point 'symbol)))

  (defun my/consult-my-bookmark (&optional use-eww)
    "Open a link from my bookmarks file, in EWW with USE-EWW."
    (interactive "P")
    (my/consult-org-links (expand-file-name "bookmarks.org" org-directory) use-eww))

  (defun my/consult-org-links (file &optional use-eww)
    "Select and open an Org link from FILE, in EWW with USE-EWW."
    (interactive "fOrg file: \nP")
    (require 'org)
    (let ((links (make-hash-table :test #'equal)))
      (with-temp-buffer
        (insert-file-contents file)
        (while (re-search-forward org-link-bracket-re nil t)
          (let* ((raw (match-string-no-properties 1))
                 (desc (or (match-string-no-properties 2)
                           (file-name-nondirectory raw))))
            (puthash (format "%s %s" (propertize desc 'face 'nano-default)
                             (propertize raw 'face 'nano-faded))
                     (org-link-expand-abbrev raw) links))))
      (if (hash-table-empty-p links)
          (message "No org links found")
        (let ((link (gethash (consult--read (hash-table-keys links)
                                            :prompt "Org link: "
                                            :category 'org-url-link)
                             links)))
          (cond ((not (string-match-p "\\`https?://" link))
                 (org-link-open-from-string (format "[[%s]]" link)))
                (use-eww (eww-browse-url link))
                (t (browse-url link))))))))

;;; In-buffer completion

(use-package corfu
  :ensure t
  :demand t
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-auto nil)
  (corfu-cycle t)
  (corfu-separator ?\s)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match t)
  (corfu-preview-current nil)
  (corfu-on-exact-match nil)
  (corfu-scroll-margin 6)
  (corfu-preselect 'prompt)
  :bind (("C-<tab>" . completion-at-point)
         :map corfu-map
         ("TAB" . corfu-next)
         ([tab] . corfu-next)
         ("S-TAB" . corfu-previous)
         ([backtab] . corfu-previous)
         ("S-<return>" . corfu-insert))
  :config
  (global-corfu-mode 1)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode 1))

(defun my/file-capf ()
  "Complete a file name containing a slash at point."
  (when-let* ((bounds (bounds-of-thing-at-point 'filename))
              ((string-search "/" (buffer-substring (car bounds) (cdr bounds)))))
    (list (car bounds) (cdr bounds) #'read-file-name-internal :exclusive 'no)))

;; Fallbacks after each mode's own completion functions.
(add-hook 'completion-at-point-functions #'my/file-capf 50)
(add-hook 'completion-at-point-functions #'dabbrev-capf 60)
(add-hook 'text-mode-hook
          (lambda () (add-hook 'completion-at-point-functions
                               #'ispell-completion-at-point 70 t)))

(use-package dabbrev
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :custom
  (dabbrev-check-all-buffers nil)
  (dabbrev-friend-buffer-function #'dabbrev--same-major-mode-p)
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))

(use-package tempel
  :ensure t
  :bind (("M-i" . tempel-complete)
         ("M-+" . tempel-insert))
  :init
  (defun my/tempel-setup-capf ()
    "Try exact template names first, also in Eglot buffers."
    (add-hook 'completion-at-point-functions #'tempel-expand -90 t))
  (dolist (hook '(conf-mode-hook prog-mode-hook text-mode-hook))
    (add-hook hook #'my/tempel-setup-capf)))

(provide 'my-completion)
;;; my-completion.el ends here
