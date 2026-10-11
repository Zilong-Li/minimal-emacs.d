;;; my-org.el --- Org, agenda, capture and export -*- lexical-binding: t; -*-

(setq org-directory "~/Dropbox/Org/GTD")

;;; Org

(use-package org
  :defer t
  :bind (("C-c s s" . org-store-link)
         ("C-c s i" . org-insert-link-global)
         ("C-c s l" . org-open-at-point-global)
         ("C-c s g" . org-mark-ring-goto)
         :map org-mode-map
         ("C-c ;" . nil)
         ("C-'" . nil)
         ("C-c RET" . nil)
         ("C-c C-<return>" . org-table-hline-and-move)
         ("<f5>" . org-edit-special)
         :map org-src-mode-map
         ("<f5>" . org-edit-src-exit))
  :hook ((org-mode . my/org-fill-setup)
         (org-after-todo-state-change . my/org-log-next-activation)
         (org-babel-after-execute . my/org-babel-ansi))
  :custom
  (org-yank-image-save-method "~/Dropbox/Org/Images")
  (org-ellipsis " …")
  (org-tags-column 0)
  (org-hide-emphasis-markers t)
  (org-cycle-separator-lines 2)
  (org-use-tag-inheritance '("events"))
  (org-use-property-inheritance t)
  (org-link-use-indirect-buffer-for-internals t)
  (org-fontify-quote-and-verse-blocks t)
  (org-fontify-whole-block-delimiter-line t)
  (org-return-follows-link t)
  (org-image-actual-width nil)
  (org-export-coding-system 'utf-8)
  (org-indirect-buffer-display 'other-window)
  (org-adapt-indentation nil)
  (org-confirm-babel-evaluate nil)
  (org-edit-src-content-indentation 0)
  (org-plantuml-jar-path "~/.local/bin/plantuml.jar")
  (org-babel-latex-htlatex "htlatex")
  (org-babel-python-command "~/Projects/pyone/.venv/bin/python3")
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)")))
  (org-indent-indentation-per-level 2)
  (org-hide-block-startup t)
  (org-highlight-latex-and-related '(native))
  (org-preview-latex-default-process 'xelatex)
  (org-preview-latex-process-alist
   '((xelatex
      :programs ("xelatex" "dvisvgm")
      :description "xdv > svg"
      :message "you need to install the programs: xelatex and dvisvgm."
      :image-input-type "xdv"
      :image-output-type "svg"
      :image-size-adjust (2.0 . 1.5)
      :latex-compiler ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
      :image-converter ("dvisvgm %f --page=1- --optimize --clipjoin --relative --no-fonts --exact-bbox --scale=%S --output=%O"))))
  (org-format-latex-options
   '(:foreground default :background default :scale 1.2
     :html-foreground "Black" :html-background "Transparent"
     :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
  ;; Refile and capture
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path 'file)
  (org-refile-targets
   '(("life.org" :maxlevel . 1)
     ("bookmarks.org" :maxlevel . 2)
     ("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((calc . t) (shell . t) (latex . t) (python . t) (R . t) (C . t) (plantuml . t)))
  (remove-hook 'kill-emacs-hook #'org-babel-remove-temporary-directory)

  (defun my/org-fill-setup ()
    "Fill to `fill-column' minus the indentation of the current level."
    (setq-local fill-paragraph-function
                (lambda (&optional justify region)
                  (let ((fill-column (- fill-column (my/org-level-offset))))
                    (org-fill-paragraph justify region)))
                normal-auto-fill-function
                (lambda ()
                  (let ((fill-column (- fill-column (my/org-level-offset))))
                    (org-auto-fill-function)))))

  (defun my/org-level-offset ()
    (* (or (org-current-level) 0) org-indent-indentation-per-level))

  (defun my/org-log-next-activation ()
    "Record when an entry first became NEXT in its ACTIVATED property."
    (when (and (string= (org-get-todo-state) "NEXT")
               (not (org-entry-get nil "ACTIVATED")))
      (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))

  (defun my/org-babel-ansi ()
    "Render ANSI colors in the result of the current source block."
    (when-let* ((beg (org-babel-where-is-src-block-result nil nil)))
      (save-excursion
        (goto-char beg)
        (when (looking-at org-babel-result-regexp)
          (let ((ansi-color-context-region nil))
            (ansi-color-apply-on-region beg (org-babel-result-end)))))))

  (defun my/org-delete-file-link-and-file ()
    "Delete the file link at point and move its file to the trash."
    (interactive)
    (let ((link (org-element-context)))
      (unless (and (eq (org-element-type link) 'link)
                   (string= (org-element-property :type link) "file"))
        (user-error "No file link at point"))
      (let ((file (expand-file-name (org-element-property :path link))))
        (unless (file-exists-p file)
          (user-error "File does not exist: %s" file))
        (when (yes-or-no-p (format "Delete file '%s' and this link? " file))
          (delete-file file t)
          (delete-region (org-element-property :begin link)
                         (org-element-property :end link)))))))

;;; Agenda

(defun my/org-save-agenda-buffers (&rest _)
  "Save `org-agenda-files' buffers without confirmation."
  (save-some-buffers t (lambda () (member (buffer-file-name) (org-agenda-files)))))
(advice-add 'org-refile :after #'my/org-save-agenda-buffers)
(advice-add 'org-agenda-quit :before #'my/org-save-agenda-buffers)

(use-package org-agenda
  :bind ("C-c a" . org-agenda)
  :custom
  (org-agenda-files (mapcar (lambda (file) (expand-file-name file org-directory))
                            '("inbox.org" "bookmarks.org" "life.org" "projects.org")))
  (org-agenda-window-setup 'current-window)
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-show-all-dates nil)
  (org-agenda-show-outline-path nil)    ; Shown in the header line instead
  (org-agenda-show-current-time-in-grid t)
  (org-agenda-start-on-weekday 1)
  (org-agenda-span 7)
  (org-agenda-hide-tags-regexp ".")
  (org-agenda-tags-column 0)
  (org-agenda-block-separator nil)
  (org-agenda-category-icon-alist nil)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-sticky t)
  (org-agenda-prefix-format
   '((agenda . "%i %?-12t%s") (todo . "%i") (tags . "%i") (search . "%i")))
  (org-agenda-sorting-strategy
   '((agenda deadline-down scheduled-down todo-state-up time-up
             habit-down priority-down category-keep)
     (todo priority-down category-keep)
     (tags timestamp-up priority-down category-keep)
     (search category-keep)))
  (org-agenda-time-grid '((daily today require-timed) () "......" "----------------"))
  (org-agenda-current-time-string "   now")
  (org-agenda-custom-commands
   '(("d" "Get Things Done (GTD)"
      ((todo "NEXT|TODO"
             ((org-agenda-todo-keyword-format ":%s:")
              (org-agenda-prefix-format '((todo . " ")))
              (org-agenda-overriding-header (propertize "📅 TODO \n" 'face 'nano-strong))))
       (tags "DEADLINE>=\"<today>\""
             ((org-agenda-prefix-format '((tags . " %(my/org-agenda-date) ")))
              (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
              (org-agenda-overriding-header "\n🔔 Upcoming deadlines \n")))
       (tags-todo "DEADLINE<\"<today>\""
                  ((org-agenda-prefix-format '((tags . " %(my/org-agenda-date) ")))
                   (org-agenda-overriding-header "\n🦀 Overdue \n")))))))
  :config
  (add-hook 'org-agenda-after-show-hook #'org-narrow-to-subtree)

  (defun my/org-agenda-date ()
    "Return the entry's date as DD/MM."
    (if-let* ((timestamp (or (org-entry-get nil "TIMESTAMP")
                             (org-entry-get nil "SCHEDULED")
                             (org-entry-get nil "DEADLINE"))))
        (propertize (format-time-string "%d/%m" (org-time-string-to-time timestamp))
                    'face 'nano-popout)
      "     "))

  (define-advice org-agenda-highlight-todo (:filter-return (entry) nano)
    "Hide TODO keywords and fade done or cancelled ENTRY lines."
    (let ((dim (or (string-match-p ":DONE:\\|~" entry)
                   (bound-and-true-p org-agenda-dim)))
          (entry (replace-regexp-in-string ":\\(?:TODO\\|NEXT\\|IDEA\\|DONE\\):\\|~" "" entry)))
      (if dim (propertize entry 'face 'nano-faded) entry)))

  ;; Open entries in a window below, narrowed, with the outline path on top.
  (defun my/org-agenda-display (buffer _alist)
    (let ((display-buffer-overriding-action nil)
          (window (or (window-in-direction 'below)
                      (and (not (one-window-p)) (next-window))
                      (split-window-below -15))))
      (setq-local mode-line-format nil)
      (select-window window)
      (switch-to-buffer buffer)
      (setq-local header-line-format
                  '((:eval
                     (let ((path (org-with-point-at (org-get-at-bol 'org-marker)
                                   (org-display-outline-path nil nil " » " t))))
                       (concat " "
                               (propertize (buffer-name (buffer-base-buffer)) 'face 'nano-strong)
                               (propertize (format " / %s" (substring-no-properties path))
                                           'face 'nano-faded))))))
      window))
  (define-advice org-agenda-goto (:around (orig &rest args) below)
    (let ((display-buffer-overriding-action '(my/org-agenda-display)))
      (apply orig args)
      (org-narrow-to-subtree)))

  ;; Refresh the daily agenda while Emacs is idle.
  (defun my/org-agenda-refresh ()
    (when-let* ((window (get-buffer-window "*Org Agenda(a)*" t)))
      (with-selected-window window
        (let ((inhibit-message t))
          (org-agenda-redo)))))
  (run-with-idle-timer 60 t #'my/org-agenda-refresh))

;;; Capture

(use-package org-capture
  :bind (("C-c c" . org-capture)
         ("C-c i" . my/org-capture-inbox)
         ("C-c m" . my/org-capture-meeting)
         ("C-c B" . my/org-capture-bookmark))
  :custom
  (org-capture-templates
   '(("i" "Inbox" entry (file "inbox.org") "* TODO %?\n/Entered on/ %U")
     ("c" "org-protocol-capture" entry (file "inbox.org")
      "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
     ("B" "Bookmarks" entry (file+headline "bookmarks.org" "Reading") "* TODO %?\n")
     ("m" "Meeting" entry (file+headline "life.org" "Events") "* %? :meeting:\n")))
  :init
  (defun my/org-capture-inbox () (interactive) (org-capture nil "i"))
  (defun my/org-capture-meeting () (interactive) (org-capture nil "m"))
  (defun my/org-capture-bookmark () (interactive) (org-capture nil "B"))
  :config
  ;; Capture in a small window below instead of replacing the layout.
  (define-advice org-capture-place-template (:override (&optional inhibit-wconf-store) below)
    (unless inhibit-wconf-store
      (org-capture-put :return-to-wconf (current-window-configuration)))
    (select-window (split-window-below -10))
    (switch-to-buffer
     (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
    (widen)
    (org-fold-show-all)
    (goto-char (org-capture-get :pos))
    (setq-local outline-level 'org-outline-level)
    (pcase (org-capture-get :type)
      ((or 'nil 'entry) (org-capture-place-entry))
      ('table-line (org-capture-place-table-line))
      ('plain (org-capture-place-plain-text))
      ((or 'item 'checkitem) (org-capture-place-item)))
    (setq-local org-capture-current-plist org-capture-plist)
    (org-capture-mode 1)))

;;; LaTeX export

(use-package ox-latex
  :defer t
  :custom
  (org-latex-compiler "lualatex")
  (org-latex-pdf-process
   '("latexmk -f -pdf -%latex -interaction=nonstopmode -shell-escape -output-directory=%o %f"))
  (org-latex-toc-command "\\tableofcontents\n\\clearpage\n")
  (org-latex-packages-alist
   '(("T1" "fontenc" t) ("" "amsmath" t) ("" "mathtools" t) ("" "siunitx" t)
     ("" "lmodern" t) ("" "booktabs" t)))
  (org-latex-default-class "article")
  (bibtex-dialect 'biblatex)
  (org-cite-export-processors '((latex biblatex) (t basic)))
  :config
  (require 'oc-biblatex)
  (let ((sections '(("\\section{%s}" . "\\section*{%s}")
                    ("\\subsection{%s}" . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}" . "\\paragraph*{%s}"))))
    (setq org-latex-classes
          `(;; Accessible tagged PDF: \DocumentMetadata precedes \documentclass.
            ("article"
             ,(concat "\\DocumentMetadata{lang = en, pdfversion = 2.0, pdfstandard = ua-2, pdfstandard = a-4}\n"
                      "\\documentclass[11pt]{article}")
             ,@sections ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
            ("chinese"
             "\\documentclass[11pt]{article}\n\\usepackage{xeCJK}\n[EXTRA]\n[PACKAGES]"
             ,@sections ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
            ("minipaper"
             "\\documentclass[letterpaper,12pt,leqno]{article}\n\\usepackage{paper}\n[NO-DEFAULT-PACKAGES]\n[EXTRA]\n[PACKAGES]"
             ,@sections)))))

(provide 'my-org)
;;; my-org.el ends here
