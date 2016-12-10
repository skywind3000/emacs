

(setq config-dir (file-name-directory 
                  (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path config-dir)


(message "init.el")

(require 'init-config)

(require 'skywind)

(message "done")

