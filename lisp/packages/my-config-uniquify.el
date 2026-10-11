;;; my-config-uniquify.el --- Personal uniquify configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets) ; or 'reverse
  (uniquify-separator " • ")
  (uniquify-after-kill-buffer-p t)
  (uniquify-ignore-buffers-re "^\\*")
  )

(provide 'my-config-uniquify)
;;; my-config-uniquify.el ends here
