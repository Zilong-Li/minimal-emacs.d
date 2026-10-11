;;; my-config-magit-status.el --- Personal magit-status configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package magit-status
  :defer t
  :config
  ;; Speed up Magit status by not generating all of the available sections.
  (dolist (func '(
                  ;; magit-insert-status-headers
                  ;; magit-insert-untracked-files
                  ;; magit-insert-unstaged-changes
                  ;; magit-insert-staged-changes
                  ;; magit-insert-stashes
                  ;; magit-insert-unpushed-to-pushremote
                  magit-insert-unpushed-to-upstream-or-recent
                  magit-insert-unpulled-from-pushremote
                  magit-insert-unpulled-from-upstream
                  ))
    (remove-hook 'magit-status-sections-hook func))
  (dolist (func '(
                  ;; magit-insert-error-header
                  magit-insert-diff-filter-header
                  ;; magit-insert-head-branch-header
                  ;; magit-insert-upstream-branch-header
                  ;; magit-insert-push-branch-header
                  magit-insert-tags-header
                  ))
    (remove-hook 'magit-status-headers-hook func)))

(provide 'my-config-magit-status)
;;; my-config-magit-status.el ends here
