# Personal configuration

This directory combines the upstream minimal-emacs.d foundation with a small
personal layer. It prefers built-in Emacs features and keeps third-party
packages to the key UI, editing and workflow tools.

Requires Emacs 31 or newer. Start it with:

```sh
emacs --init-directory /Users/rlk420/Projects/minimal-emacs.d --debug-init
```

The first start installs the packages with the built-in package.el (MELPA is
preferred, then GNU and NonGNU ELPA). Ghostel offers to download its native
module the first time it loads; PDF Tools builds `epdfinfo` the first time a
PDF is opened. Tree-sitter grammars are installed on demand: Emacs asks once
per language when a file first needs one.

## Files

`config.org` is a literate version of every personal file below; tangle it
(`C-c C-v t`, or `emacs --batch -l org config.org -f org-babel-tangle`) to
regenerate them.

Keep the upstream `init.el`, `early-init.el` and README unchanged so upstream
updates can be applied independently.

- `pre-early-init.el`: frame parameters and startup choices.
- `post-early-init.el`: package archives and package.el policy.
- `pre-init.el`: activates installed packages from the quickstart file.
- `post-init.el`: loads the modules below in order.
- `lisp/my-defaults.el`: built-in behaviour, files, history, platform, server.
- `lisp/my-ui.el`: NANO theme and header line, fonts, windows, perspectives.
- `lisp/my-keys.el`: Meow, structural editing, avy, global keys, `C-q` prefix.
- `lisp/my-completion.el`: Vertico, Orderless, Marginalia, Consult, Corfu, Tempel.
- `lisp/my-tools.el`: Dired, projects, TRAMP, Magit, shells, Ghostel, EWW,
  PDF Tools, gptel, codex-ide, speech and screenshots.
- `lisp/my-prog.el`: tree-sitter, Eglot, Python, ESS, C/C++, shell, LaTeX.
- `lisp/my-org.el`: Org, agenda, capture, LaTeX export.
- `templates`: Tempel templates.

## Packages

Third-party packages: meow, meow-tree-sitter, nano-theme, nano-modeline,
vertico, orderless, marginalia, consult, corfu, tempel, avy, persp-mode, magit,
ess, pdf-tools, gptel, codex-ide and ghostel.

Everything else uses built-in Emacs features:

| Instead of                     | Built-in                                         |
|--------------------------------|--------------------------------------------------|
| straight.el                    | package.el, `use-package :vc`, quickstart        |
| smartparens                    | `electric-pair-local-mode`, sexp commands in `my-keys.el` |
| ace-window, popper             | `other-window`, side windows (`` C-` ``, `C-c o o`) |
| cape, capf-autosuggest         | `dabbrev-capf`, `ispell-completion-at-point`, a file capf |
| embark                         | `which-key` (press `C-h` after a prefix)         |
| hide-mode-line                 | `my/toggle-mode-line` (`C-c l s`)                |
| kirigami, outline-indent       | Hideshow/Outline via `my/toggle-fold` (`F`)      |
| hl-todo                        | font-lock keywords (`my/todo-keywords`)          |
| vundo                          | `undo-redo` (`U`)                                |
| ultra-scroll                   | `pixel-scroll-precision-mode`                    |
| flymake-ruff                   | `python-flymake-command` running ruff            |
| rust/go/yaml/web/lua modes     | tree-sitter modes (`treesit-enabled-modes`)      |
| AUCTeX, cdlatex, xenops        | `latex-mode` with RefTeX                         |
| my-treesit.el                  | `treesit-enabled-modes`, `treesit-auto-install-grammar` |

To add a package, declare it with `use-package` and `:ensure t` (or `:vc` for
a Git repository) in the module where it belongs. Update packages with
`M-x package-upgrade-all`; the quickstart file is refreshed automatically.

codex-ide is installed but not activated at startup, because its autoloads
would load Transient; it is loaded on the first `codex-ide-menu` (`C-q g c`).
