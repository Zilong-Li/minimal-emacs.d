;;; my-config-meow.el --- Personal meow configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package meow
  :init
  (defun my/meow-insert-at-cursor ()
    "insert for all modes."
    (interactive)
    (if meow--temp-normal
        (progn
          (message "Quit temporary normal mode")
          (meow--switch-state 'motion))
      (meow--cancel-selection)
      (meow--switch-state 'insert)))

  (defun my/meow-insert-space ()
    "Insert a space character in normal mode."
    (interactive)
    (insert " "))

  (defun my/meow-setup ()
    (add-to-list 'meow-mode-state-list
                 '(mu4e-view-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(osx-dictionary-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(pdf-outline-buffer-mode . motion))
    (add-to-list 'meow-mode-state-list
                 '(eshell-mode . insert))
    (add-to-list 'meow-mode-state-list
                 '(edraw-property-editor-mode . insert))
    (add-to-list 'meow-mode-state-list
                 '(comint-mode . insert))
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

    (meow-motion-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))

    (meow-leader-define-key
     '("<RET>" . hs-toggle-hiding)
     ;; TODO: bind j,k,l as well!
     '("j" . persp-switch)
     ;; make SPC-u as C-u now
     '("u" . meow-universal-argument)
     ;; frequent keys
     '("SPC" . consult-buffer) ; buffer
     '("/" . my/consult-ripgrep) ; search project
     '("0" . delete-window)
     '("1" . delete-other-windows)
     '("2" . split-window-below)
     '("3" . split-window-right)
     '("4" . ctl-x-4-prefix)
     '("5" . ctl-x-5-prefix)
     '("8" . insert-char)  ; insert emoji
     '("9" . delete-frame)
     '("?" . meow-cheatsheet)
     )

    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '(";" . meow-reverse)
     '("'" . repeat) ; vim use .
     '("%" . my/jump-to-matching-paren)  ; like % in vim
     '("&" . meow-query-replace)
     '("@" . meow-query-replace-regexp)
     '("=" . text-scale-increase) ; increase text size
     '("-" . text-scale-decrease)
     '("_" . negative-argument)
     '("`" . meow-last-buffer)
     '("!" . my/consult-outline)
     '("<" . beginning-of-buffer)
     '(">" . end-of-buffer)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . other-window)
     '("A" . meow-append)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("C" . meow-comment)
     '("d" . meow-delete)
     '("D" . my/toggle-window-dedicated)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("F" . kirigami-toggle-fold) ; fold/unfold text
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . my/meow-insert-at-cursor) ;; meow-insert
     '("I" . meow-open-below)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("M" . toggle-frame-maximized)
     '("n" . meow-search)
     '("N" . my/toggle-window-split)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("P" . meow-yank-pop)
     '("q" . meow-quit)
     '("Q" . my/search-thing-at-point-or-prompt)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("S" . my/meow-insert-space)
     '("t" . avy-goto-char-timer)
     '("T" . meow-till)
     '("u" . meow-undo)
     '("U" . vundo)
     '("v" . xref-find-definitions)
     '("V" . xref-go-back)
     '("/" . meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("Z" . meow-paren-mode)
     '("<escape>" . ignore)))
  (my-ensure 'meow)
  (setq meow-use-dynamic-face-color nil)
  ;; (setq meow-use-cursor-position-hack t)
  (my/meow-setup)
  (meow-setup-indicator)
  (meow-global-mode 1)
  )

(provide 'my-config-meow)
;;; my-config-meow.el ends here
