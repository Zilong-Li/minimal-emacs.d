;;; my-config-popper.el --- Personal popper configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package popper
  :defer t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         )
  :init
  (setq popper-reference-buffers
        '("\\*\\(?:[^*]\\|\\(?:[^*]-\\)+\\)*ghostel\\*" ghostel-mode ; ghostel as a popup
          "\\*\\([Pp]ython\\|[Jj]ulia\\)\\*"
          "\\*R\\(?:.*\\)?\\*"
          "^\\*eshell.*\\*$" eshell-mode ; eshell as a popup
          "^\\*shell.*\\*$"  shell-mode  ; shell as a popup
          "\\*Messages\\*"
          help-mode
          ess-r-help-mode
          compilation-mode))
  (setq popper-display-control nil) ; buffers are managed by `display-buffer-alist'
  (popper-mode +1)
  (popper-echo-mode +1)  ; For echo area hints
  )

(provide 'my-config-popper)
;;; my-config-popper.el ends here
