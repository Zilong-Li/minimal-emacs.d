;;; my-config-docker.el --- Personal docker configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package docker
  :defer t
  :bind ("C-c D" . docker)
  :init
  (require 'my-config-docker-image "packages/my-config-docker-image")
  (require 'my-config-docker-volume "packages/my-config-docker-volume")
  (require 'my-config-docker-network "packages/my-config-docker-network")
  (require 'my-config-docker-compose "packages/my-config-docker-compose")

  (require 'my-config-docker-container "packages/my-config-docker-container"))

(provide 'my-config-docker)
;;; my-config-docker.el ends here
