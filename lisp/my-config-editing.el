;;; my-config-editing.el --- Personal editing configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(delete-selection-mode 1)

(setq-default fill-column 80)
(defun my/fill-unfill ()
  "Like `fill-paragraph', but unfill if used twice."

  (interactive)
  (let ((fill-column
         (if (eq last-command #'my/fill-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(bind-key "M-q"  #'my/fill-unfill)
;; (bind-key [remap fill-paragraph]  #'my/fill-unfill)

(defun uppercasep (c) (and (= ?w (char-syntax c)) (= c (upcase c))))

(defun downcase-char ()
  (interactive)
  (save-excursion
    (let ((ch (thing-at-point 'char t)))
      (delete-char 1)
      (insert (downcase ch)))))

(defun zl-toggle-case-dwiam ()
  "toggle cases, do what i actually mean:

If no region is active, toggle between upcase and downcase on the
current character. If a region is active, then if there exists at
least one upcase char in the region, then downcase the whole
region. Otherwise, upcase the whole region."
  (interactive)
  (if (region-active-p)
      (let ((region (buffer-substring-no-properties
                     (region-beginning) (region-end))))
        (message "%s" region)
        (if (cl-remove-if-not #'uppercasep (string-to-list region))
            (downcase-region (region-beginning) (region-end))
          (upcase-region (region-beginning) (region-end))))
    (if (uppercasep (string-to-char (thing-at-point 'char t)))
        (downcase-char)
      (upcase-char 1))))

(defun replace-bounds (strt end content)
  (delete-region strt end)
  (insert (number-to-string content)))

(defun zl-increase-number (arg)
  "increase number at point"
  (interactive "P")
  (let* ((num (thing-at-point 'number t))
         (bounds (bounds-of-thing-at-point 'word))
         (strt (car bounds))
         (end (cdr bounds)))
    (message "%s" arg)
    (if arg
        (replace-bounds strt end (+ num arg))
      (replace-bounds strt end (+ num 1)))))

(defun zl-decrease-number ()
  "decrease number at point"
  (interactive)
  (let ((current-prefix-arg -1))
    (call-interactively #'zl-increase-number)))

(provide 'my-config-editing)
;;; my-config-editing.el ends here
