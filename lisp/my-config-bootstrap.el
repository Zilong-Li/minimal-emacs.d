;;; my-config-bootstrap.el --- Personal bootstrap configuration -*- no-byte-compile: t; lexical-binding: t; -*-

;; Older AUCTeX autoloads alias ConTeXt-mode to context-mode; newer ones
;; alias in the opposite direction.  Repair the old definition before
;; Straight activates AUCTeX, including when reloading this configuration.
(when (eq (symbol-function 'ConTeXt-mode) 'context-mode)
  (fset 'ConTeXt-mode '(autoload "context" nil t nil)))


(defvar my/straight-custom-recipes
  '(
    (meow-tree-sitter :type git :host github :repo "skissue/meow-tree-sitter")
    (consult-tramp :type git :host github :repo "Ladicle/consult-tramp")
    (nov :type git :host nil :repo "https://depp.brause.cc/nov.el.git")
    (nextflow-mode :type git :host github :repo "edmundmiller/nextflow-mode")
    (ess-smart-equals :type git :host github :repo "genovese/ess-smart-equals")
    (cython-mode :type git :host github :repo "cython/emacs-cython-mode")
    (ultra-scroll :type git :host github :repo "jdtsmith/ultra-scroll")
    (buffer-box :type git :host github :repo "rougier/buffer-box")
    (life-calendar :type git :host github :repo "vshender/emacs-life-calendar")
    (relative-date :type git :host github :repo "rougier/relative-date")
    (nano-modeline :type git :host github :repo "rougier/nano-modeline" :branch "rewrite")
    (nano-elfeed :type git :host github :repo "Zilong-Li/nano-elfeed")
    (outline-indent :type git :host github :repo "jamescherti/outline-indent.el")
    (kirigami :type git :host github :repo "jamescherti/kirigami.el")
    (org-timegrid :type git :host github :repo "Gleek/org-timegrid")
    (org-better-agenda :type git :host github :repo "Lycomedes1814/org-better-agenda")
    (ghostel :type git :host github :repo "dakra/ghostel")
    (cuda-mode :type git :host github :repo "chachi/cuda-mode")
    (pdf-tools :host github :repo "vedang/pdf-tools")
    (codex-ide :type git :host github :repo "dgillis/emacs-codex-ide")))

(dolist (recipe my/straight-custom-recipes)
  (straight-use-package (if (cdr recipe) recipe (car recipe))))

(setq package-list
      '(meow                ; modal editting!!!
        0x0                 ; Upload stuff to a server https://0x0.st
        persp-mode          ; Session and Buffers management
        avy                 ; Jumping to visible text
        avy-zap             ; Zap to char using avy
        ace-window          ; Ace window! Require avy
        ace-link            ; Ace links! Require avy
        capf-autosuggest    ; preview the most recent matching history element for eshell and comint
        cape                ; Completion At Point Extensions
        orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
        marginalia          ; Enrich existing commands with completion annotations
        consult             ; Consulting completing-read
        consult-dir         ; autojump, z for emacs
        consult-notes       ; Find denotes
        embark              ; Acting on targets at point
        embark-consult      ; Acting on targets at point
        corfu               ; Completion Overlay Region FUnction
        tempel              ; Simple Templates for Emacs
        gptel               ; LLM in emacs
        vundo               ; Visually undo!
        nano-theme          ; NANO theme is beautiful! consider the rewrite branch TODO
        nano-agenda         ; NANO Agenda
        hide-mode-line      ; Can toggle default mode-line
        htmlize             ; Convert buffer text and decorations to HTML
        engrave-faces       ; better than htmlize and minted
        hl-todo             ; highlight TODO and friends
        f                   ; Modern API for working with files and directories
        rainbow-mode        ; Preview color codes
        xterm-color         ; true color for terms
        pcmpl-args          ; Enhanced shell completion
        native-complete     ; get native TAB completion working for shell
        transient           ; Transient command menus used by magit and casual
        magit               ; A Git porcelain inside Emacs.
        vc-backup           ; VC backend for versioned backups
        casual              ; Transient drived UI for many commands
        auctex              ; powerful latex editting!!!
        cdlatex             ; Fast latex editting!!!
        xenops              ; Fast latex preview!!!
        denote              ; Best for noting!
        popper              ; Popup my buffers and cycle through them!
        mini-frame          ; Show minibuffer in child frame on read-from-minibuffer
        imenu-list          ; Show imenu entries in a separate buffer
        docker              ; Manage docker from Emacs
        envrc               ; Emacs support for direnv
        markdown-mode       ; Major mode for Markdown-formatted text
        python-pytest       ; pytest integration in emacs
        yaml-mode           ; YAML mode
        snakemake-mode      ; snakemake mode
        lua-mode            ; lua mode
        groovy-mode         ; for nextflow-mode
        toc-org             ; up-to-date table of contents
        elfeed              ; RSS reader
        elfeed-org          ; Configure RSS
        ess                 ; best IDE for R!
        poly-R              ; work with Rmarkdown
        flymake-ruff        ; ruff linter for python
        julia-mode          ; Julia
        rust-mode           ; Rust
        go-mode             ; Golang
        web-mode            ; web-mode
        devdocs             ; doc viewer by querying devdocs.io
        smartparens         ; be smart about parens pairs
        exec-path-from-shell; Get environment variables such as $PATH from the shell
        async               ; Emacs Async ops!
        olivetti            ; Minor mode to auto balance window margins
        fountain-mode       ; Major mode for screenwriting and playwriting
        ))

;; Install packages that are not yet installed
(dolist (package package-list)
  (unless (assq package my/straight-custom-recipes)
    (straight-use-package package)))

(provide 'my-config-bootstrap)
;;; my-config-bootstrap.el ends here
