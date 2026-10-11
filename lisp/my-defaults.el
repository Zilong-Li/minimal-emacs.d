;;; my-defaults.el --- Built-in defaults -*- lexical-binding: t; -*-

;; Settings already provided by minimal-emacs.d's init.el are not repeated.

;;; Customization file

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;; Behaviour

(setq initial-major-mode 'text-mode
      initial-buffer-choice t           ; Open *scratch* at startup
      pop-up-windows nil
      show-help-function nil
      column-number-mode t
      completion-ignore-case t
      completions-detailed t
      find-ls-option '("-exec ls -ldh {} +" . "-ldh")
      ibuffer-human-readable-size t
      native-comp-async-on-battery-power nil
      ;; Scrolling
      scroll-conservatively 101
      scroll-margin 0
      recenter-positions '(5 bottom)
      pixel-scroll-precision-use-momentum nil
      ;; Mouse
      mouse-1-click-follows-link nil
      dired-mouse-drag-files t
      mouse-drag-and-drop-region-cross-program t
      ;; Text
      truncate-string-ellipsis "…"
      x-underline-at-descent-line nil
      x-use-underline-position-properties t
      underline-minimum-offset 10)

(setq-default cursor-type '(hbar . 2))

(prefer-coding-system 'utf-8)
(set-language-environment "English")

(delete-selection-mode 1)
(pixel-scroll-precision-mode 1)
(global-goto-address-mode 1)             ; C-c RET opens the URL at point
(mouse-avoidance-mode 'exile)
(add-hook 'text-mode-hook #'visual-line-mode)

(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (keymap-global-set "<mouse-4>" #'scroll-down-line)
  (keymap-global-set "<mouse-5>" #'scroll-up-line))

;;; Files, backups and auto-save

(setq auto-save-timeout 20
      auto-save-interval 200
      make-backup-files t
      vc-make-backup-files t
      kept-old-versions 6
      kept-new-versions 9)

(use-package autorevert
  :custom
  (auto-revert-use-notify nil)
  (auto-revert-verbose nil)
  :config
  (global-auto-revert-mode 1))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets)
  (uniquify-separator " • ")
  (uniquify-after-kill-buffer-p t)
  (uniquify-ignore-buffers-re "^\\*"))

(use-package recentf
  :defer 0.5
  :custom
  (recentf-max-saved-items 20)
  (recentf-auto-cleanup 60)
  (recentf-exclude
   `("~\\'" "\\`out\\'" "\\.log\\'" "\\.mp3\\'" "^/[^/]*:" "\\.el\\.gz\\'"
     ;; Agenda files are opened constantly; keep them out of the list.
     ,(lambda (file)
        (and (bound-and-true-p org-directory)
             (string-prefix-p (expand-file-name org-directory)
                              (expand-file-name file))))))
  :config
  (recentf-mode 1))

;;; History

(setq kill-ring-max 50
      history-length 50
      history-delete-duplicates t
      savehist-additional-variables
      '(kill-ring command-history register-alist search-ring regexp-search-ring))

(add-hook 'kill-emacs-hook
          (lambda () (setq kill-ring (mapcar #'substring-no-properties kill-ring))))
(savehist-mode 1)

;;; Platform

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
        ns-function-modifier 'hyper     ; Fn key as hyper (H)
        insert-directory-program "gls") ; GNU ls for Dired

  ;; Share the macOS clipboard in terminal frames.
  (unless (display-graphic-p)
    (setq interprogram-cut-function
          (lambda (text)
            (let ((process-connection-type nil))
              (let ((proc (start-process "pbcopy" nil "pbcopy")))
                (process-send-string proc text)
                (process-send-eof proc))))
          interprogram-paste-function
          (lambda () (shell-command-to-string "pbpaste")))))

(dolist (directory (list (expand-file-name "~/.local/bin")
                         "/Library/TeX/texbin" "/opt/homebrew/bin"))
  (add-to-list 'exec-path directory t)
  (unless (member directory (parse-colon-path (or (getenv "PATH") "")))
    (setenv "PATH" (concat (getenv "PATH") path-separator directory))))

(setq shell-file-name "/bin/bash"
      explicit-shell-file-name "/bin/bash")

;;; Server

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (or (daemonp) (server-running-p))
              (server-start))))

(provide 'my-defaults)
;;; my-defaults.el ends here
