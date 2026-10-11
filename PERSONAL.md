# Personal configuration

This directory combines the upstream minimal-emacs.d foundation with the
personal configuration originally migrated from `../emacs.d/mini.org`.
Personal customizations are now maintained directly in the `.el` files.

Requires Emacs 29 or newer and Git. Start this configuration with:

```sh
emacs --init-directory /Users/rlk420/Projects/minimal-emacs.d --debug-init
```

The first start downloads Straight and installs the declared packages into
`straight/`. Native packages such as Ghostel and PDF Tools still require their
external build dependencies. Your font, Org, bibliography, mail and external-tool
paths remain personal machine settings.

Edit the customization files directly:

- `pre-early-init.el`: disables package.el initialization and sets frame choices.
- `post-early-init.el`: disables automatic package.el installation by use-package.
- `pre-init.el`: bootstraps Straight with built-in use-package.
- `post-init.el`: loads personal modules in their dependency order.
- `lisp/packages/my-config-PACKAGE.el`: each package's configuration, including
  built-in packages. Deferred subpackage modules are required from their parent's
  `:init` or `:config` block, preserving when they run.
- `lisp/my-config-bootstrap.el`: Straight recipes and the package installation list.
- Other `lisp/my-config-*.el` files: shared helpers, keybindings, platform settings,
  and integrations across packages.
- `templates`: Tempel templates.
- `elfeed.org`: RSS feed list.

Keep the upstream `init.el`, `early-init.el` and README unchanged so upstream
updates can be applied independently. Runtime caches, downloaded packages,
saved histories and custom.el are ignored.

Package installation is declared centrally: add ordinary packages to
`package-list` and custom repositories to `my/straight-custom-recipes` in
`lisp/my-config-bootstrap.el`. Custom recipes are installed first and take precedence over the
general list. Straight installs and activates each package synchronously before
the personal configuration runs. Existing deferred loading is preserved;
automatic installation by use-package is disabled.

To configure a package, edit its module under `lisp/packages/`. For a new package,
declare its installation in the bootstrap module, create a module with lexical
binding and `(provide 'my-config-PACKAGE)`, and add
`(require 'my-config-PACKAGE "packages/my-config-PACKAGE")` to `post-init.el` after
its dependencies. Modules are loaded once per session with `require`; restart
Emacs to apply the complete configuration again. Keep the explicit loader order
when moving integrations, especially Meow, completion, and Org setup.

Use `M-x straight-pull-package` to update a package, or
`M-x straight-freeze-versions` to record installed versions. See the
[Straight manual](https://github.com/radian-software/straight.el#user-manual)
for package management and recipe syntax.

Startup garbage collection and native compilation paths are managed by
minimal-emacs.d. Personal auto-save intervals and backup retention use the
starter kit's centralized directories. Temporary startup mode-line hiding is
disabled to let hide-mode-line/Nano own the final state. Frame dimensions are
merged with the early transparency and blur settings.
On macOS, early initialization also adds Homebrew GCC's `libemutls_w.a`
directory to `LIBRARY_PATH` so native compilation can link primitive trampolines.
The path is discovered through Homebrew's `opt/gcc` symlink after upgrades.

Org Agenda uses plain dates, ESS inspection uses a built-in help window, and
JSON editing and spelling correction use built-in Emacs commands. The SVG,
Nano Elfeed and ox-extra customizations were removed to avoid adding packages.

The old `elpaca/` cache is retained but is no longer initialized. Restart Emacs
when switching package managers so only Straight's packages are activated.
This change does not alter the default Emacs profile or ~/.emacs.d symlink.
