;;; my-tools.el --- Files, projects, Git, shells, web and applications -*- lexical-binding: t; -*-

;;; Dired, images and buffers

(use-package dired
  :bind (:map dired-mode-map
              ("a" . other-window)
              ("n" . dired-goto-file)
              ("/" . find-name-dired)
              ("," . dired-create-directory)
              ("v" . my/dired-slideshow)
              ("p" . dired-up-directory)
              ("K" . wdired-change-to-wdired-mode))
  :custom
  (dired-listing-switches
   "-l -v --group-directories --no-group --human-readable --time-style=+%Y-%m-%d --almost-all")
  (dired-dwim-target t)
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t)
  :config
  (defun my/dired-slideshow ()
    "Show the images of this directory as a slideshow."
    (interactive)
    (start-process "dired-slideshow" nil "~/.local/bin/s" (dired-current-directory))))

(use-package image-mode
  :bind (:map image-mode-map
              ("a" . other-window)
              ("d" . my/image-dired)
              ("A +" . image-increase-speed)
              ("A -" . image-decrease-speed)
              ("A r" . image-reverse-speed)
              ("A 0" . image-reset-speed))
  :config
  (defun my/image-dired ()
    "Open Dired at the current image."
    (interactive)
    (dired-jump nil (buffer-file-name))))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-expert t)
  (ibuffer-default-display-maybe-show-predicates t)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-shrink-to-minimum-size t)
  (ibuffer-formats
   '((mark modified read-only locked
           " " (name 30 30 :left :elide)
           " " (size 9 -1 :right)
           " " (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " " (name 16 -1) " " filename)))
  :config
  (require 'ibuf-ext)
  (define-ibuffer-filter persp
      "Limit the view to buffers of the current perspective."
    (:description "persp-mode"
     :reader (persp-read-persp nil nil (safe-persp-name (get-frame-persp)) t))
    (memq buf (safe-persp-buffers
               (persp-get-by-name (if (string= qualifier "")
                                      (safe-persp-name (get-current-persp))
                                    qualifier)))))

  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (let ((name (safe-persp-name (get-frame-persp))))
                (setf (alist-get "persp-mode" ibuffer-saved-filter-groups nil nil #'equal)
                      `((,name (persp . ,name)))))
              (ibuffer-switch-to-saved-filter-groups "persp-mode"))))

(defun my--messages-buffer-keys ()
  "Personal keys for *Messages*."
  (local-set-key (kbd "a") #'other-window)
  (local-set-key (kbd "q") #'bury-buffer)
  (local-set-key (kbd "C-c C-l") #'message-clear-log)
  (local-set-key (kbd "g") #'revert-buffer))
(add-hook 'messages-buffer-mode-hook #'my--messages-buffer-keys)

(with-eval-after-load 'help-mode
  (keymap-set help-mode-map "Q" #'kill-buffer-and-window))

;;; Projects (one perspective per project)

(use-package project
  :bind (("C-c p p" . project-switch-project)
         ("C-c p d" . my/project-persp-dired)
         ("C-c p k" . my/kill-project-and-perspective)
         ("C-c p f" . project-find-file)
         ("C-c p F" . project-forget-project)
         ("C-c p c" . project-compile)
         ("C-c p b" . project-switch-to-buffer))
  :custom
  (project-vc-extra-root-markers '(".dir-locals.el" "Makefile" "package.json"
                                   "setup.py" ".project"))
  :config
  (defun my/project-persp-switch (root)
    "Switch to the perspective named after project ROOT."
    (persp-switch (file-name-nondirectory (directory-file-name root))))

  (defun my/project-persp-dired ()
    "Open the project root in Dired within its perspective."
    (interactive)
    (let ((root (project-root (project-current t))))
      (my/project-persp-switch root)
      (dired root)))

  (defun my/kill-project-and-perspective ()
    "Kill the buffers of the current project and remove its perspective."
    (interactive)
    (let* ((project (or (project-current) (user-error "Not in a project")))
           (name (file-name-nondirectory (directory-file-name (project-root project)))))
      (project-kill-buffers)
      (when (persp-with-name-exists-p name)
        (persp-kill name))))

  (define-advice project-switch-project (:before (&optional dir) persp)
    (when dir (my/project-persp-switch dir)))
  (define-advice project-find-file (:before (&rest _) persp)
    (my/project-persp-switch (project-root (project-current t))))

  (add-to-list 'project-switch-commands '(magit-project-status "Magit" ?M) t)
  (add-to-list 'project-switch-commands '(my/project-persp-dired "Perspective" ?p) t))

;;; Remote files

(use-package tramp
  :defer t
  :config
  (setq tramp-chunksize 2000
        tramp-default-method "ssh"
        auth-source-cache-expiry nil
        vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp tramp-file-name-regexp))
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path t)
  (add-to-list 'password-word-equivalents "Second Factor")
  (add-to-list 'password-word-equivalents "First Factor")

  (defun my/tramp-set-display ()
    "Read DISPLAY from the remote ~/.display.txt for remote processes."
    (when (file-remote-p default-directory)
      (let ((file (expand-file-name "~/.display.txt")))
        (add-to-list 'tramp-remote-process-environment
                     (format "DISPLAY=%s"
                             (if (file-exists-p file)
                                 (with-temp-buffer
                                   (insert-file-contents file)
                                   (string-trim (buffer-string)))
                               "localhost:10.0"))))))
  (add-hook 'tramp-connected-hook #'my/tramp-set-display))

(defun my/copy-file-to-download-folder (file)
  "Copy FILE to ~/Downloads/."
  (interactive "fCopy file: ")
  (copy-file file (expand-file-name (file-name-nondirectory file) "~/Downloads/") t))

(defun my/copy-folder-to-download-folder (directory)
  "Copy DIRECTORY recursively into ~/Downloads/."
  (interactive "DCopy directory: ")
  (copy-directory directory
                  (expand-file-name (file-name-nondirectory (directory-file-name directory))
                                    "~/Downloads/")
                  nil nil t))

(defun my/upload-file-to-remote-folder (file directory)
  "Copy local FILE to the (remote) DIRECTORY."
  (interactive (list (read-file-name "Upload local file: " nil nil t)
                     (read-directory-name "Remote destination: ")))
  (copy-file file (expand-file-name (file-name-nondirectory file) directory) t))

;;; Git

(use-package magit
  :ensure t
  :bind (("C-M-g" . magit-status)
         :map magit-mode-map
         ("U" . magit-unstage-all)
         ("G" . my/magit-visit-pull-request-url)
         :map magit-file-section-map ("<C-return>" . nil)
         :map magit-hunk-section-map ("<C-return>" . nil))
  :hook (magit-mode . hl-line-mode)
  :custom
  (magit-git-executable "/opt/homebrew/bin/git") ; Faster than the shim on macOS
  (magit-process-connection-type nil)
  (magit-diff-refine-hunk t)
  (magit-highlight-trailing-whitespace nil)
  (magit-highlight-whitespace nil)
  (magit-log-section-commit-count 10)
  (magit-pre-refresh-hook nil)
  (magit-process-popup-time 15)
  (magit-refresh-status-buffer nil)
  (magit-section-initial-visibility-alist '((untracked . hide)))
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-topleft-v1)
  (git-commit-major-mode 'text-mode)    ; No Markdown parsing while typing
  (git-commit-setup-hook '(git-commit-save-message
                           git-commit-turn-on-auto-fill
                           bug-reference-mode))
  :config
  (defun my/magit-visit-pull-request-url ()
    "Visit the current branch's pull request on GitHub."
    (interactive)
    (browse-url
     (format "https://github.com/%s/pull/new/%s"
             (replace-regexp-in-string
              "\\`.+github\\.com:\\(.+?\\)\\(\\.git\\)?\\'" "\\1"
              (magit-get "remote" (magit-get-remote) "url"))
             (magit-get-current-branch))))

  ;; Cache `git config' lookups.
  (defvar my/magit-config-cache (make-hash-table :test #'equal))
  (define-advice magit-git-items (:around (orig &rest args) cache-config)
    (if (equal (car args) "config")
        (with-memoization (gethash args my/magit-config-cache)
          (apply orig args))
      (apply orig args)))

  ;; Fringe on the left for highlighting.
  (add-hook 'magit-mode-setup-hook
            (lambda () (set-window-fringes nil (* 2 (window-font-width)) 0)))
  (advice-add 'magit-set-header-line-format :override #'ignore)

  ;; Faster refreshes: fewer sections, refs and no automatic commit diff.
  (setq auto-revert-buffer-list-filter #'magit-auto-revert-repository-buffer-p)
  (remove-hook 'magit-refs-sections-hook #'magit-insert-tags)
  (remove-hook 'server-switch-hook #'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook #'magit-commit-diff)
  (dolist (func '(magit-insert-unpushed-to-upstream-or-recent
                  magit-insert-unpulled-from-pushremote
                  magit-insert-unpulled-from-upstream))
    (remove-hook 'magit-status-sections-hook func))
  (dolist (func '(magit-insert-diff-filter-header magit-insert-tags-header))
    (remove-hook 'magit-status-headers-hook func))

  (transient-insert-suffix 'magit-pull "p" '("F" "default" magit-fetch-from-upstream))
  (transient-insert-suffix 'magit-push "p" '("P" "default" magit-push-current-to-upstream)))

(use-package ediff
  :defer t
  :custom
  (ediff-combination-pattern
   '("<<<<<<< A: HEAD" A "||||||| Ancestor" Ancestor "=======" B ">>>>>>> B: Incoming"))
  (ediff-diff-options "-w")
  (ediff-highlight-all-diffs nil)
  (ediff-show-clashes-only t))

(setq transient-align-variable-pitch t)

;;; Compilation, processes and REPLs

(setq compilation-context-lines 10
      comint-input-ring-size 1000
      comint-process-echoes t)

(use-package proced
  :defer t
  :custom
  (proced-enable-color-flag t)
  (proced-tree-flag t)
  (proced-auto-update-flag 'visible)
  (proced-auto-update-interval 1)
  (proced-descent t)
  (proced-filter 'user))

(defun my/repl-send-line-or-region (repl &optional step)
  "Send the current line or region to REPL; with STEP move to the next line."
  (let* ((proc (or (get-buffer-process repl)
                   (error "No process found for buffer %s" repl)))
         (min (if (use-region-p) (region-beginning) (line-beginning-position)))
         (max (if (use-region-p) (region-end) (line-end-position)))
         (command (buffer-substring min max)))
    (with-current-buffer (process-buffer proc)
      (goto-char (process-mark proc))
      (insert command "\n")
      (set-marker (process-mark proc) (point)))
    (process-send-string proc (concat command "\n"))
    (display-buffer (process-buffer proc))
    (when step
      (goto-char max)
      (forward-line 1))
    (deactivate-mark)))

(defun my/shell-setup ()
  "Plain completion and auto-kill on exit for `shell-mode'."
  (setq-local completion-styles '(basic))
  (when-let* ((proc (get-buffer-process (current-buffer))))
    (set-process-sentinel proc
                          (lambda (process _event)
                            (when (memq (process-status process) '(exit signal))
                              (kill-buffer (process-buffer process)))))))
(add-hook 'shell-mode-hook #'my/shell-setup)

(use-package eshell
  :bind ("M-e" . eshell)
  :hook ((eshell-mode . my/eshell-setup)
         (eshell-post-command . my/eshell-store-last-output))
  :custom
  (eshell-scroll-to-bottom-on-input 'all)
  (eshell-history-size 10240)
  (eshell-last-dir-unique t)
  (eshell-last-dir-ring-size 32)
  (eshell-error-if-no-glob t)
  (eshell-hist-ignoredups 'erase)
  (eshell-cd-on-directory t)
  (eshell-save-history-on-exit t)
  (eshell-kill-on-exit t)
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands nil)
  (eshell-prompt-function (lambda () "λ "))
  (eshell-prompt-regexp "^[λ#] +")
  :config
  (add-to-list 'eshell-modules-list 'eshell-elecslash)
  (add-to-list 'eshell-modules-list 'eshell-rebind)

  (defun my/eshell-setup ()
    (setq-local debug-on-error nil
                completion-styles '(basic)))

  (defalias 'eshell/d #'dired)
  (defalias 'eshell/c (lambda () (eshell/cd "..")))
  (defalias 'eshell/vi #'eshell/e)
  (defalias 'eshell/le #'eshell/less)

  (define-advice eshell/cat (:override (filename) highlight)
    "Like cat(1) but with syntax highlighting."
    (let ((existing (get-file-buffer filename))
          (buffer (find-file-noselect filename)))
      (eshell-print
       (with-current-buffer buffer
         (font-lock-ensure)
         (let ((contents (buffer-string)))
           (remove-text-properties 0 (length contents) '(read-only nil) contents)
           contents)))
      (unless existing (kill-buffer buffer))
      nil))

  (defun my/eshell-image-append (flag images)
    "Join IMAGES (the last one is the output) with ImageMagick FLAG."
    (unless (cdr images)
      (error "Usage: <image1> <image2> ... <output-image>"))
    (eshell-command-result
     (mapconcat #'identity (append (list "convert" flag) images) " ")))
  (defun eshell/ch (&rest images) "Concatenate IMAGES horizontally."
         (my/eshell-image-append "+append" images))
  (defun eshell/cv (&rest images) "Concatenate IMAGES vertically."
         (my/eshell-image-append "-append" images))

  (defun eshell/l (&rest args) (apply #'eshell/ls "-alrth" args))

  (defun my/eshell-on-files (fun1 fun2 args)
    "Call FUN1 on the first of ARGS and FUN2 on the rest."
    (when args
      (let ((files (flatten-list args)))
        (funcall fun1 (car files))
        (mapc fun2 (cdr files)))
      ""))
  (defun eshell/e (&rest files)
    (my/eshell-on-files #'find-file #'find-file-other-window files))
  (defun eshell/ee (&rest files)
    (my/eshell-on-files #'find-file-other-window #'find-file-other-window files))
  (defun eshell/less (&rest files)
    (my/eshell-on-files #'view-file #'view-file-other-window files))

  (defun eshell/set (var &rest values)
    "Set the buffer-local variable and environment variable VAR to VALUES.
Without VALUES delete them."
    (if values
        (let ((val (mapconcat #'eshell-stringify values " ")))
          (set (make-local-variable (intern var)) val)
          (setenv var val))
      (kill-local-variable (intern var))
      (setenv var)))

  (defun eshell/newbase (file newbase)
    "Replace the extension of FILE, e.g. {newbase $f txt}."
    (concat (file-name-base file)
            (if (string-prefix-p "." newbase) newbase (concat "." newbase))))

  (defvar my/eshell-output (make-ring 10)
    "Output of the last eshell commands.")
  (defun my/eshell-store-last-output ()
    (ring-insert my/eshell-output
                 (buffer-substring-no-properties eshell-last-input-end
                                                 eshell-last-output-start)))
  (defun eshell/output (&optional index format)
    "Return output INDEX (0 is the latest) as text, a list or a file (FORMAT)."
    (when (stringp index) (setq format index index 0))
    (let ((results (ring-ref my/eshell-output (or index 0))))
      (pcase (and format (aref format 0))
        (?l (split-string results))
        (?f (let ((file (make-temp-file "eshell-output-")))
              (with-temp-file file (insert results))
              file))
        (_ (string-trim results))))))

(use-package ghostel
  :ensure t
  :bind (("C-c t t" . my/toggle-ghostel)
         ("C-c t o" . ghostel-other)
         ("C-c t e" . ghostel-emacs-mode)
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :init
  ;; Render comint and compilation output with Ghostel once those libraries
  ;; load, but not before init finishes (package installation compiles code).
  (add-hook 'after-init-hook
            (lambda ()
              (with-eval-after-load 'comint (ghostel-comint-global-mode 1))
              (with-eval-after-load 'compile (ghostel-compile-global-mode 1))))
  (add-hook 'eshell-load-hook #'ghostel-eshell-visual-command-mode)
  :custom
  (ghostel-kill-buffer-on-exit t)
  :config
  (defun my/toggle-ghostel ()
    "Toggle the project terminal."
    (interactive)
    (if (derived-mode-p 'ghostel-mode)
        (delete-window)
      (ghostel-project)))

  (defun my/ghostel-send-C-k-and-kill ()
    "Send C-k and save the killed text, like Emacs' C-k."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  ;; M-p/M-n walk the shell history as in eshell.
  (keymap-set ghostel-semi-char-mode-map "M-p" (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
  (keymap-set ghostel-semi-char-mode-map "M-n" (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
  (keymap-set ghostel-semi-char-mode-map "C-s" #'consult-line)
  (keymap-set ghostel-semi-char-mode-map "C-k" #'my/ghostel-send-C-k-and-kill)
  (add-to-list 'ghostel-keymap-exceptions "M-o")
  (keymap-set ghostel-semi-char-mode-map "M-o" #'other-window)
  (keymap-set ghostel-char-mode-map "M-o" #'other-window)

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

;;; Web

(setq browse-url-browser-function #'browse-url-default-browser
      browse-url-secondary-browser-function #'browse-url-generic
      browse-url-generic-program "open")

(defun my/browse-url-secondary (&optional url)
  "Open URL (or the URL at point) in the secondary browser."
  (interactive)
  (funcall browse-url-secondary-browser-function
           (or url
               (thing-at-point 'url)
               (and (derived-mode-p 'org-mode)
                    (org-element-property :raw-link (org-element-context)))
               (read-string "URL: "))))

(defun my/search-thing-at-point-or-prompt ()
  "Search the web for the region, the symbol at point, or a prompt."
  (interactive)
  (browse-url
   (format "https://duckduckgo.com/html/?q=%s"
           (url-hexify-string
            (cond ((use-region-p)
                   (buffer-substring-no-properties (region-beginning) (region-end)))
                  ((thing-at-point 'symbol t))
                  (t (read-string "Search: ")))))))

(use-package eww
  :bind (("C-c w" . eww)
         :map eww-mode-map
         ("=" . text-scale-increase)
         ("-" . text-scale-decrease)
         ("a" . other-window)
         ("f" . eww-forward-url)
         ("r" . eww-search-words)
         ("U" . shr-copy-url)
         ("D" . my/eww-download-image-at-point))
  :custom
  (eww-search-prefix "https://duckduckgo.com/html/search?q=")
  (eww-auto-rename-buffer 'title)
  (eww-browse-url-new-window-is-tab nil)
  (eww-download-directory (expand-file-name "~/Downloads/"))
  (eww-use-external-browser-for-content-type "\\`\\(video/\\|audio\\)")
  (shr-use-fonts nil)
  (shr-use-colors nil)
  (shr-indentation 2)
  (shr-width 100)
  (shr-max-width 120)
  (shr-max-image-size '(800 . 600))
  (shr-image-animate t)
  :config
  (defun my/browse-url-mpv (url &rest _)
    (start-process "mpv" nil "mpv" url))

  (defun my/browse-url-pdf (url &rest _)
    "Fetch the remote PDF at URL and view it in Emacs."
    (let ((file (make-temp-file "emacs-pdf-" nil ".pdf")))
      (url-copy-file url file t)
      (find-file-other-window file)))

  (defun my/eww-download-image-at-point ()
    "Download the image at point to `eww-download-directory'."
    (interactive)
    (if-let* ((url (or (get-text-property (point) 'image-url)
                       (get-text-property (point) 'shr-url))))
        (let* ((name (file-name-nondirectory (or (url-filename (url-generic-parse-url url)) "")))
               (dest (expand-file-name (if (string-empty-p name)
                                           (format-time-string "eww-image-%Y%m%d-%H%M%S")
                                         name)
                                       eww-download-directory)))
          (url-copy-file url dest t)
          (message "Saved: %s" dest))
      (message "No image at point")))

  ;; Once EWW is in use, open links in it, except videos and PDFs.
  (setq browse-url-handlers
        '(("\\(youtube\\.com\\|youtu\\.be\\|vimeo\\.com\\|twitch\\.tv\\)" . my/browse-url-mpv)
          ("\\.mp4\\'" . my/browse-url-mpv)
          ("\\.pdf\\'" . my/browse-url-pdf))
        browse-url-browser-function #'eww-browse-url)

  (add-hook 'eww-mode-hook
            (lambda ()
              (face-remap-add-relative
               'header-line :height 0.9
               :box `(:line-width 1 :color ,(face-background 'default))))))

(use-package webjump
  :bind ("C-x /" . webjump)
  :custom
  (webjump-sites
   '(("DuckDuckGo" . [simple-query "www.duckduckgo.com" "www.duckduckgo.com/?q=" ""])
     ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
     ("YouTube" . [simple-query "www.youtube.com/feed/subscriptions" "www.youtube.com/results?search_query=" ""])
     ("ChatGPT" . [simple-query "https://chatgpt.com" "https://chatgpt.com/?q=" ""])))
  :config
  (define-advice webjump (:around (orig &rest args) external)
    (let ((browse-url-browser-function #'browse-url-generic)
          (browse-url-handlers nil))
      (apply orig args))))

;;; Reading: dictionary, spelling, PDF

(setq dictionary-server "dict.org"
      ispell-program-name "hunspell"
      ispell-dictionary "en_US"
      flyspell-abbrev-p nil
      flyspell-use-meta-tab nil)

(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :bind (:map pdf-view-mode-map ("O" . my/pdf-view-open-file))
  :config
  (pdf-tools-install :no-query)
  (defun my/pdf-view-open-file ()
    "Open the PDF in the system viewer."
    (interactive)
    (call-process "open" nil 0 nil (buffer-file-name))))

;;; LLM

(use-package gptel
  :ensure t
  :bind (:map gptel-mode-map
              ("C-c C-n" . my/gptel-next-prompt)
              ("C-c C-p" . my/gptel-previous-prompt))
  :custom
  (gptel-default-mode 'org-mode)
  (gptel-log-level 'info)
  (gptel-include-reasoning 'ignore)
  (gptel-use-tools t)
  (gptel-track-media t)
  (gptel-use-context nil)
  (gptel-use-header-line t)
  (gptel-org-branching-context t)
  (gptel-expert-commands t)
  (gptel-prompt-prefix-alist
   '((markdown-mode . "## User: ") (org-mode . "* Prompt: ") (text-mode . "User: ")))
  (gptel-response-prefix-alist
   '((markdown-mode . "## Assistant\n") (org-mode . "** Response:") (text-mode . "Assistant: ")))
  :init
  (defun my/proofread (instruction)
    "Rewrite the region or paragraph with gptel following INSTRUCTION."
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook (lambda () (insert instruction))
      (call-interactively #'gptel-rewrite)))
  (defun my/proofread-dwim ()
    "Fix grammar and spelling of the region or paragraph."
    (interactive)
    (my/proofread "Fix grammar, spelling and punctuation. Preserve tone and meaning."))
  (defun my/proofread-formal ()
    "Proofread and raise the register to formal."
    (interactive)
    (my/proofread "Fix grammar and spelling, then rewrite in a formal professional tone."))
  :config
  (setq gptel-model 'gpt-5.6-sol
        gptel-backend (gptel-make-openai-oauth "OpenAI-sub"))
  (make-variable-buffer-local 'gptel-context)

  (defun my/gptel-previous-prompt ()
    (interactive)
    (goto-char (line-beginning-position))
    (when (search-backward (gptel-prompt-prefix-string) nil t)
      (goto-char (line-end-position))))

  (defun my/gptel-next-prompt (&rest _)
    (interactive)
    (goto-char (line-end-position))
    (when (search-forward (gptel-prompt-prefix-string) nil t)
      (goto-char (line-end-position))))

  (defun my/gptel-remove-extra-whitespace (beg end)
    "Collapse excess blank lines in the response from BEG to END."
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        (goto-char (point-min))
        (while (re-search-forward "\n\n\n+" nil t)
          (replace-match "\n\n")))))

  (add-hook 'gptel-post-response-functions #'my/gptel-remove-extra-whitespace)
  (add-hook 'gptel-post-response-functions #'my/gptel-next-prompt 10))

;; NonGNU ELPA has an unrelated `codex-ide'; register this one's spec first.
(with-eval-after-load 'package-vc
  (setf (alist-get 'codex-ide package-vc-selected-packages)
        '(:url "https://github.com/dgillis/emacs-codex-ide" :lisp-dir ".")))
(use-package codex-ide
  :vc (:url "https://github.com/dgillis/emacs-codex-ide" :lisp-dir "." :rev :newest)
  :commands codex-ide-menu
  :init
  ;; Not activated at startup (see `package-load-list' in post-early-init.el).
  (add-to-list 'load-path (locate-user-emacs-file "elpa/codex-ide"))
  :custom
  (codex-ide-fast "on"))

;;; RSS

(use-package elfeed
  :ensure t
  :bind (("C-c l r" . elfeed)
         :map elfeed-search-mode-map
         ("o" . my/elfeed-search-other-window)
         ("d" . my/elfeed-toggle-starred)
         ("l" . my/elfeed-toggle-readlater)
         ("i" . my/elfeed-toggle-important)
         :map elfeed-show-mode-map
         ("M-." . dictionary-lookup-definition)
         ("x" . my/elfeed-show-visit-xwidget))
  :hook (elfeed-show-mode . variable-pitch-mode)
  :config
  (defun my/elfeed-load-feeds ()
    "Read `elfeed-feeds' and feed titles from the Org links in elfeed.org.
Each link heading's tags become the feed's tags."
    (with-temp-buffer
      (insert-file-contents (locate-user-emacs-file "elfeed.org"))
      (setq elfeed-feeds nil)
      (while (re-search-forward
              "^\\*+ +\\[\\[\\([^]]+\\)\\]\\[\\([^]]+\\)\\]\\][ \t]*\\(:[^ \t\n]+:\\)?" nil t)
        (let ((url (match-string 1))
              (title (match-string 2))
              (tags (split-string (or (match-string 3) "") ":" t)))
          (push (cons url (mapcar #'intern tags)) elfeed-feeds)
          (elfeed-meta--put (elfeed-db-get-feed url) :title title))))
    (setq elfeed-feeds (nreverse elfeed-feeds)))
  (advice-add 'elfeed :before #'my/elfeed-load-feeds)

  (dolist (tag '(starred readlater important))
    (defalias (intern (format "my/elfeed-toggle-%s" tag))
      (lambda () (interactive) (elfeed-search-toggle-all tag))
      (format "Toggle the %s tag on the selected entries." tag)))

  (defun my/elfeed-search-other-window ()
    "Show the selected entry in the other window."
    (interactive)
    (let ((entry (elfeed-search-selected :ignore-region)))
      (delete-other-windows)
      (select-window (split-window-right))
      (elfeed-search-show-entry entry)))

  (defun my/elfeed-show-visit-xwidget (&optional generic)
    "Visit the entry with xwidget-webkit, or with the GENERIC browser."
    (interactive "P")
    (when-let* ((link (elfeed-entry-link elfeed-show-entry)))
      (if generic (browse-url link) (xwidget-webkit-browse-url link)))))

;;; Speech and screenshots

(defvar my/piper-binary "~/.local/bin/piper")
(defvar my/piper-model "~/.local/share/piper/models/en_US-ryan-high.onnx")

(defun my/tts-piper (&optional arg)
  "Read text aloud with piper.
Read the region, a prompted text with \\[universal-argument], ARG lines
with a numeric prefix, or else from point to the end of the buffer."
  (interactive "P")
  (let ((text (cond ((use-region-p)
                     (buffer-substring-no-properties (region-beginning) (region-end)))
                    ((consp arg) (read-string "Enter text: "))
                    (arg (buffer-substring-no-properties
                          (point) (save-excursion (forward-line arg) (point))))
                    (t (buffer-substring-no-properties (point) (point-max))))))
    (make-process
     :name "piper" :buffer "*piper*"
     :command (list (expand-file-name my/piper-binary)
                    "--model" (expand-file-name my/piper-model) "--"
                    (replace-regexp-in-string "\\([a-z]\\)'\\([a-z]\\)" "\\1 \\2" text)))))
(keymap-global-set "C-x s" #'my/tts-piper)

(defun my/mac-screencapture (&optional arg)
  "Take a screenshot with macOS screencapture.
No prefix: region to clipboard.     C-u: frame to clipboard.
C-u C-u: region to file.            C-u C-u C-u: frame to file."
  (interactive "P")
  (let* ((frame-id (frame-parameter nil 'outer-window-id))
         (frame (and (member arg '((4) (64))) t))
         (file (and (member arg '((16) (64)))
                    (expand-file-name
                     (read-file-name "Save screenshot to: " nil nil nil
                                     (format-time-string "screenshot-%Y%m%d-%H%M%S.png"))))))
    (apply #'call-process "screencapture" nil nil nil
           (append (cond ((not frame) '("-s"))
                         (frame-id (list "-l" frame-id))
                         (t '("-w")))
                   (if file (list file) '("-c"))))
    (message (if file "Screenshot saved to %s" "Screenshot copied to clipboard") file)))

(provide 'my-tools)
;;; my-tools.el ends here
