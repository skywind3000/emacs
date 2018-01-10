
(setq config-home (file-name-directory 
         (or (buffer-file-name) load-file-name)))

(message (concat "init from: " config-home))

(add-to-list 'load-path (concat config-home "lisp"))
(add-to-list 'load-path (concat config-home "lib"))
(add-to-list 'load-path (concat config-home "theme"))

(message "init.el")

(require 'init-config)
(require 'init-tabs)
(require 'init-font)
(require 'init-compilation)
(require 'init-gdb)
;(require 'init-cc-mode)

(require 'vimmake)
(require 'goto-chg)

(message "done")

(provide 'init)


