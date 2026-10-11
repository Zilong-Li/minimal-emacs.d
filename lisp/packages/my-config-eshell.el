;;; my-config-eshell.el --- Personal eshell configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package eshell
  :defer t
  :hook (eshell-mode . my/eshell-setup)
  :hook (eshell-load . ghostel-eshell-visual-command-mode)
  :hook (eshell-post-command . ha-eshell-store-last-output)

  :bind
  (("M-e" . eshell))

  :custom
  ;; (eshell-input-filter 'gopar/eshell-input-filter)
  (eshell-scroll-to-bottom-on-input 'all) ;; This jumps back to the prompt:
  (eshell-history-size 10240)
  (eshell-last-dir-unique t)
  (eshell-last-dir-ring-size 32)
  (eshell-error-if-no-glob t)
  (eshell-hist-ignoredups 'erase)
  (eshell-cd-on-directory t)
  (eshell-save-history-on-exit t)
  (eshell-kill-on-exit t);; Since eshell starts fast, let's dismiss it on exit
  (eshell-destroy-buffer-when-process-dies t)
  ;; Can you remember the parameter differences between the
  ;; executables `chmod' and `find' and their Emacs counterpart?
  ;; Me neither, so this makes it act a bit more shell-like:

  :config

  (setq eshell-visual-commands '())
  (setq eshell-modules-list (append eshell-modules-list '(eshell-elecslash eshell-rebind)))
  (setq eshell-prompt-function (lambda () "λ ")
        eshell-prompt-regexp (rx line-start (or "λ" "#") (1+ space)))

  ;; give me more aliases! https://www.emacswiki.org/emacs/EshellAlias
  (setq my/eshell-aliases
      '((d  . dired)
        (c  . (lambda () (eshell/cd "..")))
        (eshell/le . eshell/less)
        (eshell/vi . eshell/e)
            (Eshell/clear . eshell/clear-scrollback)))

  (mapc (lambda (alias)
              (defalias (car alias) (cdr alias)))
        my/eshell-aliases)

  :init

  (defun gopar/eshell-input-filter (input)
    "Do not save on the following:
       - empty lines
       - commands that start with a space, `ls`/`l`/`lsd`"
    (and
     (eshell-input-filter-default input)
     (eshell-input-filter-initial-space input)
     (not (string-prefix-p "c" input))
     (not (string-prefix-p "ls" input))
     (not (string-prefix-p "lsd" input))
     (not (string-prefix-p "l" input))))

  (defun eshell/cat-with-syntax-highlighting (filename)
    "Like cat(1) but with syntax highlighting.
Stole from aweshell"
    (let ((existing-buffer (get-file-buffer filename))
          (buffer (find-file-noselect filename)))
      (eshell-print
       (with-current-buffer buffer
         (if (fboundp 'font-lock-ensure)
             (font-lock-ensure)
           (with-no-warnings
             (font-lock-fontify-buffer)))
         (let ((contents (buffer-string)))
           (remove-text-properties 0 (length contents) '(read-only nil) contents)
           contents)))
      (unless existing-buffer
        (kill-buffer buffer))
      nil))
  (advice-add 'eshell/cat :override #'eshell/cat-with-syntax-highlighting)

  (defun eshell/ch (&rest images)
    "Concatenate IMAGES horizontally using ImageMagick's convert +append."
    (let ((output (car (last images)))
          (inputs (butlast images)))
      (unless (and output inputs)
        (error "Usage: ch <image1> <image2> ... <output-image>"))
      (let ((command (concat "convert +append "
                             (mapconcat 'identity inputs " ")
                             " "
                             output)))
        (eshell-command-result command))))


  (defun eshell/cv (&rest images)
    "Concatenate IMAGES vertically using ImageMagick's convert -append."
    (let ((output (car (last images)))
          (inputs (butlast images)))
      (unless (and output inputs)
        (error "Usage: cv <image1> <image2> ... <output-image>"))
      (let ((command (concat "convert -append "
                             (mapconcat 'identity inputs " ")
                             " "
                             output)))
        (eshell-command-result command))))

  (defun eshell/l (&rest args)
    "List files with `ls -al` using ARGS."
    (apply 'eshell/ls "-alrth" args))

  (defun eshell/e (&rest files)
    "Essentially an alias to the `find-file' function."
    (eshell-fn-on-files 'find-file 'find-file-other-window files))

  (defun eshell/ee (&rest files)
    "Edit one or more files in another window."
    (eshell-fn-on-files 'find-file-other-window 'find-file-other-window files))

  (defun eshell/less (&rest files)
    "Essentially an alias to the `view-file' function."
    (eshell-fn-on-files 'view-file 'view-file-other-window files))

  (defun eshell-fn-on-files (fun1 fun2 args)
    "Call FUN1 on the first element in list, ARGS.
Call FUN2 on all the rest of the elements in ARGS."
    (unless (null args)
      (let ((filenames (flatten-list args)))
        (funcall fun1 (car filenames))
        (when (cdr filenames)
          (mapcar fun2 (cdr filenames))))
      ;; Return an empty string, as the return value from `fun1'
      ;; probably isn't helpful to display in the `eshell' window.
      ""))

  (defun eshell/set (&rest args)
    "Creates a buffer local variable.
The first parameters of ARGS is the name of the variable.
The other parameters are the values. If not given, the
variable is deleted."
    (let* ((var (car args))
           (var-sym (make-symbol var))
           ;; Convert value to a string
           (val (pcase (seq-length (cdr args))
                  (0 nil)
                  (1 (format "%s" (cadr args)))
                  (_ (thread-last (cdr args)
                                  (seq-map 'eshell-stringify)
                                  (s-join " "))))))
      (if val
          (progn
            (set (make-local-variable var-sym) val)
            (setenv var val))

        ;; If we don't get both a variable and a value, let's try to
        ;; delete the variable:
        (makunbound var-sym)
        (setenv var))))

  (defun eshell/newbase (file newbase)
    "set f file.org
     echo- {newbase $f txt} # rename org as txt"
    (unless (string-match (rx bos ".") newbase)
      (setq newbase (concat "." newbase)))
    (concat (file-name-base file) newbase))

  (defun my/eshell-setup ()
    (set (make-local-variable 'debug-on-error) nil)
    (setq mode-line-format nil)
    (setq-local corfu-auto nil)
    (setq-local completion-styles '(basic))
    (corfu-mode)
    (require 'pcmpl-args) ; completion for linux commands
    (nano-modeline nano-modeline-format-terminal)
    )

  (defun ha-eshell-quit-or-delete-char (arg)
    "The `C-d' sequence closes window or deletes a character."
    (interactive "p")
    (if (and (eolp) (looking-back eshell-prompt-regexp))
        (progn
          (eshell-life-is-too-much) ; Why not? (eshell/exit)
          (ignore-errors
            (delete-window)))
      (delete-forward-char arg)))

  (defun eshell-insert-history ()
    "Displays the eshell history to select and insert back into your eshell."
    (interactive)
    (insert (completing-read "Eshell history: "
                             (delete-dups
                              (ring-elements eshell-history-ring)))))

  (defvar ha-eshell-output (make-ring 10)
    "A ring (looped list) storing history of eshell command output.")

  (defun ha-eshell-store-file-output (results)
    "Writes the string, RESULTS, to a temporary file and returns that file name."
    (let ((filename (make-temp-file "ha-eshell-")))
      (with-temp-file filename
        (insert results))
      filename))

  (defun ha-eshell-store-last-output ()
    "Store the output from the last eshell command.
Called after every command by connecting to the `eshell-post-command-hook'."
    (let ((output
           (buffer-substring-no-properties eshell-last-input-end eshell-last-output-start)))
      (ring-insert ha-eshell-output output)))

  (defun eshell/output (&rest args)
    "Return an eshell command output from its history.
The first argument is the index into the historical past, where
`0' is the most recent, `1' is the next oldest, etc.
The second argument represents the returned output:
 * `text' :: as a string
 * `list' :: as a list of elements separated by whitespace
 * `file' :: as a filename that contains the output
If the first argument is not a number, it assumes the format
to be `:text'. "
    (require 's)
    (let (frmt element)
      (cond
       ((> (length args) 1)  (setq frmt (cadr args)
                                   element (car args)))
       ((= (length args) 0)  (setq frmt "text"
                                   element 0))
       ((numberp (car args)) (setq frmt "text"
                                   element (car args)))
       ((= (length args) 1)  (setq frmt (car args)
                                   element 0)))

      (if-let* ((results (ring-ref ha-eshell-output (or element 0))))
          (cl-case (string-to-char frmt)
            (?l     (split-string results))
            (?f     (ha-eshell-store-file-output results))
            (otherwise (s-trim results)))
        "")))

  )

(provide 'my-config-eshell)
;;; my-config-eshell.el ends here
