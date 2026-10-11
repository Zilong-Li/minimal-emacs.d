;;; my-config-embark.el --- Personal embark configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package embark
  :bind
  (:map global-map
        ("C-;" . embark-dwim)
        ("C-." . embark-act)
        ("C-h B" . embark-bindings) ;; alternative for `describe-bindings'
        :map embark-region-map
        ("U" . 0x0-dwim)
        ("S" . my/search-query)
        :map embark-file-map
        ("x" . my/xwidget-browse-file)
        :map embark-url-map
        ("x" . xwidget-webkit-browse-url)
        )

  :init

  (defun my/xwidget-browse-file (file)
    "Open FILE in xwidget-webkit-browse-url."
    (xwidget-webkit-browse-url
     (concat "file://" (expand-file-name file))))

  (defvar my/search-engine-url
    "https://duckduckgo.com/html/?q=%s"
    "Search URL used by my search commands.")

  (defun my/search-query (query)
    "Search QUERY using `browse-url'."
    (interactive "sSearch: ")
    (browse-url
     (format my/search-engine-url
             (url-hexify-string query))))

  (defun my/search-thing-at-point-or-prompt ()
    "Search active region, symbol at point, or prompt."
    (interactive)
    (my/search-query
     (cond
      ((use-region-p)
       (buffer-substring-no-properties
        (region-beginning)
        (region-end)))
      ((thing-at-point 'symbol t))
      (t
       (read-string "Search: ")))))

  ;; replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  (setq embark-cycle-key ".") ; https://github.com/oantolin/embark/issues/786

  :config


  (with-eval-after-load 'vertico
    (vertico-multiform-mode) ; make which-key like help
    (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))
    )

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.

(provide 'my-config-embark)
;;; my-config-embark.el ends here
