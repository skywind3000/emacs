;; vimmake.el - make and execute programs

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
	(setq pid (or (and (fboundp 'emacs-pid) (emacs-pid)) 0))
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
	 (cons :line (line-number-at-pos))
	 (cons :column (current-column))
	 (cons :cword (or (thing-at-point 'word) ""))
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
	(setenv "EMACS_LINE" (cdr (assoc :line buffer-info)))
	(setenv "EMACS_COLUMN" (cdr (assoc :column buffer-info)))
	(setenv "EMACS_CWORD" (cdr (assoc :cword buffer-info)))
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

(defun vimmake-write-file (filename text)
  (with-temp-buffer
	(erase-buffer)
	(insert text)
	(write-region (point-min) (point-max) filename nil)))

(defun vimmake-trim-string (string)
  (replace-regexp-in-string
   "\\`[ \t\n]*" ""
   (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)

;; run in compilation mode
(defun vimmake-run-compile (command option)
  (let ((compilation-ask-about-save nil)
		(compile-command ""))
	(compile command)
	))

;; run by start-process
(defun vimmake-run-process (command option)
  (let ((opt-open (cdr (or (assoc :open option) '(0 . nil))))
		(buffer-name (cdr (or (assoc :buffer-name option) '(0 . nil))))
		(process-name (cdr (or (assoc :process-name option) '(0 . nil))))
		(win nil)
		(pid nil))
	(setq buffer-name (or buffer-name "*vimmake*"))
	(setq process-name (or process-name "vimmake"))
	(setq opt-open (or opt-open :normal))
	(setq buffer-name (create-file-buffer buffer-name))
	(setq win (display-buffer buffer-name))
	(cond
	 ((eq opt-open :normal)
;	  (setq win (display-buffer buffer-name))
;	  (with-selected-window win (recenter) (message "win: %s" win) )
	  )
	 )
	(with-selected-window win
	  (erase-buffer)
	  (recenter)
	  (insert (format "[%s]\n" command))
	  )	
	(setq pid (start-process-shell-command
			   process-name
			   buffer-name
			   command))
	(cond
	 ((eq opt-open :normal)
;	  (setq win (display-buffer buffer-name))
;	  (with-selected-window win (recenter) (message "win: %s" win) )
	  )
	 )
	))

;; run by open a new cmd.exe window
(defun vimmake-run-windows (command option)
  (let ((my-command command)
		(temp-name ""))
	(setq temp-name (or (getenv "TMP")
						(getenv "TEMP")))
	(when (eq temp-name nil)
	  (setq temp-name (or (getenv "WINDIR")
						  (getenv "SYSTEMROOT")
						  "C:\\Windows"))
	  (setq temp-name (expand-file-name "Temp" temp-name)))
	(setq temp-name (expand-file-name "vimmake2.cmd" temp-name))
	(setq my-command (format
					  "@echo off\ncd /D %s\ncall %s\npause\n"
					  (shell-quote-argument default-directory)
					  command))
	(vimmake-write-file temp-name my-command)
	(let ((proc (start-process "cmd" nil
							   "cmd.exe"
							   "/C"
							   "start"
							   "cmd.exe" "/C"
							   temp-name)))
	  (set-process-query-on-exit-flag proc nil))
	))


;; main function of run
(defun vimmake-run (command mode option)
  (let ((default-cwd default-directory)
		(option-save (cdr (or (assoc :save option) '(0 . 0))))
		(option-cwd (cdr (or (assoc :cwd option) '(0 . nil))))
		(compilation-ask-about-save nil)
		(buffer-info (vimmake-buffer-info))
		(final-command ""))
	(setq final-command (vimmake-replace-string buffer-info command))
	(setq final-command (vimmake-trim-string final-command))
	(vimmake-init-environ buffer-info)
	(cond
	 ((eq option-save 0)
	  (setq compilation-ask-about-save nil))
	 ((eq option-save 1)
	  (setq compilation-ask-about-save nil))
	 ((eq option-save 2)
	  (setq compilation-ask-about-save t))
	 (t nil))
	(setq default-cwd (or option-cwd default-cwd))
	(let ((default-directory default-cwd))
	  (cond
	   ((eq mode :compile)
		(vimmake-run-compile final-command option))
	   ((eq mode :process)
		(vimmake-run-process final-command option))
	   ((and (eq mode :windows) (eq system-type 'windows-nt))
		(vimmake-run-windows final-command option))
	   ))
	))

(message "vimmake loaded")

(provide 'vimmake)



