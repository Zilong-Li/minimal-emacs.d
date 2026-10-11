;;; my-config-docker-container.el --- Personal docker-container configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package docker-container
  :commands docker-containers
  :custom
  (docker-containers-shell-file-name "/bin/bash")
  (docker-containers-show-all nil))

(provide 'my-config-docker-container)
;;; my-config-docker-container.el ends here
