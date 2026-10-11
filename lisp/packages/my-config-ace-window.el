;;; my-config-ace-window.el --- Personal ace-window configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ace-window
  :defer t
  :bind ("M-o" . ace-window)
  :custom
  (aw-dispatch-when-more-than 3)
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-ignore-on t)
  )

(with-eval-after-load 'ace-window
    (when (boundp 'aw-ignored-buffers)
      (add-to-list 'aw-ignored-buffers "*Dired-Side*")))

(provide 'my-config-ace-window)
;;; my-config-ace-window.el ends here
