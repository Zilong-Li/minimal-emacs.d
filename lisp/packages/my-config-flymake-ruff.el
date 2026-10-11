;;; my-config-flymake-ruff.el --- Personal flymake-ruff configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package flymake-ruff
  :hook (python-mode . flymake-ruff-load)
  :hook (python-ts-mode . flymake-ruff-load)
  )

(provide 'my-config-flymake-ruff)
;;; my-config-flymake-ruff.el ends here
