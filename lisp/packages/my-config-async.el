;;; my-config-async.el --- Personal async configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package async
  :defer t
  :config
  (dired-async-mode 1))

(provide 'my-config-async)
;;; my-config-async.el ends here
