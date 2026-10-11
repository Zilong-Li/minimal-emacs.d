;;; my-config-kirigami.el --- Personal kirigami configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package kirigami
  :ensure nil
  :bind (("C-c l o" . kirigami-toggle-fold))
  :init
  (kirigami-global-mode 1))

(provide 'my-config-kirigami)
;;; my-config-kirigami.el ends here
