;;; my-config-file-transfer.el --- Personal file-transfer configuration -*- no-byte-compile: t; lexical-binding: t; -*-

(defun my/copy-file-to-download-folder (source-file)
  "Copy SOURCE-FILE to a fixed destination folder without prompting."
  (interactive "fCopy file: ")
  (let ((destination-folder "~/Downloads/"))
    (copy-file source-file (expand-file-name (file-name-nondirectory source-file) destination-folder) t)))

(defun my/copy-folder-to-download-folder (source-directory)
  "Copy SOURCE-DIRECTORY recursively into ~/Downloads/ without prompting."
  (interactive "DCopy directory: ")
  (let* ((destination-folder "~/Downloads/")
         (directory-name
          (file-name-nondirectory
           (directory-file-name source-directory)))
         (destination
          (expand-file-name directory-name destination-folder)))
    (copy-directory source-directory destination nil nil t)))

(defun my/upload-file-to-remote-folder (source-file destination-folder)
  "Copy local SOURCE-FILE to remote DESTINATION-FOLDER."
  (interactive
   (list
    (read-file-name "Upload local file: " nil nil t)
    (read-directory-name "Remote destination: ")))
  (copy-file
   source-file
   (expand-file-name
    (file-name-nondirectory source-file)
    destination-folder)
   t))


(defun my/upload-file-with-consult-tramp (source-file)
  "Upload local SOURCE-FILE to a remote directory selected with consult-tramp."
  (interactive "fUpload local file: ")
  (let* ((remote-directory
          ;; Pick a TRAMP destination using consult-tramp.
          (consult-tramp))
         (destination
          (expand-file-name
           (file-name-nondirectory source-file)
           remote-directory)))
    (copy-file source-file destination t)
    (message "Uploaded %s -> %s"
             source-file destination)))

(provide 'my-config-file-transfer)
;;; my-config-file-transfer.el ends here
