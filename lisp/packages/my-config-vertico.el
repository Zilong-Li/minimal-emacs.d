;;; my-config-vertico.el --- Personal vertico configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package vertico
  :defer 1
  :custom
  (vertico-count 8) ; Maximal number of candidates to show.
  (vertico-resize nil); How to resize the Vertico minibuffer window.
  (vertico-count-format nil); No prefix with number of entries
  (vertico-cycle t)
  :bind (:map vertico-map
              ("<backtab>" . minibuffer-complete))
  :config
  (vertico-mode)

  (setq vertico-grid-separator
        #("  |  " 2 3 (display (space :width (1))
                               face (:background "#ECEFF1")))

        vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                                display (space :align-to (- right (-1 . right-margin) (- +1)))))))

  (set-face-attribute 'vertico-group-separator nil
                      :strike-through t)
  (set-face-attribute 'vertico-current nil
                      :inherit '(nano-strong nano-subtle))
  (set-face-attribute 'completions-first-difference nil
                      :inherit '(nano-default))
  )

(provide 'my-config-vertico)
;;; my-config-vertico.el ends here
