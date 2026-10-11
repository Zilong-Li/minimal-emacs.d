;;; my-config-org.el --- Personal org configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq my/section-start-time (current-time))

(defun my/calc-offset-on-org-level ()
  "Calculate offset (in chars) on current level in org mode file."

  (* (or (org-current-level) 0) org-indent-indentation-per-level))

(defun my/org-fill-paragraph (&optional justify region)
  "Calculate apt fill-column value and fill paragraph."

  (let* ((fill-column (- fill-column (my/calc-offset-on-org-level))))
    (org-fill-paragraph justify region)))

(defun my/org-auto-fill-function ()
  "Calculate apt fill-column value and do auto-fill"

  (let* ((fill-column (- fill-column (my/calc-offset-on-org-level))))
    (org-auto-fill-function)))

(setq org-directory "~/Dropbox/Org/GTD")
(use-package org
  :defer t
  :custom
  (org-yank-image-save-method "~/Dropbox/Org/Images")
  (org-ellipsis " …")                  ; Nicer ellipsis
  (org-tags-column 0)              ; Tags next to header title
  (org-agenda-tags-column 0)       ;
  (org-hide-emphasis-markers t)    ; Hide markers
  (org-cycle-separator-lines 2)    ; Number of empty lines between sections
  (org-use-tag-inheritance '("events"))    ; nil for Tags ARE NOT inherited
  (org-use-property-inheritance t) ; Properties ARE inherited
  (org-link-use-indirect-buffer-for-internals t) ; Indirect buffer for internal links
  (org-fontify-quote-and-verse-blocks t) ; Specific face for quote and verse blocks
  (org-fontify-whole-block-delimiter-line t) ; Fontify whole block
  (org-return-follows-link nil)    ; Follow links when hitting return
  (org-image-actual-width nil)     ; Resize image to window width
  (org-export-coding-system 'utf-8) ; coding-system
  (org-indirect-buffer-display 'other-window) ; Tab on a task expand it in a new window
  (org-src-fontify-natively t)         ; Fontify code in code blocks.
  (org-adapt-indentation nil)          ; Adaptive indentation
  (org-src-tab-acts-natively t)        ; Tab acts as in source editing
  (org-confirm-babel-evaluate nil)     ; No confirmation before executing code
  (org-edit-src-content-indentation 0) ; No relative indentation for code blocks
  (org-plantuml-jar-path "~/.local/bin/plantuml.jar")
  (org-babel-latex-htlatex "htlatex")  ; Command to convert latex to svg and html
  (org-latex-preview-ltxpng-directory "~/.ltximg/")
  (org-latex-default-class "article")
  (org-outline-path-complete-in-steps nil) ; No steps in path display
  (org-return-follows-link t) ; return open link at point
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)")))
  (org-indent-indentation-per-level 2) ; Indentation per level
  (org-hide-block-startup t) ; hide blocks on startup
  (org-preview-latex-default-process 'xelatex)
  (org-highlight-latex-and-related '(native))
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
  ;; :config
  ;; (plist-put org-format-latex-options :scale 1.2)
  )

(defun ek/babel-ansi ()
  (when-let* ((beg (org-babel-where-is-src-block-result nil nil)))
    (save-excursion
      (goto-char beg)
      (when (looking-at org-babel-result-regexp)
        (let ((end (org-babel-result-end))
              (ansi-color-context-region nil))
          (ansi-color-apply-on-region beg end))))))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((calc . t)
     (shell . t)
     (latex . t)
     (python . t)
     (R . t)
     (C . t)
     (plantuml . t)))
  (setq org-babel-python-command "~/Projects/pyone/.venv/bin/python3")
  (add-hook 'org-babel-after-execute-hook 'ek/babel-ansi)
  (remove-hook 'kill-emacs-hook 'org-babel-remove-temporary-directory)
  )

(with-eval-after-load 'org
  (define-key org-mode-map "\C-c;" nil) ;; disable C-c ; for toggle comment
  (define-key org-mode-map (kbd "C-j") nil) ;; disable C-j  for `org-return-and-maybe-indent'
  (define-key org-mode-map (kbd "C-'") nil) ;; disable C-'  for org-cycle-agenda-files
  (define-key org-mode-map (kbd "C-c RET") nil) ;; disable C-c RET  for org-table-hline-and-move
  (define-key org-mode-map (kbd "<f5>") #'org-edit-special) ; open `org-edit-special'
  (define-key org-src-mode-map (kbd "<f5>") #'org-edit-src-exit) ; exit `org-edit-special'
  (bind-key "C-c C-<return>"  #'org-table-hline-and-move 'org-mode-map)
  (bind-key "C-c s s"  #'org-store-link)         ;; store a link at any point
  (bind-key "C-c s i"  #'org-insert-link-global) ;; insert a previous stored link
  (bind-key "C-c s l"  #'org-open-at-point-global) ;; visit a link - no matter the mode
  (bind-key "C-c s g"  #'org-mark-ring-goto)       ;; go back to where I was after visiting a link in org mode only
)

(provide 'my-config-org)
;;; my-config-org.el ends here
