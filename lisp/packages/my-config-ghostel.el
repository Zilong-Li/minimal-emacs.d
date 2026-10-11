;;; my-config-ghostel.el --- Personal ghostel configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ghostel
  :ensure nil
  :commands (my/toggle-ghostel ghostel ghostel-project)
  :bind (("C-c t t" . my/toggle-ghostel)
         ("C-c t o" . ghostel-other)
         ("C-c t e" . ghostel-emacs-mode)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . my/ghostel-send-C-k-and-kill)
         ;; ;; I'm used to go up/down the shell history with M-n/p from eshell
         ;; ;; Simulate this behavior in ghostel by sending C-p and C-n
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (setq ghostel-kill-buffer-on-exit t)
  ;; set term name to match the bashrc on the remote server
  ;; (setq ghostel-term "screen-256color")
  ;; (setq ghostel-shell "/bin/bash")
  ;; (set-face-attribute 'ghostel-default nil :background "#fffff0")

  (defun my/toggle-ghostel ()
    (interactive)
    (if (derived-mode-p 'ghostel-mode)
        (delete-window)
      (ghostel-project)))

  (defun my/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'ghostel-keymap-exceptions "M-o")
  (define-key ghostel-semi-char-mode-map (kbd "M-o") #'ace-window)
  (define-key ghostel-char-mode-map (kbd "M-o") #'ace-window)

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

(provide 'my-config-ghostel)
;;; my-config-ghostel.el ends here
