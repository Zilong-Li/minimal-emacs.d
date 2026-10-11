;;; my-config-epg-config.el --- Personal epg-config configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(require 'epg-config)

(setq epg-gpg-program (or (executable-find "gpg") "gpg")      ; What gpg program to use
      auth-source-debug nil         ; debug auth-source
      epg-user-id "bbl"           ; GnuPG ID of your default identity
      mml2015-use 'epg            ; The package used for PGP/MIME.
      mml-secure-openpgp-encrypt-to-self t   ; Add our own key ID to recipient list
      mml-secure-openpgp-sign-with-sender t) ; Use message sender to find a key to sign with.

;; GnuPG 2.1 or later has an option to control the behavior of
;; Pinentry invocation.  The value should be the symbol ‘error’,
;; ‘ask’, ‘cancel’, or ‘loopback’.
;; Default 'nil' will use external/system program to enter pin entry
;; (setq epg-pinentry-mode 'loopback)

(provide 'my-config-epg-config)
;;; my-config-epg-config.el ends here
