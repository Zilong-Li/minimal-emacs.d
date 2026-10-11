;;; my-config-environment.el --- Personal environment configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(dolist (directory (list (expand-file-name "~/.local/bin")
                        "/Library/TeX/texbin" "/opt/homebrew/bin"))
  (add-to-list 'exec-path directory t)
  (unless (member directory (parse-colon-path (or (getenv "PATH") "")))
    (setenv "PATH" (concat (or (getenv "PATH") "") path-separator directory))))

(provide 'my-config-environment)
;;; my-config-environment.el ends here
