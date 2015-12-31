;;(setq my-emacs-libs "~angel/.emacs_libs")

;;(add-to-list 'load-path
;;             my-emacs-libs)

;;(load-file "/home/angel/.emacs_libs/emacs")
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(comint-completion-fignore (quote ("pyc" "~" "#" "o")))
 '(default-major-mode (quote emacs-lisp-mode) t)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(indent-tabs-mode nil)
 '(tab-width 4)
 '(inhibit-default-init t)
 '(inhibit-startup-screen t)
 '(initial-major-mode (quote emacs-lisp-mode))
 '(initial-scratch-message nil)
 '(make-backup-files t)
 '(menu-bar-mode nil)
 '(message-log-max 200)
 '(scroll-bar-mode nil)
 '(semantic-complete-inline-analyzer-displayor-class (quote semantic-displayor-traditional))
 '(shell-completion-fignore (quote ("pyc" "o" "~" "#")))
 '(flymake-no-changes-timeout 4)
 '(tool-bar-mode nil)
 '(ediff-split-window-function (quote split-window-horizontally))
 )

(setq split-height-threshold nil)
(setq split-width-threshold 0)

(set-cursor-color "blue1")
(show-paren-mode t)
(setq ring-bell-function 'ignore)


;; scroll window
(defun scroll-up-25%-window ()
  (interactive)
  (scroll-up (/ (window-height) 4)))

(defun scroll-down-25%-window ()
  (interactive)
  (scroll-down (/ (window-height) 4)))


;; fly-in-windows
(defun fly-other-window ()
  (interactive)
  (other-window 1))


;;fly switch to buffers
(defun user-bufferp (buffer)
  (if (not (string-match "^[[:space:]]*?\\*.*?\\*[[:space:]]*$"
                         (buffer-name buffer)))
      t
    nil))

;; (defun user-bufferp (buffer)
;;   (if (not (string-equal (substring (buffer-name buffer) 0 1) "*"))
;;       t
;;     nil))

(defun fly-switch-to-buffer ()
  (interactive)
  (let ((to (car (remove (current-buffer) (remove-if-not #'user-bufferp (buffer-list))))))
    (if to
        (progn
          (bury-buffer (buffer-name (current-buffer)))
          (switch-to-buffer to))
      (message "No user buffer"))))




(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
                     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))

(defun wy-back-to-char (n char)
  (interactive "p\ncBack to char: ")
  (search-backward (string char) nil nil n)
  (while (char-equal (read-char)
                     char)
    (search-backward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))



(global-set-key "\M-p" 'scroll-down-25%-window)
(global-set-key "\M-n" 'scroll-up-25%-window)
(global-set-key "\M-l" 'dabbrev-expand)

(global-set-key (kbd "M-q") 'fly-switch-to-buffer)
(global-set-key (kbd "M-j") 'fly-other-window)


(define-prefix-command 'ctl-o)
(global-set-key (kbd "C-o") 'ctl-o)
(define-key global-map (kbd "C-o f") 'wy-go-to-char)
(define-key global-map (kbd "C-o a") 'wy-back-to-char)



;; yasnippet
(require 'yasnippet)
;;(setq yas/root-directory "/home/angel/.emacs_libs/snippet")
;;(yas/load-directory "/home/angel/.emacs_libs/snippet")
(setq yas/root-directory (getenv "yas_root_directory"))
(yas/load-directory yas/root-directory)



;; ido
(require 'ido)
(ido-mode t)
;; completion-ignored-extensions
;; (add-to-list 'completion-ignored-extensions "#")



;; c c-mode-common-hook
(setq c-basic-offset 4
      c-default-style "linux")


;; python
(add-hook 'python-mode-hook
          #'(lambda ()
              (yas/minor-mode 1)))


(setq flymake-gui-warnings-enabled nil)
;; pyflakes pip install pyflakes
(when (load "flymake" t) 
  (defun flymake-pyflakes-init () 
    (let* ((temp-file (flymake-init-create-temp-buffer-copy 
                       'flymake-create-temp-inplace)) 
           (local-file (file-relative-name 
                        temp-file 
                        (file-name-directory buffer-file-name)))) 
      (list "pyflakes" (list local-file)))) 

  (add-to-list 'flymake-allowed-file-name-masks 
               '("\\.py\\'" flymake-pyflakes-init))) 

(add-hook 'find-file-hook 'flymake-find-file-hook)
(custom-set-faces
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "yellow")))))


;;
(require 'ffap)


;; dynamic abbrev
(setq dabbrev-case-replace 'nil)
(setq dabbrev-abbrev-char-regexp 'nil)
(setq dabbrev-abbrev-skip-leading-regexp "\\$")

;; vc-mode
(eval-after-load "vc-hooks"
  '(define-key vc-prefix-map "=" 'ediff-revision))