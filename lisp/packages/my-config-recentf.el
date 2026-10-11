;;; my-config-recentf.el --- Personal recentf configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package recentf
  ;; Loads after 0.5 second of idle time.
  :defer 0.5
  :custom
  (recentf-max-menu-items 15)
  (recentf-max-saved-items 20)
  (recentf-auto-cleanup 60) ; idle for 60 secs
  (recentf-exclude
   '("~\\'" "\\`out\\'" "\\.log\\'" "\\.mp3\\'" "^/[^/]*:" "\\.el\\.gz\\'"))
  :config
  (add-to-list 'recentf-exclude
             (lambda (file)
               (member (expand-file-name file)
                       (mapcar #'expand-file-name (org-agenda-files)))))
  (recentf-mode 1)
  )

(provide 'my-config-recentf)
;;; my-config-recentf.el ends here
