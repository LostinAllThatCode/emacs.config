;;; -*- coding: utf-8-unix; -*-
;;; Emacs-DevTools - An easy emacs setup for developers
;;;
;;; Copyright (C) 2015 by it's authors.
;;; All rights reserved. See LICENSE, AUTHORS.
;;;
;;; lang-autoit.el --- AutoIt3 language support

;; install and initialization
(add-to-list 'load-path "C:/Users/agaida/AppData/Roaming/.emacs.d/lang/autoit-mode")

;; Fix: undeclared variable on upstream code
(defvar *autoit-smie-backward-bob* nil)

;; Enable to autoload the module
(autoload 'autoit-mode "autoit-mode" "Mode for AutoIt3 files" t nil)

;; Autoload cl functions when needed
(autoload 'mapcan "cl" "Common Lisp functions on Emacs" t nil)

;; activate mode automatically
(add-to-list 'auto-mode-alist '("\.au3$" . autoit-mode))

;; custom logic for autoit indentation
;; the official one is still a WIP
(defun my-autoit-indent-end-token-p ()
  (or (looking-at "^[ \t]*End*")
      (looking-at "^[ \t]*Next")
      (looking-at "^[ \t]*EndSelect")
      (looking-at "^[ \t]*EndSwitch")
      (looking-at "^[ \t]*WEnd")))

; Stolen from http://www.emacswiki.org/emacs/ModeTutorial
(defun my-autoit-indent-line ()
  "Indent autoit code"
  (interactive)
  (beginning-of-line)
  (if (bobp) (indent-to 0)
    (let ((not-indented t) cur-indent)
      (if (or (my-autoit-indent-end-token-p) (looking-at "^[ \t]*Else"))
          (progn
            (save-excursion
              (forward-line -1)
              (setq cur-indent (- (current-indentation) standard-indent)))
            (if (< cur-indent 0)
                (setq cur-indent 0)))
        (save-excursion
          (while not-indented ; Iterate backwards until we find an indentation hint
            (forward-line -1)
            (if (my-autoit-indent-end-token-p)
                (progn
                  (setq cur-indent (current-indentation))
                  (setq not-indented nil))
              (if (looking-at "^[ \t]*\\(If\\|Func\\|While\\|For\\|Switch\\|Select\\)") ; This hint indicates that we need to indent an extra level
                  (progn
                    (setq cur-indent (+ (current-indentation) standard-indent))
                    (setq not-indented nil))
                (if (bobp)
                    (setq not-indented nil)))))))
      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

;; Fix the identation
(add-hook 'autoit-mode-hook
          (lambda ()
		    (set-face-attribute 'font-lock-builtin-face nil :foreground "DarkGoldenrod3")
            (set-face-attribute 'font-lock-variable-name-face nil :bold t :foreground "burlywood3")
            (set-face-attribute 'font-lock-function-name-face nil :foreground "burlywood3")
            (setq indent-line-function 'my-autoit-indent-line)))

(provide 'lang-autoit)
