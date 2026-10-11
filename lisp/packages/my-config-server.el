;;; my-config-server.el --- Personal server configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(require 'server)
(unless (or noninteractive (daemonp) (server-running-p))
  (server-start))

(provide 'my-config-server)
;;; my-config-server.el ends here
