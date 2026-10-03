;;; post-init.el --- Personal packages and workflow -*- no-byte-compile: t; lexical-binding: t; -*-

(defvar my/init-start-time (current-time) "Time when init.el was started")
(defvar my/section-start-time (current-time) "Time when section was started")
(defun my/report-time (section)
  (message "%-36s %.2fs"
           (concat section " " "section time: ")
           (float-time (time-subtract (current-time) my/section-start-time))))
(message "===================================================================")
;; Load native tree-sitter and personal setup before the Meow integration.
(require 'my-treesit)

;; Older AUCTeX autoloads alias ConTeXt-mode to context-mode; newer ones
;; alias in the opposite direction.  Repair the old definition before
;; Straight activates AUCTeX, including when reloading this configuration.
(when (eq (symbol-function 'ConTeXt-mode) 'context-mode)
  (fset 'ConTeXt-mode '(autoload "context" nil t nil)))


(defvar my/straight-custom-recipes
  '(
    (meow-tree-sitter :type git :host github :repo "skissue/meow-tree-sitter")
    (consult-tramp :type git :host github :repo "Ladicle/consult-tramp")
    (nov :type git :host nil :repo "https://depp.brause.cc/nov.el.git")
    (nextflow-mode :type git :host github :repo "edmundmiller/nextflow-mode")
    (ess-smart-equals :type git :host github :repo "genovese/ess-smart-equals")
    (cython-mode :type git :host github :repo "cython/emacs-cython-mode")
    (ultra-scroll :type git :host github :repo "jdtsmith/ultra-scroll")
    (buffer-box :type git :host github :repo "rougier/buffer-box")
    (life-calendar :type git :host github :repo "vshender/emacs-life-calendar")
    (relative-date :type git :host github :repo "rougier/relative-date")
    (nano-modeline :type git :host github :repo "rougier/nano-modeline" :branch "rewrite")
    (nano-elfeed :type git :host github :repo "Zilong-Li/nano-elfeed")
    (outline-indent :type git :host github :repo "jamescherti/outline-indent.el")
    (kirigami :type git :host github :repo "jamescherti/kirigami.el")
    (org-timegrid :type git :host github :repo "Gleek/org-timegrid")
    (org-better-agenda :type git :host github :repo "Lycomedes1814/org-better-agenda")
    (ghostel :type git :host github :repo "dakra/ghostel")
    (cuda-mode :type git :host github :repo "chachi/cuda-mode")
    (pdf-tools :host github :repo "vedang/pdf-tools")
    (codex-ide :type git :host github :repo "dgillis/emacs-codex-ide")))

(dolist (recipe my/straight-custom-recipes)
  (straight-use-package (if (cdr recipe) recipe (car recipe))))

(setq package-list
      '(meow                ; modal editting!!!
        0x0                 ; Upload stuff to a server https://0x0.st
        persp-mode          ; Session and Buffers management
        avy                 ; Jumping to visible text
        avy-zap             ; Zap to char using avy
        ace-window          ; Ace window! Require avy
        ace-link            ; Ace links! Require avy
        capf-autosuggest    ; preview the most recent matching history element for eshell and comint
        cape                ; Completion At Point Extensions
        orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
        marginalia          ; Enrich existing commands with completion annotations
        consult             ; Consulting completing-read
        consult-dir         ; autojump, z for emacs
        consult-notes       ; Find denotes
        embark              ; Acting on targets at point
        embark-consult      ; Acting on targets at point
        corfu               ; Completion Overlay Region FUnction
        tempel              ; Simple Templates for Emacs
        gptel               ; LLM in emacs
        vundo               ; Visually undo!
        nano-theme          ; NANO theme is beautiful! consider the rewrite branch TODO
        nano-agenda         ; NANO Agenda
        hide-mode-line      ; Can toggle default mode-line
        htmlize             ; Convert buffer text and decorations to HTML
        engrave-faces       ; better than htmlize and minted
        hl-todo             ; highlight TODO and friends
        f                   ; Modern API for working with files and directories
        rainbow-mode        ; Preview color codes
        xterm-color         ; true color for terms
        pcmpl-args          ; Enhanced shell completion
        native-complete     ; get native TAB completion working for shell
        transient           ; Transient command menus used by magit and casual
        magit               ; A Git porcelain inside Emacs.
        vc-backup           ; VC backend for versioned backups
        casual              ; Transient drived UI for many commands
        auctex              ; powerful latex editting!!!
        cdlatex             ; Fast latex editting!!!
        xenops              ; Fast latex preview!!!
        denote              ; Best for noting!
        popper              ; Popup my buffers and cycle through them!
        mini-frame          ; Show minibuffer in child frame on read-from-minibuffer
        imenu-list          ; Show imenu entries in a separate buffer
        docker              ; Manage docker from Emacs
        envrc               ; Emacs support for direnv
        markdown-mode       ; Major mode for Markdown-formatted text
        python-pytest       ; pytest integration in emacs
        yaml-mode           ; YAML mode
        snakemake-mode      ; snakemake mode
        lua-mode            ; lua mode
        groovy-mode         ; for nextflow-mode
        toc-org             ; up-to-date table of contents
        elfeed              ; RSS reader
        elfeed-org          ; Configure RSS
        ess                 ; best IDE for R!
        poly-R              ; work with Rmarkdown
        flymake-ruff        ; ruff linter for python
        julia-mode          ; Julia
        rust-mode           ; Rust
        go-mode             ; Golang
        web-mode            ; web-mode
        devdocs             ; doc viewer by querying devdocs.io
        smartparens         ; be smart about parens pairs
        exec-path-from-shell; Get environment variables such as $PATH from the shell
        async               ; Emacs Async ops!
        olivetti            ; Minor mode to auto balance window margins
        fountain-mode       ; Major mode for screenwriting and playwriting
        ))

;; Install packages that are not yet installed
(dolist (package package-list)
  (unless (assq package my/straight-custom-recipes)
    (straight-use-package package)))

;; Straight installs and activates each package before returning, so direct
;; require calls below can use the packages immediately.

(defun my-ensure (feature)
  "Make sure FEATURE is required."
  (unless (featurep feature)
    (condition-case nil
        (require feature)
      (error nil))))

