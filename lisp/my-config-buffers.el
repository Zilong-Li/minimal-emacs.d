;;; my-config-buffers.el --- Personal buffers configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(bind-key "C-c b s" #'scratch-buffer)
(bind-key "C-c b i" #'ibuffer)
(bind-key "C-c b k" #'kill-current-buffer)
(bind-key "C-x k" #'kill-buffer) ; select buffer to be killed

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(bind-key "C-c b r"   #'revert-buffer-no-confirm)
(bind-key "C-c b c"   #'compile) ; compile buffer
(bind-key "s-s"   #'save-buffer) ; hyper + s

(provide 'my-config-buffers)
;;; my-config-buffers.el ends here
