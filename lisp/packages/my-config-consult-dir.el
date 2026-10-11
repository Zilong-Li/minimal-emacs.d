;;; my-config-consult-dir.el --- Personal consult-dir configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(my/report-time "Completion")

(provide 'my-config-consult-dir)
;;; my-config-consult-dir.el ends here
