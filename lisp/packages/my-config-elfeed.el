;;; my-config-elfeed.el --- Personal elfeed configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package elfeed
  :commands elfeed
  :bind (("C-c l r" . elfeed)
         :map elfeed-search-mode-map
         ("o" . timu-elfeed-search-other-window)
         :map elfeed-show-mode-map
         ("M-." . dictionary-lookup-definition)
         ("x" . timu-elfeed-show-visit-xwidget)
         )
  :config
  (add-hook 'elfeed-show-mode-hook 'variable-pitch-mode)
  (define-key elfeed-search-mode-map "d" (elfeed-tag-selection-as 'starred))
  (define-key elfeed-search-mode-map "l" (elfeed-tag-selection-as 'readlater))
  (define-key elfeed-search-mode-map "i" (elfeed-tag-selection-as 'important))

  :init
  (defun my/elfeed ()
    "Open Elfeed in a new frame."
    (interactive)
    (let ((frame (make-frame)))
      (select-frame frame)
      (elfeed)))

  (defun elfeed-tag-selection-as (mytag)
    "https://karthinks.com/software/lazy-elfeed/"
    "Returns a function that tags an elfeed entry or selection as MYTAG"
    (lambda ()
      "Toggle a tag on an Elfeed search selection"
      (interactive)
      (elfeed-search-toggle-all mytag)))

  (defun timu-elfeed-search-other-window ()
    "Browse `elfeed' entry in the other window.
Credit: https://protesilaos.com/dotemacs"
    (interactive)
    (let* ((entry (if (eq major-mode 'elfeed-show-mode)
                      elfeed-show-entry
                    (elfeed-search-selected :ignore-region)))
           (link (elfeed-entry-link entry))
           (win (selected-window)))
      (with-current-buffer (get-buffer "*elfeed-search*")
        (unless (one-window-p)              ; experimental
          (delete-other-windows win))
        (split-window-right)
        (other-window 1)
        (elfeed-search-show-entry entry))))

  (defun timu-elfeed-show-visit-xwidget (&optional generic)
    "Visit the current entry in Xwidget using `xwidget-webkit-browse-url'.
If there is a prefix argument, visit the current entry in the
GENERIC browser defined by `browse-url-generic-program'."

    (interactive "P")
    (let ((link (elfeed-entry-link elfeed-show-entry)))
      (when link
        (message "Sent to browser: %s" link)
        (if generic
            (browse-url link)
          (xwidget-webkit-browse-url link)))))
  )

(provide 'my-config-elfeed)
;;; my-config-elfeed.el ends here
