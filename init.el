

(setq config-home (file-name-directory 
         (or (buffer-file-name) load-file-name)))

(setq config-lisp (concat config-home "lisp"))
(setq config-lib (concat config-home "lib"))

(message (concat "init from: " config-home))

; (message (file-name-directory (buffer-file-name)))
; (push config-lisp load-path)
; (push config-home load-path)

(add-to-list 'load-path config-lisp)
(add-to-list 'load-path config-lib)


(message "init.el")

(require 'init-config)
(require 'init-tabs)
(require 'init-font)
(require 'init-compilation)

(require 'vimmake)


(message "done")


(provide 'init)


