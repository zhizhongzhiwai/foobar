(require 'cl)
(require 'thingatpt)
(require 'tempo)

;; new line
(defun append-newline ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be PHP, Perl, Python, Ruby, JavaScript, Bash, ocaml, vb, elisp.
File suffix is used to determine what program to run."
(interactive)
  (let (suffixMap fName suffix progName cmdStr)

    ;; a keyed list of file suffix to comand-line program path/name
    (setq suffixMap 
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("rb" . "ruby")
            ("js" . "js")
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
;            ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
            )
          )

    (setq fName (buffer-file-name))
    (setq suffix (file-name-extension fName))
    (setq progName (cdr (assoc suffix suffixMap)))
    (setq cmdStr (concat progName " \""   fName "\""))

    (if (string-equal suffix "el") ; special case for emacs lisp
        (load-file fName) 
      (if progName
        (progn
          (message "Running…")
          (shell-command cmdStr "*run-current-file output*" )
          )
        (message "No recognized program file suffix for this file.")
        )
)))


(defun insert-newline ()
  (interactive)
  (previous-line 1)
  (append-newline))


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


(defun mark-region (x y)
  (interactive)
  (goto-char x)
  (push-mark x)
  (push-mark y nil t)
)

(defun mark-thing-at-point (thing)
  (interactive)
  (let ((pt (bounds-of-thing-at-point thing)))
    (if pt
	(mark-region (car pt) (cdr pt))
      (message "nothing!"))))

(defun aka-mark ()
  (interactive)
  (let ((reg (get-register ?!)))
    (if reg
        (progn
          (goto-char (marker-position reg))
          (set-register ?! nil)
          (message "%s" "marker cancel"))
      (progn
        (set-register ?! (point-marker))
        (message "%s" "set marker")))))


(defmacro switch-buffer-to-new-window (name fn-switch)
  `(if (not (string= (buffer-name (current-buffer)) ,name))
       (progn
	 (switch-to-buffer-other-window (buffer-name (current-buffer)))
	 ,fn-switch)
     ()))


;; shell-bufferp
(defconst +shell-buffer-name+ "*shell*")
(defun switch-to-shell-buffer ()
  (interactive)
  (switch-buffer-to-new-window +shell-buffer-name+ (shell)))


(defconst +gud-buffer-name+ "*gud-gdb*")
(defun switch-to-gud-gdb-buffer ()
  (interactive)
  (switch-buffer-to-new-window +gud-buffer-name+
			       (switch-to-buffer +gud-buffer-name+)))


;; scratch-buffer
(defconst +scratch-buffer-name+ "*scratch*")
(defun switch-to-scratch-buffer ()
  (interactive)
  (switch-buffer-to-new-window +scratch-buffer-name+
			       (switch-to-buffer +scratch-buffer-name+)))


;; scroll window
(defun scroll-up-25%-window ()
  (interactive)
  (scroll-up (/ (window-height) 4)))

(defun scroll-down-25%-window ()
  (interactive)
  (scroll-down (/ (window-height) 4)))



;; toggle max window
(setf (symbol-function 'toggle-window-max)
      (lexical-let ((regchar ?\C-.)
		    (regcopy nil))
	(lambda ()
	  (interactive)
	  (if (get-register regchar)
	      (progn
		(jump-to-register regchar t)
		(set-register regchar nil)
		(setq regcopy nil))
	    (progn
	      (frame-configuration-to-register regchar)
	      (delete-other-windows))))))


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


(defun find-next-blank-line ()
  (loop
       while (split-string (thing-at-point 'line)
			   split-string-default-separators
			   t)
       do (next-line)))

(defun goto-first-blank-line ()
  (goto-char (point-min))
  (find-next-blank-line))


;; abbrev
(defun define-upcase-abbrev (name)
  (interactive "sabbrev name: \n")
  (define-abbrev global-abbrev-table name (upcase name) nil))

(defun* delete-abbrev (name)
  (interactive "sname: ")
  (define-abbrev global-abbrev-table name nil nil))

(defun define-abb (name expand-string)
  (interactive "sname: \nsexpand string: ")
  (define-abbrev global-abbrev-table name expand-string nil))


;; (defun %expand-abbrev-and-indent% (replace-string point-offset)
;;   (let* ((replace-string-length (length replace-string))
;; 	 (indent-start-point (point))
;; 	 (indent-end-point (+ (point) replace-string-length))
;; 	 (move-point-to (+ (point) point-offset)))
;;     (insert replace-string)
;;     (goto-char move-point-to)
;;     (indent-region indent-start-point indent-end-point)))

;; (defun expand-abbrev-and-indent (abbrev-key table)
;;   (let ((replace (find abbrev-key table :key #'car :test #'(lambda (x y) (string= (symbol-name x) (symbol-name y)))))) 
;;     (%expand-abbrev-and-indent% (nth 1 replace) (nth 2 replace))))



;; ;;;;
(defconst +executable-script-mode+
  '((python-mode . "^#!.*python")
    (perl-mode . "^#!.*perl")
    (sh-mode . "^#!.*\\(sh\\|bash\\)")))

(defun after-save-chmod-script ()
  (if (and (find major-mode (mapcar #'car +executable-script-mode+))
	   (buffer-file-name (current-buffer))
	   ((lambda (regex)
	      (save-excursion
		(goto-char (point-min))
		(string-match regex (buffer-substring-no-properties (point)
								    (progn (move-end-of-line 1)
									   (point))))))
	    (cdr (assoc major-mode +executable-script-mode+))))
      (set-file-modes (buffer-file-name (current-buffer)) #o755)))


;; global gtags
(defun gtags-update-tags ()
  (if gtags-mode
      (progn (message "%s" (with-temp-buffer (shell-command "global -u 2>/dev/null" t)
				       (buffer-substring-no-properties 1 (point-max))))
       )))


(defmacro gtags-other-window (gtags-command)
  (let ((old-buffer (make-symbol "old"))
	(tag-buffer (make-symbol "tagbuf")))
    `(let ((,old-buffer (current-buffer)))
       ,gtags-command
       (setq ,tag-buffer (current-buffer))
       (switch-to-buffer ,old-buffer)
       (switch-to-buffer-other-window ,tag-buffer))))


(defun gtags-find-tag-other-window ()
  (interactive)
  (gtags-other-window (gtags-find-tag))
  (global-set-key "\M-." 'gtags-find-tag-other-window))


(defun gtags-find-rtag-other-window ()
  (interactive)
  (gtags-other-window (gtags-find-rtag))
  (global-set-key "\M-," 'gtags-find-rtag-other-window))


(defun gtags-find-symbol-other-window ()
  (interactive)
  (gtags-other-window (gtags-find-symbol))
  (global-set-key "\M-'" 'gtags-find-symbol-other-window))


;; hs-minor-mode
(defadvice hs-hide-block (before move-to-block-tail)
  "move to the block tail"
  (end-of-defun)
  (previous-line)
  (move-end-of-line 1)
  (backward-char))


(defadvice hs-show-block (before move-to-block-tail)
  "move to the block tail"
  (move-end-of-line 1)
  (backward-char))


;; template
(defmacro* define-template (name element &rest lst)
  (require 'tempo)
  (setq tempo-interactive t)
  (let* ((string-name (symbol-name name))
         (new-insert-name (intern (format "insert-template-%s" string-name)))
         (elements (cons element lst)))
    `(progn
       (tempo-define-template ,string-name ',elements)
       (defalias (quote ,new-insert-name) (intern (format "tempo-template-%s" ,string-name))))))

;; template
(defun* mapformat (lst)
  (reduce #'(lambda (ret f)
              (append ret (list (cons 'format f))))
          lst
          :initial-value ()))


(defmacro* expand-template (template-clauses &optional (env nil))
  `(let ,env
     (concat ,@(mapformat template-clauses))))

(defmacro* expand-template* (template-clauses &optional (env nil))
  `(let* ,env
     (concat ,@(mapformat template-clauses))))



(defun* get-function-prototype-by-buffer (buffer)
  (save-excursion
    (set-buffer buffer)
    (goto-char (point-min))
    (do* ((definitions ()))
        ((not (re-search-forward
               "^\\(?1:[[:alpha:]].*?(*\\(?:.\\|\n\\)*?)\\)[[:blank:]]*\n{"
               (point-max)
               t))
         definitions)
      (setq definitions (append definitions
                                (list (match-string-no-properties 1)))))))


(defun* insert-function-prototypes-by-buffer (&optional buffer)
  (interactive "bBuffer name: ")
  (mapcar #'(lambda (definition)
              (insert (format "\n%s;\n" definition)))
          (get-function-prototype-by-buffer
           (if buffer
               buffer
             (buffer-name (current-buffer))))))
;; hex sub
(defmacro* -* (a &rest lst)
  (flet ((convert-hex (dec-num)
                      (read (format "#x%s" dec-num))))
    `(insert (format "%x" (- ,@(mapcar #'(lambda (dec-num)
                                   (convert-hex dec-num))
                               (cons a lst)))))))

(defun url (_args)
  (interactive "sargs: ")
  (let* ((args_keys (delete-dups (split-string  _args nil t)))
         (url_args_keys (mapcar '(lambda (key)
                                   (format "url_args_%s" key))
                                (append  '("host" "path") args_keys)))
         
         (url_args_string (mapconcat '(lambda (x)
                                        x)
                                     (mapcar '(lambda (key)
                                                (format "%s={%s}" key key))
                                             args_keys)
                                     "&"))
         (funcation_call_args (mapconcat '(lambda (x)
                                            x)
                                         (mapcar '(lambda (key)
                                                    (format "%s=url_args_%s" key key))
                                                 (append '("host" "path") args_keys ))
                                         ",\n")))
    (py-newline-and-indent)
    (insert (format "url_template = 'http://{host}{path}?%s'" url_args_string))
    (setq url-back-point (point))
    (mapcar '(lambda (key)
               (progn (py-newline-and-indent)
                      (insert (format "%s = ;" key))))
            url_args_keys)
    
    (py-newline-and-indent)
    (insert (format "url = url_template.format(" funcation_call_args))
    (mapcar '(lambda (key)
               (progn (py-newline-and-indent)
                      (insert (format "%s=ulr_args_%s," key key))))
            (append '("host" "path") args_keys))
    (insert ")")
    (py-newline-and-indent)
    (insert (format "raw_response = urllib2.urlopen(url).read()"))
    (py-newline-and-indent)
    (insert (format "response = json.loads(raw_response)\n\n"))
    (goto-char url-back-point)))



(provide 'foo-common)