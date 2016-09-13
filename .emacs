(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'load-path "~/.emacs.d/modules/easy-build")
(add-to-list 'load-path "~/.emacs.d/lang")
(package-initialize)

; other language support
(require 'lang-autoit)

; general settings
(setq split-height-threshold 1200)
(setq split-width-threshold 2000)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq auto-save-default nil)

; easy build system
(require 'easy-build)
(setq makescript "build.bat")


; hotkeys
(define-key global-map "\eh" 'cff-find-other-file)       ; ALT+H (Search .h/.cpp file by source) 
(define-key global-map "\ep" 'imenu)                     ; ALT+P (Search function and jump to it) 
(define-key global-map "\ef" 'find-file)                 ; ALT+F (Find file in current window)
(define-key global-map "\eF" 'find-file-other-window)    ; ALT+SHIFT+F (Find file in second window)
(define-key global-map "\ew" 'other-window)              ; ALT+W (Switch to other window)
(define-key global-map "\eu" 'undo)                      ; ALT+U (Undo last step)
(define-key global-map "\eq" 'kill-emacs)                ; ALT+Q
(define-key global-map "\en" 'next-error)                ; ALT+N
(define-key global-map "\eN" 'previous-error)            ; ALT+SHIFT+N
(define-key global-map "\em" 'make-without-asking)       ; ALT+M (Compile without asking. !See makescript)
(define-key global-map "\er" 'revert-buffer)             ; ALT+R
(define-key global-map "\ek" 'kill-this-buffer)          ; ALT+K 
(define-key global-map "\es" 'save-buffer)               ; ALT+S
(define-key global-map "\t" 'dabbrev-expand)
(define-key global-map [backtab] 'indent-for-tab-command)
(define-key global-map [C-next] 'scroll-other-window)
(define-key global-map [C-prior] 'scroll-other-window-down)

(require 'ido)
(global-set-key (read-kbd-macro "\eb")  'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB")  'ido-switch-buffer-other-window)


; C++ indentation style
(defconst casey-big-fun-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
    "Casey's Big Fun C++ Style")

(defun casey-big-fun-c-hook ()
  ; Set my style for the current buffer
  (c-add-style "BigFun" casey-big-fun-c-style t)
  
  ; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

  ; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ; No hungry backspace
  (c-toggle-auto-hungry-state -1)

  ; Newline indents, semi-colon doesn't
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

  ; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)

  ; Abbrevation expansion
  (abbrev-mode 1))


(defun dired-find-file-other-frame ()
    "In Dired, visit this file or directory in another window."
    (interactive)
    (find-file-other-frame (dired-get-file-for-visit)))

;; layout style

(load-theme 'gruber-darker t)
(add-to-list 'default-frame-alist '(font . "Liberation Mono-8.5"))
(set-face-attribute 'default t :font "Liberation Mono-8.5")


;; window customization 
(defun post-load-stuff ()
  (interactive)
  (cua-mode t)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (toggle-frame-maximized)	
  (split-window-horizontally)
  (set-foreground-color "burlywood3")
  (set-background-color "#161616")
  (set-default 'truncate-lines t))

;; compilation buffer setup
(defun my-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
)

;; hooks
(add-hook 'c-mode-common-hook 'casey-big-fun-c-hook)
(add-hook 'compilation-mode-hook 'my-compilation-hook)
(add-hook 'window-setup-hook 'post-load-stuff t)
