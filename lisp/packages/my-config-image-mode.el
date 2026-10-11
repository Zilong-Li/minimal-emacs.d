;;; my-config-image-mode.el --- Personal image-mode configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/open-dired-for-current-image ()
  "Open dired buffer where the current image belongs."
  (interactive)
  (when (derived-mode-p 'image-mode)
    (let ((file (buffer-file-name)))
      (if file
          (dired (file-name-directory file))
        (message "Current buffer is not associated with a file.")))))

(with-eval-after-load 'image-mode
  (define-key image-mode-map (kbd "d") #'my/open-dired-for-current-image)
  (define-key image-mode-map (kbd "a") 'other-window)
  (define-key image-mode-map (kbd "A +") 'image-increase-speed)
  (define-key image-mode-map (kbd "A -") 'image-decrease-speed)
  (define-key image-mode-map (kbd "A r") 'image-reverse-speed)
  (define-key image-mode-map (kbd "A 0") 'image-reset-speed)
  )

(bind-key "C-c l y" #'yank-media)

(defun my-embark-image ()
  "Match images."
  (let ((extensions "\\(png\\|jpg\\|svg\\|gif\\|jpeg\\)\\'"))
    (cond
     ((derived-mode-p 'org-mode)
      (when-let* ((link (org-element-context)))
        (when (eq (org-element-type link) 'link)
          (cond
           ((string= "attachment" (org-element-property :type link))
            (cons 'image (expand-file-name (org-element-property :path link)
                                           (org-attach-dir))))
           ((string-match "sketch" (org-element-property :type link))
            (cons 'image (my-get-sketch-filename (org-element-property :path link))))
           ((string-match extensions (org-element-property :path link))
            (cons 'image (org-element-property :path link)))))))
     ((and (derived-mode-p 'dired-mode)
           (string-match extensions (dired-get-filename)))
      (cons 'image (dired-get-filename)))
     ((derived-mode-p 'subed-mode)
      (when-let* ((filename (thing-at-point 'filename)))
        (when (string-match (concat "file:\\(.+\\." extensions "\\)") filename)
          (cons 'image (match-string 1 filename)))))
     ((and (buffer-file-name)
           (string-match extensions (buffer-file-name)))
      (cons 'image (buffer-file-name))))))

(with-eval-after-load 'embark
  (add-to-list 'embark-target-finders 'my-embark-image))

(provide 'my-config-image-mode)
;;; my-config-image-mode.el ends here
