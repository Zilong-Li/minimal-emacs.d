;;; my-config-minibuffer.el --- Personal minibuffer configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(defun minibuffer-format-candidate (orig cand prefix suffix index _start)
  (let ((prefix (if (= vertico--index index)
                    "  "
                  "   ")))
    (funcall orig cand prefix suffix index _start)))

(advice-add #'vertico--format-candidate
           :around #'minibuffer-format-candidate)

(defun vertico--prompt-selection ()
  "Highlight the prompt"

  (let ((inhibit-modification-hooks t))
    (set-text-properties (minibuffer-prompt-end) (point-max)
                         '(face (nano-strong nano-salient)))))

(defun minibuffer-vertico-setup ()

  (setq truncate-lines t)
  (setq completion-in-region-function
        (if vertico-mode
            #'consult-completion-in-region
          #'completion--in-region)))

(add-hook 'vertico-mode-hook #'minibuffer-vertico-setup)
(add-hook 'minibuffer-setup-hook #'minibuffer-vertico-setup)

;; Enable rich annotations using the Marginalia package

(provide 'my-config-minibuffer)
;;; my-config-minibuffer.el ends here
