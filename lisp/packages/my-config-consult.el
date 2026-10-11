;;; my-config-consult.el --- Personal consult configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package consult
  :bind (
         ("C-c l l" . my/consult-goto-line)
         ("C-c l m" . consult-global-mark)
         ("C-c b b" . consult-bookmark)
         ("C-c b m" . my/consult-my-bookmark)
         )

  :custom
  (consult-preview-key nil) ; No live preview
  (consult-narrow-key "<") ;; Use nano-modeline styling for consult
  (consult-line-start-from-top t)

  :config

  ;; Use Consult for xref locations with a preview feature.
  (setopt xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)

  :preface

  (defun my/consult-outline ()
    (interactive)
    (consult-outline)
    (when (derived-mode-p 'org-mode)
      (org-narrow-to-subtree))
    )

  (defun my/consult-line ()
    "Consult line with live preview"
    (interactive)
    (let ((consult-preview-key 'any)
          (mini-frame-resize 'grow-only)) ;; !! Important
      (consult-line (thing-at-point 'symbol))))

  (defun my/consult-goto-line ()
    "Consult goto line with live preview"
    (interactive)
    (let ((consult-preview-key 'any))
      (consult-goto-line)))

  (defun my/get-project-root ()
    (when (fboundp 'projectile-project-root)
      (projectile-project-root)))

  ;; Ripgrep the current word from project root
  (defun my/consult-ripgrep ()
    (interactive)
    (consult-ripgrep (my/get-project-root)(thing-at-point 'symbol)))

  (defun consult-org-links--parse-file (file)
    "Parse org FILE and return list of (description . link) pairs."
    (let ((links '()))
      (with-temp-buffer
        (insert-file-contents file)
        (org-mode)
        (goto-char (point-min))
        (while (re-search-forward org-link-bracket-re nil t)
          (let* ((raw-link (match-string-no-properties 1))
                 (desc (or (match-string-no-properties 2)
                           (file-name-nondirectory raw-link)))
                 (link (org-link-expand-abbrev raw-link)))
            (push (cons desc link) links))))
      (nreverse links)))

  (defun consult-org-links--format-candidate (link-pair)
    "Format LINK-PAIR for consult completion."
    (let ((desc (car link-pair))
          (link (cdr link-pair)))
      (format "%s %s"
              (propertize desc 'face 'nano-default)
              (propertize link 'face 'nano-faded))))

  (defun consult-org-links--ensure-org-link (link)
    "Return LINK wrapped as an Org link if it's not already."
    (if (string-match-p "\\`\\[\\[.*\\]\\]\\'" link)
        link
      (format "[[%s]]" link)))

  (defun consult-org-links--action-simple (link)
    "Open LINK based on its type."
    (when (and link (stringp link) (not (string-empty-p link)))
      (if (string-match-p "\\`https?://" link)
          (browse-url link)
        (org-open-link-from-string
         (consult-org-links--ensure-org-link link)))))


  (defun consult-org-links-simple (org-file &optional use-eww)
    "Select and open org links using consult completion."
    (interactive "fOrg file: \nP")
    (let* ((links (consult-org-links--parse-file org-file))
           (table (make-hash-table :test 'equal))
           (candidates (mapcar (lambda (link-pair)
                                 (let ((formatted (consult-org-links--format-candidate link-pair)))
                                   (puthash formatted (cdr link-pair) table)
                                   formatted))
                               links)))
      (if candidates
          (let ((selected
                 (consult--read
                  candidates
                  :prompt "Org link: "
                  :category 'org-url-link))) ; this is key
            (when-let* ((link (gethash selected table)))
              (if (and use-eww (string-match-p "\\`https?://" link))
                  (eww-browse-url link)
                (consult-org-links--action-simple link))))
        (message "No org links found"))))

  (defun my/consult-my-bookmark (&optional use-eww)
    (interactive "P")
    (consult-org-links-simple "~/Dropbox/Org/GTD/bookmarks.org" use-eww))

  )

(provide 'my-config-consult)
;;; my-config-consult.el ends here
