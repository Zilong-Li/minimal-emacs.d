Native tree-sitter configuration
===============================

`my-treesit.el` uses the built-in `treesit` API in Emacs 29 and newer.
Emacs builds without tree-sitter and missing/incompatible grammars retain
classic major modes. Remappings require both an available mode and all its
grammar dependencies. No grammars are downloaded during startup or file visits.

After restarting Emacs:

- `M-x my/treesit-status` shows mode availability and grammar load errors.
- `M-x my/treesit-install-all-missing` builds the grammars needed by available
  modes, then refreshes remappings. Git and C/C++ build tools must be on PATH.
- `M-x treesit-install-language-grammar` installs an individual grammar and
  also refreshes remappings.
- Reopen a file (or run `M-x normal-mode`) to apply the new selection.

The installer uses the one-argument API supported by Emacs 29. Installation
failures appear in `*Warnings*` and the final summary. Restart after replacing
a grammar that was already loaded: Emacs can keep the old library in memory.

`my/treesit-modes` lists modes and dependencies. `my/treesit-sources` supplies
default grammar recipes without replacing user recipes. ABI 14 pins for core
grammars follow the compatibility revisions maintained by
[treesit-auto](https://github.com/renzmann/treesit-auto/blob/main/treesit-auto.el).
Some community grammar recipes still track their upstream default branch;
use `treesit-language-source-alist` to pin a revision when necessary. ABI
compatibility alone does not guarantee compatibility with a mode's queries.

TypeScript/TSX and Go/go.mod require both grammars because they share mode
libraries. `.ts` and `.tsx` use JavaScript mode when their grammars are absent.
YAML recognizes both `.yaml` and `.yml`. Rust retains `rust-mode` and its
existing rustfmt-on-save setup. Modes added in later Emacs releases are only
remapped when present. Explicit user remappings take precedence.

Run the regression checks from this configuration directory:

```sh
emacs -Q --batch -L lisp -l tests/my-treesit-tests.el -f ert-run-tests-batch-and-exit
```
