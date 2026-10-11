;;; my-config-smartparens.el --- Personal smartparens configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

(provide 'my-config-smartparens)
;;; my-config-smartparens.el ends here
