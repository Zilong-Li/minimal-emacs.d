;;; my-config-browser.el --- Personal browser configuration -*- no-byte-compile: t; lexical-binding: t; -*-

;; Keep your fallback setting
(setq browse-url-browser-function 'browse-url-default-browser
      browse-url-secondary-browser-function 'browse-url-generic ; use the program set by browse-url-generic-program as the secondary
      browse-url-generic-program "open")


(defun my/browse-url-secondary (&optional url)
  "Open URL (or URL at point) in the secondary browser."
  (interactive)
  (let ((url (or url
                 (thing-at-point 'url)
                 (and (derived-mode-p 'org-mode)
                      (org-element-property :raw-link (org-element-context)))
                 (read-string "URL: "))))
    (funcall browse-url-secondary-browser-function url)))

(provide 'my-config-browser)
;;; my-config-browser.el ends here
