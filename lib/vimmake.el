(message "Vimmake here")

(defun vimmake-buffer-info ()
  (let ((file-name "")
        (file-path "")
        (file-dir "")
        (file-noext "")
        (file-ext "")
        (default-cwd "")
        (pid 0)
        (absolute-file-name ""))
    (setq absolute-file-name (buffer-file-name))
    (when (not (eq absolute-file-name nil))
      (setq absolute-file-name (expand-file-name absolute-file-name))
      (setq file-path absolute-file-name)
      (setq file-name (file-name-nondirectory absolute-file-name))
      (setq file-dir (file-name-directory absolute-file-name))
      (setq file-noext (file-name-sans-extension file-name))
      (setq file-ext (concat "." (or (file-name-extension file-name) "")))
      )
    (setq default-cwd default-directory)
    (list
     (cons :file-name file-name)
     (cons :file-path file-path)
     (cons :file-dir file-dir)
     (cons :file-ext file-ext)
     (cons :file-noext file-noext)
     (cons :emacs-pid pid)
     (cons :default-cwd default-cwd))
    ))

(defun vimmake-init-environ (buffer-info)
  (let ((buffer-data ""))
    (setenv "EMACS_FILENAME" (cdr (assoc :file-name buffer-info)))
    (setenv "EMACS_FILEPATH" (cdr (assoc :file-path buffer-info)))
    (setenv "EMACS_FILEDIR" (cdr (assoc :file-dir buffer-info)))
    (setenv "EMACS_FILEEXT" (cdr (assoc :file-ext buffer-info)))
    (setenv "EMACS_FILENOEXT" (cdr (assoc :file-noext buffer-info)))
    (setenv "EMACS_PID" (number-to-string (cdr (assoc :emacs-pid buffer-info))))
    (setenv "EMACS_CWD" (cdr (assoc :default-cwd buffer-info)))
    ))

(defun vimmake-string-template (source-string template)
  (let ((new-string source-string)
        (temp-length (length template))
        (index 0)
        (item-key "")
        (item-val "")
        (case-fold-search nil))
    (while (< index temp-length)
      (setq item-key (car (nth index template)))
      (setq item-val (cdr (nth index template)))
      (setq new-string (replace-regexp-in-string
                        (regexp-quote item-key)
                        item-val
                        new-string t t))
      (setq index (+ index 1)))
    new-string))

(defun vimmake-replace-string (buffer-info command)
  (let ((new-command command)
		(next-list nil)
        (temp-list nil))
    (setq temp-list
          (list
           (cons "%f" (cdr (assoc :file-path buffer-info)))
           (cons "%p" (cdr (assoc :file-dir buffer-info)))
           (cons "%n" (cdr (assoc :file-noext buffer-info)))
           (cons "%e" (cdr (assoc :file-ext buffer-info)))
           (cons "%m" (cdr (assoc :file-name buffer-info)))
           (cons "%x" (concat (cdr (assoc :file-dir buffer-info))
                              (cdr (assoc :file-noext buffer-info))))
           (cons "%w" (cdr (assoc :default-cwd buffer-info)))
           ))
	(dolist (elt temp-list)
	  (let ((key (car elt))
			(val (cdr elt))
			(nkey (upcase (car elt)))
			(nval (shell-quote-argument (cdr elt))))
		(setq next-list (cons (cons nkey nval) next-list))))
	(setq temp-list (append temp-list next-list))
	(vimmake-string-template new-command temp-list)
  ))



(message "%s" (eq buffer-file-name nil))
(message "%s" (vimmake-buffer-info))

(message "pwd: %s" (pwd))
(message "default-pwd: %s" default-directory)

(setq buffer-info (vimmake-buffer-info))

(vimmake-replace-string buffer-info "dfsdfdsf")

(message "replace: \n%s" (vimmake-replace-string buffer-info "F: %F\nf: %f\nn: %n\nm: %m\ne: %e\nx: %x\np: %p"))

(message "-----------------")

(provide 'vimmake)



