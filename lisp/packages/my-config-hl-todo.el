;;; my-config-hl-todo.el --- Personal hl-todo configuration -*- no-byte-compile: t; lexical-binding: t; -*-

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

(provide 'my-config-hl-todo)
;;; my-config-hl-todo.el ends here
