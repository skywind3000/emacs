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
	(setenv "EMACS_PID" (cdr (assoc :emacs-pid buffer-info)))
	(setenv "EMACS_CWD" (cdr (assoc :default-cwd buffer-info)))
	))
  


(message "%s" (eq buffer-file-name nil))
(message "%s" (vimmake-buffer-info))

(message "%s" (assoc :file-noext (vimmake-init-environ)))

(message "pwd: %s" (pwd))
(message "default-pwd: %s" default-directory)

(vimmake-init-environ (vimmake-init-environ))

(provide 'vimmake)



