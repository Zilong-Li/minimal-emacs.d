;;; my-config-org-capture.el --- Personal org-capture configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq org-outline-path-complete-in-steps nil)
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets
      '(
        ("life.org" :maxlevel . 1)
        ("bookmarks.org" :maxlevel . 2)
        ("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("c" "org-protocol-capture" entry (file "inbox.org")
         "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
        ("B" "Bookmarks" entry  (file+headline "bookmarks.org" "Reading")
        ,(concat "* TODO %?\n"))
        ("m" "Meeting" entry  (file+headline "life.org" "Events")
        ,(concat "* %? :meeting:\n"))
        ))

(bind-key "C-c c" #'org-capture)

(defun my/org-capture-meeting ()
  (interactive)
  (org-capture nil "m"))

(bind-key "C-c m" #'my/org-capture-meeting)

(defun my/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(bind-key "C-c i" #'my/org-capture-inbox)

(defun my/org-capture-bookmark ()
  (interactive)
  (org-capture nil "B"))

(bind-key "C-c B" #'my/org-capture-bookmark)

(defun my/org-capture-mu4e ()
  (interactive)
  (org-capture nil "@"))

(bind-key "C-c @" #'my/org-capture-mu4e)

(with-eval-after-load 'org-capture

  (defun org-capture-place-template (&optional inhibit-wconf-store)
    "Insert the template at the target location, and display the buffer.
when `inhibit-wconf-store', don't store the window configuration, as it
may have been stored before."
    (unless inhibit-wconf-store
      (org-capture-put :return-to-wconf (current-window-configuration)))
    ;; (delete-other-windows)
    ;; (org-switch-to-buffer-other-window
    ;;  (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
    (select-window (split-window-below -10))
    (switch-to-buffer
     (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
    (widen)
    (org-show-all)
    (goto-char (org-capture-get :pos))
    (setq-local outline-level 'org-outline-level)
    (pcase (org-capture-get :type)
      ((or `nil `entry) (org-capture-place-entry))
      (`table-line (org-capture-place-table-line))
      (`plain (org-capture-place-plain-text))
      (`item (org-capture-place-item))
      (`checkitem (org-capture-place-item)))
    (setq-local org-capture-current-plist org-capture-plist)
    (org-capture-mode 1)))

(provide 'my-config-org-capture)
;;; my-config-org-capture.el ends here
