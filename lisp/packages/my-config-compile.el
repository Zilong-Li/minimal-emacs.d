;;; my-config-compile.el --- Personal compile configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package compile
  :defer t
  :custom
  (compilation-scroll-output 'first-error)
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-context-lines 10)
  )

;; when M-x compile RET grep --color=always -r i .
;; handling ansi color escape

(provide 'my-config-compile)
;;; my-config-compile.el ends here
