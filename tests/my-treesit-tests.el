;;; my-treesit-tests.el --- Tree-sitter selection regressions -*- lexical-binding: t; -*-

(require 'ert)
(require 'my-treesit)

(defmacro my/treesit-test-state (&rest body)
  "Run BODY with isolated mode mappings."
  (declare (indent 0))
  `(let ((my/treesit-modes
          '((python-ts-mode (python) (python-mode))
            (typescript-ts-mode (typescript tsx) (typescript-mode))))
         (my/treesit-file-modes '(("\\.ts\\'" typescript-ts-mode js-mode)))
         (major-mode-remap-alist '((unrelated-mode . personal-mode)))
         (auto-mode-alist '(("\\.custom\\'" . personal-mode)))
         (my/treesit--remaps nil)
         (my/treesit--file-associations nil))
     ,@body))

(ert-deftest my/treesit-no-native-support ()
  (my/treesit-test-state
    (cl-letf (((symbol-function 'treesit-available-p) (lambda () nil))
              ((symbol-function 'treesit-language-available-p)
               (lambda (&rest _) (ert-fail "Grammar checked without native support"))))
      (my/treesit-refresh)
      (should (eq (cdr (assq 'unrelated-mode major-mode-remap-alist)) 'personal-mode))
      (should (eq (cdr (assq 'python-ts-mode major-mode-remap-alist)) 'python-mode))
      (should-not (assq 'python-mode major-mode-remap-alist))
      (should (eq (cdr (assoc "\\.ts\\'" auto-mode-alist)) 'js-mode))
      (should-error (my/treesit-install-all-missing) :type 'user-error))))

(ert-deftest my/treesit-missing-and-incompatible-grammar ()
  (my/treesit-test-state
    (cl-letf (((symbol-function 'treesit-available-p) (lambda () t))
              ((symbol-function 'treesit-language-available-p) (lambda (&rest _) nil)))
      (my/treesit-refresh)
      (should-not (assq 'python-mode major-mode-remap-alist))
      (should (eq (cdr (assoc "\\.ts\\'" auto-mode-alist)) 'js-mode)))))

(ert-deftest my/treesit-requires-all-grammars ()
  (my/treesit-test-state
    (cl-letf (((symbol-function 'treesit-available-p) (lambda () t))
              ((symbol-function 'treesit-language-available-p)
               (lambda (lang &optional _) (memq lang '(python typescript)))))
      (my/treesit-refresh)
      (should (eq (cdr (assq 'python-mode major-mode-remap-alist)) 'python-ts-mode))
      (should-not (assq 'typescript-mode major-mode-remap-alist)))))

(ert-deftest my/treesit-missing-mode-on-older-emacs ()
  (my/treesit-test-state
    (let ((my/treesit-modes '((my/nonexistent-ts-mode (python) (python-mode)))))
      (cl-letf (((symbol-function 'treesit-available-p) (lambda () t))
                ((symbol-function 'treesit-language-available-p) (lambda (&rest _) t)))
        (my/treesit-refresh)
        (should-not (assq 'python-mode major-mode-remap-alist))))))

(ert-deftest my/treesit-refresh-preserves-overrides-and-removes-stale-mappings ()
  (my/treesit-test-state
    (push '(python-mode . personal-python-mode) major-mode-remap-alist)
    (let ((available t))
      (cl-letf (((symbol-function 'treesit-available-p) (lambda () t))
                ((symbol-function 'treesit-language-available-p)
                 (lambda (&rest _) available)))
        (my/treesit-refresh)
        (my/treesit-refresh)
        (should (eq (cdr (assq 'python-mode major-mode-remap-alist)) 'personal-python-mode))
        (should (= 1 (cl-count 'typescript-mode major-mode-remap-alist :key #'car)))
        (should (eq (cdr (assoc "\\.ts\\'" auto-mode-alist)) 'typescript-ts-mode))
        (setq available nil)
        (my/treesit-refresh)
        (should (equal (cl-remove-if (lambda (entry) (memq entry my/treesit--remaps))
                                    major-mode-remap-alist)
                       '((python-mode . personal-python-mode) (unrelated-mode . personal-mode))))
        (should (eq (cdr (assq 'python-ts-mode major-mode-remap-alist)) 'python-mode))
        (should (eq (cdr (assoc "\\.ts\\'" auto-mode-alist)) 'js-mode))
        (should (assoc "\\.custom\\'" auto-mode-alist))))))

(ert-deftest my/treesit-installer-emacs29-arity-and-warning-failure ()
  (my/treesit-test-state
    (let (installed calls warnings)
      (cl-letf (((symbol-function 'treesit-available-p) (lambda () t))
                ((symbol-function 'treesit-language-available-p)
                 (lambda (lang &optional _) (memq lang installed)))
                ;; Exactly one argument: the API supported by Emacs 29.
                ((symbol-function 'treesit-install-language-grammar)
                 (lambda (lang)
                   (push lang calls)
                   (unless (eq lang 'tsx) (push lang installed))))
                ((symbol-function 'display-warning)
                 (lambda (_ text &rest _) (push text warnings))))
        (my/treesit-install-all-missing)
        (should (equal (sort calls #'string-lessp) '(python tsx typescript)))
        (should warnings)
        (should (assq 'python-mode major-mode-remap-alist))
        (should-not (assq 'typescript-mode major-mode-remap-alist))))))

;;; my-treesit-tests.el ends here
