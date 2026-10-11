;;; my-config-file-defaults.el --- Personal file-defaults configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(set-default-coding-systems 'utf-8)     ; Default to utf-8 encoding
(prefer-coding-system       'utf-8)     ; Add utf-8 at the front for automatic detection.
(set-terminal-coding-system 'utf-8)     ; Set coding system of terminal output
(set-keyboard-coding-system 'utf-8)     ; Set coding system for keyboard input on TERMINAL
(set-language-environment "English")    ; Set up multilingual environment

;; Keep the starter kit's centralized autosave/ and backup/ directories.
(setq auto-save-default t        ; Auto-save every buffer that visits a file
      auto-save-timeout 20       ; Number of seconds between auto-save
      auto-save-interval 200)    ; Number of keystrokes between auto-saves

(setq make-backup-files t          ; Backup of a file the first time it is saved.
      vc-make-backup-files t       ; No backup of files under version contr
      backup-by-copying t          ; Don't clobber symlinks
      version-control t            ; Version numbers for backup files
      delete-old-versions t        ; Delete excess backup files silently
      kept-old-versions 6          ; Number of old versions to keep
      kept-new-versions 9          ; Number of new versions to keep
      delete-by-moving-to-trash t) ; Delete files to trash

;; Back
;; (require 'vc-backup)

(provide 'my-config-file-defaults)
;;; my-config-file-defaults.el ends here
