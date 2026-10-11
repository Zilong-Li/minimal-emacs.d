;;; my-config-project.el --- Personal project configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package project
  :preface
  (defun my/kill-project-and-perspective ()
    "Kill all buffers in the current project and remove its perspective."
    (interactive)
    (let* ((project (project-current))
           (persp-name (and project (file-name-nondirectory
                                     (directory-file-name
                                      (project-root project))))))
      (if (not project)
          (message "Not in a project")
        ;; Kill all project buffers using built-in command
        (project-kill-buffers)

        ;; Kill the perspective if it exists
        (when (and persp-name (persp-with-name-exists-p persp-name))
          (persp-kill persp-name)
          (message "Killed perspective: %s" persp-name)))))

  ;; Custom function to add remote project manually
  (defun my/add-remote-project (remote-path)
    "Add a remote project path to project.el's known projects."
    (interactive "sEnter remote path (e.g. /ssh:user@host:/path/to/project): ")
    (project-remember-project
     (project--find-in-directory (file-name-as-directory remote-path))))

  (defun +project-switch-project-dired (dir)
    (interactive (list (project-prompt-project-dir)))
    (dired dir))

  ;; Function to create or switch to a perspective for a project
  (defun project-persp-switch (project-root)
    "Switch to a perspective named after the PROJECT-ROOT.
Create the perspective if it doesn't exist."
    (interactive)
    (let ((persp-name (file-name-nondirectory
                       (directory-file-name project-root))))
      (if (persp-with-name-exists-p persp-name)
          (persp-switch persp-name)
        ;; Create a new perspective
        (persp-switch persp-name)
        ;; Additional setup for the new perspective if needed
        )))

  ;; Advice to integrate with project.el's project switching
  (defun project-persp-advice (orig-fun &rest args)
    "Advice for `project-switch-project' to create/switch to a perspective."
    (let ((project-root (if args
                            (car args)
                          (project-root (project-current)))))
      (project-persp-switch project-root)
      (apply orig-fun args)))

  ;;; Create a custom command to be added to project-switch-commands
  (defun project-persp-dired ()
    "Open dired in the project root, creating/switching to a perspective for the project."
    (interactive)
    (let ((project (project-current t)))
      (when project
        (let ((root (project-root project)))
          (project-persp-switch root)
          (dired root)))))

  ;; Also integrate with project-find-file
  (defun project-find-file-with-persp-advice (orig-fun &rest args)
    "Advice for `project-find-file' to switch to the project's perspective."
    (let ((project (project-current t)))
      (when project
        (project-persp-switch (project-root project)))
      (apply orig-fun args)))

  :bind (
         ("C-c p p" . project-switch-project)
         ("C-c p d" . project-persp-dired)
         ("C-c p k" . my/kill-project-and-perspective)
         ("C-c p f" . project-find-file)
         ("C-c p F" . project-forget-project)
         ("C-c p c" . project-compile)
         ("C-c p b" . project-switch-to-buffer)
         )

  :custom
  (project-vc-extra-root-markers '(".dir-locals.el"))

  :config
  ;; Custom function to detect project root with TRAMP support
  (defun my/project-try-tramp (dir)
    "Detect project root in DIR, with TRAMP support."
    (let ((root (or (locate-dominating-file dir ".git")
                    (locate-dominating-file dir "Makefile")
                    (locate-dominating-file dir "package.json")
                    (locate-dominating-file dir "setup.py")
                    (locate-dominating-file dir ".project"))))
      (when root
        (cons 'transient root))))

  ;; Add our custom project root detector
  (add-hook 'project-find-functions #'my/project-try-tramp)

  (add-to-list 'project-switch-commands
               '(magit-project-status "Magit" ?M) t)

  ;; Configure project.el to cache remote project information
  (setq project-list-file (locate-user-emacs-file "project-list"))

  ;; Add the advice to project-switch-project
  (advice-add 'project-switch-project :around #'project-persp-advice)

  (advice-add 'project-find-file :around #'project-find-file-with-persp-advice)

  ;; Add the command to project-switch-commands
  (add-to-list 'project-switch-commands '(?p "Perspective" project-persp-dired))

  )

(provide 'my-config-project)
;;; my-config-project.el ends here
