;;; my-config-corfu.el --- Personal corfu configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package corfu
  :commands (corfu-mode global-corfu-mode)
  ;; Optional customizations
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-auto nil)                 ;; Enable auto completion
  (corfu-auto-prefix 2)          ;; Minimum 3 chars for completion
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-separator 32)           ;; SPC as seperator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match t)         ; Quit immediately when no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 6)        ;; Use scroll margin
  (corfu-preselect 'prompt)      ;; Always preselet the prompt
  ;; Enable indentation+completion using the TAB key.
  (tab-always-indent 'complete)  ;; only works in prog-mode, otherwise invoking `completion-at-point'
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)

  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("S-<return>" . corfu-insert))
  :bind
  (:map global-map
        ("C-<tab>" . completion-at-point))

  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  )

(provide 'my-config-corfu)
;;; my-config-corfu.el ends here
