;; M-x package-install list-package



;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (setq url-proxy-services
;;       '(("socks"     . "socks://localhost:1080")
;; 	("no_proxy" . "^.*example.com")))

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(require 'package)
(package-initialize)
(require 'use-package)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-completion-fignore (quote ("pyc" "~" "#" "o")))
 '(default-major-mode (quote emacs-lisp-mode) t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(electric-indent-mode nil)
 '(flymake-no-changes-timeout 4)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(indent-tabs-mode nil)
 '(inhibit-default-init t)
 '(inhibit-startup-screen t)
 '(initial-major-mode (quote emacs-lisp-mode))
 '(initial-scratch-message nil)
 '(make-backup-files t)
 '(menu-bar-mode nil)
 '(message-log-max 200)
 '(package-selected-packages (quote (jedi jedi-core company py-autopep8)))
 '(scroll-bar-mode nil)
 '(shell-completion-fignore (quote ("pyc" "o" "~" "#")))
 '(tab-width 4))

(setq split-height-threshold nil)
(setq split-width-threshold 0)

(set-cursor-color "blue1")
(show-paren-mode t)
(setq ring-bell-function 'ignore)



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




(global-set-key "\M-p" 'scroll-down-25%-window)
(global-set-key "\M-n" 'scroll-up-25%-window)
(global-set-key "\M-l" 'dabbrev-expand)

(global-set-key (kbd "M-q") 'fly-switch-to-buffer)
(global-set-key (kbd "M-j") 'fly-other-window)


(define-prefix-command 'ctl-o)
(global-set-key (kbd "C-o") 'ctl-o)
(define-key global-map (kbd "C-o f") 'wy-go-to-char)
(define-key global-map (kbd "C-o a") 'wy-back-to-char)



;; ido
(require 'ido)
(ido-mode t)
;; completion-ignored-extensions
;; (add-to-list 'completion-ignored-extensions "#")



;; c c-mode-common-hook
(setq c-basic-offset 4
      c-default-style "linux")

;;
(require 'ffap)


;; dynamic abbrev
(setq dabbrev-case-replace 'nil)
(setq dabbrev-abbrev-char-regexp 'nil)
(setq dabbrev-abbrev-skip-leading-regexp "\\$")

;; python
(setq python-indent-offset 4)
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)


;; python flychecker
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
;;(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)

;; jedi autocomplete
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook 'jedi:setup)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
