;;; my-config-marginalia.el --- Personal marginalia configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-c" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  (setq-default marginalia--ellipsis "…"    ; Nicer ellipsis
              marginalia-align 'right       ; right alignment
              marginalia-align-offset -1)   ; one space on the right


  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode)

  )

(provide 'my-config-marginalia)
;;; my-config-marginalia.el ends here
