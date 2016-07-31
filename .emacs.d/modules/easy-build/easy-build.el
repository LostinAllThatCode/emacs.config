
(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p makescript) t
    (cd "../")
    (find-project-directory-recursive)))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (setq compilation-scroll-output t)
  (if (find-project-directory) (compile makescript))
  (other-window 1))

(provide 'easy-build)