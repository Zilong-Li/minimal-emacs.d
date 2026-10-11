;;; my-config-org-links.el --- Personal org-links configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/org-mode-hook ()
  (setq-local fill-paragraph-function #'my/org-fill-paragraph
              normal-auto-fill-function #'my/org-auto-fill-function))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook 'my/org-mode-hook)
  )

(defun my/org-delete-file-link-and-file ()
  "Delete the org file link at point and the file it points to."
  (interactive)
  (let* ((context (org-element-context))
         (type (org-element-type context)))
    (unless (eq type 'link)
      (user-error "No link at point"))
    (let* ((link context)
           (link-type (org-element-property :type link))
           (path (org-element-property :path link))
           (begin (org-element-property :begin link))
           (end (org-element-property :end link)))
      (unless (string= link-type "file")
        (user-error "Not a file link"))
      (let ((full-path (expand-file-name path)))
        (unless (file-exists-p full-path)
          (user-error "File does not exist: %s" full-path))
        (when (yes-or-no-p (format "Delete file '%s' and this link? " full-path))
          (delete-file full-path t)  ; t = move to trash
          (delete-region begin end)
          (message "Deleted file and link: %s" full-path))))))



(my/report-time "Org")

(setq my/section-start-time (current-time))

(provide 'my-config-org-links)
;;; my-config-org-links.el ends here
