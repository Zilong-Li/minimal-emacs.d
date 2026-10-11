;;; my-config-platform.el --- Personal platform configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta t
        mac-option-modifier 'meta
        ;; mac-command-key-is-meta t
        ;; mac-command-modifier 'meta
        ns-function-modifier 'hyper ; Fn key as hyper (H)
                                        ;dired-use-ls-dired t
        insert-directory-program "gls" ;; ls for dired
        )
  (menu-bar-mode -1)


  

  )

(when (eq system-type 'gnu/linux)
  (setq
   browse-url-browser-function #'browse-url-xdg-open
   ;; x-super-keysym 'meta
   ;; x-meta-keysym 'super
   ))

(setq my/section-start-time (current-time))

(provide 'my-config-platform)
;;; my-config-platform.el ends here
