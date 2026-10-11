;;; my-config-embark-consult.el --- Personal embark-consult configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(provide 'my-config-embark-consult)
;;; my-config-embark-consult.el ends here
