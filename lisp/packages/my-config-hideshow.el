;;; my-config-hideshow.el --- Personal hideshow configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package hideshow
  :ensure nil
  :custom
  (hs-isearch-open t)
  :hook
  ((c-mode          . hs-minor-mode)
   (c++-mode        . hs-minor-mode)
   (c-ts-mode       . hs-minor-mode)
   (c++-ts-mode     . hs-minor-mode)
   (emacs-lisp-mode . hs-minor-mode)
   (java-mode       . hs-minor-mode)
   (java-ts-mode    . hs-minor-mode)
   (rust-mode       . hs-minor-mode)
   (rust-ts-mode    . hs-minor-mode)
   (go-mode         . hs-minor-mode)
   (go-ts-mode      . hs-minor-mode)
   (js-mode         . hs-minor-mode)
   (js-ts-mode      . hs-minor-mode)
   (typescript-mode    . hs-minor-mode)
   (typescript-ts-mode . hs-minor-mode)
   (css-mode        . hs-minor-mode)
   (css-ts-mode     . hs-minor-mode)
   (sh-mode         . hs-minor-mode)
   (bash-ts-mode    . hs-minor-mode)
   (js-json-mode    . hs-minor-mode)
   (json-ts-mode    . hs-minor-mode)
   (html-mode       . hs-minor-mode)
   (perl-mode       . hs-minor-mode)))

(provide 'my-config-hideshow)
;;; my-config-hideshow.el ends here
