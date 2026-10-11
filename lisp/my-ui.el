;;; my-ui.el --- Theme, header line, windows and perspectives -*- lexical-binding: t; -*-

;;; Theme and fonts

(use-package nano-theme
  :ensure t
  :demand t
  :init
  (setq nano-fonts-use nil)
  :config
  (load-theme 'nano-light t)

  (defun my/nano-terminal-colors (&optional frame)
    "Apply NANO's explicit light colors to terminal FRAME.
Set the default face directly so the terminal's own dark background
cannot select the dark face palette."
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

  (dolist (setup '(my/nano-terminal-colors my/nano-fonts))
    (funcall setup)
    (add-hook 'after-make-frame-functions setup))

  (set-face-attribute 'minibuffer-prompt nil :foreground "pink" :weight 'bold))

;; Nicer glyphs for truncation and wrapping.
(set-display-table-slot standard-display-table 'truncation (make-glyph-code ?…))
(set-display-table-slot standard-display-table 'wrap (make-glyph-code ?↩))

;;; Header line (NANO) instead of the mode line

(defvar my/mode-line-format (default-value 'mode-line-format)
  "The standard mode line, restored by `my/toggle-mode-line'.")
(setq-default mode-line-format nil)

(defun my/toggle-mode-line ()
  "Toggle the standard Emacs mode line in the current buffer."
  (interactive)
  (setq mode-line-format (unless mode-line-format my/mode-line-format))
  (force-mode-line-update))

(use-package nano-modeline
  :vc (:url "https://github.com/rougier/nano-modeline" :branch "rewrite" :rev :newest)
  :commands nano-modeline
  :init
  (defun my/nano-modeline (fmt)
    "Install the NANO header line described by the variable FMT."
    (require 'nano-modeline)
    (nano-modeline (symbol-value fmt)))

  (pcase-dolist (`(,fmt . ,hooks)
                 '((nano-modeline-format-default prog-mode-hook text-mode-hook)
                   (nano-modeline-format-org-capture org-capture-mode-hook)
                   (nano-modeline-format-gptel gptel-mode-hook)
                   (nano-modeline-format-elfeed-search elfeed-search-mode-hook)
                   (nano-modeline-format-elfeed-entry elfeed-show-mode-hook)
                   (nano-modeline-format-terminal term-mode-hook ghostel-mode-hook
                                                  eshell-mode-hook shell-mode-hook)
                   (my/nano-modeline-format-pdf-view pdf-view-mode-hook)))
    (dolist (hook hooks)
      (add-hook hook (lambda () (my/nano-modeline fmt)))))
  :custom
  (nano-modeline-padding '(0.20 . 0.25))
  :config
  (defun my/nano-modeline-element-pdf-label ()
    (propertize "PDF:" 'face 'nano-modeline-face-primary))

  (defun my/nano-modeline-element-pdf-page ()
    "Return current PDF page and total number of pages."
    (when (derived-mode-p 'pdf-view-mode)
      (propertize (format " %d/%s" (image-mode-window-get 'page)
                          (or (ignore-errors (pdf-cache-number-of-pages)) "?"))
                  'face 'nano-modeline-face-secondary)))

  (defvar my/nano-modeline-format-pdf-view
    (cons '(my/nano-modeline-element-pdf-label
            nano-modeline-element-space
            nano-modeline-element-buffer-name
            nano-modeline-element-space
            nano-modeline-element-buffer-mode)
          '(my/nano-modeline-element-pdf-page
            nano-modeline-element-window-status
            nano-modeline-element-space))))

;;; Windows and frames

(setq window-divider-default-right-width 24
      window-divider-default-places 'right-only
      window-combination-resize nil
      switch-to-buffer-obey-display-actions t
      switch-to-buffer-in-dedicated-window 'pop
      temp-buffer-max-height 8)
(window-divider-mode 1)
(temp-buffer-resize-mode 1)

(defun my/side-window (side slot &rest extra)
  "Return `display-buffer' actions for a side window at SIDE and SLOT."
  `((display-buffer-in-side-window)
    (side . ,side) (slot . ,slot) (window-height . 0.4)
    (preserve-size . (t . t))
    (window-parameters . ((no-other-window . t) (no-delete-other-windows . t)))
    ,@extra))

(setq display-buffer-alist
      `(("\\*Async Shell Command\\*" (display-buffer-no-window))
        ("\\`\\*\\(Warnings\\|Compile-Log\\|Org Links\\)\\*\\'"
         (display-buffer-no-window) (allow-no-window . t))
        ("^\\*eldoc" display-buffer-at-bottom
         (display-buffer-reuse-window display-buffer-pop-up-window))
        ;; Bottom windows (not side windows)
        ((or (derived-mode . flymake-diagnostics-buffer-mode)
             (derived-mode . flymake-project-diagnostics-mode)
             (derived-mode . messages-buffer-mode)
             (derived-mode . backtrace-mode))
         (display-buffer-reuse-mode-window display-buffer-at-bottom)
         (window-height . 0.4) (dedicated . t) (preserve-size . (t . t)))
        ;; Terminals and shells on the right of the bottom side window,
        ;; REPLs on the left.  Toggle them all with C-` or C-c o o.
        ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*\\(?:ghostel\\|e?shell\\)\\*"
         ,@(my/side-window 'bottom 1))
        ("\\*\\(?:R\\|[Jj]ulia\\|\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*[Pp]ython\\)\\(?:.*\\)?\\*"
         ,@(my/side-window 'bottom -1))
        ("^\\*.*[Dd]ictionary\\*"
         (display-buffer-in-side-window) (side . bottom) (window-height . 0.35))))

(defun my/toggle-window-dedicated ()
  "Toggle whether the selected window is dedicated to its buffer."
  (interactive)
  (let ((window (selected-window)))
    (set-window-dedicated-p window (not (window-dedicated-p window)))
    (message "Window is %s" (if (window-dedicated-p window) "dedicated" "normal"))))

(defun my/make-frame ()
  "Create a new frame showing *scratch*."
  (interactive)
  (select-frame (make-frame))
  (scratch-buffer))

(defun my/kill-emacs ()
  "Delete the frame, or kill Emacs when it is the only frame."
  (interactive)
  (condition-case nil
      (delete-frame)
    (error (save-buffers-kill-terminal))))

;; Prefix help: press C-h after a prefix key to list its bindings.
(use-package which-key
  :hook (after-init . which-key-mode)
  :custom
  (which-key-show-early-on-C-h t)
  (which-key-idle-delay 10000)
  (which-key-idle-secondary-delay 0.05))

;;; Perspectives

(use-package persp-mode
  :ensure t
  :bind ("C-c p s" . persp-kill)
  :custom
  (persp-keymap-prefix "s-p")
  (persp-nil-name "Home")
  (persp-autokill-buffer-on-remove 'kill-weak)
  (persp-before-switch-functions
   (list (lambda (&rest _)
           (when (active-minibuffer-window) (keyboard-escape-quit)))))
  :init
  (persp-mode 1)
  :config
  (defun my/persp-skip-save-buffer-p (buffer)
    "Exclude Magit, Ediff and other transient BUFFERs from saved perspectives."
    (with-current-buffer buffer
      (or (string-match-p "\\`\\*?[Ee]diff" (buffer-name))
          (string-prefix-p "magit-" (symbol-name major-mode))
          (derived-mode-p 'magit-mode 'ediff-mode 'comint-mode 'dired-mode))))
  (add-to-list 'persp-filter-save-buffers-functions #'my/persp-skip-save-buffer-p)

  (defun my/persp-buffer-filter-predicate (buffer)
    "Show BUFFER when it belongs to the current perspective.
In the default perspective show only buffers that belong to no other
perspective.  Always hide noisy internal buffers."
    (let ((current (get-current-persp)))
      (unless (string-match-p "^\\*\\(splash\\|Warning\\|Compile-Log\\|Async\\|Backtrace\\)"
                              (buffer-name buffer))
        (if current
            (memq buffer (persp-buffers current))
          (not (cl-some (lambda (p) (and p (memq buffer (persp-buffers p))))
                        (persp-persps)))))))

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-sources
                 (list :name     "Persp"
                       :narrow   ?s
                       :category 'buffer
                       :state    #'consult--buffer-state
                       :history  'buffer-name-history
                       :default  t
                       :items
                       (lambda () (consult--buffer-query
                                   :sort 'visibility
                                   :predicate #'my/persp-buffer-filter-predicate
                                   :as #'buffer-name)))))

  (with-eval-after-load 'elfeed
    (persp-def-auto-persp "RSS"
                          :parameters '((dont-save-to-file . t))
                          :buffer-name "^\\*elfeed-\\(search\\|entry\\)"
                          :dyn-env '(after-switch-to-buffer-functions ; prevent recursion
                                     (persp-add-buffer-on-find-file nil)
                                     persp-add-buffer-on-after-change-major-mode)
                          :switch 'frame)))

(provide 'my-ui)
;;; my-ui.el ends here
