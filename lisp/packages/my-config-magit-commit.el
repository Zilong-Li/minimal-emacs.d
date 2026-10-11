;;; my-config-magit-commit.el --- Personal magit-commit configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package magit-commit
  :defer t
  :config
  (require 'my-config-git-commit "packages/my-config-git-commit"))

(provide 'my-config-magit-commit)
;;; my-config-magit-commit.el ends here
