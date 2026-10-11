;;; my-config-magit.el --- Personal magit configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package magit
  :bind (("C-M-g" . magit-status))
  :bind (:map magit-mode-map
              ("U" . magit-unstage-all))
  :bind (:map magit-file-section-map ("<C-return>"))
  :bind (:map magit-hunk-section-map ("<C-return>"))
  :custom
  (magit-process-connection-type nil) ; speedup on macOS
  (magit-diff-options nil)
  (magit-diff-refine-hunk t)
  (magit-fetch-arguments nil)
  ;; This is done for the sake of performance on macOS
  (magit-git-executable "/opt/homebrew/bin/git")
  (magit-highlight-trailing-whitespace nil)
  (magit-highlight-whitespace nil)
  (magit-log-section-commit-count 10)
  (magit-pre-refresh-hook nil)
  (magit-process-popup-time 15)
  (magit-push-always-verify nil)
  ;; You can tell Magit to only automatically refresh the current Magit
  ;; buffer, but not the status buffer. If you do that, then the status buffer
  ;; is only refreshed automatically if it is the current buffer.
  (magit-refresh-status-buffer nil)
  (magit-section-initial-visibility-alist '((untracked . hide)))
  (magit-stage-all-confirm nil)
  (magit-unstage-all-confirm nil)
  (magit-use-overlays nil)
  :preface
  ;; History can be viewed with:
  ;; git log refs/snapshots/$(git symbolic-ref HEAD)
  (defun magit-monitor (&optional _no-display)
    "Start git-monitor in the current directory."
    (interactive)
    (let* ((path (file-truename
                  (directory-file-name
                   (expand-file-name default-directory))))
           (name (format "*git-monitor: %s*"
                         (file-name-nondirectory path))))
      (unless (and (get-buffer name)
                   (with-current-buffer (get-buffer name)
                     (string= path (directory-file-name default-directory))))
        (with-current-buffer (get-buffer-create name)
          (cd path)
          (if (file-regular-p ".git")
              (let ((branch (string-chop-newline
                             (shell-command-to-string
                              "git branch --show-current")))
                    (repo
                     (with-temp-buffer
                       (insert-file-contents-literally ".git")
                       (goto-char (point-min))
                       (and (looking-at "^gitdir: \\(.+?/\\.git/\\)")
                            (match-string 1)))))
                (when repo
                  (ignore-errors
                    (start-process "*git-monitor*" (current-buffer)
                                   "git-monitor"
                                   "--git-dir" repo
                                   "--work-dir" path
                                   "-r" (concat "refs/heads/" branch)))))
            (ignore-errors
              (start-process "*git-monitor*" (current-buffer)
                             "git-monitor" "--work-dir" path)))))))

  (defun magit-status-with-prefix ()
    (interactive)
    (let ((current-prefix-arg '(4)))
      (call-interactively #'magit-status)))

  (defun endless/visit-pull-request-url ()
    "Visit the current branch's PR on Github."
    (interactive)
    (browse-url
     (format "https://github.com/%s/pull/new/%s"
             (replace-regexp-in-string
              "\\`.+github\\.com:\\(.+?\\)\\(\\.git\\)?\\'" "\\1"
              (magit-get "remote" (magit-get-remote) "url"))
             (magit-get-current-branch))))

  (defvar magit--call-git-cache (make-hash-table :test #'equal))

  (defun my-magit-cache-config (orig-func &rest args)
    (or (and (string= (car args) "config")
             (gethash args magit--call-git-cache))
        (let ((result (apply orig-func args)))
          (puthash args result magit--call-git-cache)
          result)))

  :hook ((magit-mode . hl-line-mode))

  :config

  ;; Add fringe on the left side of magit windows such that we can highlight region using the fringe.

  (add-hook 'magit-mode-setup-hook
            #'(lambda ()
                (interactive)
                (set-window-fringes nil (* 2 (window-font-width)) 0)
                ))

  (add-hook 'magit-status-mode-hook #'(lambda () (magit-monitor t)))

  (define-key magit-mode-map "G" #'endless/visit-pull-request-url)

  ;; Magit also reverts buffers for visited files located inside the current
  ;; repository when the visited file changes on disk. That is implemented on
  ;; top of auto-revert-mode from the built-in library autorevert. To figure
  ;; out whether that impacts performance, check whether performance is
  ;; significantly worse, when many buffers exist and/or when some buffers
  ;; visit files using TRAMP. If so, then this should help.
  (setq auto-revert-buffer-list-filter
        'magit-auto-revert-repository-buffer-p)

  (setq magit-bury-buffer-function 'magit-restore-window-configuration
        magit-display-buffer-function 'magit-display-buffer-fullframe-status-topleft-v1)

  ;; When refreshing the "references buffer" is slow, then that’s usually
  ;; because several hundred refs are being displayed. The best way to address
  ;; that is to display fewer refs, obviously.
  (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)

  ;; When you initiate a commit, then Magit by default automatically shows a
  ;; diff of the changes you are about to commit. For large commits this can
  ;; take a long time, which is especially distracting when you are committing
  ;; large amounts of generated data which you don’t actually intend to
  ;; inspect before committing. This behavior can be turned off using:
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff)

  (advice-add 'magit-git-items :around #'my-magit-cache-config)

  (advice-add 'magit-set-header-line-format :override #'ignore)

  (require 'my-config-magit-commit "packages/my-config-magit-commit")

  (require 'my-config-magit-pull "packages/my-config-magit-pull")

  (require 'my-config-magit-push "packages/my-config-magit-push")

  (require 'my-config-magit-status "packages/my-config-magit-status")

  )

(provide 'my-config-magit)
;;; my-config-magit.el ends here
