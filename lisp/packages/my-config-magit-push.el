;;; my-config-magit-push.el --- Personal magit-push configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package magit-push
  :defer t
  :config
  (transient-insert-suffix 'magit-push "p"
    '("P" "default" magit-push-current-to-upstream)))

(provide 'my-config-magit-push)
;;; my-config-magit-push.el ends here
