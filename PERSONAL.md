# Personal configuration

This directory combines the upstream minimal-emacs.d foundation with the
personal configuration migrated from `../emacs.d/mini.org`, including its
uncommitted changes at migration time. The original directory is untouched.

Requires Emacs 29 or newer and Git. Start this configuration with:

```sh
emacs --init-directory /Users/rlk420/Projects/minimal-emacs.d --debug-init
```

The first start downloads Elpaca and installs the declared packages. This can
take several minutes. Packages with native components, such as Rime,
Ghostel and PDF Tools, still require their external build dependencies.
Your existing font, Org, bibliography, mail and external-tool paths remain
personal machine settings; those data files are not copied here.

Edit `mini.org`, then run `M-x org-babel-tangle` or:

```sh
emacs -Q --batch -l /Users/rlk420/Projects/minimal-emacs.d/tangle.el
```

Tangle generates only these personal files:

- `pre-early-init.el`: disables package.el initialization and sets frame choices.
- `post-early-init.el`: disables automatic package.el installation by use-package.
- `pre-init.el`: bootstraps Elpaca and queues its use-package integration.
- `post-init.el`: queues personal packages, waits for activation, configures the
  editor and enables personal modes.
- `templates`: Tempel templates.

`elfeed.org` is the copied feed list. `init.el`, `early-init.el` and the upstream
README remain unchanged so upstream updates can be applied independently.
Generated customization files are tracked alongside their literate source.
Runtime caches, downloaded packages, saved histories and custom.el are ignored.

Elpaca installs packages in parallel. A single `elpaca-wait` before the personal
configuration preserves the ordering needed by direct `require` calls and
definitions that use package APIs. Existing command/hook-based deferred loading
is preserved. Package installation is declared centrally; use-package's automatic
installation is disabled. To add a package, add it to `package-list`, or add a
recipe to `my/elpaca-custom-recipes` for a custom repository. Recipes take
precedence over the general list. Use `M-x elpaca-manager` to inspect packages.
See the [Elpaca manual](https://github.com/progfolio/elpaca/blob/master/doc/manual.md)
for recipe syntax and package management.

Startup garbage collection and native compilation paths are managed by
minimal-emacs.d; the old GCMH block is inactive. Personal auto-save intervals
and backup retention are preserved with the starter kit's centralized directories.
Temporary startup mode-line hiding is disabled to let hide-mode-line/Nano own
the final state. The local bin directory is expanded correctly in PATH, and
Nano Elfeed icons are located through the installed library instead of Straight.

This migration does not change your default Emacs profile or ~/.emacs.d symlink.
