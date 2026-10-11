;;; my-config-rust-mode.el --- Personal rust-mode configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package rust-mode
  :mode (("\\.rs$" . rust-mode))
  :preface
  (defun sp1ff/rust/mode-hook ()
    "My rust-mode hook"
    (column-number-mode)
    (hs-minor-mode)
    ;; Rust style guide
    ;; <https://github.com/rust-lang-nursery/fmt-rfcs/blob/master/guide/guide.md>
    (setq indent-tabs-mode nil
          tab-width 4
          c-basic-offset 4
          fill-column 100))
  :hook (rust-mode . sp1ff/rust/mode-hook)
  :config
  (let ((dot-cargo-bin (expand-file-name "~/.cargo/bin/")))
    (setq rust-rustfmt-bin (concat dot-cargo-bin "rustfmt")
          rust-cargo-bin (concat dot-cargo-bin "cargo")
          rust-format-on-save t))
  )

(provide 'my-config-rust-mode)
;;; my-config-rust-mode.el ends here
