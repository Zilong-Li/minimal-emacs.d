;;; my-config-outline-indent.el --- Personal outline-indent configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package outline-indent
  :ensure nil
  :commands outline-indent-minor-mode
  :custom
  (outline-indent-ellipsis " ▼")
  :hook
  ((python-mode . outline-indent-minor-mode)
   (python-ts-mode . outline-indent-minor-mode)
   (yaml-mode . outline-indent-minor-mode)
   (yaml-ts-mode . outline-indent-minor-mode)
   (haskell-mode . outline-indent-minor-mode)))

(provide 'my-config-outline-indent)
;;; my-config-outline-indent.el ends here
