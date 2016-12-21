(message "init-config")

(message (concat "init from: " config-home))

(setq inhibit-startup-screen t)
(global-linum-mode t)
(setq linum-format "%4d ")

(setq linum-disabled-modes-list 
 '(eshell-mode 
   wl-summary-mode 
   compilation-mode
   message-mode
   )) 

(defun linum-on () 
 (unless (or (minibufferp) 
          (member major-mode linum-disabled-modes-list)) (linum-mode 1)))


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

(setq scroll-step            1
      scroll-conservatively  10000)

(defun zap-to-char-save (arg char)
    "Zap to a character, but save instead of kill."
    (interactive "p\ncZap to char: ")
    (save-excursion
      (zap-to-char arg char)
      (yank)))

(provide 'init-config)



