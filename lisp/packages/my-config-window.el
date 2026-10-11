;;; my-config-window.el --- Personal window configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package window
  :custom
  (switch-to-buffer-obey-display-actions t)
  (switch-to-buffer-in-dedicated-window 'pop)  ;; default nil
  (display-buffer-alist
   '(;; no window
     ("\\*Async Shell Command\\*"
      (display-buffer-no-window))

     ("\\`\\*\\(Warnings\\|Compile-Log\\|Org Links\\)\\*\\'"
      (display-buffer-no-window)
      (allow-no-window . t))

     ;; `eldoc-doc-buffer'
     ("^\\*eldoc" display-buffer-at-bottom
      (display-buffer-reuse-window display-buffer-pop-up-window))

     ;; bottom buffer (NOT side window)
     ((or . ((derived-mode . flymake-diagnostics-buffer-mode)
             (derived-mode . flymake-project-diagnostics-mode)
             (derived-mode . messages-buffer-mode)
             (derived-mode . backtrace-mode)))
      (display-buffer-reuse-mode-window display-buffer-at-bottom)
      (window-height . 0.4)
      (dedicated . t)
      (preserve-size . (t . t)))

     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*ghostel\\*"
      ;; (display-buffer-reuse-mode-window display-buffer-below-selected)
          ;; (dedicated . t)
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . 1)  ;; rightmost
      (window-height . 0.4)
      (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ;; bottom side windows
     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*e?shell\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . 1)  ;; rightmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ("\\*R\\|[Jj]ulia\\(?:.*\\)?\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . -1) ;; leftmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))

     ("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*[Pp]ython\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (slot . -1) ;; leftmost
      (window-height . 0.4)
      ;; (window-width . 0.5)
      (perserve-size . (t . t))
      (window-parameters . ((no-other-window . t)
                            (no-delete-other-windows . t))))


     ((derived-mode . ready-player-mode)
      (display-buffer-reuse-mode-window display-buffer-pop-up-frame)
      (window-height . fit-window-to-buffer)
      (window-width . fit-window-to-buffer)
      )

     ;; ("\\*mu4e.*\\*"
     ;;  (display-buffer-use-some-window)
     ;;  (body-function . (lambda (window) (delete-other-windows window)))
     ;;  )

     ("\\*Outline\\|\\*Easy\\(?:.*\\)?\\*"
      (display-buffer-in-side-window)
      (side . left)
      (window-width . 0.35)
      (window-parameters . ((no-delete-other-windows . t))))
     ))
  )

(provide 'my-config-window)
;;; my-config-window.el ends here
