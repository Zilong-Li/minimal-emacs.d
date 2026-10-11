;;; my-config-ess.el --- Personal ess configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ess
  :defer t
  :mode (("\\.R\\'" . ess-r-mode)
         ("\\.r\\'" . ess-r-mode))
  :init

  (setq ess-eval-visibly 'nowait
        inferior-ess-r-program-name "~/.local/bin/R"
        ess-use-company nil ;; use corfu!
        ess-history-file nil
        ess-history-directory nil
        ess-style 'RStudio)

  (defun my/read-into-string (buffer)
    (with-current-buffer buffer
      (buffer-string)))

  (defun my/ess-R-object-popup (r-func)
    "R-FUNC: The R function to use on the object.
Run R-FUNC for object at point, and display results in a help window."
    (let ((objname (current-word))
          (tmpbuf (get-buffer-create "**ess-R-object-popup**")))
      (if objname
          (progn
            (ess-command (concat "class(" objname ")\n") tmpbuf)
            (let ((bs (my/read-into-string tmpbuf)))
              (if (not(string-match "\(object .* not found\)\|unexpected" bs))
                  (progn
                    (ess-command (concat r-func "(" objname ")\n") tmpbuf)
                    (let ((bs (my/read-into-string tmpbuf)))
                      (with-help-window "*ESS Object*" (princ bs))))))))
      (kill-buffer tmpbuf)))

  (defun my/ess-R-object-popup-fed ()
    (interactive)
    (my/ess-R-object-popup "fed"))

  (defun my/ess-R-object-popup-str ()
    (interactive)
    (my/ess-R-object-popup "str"))

  (defun my/ess-R-object-popup-interactive (r-func)
    (interactive "sR function to execute: ") ; don't use R which is invalid
    (my/ess-R-object-popup r-func))

  :config

  (require 'ess-r-mode)
  (require 'ess-r-package) ;; quick r package setup

  (setq ess-smart-equals-extra-ops '(brace paren percent))
  (with-eval-after-load 'ess-r-mode
    (require 'ess-smart-equals)
    (ess-smart-equals-activate))

  ;; be smart about parens pairs
  ;; (add-hook 'ess-r-mode-hook #'smartparens-mode)
  ;; (add-hook 'inferior-ess-r-mode-hook #'smartparens-mode)

  ;; completion
  (add-hook 'ess-r-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list #'cape-file        ;; File completion first
                                #'tempel-expand
                                #'ess-r-object-completion
                                #'cape-history
                                #'cape-dabbrev)))) ;; Add dabbrev as fallback

  (defun my-ess-quit-or-delete-char (arg)
    "Delete character at point or quit R when at empty prompt."
    (interactive "p")
    ;; ESS R prompts are typically "> " or "+ "
    (let ((ess-prompt-regexp "^[>+] "))
      (if (and (eolp) (looking-back ess-prompt-regexp))
          (progn
            (ess-quit)
            ;; (ess-eval-linewise "q()" nil nil nil 'wait)
            )
        (delete-forward-char arg))))

  (defun my/inferior-ess-setup ()
    "Set up C-d to delete char or quit in ESS R process."
    (local-set-key (kbd "C-d") 'my-ess-quit-or-delete-char)
    (setq-local corfu-auto nil)
    (buffer-box-on)
    )

  (add-hook 'inferior-ess-mode-hook 'my/inferior-ess-setup)

  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:modifiers . t)
          (ess-R-fl-keyword:fun-defs . t)
          (ess-R-fl-keyword:keywords . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:constants . t)
          (ess-R-fl-keyword:F&T . t)
          (ess-R-fl-keyword:%op% . t)
          (ess-fl-keyword:fun-calls . t)
          (ess-fl-keyword:numbers . t)
          (ess-fl-keyword:operators . t)
          (ess-fl-keyword:delimiters . nil)
          (ess-fl-keyword:= . nil)))
  :bind
  (:map ess-r-mode-map
        ("C-c C-k" . ess-help)
        ("C-c C-f" . my/ess-R-object-popup-fed)
        ("C-c C-s" . my/ess-R-object-popup-str)
        ("C-c C-r" . my/ess-R-object-popup-interactive)
        )
  )

(provide 'my-config-ess)
;;; my-config-ess.el ends here
