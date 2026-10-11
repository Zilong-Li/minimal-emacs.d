;;; my-config-nano-theme.el --- Personal nano-theme configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

(provide 'my-config-nano-theme)
;;; my-config-nano-theme.el ends here
