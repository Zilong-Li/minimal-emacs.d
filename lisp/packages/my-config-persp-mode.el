;;; my-config-persp-mode.el --- Personal persp-mode configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package persp-mode
  :bind
  ("C-c p s" . persp-kill)

  :custom
  (persp-keymap-prefix "s-p")  ; The setter calls kbd; pass a key description.
  (persp-nil-name "Home")
  (persp-autokill-buffer-on-remove 'kill-weak)

  :init
  (persp-mode 1)

  (defun my/check-and-abort-minibuffer (name frame)
    (when (active-minibuffer-window)
      (keyboard-escape-quit)))

  (setq persp-before-switch-functions #'my/check-and-abort-minibuffer)

  :config

  (defun my/persp-skip-save-buffer-p (buffer)
    "Exclude Magit and other transient BUFFERs from saved perspectives."
    (with-current-buffer buffer
      (or (string-match-p "\\`\\*?[Ee]diff" (buffer-name))
          (derived-mode-p 'magit-mode 'magit-repolist-mode)
          ;; Also cover Magit modes outside the magit-mode hierarchy.
          (string-prefix-p "magit-" (symbol-name major-mode))
          (memq major-mode '(ediff-mode comint-mode dired-mode PDFView)))))

  (add-to-list 'persp-filter-save-buffers-functions
               #'my/persp-skip-save-buffer-p)

  (defun my/persp-add-buffer (&optional buffer)
    "Add BUFFER to the current perspective when `persp-mode' is active."
    (when (and (bound-and-true-p persp-mode)
               (fboundp 'persp-add-buffer)
               (or (null buffer) (buffer-live-p buffer)))
      (with-current-buffer (or buffer (current-buffer))
        (unless (minibufferp)
          (ignore-errors
            (persp-add-buffer (current-buffer)))))))

  (defun my/persp-add-visible-buffers ()
    "Add visible buffers in the selected frame to the current perspective."
    (when (and (bound-and-true-p persp-mode)
               (fboundp 'persp-add-buffer))
      (dolist (window (window-list nil 'no-minibuf))
        (my/persp-add-buffer (window-buffer window)))))

  ;; Define our smarter buffer filter
  (defun my/persp-buffer-filter-predicate (buffer)
    "Filter buffers based on perspective context:
   - In default perspective: only show buffers not in any other perspective
   - In named perspective: only show buffers in that perspective
   - Always exclude ephemeral buffers (starting with *)"
    (let ((buf-name (buffer-name buffer))
          (current-persp (get-current-persp)))
      ;; First, exclude ephemeral buffers
      (when (not (string-match-p "^\\*\\(splash\\|Warning\\|Compile-Log\\|Async\\|Backtrace\\)" buf-name))
        (if (null current-persp)
            ;; In default/nil perspective: show only buffers not in any other perspective
            (not (cl-some (lambda (p)
                            (and (not (eq p current-persp))
                                 (memq buffer (persp-buffers p))))
                          (persp-persps)))
          ;; In named perspective: show only buffers in this perspective
          (memq buffer (persp-buffers current-persp))))))

  (with-eval-after-load 'consult
    (defvar persp-consult-source
      (list :name     "Persp"
            :narrow   ?s
            :category 'buffer
            :state    #'consult--buffer-state
            :history  'buffer-name-history
            :default  t
            :items
            #'(lambda () (consult--buffer-query :sort 'visibility
                                                :predicate 'my/persp-buffer-filter-predicate
                                                :as #'buffer-name))))
    (add-to-list 'consult-buffer-sources persp-consult-source))


  (with-eval-after-load 'elfeed
    ;; Define an auto-perspective for elfeed buffers
    (persp-def-auto-persp "RSS"
                          :parameters '((dont-save-to-file . t))
                          :buffer-name "^\\*elfeed-\\(search\\|entry\\)"
                          :dyn-env '(after-switch-to-buffer-functions ;; prevent recursion
                                     (persp-add-buffer-on-find-file nil)
                                     persp-add-buffer-on-after-change-major-mode)
                          :switch 'frame
                          ))

  )

(my/report-time "Perspectives")

(setq my/section-start-time (current-time))

(provide 'my-config-persp-mode)
;;; my-config-persp-mode.el ends here
