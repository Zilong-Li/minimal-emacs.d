;;; my-config-keybindings.el --- Personal keybindings configuration -*- no-byte-compile: t; lexical-binding: t; -*-

; define sub-maps
(defvar-keymap my-prefix-meow-map
  :doc "Prefix map of C-q m for buffers"
  "n" #'meow-normal-mode
  "m" #'meow-motion-mode
  "p" #'meow-paren-mode
  )

(defvar-keymap my-prefix-window-map
  :doc "Prefix map of C-q w for buffers"
  "k" #'kill-buffer-and-window
  "l" #'my/browse-url-secondary
  )

(defvar-keymap my-prefix-gpt-map
  :doc "Prefix map of C-q g for buffers"
  "g" #'gptel
  "s" #'gptel-send
  "m" #'gptel-menu
  "p" #'my/proofread-dwim
  "l" #'my/proofread-formal
  "c" #'codex-ide-menu
  )

(defvar-keymap my-prefix-edit-map
    :doc "Prefix map of C-q e for editing"
    "w" #'mark-word
    "s" #'mark-end-of-sentence
    "p" #'mark-paragraph
    "g" #'mark-whole-buffer
    "d" #'org-remark-delete
    "m" #'org-remark-mark
    "l" #'org-remark-mark-red-line
    "v" #'org-remark-view-next
    )

(defvar-keymap my-prefix-fold-map
    :doc "Prefix map of C-q f for fold/unfold text"
    "O" #'kirigami-open-fold  ; open fold at point
    "o" #'kirigami-open-folds ; open all folds
    "c" #'kirigami-close-folds ; close all folds
    "C" #'kirigami-close-fold ; close fold at point
    "r" #'kirigami-open-fold-rec ; open fold recursively
    )

(defvar-keymap my-prefix-casual-map
    :doc "Prefix map of C-q c for casual"
    "a" #'casual-avy-tmenu
    "g" #'casual-agenda-tmenu
    "i" #'casual-ibuffer-tmenu
    "c" #'casual-calc-tmenu
    "n" #'casual-info-tmenu
    "r" #'casual-re-builder-tmenu
    "b" #'casual-bookmarks-tmenu
    "d" #'casual-dired-tmenu
    "w" #'casual-eww-tmenu
    "e" #'casual-editkit-main-tmenu)

 (defvar-keymap my-prefix-spell-map
    :doc "Prefix map of C-q s for spelling"
    "o" #'osx-dictionary-search-word-at-point
    "i" #'osx-dictionary-search-input
    "c" #'flyspell-correct-word-before-point
    "d" #'dictionary-lookup-definition
    "s" #'dictionary-search)

; define the top-level keymap
(defvar-keymap my-prefix-command
  :doc "My prefix map bound to C-q"
  "w" my-prefix-window-map
  "g" my-prefix-gpt-map
  "e" my-prefix-edit-map
  "f" my-prefix-fold-map
  "c" my-prefix-casual-map
  "s" my-prefix-spell-map
  "m" my-prefix-meow-map
  )


; bind the root map to your prefix key
(keymap-set global-map "C-q" my-prefix-command)

(provide 'my-config-keybindings)
;;; my-config-keybindings.el ends here
