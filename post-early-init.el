;;; post-early-init.el --- Package policy -*- no-byte-compile: t; lexical-binding: t; -*-

;; Built-in package.el installs the few third-party packages.  They opt in
;; explicitly with `:ensure' or `:vc', so built-in libraries are never fetched.
(setq use-package-always-ensure nil
      package-quickstart t
      package-install-upgrade-built-in nil
      ;; Prefer MELPA's development snapshots (meow, gptel, ghostel, ...).
      package-archive-priorities '(("melpa" . 99) ("gnu" . 80) ("nongnu" . 70)))

;; codex-ide's autoloads define Transient menus, which would load Transient at
;; every startup.  Leave it inactive; my-tools.el loads it on first use.
(setq package-load-list '((codex-ide nil) all))

;;; post-early-init.el ends here
