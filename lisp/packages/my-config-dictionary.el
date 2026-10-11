;;; my-config-dictionary.el --- Personal dictionary configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package dictionary
  :defer t
  :init
  (add-to-list 'display-buffer-alist
               '("^\\*.*[Dd]ictionary\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.35)
                 ))
  :custom
  (dictionary-server "dict.org"))

;; https://github.com/abo-abo/define-word/blob/31a8c67405afa99d0e25e7c86a4ee7ef84a808fe/define-word.el#L161
(defun my/dict-lookup-word ()
  (interactive)
  (let ((word
         (cond
          ((eq major-mode 'pdf-view-mode)
           (car (pdf-view-active-region-text)))
          ((use-region-p)
           (buffer-substring-no-properties
            (region-beginning)
            (region-end)))
          (t
           (substring-no-properties
            (thing-at-point 'word))))))
    (start-process "goldendict" nil "goldendict" word)
    )
  )

(if (eq system-type 'darwin)
  (bind-key "C-c l d"   #'osx-dictionary-search-word-at-point)
  (bind-key "C-c l d"   #'my/dict-lookup-word)
)

(provide 'my-config-dictionary)
;;; my-config-dictionary.el ends here
