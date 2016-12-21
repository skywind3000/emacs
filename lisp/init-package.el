(require 'package)

;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa-stable.milkbox.net/packages/"))

(package-initialize)

(require 'quickrun)

(quickrun-add-command "c++/c11"
                      '((:command . "g++")
                        (:exec    . ("%c %o -o %e %s"
                                     "%e %a"))
                        (:remove  . ("%e")))
                      :default "c++")

(quickrun-add-command "c"
                      '((:command . "gcc")
                        (:exec    . ("%c %o -o %e %s"
                                     "%e %a"))
                        (:remove  . ("%e")))
                      :default "c")

(provide 'init-package)


