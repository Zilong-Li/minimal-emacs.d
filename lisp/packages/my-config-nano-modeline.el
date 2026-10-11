;;; my-config-nano-modeline.el --- Personal nano-modeline configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package nano-modeline
  :ensure nil
  :custom
  (nano-modeline-position "Top")
  (nano-modeline-padding '(0.20 . 0.25))
  :config
  (defun my/nano-modeline-element-pdf-label ()
    "Display a PDF label in the modeline."
    (propertize "PDF:" 'face 'nano-modeline-face-primary))

  (defun my/nano-modeline-element-pdf-page ()
    "Return current PDF page and total number of pages."
    (when (derived-mode-p 'pdf-view-mode) (propertize (format " %d/%s" (image-mode-window-get 'page) (or (ignore-errors (pdf-cache-number-of-pages)) "?")) 'face 'nano-modeline-face-secondary)))

  ;; PDF-specific nano-modeline format.
  (defvar my/nano-modeline-format-pdf-view
    (cons '(my/nano-modeline-element-pdf-label
            nano-modeline-element-space
            nano-modeline-element-buffer-name
            nano-modeline-element-space
            nano-modeline-element-buffer-mode)
          '(my/nano-modeline-element-pdf-page
            nano-modeline-element-window-status
            nano-modeline-element-space)))

  :hook
  ((prog-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (text-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (pdf-view-mode . (lambda () (nano-modeline my/nano-modeline-format-pdf-view)))
   (gptel-mode . (lambda () (nano-modeline nano-modeline-format-gptel)))
   (org-mode . (lambda () (nano-modeline nano-modeline-format-default)))
   (org-capture-mode . (lambda () (nano-modeline nano-modeline-format-org-capture)))
   (nano-calendar-mode . (lambda () (nano-modeline nano-modeline-format-nano-agenda)))
   (mu4e-headers-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-headers)))
   (mu4e-view-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-message)))
   (mu4e-compose-mode . (lambda () (nano-modeline nano-modeline-format-mu4e-compose)))
   (elfeed-search-mode . (lambda () (nano-modeline nano-modeline-format-elfeed-search)))
   (elfeed-show-mode . (lambda () (nano-modeline nano-modeline-format-elfeed-entry)))
   (term-mode . (lambda () (nano-modeline nano-modeline-format-terminal)))
   (ghostel-mode . (lambda () (nano-modeline nano-modeline-format-terminal)))
   )
  )

(set-face-foreground 'minibuffer-prompt "pink")
(set-face-bold 'minibuffer-prompt t)

(provide 'my-config-nano-modeline)
;;; my-config-nano-modeline.el ends here
