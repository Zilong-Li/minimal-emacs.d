;;; my-config-capf-autosuggest.el --- Personal capf-autosuggest configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package capf-autosuggest
  :defer t
  :hook ((eshell-mode . capf-autosuggest-mode)
         (comint-mode . capf-autosuggest-mode))
  :custom
  (capf-autosuggest-dwim-next-line nil))

(provide 'my-config-capf-autosuggest)
;;; my-config-capf-autosuggest.el ends here
