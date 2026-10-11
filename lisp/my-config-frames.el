;;; my-config-frames.el --- Personal frames configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(setq frame-title-format "OneEmacs")

(defun my/make-frame ()
  "Create a new frame and switch to *scratch* buffer."

  (interactive)
  (select-frame (make-frame))
  (switch-to-buffer "*scratch*"))

(defun my/kill-emacs ()
  "Delete frame or kill Emacs if there is only one frame."

  (interactive)
  (condition-case nil
      (delete-frame)
    (error (save-buffers-kill-terminal))))

;; Merge dimensions and borders with the early transparency/blur settings.
(dolist (parameter '((min-height . 1) (height . 45)
                     (min-width . 1) (width . 81)
                     (vertical-scroll-bars . nil)
                     (internal-border-width . 12)
                     (left-fringe . 0) (right-fringe . 0)
                     (tool-bar-lines . 0)))
  (setf (alist-get (car parameter) default-frame-alist) (cdr parameter))
  (setf (alist-get (car parameter) initial-frame-alist) (cdr parameter)))

(bind-key "M-n"        #'my/make-frame)
(bind-key "C-x C-c"    #'my/kill-emacs)
(bind-key "M-`"        #'other-frame)
(bind-key "C-z"        nil)
;; (bind-key "<M-return>" #'eval-buffer)

; https://stackoverflow.com/questions/14881020/emacs-shortcut-to-switch-from-a-horizontal-split-to-a-vertical-split-in-one-move
(defun my/toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(provide 'my-config-frames)
;;; my-config-frames.el ends here
