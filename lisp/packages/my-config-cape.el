;;; my-config-cape.el --- Personal cape configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/register-org-capfs ()
  "set `completion-at-point-functions' in reverse order"
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'tempel-expand
                     #'cape-dict
                     ))))

;; the priority is in reverse order
(defun my/register-elisp-capfs ()
  "I want  'cape-elisp-block' for emacs-lisp-mode"
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  )

(defun my/register-eshell-capfs ()
  "I want 'cape-history' for comint-mode"
  ;; (add-to-list 'completion-at-point-functions #'cape-line)
  ;; (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'pcomplete-completions-at-point)
  ;; (add-to-list 'completion-at-point-functions #'native-complete-at-point)
  )

(defun my/register-default-capfs ()
  "I use 'cape-dabbrev', `cape-dict' and 'cape-file' everywhere as they are
generally useful. This function needs to be called in certain
mode hooks, as some modes fill the buffer-local capfs with
exclusive completion functions, so that the global ones don't get
called at all."
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  )


(use-package cape
  :defer 10
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (
         ("C-c ; d" . cape-dabbrev)
         ("C-c ; i" . cape-dict)
         ("C-c ; a" . cape-abbrev)
         ("C-c ; f" . cape-file)
         ("C-c ; h" . cape-history)
         ("C-c ; l" . cape-line)
         ("C-c ; t" . cape-tex)
         ("C-c ; e" . cape-elisp-symbol)
         ("C-c ; ;" . cape-emoji)
         )
  :hook
  ((org-mode . my/register-org-capfs)
   (eshell-mode . my/register-eshell-capfs)
   (emacs-lisp-mode . my/register-elisp-capfs))

  :init
  (my/register-default-capfs)

  :config

  (with-eval-after-load 'eglot
    (defun my/eglot-capf ()
      (setq-local completion-at-point-functions
                  (list (cape-capf-super
                         #'eglot-completion-at-point
                         #'tempel-complete
                         ))))
    (add-hook 'eglot-managed-mode-hook #'my/eglot-capf))

  )

(provide 'my-config-cape)
;;; my-config-cape.el ends here
