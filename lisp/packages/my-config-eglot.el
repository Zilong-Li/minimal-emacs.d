;;; my-config-eglot.el --- Personal eglot configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package eglot
  :preface
  (defun my/mp-eglot-eldoc ()
    (setq eldoc-documentation-strategy
          'eldoc-documentation-compose-eagerly)
    ;; (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
    ;; Show flymake diagnostics first.
    (setq eldoc-documentation-functions
                      (cons #'flymake-eldoc-function
                            (remove #'flymake-eldoc-function
                                    eldoc-documentation-functions)))
    )
  :hook ((eglot-managed-mode . my/mp-eglot-eldoc))
  :bind (("C-c l e" . eglot)
         :map eglot-mode-map
              ("C-x C-t" . eglot-format) ;; override transpose-line
              ("C-x C-w" . eglot-rename) ;; override write-file
              ("C-c C-." . eglot-code-actions)
              )
  :config
  (setq read-process-output-max (* 1024 1024)) ; 1 Mb
  (setq completion-category-defaults nil) ;; disable completion-styles

  ;; (push :inlayHintProvider eglot-ignored-server-capabilities) ;; permenat disable eglot-inlay-hints-mode
  (push :documentHighlightProvider eglot-ignored-server-capabilities)


  ;; rust
  ;; (add-to-list 'eglot-server-programs
  ;;              '((rust-ts-mode rust-mode) .
  ;;                ("rust-analyzer" :initializationOptions (:check (:command "clippy")))))

  ;; python
  ;; (add-to-list 'eglot-server-programs '((python-mode)
  ;;                                       . ("pylsp")))
  ;; ruff :linting
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["ruff"]
                                                   :plugins (
                                                             :ruff (:enabled t :lineLength 88)
                                                             :pycodestyle (:enabled :json-false)
                                                             :mccabe (:enabled :json-false)
                                                             :pyflakes (:enabled :json-false)
                                                             :flake8 (:enabled :json-false :maxLineLength 88)
                                                             :autopep8 (:enabled :json-false)
                                                             :yapf (:enabled :json-false)
                                                             :pydocstyle (:enabled :json-false :convention "numpy")
                                                             )))))

  )

(provide 'my-config-eglot)
;;; my-config-eglot.el ends here
