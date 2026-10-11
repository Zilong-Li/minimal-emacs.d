;;; my-config-ox-latex.el --- Personal ox-latex configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package ox-latex
  :defer t
  :after org
  :custom
  ;;; %latex gets replaced with org-latex-compiler
  ;;; OR overridden by the #+LATEX_COMPILER header
  (org-latex-compiler "lualatex")
  (org-latex-pdf-process '("latexmk -f -pdf -%latex -interaction=nonstopmode -shell-escape -output-directory=%o %f"))
  (org-latex-toc-command "\\tableofcontents
\\clearpage
")
  (org-latex-src-block-backend 'engraved)
  (org-latex-packages-alist
   '(("T1" "fontenc" t)
     ("" "amsmath" t)
     ("" "mathtools" t)
     ("" "siunitx" t)
     ("" "fvextra" t) ;; for engrave-faces
     ("" "lmodern" t)
     ("" "booktabs" t)
     ))
  )



(with-eval-after-load 'ox-latex
  ;; (require 'oc-natbib)
  (require 'oc-biblatex)
  (setq bibtex-dialect 'biblatex)
  (setq org-latex-default-class "article")
  (setq org-cite-export-processors
        '((latex biblatex)
          (t basic)))
  ;; accessible tagged pdf: https://jamesendreshowell.com/2025-12-29-org-mode-latex-and-tagged-pdfs-producing-accessible-documents.html
  (defvar org-latex-metadata "\\DocumentMetadata{lang = en, pdfversion = 2.0, pdfstandard = ua-2, pdfstandard = a-4}"
    "LaTeX preamble command to specify PDF accessibility metadata.\nIt must appear before the \\documentclass{} declaration.")

  (setq org-latex-classes
        `(
          ("article" ,(concat org-latex-metadata "\n" "\\documentclass[11pt]{article}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ))
  (add-to-list 'org-latex-classes
               '("chinese"
                         "\\documentclass[11pt]{article}
\\usepackage{xeCJK}
[EXTRA]
[PACKAGES]"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                         ))
  (add-to-list 'org-latex-classes
               '("minipaper"
                         "\\documentclass[letterpaper,12pt,leqno]{article}
\\usepackage{paper}
[NO-DEFAULT-PACKAGES]
[EXTRA]
[PACKAGES]"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                         ))
  )

(my/report-time "Org latex")

(provide 'my-config-ox-latex)
;;; my-config-ox-latex.el ends here
