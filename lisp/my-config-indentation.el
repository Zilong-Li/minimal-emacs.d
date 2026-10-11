;;; my-config-indentation.el --- Personal indentation configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq-default indent-tabs-mode nil        ; Stop using tabs to indent
              tab-always-indent 'complete ; Indent first then try completions
              tab-width 4)                ; Smaller width for tab characters

(remove-hook 'find-file-hooks 'vc-find-file-hook)

(provide 'my-config-indentation)
;;; my-config-indentation.el ends here
