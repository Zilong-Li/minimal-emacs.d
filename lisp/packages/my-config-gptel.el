;;; my-config-gptel.el --- Personal gptel configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package gptel
  :demand t
  :bind
  (:map gptel-mode-map
        ("C-c C-n"  . my/gptel-next-prompt)
        ("C-c C-p"  . my/gptel-previous-prompt))
  :custom
  (gptel-default-mode 'org-mode)
  (gptel-log-level 'info)
  (gptel-include-reasoning 'ignore)
  (gptel-use-tools t)
  (gptel-track-media t)
  (gptel-use-context nil)
  (gptel-use-header-line t)
  (gptel-org-branching-context t)
  (gptel-prompt-prefix-alist
   '((markdown-mode . "## User: ")
     (org-mode . "* Prompt: ")
     (text-mode . "User: ")))
  (gptel-response-prefix-alist
   '((markdown-mode . "## Assistant\n")
     (org-mode . "** Response:")
     (text-mode . "Assistant: ")))

  :preface

  (defun my/gptel-remove-extra-whitespace (beg end)
    "Collapse excess blank lines within the response from BEG to END."
    (save-excursion
      (save-restriction
        (narrow-to-region beg end)
        (goto-char (point-min))
        (while (re-search-forward "\n\n\n+" nil t)
          (replace-match "\n\n")))))

  (defun my/gptel-previous-prompt ()
    (interactive)
    (goto-char (line-beginning-position))
    (when (re-search-backward
           (regexp-quote (gptel-prompt-prefix-string)) nil t)
      (goto-char (line-end-position))))

  (defun my/gptel-next-prompt (&rest _ignore)
    (interactive)
    (goto-char (line-end-position))
    (when (re-search-forward
           (regexp-quote (gptel-prompt-prefix-string)) nil t)
      (goto-char (line-end-position))))

  (defun my/proofread-concise ()
    "Proofread and tighten the writing."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar and spelling, then cut unnecessary words for conciseness."))
      (call-interactively #'gptel-rewrite)))

  (defun my/proofread-dwim ()
    "Proofread region or paragraph — fix grammar and spelling."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar, spelling and punctuation. Preserve tone and meaning."))
      (call-interactively #'gptel-rewrite)))


  (defun my/proofread-formal ()
    "Proofread and raise the register to formal."
    (interactive)
    (unless (use-region-p) (mark-paragraph))
    (minibuffer-with-setup-hook
        (lambda () (insert "Fix grammar and spelling, then rewrite in a formal professional tone."))
      (call-interactively #'gptel-rewrite)))

  :config

  ;; These are defvars
  (setq gptel-expert-commands t)

  (setq gptel-model 'gpt-5.6-sol
        gptel-backend (gptel-make-openai-oauth "OpenAI-sub"))


  (make-variable-buffer-local 'gptel-context)

  (add-hook 'gptel-post-response-functions #'my/gptel-remove-extra-whitespace)
  (add-hook 'gptel-post-response-functions #'my/gptel-next-prompt 10)


  )

(provide 'my-config-gptel)
;;; my-config-gptel.el ends here
