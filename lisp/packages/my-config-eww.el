;;; my-config-eww.el --- Personal eww configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package eww
  :defer t
  :bind (("C-c w" . eww))

  :preface
  (defun my-browse-url-mpv (url &rest _args)
    "Open URL in mpv."
    (start-process "mpv" nil "mpv" url))

  (defun my-browse-url-pdf (url &rest _args)
    "Fetch remote PDF and open in pdf-tools within Emacs."
    (let ((tmp (make-temp-file "emacs-pdf-" nil ".pdf")))
      (url-copy-file url tmp t)
      (find-file-other-window tmp)
      (pdf-view-mode)))

  (defun my/eww-download-image-at-point ()
    "Download image at point to `eww-download-directory'."
    (interactive)
    (let ((url (or (get-text-property (point) 'image-url)
                   (get-text-property (point) 'shr-url))))
      (if (not url)
          (message "No image at point")
        (let* ((parsed (url-generic-parse-url url))
               (name (file-name-nondirectory
                      (or (url-filename parsed) "")))
               (filename (if (string-empty-p name)
                             (format-time-string "eww-image-%Y%m%d-%H%M%S")
                           name))
               (dest (expand-file-name filename eww-download-directory)))
          (url-copy-file url dest t)
          (message "Saved: %s" dest)))))

  :config
  (require 'subr-x)

  (setq eww-search-prefix "https://duckduckgo.com/html/search?q=")

  (setq browse-url-browser-function
        '(("\\(youtube\\.com\\|youtu\\.be\\|vimeo\\.com\\|twitch\\.tv\\)" . my-browse-url-mpv)
          ("\\.mp4\\'" . my-browse-url-mpv)
          ("\\.pdf\\'" . my-browse-url-pdf)
          ("^gemini://" . elpher-browse-url-elpher)
          ("^gopher://" . elpher-browse-url-elpher)
          ("." . eww-browse-url)))

  (setq shr-use-fonts nil
        shr-use-colors nil
        shr-indentation 2
        shr-width 100
        shr-max-width 120
        shr-max-image-size '(800 . 600)
        shr-image-animate t
        eww-browse-url-new-window-is-tab nil
        eww-auto-rename-buffer 'title
        eww-download-directory (expand-file-name "~/Downloads/")
        eww-use-external-browser-for-content-type "\\`\\(video/\\|audio\\)")

  (define-key eww-mode-map (kbd "=") #'text-scale-increase)
  (define-key eww-mode-map (kbd "-") #'text-scale-decrease)
  (define-key eww-mode-map (kbd "a") #'other-window)
  (define-key eww-mode-map (kbd "f") #'eww-forward-url)
  (define-key eww-mode-map (kbd "r") #'eww-search-words)
  (define-key eww-mode-map (kbd "U") #'shr-copy-url)
  (define-key eww-mode-map (kbd "D") #'my/eww-download-image-at-point)

  (add-hook 'eww-mode-hook
            (lambda ()
              (face-remap-add-relative
               'header-line
               :height 0.9
               :box `(:line-width 1 :color ,(face-background 'default))))))

(provide 'my-config-eww)
;;; my-config-eww.el ends here
