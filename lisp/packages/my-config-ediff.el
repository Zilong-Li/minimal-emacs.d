;;; my-config-ediff.el --- Personal ediff configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ediff
  :defer t
  :custom
  (ediff-combination-pattern
   '("<<<<<<< A: HEAD" A "||||||| Ancestor" Ancestor "=======" B ">>>>>>> B: Incoming"))
  (ediff-diff-options "-w")
  (ediff-highlight-all-diffs nil)
  (ediff-show-clashes-only t)
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally)
  )

(provide 'my-config-ediff)
;;; my-config-ediff.el ends here
