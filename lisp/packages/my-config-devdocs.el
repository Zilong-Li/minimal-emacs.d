;;; my-config-devdocs.el --- Personal devdocs configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package devdocs
  :defer t
  :bind
  (("C-h d" . gopar/devdocs-lookup)
   ("C-h C-d" . gopar/devdocs-lookup))
  :init
  (add-to-list 'display-buffer-alist
               '("\\*devdocs\\*"
                 display-buffer-in-side-window
                 (side . right)
                 (slot . 3)
                 (window-width . 0.4)
                 (window-parameters . ((no-delete-other-windows . t)))
                 (dedicated . t)))

  (defun gopar/devdocs-lookup (&optional ask-docs)
    "Light wrapper around `devdocs-lookup` which pre-populates the function input with thing at point"
    (interactive "P")
    (let ((query (thing-at-point 'symbol t)))
      (devdocs-lookup ask-docs query)))


  :hook (((python-mode python-ts-mode) . (lambda ()
                                           (setq-local devdocs-current-docs
                                                       '("python~3.10"))))
         ((c++-mode c++-ts-mode) . (lambda ()
                                     (setq-local devdocs-current-docs
                                                 '("cpp"))))
         ((rust-mode rust-ts-mode) . (lambda ()
                                       (setq-local devdocs-current-docs
                                                   '("rust"))))
         (ess-r-mode . (lambda ()
                         (setq-local devdocs-current-docs
                                     '("r"))))
         )
  )

(provide 'my-config-devdocs)
;;; my-config-devdocs.el ends here
