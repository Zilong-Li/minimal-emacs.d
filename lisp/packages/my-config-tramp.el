;;; my-config-tramp.el --- Personal tramp configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq shell-file-name "/bin/bash")
(setq sh-shell "/bin/bash")
(setq sh-shell-file "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")
(setq auth-source-cache-expiry nil) ;; cache password never expires

(defun set-tramp-display-from-file ()
  "Read DISPLAY value from remote ~/.display.txt and set it for TRAMP."
  (when (file-remote-p default-directory)
    (let* ((remote-host (file-remote-p default-directory 'host))
           (display
            (with-tramp-connection-property
                (get-process "dummy") remote-host "display"
              (let ((display-file (expand-file-name "~/.display.txt")))
                (if (file-exists-p display-file)
                    (with-temp-buffer
                      (insert-file-contents display-file)
                      (format "DISPLAY=%s" (string-trim (buffer-string))))
                  "DISPLAY=localhost:10.0")))))
      (add-to-list 'tramp-remote-process-environment display))))

(with-eval-after-load 'tramp
  ;; won't work with ess R
  ;; Enable full-featured Dirvish over TRAMP on certain connections
  ;; https://www.gnu.org/software/tramp/#Improving-performance-of-asynchronous-remote-processes-1.
  ;; (add-to-list 'tramp-connection-properties
  ;;              (list (regexp-quote "/ssh:")
  ;;                    "direct-async-process" t))
  (setq tramp-chunksize 2000)
  (setq tramp-verbose 1)
  (setq tramp-default-method "ssh")  ;; use scpx to speed up if ssh is slow
  (setq tramp-remote-path (append tramp-remote-path '(tramp-own-remote-path)))
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                vc-ignore-dir-regexp
                tramp-file-name-regexp))
  (add-to-list 'password-word-equivalents "Second Factor")
  (add-to-list 'password-word-equivalents "First Factor")
  ;; (add-to-list 'tramp-remote-process-environment (format "DISPLAY=%s" (getenv "DISPLAY")))
  (add-hook 'tramp-connected-hook #'set-tramp-display-from-file)
  )

(bind-key "C-c l k" #'tramp-cleanup-all-connections)

(provide 'my-config-tramp)
;;; my-config-tramp.el ends here
