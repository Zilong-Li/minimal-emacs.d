;;; my-config-avy.el --- Personal avy configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package avy
  :commands (avy-goto-char-timer avy-goto-char avy-goto-char-2)
  :bind (("M-j" . avy-goto-char-timer))
  :custom
  (avy-case-fold-search t)
  (avy-timeout-seconds 0.5)
  :preface
  (defun avy-action-kill-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (kill-whole-line))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-copy-whole-line (pt)
    (save-excursion
      (goto-char pt)
      (cl-destructuring-bind (start . end)
          (bounds-of-thing-at-point 'line)
        (copy-region-as-kill start end)))
    (select-window
     (cdr
      (ring-ref avy-ring 0)))
    t)

  (defun avy-action-yank-whole-line (pt)
    (avy-action-copy-whole-line pt)
    (save-excursion (yank))
    t)

  (defun avy-action-teleport-whole-line (pt)
    (avy-action-kill-whole-line pt)
    (save-excursion (yank)) t)

  (defun avy-action-mark-to-char (pt)
    (activate-mark)
    (goto-char pt))

  (defun avy-action-embark (pt)
    (require 'embark)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun avy-action-flyspell (pt)
    (save-excursion
      (goto-char pt)
      (when (require 'flyspell nil t)
        (flyspell-mode)
        (flyspell-auto-correct-word)
        ))
    (select-window
     (cdr (ring-ref avy-ring 0)))
    t)

  :config

  (define-key isearch-mode-map (kbd "M-j") 'avy-isearch)

  (setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark)
  (setf (alist-get ?\; avy-dispatch-alist) 'avy-action-flyspell)

  (setf (alist-get ?k avy-dispatch-alist) 'avy-action-kill-stay
        (alist-get ?K avy-dispatch-alist) 'avy-action-kill-whole-line)

  (setf (alist-get ?y avy-dispatch-alist) 'avy-action-yank
        (alist-get ?w avy-dispatch-alist) 'avy-action-copy
        (alist-get ?W avy-dispatch-alist) 'avy-action-copy-whole-line
        (alist-get ?Y avy-dispatch-alist) 'avy-action-yank-whole-line)

  (setf (alist-get ?t avy-dispatch-alist) 'avy-action-teleport
        (alist-get ?T avy-dispatch-alist) 'avy-action-teleport-whole-line)

  (setf (alist-get ?  avy-dispatch-alist) 'avy-action-mark-to-char))

(provide 'my-config-avy)
;;; my-config-avy.el ends here
