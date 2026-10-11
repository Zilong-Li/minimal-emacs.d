;;; my-config-screenshots.el --- Personal screenshots configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defvar frameshot-directory "~/Pictures/Screenshots/"
  "Default directory for frame shots.")

(defvar frameshot-format 'png
  "Default frame shot format.")

(defun my/frameshot ()
  "Save Emacs frame as frame shot.
Directory is determined by variable `frameshot-directory' and if
not defined, it will be saved in the `$HOME' directory."
  (interactive)
  (let* ((image (x-export-frames nil (or frameshot-format 'png)))
             (base-directory (or frameshot-directory (getenv "HOME")))
             (directory (concat (file-name-as-directory base-directory)
                                        (format-time-string "%Y/%m/%Y-%m-%d/")))
             (file (concat directory (format-time-string "Screenshot-%Y-%m-%d-%T.")
                               (symbol-name frameshot-format))))
    (make-directory directory t)
    (with-temp-file file
      (insert image))
    (dired directory)
    (revert-buffer)
    (dired-goto-file (expand-file-name file))
    (message "Frame shot saved as `%s'" file)))

(defun my/mac-screencapture (&optional arg)
  "Take a screenshot using macOS screencapture.

No prefix:     capture region to clipboard.
C-u:           capture frame to clipboard.
C-u C-u:       capture region to file.
C-u C-u C-u:   capture frame to file."
  (interactive "P")
  (let* ((frame-id (frame-parameter nil 'outer-window-id))
         (to-file (member arg '((16) (64))))
         (filename (when to-file
                     (expand-file-name
                      (read-file-name "Save screenshot to: " nil nil nil
                                      (format-time-string "screenshot-%Y%m%d-%H%M%S.png"))))))
    (pcase arg
      ;; Default: region to clipboard
      ('nil
       (call-process "screencapture" nil nil nil "-s" "-c"))

      ;; C-u: frame to clipboard
      ('(4)
       (if frame-id
           (call-process "screencapture" nil nil nil "-l" frame-id "-c")
         (call-process "screencapture" nil nil nil "-w" "-c")))

      ;; C-u C-u: region to file
      ('(16)
       (call-process "screencapture" nil nil nil "-s" filename))

      ;; C-u C-u C-u: frame to file
      ('(64)
       (if frame-id
           (call-process "screencapture" nil nil nil "-l" frame-id filename)
         (call-process "screencapture" nil nil nil "-w" filename))))

    (if to-file
        (message "Screenshot saved to %s" filename)
      (message "Screenshot copied to clipboard"))))

(provide 'my-config-screenshots)
;;; my-config-screenshots.el ends here
