(message "init-config")

(message (concat "init from: " config-home))

(setq inhibit-startup-screen t)
(global-linum-mode t)
(setq linum-format "%d ")

; (unless window-system
;   (add-hook 'linum-before-numbering-hook
; 	    (lambda ()
; 	      (setq-local linum-format-fmt
; 			  (let ((w (length (number-to-string
; 					    (count-lines (point-min) (point-max))))))
; 			    (concat "%" (number-to-string w) "d"))))))

; (defun linum-format-func (line)
;   (concat
;    (propertize (format linum-format-fmt line) 'face 'linum)
;    (propertize " " 'face 'mode-line)))

; (unless window-system
;   (setq linum-format 'linum-format-func))

(defun start-cmd () (interactive)
   (let ((proc (start-process "cmd" nil "cmd.exe" "/C" "start" "cmd.exe")))
    (set-process-query-on-exit-flag proc nil))
  )


(global-set-key [f10] 'eval-buffer)

(provide 'init-config)



