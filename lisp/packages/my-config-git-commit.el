;;; my-config-git-commit.el --- Personal git-commit configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package git-commit
  :custom
  ;; Commit messages need no Markdown parsing or fontification while typing.
  (git-commit-major-mode 'text-mode)
  (git-commit-setup-hook
   '(git-commit-save-message
     git-commit-turn-on-auto-fill
     ;; git-commit-turn-on-flyspell
     bug-reference-mode)))

(provide 'my-config-git-commit)
;;; my-config-git-commit.el ends here
