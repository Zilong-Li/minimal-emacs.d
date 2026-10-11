;;; my-config-cc-mode.el --- Personal cc-mode configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

(provide 'my-config-cc-mode)
;;; my-config-cc-mode.el ends here
