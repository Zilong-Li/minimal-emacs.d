;;; my-config-ultra-scroll.el --- Personal ultra-scroll configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(provide 'my-config-ultra-scroll)
;;; my-config-ultra-scroll.el ends here
