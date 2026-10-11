;;; my-config-ibuffer.el --- Personal ibuffer configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ibuffer
  :defer t
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-default-display-maybe-show-predicates t)
  (ibuffer-expert t)
  (ibuffer-formats
   '((mark modified read-only locked
           " " (name 30 30 :left :elide)
           " " (size 9 -1 :right)
           " " (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
               (name 16 -1)
               " " filename)))
  (ibuffer-maybe-show-regexps nil)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-shrink-to-minimum-size t t)
  ;; (ibuffer-use-other-window t)

  :config

  (require 'ibuf-ext)

  (define-ibuffer-filter persp
      "Toggle current view to buffers associated with current perspective."
    (:description "persp-mode"
                  :reader (persp-read-persp nil nil (safe-persp-name (get-frame-persp)) t))
    (let ((persp-name (if (string= qualifier "")
                          (safe-persp-name (get-current-persp))
                        qualifier)))
      (member buf (safe-persp-buffers (persp-get-by-name persp-name)))))

  (defun persp-add-current-ibuffer-group ()
     (require 'cl-lib)
      (let ((perspslist (list
                         (list (safe-persp-name (get-frame-persp))
                               (cons 'persp (safe-persp-name (get-frame-persp)))))))
        (setq ibuffer-saved-filter-groups
              (cl-delete "persp-mode" ibuffer-saved-filter-groups
                       :test 'string= :key 'car))
        (push
         (cons "persp-mode" perspslist)
         ibuffer-saved-filter-groups)))

  (add-hook 'ibuffer-mode-hook
            #'(lambda ()
                (persp-add-current-ibuffer-group)
                (ibuffer-switch-to-saved-filter-groups "persp-mode")))

  )

(provide 'my-config-ibuffer)
;;; my-config-ibuffer.el ends here
