;;; my-config-denote.el --- Personal denote configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package denote
  :commands (denote denote-open-or-create consult-notes)
  :bind
  ( :map global-map
    ("C-c n n" . denote)
    ("C-c n N" . denote-open-or-create)
    ("C-c n o" . consult-notes)
    ("C-c n l" . denote-link)            ; insert link
    ("C-c n i" . denote-org-link-to-heading) ; insert link to org headings
    ("C-c n I" . denote-add-links)       ; insert links to all files matching regrex
    ("C-c n f" . denote-find-link)       ; find link
    ("C-c n b" . denote-backlinks)       ; show backlinks
    ("C-c n B" . denote-find-backlink)   ; find backlinks
    ("C-c n O" . denote-org-dblock-insert-backlinks) ; org backlink block
    ("C-c n d" . denote-date)  ; new specifying date and time
    ("C-c n z" . denote-signature)
    ("C-c n s" . denote-subdirectory)
    ("C-c n t" . denote-template)
    ("C-c n R" . denote-rename-file)

    :map dired-mode-map
    ("C-c C-d C-i" . denote-link-dired-marked-notes)
    ("C-c C-d C-r" . denote-dired-rename-marked-files)
    ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter)
    ;; Also check the commands `denote-link-after-creating',
    ;; `denote-link-or-create'.  You may want to bind them to keys as well.
    )

  :hook
  (dired-mode . denote-dired-mode)
  :custom
  (denote-file-type 'org)
  (denote-directory (expand-file-name "~/Dropbox/Denotes/"))
  (denote-known-keywords '("emacs" "academia" "algorithm"))
  (denote-prompts '(title keywords))
  (denote-infer-keywords t)
  (denote-sort-keywords nil)
  (denote-excluded-directories-regexp nil)
  (denote-excluded-keywords-regexp nil)
  ;; Pick dates, where relevant, with Org's advanced interface:
  (denote-date-prompt-use-org-read-date t)
  (denote-date-format nil) ; read doc string

  :config
  ;; Read this manual for how to specify `denote-templates'.  We do not
  ;; include an example here to avoid potential confusion.

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1)

  )







(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

(provide 'my-config-denote)
;;; my-config-denote.el ends here
