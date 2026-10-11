;;; post-init.el --- Load personal configuration modules -*- no-byte-compile: t; lexical-binding: t; -*-

(require 'my-defaults)    ; Built-in behaviour, files, history, platform
(require 'my-ui)          ; Theme, fonts, header line, windows, perspectives
(require 'my-keys)        ; Meow, its paren state and the C-q prefix
(require 'my-completion)  ; Vertico, Orderless, Marginalia, Consult, Corfu, Tempel
(require 'my-tools)       ; Dired, projects, Git, shells, web, LLM
(require 'my-prog)        ; Tree-sitter, Eglot, languages, folding
(require 'my-org)         ; Org, agenda, capture, export

;;; post-init.el ends here
