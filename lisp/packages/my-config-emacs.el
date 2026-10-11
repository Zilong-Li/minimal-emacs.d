;;; my-config-emacs.el --- Personal emacs configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package emacs
  :ensure nil
  :bind
  (("RET" . newline-and-indent)
   ("M-j" . duplicate-dwim)
   ("C-z" . nil)
   ("C-x C-z" . nil)
   ("C-M-z" . delete-pair)
   ("C-x C-k RET" . nil))
  :custom
  (font-lock-maximum-decoration t) ; important for highlighting marks
  (indicate-empty-lines nil) ;; No empty line indicators
  (cursor-in-non-selected-windows nil) ;; No cursor in inactive windows
  (cursor-type '(hbar .  2)) ;; Bar cursor
  (cursor-in-non-selected-windows nil)
  (blink-cursor-mode nil)
  (pop-up-windows nil)        ; No popup windows
  (show-help-function nil)    ; No help text
  (use-file-dialog nil)       ; No file dialog
  (use-dialog-box nil)        ; No dialog box
  (initial-major-mode 'text-mode)
  (ad-redefinition-action 'accept)
  (auto-save-default t)
  (column-number-mode t)
  (line-spacing nil)
  (completion-ignore-case t)
  (completions-detailed t)
  (doc-view-resolution 200)
  (delete-by-moving-to-trash t)
  (delete-pair-blink-delay 0)
  (find-ls-option '("-exec ls -ldh {} +" . "-ldh"))  ; find-dired results with human readable sizes
  (global-auto-revert-non-file-buffers t)
  (global-goto-address-mode t)                            ;     C-c RET on URLs open in default browser
  (browse-url-secondary-browser-function 'eww-browse-url) ; C-u C-c RET on URLs open in EWW
  (help-window-select t)
  (history-length 300)
  (inhibit-startup-screen t)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (inhibit-startup-echo-area-message t) ; Disable initial echo message
  (ibuffer-human-readable-size t) ; EMACS-31
  (ispell-dictionary "en_US")
  (create-lockfiles nil)   ; No lock files
  (make-backup-files nil)  ; No backup files
  (native-comp-async-on-battery-power nil)  ; No compilations when on battery EMACS-31
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (read-answer-short t)
  (use-short-answers t); Replace yes/no prompts with y/n
  (confirm-nonexistent-file-or-buffer nil) ; Ok to visit non existent file
  (initial-buffer-choice t) ; Open *scratch* buffer at init
  :config
  ;; text display
  (add-hook 'text-mode-hook 'visual-line-mode)
  )



(setq my/section-start-time (current-time))

(provide 'my-config-emacs)
;;; my-config-emacs.el ends here
