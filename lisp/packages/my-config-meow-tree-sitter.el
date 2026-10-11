;;; my-config-meow-tree-sitter.el --- Personal meow-tree-sitter configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package meow-tree-sitter
  :if (treesit-available-p)
  :defer t
  :after (meow treesit)
  :config
  (meow-tree-sitter-register-defaults)
  )

(provide 'my-config-meow-tree-sitter)
;;; my-config-meow-tree-sitter.el ends here
