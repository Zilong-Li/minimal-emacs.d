;;; my-config-nano-elfeed.el --- Personal nano-elfeed configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package nano-elfeed
  :after elfeed
  :init
  (setq nano-elfeed-icon-path (concat straight-base-dir "straight/repos/nano-elfeed/icons"))
  :config
  (setq nano-elfeed-icons
        `(("RSS"             . ,(nano-elfeed-make-icon "default"))
          ("BioRxiv Bioinformatics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("BioRxiv Genetics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("BioRxiv Genomics"   . ,(nano-elfeed-make-icon "biorxiv"))
          ("Science"           . ,(nano-elfeed-make-icon "science"))
          ("Nature"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Genetics"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Methods"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Medicine"           . ,(nano-elfeed-make-icon "nature"))
          ("Nature Biotechnology"           . ,(nano-elfeed-make-icon "nature"))
          ("eLife"           . ,(nano-elfeed-make-icon "elife"))
          ("eLife Genetics Genomics"           . ,(nano-elfeed-make-icon "elife"))
          ("eLife Evolutionary Biology"           . ,(nano-elfeed-make-icon "elife"))
          ("Emacs"           . ,(nano-elfeed-make-icon "reddit"))
          ("Emacs org-mode"  . ,(nano-elfeed-make-icon "reddit"))
          ("Paris Review"    . ,(nano-elfeed-make-icon "parisreview"))
          ("McSweeney's"    . ,(nano-elfeed-make-icon "mcsweeneys"))
          ("Aeon"            . ,(nano-elfeed-make-icon "aeon"))
          ("Slashdot"        . ,(nano-elfeed-make-icon "slashdot"))
          ("Ars Technica"    . ,(nano-elfeed-make-icon "ars-technica"))
          ("Boing Boing"     . ,(nano-elfeed-make-icon "boing-boing"))
          ("Plos Comp.Bio"   . ,(nano-elfeed-make-icon "plos"))
          ("Quanta"          . ,(nano-elfeed-make-icon "quanta"))
          ))

  )

(provide 'my-config-nano-elfeed)
;;; my-config-nano-elfeed.el ends here
