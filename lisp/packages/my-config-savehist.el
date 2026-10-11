;;; my-config-savehist.el --- Personal savehist configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun unpropertize-kill-ring ()
  (setq kill-ring (mapcar 'substring-no-properties kill-ring)))

(add-hook 'kill-emacs-hook 'unpropertize-kill-ring)

(require 'savehist)

(setq kill-ring-max 50
      history-length 50)

(setq savehist-additional-variables
      '(kill-ring
        command-history
        set-variable-value-history
        custom-variable-history
        query-replace-history
        read-expression-history
        minibuffer-history
        read-char-history
        face-name-history
        bookmark-history
        file-name-history))

 (put 'minibuffer-history         'history-length 50)
 (put 'file-name-history          'history-length 50)
 (put 'set-variable-value-history 'history-length 25)
 (put 'custom-variable-history    'history-length 25)
 (put 'query-replace-history      'history-length 25)
 (put 'read-expression-history    'history-length 25)
 (put 'read-char-history          'history-length 25)
 (put 'face-name-history          'history-length 25)
 (put 'bookmark-history           'history-length 25)

(setq history-delete-duplicates t)

(let (message-log-max)
  (savehist-mode))

(my/report-time "History")

(provide 'my-config-savehist)
;;; my-config-savehist.el ends here
