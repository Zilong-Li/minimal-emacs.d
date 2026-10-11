;;; my-config-magit-pull.el --- Personal magit-pull configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package magit-pull
  :defer t
  :config
  (transient-insert-suffix 'magit-pull "p"
    '("F" "default" magit-fetch-from-upstream)))

(provide 'my-config-magit-pull)
;;; my-config-magit-pull.el ends here
