;;; my-config-webjump.el --- Personal webjump configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package webjump
  :bind ("C-x /" . webjump)
  :custom
  (webjump-sites
   '(("DuckDuckGo" . [simple-query "www.duckduckgo.com" "www.duckduckgo.com/?q=" ""])
     ("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
     ("YouTube" . [simple-query "www.youtube.com/feed/subscriptions" "www.youtube.com/results?search_query=" ""])
     ("ChatGPT" . [simple-query "https://chatgpt.com" "https://chatgpt.com/?q=" ""])))
  :config
  (defun my/webjump-external (orig-fun &rest args)
    (let ((browse-url-browser-function #'browse-url-generic)
          (browse-url-handlers nil))
      (apply orig-fun args)))
  (advice-add 'webjump :around #'my/webjump-external))

(provide 'my-config-webjump)
;;; my-config-webjump.el ends here
