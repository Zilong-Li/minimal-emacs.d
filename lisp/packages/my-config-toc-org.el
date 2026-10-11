;;; my-config-toc-org.el --- Personal toc-org configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package toc-org
  :defer t
  :after org
  :hook
  (org-mode . toc-org-mode)
  )

(provide 'my-config-toc-org)
;;; my-config-toc-org.el ends here
