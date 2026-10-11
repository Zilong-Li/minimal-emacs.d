;;; my-config-web-mode.el --- Personal web-mode configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.php\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.tsx?\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-closing t
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-quoting t
        web-mode-enable-current-element-highlight t))

(provide 'my-config-web-mode)
;;; my-config-web-mode.el ends here
