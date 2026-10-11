;;; my-config-messages.el --- Personal messages configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my-messages-buffer-keybindings ()
  "Custom key bindings for *Messages* buffer."
  (local-set-key (kbd "a") 'other-window)
  (local-set-key (kbd "q") 'bury-buffer)         ; Press 'q' to bury the buffer
  (local-set-key (kbd "C-c C-l") 'message-clear-log) ; Press 'C-c C-l' to clear messages
  (local-set-key (kbd "g") 'revert-buffer))      ; Press 'g' to refresh the buffer

(add-hook 'messages-buffer-mode-hook 'my-messages-buffer-keybindings)

(provide 'my-config-messages)
;;; my-config-messages.el ends here
