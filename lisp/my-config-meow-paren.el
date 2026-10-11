;;; my-config-meow-paren.el --- Personal meow-paren configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

(provide 'my-config-meow-paren)
;;; my-config-meow-paren.el ends here