;; (setq my-disable-idle-timer t)
;; Light weight mode, fewer packages are used.
(setq my-lightweight-mode-p (and (boundp 'startup-now) (eq startup-now t)))

(defvar my-disable-idle-timer (daemonp)
  "Function passed to `my-run-with-idle-timer' is run immediately.")

(defun my-run-with-idle-timer (seconds func)
  "After SECONDS, run function FUNC once."
  (cond
   ((or my-disable-idle-timer my-lightweight-mode-p)
    (funcall func))
   (t
    (run-with-idle-timer seconds nil func))))

(use-package emacs
  :ensure nil
  :bind
  (("RET" . newline-and-indent)
   ("M-j" . duplicate-dwim)
   ("C-z" . nil)
   ("C-x C-z" . nil)
   ("C-M-z" . delete-pair)
   ("C-x C-k RET" . nil))
  :custom
  (font-lock-maximum-decoration t) ; important for highlighting marks
  (indicate-empty-lines nil) ;; No empty line indicators
  (cursor-in-non-selected-windows nil) ;; No cursor in inactive windows
  (cursor-type '(hbar .  2)) ;; Bar cursor
  (cursor-in-non-selected-windows nil)
  (blink-cursor-mode nil)
  (pop-up-windows nil)        ; No popup windows
  (show-help-function nil)    ; No help text
  (use-file-dialog nil)       ; No file dialog
  (use-dialog-box nil)        ; No dialog box
  (initial-major-mode 'text-mode)
  (ad-redefinition-action 'accept)
  (auto-save-default t)
  (column-number-mode t)
  (line-spacing nil)
  (completion-ignore-case t)
  (completions-detailed t)
  (doc-view-resolution 200)
  (delete-by-moving-to-trash t)
  (delete-pair-blink-delay 0)
  (find-ls-option '("-exec ls -ldh {} +" . "-ldh"))  ; find-dired results with human readable sizes
  (global-auto-revert-non-file-buffers t)
  (global-goto-address-mode t)                            ;     C-c RET on URLs open in default browser
  (browse-url-secondary-browser-function 'eww-browse-url) ; C-u C-c RET on URLs open in EWW
  (help-window-select t)
  (history-length 300)
  (inhibit-startup-screen t)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (inhibit-startup-echo-area-message t) ; Disable initial echo message
  (ibuffer-human-readable-size t) ; EMACS-31
  (ispell-dictionary "en_US")
  (create-lockfiles nil)   ; No lock files
  (make-backup-files nil)  ; No backup files
  (native-comp-async-on-battery-power nil)  ; No compilations when on battery EMACS-31
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (read-answer-short t)
  (use-short-answers t); Replace yes/no prompts with y/n
  (confirm-nonexistent-file-or-buffer nil) ; Ok to visit non existent file
  (initial-buffer-choice t) ; Open *scratch* buffer at init
  :config
  ;; text display
  (add-hook 'text-mode-hook 'visual-line-mode)
  )



(setq my/section-start-time (current-time))

(use-package meow
  :init
  (defun my/meow-insert-at-cursor ()
    "insert for all modes."
    (interactive)
    (if meow--temp-normal
        (progn
          (message "Quit temporary normal mode")
          (meow--switch-state 'motion))
      (meow--cancel-selection)
      (meow--switch-state 'insert)))

  (defun my/meow-insert-space ()
    "Insert a space character in normal mode."
    (interactive)
    (insert " "))

  (defun my/meow-setup ()
    (add-to-list 'meow-mode-state-list
                 '(mu4e-view-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(osx-dictionary-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(pdf-outline-buffer-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(eshell-mode . insert))
    (add-to-list 'meow-mode-state-list
                 '(edraw-property-editor-mode . insert))
    (add-to-list 'meow-mode-state-list
                 '(comint-mode . insert))
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

    (meow-motion-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))

    (meow-leader-define-key
     '("<RET>" . hs-toggle-hiding)
     ;; TODO: bind j,k,l as well!
     '("j" . persp-switch)
     ;; make SPC-u as C-u now
     '("u" . meow-universal-argument)
     ;; frequent keys
     '("SPC" . consult-buffer) ; buffer
     '("/" . my/consult-ripgrep) ; search project
     '("0" . delete-window)
     '("1" . delete-other-windows)
     '("2" . split-window-below)
     '("3" . split-window-right)
     '("4" . ctl-x-4-prefix)
     '("5" . ctl-x-5-prefix)
     '("8" . insert-char)  ; insert emoji
     '("9" . delete-frame)
     '("?" . meow-cheatsheet)
     )

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
     '("'" . repeat) ; vim use .
     '("%" . my/jump-to-matching-paren)  ; like % in vim
     '("&" . meow-query-replace)
     '("@" . meow-query-replace-regexp)
     '("=" . text-scale-increase) ; increase text size
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
     '("F" . kirigami-toggle-fold) ; fold/unfold text
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . my/meow-insert-at-cursor) ;; meow-insert
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
     '("N" . my/toggle-window-split)
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
     '("U" . vundo)
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
     '("<escape>" . ignore)))
  (my-ensure 'meow)
  (setq meow-use-dynamic-face-color nil)
  ;; (setq meow-use-cursor-position-hack t)
  (my/meow-setup)
  (meow-setup-indicator)
  (meow-global-mode 1)
  )

(use-package meow-tree-sitter
  :if (treesit-available-p)
  :defer t
  :after (meow treesit)
  :config
  (meow-tree-sitter-register-defaults)
  )

(setq meow-paren-keymap (make-keymap))
(meow-define-state paren
  "meow state for interacting with smartparens"
  :lighter " [P]"
  :keymap meow-paren-keymap)

;; meow-define-state creates the variable
(setq meow-cursor-type-paren 'hollow)

(meow-define-keys 'paren
  '("<escape>" . meow-normal-mode)
  '("a" . sp-beginning-of-sexp)
  '("e" . sp-end-of-sexp)
  '("j" . sp-forward-sexp)
  '("k" . sp-backward-sexp)
  '("l" . sp-down-sexp)
  '("h" . sp-up-sexp)
  '("n" . sp-forward-slurp-sexp)
  '("p" . sp-forward-barf-sexp)
  '("b" . sp-backward-slurp-sexp)
  '("f" . sp-backward-barf-sexp)
  '("o a" . my/wrap-angle)
  '("o g" . my/wrap-string)
  '("o q" . my/wrap-backquote)
  '("o s" . sp-wrap-square)
  '("o r" . sp-wrap-round)
  '("o c" . sp-wrap-curly)
  '("O" . sp-unwrap-sexp)
  '("r" . sp-rewrap-sexp)
  '("R" . sp-raise-sexp)
  '("s" . sp-split-sexp)
  '("S" . sp-slurp-hybrid-sexp)
  '("A" . sp-absorb-sexp)
  '("t" . sp-transpose-sexp)
  '("T" . my/back-transpose)
  '("u" . meow-undo))

(my/report-time "meow")

; define sub-maps
(defvar-keymap my-prefix-meow-map
  :doc "Prefix map of C-q m for buffers"
  "n" #'meow-normal-mode
  "m" #'meow-motion-mode
  "p" #'meow-paren-mode
  )

(defvar-keymap my-prefix-window-map
  :doc "Prefix map of C-q w for buffers"
  "k" #'kill-buffer-and-window
  "l" #'my/browse-url-secondary
  )

(defvar-keymap my-prefix-gpt-map
  :doc "Prefix map of C-q g for buffers"
  "g" #'gptel
  "s" #'gptel-send
  "m" #'gptel-menu
  "p" #'my/proofread-dwim
  "l" #'my/proofread-formal
  "c" #'codex-ide-menu
  )

(defvar-keymap my-prefix-edit-map
    :doc "Prefix map of C-q e for editing"
    "w" #'mark-word
    "s" #'mark-end-of-sentence
    "p" #'mark-paragraph
    "g" #'mark-whole-buffer
    "d" #'org-remark-delete
    "m" #'org-remark-mark
    "l" #'org-remark-mark-red-line
    "v" #'org-remark-view-next
    )

(defvar-keymap my-prefix-fold-map
    :doc "Prefix map of C-q f for fold/unfold text"
    "O" #'kirigami-open-fold  ; open fold at point
    "o" #'kirigami-open-folds ; open all folds
    "c" #'kirigami-close-folds ; close all folds
    "C" #'kirigami-close-fold ; close fold at point
    "r" #'kirigami-open-fold-rec ; open fold recursively
    )

(defvar-keymap my-prefix-casual-map
    :doc "Prefix map of C-q c for casual"
    "a" #'casual-avy-tmenu
    "g" #'casual-agenda-tmenu
    "i" #'casual-ibuffer-tmenu
    "c" #'casual-calc-tmenu
    "n" #'casual-info-tmenu
    "r" #'casual-re-builder-tmenu
    "b" #'casual-bookmarks-tmenu
    "d" #'casual-dired-tmenu
    "w" #'casual-eww-tmenu
    "e" #'casual-editkit-main-tmenu)

 (defvar-keymap my-prefix-spell-map
    :doc "Prefix map of C-q s for spelling"
    "o" #'osx-dictionary-search-word-at-point
    "i" #'osx-dictionary-search-input
    "c" #'flyspell-correct-word-before-point
    "d" #'dictionary-lookup-definition
    "s" #'dictionary-search)

; define the top-level keymap
(defvar-keymap my-prefix-command
  :doc "My prefix map bound to C-q"
  "w" my-prefix-window-map
  "g" my-prefix-gpt-map
  "e" my-prefix-edit-map
  "f" my-prefix-fold-map
  "c" my-prefix-casual-map
  "s" my-prefix-spell-map
  "m" my-prefix-meow-map
  )


; bind the root map to your prefix key
(keymap-set global-map "C-q" my-prefix-command)

(use-package smartparens
  :defer t
  :init
  ;; utily for smartparens
  (defun my/wrap-string () (interactive) (sp-wrap-with-pair "\""))
  (defun my/wrap-backquote () (interactive) (sp-wrap-with-pair "`"))
  (defun my/wrap-angle () (interactive) (sp-wrap-with-pair "<"))
  (defun my/back-transpose ()
    "backward transpose two sexp via `sp-transpose-sexp'"
    (interactive)
    (sp-transpose-sexp -1))

  :bind
  (:map smartparens-mode-map
        ("s-[" . sp-backward-unwrap-sexp)
        ("s-]" . sp-unwrap-sexp)
        ("C-<right>" . sp-forward-slurp-sexp)
        ("C-<left>" . sp-forward-barf-sexp)
        ("C-<down>" . sp-backward-slurp-sexp)
        ("C-<up>" . sp-backward-barf-sexp)
        ("C-M-a" . sp-beginning-of-sexp)
        ("C-M-e" . sp-end-of-sexp)
        ("C-M-f" . sp-forward-sexp)
        ("C-M-b" . sp-backward-sexp)
        ("C-M-t" . sp-transpose-sexp)  ;; swap a b
        ("C-M-r" . sp-rewrap-sexp)  ;; change surrounded pairs
        ("C-c ("  . sp-wrap-round)
        ("C-c ["  . sp-wrap-square)
        ("C-c {"  . sp-wrap-curly)
        ("C-c <"  . my/wrap-angle)
        ("C-c \"" . my/wrap-string)
        ("C-c `"  . my/wrap-backquote)
        )
  :hook (prog-mode . smartparens-mode) ;
  :hook (prog-mode . turn-on-smartparens-strict-mode) ;; enforces that pairs are always balanced
  :config
  ;; load default config
  (require 'smartparens-config)
  ;; Add angle brackets pair to smartparens
  (sp-local-pair 'html-mode "<" ">")
  (sp-local-pair 'web-mode "<" ">")

  (with-eval-after-load 'nano-theme-support
    ;; Matching pairs
    (set-face-attribute 'sp-pair-overlay-face nil
                        :background nano-light-subtle
                        :foreground 'unspecified)
    ;; Show pair highlights
    (set-face-attribute 'sp-show-pair-match-face nil
                        :background 'unspecified
                        :foreground nano-light-salient
                        :weight 'bold
                        :underline t)
    ;; Mismatched pairs
    (set-face-attribute 'sp-show-pair-mismatch-face nil
                        :background nano-light-critical
                        :foreground nano-light-background
                        :weight 'bold)
    ;; Wrap overlay (when wrapping text)
    (set-face-attribute 'sp-wrap-overlay-face nil
                        :background nano-light-highlight
                        :foreground 'unspecified)
    ;; Tag overlay (for HTML/XML tags)
    (set-face-attribute 'sp-wrap-tag-overlay-face nil
                        :background nano-light-subtle
                        :foreground nano-light-salient))

  ;; Highlighting Parenthesis
  (show-smartparens-global-mode t)

  )

(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta t
        mac-option-modifier 'meta
        ;; mac-command-key-is-meta t
        ;; mac-command-modifier 'meta
        ns-function-modifier 'hyper ; Fn key as hyper (H)
                                        ;dired-use-ls-dired t
        insert-directory-program "gls" ;; ls for dired
        )
  (menu-bar-mode -1)


  

  )

(when (eq system-type 'gnu/linux)
  (setq
   browse-url-browser-function #'browse-url-xdg-open
   ;; x-super-keysym 'meta
   ;; x-meta-keysym 'super
   ))

(setq my/section-start-time (current-time))

(use-package nano-theme
  ;; Theme files use provide-theme rather than providing a Lisp feature.
  :no-require t
  :demand t
  :init
  (setq nano-fonts-use nil)
  :config
  (load-theme 'nano-light t)

  (defun my/nano-terminal-colors (&optional frame)
    "Apply NANO's explicit light colors to terminal FRAME.
Like Spartan's `nano-install-theme', set the default face directly so
the terminal's own dark background cannot select the dark face palette."
    (let ((frame (or frame (selected-frame))))
      (when (and (not (display-graphic-p frame))
                 (memq 'nano-light custom-enabled-themes))
        (set-frame-parameter frame 'background-mode 'light)
        (set-face-attribute 'default frame
                            :foreground nano-light-foreground
                            :background nano-light-background)
        (frame-set-background-mode frame)
        (set-face-attribute 'cursor frame
                            :background nano-light-foreground
                            :foreground nano-light-background)
        (set-frame-parameter frame 'cursor-color nano-light-foreground)
        ;; TTY hardware cursors are drawn by the terminal, outside Emacs faces.
        ;; OSC 12 sets their color in xterm-compatible terminals.
        (when (and (not noninteractive)
                   (string-match-p
                    "\\`\\(?:xterm\\|rxvt\\|screen\\|tmux\\|foot\\|alacritty\\|kitty\\|wezterm\\|ghostty\\)"
                    (or (tty-type frame) "")))
          (let* ((terminal (frame-terminal frame))
                 (set-string (format "\e]12;%s\a" nano-light-foreground))
                 (previous (terminal-parameter terminal 'my/nano-cursor-set-string)))
            ;; Let Emacs restore the terminal on exit, client detach, and
            ;; suspension, then reapply the color when the TTY is resumed.
            (set-terminal-parameter
             terminal 'tty-mode-reset-strings
             (cons "\e]112\a"
                   (delete "\e]112\a"
                           (terminal-parameter terminal 'tty-mode-reset-strings))))
            (set-terminal-parameter
             terminal 'tty-mode-set-strings
             (cons set-string
                   (delete set-string
                           (delete previous
                                   (terminal-parameter terminal 'tty-mode-set-strings)))))
            (set-terminal-parameter terminal 'my/nano-cursor-set-string set-string)
            (send-string-to-terminal set-string frame))))))

  (my/nano-terminal-colors)
  (add-hook 'after-make-frame-functions #'my/nano-terminal-colors)

  (defun my/nano-fonts (&optional frame)
    "Apply personal typography to FRAME, including newly created GUI frames."
    (when (display-graphic-p frame)
      (set-face-attribute 'default frame
                        :family "Roboto Mono" :weight 'light :height 160)
      (set-face-attribute 'bold frame :weight 'regular)
      (set-face-attribute 'italic frame
                        :family "Iosevka" :weight 'light :slant 'italic)
      (set-face-attribute 'variable-pitch frame
                        :family "ETBembo" :weight 'regular :height 240)
      (with-selected-frame (or frame (selected-frame))
        (set-fontset-font t 'unicode
                          (font-spec :family "RobotoMono Nerd Font"
                                     :weight 'light :height 160))
        (set-fontset-font t 'emoji
                          (font-spec :family "Apple Color Emoji") nil 'prepend)
        (set-fontset-font t 'emoji
                          (font-spec :family "Noto Color Emoji") nil 'append))))

  (my/nano-fonts)
  (add-hook 'after-make-frame-functions #'my/nano-fonts))

(setq-default fill-column 80                          ; Default line width
              sentence-end-double-space nil           ; Use a single space after dots
              bidi-paragraph-direction 'left-to-right ; Faster
              truncate-string-ellipsis "…")           ; Nicer ellipsis

;; Nicer glyphs for continuation and wrap
(set-display-table-slot standard-display-table
                        'truncation (make-glyph-code ?…))

(set-display-table-slot standard-display-table
                        'wrap (make-glyph-code ?↩))

(when (eq system-type 'darwin)
  (add-hook 'term-mode-hook
            (lambda ()
              (setq buffer-display-table (make-display-table)))))

(setq x-underline-at-descent-line nil
      x-use-underline-position-properties t
      underline-minimum-offset 10)

(use-package buffer-box
  :commands (buffer-box buffer-box-on buffer-box-off))

(use-package nano-modeline
  :ensure nil
  :custom
  (nano-modeline-position "Top")
  (nano-modeline-padding '(0.20 . 0.25))
  :config
  (defun my/nano-modeline-element-pdf-label ()
    "Display a PDF label in the modeline."
    (propertize "PDF:" 'face 'nano-modeline-face-primary))

  (defun my/nano-modeline-element-pdf-page ()
    "Return current PDF page and total number of pages."
    (when (derived-mode-p 'pdf-view-mode) (propertize (format " %d/%s" (image-mode-window-get 'page) (or (ignore-errors (pdf-cache-number-of-pages)) "?")) 'face 'nano-modeline-face-secondary)))

  ;; PDF-specific nano-modeline format.
  (defvar my/nano-modeline-format-pdf-view
    (cons '(my/nano-modeline-element-pdf-label
            nano-modeline-element-space
            nano-modeline-element-buffer-name
            nano-modeline-element-space
            nano-modeline-element-buffer-mode)
          '(my/nano-modeline-element-pdf-page
            nano-modeline-element-window-status
            nano-modeline-element-space)))

  :hook
  ((prog-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (text-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (pdf-view-mode . (lambda () (nano-modeline my/nano-modeline-format-pdf-view)))
   (gptel-mode . (lambda () (nano-modeline nano-modeline-format-gptel)))
   (org-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (org-capture-mode . (lambda () (nano-modeline nano-modeline-format-org-capture)))
   (nano-calendar-mode . (lambda () (nano-modeline nano-modeline-format-nano-agenda)))
   (mu4e-headers-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-headers)))
   (mu4e-view-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-message)))
   (mu4e-compose-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-compose)))
   (elfeed-search-mode . (lambda () (nano-modeline nano-modeline-format-elfeed-search)))
   (elfeed-show-mode . (lambda () (nano-modeline nano-modeline-format-elfeed-entry)))
   (term-mode . (lambda () (nano-modeline nano-modeline-format-terminal)))
   (ghostel-mode . (lambda () (nano-modeline nano-modeline-format-terminal)))
   )
  )

(set-face-foreground 'minibuffer-prompt "pink")
(set-face-bold 'minibuffer-prompt t)
(require 'hide-mode-line)
;; we hide the emacs mode-line but not the nano-modeline
(global-hide-mode-line-mode)

(defun my/toggle-emacs-mode-line ()
  "toggle hide-mode-line-mode"
  (interactive)
  (if hide-mode-line-format
      (progn
        (setq-local hide-mode-line--old-format hide-mode-line-format
                    hide-mode-line-format nil)
        (turn-on-hide-mode-line-mode))
    (progn
      (setq-local hide-mode-line-format hide-mode-line--old-format
                  hide-mode-line--old-format nil)
      (turn-on-hide-mode-line-mode))
    )
  )

(bind-key "C-c l s" #'my/toggle-emacs-mode-line)
(my/report-time "Theme")

(setq my/section-start-time (current-time))

(use-package persp-mode
  :bind
  ("C-c p s" . persp-kill)

  :custom
  (persp-keymap-prefix "s-p")  ; The setter calls kbd; pass a key description.
  (persp-nil-name "Home")
  (persp-autokill-buffer-on-remove 'kill-weak)

  :init
  (persp-mode 1)

  (defun my/check-and-abort-minibuffer (name frame)
    (when (active-minibuffer-window)
      (keyboard-escape-quit)))

  (setq persp-before-switch-functions #'my/check-and-abort-minibuffer)

  :config

  (defun my/persp-skip-save-buffer-p (buffer)
    "Exclude Magit and other transient BUFFERs from saved perspectives."
    (with-current-buffer buffer
      (or (string-match-p "\\`\\*?[Ee]diff" (buffer-name))
          (derived-mode-p 'magit-mode 'magit-repolist-mode)
          ;; Also cover Magit modes outside the magit-mode hierarchy.
          (string-prefix-p "magit-" (symbol-name major-mode))
          (memq major-mode '(ediff-mode comint-mode dired-mode PDFView)))))

  (add-to-list 'persp-filter-save-buffers-functions
               #'my/persp-skip-save-buffer-p)

  (defun my/persp-add-buffer (&optional buffer)
    "Add BUFFER to the current perspective when `persp-mode' is active."
    (when (and (bound-and-true-p persp-mode)
               (fboundp 'persp-add-buffer)
               (or (null buffer) (buffer-live-p buffer)))
      (with-current-buffer (or buffer (current-buffer))
        (unless (minibufferp)
          (ignore-errors
            (persp-add-buffer (current-buffer)))))))

  (defun my/persp-add-visible-buffers ()
    "Add visible buffers in the selected frame to the current perspective."
    (when (and (bound-and-true-p persp-mode)
               (fboundp 'persp-add-buffer))
      (dolist (window (window-list nil 'no-minibuf))
        (my/persp-add-buffer (window-buffer window)))))

  ;; Define our smarter buffer filter
  (defun my/persp-buffer-filter-predicate (buffer)
    "Filter buffers based on perspective context:
   - In default perspective: only show buffers not in any other perspective
   - In named perspective: only show buffers in that perspective
   - Always exclude ephemeral buffers (starting with *)"
    (let ((buf-name (buffer-name buffer))
          (current-persp (get-current-persp)))
      ;; First, exclude ephemeral buffers
      (when (not (string-match-p "^\\*\\(splash\\|Warning\\|Compile-Log\\|Async\\|Backtrace\\)" buf-name))
        (if (null current-persp)
            ;; In default/nil perspective: show only buffers not in any other perspective
            (not (cl-some (lambda (p)
                            (and (not (eq p current-persp))
                                 (memq buffer (persp-buffers p))))
                          (persp-persps)))
          ;; In named perspective: show only buffers in this perspective
          (memq buffer (persp-buffers current-persp))))))

  (with-eval-after-load 'consult
    (defvar persp-consult-source
      (list :name     "Persp"
            :narrow   ?s
            :category 'buffer
            :state    #'consult--buffer-state
            :history  'buffer-name-history
            :default  t
            :items
            #'(lambda () (consult--buffer-query :sort 'visibility
                                                :predicate 'my/persp-buffer-filter-predicate
                                                :as #'buffer-name))))
    (add-to-list 'consult-buffer-sources persp-consult-source))


  (with-eval-after-load 'elfeed
    ;; Define an auto-perspective for elfeed buffers
    (persp-def-auto-persp "RSS"
                          :parameters '((dont-save-to-file . t))
                          :buffer-name "^\\*elfeed-\\(search\\|entry\\)"
                          :dyn-env '(after-switch-to-buffer-functions ;; prevent recursion
                                     (persp-add-buffer-on-find-file nil)
                                     persp-add-buffer-on-after-change-major-mode)
                          :switch 'frame
                          ))

  )

(my/report-time "Perspectives")

(setq my/section-start-time (current-time))

(use-package avy
  :commands (avy-goto-char-timer avy-goto-char avy-goto-char-2)
  :bind (("M-j" . avy-goto-char-timer))
  :custom
  (avy-case-fold-search t)
  (avy-timeout-seconds 0.5)
  :preface
  (defun avy-action-kill-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (kill-whole-line))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-copy-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (cl-destructuring-bind (start . end)
          (bounds-of-thing-at-point 'line)
        (copy-region-as-kill start end)))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-yank-whole-line (pt)
    (avy-action-copy-whole-line pt)
    (save-excursion (yank))
    t)

  (defun avy-action-teleport-whole-line (pt)
    (avy-action-kill-whole-line pt)
    (save-excursion (yank)) t)

  (defun avy-action-mark-to-char (pt)
    (activate-mark)
    (goto-char pt))

  (defun avy-action-embark (pt)
    (require 'embark)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun avy-action-flyspell (pt)
    (save-excursion
      (goto-char pt)
      (when (require 'flyspell nil t)
        (flyspell-mode)
        (flyspell-auto-correct-word)
        ))
    (select-window
     (cdr (ring-ref avy-ring 0)))
    t)

  :config

  (define-key isearch-mode-map (kbd "M-j") 'avy-isearch)

  (setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark)
  (setf (alist-get ?\; avy-dispatch-alist) 'avy-action-flyspell)

  (setf (alist-get ?k avy-dispatch-alist) 'avy-action-kill-stay
        (alist-get ?K avy-dispatch-alist) 'avy-action-kill-whole-line)

  (setf (alist-get ?y avy-dispatch-alist) 'avy-action-yank
        (alist-get ?w avy-dispatch-alist) 'avy-action-copy
        (alist-get ?W avy-dispatch-alist) 'avy-action-copy-whole-line
        (alist-get ?Y avy-dispatch-alist) 'avy-action-yank-whole-line)

  (setf (alist-get ?t avy-dispatch-alist) 'avy-action-teleport
        (alist-get ?T avy-dispatch-alist) 'avy-action-teleport-whole-line)

  (setf (alist-get ?  avy-dispatch-alist) 'avy-action-mark-to-char))

(use-package avy-zap
  :bind (("M-z" . avy-zap-up-to-char-dwim)
         ("M-Z" . avy-zap-to-char-dwim)))

(use-package ace-link
  :bind ("C-j" . ace-link)
  :config
  (ace-link-setup-default)
  )

(setq frame-title-format "OneEmacs")

(defun my/make-frame ()
  "Create a new frame and switch to *scratch* buffer."

  (interactive)
  (select-frame (make-frame))
  (switch-to-buffer "*scratch*"))

(defun my/kill-emacs ()
  "Delete frame or kill Emacs if there is only one frame."

  (interactive)
  (condition-case nil
      (delete-frame)
    (error (save-buffers-kill-terminal))))

;; Merge dimensions and borders with the early transparency/blur settings.
(dolist (parameter '((min-height . 1) (height . 45)
                     (min-width . 1) (width . 81)
                     (vertical-scroll-bars . nil)
                     (internal-border-width . 12)
                     (left-fringe . 0) (right-fringe . 0)
                     (tool-bar-lines . 0)))
  (setf (alist-get (car parameter) default-frame-alist) (cdr parameter))
  (setf (alist-get (car parameter) initial-frame-alist) (cdr parameter)))

(bind-key "M-n"        #'my/make-frame)
(bind-key "C-x C-c"    #'my/kill-emacs)
(bind-key "M-`"        #'other-frame)
(bind-key "C-z"        nil)
;; (bind-key "<M-return>" #'eval-buffer)

; https://stackoverflow.com/questions/14881020/emacs-shortcut-to-switch-from-a-horizontal-split-to-a-vertical-split-in-one-move
(defun my/toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(use-package ace-window
  :defer t
  :bind ("M-o" . ace-window)
  :custom
  (aw-dispatch-when-more-than 3)
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-ignore-on t)
  )

(with-eval-after-load 'ace-window
    (when (boundp 'aw-ignored-buffers)
      (add-to-list 'aw-ignored-buffers "*Dired-Side*")))

(setq-default window-divider-default-right-width 24
              window-divider-default-places 'right-only
              left-margin-width 0
              right-margin-width 0
              window-combination-resize nil) ; Do not resize windows proportionally

(window-divider-mode 1)

;; Make a window dedicated
(defun my/toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
     (set-window-dedicated-p window (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer))
  (force-window-update))

(use-package window
  :custom
  (switch-to-buffer-obey-display-actions t)
  (switch-to-buffer-in-dedicated-window 'pop)  ;; default nil
  (display-buffer-alist
   '(;; no window
     ("\\*Async Shell Command\\*"
      (display-buffer-no-window))

     ("\\`\\*\\(Warnings\\|Compile-Log\\|Org Links\\)\\*\\'"
      (display-buffer-no-window)
      (allow-no-window . t))

     ;; `eldoc-doc-buffer'
     ("^\\*eldoc" display-buffer-at-bottom
      (display-buffer-reuse-window display-buffer-pop-up-window))

     ;; bottom buffer (NOT side window)
     ((or . ((derived-mode . flymake-diagnostics-buffer-mode)
             (derived-mode . flymake-project-diagnostics-mode)
             (derived-mode . messages-buffer-mode)
             (derived-mode . backtrace-mode)))
      (display-buffer-reuse-mode-window display-buffer-at-bottom)
      (window-height . 0.4)
      (dedicated . t)
      (preserve-size . (t . t)))

     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*ghostel\\*"
      ;; (display-buffer-reuse-mode-window display-buffer-below-selected)
          ;; (dedicated . t)
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . 1)  ;; rightmost
      (window-height . 0.4)
      (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ;; bottom side windows
     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*e?shell\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . 1)  ;; rightmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ("\\*R\\|[Jj]ulia\\(?:.*\\)?\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . -1) ;; leftmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*[Pp]ython\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . -1) ;; leftmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))


     ((derived-mode . ready-player-mode)
      (display-buffer-reuse-mode-window display-buffer-pop-up-frame)
      (window-height . fit-window-to-buffer)
      (window-width . fit-window-to-buffer)
      )

     ;; ("\\*mu4e.*\\*"
     ;;  (display-buffer-use-some-window)
     ;;  (body-function . (lambda (window) (delete-other-windows window)))
     ;;  )

     ("\\*Outline\\|\\*Easy\\(?:.*\\)?\\*"
      (display-buffer-in-side-window)
      (side . left)
      (window-width . 0.35)
      (window-parameters . ((no-delete-other-windows . t))))
     ))
  )

(use-package popper
  :defer t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         )
  :init
  (setq popper-reference-buffers
        '("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*ghostel\\*" ghostel-mode ; ghostel as a popup
          "\\*\\([Pp]ython\\|[Jj]ulia\\)\\*"
          "\\*R\\(?:.*\\)?\\*"
          "^\\*eshell.*\\*$" eshell-mode ; eshell as a popup
          "^\\*shell.*\\*$"  shell-mode  ; shell as a popup
          "\\*Messages\\*"
          help-mode
          ess-r-help-mode
          compilation-mode))
  (setq popper-display-control nil) ; buffers are managed by `display-buffer-alist'
  (popper-mode +1)
  (popper-echo-mode +1)  ; For echo area hints
  )

(use-package help
  :defer t
  :custom
  (temp-buffer-resize-mode t)
  (temp-buffer-max-height 8)
  )

(use-package autorevert
  :custom
  (auto-revert-use-notify nil)
  :config
  (global-auto-revert-mode t))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets) ; or 'reverse
  (uniquify-separator " • ")
  (uniquify-after-kill-buffer-p t)
  (uniquify-ignore-buffers-re "^\\*")
  )

(bind-key "C-c b s" #'scratch-buffer)
(bind-key "C-c b i" #'ibuffer)
(bind-key "C-c b k" #'kill-current-buffer)
(bind-key "C-x k" #'kill-buffer) ; select buffer to be killed

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(bind-key "C-c b r"   #'revert-buffer-no-confirm)
(bind-key "C-c b c"   #'compile) ; compile buffer
(bind-key "s-s"   #'save-buffer) ; hyper + s

(use-package ibuffer
  :defer t
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-default-display-maybe-show-predicates t)
  (ibuffer-expert t)
  (ibuffer-formats
   '((mark modified read-only locked
           " " (name 30 30 :left :elide)
           " " (size 9 -1 :right)
           " " (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
               (name 16 -1)
               " " filename)))
  (ibuffer-maybe-show-regexps nil)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-shrink-to-minimum-size t t)
  ;; (ibuffer-use-other-window t)

  :config

  (require 'ibuf-ext)

  (define-ibuffer-filter persp
      "Toggle current view to buffers associated with current perspective."
    (:description "persp-mode"
                  :reader (persp-read-persp nil nil (safe-persp-name (get-frame-persp)) t))
    (let ((persp-name (if (string= qualifier "")
                          (safe-persp-name (get-current-persp))
                        qualifier)))
      (member buf (safe-persp-buffers (persp-get-by-name persp-name)))))

  (defun persp-add-current-ibuffer-group ()
     (require 'cl-lib)
      (let ((perspslist (list
                         (list (safe-persp-name (get-frame-persp))
                               (cons 'persp (safe-persp-name (get-frame-persp)))))))
        (setq ibuffer-saved-filter-groups
              (cl-delete "persp-mode" ibuffer-saved-filter-groups
                       :test 'string= :key 'car))
        (push
         (cons "persp-mode" perspslist)
         ibuffer-saved-filter-groups)))

  (add-hook 'ibuffer-mode-hook
            #'(lambda ()
                (persp-add-current-ibuffer-group)
                (ibuffer-switch-to-saved-filter-groups "persp-mode")))

  )

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
(use-package async
  :defer t
  :config
  (dired-async-mode 1))

(use-package wdired
  :defer t
  :after dired
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t)

  :bind
  (:map dired-mode-map
        ("K" . wdired-change-to-wdired-mode)))

(defun my/open-dired-for-current-image ()
  "Open dired buffer where the current image belongs."
  (interactive)
  (when (derived-mode-p 'image-mode)
    (let ((file (buffer-file-name)))
      (if file
          (dired (file-name-directory file))
        (message "Current buffer is not associated with a file.")))))

(with-eval-after-load 'image-mode
  (define-key image-mode-map (kbd "d") #'my/open-dired-for-current-image)
  (define-key image-mode-map (kbd "a") 'other-window)
  (define-key image-mode-map (kbd "A +") 'image-increase-speed)
  (define-key image-mode-map (kbd "A -") 'image-decrease-speed)
  (define-key image-mode-map (kbd "A r") 'image-reverse-speed)
  (define-key image-mode-map (kbd "A 0") 'image-reset-speed)
  )

(bind-key "C-c l y" #'yank-media)

(defun my-embark-image ()
  "Match images."
  (let ((extensions "\\(png\\|jpg\\|svg\\|gif\\|jpeg\\)\\'"))
    (cond
     ((derived-mode-p 'org-mode)
      (when-let* ((link (org-element-context)))
        (when (eq (org-element-type link) 'link)
          (cond
           ((string= "attachment" (org-element-property :type link))
            (cons 'image (expand-file-name (org-element-property :path link)
                                           (org-attach-dir))))
           ((string-match "sketch" (org-element-property :type link))
            (cons 'image (my-get-sketch-filename (org-element-property :path link))))
           ((string-match extensions (org-element-property :path link))
            (cons 'image (org-element-property :path link)))))))
     ((and (derived-mode-p 'dired-mode)
           (string-match extensions (dired-get-filename)))
      (cons 'image (dired-get-filename)))
     ((derived-mode-p 'subed-mode)
      (when-let* ((filename (thing-at-point 'filename)))
        (when (string-match (concat "file:\\(.+\\." extensions "\\)") filename)
          (cons 'image (match-string 1 filename)))))
     ((and (buffer-file-name)
           (string-match extensions (buffer-file-name)))
      (cons 'image (buffer-file-name))))))

(with-eval-after-load 'embark
  (add-to-list 'embark-target-finders 'my-embark-image))

(defvar frameshot-directory "~/Pictures/Screenshots/"
  "Default directory for frame shots.")

(defvar frameshot-format 'png
  "Default frame shot format.")

(defun my/frameshot ()
  "Save Emacs frame as frame shot.
Directory is determined by variable `frameshot-directory' and if
not defined, it will be saved in the `$HOME' directory."
  (interactive)
  (let* ((image (x-export-frames nil (or frameshot-format 'png)))
             (base-directory (or frameshot-directory (getenv "HOME")))
             (directory (concat (file-name-as-directory base-directory)
                                        (format-time-string "%Y/%m/%Y-%m-%d/")))
             (file (concat directory (format-time-string "Screenshot-%Y-%m-%d-%T.")
                               (symbol-name frameshot-format))))
    (make-directory directory t)
    (with-temp-file file
      (insert image))
    (dired directory)
    (revert-buffer)
    (dired-goto-file (expand-file-name file))
    (message "Frame shot saved as `%s'" file)))

(defun my/mac-screencapture (&optional arg)
  "Take a screenshot using macOS screencapture.

No prefix:     capture region to clipboard.
C-u:           capture frame to clipboard.
C-u C-u:       capture region to file.
C-u C-u C-u:   capture frame to file."
  (interactive "P")
  (let* ((frame-id (frame-parameter nil 'outer-window-id))
         (to-file (member arg '((16) (64))))
         (filename (when to-file
                     (expand-file-name
                      (read-file-name "Save screenshot to: " nil nil nil
                                      (format-time-string "screenshot-%Y%m%d-%H%M%S.png"))))))
    (pcase arg
      ;; Default: region to clipboard
      ('nil
       (call-process "screencapture" nil nil nil "-s" "-c"))

      ;; C-u: frame to clipboard
      ('(4)
       (if frame-id
           (call-process "screencapture" nil nil nil "-l" frame-id "-c")
         (call-process "screencapture" nil nil nil "-w" "-c")))

      ;; C-u C-u: region to file
      ('(16)
       (call-process "screencapture" nil nil nil "-s" filename))

      ;; C-u C-u C-u: frame to file
      ('(64)
       (if frame-id
           (call-process "screencapture" nil nil nil "-l" frame-id filename)
         (call-process "screencapture" nil nil nil "-w" filename))))

    (if to-file
        (message "Screenshot saved to %s" filename)
      (message "Screenshot copied to clipboard"))))

(use-package project
  :preface
  (defun my/kill-project-and-perspective ()
    "Kill all buffers in the current project and remove its perspective."
    (interactive)
    (let* ((project (project-current))
           (persp-name (and project (file-name-nondirectory
                                     (directory-file-name
                                      (project-root project))))))
      (if (not project)
          (message "Not in a project")
        ;; Kill all project buffers using built-in command
        (project-kill-buffers)

        ;; Kill the perspective if it exists
        (when (and persp-name (persp-with-name-exists-p persp-name))
          (persp-kill persp-name)
          (message "Killed perspective: %s" persp-name)))))

  ;; Custom function to add remote project manually
  (defun my/add-remote-project (remote-path)
    "Add a remote project path to project.el's known projects."
    (interactive "sEnter remote path (e.g. /ssh:user@host:/path/to/project): ")
    (project-remember-project
     (project--find-in-directory (file-name-as-directory remote-path))))

  (defun +project-switch-project-dired (dir)
    (interactive (list (project-prompt-project-dir)))
    (dired dir))

  ;; Function to create or switch to a perspective for a project
  (defun project-persp-switch (project-root)
    "Switch to a perspective named after the PROJECT-ROOT.
Create the perspective if it doesn't exist."
    (interactive)
    (let ((persp-name (file-name-nondirectory
                       (directory-file-name project-root))))
      (if (persp-with-name-exists-p persp-name)
          (persp-switch persp-name)
        ;; Create a new perspective
        (persp-switch persp-name)
        ;; Additional setup for the new perspective if needed
        )))

  ;; Advice to integrate with project.el's project switching
  (defun project-persp-advice (orig-fun &rest args)
    "Advice for `project-switch-project' to create/switch to a perspective."
    (let ((project-root (if args
                            (car args)
                          (project-root (project-current)))))
      (project-persp-switch project-root)
      (apply orig-fun args)))

  ;;; Create a custom command to be added to project-switch-commands
  (defun project-persp-dired ()
    "Open dired in the project root, creating/switching to a perspective for the project."
    (interactive)
    (let ((project (project-current t)))
      (when project
        (let ((root (project-root project)))
          (project-persp-switch root)
          (dired root)))))

  ;; Also integrate with project-find-file
  (defun project-find-file-with-persp-advice (orig-fun &rest args)
    "Advice for `project-find-file' to switch to the project's perspective."
    (let ((project (project-current t)))
      (when project
        (project-persp-switch (project-root project)))
      (apply orig-fun args)))

  :bind (
         ("C-c p p" . project-switch-project)
         ("C-c p d" . project-persp-dired)
         ("C-c p k" . my/kill-project-and-perspective)
         ("C-c p f" . project-find-file)
         ("C-c p F" . project-forget-project)
         ("C-c p c" . project-compile)
         ("C-c p b" . project-switch-to-buffer)
         )

  :custom
  (project-vc-extra-root-markers '(".dir-locals.el"))

  :config
  ;; Custom function to detect project root with TRAMP support
  (defun my/project-try-tramp (dir)
    "Detect project root in DIR, with TRAMP support."
    (let ((root (or (locate-dominating-file dir ".git")
                    (locate-dominating-file dir "Makefile")
                    (locate-dominating-file dir "package.json")
                    (locate-dominating-file dir "setup.py")
                    (locate-dominating-file dir ".project"))))
      (when root
        (cons 'transient root))))

  ;; Add our custom project root detector
  (add-hook 'project-find-functions #'my/project-try-tramp)

  (add-to-list 'project-switch-commands
               '(magit-project-status "Magit" ?M) t)

  ;; Configure project.el to cache remote project information
  (setq project-list-file (locate-user-emacs-file "project-list"))

  ;; Add the advice to project-switch-project
  (advice-add 'project-switch-project :around #'project-persp-advice)

  (advice-add 'project-find-file :around #'project-find-file-with-persp-advice)

  ;; Add the command to project-switch-commands
  (add-to-list 'project-switch-commands '(?p "Perspective" project-persp-dired))

  )

(use-package xref
  :defer t
  :config
  (setq-default xref-history-storage 'xref-window-local-history))

(set-default-coding-systems 'utf-8)     ; Default to utf-8 encoding
(prefer-coding-system       'utf-8)     ; Add utf-8 at the front for automatic detection.
(set-terminal-coding-system 'utf-8)     ; Set coding system of terminal output
(set-keyboard-coding-system 'utf-8)     ; Set coding system for keyboard input on TERMINAL
(set-language-environment "English")    ; Set up multilingual environment

;; Keep the starter kit's centralized autosave/ and backup/ directories.
(setq auto-save-default t        ; Auto-save every buffer that visits a file
      auto-save-timeout 20       ; Number of seconds between auto-save
      auto-save-interval 200)    ; Number of keystrokes between auto-saves

(setq make-backup-files t          ; Backup of a file the first time it is saved.
      vc-make-backup-files t       ; No backup of files under version contr
      backup-by-copying t          ; Don't clobber symlinks
      version-control t            ; Version numbers for backup files
      delete-old-versions t        ; Delete excess backup files silently
      kept-old-versions 6          ; Number of old versions to keep
      kept-new-versions 9          ; Number of new versions to keep
      delete-by-moving-to-trash t) ; Delete files to trash

;; Back
;; (require 'vc-backup)

(use-package 0x0
  :custom
  (0x0-use-curl "~/.local/bin/curl"))

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file nil t))

(use-package files
  :defer t
  :bind
  (:map global-map
        ("C-c f f" . find-file)
        ("C-c f c" . copy-file)
        ("C-c f C" . my/copy-file-to-download-folder)
        ("C-c f u" . my/upload-file-to-remote-folder)
        ("C-c f d" . delete-file)
        ("C-c f m" . rename-file)
        ("C-c f g" . find-file-at-point)
        ("C-c f p" . camdez/show-buffer-file-name)
        ("C-c f t" . find-file-other-tab)
        ("C-c f r" . consult-recent-file)
        ("C-c f R" . find-file-read-only)
        )
  :init

  (defun camdez/show-buffer-file-name ()
    "Show the full path to the current file in the minibuffer."
    (interactive)
    (let ((file-name (buffer-file-name)))
      (if file-name
          (progn
            (message file-name)
            (kill-new file-name))
        (error "Buffer not visiting a file"))))
  )

(use-package recentf
  ;; Loads after 0.5 second of idle time.
  :defer 0.5
  :custom
  (recentf-max-menu-items 15)
  (recentf-max-saved-items 20)
  (recentf-auto-cleanup 60) ; idle for 60 secs
  (recentf-exclude
   '("~\\'" "\\`out\\'" "\\.log\\'" "\\.mp3\\'" "^/[^/]*:" "\\.el\\.gz\\'"))
  :config
  (add-to-list 'recentf-exclude
             (lambda (file)
               (member (expand-file-name file)
                       (mapcar #'expand-file-name (org-agenda-files)))))
  (recentf-mode 1)
  )

(defun my/copy-file-to-download-folder (source-file)
  "Copy SOURCE-FILE to a fixed destination folder without prompting."
  (interactive "fCopy file: ")
  (let ((destination-folder "~/Downloads/"))
    (copy-file source-file (expand-file-name (file-name-nondirectory source-file) destination-folder) t)))

(defun my/copy-folder-to-download-folder (source-directory)
  "Copy SOURCE-DIRECTORY recursively into ~/Downloads/ without prompting."
  (interactive "DCopy directory: ")
  (let* ((destination-folder "~/Downloads/")
         (directory-name
          (file-name-nondirectory
           (directory-file-name source-directory)))
         (destination
          (expand-file-name directory-name destination-folder)))
    (copy-directory source-directory destination nil nil t)))

(defun my/upload-file-to-remote-folder (source-file destination-folder)
  "Copy local SOURCE-FILE to remote DESTINATION-FOLDER."
  (interactive
   (list
    (read-file-name "Upload local file: " nil nil t)
    (read-directory-name "Remote destination: ")))
  (copy-file
   source-file
   (expand-file-name
    (file-name-nondirectory source-file)
    destination-folder)
   t))


(defun my/upload-file-with-consult-tramp (source-file)
  "Upload local SOURCE-FILE to a remote directory selected with consult-tramp."
  (interactive "fUpload local file: ")
  (let* ((remote-directory
          ;; Pick a TRAMP destination using consult-tramp.
          (consult-tramp))
         (destination
          (expand-file-name
           (file-name-nondirectory source-file)
           remote-directory)))
    (copy-file source-file destination t)
    (message "Uploaded %s -> %s"
             source-file destination)))

(defun unpropertize-kill-ring ()
  (setq kill-ring (mapcar 'substring-no-properties kill-ring)))

(add-hook 'kill-emacs-hook 'unpropertize-kill-ring)

(require 'savehist)

(setq kill-ring-max 50
      history-length 50)

(setq savehist-additional-variables
      '(kill-ring
        command-history
        set-variable-value-history
        custom-variable-history
        query-replace-history
        read-expression-history
        minibuffer-history
        read-char-history
        face-name-history
        bookmark-history
        file-name-history))

 (put 'minibuffer-history         'history-length 50)
 (put 'file-name-history          'history-length 50)
 (put 'set-variable-value-history 'history-length 25)
 (put 'custom-variable-history    'history-length 25)
 (put 'query-replace-history      'history-length 25)
 (put 'read-expression-history    'history-length 25)
 (put 'read-char-history          'history-length 25)
 (put 'face-name-history          'history-length 25)
 (put 'bookmark-history           'history-length 25)

(setq history-delete-duplicates t)

(let (message-log-max)
  (savehist-mode))

(my/report-time "History")

(defun my-messages-buffer-keybindings ()
  "Custom key bindings for *Messages* buffer."
  (local-set-key (kbd "a") 'other-window)
  (local-set-key (kbd "q") 'bury-buffer)         ; Press 'q' to bury the buffer
  (local-set-key (kbd "C-c C-l") 'message-clear-log) ; Press 'C-c C-l' to clear messages
  (local-set-key (kbd "g") 'revert-buffer))      ; Press 'g' to refresh the buffer

(add-hook 'messages-buffer-mode-hook 'my-messages-buffer-keybindings)

(require 'server)
(unless (or noninteractive (daemonp) (server-running-p))
  (server-start))

(dolist (directory (list (expand-file-name "~/.local/bin")
                        "/Library/TeX/texbin" "/opt/homebrew/bin"))
  (add-to-list 'exec-path directory t)
  (unless (member directory (parse-colon-path (or (getenv "PATH") "")))
    (setenv "PATH" (concat (or (getenv "PATH") "") path-separator directory))))

(use-package docker
  :defer t
  :bind ("C-c D" . docker)
  :init
  (use-package docker-image   :commands docker-images)
  (use-package docker-volume  :commands docker-volumes)
  (use-package docker-network :commands docker-containers)
  (use-package docker-compose :commands docker-compose)

  (use-package docker-container
    :commands docker-containers
    :custom
    (docker-containers-shell-file-name "/bin/bash")
    (docker-containers-show-all nil)))

(setq shell-file-name "/bin/bash")
(setq sh-shell "/bin/bash")
(setq sh-shell-file "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")
(setq auth-source-cache-expiry nil) ;; cache password never expires

(defun set-tramp-display-from-file ()
  "Read DISPLAY value from remote ~/.display.txt and set it for TRAMP."
  (when (file-remote-p default-directory)
    (let* ((remote-host (file-remote-p default-directory 'host))
           (display
            (with-tramp-connection-property
                (get-process "dummy") remote-host "display"
              (let ((display-file (expand-file-name "~/.display.txt")))
                (if (file-exists-p display-file)
                    (with-temp-buffer
                      (insert-file-contents display-file)
                      (format "DISPLAY=%s" (string-trim (buffer-string))))
                  "DISPLAY=localhost:10.0")))))
      (add-to-list 'tramp-remote-process-environment display))))

(with-eval-after-load 'tramp
  ;; won't work with ess R
  ;; Enable full-featured Dirvish over TRAMP on certain connections
  ;; https://www.gnu.org/software/tramp/#Improving-performance-of-asynchronous-remote-processes-1.
  ;; (add-to-list 'tramp-connection-properties
  ;;              (list (regexp-quote "/ssh:")
  ;;                    "direct-async-process" t))
  (setq tramp-chunksize 2000)
  (setq tramp-verbose 1)
  (setq tramp-default-method "ssh")  ;; use scpx to speed up if ssh is slow
  (setq tramp-remote-path (append tramp-remote-path '(tramp-own-remote-path)))
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                vc-ignore-dir-regexp
                tramp-file-name-regexp))
  (add-to-list 'password-word-equivalents "Second Factor")
  (add-to-list 'password-word-equivalents "First Factor")
  ;; (add-to-list 'tramp-remote-process-environment (format "DISPLAY=%s" (getenv "DISPLAY")))
  (add-hook 'tramp-connected-hook #'set-tramp-display-from-file)
  )

(bind-key "C-c l k" #'tramp-cleanup-all-connections)

(use-package consult-tramp
  :commands consult-tramp
  :bind ("C-c t r" . consult-tramp)
  :custom
  (consult-tramp-method "ssh")
  (consult-tramp-enable-shosts nil)
  )

(use-package proced
  :ensure nil
  :defer t
  :custom
  (proced-enable-color-flag t)
  (proced-tree-flag t)
  (proced-auto-update-flag 'visible)
  (proced-auto-update-interval 1)
  (proced-descent t)
  (proced-filter 'user) ;; We can change interactively with `s'
  :config
  (add-hook 'proced-mode-hook
            (lambda ()
              (proced-toggle-auto-update 1))))

(use-package compile
  :defer t
  :custom
  (compilation-scroll-output 'first-error)
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-context-lines 10)
  )

;; when M-x compile RET grep --color=always -r i .
;; handling ansi color escape
(use-package ansi-color
  :defer t
  :config
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  )

(setq my/section-start-time (current-time))

(use-package corfu
  :commands (corfu-mode global-corfu-mode)
  ;; Optional customizations
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-auto nil)                 ;; Enable auto completion
  (corfu-auto-prefix 2)          ;; Minimum 3 chars for completion
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-separator 32)           ;; SPC as seperator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match t)         ; Quit immediately when no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 6)        ;; Use scroll margin
  (corfu-preselect 'prompt)      ;; Always preselet the prompt
  ;; Enable indentation+completion using the TAB key.
  (tab-always-indent 'complete)  ;; only works in prog-mode, otherwise invoking `completion-at-point'
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)

  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("S-<return>" . corfu-insert))
  :bind
  (:map global-map
        ("C-<tab>" . completion-at-point))

  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  )

(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :custom
  (dabbrev-upcase-means-case-search t)
  (dabbrev-check-all-buffers nil)
  (dabbrev-check-other-buffers t)
  (dabbrev-friend-buffer-function 'dabbrev--same-major-mode-p)
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(defun my/register-org-capfs ()
  "set `completion-at-point-functions' in reverse order"
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'tempel-expand
                     #'cape-dict
                     ))))

;; the priority is in reverse order
(defun my/register-elisp-capfs ()
  "I want  'cape-elisp-block' for emacs-lisp-mode"
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  )

(defun my/register-eshell-capfs ()
  "I want 'cape-history' for comint-mode"
  ;; (add-to-list 'completion-at-point-functions #'cape-line)
  ;; (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'pcomplete-completions-at-point)
  ;; (add-to-list 'completion-at-point-functions #'native-complete-at-point)
  )

(defun my/register-default-capfs ()
  "I use 'cape-dabbrev', `cape-dict' and 'cape-file' everywhere as they are
generally useful. This function needs to be called in certain
mode hooks, as some modes fill the buffer-local capfs with
exclusive completion functions, so that the global ones don't get
called at all."
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  )


(use-package cape
  :defer 10
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (
         ("C-c ; d" . cape-dabbrev)
         ("C-c ; i" . cape-dict)
         ("C-c ; a" . cape-abbrev)
         ("C-c ; f" . cape-file)
         ("C-c ; h" . cape-history)
         ("C-c ; l" . cape-line)
         ("C-c ; t" . cape-tex)
         ("C-c ; e" . cape-elisp-symbol)
         ("C-c ; ;" . cape-emoji)
         )
  :hook
  ((org-mode . my/register-org-capfs)
   (eshell-mode . my/register-eshell-capfs)
   (emacs-lisp-mode . my/register-elisp-capfs))

  :init
  (my/register-default-capfs)

  :config

  (with-eval-after-load 'eglot
    (defun my/eglot-capf ()
      (setq-local completion-at-point-functions
                  (list (cape-capf-super
                         #'eglot-completion-at-point
                         #'tempel-complete
                         ))))
    (add-hook 'eglot-managed-mode-hook #'my/eglot-capf))

  )

(use-package consult
  :bind (
         ("C-c l l" . my/consult-goto-line)
         ("C-c l m" . consult-global-mark)
         ("C-c b b" . consult-bookmark)
         ("C-c b m" . my/consult-my-bookmark)
         )

  :custom
  (consult-preview-key nil) ; No live preview
  (consult-narrow-key "<") ;; Use nano-modeline styling for consult
  (consult-line-start-from-top t)

  :config

  ;; Use Consult for xref locations with a preview feature.
  (setopt xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)

  :preface

  (defun my/consult-outline ()
    (interactive)
    (consult-outline)
    (when (derived-mode-p 'org-mode)
      (org-narrow-to-subtree))
    )

  (defun my/consult-line ()
    "Consult line with live preview"
    (interactive)
    (let ((consult-preview-key 'any)
          (mini-frame-resize 'grow-only)) ;; !! Important
      (consult-line (thing-at-point 'symbol))))

  (defun my/consult-goto-line ()
    "Consult goto line with live preview"
    (interactive)
    (let ((consult-preview-key 'any))
      (consult-goto-line)))

  (defun my/get-project-root ()
    (when (fboundp 'projectile-project-root)
      (projectile-project-root)))

  ;; Ripgrep the current word from project root
  (defun my/consult-ripgrep ()
    (interactive)
    (consult-ripgrep (my/get-project-root)(thing-at-point 'symbol)))

  (defun consult-org-links--parse-file (file)
    "Parse org FILE and return list of (description . link) pairs."
    (let ((links '()))
      (with-temp-buffer
        (insert-file-contents file)
        (org-mode)
        (goto-char (point-min))
        (while (re-search-forward org-link-bracket-re nil t)
          (let* ((raw-link (match-string-no-properties 1))
                 (desc (or (match-string-no-properties 2)
                           (file-name-nondirectory raw-link)))
                 (link (org-link-expand-abbrev raw-link)))
            (push (cons desc link) links))))
      (nreverse links)))

  (defun consult-org-links--format-candidate (link-pair)
    "Format LINK-PAIR for consult completion."
    (let ((desc (car link-pair))
          (link (cdr link-pair)))
      (format "%s %s"
              (propertize desc 'face 'nano-default)
              (propertize link 'face 'nano-faded))))

  (defun consult-org-links--ensure-org-link (link)
    "Return LINK wrapped as an Org link if it's not already."
    (if (string-match-p "\\`\\[\\[.*\\]\\]\\'" link)
        link
      (format "[[%s]]" link)))

  (defun consult-org-links--action-simple (link)
    "Open LINK based on its type."
    (when (and link (stringp link) (not (string-empty-p link)))
      (if (string-match-p "\\`https?://" link)
          (browse-url link)
        (org-open-link-from-string
         (consult-org-links--ensure-org-link link)))))


  (defun consult-org-links-simple (org-file &optional use-eww)
    "Select and open org links using consult completion."
    (interactive "fOrg file: \nP")
    (let* ((links (consult-org-links--parse-file org-file))
           (table (make-hash-table :test 'equal))
           (candidates (mapcar (lambda (link-pair)
                                 (let ((formatted (consult-org-links--format-candidate link-pair)))
                                   (puthash formatted (cdr link-pair) table)
                                   formatted))
                               links)))
      (if candidates
          (let ((selected
                 (consult--read
                  candidates
                  :prompt "Org link: "
                  :category 'org-url-link))) ; this is key
            (when-let* ((link (gethash selected table)))
              (if (and use-eww (string-match-p "\\`https?://" link))
                  (eww-browse-url link)
                (consult-org-links--action-simple link))))
        (message "No org links found"))))

  (defun my/consult-my-bookmark (&optional use-eww)
    (interactive "P")
    (consult-org-links-simple "~/Dropbox/Org/GTD/bookmarks.org" use-eww))

  )

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(my/report-time "Completion")

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil) ; this the default used by the below
  (completion-category-overrides '((file (styles  partial-completion))))
  (completion-pcm-leading-wildcard t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  )

(use-package vertico
  :defer 1
  :custom
  (vertico-count 8) ; Maximal number of candidates to show.
  (vertico-resize nil); How to resize the Vertico minibuffer window.
  (vertico-count-format nil); No prefix with number of entries
  (vertico-cycle t)
  :bind (:map vertico-map
              ("<backtab>" . minibuffer-complete))
  :config
  (vertico-mode)

  (setq vertico-grid-separator
        #("  |  " 2 3 (display (space :width (1))
                               face (:background "#ECEFF1")))

        vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                                display (space :align-to (- right (-1 . right-margin) (- +1)))))))

  (set-face-attribute 'vertico-group-separator nil
                      :strike-through t)
  (set-face-attribute 'vertico-current nil
                      :inherit '(nano-strong nano-subtle))
  (set-face-attribute 'completions-first-difference nil
                      :inherit '(nano-default))
  )

(use-package vertico-directory
  :after vertico
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("TAB" . vertico-insert)
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(defun minibuffer-format-candidate (orig cand prefix suffix index _start)
  (let ((prefix (if (= vertico--index index)
                    "  "
                  "   ")))
    (funcall orig cand prefix suffix index _start)))

(advice-add #'vertico--format-candidate
           :around #'minibuffer-format-candidate)

(defun vertico--prompt-selection ()
  "Highlight the prompt"

  (let ((inhibit-modification-hooks t))
    (set-text-properties (minibuffer-prompt-end) (point-max)
                         '(face (nano-strong nano-salient)))))

(defun minibuffer-vertico-setup ()

  (setq truncate-lines t)
  (setq completion-in-region-function
        (if vertico-mode
            #'consult-completion-in-region
          #'completion--in-region)))

(add-hook 'vertico-mode-hook #'minibuffer-vertico-setup)
(add-hook 'minibuffer-setup-hook #'minibuffer-vertico-setup)

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-c" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  (setq-default marginalia--ellipsis "…"    ; Nicer ellipsis
              marginalia-align 'right       ; right alignment
              marginalia-align-offset -1)   ; one space on the right


  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode)

  )

(use-package embark
  :bind
  (:map global-map
        ("C-;" . embark-dwim)
        ("C-." . embark-act)
        ("C-h B" . embark-bindings) ;; alternative for `describe-bindings'
        :map embark-region-map
        ("U" . 0x0-dwim)
        ("S" . my/search-query)
        :map embark-file-map
        ("x" . my/xwidget-browse-file)
        :map embark-url-map
        ("x" . xwidget-webkit-browse-url)
        )

  :init

  (defun my/xwidget-browse-file (file)
    "Open FILE in xwidget-webkit-browse-url."
    (xwidget-webkit-browse-url
     (concat "file://" (expand-file-name file))))

  (defvar my/search-engine-url
    "https://duckduckgo.com/html/?q=%s"
    "Search URL used by my search commands.")

  (defun my/search-query (query)
    "Search QUERY using `browse-url'."
    (interactive "sSearch: ")
    (browse-url
     (format my/search-engine-url
             (url-hexify-string query))))

  (defun my/search-thing-at-point-or-prompt ()
    "Search active region, symbol at point, or prompt."
    (interactive)
    (my/search-query
     (cond
      ((use-region-p)
       (buffer-substring-no-properties
        (region-beginning)
        (region-end)))
      ((thing-at-point 'symbol t))
      (t
       (read-string "Search: ")))))

  ;; replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  (setq embark-cycle-key ".") ; https://github.com/oantolin/embark/issues/786

  :config


  (with-eval-after-load 'vertico
    (vertico-multiform-mode) ; make which-key like help
    (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))
    )

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-i" . tempel-complete)
         ("M-+" . tempel-insert))

  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  )



(delete-selection-mode 1)

(setq-default fill-column 80)
(defun my/fill-unfill ()
  "Like `fill-paragraph', but unfill if used twice."

  (interactive)
  (let ((fill-column
         (if (eq last-command #'my/fill-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(bind-key "M-q"  #'my/fill-unfill)
;; (bind-key [remap fill-paragraph]  #'my/fill-unfill)

(defun uppercasep (c) (and (= ?w (char-syntax c)) (= c (upcase c))))

(defun downcase-char ()
  (interactive)
  (save-excursion
    (let ((ch (thing-at-point 'char t)))
      (delete-char 1)
      (insert (downcase ch)))))

(defun zl-toggle-case-dwiam ()
  "toggle cases, do what i actually mean:

If no region is active, toggle between upcase and downcase on the
current character. If a region is active, then if there exists at
least one upcase char in the region, then downcase the whole
region. Otherwise, upcase the whole region."
  (interactive)
  (if (region-active-p)
      (let ((region (buffer-substring-no-properties
                     (region-beginning) (region-end))))
        (message "%s" region)
        (if (cl-remove-if-not #'uppercasep (string-to-list region))
            (downcase-region (region-beginning) (region-end))
          (upcase-region (region-beginning) (region-end))))
    (if (uppercasep (string-to-char (thing-at-point 'char t)))
        (downcase-char)
      (upcase-char 1))))

(defun replace-bounds (strt end content)
  (delete-region strt end)
  (insert (number-to-string content)))

(defun zl-increase-number (arg)
  "increase number at point"
  (interactive "P")
  (let* ((num (thing-at-point 'number t))
         (bounds (bounds-of-thing-at-point 'word))
         (strt (car bounds))
         (end (cdr bounds)))
    (message "%s" arg)
    (if arg
        (replace-bounds strt end (+ num arg))
      (replace-bounds strt end (+ num 1)))))

(defun zl-decrease-number ()
  "decrease number at point"
  (interactive)
  (let ((current-prefix-arg -1))
    (call-interactively #'zl-increase-number)))

(setq-default visible-bell nil             ; No visual bell
              ring-bell-function 'ignore)  ; No bell

(setq-default mouse-yank-at-point t) ; Yank at point rather than pointer
(mouse-avoidance-mode 'exile)        ; Avoid collision of mouse with point

(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") #'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") #'scroll-up-line))

(setq-default scroll-conservatively 101       ; Avoid recentering when scrolling far
              scroll-margin 2                 ; Add a margin when scrolling vertically
              recenter-positions '(5 bottom)) ; Set re-centering positions

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(setq-default select-enable-clipboard t) ; Merge system's and Emacs' clipboard
;; (setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-selection-value)
(bind-key "s-c" #'clipboard-kill-ring-save) ;; copy
(bind-key "s-v" #'clipboard-yank) ;; paste

(defun my/paste-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun my/copy-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(when (and (not (display-graphic-p))
           (eq system-type 'darwin))
  (setq interprogram-cut-function   #'my/copy-to-osx
        interprogram-paste-function #'my/paste-from-osx))

;; https://emacs.stackexchange.com/questions/19982/hunspell-error-in-emacs
(use-package ispell
  :custom
  (ispell-program-name "hunspell"))

(use-package flyspell
  :after ispell
  :bind (("C-c i b" . flyspell-buffer)
         ("C-c i f" . flyspell-mode))
  :custom
  (flyspell-abbrev-p nil)
  (flyspell-use-meta-tab nil)
  )





(use-package hl-line
  :commands hl-line-mode
  :hook (prog-mode . hl-line-mode)
  )

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("BUG"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(setq-default indent-tabs-mode nil        ; Stop using tabs to indent
              tab-always-indent 'complete ; Indent first then try completions
              tab-width 4)                ; Smaller width for tab characters

(remove-hook 'find-file-hooks 'vc-find-file-hook)

(use-package magit
  :bind (("C-M-g" . magit-status))
  :bind (:map magit-mode-map
              ("U" . magit-unstage-all))
  :bind (:map magit-file-section-map ("<C-return>"))
  :bind (:map magit-hunk-section-map ("<C-return>"))
  :custom
  (magit-process-connection-type nil) ; speedup on macOS
  (magit-diff-options nil)
  (magit-diff-refine-hunk t)
  (magit-fetch-arguments nil)
  ;; This is done for the sake of performance on macOS
  (magit-git-executable "/opt/homebrew/bin/git")
  (magit-highlight-trailing-whitespace nil)
  (magit-highlight-whitespace nil)
  (magit-log-section-commit-count 10)
  (magit-pre-refresh-hook nil)
  (magit-process-popup-time 15)
  (magit-push-always-verify nil)
  ;; You can tell Magit to only automatically refresh the current Magit
  ;; buffer, but not the status buffer. If you do that, then the status buffer
  ;; is only refreshed automatically if it is the current buffer.
  (magit-refresh-status-buffer nil)
  (magit-section-initial-visibility-alist '((untracked . hide)))
  (magit-stage-all-confirm nil)
  (magit-unstage-all-confirm nil)
  (magit-use-overlays nil)
  :preface
  ;; History can be viewed with:
  ;; git log refs/snapshots/$(git symbolic-ref HEAD)
  (defun magit-monitor (&optional _no-display)
    "Start git-monitor in the current directory."
    (interactive)
    (let* ((path (file-truename
                  (directory-file-name
                   (expand-file-name default-directory))))
           (name (format "*git-monitor: %s*"
                         (file-name-nondirectory path))))
      (unless (and (get-buffer name)
                   (with-current-buffer (get-buffer name)
                     (string= path (directory-file-name default-directory))))
        (with-current-buffer (get-buffer-create name)
          (cd path)
          (if (file-regular-p ".git")
              (let ((branch (string-chop-newline
                             (shell-command-to-string
                              "git branch --show-current")))
                    (repo
                     (with-temp-buffer
                       (insert-file-contents-literally ".git")
                       (goto-char (point-min))
                       (and (looking-at "^gitdir: \\(.+?/\\.git/\\)")
                            (match-string 1)))))
                (when repo
                  (ignore-errors
                    (start-process "*git-monitor*" (current-buffer)
                                   "git-monitor"
                                   "--git-dir" repo
                                   "--work-dir" path
                                   "-r" (concat "refs/heads/" branch)))))
            (ignore-errors
              (start-process "*git-monitor*" (current-buffer)
                             "git-monitor" "--work-dir" path)))))))

  (defun magit-status-with-prefix ()
    (interactive)
    (let ((current-prefix-arg '(4)))
      (call-interactively #'magit-status)))

  (defun endless/visit-pull-request-url ()
    "Visit the current branch's PR on Github."
    (interactive)
    (browse-url
     (format "https://github.com/%s/pull/new/%s"
             (replace-regexp-in-string
              "\\`.+github\\.com:\\(.+?\\)\\(\\.git\\)?\\'" "\\1"
              (magit-get "remote" (magit-get-remote) "url"))
             (magit-get-current-branch))))

  (defvar magit--call-git-cache (make-hash-table :test #'equal))

  (defun my-magit-cache-config (orig-func &rest args)
    (or (and (string= (car args) "config")
             (gethash args magit--call-git-cache))
        (let ((result (apply orig-func args)))
          (puthash args result magit--call-git-cache)
          result)))

  :hook ((magit-mode . hl-line-mode))

  :config

  ;; Add fringe on the left side of magit windows such that we can highlight region using the fringe.

  (add-hook 'magit-mode-setup-hook
            #'(lambda ()
                (interactive)
                (set-window-fringes nil (* 2 (window-font-width)) 0)
                ))

  (add-hook 'magit-status-mode-hook #'(lambda () (magit-monitor t)))

  (define-key magit-mode-map "G" #'endless/visit-pull-request-url)

  ;; Magit also reverts buffers for visited files located inside the current
  ;; repository when the visited file changes on disk. That is implemented on
  ;; top of auto-revert-mode from the built-in library autorevert. To figure
  ;; out whether that impacts performance, check whether performance is
  ;; significantly worse, when many buffers exist and/or when some buffers
  ;; visit files using TRAMP. If so, then this should help.
  (setq auto-revert-buffer-list-filter
        'magit-auto-revert-repository-buffer-p)

  (setq magit-bury-buffer-function 'magit-restore-window-configuration
        magit-display-buffer-function 'magit-display-buffer-fullframe-status-topleft-v1)

  ;; When refreshing the "references buffer" is slow, then that’s usually
  ;; because several hundred refs are being displayed. The best way to address
  ;; that is to display fewer refs, obviously.
  (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)

  ;; When you initiate a commit, then Magit by default automatically shows a
  ;; diff of the changes you are about to commit. For large commits this can
  ;; take a long time, which is especially distracting when you are committing
  ;; large amounts of generated data which you don’t actually intend to
  ;; inspect before committing. This behavior can be turned off using:
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff)

  (advice-add 'magit-git-items :around #'my-magit-cache-config)

  (advice-add 'magit-set-header-line-format :override #'ignore)

  (use-package magit-commit
    :defer t
    :config
    (use-package git-commit
      :custom
      (git-commit-major-mode 'markdown-mode)
      (git-commit-setup-hook
       '(git-commit-save-message
         git-commit-turn-on-auto-fill
         ;; git-commit-turn-on-flyspell
         bug-reference-mode))))

  (use-package magit-pull
    :defer t
    :config
    (transient-insert-suffix 'magit-pull "p"
      '("F" "default" magit-fetch-from-upstream)))

  (use-package magit-push
    :defer t
    :config
    (transient-insert-suffix 'magit-push "p"
      '("P" "default" magit-push-current-to-upstream)))

  (use-package magit-status
    :defer t
    :config
    ;; Speed up Magit status by not generating all of the available sections.
    (dolist (func '(
                    ;; magit-insert-status-headers
                    ;; magit-insert-untracked-files
                    ;; magit-insert-unstaged-changes
                    ;; magit-insert-staged-changes
                    ;; magit-insert-stashes
                    ;; magit-insert-unpushed-to-pushremote
                    magit-insert-unpushed-to-upstream-or-recent
                    magit-insert-unpulled-from-pushremote
                    magit-insert-unpulled-from-upstream
                    ))
      (remove-hook 'magit-status-sections-hook func))
    (dolist (func '(
                    ;; magit-insert-error-header
                    magit-insert-diff-filter-header
                    ;; magit-insert-head-branch-header
                    ;; magit-insert-upstream-branch-header
                    ;; magit-insert-push-branch-header
                    magit-insert-tags-header
                    ))
      (remove-hook 'magit-status-headers-hook func)))

  )

(use-package ediff
  :defer t
  :custom
  (ediff-combination-pattern
   '("<<<<<<< A: HEAD" A "||||||| Ancestor" Ancestor "=======" B ">>>>>>> B: Incoming"))
  (ediff-diff-options "-w")
  (ediff-highlight-all-diffs nil)
  (ediff-show-clashes-only t)
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally)
  )

(use-package hideshow
  :ensure nil
  :custom
  (hs-isearch-open t)
  :hook
  ((c-mode          . hs-minor-mode)
   (c++-mode        . hs-minor-mode)
   (c-ts-mode       . hs-minor-mode)
   (c++-ts-mode     . hs-minor-mode)
   (emacs-lisp-mode . hs-minor-mode)
   (java-mode       . hs-minor-mode)
   (java-ts-mode    . hs-minor-mode)
   (rust-mode       . hs-minor-mode)
   (rust-ts-mode    . hs-minor-mode)
   (go-mode         . hs-minor-mode)
   (go-ts-mode      . hs-minor-mode)
   (js-mode         . hs-minor-mode)
   (js-ts-mode      . hs-minor-mode)
   (typescript-mode    . hs-minor-mode)
   (typescript-ts-mode . hs-minor-mode)
   (css-mode        . hs-minor-mode)
   (css-ts-mode     . hs-minor-mode)
   (sh-mode         . hs-minor-mode)
   (bash-ts-mode    . hs-minor-mode)
   (js-json-mode    . hs-minor-mode)
   (json-ts-mode    . hs-minor-mode)
   (html-mode       . hs-minor-mode)
   (perl-mode       . hs-minor-mode)))

(use-package outline-indent
  :ensure nil
  :commands outline-indent-minor-mode
  :custom
  (outline-indent-ellipsis " ▼")
  :hook
  ((python-mode . outline-indent-minor-mode)
   (python-ts-mode . outline-indent-minor-mode)
   (yaml-mode . outline-indent-minor-mode)
   (yaml-ts-mode . outline-indent-minor-mode)
   (haskell-mode . outline-indent-minor-mode)))

(use-package kirigami
  :ensure nil
  :bind (("C-c l o" . kirigami-toggle-fold))
  :init
  (kirigami-global-mode 1))

(setq my/section-start-time (current-time))

(defun my/calc-offset-on-org-level ()
  "Calculate offset (in chars) on current level in org mode file."

  (* (or (org-current-level) 0) org-indent-indentation-per-level))

(defun my/org-fill-paragraph (&optional justify region)
  "Calculate apt fill-column value and fill paragraph."

  (let* ((fill-column (- fill-column (my/calc-offset-on-org-level))))
    (org-fill-paragraph justify region)))

(defun my/org-auto-fill-function ()
  "Calculate apt fill-column value and do auto-fill"

  (let* ((fill-column (- fill-column (my/calc-offset-on-org-level))))
    (org-auto-fill-function)))

(setq org-directory "~/Dropbox/Org/GTD")
(use-package org
  :defer t
  :custom
  (org-yank-image-save-method "~/Dropbox/Org/Images")
  (org-ellipsis " …")                  ; Nicer ellipsis
  (org-tags-column 0)              ; Tags next to header title
  (org-agenda-tags-column 0)       ;
  (org-hide-emphasis-markers t)    ; Hide markers
  (org-cycle-separator-lines 2)    ; Number of empty lines between sections
  (org-use-tag-inheritance '("events"))    ; nil for Tags ARE NOT inherited
  (org-use-property-inheritance t) ; Properties ARE inherited
  (org-link-use-indirect-buffer-for-internals t) ; Indirect buffer for internal links
  (org-fontify-quote-and-verse-blocks t) ; Specific face for quote and verse blocks
  (org-fontify-whole-block-delimiter-line t) ; Fontify whole block
  (org-return-follows-link nil)    ; Follow links when hitting return
  (org-image-actual-width nil)     ; Resize image to window width
  (org-export-coding-system 'utf-8) ; coding-system
  (org-indirect-buffer-display 'other-window) ; Tab on a task expand it in a new window
  (org-src-fontify-natively t)         ; Fontify code in code blocks.
  (org-adapt-indentation nil)          ; Adaptive indentation
  (org-src-tab-acts-natively t)        ; Tab acts as in source editing
  (org-confirm-babel-evaluate nil)     ; No confirmation before executing code
  (org-edit-src-content-indentation 0) ; No relative indentation for code blocks
  (org-plantuml-jar-path "~/.local/bin/plantuml.jar")
  (org-babel-latex-htlatex "htlatex")  ; Command to convert latex to svg and html
  (org-latex-preview-ltxpng-directory "~/.ltximg/")
  (org-latex-default-class "article")
  (org-outline-path-complete-in-steps nil) ; No steps in path display
  (org-return-follows-link t) ; return open link at point
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)")))
  (org-indent-indentation-per-level 2) ; Indentation per level
  (org-hide-block-startup t) ; hide blocks on startup
  (org-preview-latex-default-process 'xelatex)
  (org-highlight-latex-and-related '(native))
  (org-preview-latex-process-alist
   '((xelatex
      :programs ("xelatex" "dvisvgm")
      :description "xdv > svg"
      :message "you need to install the programs: xelatex and dvisvgm."
      :image-input-type "xdv"
      :image-output-type "svg"
      :image-size-adjust (2.0 . 1.5)
      :latex-compiler ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
      :image-converter ("dvisvgm %f --page=1- --optimize --clipjoin --relative --no-fonts --exact-bbox --scale=%S --output=%O"))))
  (org-format-latex-options
   '(:foreground default :background default :scale 1.2
                         :html-foreground "Black" :html-background "Transparent"
                         :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
  ;; :config
  ;; (plist-put org-format-latex-options :scale 1.2)
  )

(defun ek/babel-ansi ()
  (when-let* ((beg (org-babel-where-is-src-block-result nil nil)))
    (save-excursion
      (goto-char beg)
      (when (looking-at org-babel-result-regexp)
        (let ((end (org-babel-result-end))
              (ansi-color-context-region nil))
          (ansi-color-apply-on-region beg end))))))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((calc . t)
     (shell . t)
     (latex . t)
     (python . t)
     (R . t)
     (C . t)
     (plantuml . t)))
  (setq org-babel-python-command "~/Projects/pyone/.venv/bin/python3")
  (add-hook 'org-babel-after-execute-hook 'ek/babel-ansi)
  (remove-hook 'kill-emacs-hook 'org-babel-remove-temporary-directory)
  )

(with-eval-after-load 'org
  (define-key org-mode-map "\C-c;" nil) ;; disable C-c ; for toggle comment
  (define-key org-mode-map (kbd "C-j") nil) ;; disable C-j  for `org-return-and-maybe-indent'
  (define-key org-mode-map (kbd "C-'") nil) ;; disable C-'  for org-cycle-agenda-files
  (define-key org-mode-map (kbd "C-c RET") nil) ;; disable C-c RET  for org-table-hline-and-move
  (define-key org-mode-map (kbd "<f5>") #'org-edit-special) ; open `org-edit-special'
  (define-key org-src-mode-map (kbd "<f5>") #'org-edit-src-exit) ; exit `org-edit-special'
  (bind-key "C-c C-<return>"  #'org-table-hline-and-move 'org-mode-map)
  (bind-key "C-c s s"  #'org-store-link)         ;; store a link at any point
  (bind-key "C-c s i"  #'org-insert-link-global) ;; insert a previous stored link
  (bind-key "C-c s l"  #'org-open-at-point-global) ;; visit a link - no matter the mode
  (bind-key "C-c s g"  #'org-mark-ring-goto)       ;; go back to where I was after visiting a link in org mode only
)

(use-package ox-latex
  :defer t
  :after org
  :custom
  ;;; %latex gets replaced with org-latex-compiler
  ;;; OR overridden by the #+LATEX_COMPILER header
  (org-latex-compiler "lualatex")
  (org-latex-pdf-process '("latexmk -f -pdf -%latex -interaction=nonstopmode -shell-escape -output-directory=%o %f"))
  (org-latex-toc-command "\\tableofcontents
\\clearpage
")
  (org-latex-src-block-backend 'engraved)
  (org-latex-packages-alist
   '(("T1" "fontenc" t)
     ("" "amsmath" t)
     ("" "mathtools" t)
     ("" "siunitx" t)
     ("" "fvextra" t) ;; for engrave-faces
     ("" "lmodern" t)
     ("" "booktabs" t)
     ))
  )



(with-eval-after-load 'ox-latex
  ;; (require 'oc-natbib)
  (require 'oc-biblatex)
  (setq bibtex-dialect 'biblatex)
  (setq org-latex-default-class "article")
  (setq org-cite-export-processors
        '((latex biblatex)
          (t basic)))
  ;; accessible tagged pdf: https://jamesendreshowell.com/2025-12-29-org-mode-latex-and-tagged-pdfs-producing-accessible-documents.html
  (defvar org-latex-metadata "\\DocumentMetadata{lang = en, pdfversion = 2.0, pdfstandard = ua-2, pdfstandard = a-4}"
    "LaTeX preamble command to specify PDF accessibility metadata.\nIt must appear before the \\documentclass{} declaration.")

  (setq org-latex-classes
        `(
          ("article" ,(concat org-latex-metadata "\n" "\\documentclass[11pt]{article}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ))
  (add-to-list 'org-latex-classes
               '("chinese"
                         "\\documentclass[11pt]{article}
\\usepackage{xeCJK}
[EXTRA]
[PACKAGES]"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                         ))
  (add-to-list 'org-latex-classes
               '("minipaper"
                         "\\documentclass[letterpaper,12pt,leqno]{article}
\\usepackage{paper}
[NO-DEFAULT-PACKAGES]
[EXTRA]
[PACKAGES]"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                         ))
  )

(my/report-time "Org latex")
(setq my/section-start-time (current-time))


(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))

(with-eval-after-load 'org
  (add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date))

(use-package toc-org
  :defer t
  :after org
  :hook
  (org-mode . toc-org-mode)
  )



(defun my/org-mode-hook ()
  (setq-local fill-paragraph-function #'my/org-fill-paragraph
              normal-auto-fill-function #'my/org-auto-fill-function))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook 'my/org-mode-hook)
  )

(defun my/org-delete-file-link-and-file ()
  "Delete the org file link at point and the file it points to."
  (interactive)
  (let* ((context (org-element-context))
         (type (org-element-type context)))
    (unless (eq type 'link)
      (user-error "No link at point"))
    (let* ((link context)
           (link-type (org-element-property :type link))
           (path (org-element-property :path link))
           (begin (org-element-property :begin link))
           (end (org-element-property :end link)))
      (unless (string= link-type "file")
        (user-error "Not a file link"))
      (let ((full-path (expand-file-name path)))
        (unless (file-exists-p full-path)
          (user-error "File does not exist: %s" full-path))
        (when (yes-or-no-p (format "Delete file '%s' and this link? " full-path))
          (delete-file full-path t)  ; t = move to trash
          (delete-region begin end)
          (message "Deleted file and link: %s" full-path))))))



(my/report-time "Org")

(setq my/section-start-time (current-time))

(use-package life-calendar
  :commands (life-calendar))

(use-package org-timegrid
  :ensure nil
  :demand t
  :bind ("C-c g" . org-timegrid-week)
  :init
  ;; The symbol `agenda' means: read events from `org-agenda-files'.
  (setq org-timegrid-org-files 'agenda
        org-timegrid-org-capture-file
        (expand-file-name "calendar.org" org-directory)
        org-timegrid-org-capture-template
        '(:target file
                  :template "* %{title}\n%{time-range}\n%?")

        ;; Save Org buffers immediately after edits made in the calendar.
        org-timegrid-org-auto-save t

        ;; Set this to nil if repeating entries should be hidden.
        org-timegrid-org-show-repeaters t

        ;; The first matching tag supplies an event's colour.
        org-timegrid-org-tag-color-alist
        '(("work"     . indigo)
          ("personal" . green)
          ("reading"  . yellow)
          ("errand"   . cyan)))
  :config
  ;; This is part of the same package. It adds a read-only day strip to Org
  ;; Agenda; pressing RET on the strip opens the editable week view.
  (use-package org-timegrid-agenda
    :ensure nil
    :after org-agenda
    :demand t
    :init
    ;; nil inserts the strip at the top. To place it after a particular custom
    ;; agenda block, use a regexp matching that block's heading instead.
    (setq org-timegrid-agenda-insert-after nil
          org-timegrid-agenda-separator t
          org-timegrid-agenda-minutes-before 180
          org-timegrid-agenda-minutes-after 180)
    :config
    (org-timegrid-agenda-mode 1))
  )

(use-package org-agenda
  :defer t
  :commands org-agenda
  :bind (("C-c a" . org-agenda))
  :custom
  (org-agenda-window-setup 'current-window)
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-show-all-dates nil)
  (org-agenda-time-in-grid t)
  (org-agenda-show-current-time-in-grid t)
  (org-agenda-start-on-weekday 1)
  (org-agenda-span 7)
  (org-agenda-hide-tags-regexp ".") ; No tags
  (org-agenda-tags-column 0)
  (org-agenda-block-separator nil)
  (org-agenda-category-icon-alist nil)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-sticky t)
  ;; files
  (org-agenda-files (list (expand-file-name "inbox.org" org-directory)
                          (expand-file-name "bookmarks.org" org-directory)
                          (expand-file-name "life.org" org-directory)
                          (expand-file-name "projects.org" org-directory)))
  ;; prefix
  (org-agenda-prefix-format
   '((agenda . "%i %?-12t%s")
     (todo .   "%i")
     (tags .   "%i")
     (search . "%i")))
  ;; sorting strategy
  (org-agenda-sorting-strategy
   '((agenda deadline-down scheduled-down todo-state-up time-up
             habit-down priority-down category-keep)
     (todo   priority-down category-keep)
     (tags   timestamp-up priority-down category-keep)
     (search category-keep)))
  ;; grid looking
  (org-agenda-time-grid
   '((daily today require-timed)
     ()
     "......" "----------------"))
  (org-agenda-current-time-string "   now")

  (org-agenda-custom-commands
   '(
     ("d" "Get Things Done (GTD)"
      (
       (todo "NEXT|TODO"
             ( (org-agenda-todo-keyword-format ":%s:")
               (org-agenda-prefix-format '((todo   . " ")))
               ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
               (org-agenda-overriding-header (propertize "📅 TODO \n" 'face 'nano-strong))))

       (tags "DEADLINE>=\"<today>\""
             ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
              (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
              (org-agenda-overriding-header "\n🔔 Upcoming deadlines \n")))

       ;; (tags "events"
       ;;       ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
       ;;        (org-agenda-overriding-header "\n🫂 Upcoming events \n")))

       ;; (tags-todo "travel+SCHEDULED>=\"<today>\""
       ;;            ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
       ;;             (org-agenda-overriding-header "\n✈ Upcoming travels \n")))

       (tags-todo "DEADLINE<\"<today>\""
                  ((org-agenda-prefix-format '((tags .  " %(my/org-agenda-custom-date) ")))
                   (org-agenda-overriding-header "\n🦀 Overdue \n")))

       ))))

  :init

  ;; Save the corresponding buffers
  (defun gtd-save-org-buffers ()
    "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
    (interactive)
    (message "Saving org-agenda-files buffers...")
    (save-some-buffers t (lambda ()
                                       (when (member (buffer-file-name) org-agenda-files)
                                         t)))
    (message "Saving org-agenda-files buffers... done"))

  ;; Add it after refile
  (advice-add 'org-refile :after
                  (lambda (&rest _)
                    (gtd-save-org-buffers)))
  ;; save buffers after agenda quit
  (advice-add 'org-agenda-quit :before 'gtd-save-org-buffers)

  )



(defun my/org-agenda-highlight-todo (x)
  (let* ((done (string-match-p (regexp-quote ":DONE:") x))
         (canceled (string-match-p (regexp-quote "~") x))
         (x (replace-regexp-in-string ":TODO:" "" x))
         (x (replace-regexp-in-string ":NEXT:" "" x))
         (x (replace-regexp-in-string ":IDEA:" "" x))
         (x (replace-regexp-in-string ":DONE:" "" x))
         (x (replace-regexp-in-string "~" "" x))
         (x (if (and (boundp 'org-agenda-dim) org-agenda-dim)
                (propertize x 'face 'nano-faded) x))
         (x (if done (propertize x 'face 'nano-faded) x))
         (x (if canceled (propertize x 'face 'nano-faded) x)))
    x))

(advice-add 'org-agenda-highlight-todo
            :filter-return #'my/org-agenda-highlight-todo)


(defun my/org-agenda-custom-date ()
  "Return the entry's date without requiring SVG packages."
  (let ((timestamp (or (org-entry-get nil "TIMESTAMP")
                       (org-entry-get nil "SCHEDULED")
                       (org-entry-get nil "DEADLINE"))))
    (if timestamp
        (propertize (format-time-string "%d/%m"
                                        (org-time-string-to-time timestamp))
                    'face 'nano-popout)
      "     ")))

;; Package installation is declared in my/straight-custom-recipes above.

(use-package org-better-agenda)

(use-package recommended-config-for-org-better-agenda
  :custom
  (org-better-agenda-inbox-file (expand-file-name "inbox.org" org-directory))
  :after org-better-agenda)

(defvar my/org-agenda-update-delay 60)
(defvar my/org-agenda-update-timer nil)

(defun my/org-agenda-update ()
  "Refresh daily agenda view"

  (when my/org-agenda-update-timer
    (cancel-timer my/org-agenda-update-timer))

  (let ((window (get-buffer-window "*Org Agenda(a)*" t)))
    (when window
      (with-selected-window window
        (let ((inhibit-message t))
          (org-agenda-redo)))))

  (setq my/org-agenda-update-timer
    (run-with-idle-timer
     (time-add (current-idle-time) my/org-agenda-update-delay)
     nil
     'my/org-agenda-update)))

(run-with-idle-timer my/org-agenda-update-delay t 'my/org-agenda-update)

(setq org-outline-path-complete-in-steps nil)
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets
      '(
        ("life.org" :maxlevel . 1)
        ("bookmarks.org" :maxlevel . 2)
        ("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("c" "org-protocol-capture" entry (file "inbox.org")
         "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
        ("B" "Bookmarks" entry  (file+headline "bookmarks.org" "Reading")
        ,(concat "* TODO %?\n"))
        ("m" "Meeting" entry  (file+headline "life.org" "Events")
        ,(concat "* %? :meeting:\n"))
        ))

(bind-key "C-c c" #'org-capture)

(defun my/org-capture-meeting ()
  (interactive)
  (org-capture nil "m"))

(bind-key "C-c m" #'my/org-capture-meeting)

(defun my/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(bind-key "C-c i" #'my/org-capture-inbox)

(defun my/org-capture-bookmark ()
  (interactive)
  (org-capture nil "B"))

(bind-key "C-c B" #'my/org-capture-bookmark)

(defun my/org-capture-mu4e ()
  (interactive)
  (org-capture nil "@"))

(bind-key "C-c @" #'my/org-capture-mu4e)

(with-eval-after-load 'org-capture

  (defun org-capture-place-template (&optional inhibit-wconf-store)
    "Insert the template at the target location, and display the buffer.
when `inhibit-wconf-store', don't store the window configuration, as it
may have been stored before."
    (unless inhibit-wconf-store
      (org-capture-put :return-to-wconf (current-window-configuration)))
    ;; (delete-other-windows)
    ;; (org-switch-to-buffer-other-window
    ;;  (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
    (select-window (split-window-below -10))
    (switch-to-buffer
     (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
    (widen)
    (org-show-all)
    (goto-char (org-capture-get :pos))
    (setq-local outline-level 'org-outline-level)
    (pcase (org-capture-get :type)
      ((or `nil `entry) (org-capture-place-entry))
      (`table-line (org-capture-place-table-line))
      (`plain (org-capture-place-plain-text))
      (`item (org-capture-place-item))
      (`checkitem (org-capture-place-item)))
    (setq-local org-capture-current-plist org-capture-plist)
    (org-capture-mode 1)))

(add-hook 'org-agenda-after-show-hook 'org-narrow-to-subtree)

(defun my/org-agenda-goto (buffer args)
  "Open a headline in a window below the current window, reusing an existing window if possible."

  (setq-local mode-line-format nil)

  (let ((display-buffer-overriding-action nil) ;; Prevent recursion
        (target-window (or (window-in-direction 'below (selected-window))
                           (and (not (one-window-p)) (next-window))
                           (split-window-below -15))))  ;; Only split if no other window is available
    (select-window target-window)
    (switch-to-buffer buffer)

    ;; Set custom header line
    (setq-local header-line-format
                '((:eval
                   (let ((nano-modeline-prefix 'none)
                         (nano-modeline-prefix-padding 0)
                         (outline-path (org-with-point-at (org-get-at-bol 'org-marker)
                                         (org-display-outline-path nil nil " » " t))))
                     (nano-modeline-render
                      ""
                      (file-name-nondirectory
                       (buffer-file-name (buffer-base-buffer)))
                      (format "/ %s" (substring-no-properties outline-path))
                      "")))))
    (selected-window)))

;; Install the new function as an advice around org-agenda-goto and apply a narrow to subtree buffer
(define-advice org-agenda-goto (:around (orig-fn &rest args) "my/org-agenda-goto")
  (let ((display-buffer-overriding-action '(my/org-agenda-goto)))  ;; Prevent recursion
    (apply orig-fn args)
    (org-narrow-to-subtree)))

;; Disable org-agenda-show-outline-path since this is now in the header line
(setq org-agenda-show-outline-path nil)

(my/report-time "Agenda")


(require 'epg-config)

(setq epg-gpg-program (or (executable-find "gpg") "gpg")      ; What gpg program to use
      auth-source-debug nil         ; debug auth-source
      epg-user-id "bbl"           ; GnuPG ID of your default identity
      mml2015-use 'epg            ; The package used for PGP/MIME.
      mml-secure-openpgp-encrypt-to-self t   ; Add our own key ID to recipient list
      mml-secure-openpgp-sign-with-sender t) ; Use message sender to find a key to sign with.

;; GnuPG 2.1 or later has an option to control the behavior of
;; Pinentry invocation.  The value should be the symbol ‘error’,
;; ‘ask’, ‘cancel’, or ‘loopback’.
;; Default 'nil' will use external/system program to enter pin entry
;; (setq epg-pinentry-mode 'loopback)

(use-package calc
  :bind ("C-c l c" . calc))

(use-package auctex
  :defer t
  :hook (LaTeX-mode . flyspell-mode)
  :hook (LaTeX-mode . xenops-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil))

;; RefTeX for managing references
(use-package reftex
  :defer t
  :hook (LaTeX-mode . reftex-mode)
  :custom
  (reftex-plug-into-AUCTeX t)
  )

;; (add-hook 'org-mode-hook #'turn-on-org-cdlatex) ; enable org-cdlatex-mode
(use-package cdlatex
  :defer t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (latex-mode . turn-on-cdlatex))
  )

(use-package xenops
  :defer t
  :hook (latex-mode . xenops-mode)
  :custom
  ;; Automatically show raw LaTeX when cursor enters a math block
  (xenops-reveal-on-entry t)
  ;; Keep math/diagram rendering crisp
  (xenops-math-image-scale-factor 1.2))

(defun my/repl-send-line-or-region (repl &optional step)
  "Send current line or region to REPL buffer."
  (let ((proc (get-buffer-process repl))
        pbuf min max command)
    (unless proc
      (error "No process found for buffer %s" repl))
    (setq pbuf (process-buffer proc))  ; Fixed typo: pbuff -> pbuf
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (line-beginning-position)  ; More reliable than point-at-bol
            max (line-end-position)))      ; More reliable than point-at-eol
    (setq command (buffer-substring min max))
    (with-current-buffer pbuf
      (goto-char (process-mark proc))
      (insert command "\n")  ; Insert newline separately for clarity
      (set-marker (process-mark proc) (point))
      (setq comint-scroll-to-bottom-on-output t))
    (process-send-string proc (concat command "\n"))
    (display-buffer pbuf)
    (when step
      (goto-char max)
      (forward-line 1))  ; Use forward-line instead of next-line
    ;; Deactivate region
    (when (use-region-p)
      (deactivate-mark))))

(use-package ghostel
  :ensure nil
  :commands (my/toggle-ghostel ghostel ghostel-project)
  :bind (("C-c t t" . my/toggle-ghostel)
         ("C-c t o" . ghostel-other)
         ("C-c t e" . ghostel-emacs-mode)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . my/ghostel-send-C-k-and-kill)
         ;; ;; I'm used to go up/down the shell history with M-n/p from eshell
         ;; ;; Simulate this behavior in ghostel by sending C-p and C-n
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (setq ghostel-kill-buffer-on-exit t)
  ;; set term name to match the bashrc on the remote server
  ;; (setq ghostel-term "screen-256color")
  ;; (setq ghostel-shell "/bin/bash")
  ;; (set-face-attribute 'ghostel-default nil :background "#fffff0")

  (defun my/toggle-ghostel ()
    (interactive)
    (if (derived-mode-p 'ghostel-mode)
        (delete-window)
      (ghostel-project)))

  (defun my/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'ghostel-keymap-exceptions "M-o")
  (define-key ghostel-semi-char-mode-map (kbd "M-o") #'ace-window)
  (define-key ghostel-char-mode-map (kbd "M-o") #'ace-window)

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

(use-package ghostel-eshell
  :hook (eshell-load . ghostel-eshell-visual-command-mode))

(use-package ghostel-compile
  :hook (after-init . ghostel-compile-global-mode))

(use-package ghostel-comint
  :hook (after-init . ghostel-comint-global-mode))

(require 'xterm-color)

(use-package eshell
  :defer t
  :hook (eshell-mode . my/eshell-setup)
  :hook (eshell-load . ghostel-eshell-visual-command-mode)
  :hook (eshell-post-command . ha-eshell-store-last-output)

  :bind
  (("M-e" . eshell))

  :custom
  ;; (eshell-input-filter 'gopar/eshell-input-filter)
  (eshell-scroll-to-bottom-on-input 'all) ;; This jumps back to the prompt:
  (eshell-history-size 10240)
  (eshell-last-dir-unique t)
  (eshell-last-dir-ring-size 32)
  (eshell-error-if-no-glob t)
  (eshell-hist-ignoredups 'erase)
  (eshell-cd-on-directory t)
  (eshell-save-history-on-exit t)
  (eshell-kill-on-exit t);; Since eshell starts fast, let's dismiss it on exit
  (eshell-destroy-buffer-when-process-dies t)
  ;; Can you remember the parameter differences between the
  ;; executables `chmod' and `find' and their Emacs counterpart?
  ;; Me neither, so this makes it act a bit more shell-like:

  :config

  (setq eshell-visual-commands '())
  (setq eshell-modules-list (append eshell-modules-list '(eshell-elecslash eshell-rebind)))
  (setq eshell-prompt-function (lambda () "λ ")
        eshell-prompt-regexp (rx line-start (or "λ" "#") (1+ space)))

  ;; give me more aliases! https://www.emacswiki.org/emacs/EshellAlias
  (setq my/eshell-aliases
      '((d  . dired)
        (c  . (lambda () (eshell/cd "..")))
        (eshell/le . eshell/less)
        (eshell/vi . eshell/e)
            (Eshell/clear . eshell/clear-scrollback)))

  (mapc (lambda (alias)
              (defalias (car alias) (cdr alias)))
        my/eshell-aliases)

  :init

  (defun gopar/eshell-input-filter (input)
    "Do not save on the following:
       - empty lines
       - commands that start with a space, `ls`/`l`/`lsd`"
    (and
     (eshell-input-filter-default input)
     (eshell-input-filter-initial-space input)
     (not (string-prefix-p "c" input))
     (not (string-prefix-p "ls" input))
     (not (string-prefix-p "lsd" input))
     (not (string-prefix-p "l" input))))

  (defun eshell/cat-with-syntax-highlighting (filename)
    "Like cat(1) but with syntax highlighting.
Stole from aweshell"
    (let ((existing-buffer (get-file-buffer filename))
          (buffer (find-file-noselect filename)))
      (eshell-print
       (with-current-buffer buffer
         (if (fboundp 'font-lock-ensure)
             (font-lock-ensure)
           (with-no-warnings
             (font-lock-fontify-buffer)))
         (let ((contents (buffer-string)))
           (remove-text-properties 0 (length contents) '(read-only nil) contents)
           contents)))
      (unless existing-buffer
        (kill-buffer buffer))
      nil))
  (advice-add 'eshell/cat :override #'eshell/cat-with-syntax-highlighting)

  (defun eshell/ch (&rest images)
    "Concatenate IMAGES horizontally using ImageMagick's convert +append."
    (let ((output (car (last images)))
          (inputs (butlast images)))
      (unless (and output inputs)
        (error "Usage: ch <image1> <image2> ... <output-image>"))
      (let ((command (concat "convert +append "
                             (mapconcat 'identity inputs " ")
                             " "
                             output)))
        (eshell-command-result command))))


  (defun eshell/cv (&rest images)
    "Concatenate IMAGES vertically using ImageMagick's convert -append."
    (let ((output (car (last images)))
          (inputs (butlast images)))
      (unless (and output inputs)
        (error "Usage: cv <image1> <image2> ... <output-image>"))
      (let ((command (concat "convert -append "
                             (mapconcat 'identity inputs " ")
                             " "
                             output)))
        (eshell-command-result command))))

  (defun eshell/l (&rest args)
    "List files with `ls -al` using ARGS."
    (apply 'eshell/ls "-alrth" args))

  (defun eshell/e (&rest files)
    "Essentially an alias to the `find-file' function."
    (eshell-fn-on-files 'find-file 'find-file-other-window files))

  (defun eshell/ee (&rest files)
    "Edit one or more files in another window."
    (eshell-fn-on-files 'find-file-other-window 'find-file-other-window files))

  (defun eshell/less (&rest files)
    "Essentially an alias to the `view-file' function."
    (eshell-fn-on-files 'view-file 'view-file-other-window files))

  (defun eshell-fn-on-files (fun1 fun2 args)
    "Call FUN1 on the first element in list, ARGS.
Call FUN2 on all the rest of the elements in ARGS."
    (unless (null args)
      (let ((filenames (flatten-list args)))
        (funcall fun1 (car filenames))
        (when (cdr filenames)
          (mapcar fun2 (cdr filenames))))
      ;; Return an empty string, as the return value from `fun1'
      ;; probably isn't helpful to display in the `eshell' window.
      ""))

  (defun eshell/set (&rest args)
    "Creates a buffer local variable.
The first parameters of ARGS is the name of the variable.
The other parameters are the values. If not given, the
variable is deleted."
    (let* ((var (car args))
           (var-sym (make-symbol var))
           ;; Convert value to a string
           (val (pcase (seq-length (cdr args))
                  (0 nil)
                  (1 (format "%s" (cadr args)))
                  (_ (thread-last (cdr args)
                                  (seq-map 'eshell-stringify)
                                  (s-join " "))))))
      (if val
          (progn
            (set (make-local-variable var-sym) val)
            (setenv var val))

        ;; If we don't get both a variable and a value, let's try to
        ;; delete the variable:
        (makunbound var-sym)
        (setenv var))))

  (defun eshell/newbase (file newbase)
    "set f file.org
     echo- {newbase $f txt} # rename org as txt"
    (unless (string-match (rx bos ".") newbase)
      (setq newbase (concat "." newbase)))
    (concat (file-name-base file) newbase))

  (defun my/eshell-setup ()
    (set (make-local-variable 'debug-on-error) nil)
    (setq mode-line-format nil)
    (setq-local corfu-auto nil)
    (setq-local completion-styles '(basic))
    (corfu-mode)
    (require 'pcmpl-args) ; completion for linux commands
    (nano-modeline nano-modeline-format-terminal)
    )

  (defun ha-eshell-quit-or-delete-char (arg)
    "The `C-d' sequence closes window or deletes a character."
    (interactive "p")
    (if (and (eolp) (looking-back eshell-prompt-regexp))
        (progn
          (eshell-life-is-too-much) ; Why not? (eshell/exit)
          (ignore-errors
            (delete-window)))
      (delete-forward-char arg)))

  (defun eshell-insert-history ()
    "Displays the eshell history to select and insert back into your eshell."
    (interactive)
    (insert (completing-read "Eshell history: "
                             (delete-dups
                              (ring-elements eshell-history-ring)))))

  (defvar ha-eshell-output (make-ring 10)
    "A ring (looped list) storing history of eshell command output.")

  (defun ha-eshell-store-file-output (results)
    "Writes the string, RESULTS, to a temporary file and returns that file name."
    (let ((filename (make-temp-file "ha-eshell-")))
      (with-temp-file filename
        (insert results))
      filename))

  (defun ha-eshell-store-last-output ()
    "Store the output from the last eshell command.
Called after every command by connecting to the `eshell-post-command-hook'."
    (let ((output
           (buffer-substring-no-properties eshell-last-input-end eshell-last-output-start)))
      (ring-insert ha-eshell-output output)))

  (defun eshell/output (&rest args)
    "Return an eshell command output from its history.
The first argument is the index into the historical past, where
`0' is the most recent, `1' is the next oldest, etc.
The second argument represents the returned output:
 * `text' :: as a string
 * `list' :: as a list of elements separated by whitespace
 * `file' :: as a filename that contains the output
If the first argument is not a number, it assumes the format
to be `:text'. "
    (require 's)
    (let (frmt element)
      (cond
       ((> (length args) 1)  (setq frmt (cadr args)
                                   element (car args)))
       ((= (length args) 0)  (setq frmt "text"
                                   element 0))
       ((numberp (car args)) (setq frmt "text"
                                   element (car args)))
       ((= (length args) 1)  (setq frmt (car args)
                                   element 0)))

      (if-let* ((results (ring-ref ha-eshell-output (or element 0))))
          (cl-case (string-to-char frmt)
            (?l     (split-string results))
            (?f     (ha-eshell-store-file-output results))
            (otherwise (s-trim results)))
        "")))

  )

(use-package capf-autosuggest
  :defer t
  :hook ((eshell-mode . capf-autosuggest-mode)
         (comint-mode . capf-autosuggest-mode))
  :custom
  (capf-autosuggest-dwim-next-line nil))

(defun my/shell-setup ()
  "Setup custom modeline and auto-cleanup for shell mode."
  ;; Custom modeline
  (nano-modeline nano-modeline-format-terminal)
  (setq-local corfu-auto nil)
  (setq-local completion-styles '(basic)) ;; disable `orderless'
  (corfu-mode) ;; enable

  (require 'pcmpl-args) ; completion for linux commands

  ;; Auto-kill buffer when shell process exits
  (when-let* ((proc (get-buffer-process (current-buffer))))
    (set-process-sentinel proc
                          (lambda (process _event)
                            (when (memq (process-status process) '(exit signal))
                              (when-let* ((buf (process-buffer process)))
                                (when (buffer-live-p buf)
                                  (kill-buffer buf))))))))

(with-eval-after-load 'shell
  (native-complete-setup-bash)
  (add-hook 'shell-mode-hook 'my/shell-setup)
  )

(use-package comint
  :defer t
  :custom
  (comint-input-ring-size 1000)
  (comint-scroll-to-bottom-on-input t)
  (comint-process-echoes t)
  (comint-prompt-read-only t)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
  (add-hook 'comint-mode-hook (lambda () (setq-local corfu-auto nil)))
  )

(setq my/section-start-time (current-time))

(use-package sh-script
  :defer t
  :init
  (defun my/get-or-create-project-shell ()
    "Get or create a shell buffer for current project."
    (let* ((default-directory (project-root (project-current t)))
           (repl-name (project-prefixed-buffer-name "shell")))
      (unless (get-buffer repl-name) (shell repl-name))
      repl-name))

  (defun my/sh-send-line-or-region-and-step ()
    (interactive)
    (let ((repl-name (my/get-or-create-project-shell)))
      (my/repl-send-line-or-region repl-name t)
      )
    )

  (defun my/sh-send-paragraph-and-step ()
    (interactive)
    (let ((repl-name (my/get-or-create-project-shell)))
      (mark-paragraph 1)
      (my/repl-send-line-or-region repl-name t)
      )
    )
  :bind
  ( :map sh-base-mode-map
    ("<C-return>" . my/sh-send-line-or-region-and-step)
    ("C-c C-c" . my/sh-send-paragraph-and-step)
    )
  :custom
  (sh-basic-offset 2)
  (sh-indent-comment t)
  )

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package js
  :mode ("\\.json\\'" . js-json-mode))

(use-package python
  :bind
  ( :map python-mode-map
    ("<C-return>" . my/python-send-dwim)
    ("C-c C-p" . my/run-python-at-project-root)
    :map python-ts-mode-map
    ("<C-return>" . my/python-send-dwim)
    ("C-c C-p" . my/run-python-at-project-root)
    :map inferior-python-mode-map
    ("<up>" . cape-history)
    )

  :hook
  (python-base-mode . my/python-init)

  :hook
  (inferior-python-mode . (lambda ()
                            (buffer-box-on)
                            (setq-local completion-at-point-functions '(cape-file
                                                                        cape-dabbrev
                                                                        python-completion-at-point))))
  :init

  (defun my/python-init ()
    (setq-local completion-at-point-functions
                '(tempel-expand
                  cape-file
                  cape-dabbrev
                  python-completion-at-point))
    (my/ruff-format-on-save-mode +1)
    ;; (my/ruff-sort-on-save-mode +1)
    )

  (defun my/run-python-at-project-root ()
    "Run Python REPL at project root and pop to it."
    (interactive)
    (let ((default-directory
           (or (when-let* ((project (project-current)))
                 (project-root project))
               default-directory)))
      (run-python (python-shell-calculate-command) nil nil)
      (pop-to-buffer (process-buffer (python-shell-get-process)))))

  (defun my/python-send-dwim ()
    "Send the appropriate Python code to REPL based on context."
    (interactive)
    (cond
     ;; If region is active, send region
     ((use-region-p)
      (python-shell-send-region (region-beginning) (region-end)))
     ;; If in a function/class, send the whole definition
     ((python-info-current-defun)
      (python-shell-send-defun nil))
     ;; Otherwise send current line
     (t
      (python-shell-send-statement))))

  (setq python-interpreter "python3") ; for non-interactive
  (setq python-shell-interpreter "python3")
  (setq python-shell-completion-native-enable nil) ; disable readline completion
  ;; Let Emacs guess Python indent silently
  (setq python-indent-guess-indent-offset t
        python-indent-guess-indent-offset-verbose nil)
  (setq python-flymake-command "ruff")

  )

(use-package flymake-ruff
  :hook (python-mode . flymake-ruff-load)
  :hook (python-ts-mode . flymake-ruff-load)
  )

(use-package python-pytest
 :custom
 (python-pytest-confirm t))

(use-package ess
  :defer t
  :mode (("\\.R\\'" . ess-r-mode)
         ("\\.r\\'" . ess-r-mode))
  :init

  (setq ess-eval-visibly 'nowait
        inferior-ess-r-program-name "~/.local/bin/R"
        ess-use-company nil ;; use corfu!
        ess-history-file nil
        ess-history-directory nil
        ess-style 'RStudio)

  (defun my/read-into-string (buffer)
    (with-current-buffer buffer
      (buffer-string)))

  (defun my/ess-R-object-popup (r-func)
    "R-FUNC: The R function to use on the object.
Run R-FUNC for object at point, and display results in a help window."
    (let ((objname (current-word))
          (tmpbuf (get-buffer-create "**ess-R-object-popup**")))
      (if objname
          (progn
            (ess-command (concat "class(" objname ")\n") tmpbuf)
            (let ((bs (my/read-into-string tmpbuf)))
              (if (not(string-match "\(object .* not found\)\|unexpected" bs))
                  (progn
                    (ess-command (concat r-func "(" objname ")\n") tmpbuf)
                    (let ((bs (my/read-into-string tmpbuf)))
                      (with-help-window "*ESS Object*" (princ bs))))))))
      (kill-buffer tmpbuf)))

  (defun my/ess-R-object-popup-fed ()
    (interactive)
    (my/ess-R-object-popup "fed"))

  (defun my/ess-R-object-popup-str ()
    (interactive)
    (my/ess-R-object-popup "str"))

  (defun my/ess-R-object-popup-interactive (r-func)
    (interactive "sR function to execute: ") ; don't use R which is invalid
    (my/ess-R-object-popup r-func))

  :config

  (require 'ess-r-mode)
  (require 'ess-r-package) ;; quick r package setup

  (setq ess-smart-equals-extra-ops '(brace paren percent))
  (with-eval-after-load 'ess-r-mode
    (require 'ess-smart-equals)
    (ess-smart-equals-activate))

  ;; be smart about parens pairs
  ;; (add-hook 'ess-r-mode-hook #'smartparens-mode)
  ;; (add-hook 'inferior-ess-r-mode-hook #'smartparens-mode)

  ;; completion
  (add-hook 'ess-r-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list #'cape-file        ;; File completion first
                                #'tempel-expand
                                #'ess-r-object-completion
                                #'cape-history
                                #'cape-dabbrev)))) ;; Add dabbrev as fallback

  (defun my-ess-quit-or-delete-char (arg)
    "Delete character at point or quit R when at empty prompt."
    (interactive "p")
    ;; ESS R prompts are typically "> " or "+ "
    (let ((ess-prompt-regexp "^[>+] "))
      (if (and (eolp) (looking-back ess-prompt-regexp))
          (progn
            (ess-quit)
            ;; (ess-eval-linewise "q()" nil nil nil 'wait)
            )
        (delete-forward-char arg))))

  (defun my/inferior-ess-setup ()
    "Set up C-d to delete char or quit in ESS R process."
    (local-set-key (kbd "C-d") 'my-ess-quit-or-delete-char)
    (setq-local corfu-auto nil)
    (buffer-box-on)
    )

  (add-hook 'inferior-ess-mode-hook 'my/inferior-ess-setup)

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
          (ess-fl-keyword:= . nil)))
  :bind
  (:map ess-r-mode-map
        ("C-c C-k" . ess-help)
        ("C-c C-f" . my/ess-R-object-popup-fed)
        ("C-c C-s" . my/ess-R-object-popup-str)
        ("C-c C-r" . my/ess-R-object-popup-interactive)
        )
  )

(use-package julia-mode
  :mode "\\.jl$")

(use-package cc-mode
  :defer t
  :mode (("\\.h\\(h?\\|xx\\|pp\\)\\'" . c++-mode)
         ("\\.m\\'" . c-mode)
         ("\\.mm\\'" . c++-mode))
  :hook (c-mode-common . my-c-mode-common-hook)
  :bind (:map c++-mode-map
              ("<" . self-insert-command)
              (">" . self-insert-command))
  :bind (:map c-mode-base-map
              ("#" . self-insert-command)
              ("{" . self-insert-command)
              ("}" . self-insert-command)
              ("/" . self-insert-command)
              ("*" . self-insert-command)
              (";" . self-insert-command)
              ("," . self-insert-command)
              (":" . self-insert-command)
              ("(" . self-insert-command)
              (")" . self-insert-command)
              ("<return>" . c-context-line-break)
              ("M-q" . c-fill-paragraph)
              )
  :custom
  (c-default-style '((java-mode . "gnu") (awk-mode . "awk") (other . "gnu")))
  :preface
  (defun my-c-mode-common-hook ()
    (set (make-local-variable 'parens-require-spaces) nil)
    (c-toggle-hungry-state 1)
    (setq c-backspace-function #'delete-backward-char)
    (setq c-auto-newline nil)
    (setq cc-search-directories '("." "/usr/include" "/usr/local/include/*" "../*/include" "$WXWIN/include"))
    ;; make a #define be left-aligned
    (setq c-electric-pound-behavior (quote (alignleft)))
  )
  :config
  (add-to-list
   'c-style-alist
   '("ledger"
     (indent-tabs-mode . nil)
     (c-basic-offset . 2)
     (c-comment-only-line-offset . (0 . 0))
     (c-hanging-braces-alist
      . ((substatement-open before after)
         (arglist-cont-nonempty)))
     (c-offsets-alist
      . ((statement-block-intro . +)
         (knr-argdecl-intro . 5)
         (substatement-open . 0)
         (substatement-label . 0)
         (label . 0)
         (case-label . 0)
         (statement-case-open . 0)
         (statement-cont . +)
         (arglist-intro . +)
         (arglist-close . +)
         (inline-open . 0)
         (brace-list-open . 0)
         (topmost-intro-cont
          . (first c-lineup-topmost-intro-cont
                   c-lineup-gnu-DEFUN-intro-cont))))
     (c-special-indent-hook . c-gnu-impose-minimum)
     (c-block-comment-prefix . ""))))

(use-package cuda-mode
  :ensure nil
  :defer t
  )

(use-package rust-mode
  :mode (("\\.rs$" . rust-mode))
  :preface
  (defun sp1ff/rust/mode-hook ()
    "My rust-mode hook"
    (column-number-mode)
    (hs-minor-mode)
    ;; Rust style guide
    ;; <https://github.com/rust-lang-nursery/fmt-rfcs/blob/master/guide/guide.md>
    (setq indent-tabs-mode nil
          tab-width 4
          c-basic-offset 4
          fill-column 100))
  :hook (rust-mode . sp1ff/rust/mode-hook)
  :config
  (let ((dot-cargo-bin (expand-file-name "~/.cargo/bin/")))
    (setq rust-rustfmt-bin (concat dot-cargo-bin "rustfmt")
          rust-cargo-bin (concat dot-cargo-bin "cargo")
          rust-format-on-save t))
  )

(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  )

(use-package eglot
  :preface
  (defun my/mp-eglot-eldoc ()
    (setq eldoc-documentation-strategy
          'eldoc-documentation-compose-eagerly)
    ;; (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
    ;; Show flymake diagnostics first.
    (setq eldoc-documentation-functions
                      (cons #'flymake-eldoc-function
                            (remove #'flymake-eldoc-function
                                    eldoc-documentation-functions)))
    )
  :hook ((eglot-managed-mode . my/mp-eglot-eldoc))
  :bind (("C-c l e" . eglot)
         :map eglot-mode-map
              ("C-x C-t" . eglot-format) ;; override transpose-line
              ("C-x C-w" . eglot-rename) ;; override write-file
              ("C-c C-." . eglot-code-actions)
              )
  :config
  (setq read-process-output-max (* 1024 1024)) ; 1 Mb
  (setq completion-category-defaults nil) ;; disable completion-styles

  ;; (push :inlayHintProvider eglot-ignored-server-capabilities) ;; permenat disable eglot-inlay-hints-mode
  (push :documentHighlightProvider eglot-ignored-server-capabilities)


  ;; rust
  ;; (add-to-list 'eglot-server-programs
  ;;              '((rust-ts-mode rust-mode) .
  ;;                ("rust-analyzer" :initializationOptions (:check (:command "clippy")))))

  ;; python
  ;; (add-to-list 'eglot-server-programs '((python-mode)
  ;;                                       . ("pylsp")))
  ;; ruff :linting
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["ruff"]
                                                   :plugins (
                                                             :ruff (:enabled t :lineLength 88)
                                                             :pycodestyle (:enabled :json-false)
                                                             :mccabe (:enabled :json-false)
                                                             :pyflakes (:enabled :json-false)
                                                             :flake8 (:enabled :json-false :maxLineLength 88)
                                                             :autopep8 (:enabled :json-false)
                                                             :yapf (:enabled :json-false)
                                                             :pydocstyle (:enabled :json-false :convention "numpy")
                                                             )))))

  )

(use-package eglot-orderless
  :no-require t
  :after (eglot orderless)
  :config
  ;; Option 1: Specify explicitly to use Orderless for Eglot
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless))))
  )
(my/report-time "languages")

(use-package dictionary
  :defer t
  :init
  (add-to-list 'display-buffer-alist
               '("^\\*.*[Dd]ictionary\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.35)
                 ))
  :custom
  (dictionary-server "dict.org"))

;; https://github.com/abo-abo/define-word/blob/31a8c67405afa99d0e25e7c86a4ee7ef84a808fe/define-word.el#L161
(defun my/dict-lookup-word ()
  (interactive)
  (let ((word
         (cond
          ((eq major-mode 'pdf-view-mode)
           (car (pdf-view-active-region-text)))
          ((use-region-p)
           (buffer-substring-no-properties
            (region-beginning)
            (region-end)))
          (t
           (substring-no-properties
            (thing-at-point 'word))))))
    (start-process "goldendict" nil "goldendict" word)
    )
  )

(if (eq system-type 'darwin)
  (bind-key "C-c l d"   #'osx-dictionary-search-word-at-point)
  (bind-key "C-c l d"   #'my/dict-lookup-word)
)

(use-package devdocs
  :defer t
  :bind
  (("C-h d" . gopar/devdocs-lookup)
   ("C-h C-d" . gopar/devdocs-lookup))
  :init
  (add-to-list 'display-buffer-alist
               '("\\*devdocs\\*"
                 display-buffer-in-side-window
                 (side . right)
                 (slot . 3)
                 (window-width . 0.4)
                 (window-parameters . ((no-delete-other-windows . t)))
                 (dedicated . t)))

  (defun gopar/devdocs-lookup (&optional ask-docs)
    "Light wrapper around `devdocs-lookup` which pre-populates the function input with thing at point"
    (interactive "P")
    (let ((query (thing-at-point 'symbol t)))
      (devdocs-lookup ask-docs query)))


  :hook (((python-mode python-ts-mode) . (lambda ()
                                           (setq-local devdocs-current-docs
                                                       '("python~3.10"))))
         ((c++-mode c++-ts-mode) . (lambda ()
                                     (setq-local devdocs-current-docs
                                                 '("cpp"))))
         ((rust-mode rust-ts-mode) . (lambda ()
                                       (setq-local devdocs-current-docs
                                                   '("rust"))))
         (ess-r-mode . (lambda ()
                         (setq-local devdocs-current-docs
                                     '("r"))))
         )
  )



(defun my/pdf-view-open-file ()
  (interactive)
  (shell-command (format "open \"%s\"" (buffer-file-name))))

(use-package pdf-tools
  :ensure nil
  :magic ("%PDF" . pdf-view-mode)
  :bind (:map
         pdf-view-mode-map
         ("O" . my/pdf-view-open-file))
  :config
  ;; Install the epdfinfo server if not already built
  (pdf-tools-install :no-query)

  ;; Use pdf-loader-install instead for faster startup:
  ;; (pdf-loader-install)

  ;; Disable incompatible modes in pdf-view buffers
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (display-line-numbers-mode -1)))

  ;; Optional: enable continuous scroll mode by default
  ;; (add-hook 'pdf-view-mode-hook #'pdf-view-roll-minor-mode)

  ;; Optional: fix rendering on non-HiDPI screens
  ;; (setq pdf-view-use-scaling nil)
  )

(use-package denote
  :commands (denote denote-open-or-create consult-notes)
  :bind
  ( :map global-map
    ("C-c n n" . denote)
    ("C-c n N" . denote-open-or-create)
    ("C-c n o" . consult-notes)
    ("C-c n l" . denote-link)            ; insert link
    ("C-c n i" . denote-org-link-to-heading) ; insert link to org headings
    ("C-c n I" . denote-add-links)       ; insert links to all files matching regrex
    ("C-c n f" . denote-find-link)       ; find link
    ("C-c n b" . denote-backlinks)       ; show backlinks
    ("C-c n B" . denote-find-backlink)   ; find backlinks
    ("C-c n O" . denote-org-dblock-insert-backlinks) ; org backlink block
    ("C-c n d" . denote-date)  ; new specifying date and time
    ("C-c n z" . denote-signature)
    ("C-c n s" . denote-subdirectory)
    ("C-c n t" . denote-template)
    ("C-c n R" . denote-rename-file)

    :map dired-mode-map
    ("C-c C-d C-i" . denote-link-dired-marked-notes)
    ("C-c C-d C-r" . denote-dired-rename-marked-files)
    ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter)
    ;; Also check the commands `denote-link-after-creating',
    ;; `denote-link-or-create'.  You may want to bind them to keys as well.
    )

  :hook
  (dired-mode . denote-dired-mode)
  :custom
  (denote-file-type 'org)
  (denote-directory (expand-file-name "~/Dropbox/Denotes/"))
  (denote-known-keywords '("emacs" "academia" "algorithm"))
  (denote-prompts '(title keywords))
  (denote-infer-keywords t)
  (denote-sort-keywords nil)
  (denote-excluded-directories-regexp nil)
  (denote-excluded-keywords-regexp nil)
  ;; Pick dates, where relevant, with Org's advanced interface:
  (denote-date-prompt-use-org-read-date t)
  (denote-date-format nil) ; read doc string

  :config
  ;; Read this manual for how to specify `denote-templates'.  We do not
  ;; include an example here to avoid potential confusion.

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1)

  )







(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

(use-package consult-notes
  :commands (consult-notes
             consult-notes-search-in-all-notes)
  :config
  ;; (consult-notes-org-headings-mode)
  (when (locate-library "denote")
    (consult-notes-denote-mode))
  ;; search only for text files in denote dir
  (setq consult-notes-denote-files-function (lambda () (denote-directory-files nil t t)))
  ;; set extra dirs
  (setq consult-notes-file-dir-sources
      '(("Zll Books"  ?b "~/Dropbox/Zll/Datahub/002-Books/")))
  )





(use-package nov
  :bind (:map nov-mode-map
              ("M-." . dictionary-lookup-definition))
  :config
  (setq nov-text-width t)
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'variable-pitch-mode) ;; use variable-pitch font
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (defun my/nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "ETBembo"
                             :height 1.0))
  )

;; Keep your fallback setting
(setq browse-url-browser-function 'browse-url-default-browser
      browse-url-secondary-browser-function 'browse-url-generic ; use the program set by browse-url-generic-program as the secondary
      browse-url-generic-program "open")


(defun my/browse-url-secondary (&optional url)
  "Open URL (or URL at point) in the secondary browser."
  (interactive)
  (let ((url (or url
                 (thing-at-point 'url)
                 (and (derived-mode-p 'org-mode)
                      (org-element-property :raw-link (org-element-context)))
                 (read-string "URL: "))))
    (funcall browse-url-secondary-browser-function url)))

(use-package eww
  :defer t
  :bind (("C-c w" . eww))

  :preface
  (defun my-browse-url-mpv (url &rest _args)
    "Open URL in mpv."
    (start-process "mpv" nil "mpv" url))

  (defun my-browse-url-pdf (url &rest _args)
    "Fetch remote PDF and open in pdf-tools within Emacs."
    (let ((tmp (make-temp-file "emacs-pdf-" nil ".pdf")))
      (url-copy-file url tmp t)
      (find-file-other-window tmp)
      (pdf-view-mode)))

  (defun my/eww-download-image-at-point ()
    "Download image at point to `eww-download-directory'."
    (interactive)
    (let ((url (or (get-text-property (point) 'image-url)
                   (get-text-property (point) 'shr-url))))
      (if (not url)
          (message "No image at point")
        (let* ((parsed (url-generic-parse-url url))
               (name (file-name-nondirectory
                      (or (url-filename parsed) "")))
               (filename (if (string-empty-p name)
                             (format-time-string "eww-image-%Y%m%d-%H%M%S")
                           name))
               (dest (expand-file-name filename eww-download-directory)))
          (url-copy-file url dest t)
          (message "Saved: %s" dest)))))

  :config
  (require 'subr-x)

  (setq eww-search-prefix "https://duckduckgo.com/html/search?q=")

  (setq browse-url-browser-function
        '(("\\(youtube\\.com\\|youtu\\.be\\|vimeo\\.com\\|twitch\\.tv\\)" . my-browse-url-mpv)
          ("\\.mp4\\'" . my-browse-url-mpv)
          ("\\.pdf\\'" . my-browse-url-pdf)
          ("^gemini://" . elpher-browse-url-elpher)
          ("^gopher://" . elpher-browse-url-elpher)
          ("." . eww-browse-url)))

  (setq shr-use-fonts nil
        shr-use-colors nil
        shr-indentation 2
        shr-width 100
        shr-max-width 120
        shr-max-image-size '(800 . 600)
        shr-image-animate t
        eww-browse-url-new-window-is-tab nil
        eww-auto-rename-buffer 'title
        eww-download-directory (expand-file-name "~/Downloads/")
        eww-use-external-browser-for-content-type "\\`\\(video/\\|audio\\)")

  (define-key eww-mode-map (kbd "=") #'text-scale-increase)
  (define-key eww-mode-map (kbd "-") #'text-scale-decrease)
  (define-key eww-mode-map (kbd "a") #'other-window)
  (define-key eww-mode-map (kbd "f") #'eww-forward-url)
  (define-key eww-mode-map (kbd "r") #'eww-search-words)
  (define-key eww-mode-map (kbd "U") #'shr-copy-url)
  (define-key eww-mode-map (kbd "D") #'my/eww-download-image-at-point)

  (add-hook 'eww-mode-hook
            (lambda ()
              (face-remap-add-relative
               'header-line
               :height 0.9
               :box `(:line-width 1 :color ,(face-background 'default))))))





(defvar piper-binary-path "~/.local/bin/piper")
;; (defvar piper-model-path "~/.local/share/piper/models/en_GB-cori-high.onnx")
(defvar piper-model-path "~/.local/share/piper/models/en_US-ryan-high.onnx")

;; new piper can use ffplay directly
(defun my/tts-piper (&optional arg)
  "Send the text after point or the given TEXT to piper for tts.
If a region is active, send the marked text.
If a non-numeric prefix argument is provided, prompt for text input.
If a numeric prefix argument is provided, send that number of lines.
Otherwise send from point to end of buffer."
  (interactive "P")
  (let* ((text (cond
                ((region-active-p) (buffer-substring-no-properties (region-beginning) (region-end)))
                ((consp arg) (read-string "Enter text: "))
                (arg (buffer-substring-no-properties (point) (save-excursion (forward-line arg) (point))))
                (t (buffer-substring-no-properties (point) (point-max)))))
         (cleaned-text (replace-regexp-in-string "\\([a-z]\\)'\\([a-z]\\)" "\\1 \\2" text))
         (cmd (format "%s --model %s -- %s"
                      (expand-file-name piper-binary-path)
                      (expand-file-name piper-model-path)
                      (shell-quote-argument cleaned-text))))
    (with-current-buffer (get-buffer-create "*piper*")
      (goto-char (point-max))
      (insert (format "[%s] Running: %s\n\n"
                      (format-time-string "%Y-%m-%d %H:%M:%S")
                      cmd)))
    (make-process
     :name "piper"
     :buffer "*piper*"
     :command (list (expand-file-name piper-binary-path)
                    "--model" (expand-file-name piper-model-path)
                    "--" cleaned-text))))

(bind-key "C-x s" #'my/tts-piper)

(use-package elfeed
  :commands elfeed
  :bind (("C-c l r" . elfeed)
         :map elfeed-search-mode-map
         ("o" . timu-elfeed-search-other-window)
         :map elfeed-show-mode-map
         ("M-." . dictionary-lookup-definition)
         ("x" . timu-elfeed-show-visit-xwidget)
         )
  :config
  (add-hook 'elfeed-show-mode-hook 'variable-pitch-mode)
  (define-key elfeed-search-mode-map "d" (elfeed-tag-selection-as 'starred))
  (define-key elfeed-search-mode-map "l" (elfeed-tag-selection-as 'readlater))
  (define-key elfeed-search-mode-map "i" (elfeed-tag-selection-as 'important))

  :init
  (defun my/elfeed ()
    "Open Elfeed in a new frame."
    (interactive)
    (let ((frame (make-frame)))
      (select-frame frame)
      (elfeed)))

  (defun elfeed-tag-selection-as (mytag)
    "https://karthinks.com/software/lazy-elfeed/"
    "Returns a function that tags an elfeed entry or selection as MYTAG"
    (lambda ()
      "Toggle a tag on an Elfeed search selection"
      (interactive)
      (elfeed-search-toggle-all mytag)))

  (defun timu-elfeed-search-other-window ()
    "Browse `elfeed' entry in the other window.
Credit: https://protesilaos.com/dotemacs"
    (interactive)
    (let* ((entry (if (eq major-mode 'elfeed-show-mode)
                      elfeed-show-entry
                    (elfeed-search-selected :ignore-region)))
           (link (elfeed-entry-link entry))
           (win (selected-window)))
      (with-current-buffer (get-buffer "*elfeed-search*")
        (unless (one-window-p)              ; experimental
          (delete-other-windows win))
        (split-window-right)
        (other-window 1)
        (elfeed-search-show-entry entry))))

  (defun timu-elfeed-show-visit-xwidget (&optional generic)
    "Visit the current entry in Xwidget using `xwidget-webkit-browse-url'.
If there is a prefix argument, visit the current entry in the
GENERIC browser defined by `browse-url-generic-program'."

    (interactive "P")
    (let ((link (elfeed-entry-link elfeed-show-entry)))
      (when link
        (message "Sent to browser: %s" link)
        (if generic
            (browse-url link)
          (xwidget-webkit-browse-url link)))))
  )

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list (concat user-emacs-directory "elfeed.org") ))
  )


(use-package nano-elfeed
  :after elfeed
  :init
  (setq nano-elfeed-icon-path (concat straight-base-dir "straight/repos/nano-elfeed/icons"))
  :config
  (setq nano-elfeed-icons
        `(("RSS"             . ,(nano-elfeed-make-icon "default"))
          ("BioRxiv Bioinformatics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("BioRxiv Genetics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("BioRxiv Genomics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("Science"           . ,(nano-elfeed-make-icon "science"))
          ("Nature"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Genetics"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Methods"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Medicine"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Biotechnology"           . ,(nano-elfeed-make-icon "nature"))
          ("eLife"           . ,(nano-elfeed-make-icon "elife"))
          ("eLife Genetics Genomics"           . ,(nano-elfeed-make-icon "elife"))
          ("eLife Evolutionary Biology"           . ,(nano-elfeed-make-icon "elife"))
          ("Emacs"           . ,(nano-elfeed-make-icon "reddit"))
          ("Emacs org-mode"  . ,(nano-elfeed-make-icon "reddit"))
          ("Paris Review"    . ,(nano-elfeed-make-icon "parisreview"))
          ("McSweeney's"    . ,(nano-elfeed-make-icon "mcsweeneys"))
          ("Aeon"            . ,(nano-elfeed-make-icon "aeon"))
          ("Slashdot"        . ,(nano-elfeed-make-icon "slashdot"))
          ("Ars Technica"    . ,(nano-elfeed-make-icon "ars-technica"))
          ("Boing Boing"     . ,(nano-elfeed-make-icon "boing-boing"))
          ("Plos Comp.Bio"   . ,(nano-elfeed-make-icon "plos"))
          ("Quanta"          . ,(nano-elfeed-make-icon "quanta"))
          ))

  )


(defun my/jump-to-matching-paren ()
  "Jump to matching paren, like % in Vim."
  (interactive)
  (cond
   ((looking-at "\\s(")  ; on an opening paren
    (forward-list))
   ((looking-back "\\s)" 1)  ; just after a closing paren
    (backward-list))
   (t
    (sp-up-sexp))))  ; inside sexp: jump to closing paren

(bind-key "C-c o o" #'window-toggle-side-windows)
(bind-key "C-c o d" #'display-line-numbers-mode)
(bind-key "C-c o t" #'org-babel-tangle)
(bind-key "C-c l a" #'add-file-local-variable-prop-line)
(bind-key "C-x C-o" #'maximize-window) ; overwride delete-blank-lines

(define-key help-mode-map (kbd "Q") 'kill-buffer-and-window)

;; Package installation is declared in my/straight-custom-recipes above.

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.php\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.tsx?\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-closing t
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-quoting t
        web-mode-enable-current-element-highlight t))

(use-package webjump
  :bind ("C-x /" . webjump)
  :custom
  (webjump-sites
   '(("DuckDuckGo" . [simple-query "www.duckduckgo.com" "www.duckduckgo.com/?q=" ""])
     ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
     ("YouTube" . [simple-query "www.youtube.com/feed/subscriptions" "www.youtube.com/results?search_query=" ""])
     ("ChatGPT" . [simple-query "https://chatgpt.com" "https://chatgpt.com/?q=" ""])))
  :config
  (defun my/webjump-external (orig-fun &rest args)
    (let ((browse-url-browser-function #'browse-url-generic)
          (browse-url-handlers nil))
      (apply orig-fun args)))
  (advice-add 'webjump :around #'my/webjump-external))

(use-package gptel
  :demand t
  :bind
  (:map gptel-mode-map
        ("C-c C-n"  . my/gptel-next-prompt)
        ("C-c C-p"  . my/gptel-previous-prompt))
  :custom
  (gptel-default-mode 'org-mode)
  (gptel-log-level 'info)
  (gptel-include-reasoning 'ignore)
  (gptel-use-tools t)
  (gptel-track-media t)
  (gptel-use-context nil)
  (gptel-use-header-line t)
  (gptel-org-branching-context t)
  (gptel-prompt-prefix-alist
   '((markdown-mode . "## User: ")
     (org-mode . "* Prompt: ")
     (text-mode . "User: ")))
  (gptel-response-prefix-alist
   '((markdown-mode . "## Assistant\n")
     (org-mode . "** Response:")
     (text-mode . "Assistant: ")))

  :preface

  (defun my/gptel-remove-extra-whitespace (beg end)
    "Collapse excess blank lines within the response from BEG to END."
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        (goto-char (point-min))
        (while (re-search-forward "\n\n\n+" nil t)
          (replace-match "\n\n")))))

  (defun my/gptel-previous-prompt ()
    (interactive)
    (goto-char (line-beginning-position))
    (when (re-search-backward
           (regexp-quote (gptel-prompt-prefix-string)) nil t)
      (goto-char (line-end-position))))

  (defun my/gptel-next-prompt (&rest _ignore)
    (interactive)
    (goto-char (line-end-position))
    (when (re-search-forward
           (regexp-quote (gptel-prompt-prefix-string)) nil t)
      (goto-char (line-end-position))))

  (defun my/proofread-concise ()
    "Proofread and tighten the writing."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar and spelling, then cut unnecessary words for conciseness."))
      (call-interactively #'gptel-rewrite)))

  (defun my/proofread-dwim ()
    "Proofread region or paragraph — fix grammar and spelling."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar, spelling and punctuation. Preserve tone and meaning."))
      (call-interactively #'gptel-rewrite)))


  (defun my/proofread-formal ()
    "Proofread and raise the register to formal."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar and spelling, then rewrite in a formal professional tone."))
      (call-interactively #'gptel-rewrite)))

  :config

  ;; These are defvars
  (setq gptel-expert-commands t)

  (setq gptel-model 'gpt-5.6-sol
        gptel-backend (gptel-make-openai-oauth "OpenAI-sub"))


  (make-variable-buffer-local 'gptel-context)

  (add-hook 'gptel-post-response-functions #'my/gptel-remove-extra-whitespace)
  (add-hook 'gptel-post-response-functions #'my/gptel-next-prompt 10)


  )

(use-package codex-ide
  :ensure nil
  :custom
  (codex-ide-fast "on")
  )

(use-package transient
  :defer t
  :custom
  (transient-align-variable-pitch t)
  )

(use-package casual
  :defer t
  :custom
  (casual-lib-use-unicode t)
  :config
  (use-package casual-calc
    :after (calc)
    :bind (:map
           calc-mode-map
           ("C-M-l" . casual-calc-tmenu)
           :map
           calc-alg-map
           ("C-M-l" . casual-calc-tmenu))
    )

  (use-package casual-ibuffer
    :after (ibuffer)
    :bind (:map
           ibuffer-mode-map
           ("C-M-l" . casual-ibuffer-tmenu)
           ("F" . casual-ibuffer-filter-tmenu)
           ("s" . casual-ibuffer-sortby-tmenu)))
  )

(require 'envrc)
(add-hook 'after-init-hook 'envrc-global-mode)

(let ((init-time (float-time (time-subtract (current-time) my/init-start-time)))
      (total-time (string-to-number (emacs-init-time "%f"))))

  (message "---------------------------------------------------------------")
  (message "Initialization time:                 %.2fs (+ %.2f system time)"
           init-time (- total-time init-time)))
  (message "---------------------------------------------------------------")
