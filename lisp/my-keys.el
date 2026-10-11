;;; my-keys.el --- Meow, structural editing and global keys -*- lexical-binding: t; -*-

;;; Structural editing with built-in sexp commands

(defun my/sexp--move-delimiter (closing slurp)
  "Move the CLOSING (or opening) delimiter of the enclosing list.
With SLURP move it outward over the adjacent sexp, otherwise barf the
outermost sexp by moving the delimiter inward."
  (save-excursion
    (if closing (up-list) (backward-up-list))
    (let ((char (if closing (char-before) (char-after))))
      (delete-char (if closing -1 1))
      (if (eq closing slurp) (forward-sexp) (backward-sexp))
      (unless slurp
        (if closing (skip-chars-backward " \t\n") (skip-chars-forward " \t\n")))
      (insert char))))

(defun my/slurp-forward () "Slurp the next sexp." (interactive) (my/sexp--move-delimiter t t))
(defun my/barf-forward () "Barf the last sexp." (interactive) (my/sexp--move-delimiter t nil))
(defun my/slurp-backward () "Slurp the previous sexp." (interactive) (my/sexp--move-delimiter nil t))
(defun my/barf-backward () "Barf the first sexp." (interactive) (my/sexp--move-delimiter nil nil))

(pcase-dolist (`(,name ,open ,close)
               '((round ?\( ?\)) (square ?\[ ?\]) (curly ?{ ?})
                 (angle ?< ?>) (string ?\" ?\") (backquote ?` ?`)))
  (defalias (intern (format "my/wrap-%s" name))
    (lambda () (interactive) (insert-pair 1 open close))
    (format "Wrap the region or the next sexp with %c%c." open close)))

(defun my/unwrap ()
  "Delete the delimiters of the list enclosing point."
  (interactive)
  (save-excursion (backward-up-list) (delete-pair 1)))

(defun my/rewrap (open)
  "Replace the delimiters of the enclosing list with OPEN and its partner."
  (interactive "cRewrap with: ")
  (let ((close (or (cadr (assq open '((?\( ?\)) (?\[ ?\]) (?{ ?}) (?< ?>)))) open)))
    (save-excursion
      (backward-up-list)
      (let ((start (point)))
        (forward-sexp)
        (delete-char -1)
        (insert close)
        (goto-char start)
        (delete-char 1)
        (insert open)))))

(defun my/beginning-of-sexp ()
  "Move to the start of the contents of the enclosing list."
  (interactive)
  (backward-up-list)
  (forward-char))

(defun my/end-of-sexp ()
  "Move to the end of the contents of the enclosing list."
  (interactive)
  (up-list)
  (backward-char))

(defun my/jump-to-matching-paren ()
  "Jump to the matching paren, like % in Vim."
  (interactive)
  (cond ((looking-at "\\s(") (forward-list))
        ((looking-back "\\s)" 1) (backward-list))
        (t (up-list))))

(add-hook 'prog-mode-hook #'electric-pair-local-mode)

(with-eval-after-load 'prog-mode
  (keymap-set prog-mode-map "C-<right>" #'my/slurp-forward)
  (keymap-set prog-mode-map "C-<left>"  #'my/barf-forward)
  (keymap-set prog-mode-map "C-<down>"  #'my/slurp-backward)
  (keymap-set prog-mode-map "C-<up>"    #'my/barf-backward)
  (keymap-set prog-mode-map "C-M-r"     #'my/rewrap)
  (keymap-set prog-mode-map "s-]"       #'my/unwrap)
  (keymap-set prog-mode-map "C-c ("     #'my/wrap-round)
  (keymap-set prog-mode-map "C-c ["     #'my/wrap-square)
  (keymap-set prog-mode-map "C-c {"     #'my/wrap-curly)
  (keymap-set prog-mode-map "C-c <"     #'my/wrap-angle)
  (keymap-set prog-mode-map "C-c \""    #'my/wrap-string)
  (keymap-set prog-mode-map "C-c `"     #'my/wrap-backquote))

;;; Folding

(defun my/toggle-fold ()
  "Toggle folding at point with Org, Hideshow or Outline."
  (interactive)
  (cond ((derived-mode-p 'org-mode) (org-cycle))
        ((bound-and-true-p hs-minor-mode) (hs-toggle-hiding))
        ((bound-and-true-p outline-minor-mode) (outline-cycle))
        (t (user-error "No folding available in this buffer"))))

;;; Meow

(defun my/meow-insert-at-cursor ()
  "Enter insert state at point, or leave temporary normal state."
  (interactive)
  (if meow--temp-normal
      (progn (message "Quit temporary normal mode")
             (meow--switch-state 'motion))
    (meow--cancel-selection)
    (meow--switch-state 'insert)))

(defun my/meow-insert-space ()
  "Insert a space character in normal state."
  (interactive)
  (insert " "))

(use-package meow
  :ensure t
  :demand t
  :config
  (setq meow-use-dynamic-face-color nil
        meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (dolist (entry '((pdf-outline-buffer-mode . motion)
                   (eshell-mode . insert)
                   (comint-mode . insert)))
    (add-to-list 'meow-mode-state-list entry))

  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))

  (meow-leader-define-key
   '("<RET>" . my/toggle-fold)
   '("j" . persp-switch)
   '("u" . meow-universal-argument)
   '("SPC" . consult-buffer)
   '("/" . my/consult-ripgrep)
   '("0" . delete-window)
   '("1" . delete-other-windows)
   '("2" . split-window-below)
   '("3" . split-window-right)
   '("4" . ctl-x-4-prefix)
   '("5" . ctl-x-5-prefix)
   '("8" . insert-char)
   '("9" . delete-frame)
   '("?" . meow-cheatsheet))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '(";" . meow-reverse)
   '("'" . repeat)
   '("%" . my/jump-to-matching-paren)
   '("&" . meow-query-replace)
   '("@" . meow-query-replace-regexp)
   '("=" . text-scale-increase)
   '("-" . text-scale-decrease)
   '("_" . negative-argument)
   '("`" . meow-last-buffer)
   '("!" . my/consult-outline)
   '("<" . beginning-of-buffer)
   '(">" . end-of-buffer)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . other-window)
   '("A" . meow-append)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("C" . meow-comment)
   '("d" . meow-delete)
   '("D" . my/toggle-window-dedicated)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("F" . my/toggle-fold)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . my/meow-insert-at-cursor)
   '("I" . meow-open-below)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("M" . toggle-frame-maximized)
   '("n" . meow-search)
   '("N" . window-layout-transpose)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("P" . meow-yank-pop)
   '("q" . meow-quit)
   '("Q" . my/search-thing-at-point-or-prompt)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("S" . my/meow-insert-space)
   '("t" . avy-goto-char-timer)
   '("T" . meow-till)
   '("u" . meow-undo)
   '("U" . undo-redo)
   '("v" . xref-find-definitions)
   '("V" . xref-go-back)
   '("/" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("Z" . meow-paren-mode)
   '("<escape>" . ignore))

  ;; A state for structural editing with the commands above.
  (defvar meow-paren-keymap (make-keymap))
  (meow-define-state paren
    "Meow state for structural editing."
    :lighter " [P]"
    :keymap meow-paren-keymap)
  (setq meow-cursor-type-paren 'hollow)
  (meow-define-keys 'paren
    '("<escape>" . meow-normal-mode)
    '("a" . my/beginning-of-sexp)
    '("e" . my/end-of-sexp)
    '("j" . forward-sexp)
    '("k" . backward-sexp)
    '("l" . down-list)
    '("h" . up-list)
    '("n" . my/slurp-forward)
    '("p" . my/barf-forward)
    '("b" . my/slurp-backward)
    '("f" . my/barf-backward)
    '("o a" . my/wrap-angle)
    '("o g" . my/wrap-string)
    '("o q" . my/wrap-backquote)
    '("o s" . my/wrap-square)
    '("o r" . my/wrap-round)
    '("o c" . my/wrap-curly)
    '("O" . my/unwrap)
    '("r" . my/rewrap)
    '("R" . raise-sexp)
    '("t" . transpose-sexps)
    '("T" . (lambda () (interactive) (transpose-sexps -1)))
    '("u" . meow-undo))

  ;; The default mode line is hidden (see my-ui.el); show the state indicator
  ;; only in the mode line restored by `my/toggle-mode-line'.
  (push '(:eval (meow-indicator)) my/mode-line-format)
  (meow-global-mode 1))

(use-package meow-tree-sitter
  :ensure t
  :after treesit
  :config
  (meow-tree-sitter-register-defaults))

;;; Jumping

(use-package avy
  :ensure t
  :bind (("M-j" . avy-goto-char-timer)
         :map isearch-mode-map
         ("M-j" . avy-isearch))
  :custom
  (avy-case-fold-search t)
  (avy-timeout-seconds 0.5)
  :config
  (defun my/avy-return (&rest _)
    "Return to the window avy started from; report success."
    (select-window (cdr (ring-ref avy-ring 0)))
    t)

  (defun my/avy-action-kill-whole-line (pt)
    (save-excursion (goto-char pt) (kill-whole-line))
    (my/avy-return))

  (defun my/avy-action-copy-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (copy-region-as-kill (line-beginning-position) (line-beginning-position 2)))
    (my/avy-return))

  (defun my/avy-action-yank-whole-line (pt)
    (my/avy-action-copy-whole-line pt)
    (save-excursion (yank))
    t)

  (defun my/avy-action-teleport-whole-line (pt)
    (my/avy-action-kill-whole-line pt)
    (save-excursion (yank))
    t)

  (defun my/avy-action-mark-to-char (pt)
    (activate-mark)
    (goto-char pt))

  (defun my/avy-action-flyspell (pt)
    (save-excursion
      (goto-char pt)
      (flyspell-mode 1)
      (flyspell-auto-correct-word))
    (my/avy-return))

  (setf (alist-get ?\; avy-dispatch-alist) #'my/avy-action-flyspell
        (alist-get ?k avy-dispatch-alist) #'avy-action-kill-stay
        (alist-get ?K avy-dispatch-alist) #'my/avy-action-kill-whole-line
        (alist-get ?y avy-dispatch-alist) #'avy-action-yank
        (alist-get ?Y avy-dispatch-alist) #'my/avy-action-yank-whole-line
        (alist-get ?w avy-dispatch-alist) #'avy-action-copy
        (alist-get ?W avy-dispatch-alist) #'my/avy-action-copy-whole-line
        (alist-get ?t avy-dispatch-alist) #'avy-action-teleport
        (alist-get ?T avy-dispatch-alist) #'my/avy-action-teleport-whole-line
        (alist-get ?\s avy-dispatch-alist) #'my/avy-action-mark-to-char))

;;; Global keys

(keymap-global-unset "C-z")
(keymap-global-unset "C-x C-z")
(keymap-global-unset "C-x C-k RET")

(defun my/fill-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column (if (eq last-command #'my/fill-unfill)
                         (progn (setq this-command nil) (point-max))
                       fill-column)))
    (call-interactively #'fill-paragraph)))

(defun my/revert-buffer-no-confirm ()
  "Revert the buffer without confirmation."
  (interactive)
  (revert-buffer t t))

(defun my/show-buffer-file-name ()
  "Show the full path of the current file and copy it."
  (interactive)
  (if-let* ((file (buffer-file-name)))
      (progn (message file) (kill-new file))
    (user-error "Buffer not visiting a file")))

(dolist (binding
         '(("M-q"     . my/fill-unfill)
           ("C-M-z"   . delete-pair)
           ("M-z"     . zap-up-to-char)
           ("M-Z"     . zap-to-char)
           ("M-o"     . other-window)
           ("M-n"     . my/make-frame)
           ("M-`"     . other-frame)
           ("C-`"     . window-toggle-side-windows)
           ("C-x C-c" . my/kill-emacs)
           ("C-x C-o" . maximize-window)
           ("C-x k"   . kill-buffer)
           ("s-s"     . save-buffer)
           ;; Buffers
           ("C-c b s" . scratch-buffer)
           ("C-c b i" . ibuffer)
           ("C-c b k" . kill-current-buffer)
           ("C-c b r" . my/revert-buffer-no-confirm)
           ("C-c b c" . compile)
           ;; Files
           ("C-c f f" . find-file)
           ("C-c f c" . copy-file)
           ("C-c f C" . my/copy-file-to-download-folder)
           ("C-c f u" . my/upload-file-to-remote-folder)
           ("C-c f d" . delete-file)
           ("C-c f m" . rename-file)
           ("C-c f g" . find-file-at-point)
           ("C-c f p" . my/show-buffer-file-name)
           ("C-c f t" . find-file-other-tab)
           ("C-c f R" . find-file-read-only)
           ;; Toggles and utilities
           ("C-c o o" . window-toggle-side-windows)
           ("C-c o d" . display-line-numbers-mode)
           ("C-c o t" . org-babel-tangle)
           ("C-c l a" . add-file-local-variable-prop-line)
           ("C-c l c" . calc)
           ("C-c l d" . dictionary-lookup-definition)
           ("C-c l k" . tramp-cleanup-all-connections)
           ("C-c l o" . my/toggle-fold)
           ("C-c l s" . my/toggle-mode-line)
           ("C-c l y" . yank-media)))
  (keymap-global-set (car binding) (cdr binding)))

;;; C-q prefix

(defvar-keymap my-prefix-meow-map
  :doc "Meow states."
  "n" #'meow-normal-mode
  "m" #'meow-motion-mode
  "p" #'meow-paren-mode)

(defvar-keymap my-prefix-window-map
  :doc "Windows and links."
  "k" #'kill-buffer-and-window
  "l" #'my/browse-url-secondary)

(defvar-keymap my-prefix-gpt-map
  :doc "LLM commands."
  "g" #'gptel
  "s" #'gptel-send
  "m" #'gptel-menu
  "p" #'my/proofread-dwim
  "l" #'my/proofread-formal
  "c" #'codex-ide-menu)

(defvar-keymap my-prefix-edit-map
  :doc "Marking."
  "w" #'mark-word
  "s" #'mark-end-of-sentence
  "p" #'mark-paragraph
  "g" #'mark-whole-buffer)

(defvar-keymap my-prefix-fold-map
  :doc "Folding with Hideshow."
  "O" #'hs-show-block
  "o" #'hs-show-all
  "c" #'hs-hide-all
  "C" #'hs-hide-block
  "l" #'hs-hide-level)

(defvar-keymap my-prefix-spell-map
  :doc "Spelling and dictionary."
  "b" #'flyspell-buffer
  "f" #'flyspell-mode
  "c" #'flyspell-correct-word-before-point
  "d" #'dictionary-lookup-definition
  "s" #'dictionary-search)

(defvar-keymap my-prefix-command
  :doc "Personal prefix map bound to C-q."
  "w" my-prefix-window-map
  "g" my-prefix-gpt-map
  "e" my-prefix-edit-map
  "f" my-prefix-fold-map
  "s" my-prefix-spell-map
  "m" my-prefix-meow-map)

(keymap-global-set "C-q" my-prefix-command)

(provide 'my-keys)
;;; my-keys.el ends here
