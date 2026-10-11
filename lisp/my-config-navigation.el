;;; my-config-navigation.el --- Personal navigation configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

;; Package installation is declared in my-config-bootstrap.el.

(provide 'my-config-navigation)
;;; my-config-navigation.el ends here
