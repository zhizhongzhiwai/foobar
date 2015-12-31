(require 'cl)
(require 'foo-common)

;; ;; define abbrev-table
;; (defconst +c-abbrev-control-statement+
;;   '((if "if () {\n\n}\n" 4)
;;     (ie "if () {\n\n}\nelse {\n\n}" 4)
;;     (while "while () {\n\n}\n" 7)
;;     (do "do {\n\n} while ();\n" 15)
;;     (for "for (){\n\n}\n" 5)
;;     (switch "switch (){\n\n}\n" 8)))


(defconst +c-abbrev-header-files+
  '(("includec" ("stdio.h" "stdlib.h" "sys/types.h" "unistd.h" "errno.h" "sys/ioctl.h" "fcntl.h" "string.h" "malloc.h"))
    ("includen" ("sys/socket.h" "netinet/in.h" "arpa/inet.h" "netdb.h"))))

(defun c-include-header-file (header-file)
  (format "#include <%s>\n" header-file))


;; (define-abbrev-table 'c-mode-abbrev-table ())
;; ;; (abbrev-name replace-string hook)
;; (let ((header-files (mapcar #'(lambda (header)
;; 				(list (nth 0 header) (reduce #'concat (nth 1 header) :key #'c-include-header-file) nil)) 
;; 			    +c-abbrev-header-files+)))

;;   (mapcar #'(lambda (abbrev-replace)
;; 	      (mapcar #'(lambda (abbrev)
;; 			  (define-abbrev c-mode-abbrev-table (nth 0 abbrev) (nth 1 abbrev) (nth 2 abbrev) :system t))
;; 		      abbrev-replace))
;; 	  (list header-files))
;;   (abbrev-mode t)
;;   (setq local-abbrev-table c-mode-abbrev-table))


(defun c-goto-function-first-blank-line ()
  (interactive)
  (beginning-of-defun)
  (find-next-blank-line))

(defun c-insert-input (prompt func)
  (let ((variable (read-string prompt))
	(definition ""))
    (multiple-value-bind (start end)
       	(values (string-match "[[:print:]].*[[:print:]]" variable) (match-end 0))
      (setq definition (substring variable start end))
      (funcall func definition))))
 
;; insert auto variable.
(defun %c-insert-auto-variabler% (variable)
  (save-excursion
    (c-goto-function-first-blank-line)
    (c-indent-line-or-region)
    (if (string= ";" (substring variable -1))
	(insert (format "%s\n" variable))
      (insert (format "%s;\n" variable)))))


(defun c-insert-auto-variabler ()
  (interactive)
  (c-insert-input "variable definition: " '%c-insert-auto-variabler%))

;; insert auto header file.
(defun c-insert-header-file ()
  (interactive)
  (c-insert-input "header files: " '%c-insert-header-file%))

(defun %c-insert-header-file% (header-files)
  (save-excursion
    (goto-first-blank-line)
    (mapcar (lambda (header-file) (insert (format "#include <%s>\n" header-file)))
	    (split-string header-files split-string-default-separators t))))


;; (defun c-gtags-init ()
;;   (add-hook 'after-save-hook 'gtags-update-tags)

;; (add-hook 'gtags-mode-hook 'c-gtags-init)



(local-set-key "\M-h" 'c-insert-auto-variabler)


;; create Makefile
(defconst +c-makefile-temp+
  (concat "obj := %s\n"
	  "CFLAGS = -O0 -Wall -g3 -o \n"
	  "$(obj): $(obj).c\n"
	  "\t$(CC) $(CFLAGS) $(obj) $(obj).c\n"
	  "clean:\n"
	  "\trm -f $(obj)\n"))

(defun c-cake ()
  (interactive)
  (let* ((obj (car (split-string (buffer-name (current-buffer)) "\\." t)))
	 (cake-shell-command ((lambda (makefile-temp)
				(format "cat <(printf '%s') >Makefile" makefile-temp))
			      (format +c-makefile-temp+ obj))))
    (message "%s" (with-temp-buffer (shell-command cake-shell-command t)
				    (buffer-substring-no-properties 1 (point-max))))))



;; ;; semantic
;; (defconst +c-system-include-directorys+
;;   '("/usr/include/"
;;     "/usr/include/arpa"
;;     "/usr/include/netinet"
;;     "/usr/include/linux"
;;     "/usr/include/net"
;;     "/usr/include/sys"))

;; (dolist (dir +c-system-include-directorys+)
;;   (semantic-add-system-include "c-mode"))


;; makefile for build dll


(defun* make-makefile-dll ()
  (interactive)
  (let* ((filename (file-name-nondirectory (buffer-file-name)))
         (basename (file-name-sans-extension filename))
         (obj (format "%s.dll" basename))
         (makefile (format "makefile.%s" basename)))
    (with-temp-buffer
      (insert (expand-template (("source_files = %s\n" filename)
                               ("obj = %s\n\n" obj)
                               ("all: $(obj)\n.PHONY: all\n\n")
                               ("$(obj): $(source_files)\n")
                               ("\tcl /Od /Oi /W3 $(source_files) /link /DLL /OUT:$(obj)\n"))))
      (write-file makefile))))

(provide 'foo-c-mode)