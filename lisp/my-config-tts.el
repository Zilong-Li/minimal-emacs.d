;;; my-config-tts.el --- Personal tts configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defvar piper-binary-path "~/.local/bin/piper")
;; (defvar piper-model-path "~/.local/share/piper/models/en_GB-cori-high.onnx")
(defvar piper-model-path "~/.local/share/piper/models/en_US-ryan-high.onnx")

;; new piper can use ffplay directly
(defun my/tts-piper (&optional arg)
  "Send the text after point or the given TEXT to piper for tts.
If a region is active, send the marked text.
If a non-numeric prefix argument is provided, prompt for text input.
If a numeric prefix argument is provided, send that number of lines.
Otherwise send from point to end of buffer."
  (interactive "P")
  (let* ((text (cond
                ((region-active-p) (buffer-substring-no-properties (region-beginning) (region-end)))
                ((consp arg) (read-string "Enter text: "))
                (arg (buffer-substring-no-properties (point) (save-excursion (forward-line arg) (point))))
                (t (buffer-substring-no-properties (point) (point-max)))))
         (cleaned-text (replace-regexp-in-string "\\([a-z]\\)'\\([a-z]\\)" "\\1 \\2" text))
         (cmd (format "%s --model %s -- %s"
                      (expand-file-name piper-binary-path)
                      (expand-file-name piper-model-path)
                      (shell-quote-argument cleaned-text))))
    (with-current-buffer (get-buffer-create "*piper*")
      (goto-char (point-max))
      (insert (format "[%s] Running: %s\n\n"
                      (format-time-string "%Y-%m-%d %H:%M:%S")
                      cmd)))
    (make-process
     :name "piper"
     :buffer "*piper*"
     :command (list (expand-file-name piper-binary-path)
                    "--model" (expand-file-name piper-model-path)
                    "--" cleaned-text))))

(bind-key "C-x s" #'my/tts-piper)

(provide 'my-config-tts)
;;; my-config-tts.el ends here
