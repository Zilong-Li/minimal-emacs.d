;;; my-config-clipboard.el --- Personal clipboard configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq-default select-enable-clipboard t) ; Merge system's and Emacs' clipboard
;; (setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-selection-value)
(bind-key "s-c" #'clipboard-kill-ring-save) ;; copy
(bind-key "s-v" #'clipboard-yank) ;; paste

(defun my/paste-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun my/copy-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(when (and (not (display-graphic-p))
           (eq system-type 'darwin))
  (setq interprogram-cut-function   #'my/copy-to-osx
        interprogram-paste-function #'my/paste-from-osx))

;; https://emacs.stackexchange.com/questions/19982/hunspell-error-in-emacs

(provide 'my-config-clipboard)
;;; my-config-clipboard.el ends here
