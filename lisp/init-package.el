(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;(add-to-list 'package-archives '("melpa" . "http://melpa-stable.milkbox.net/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;(add-to-list 'package-archives '("melpa" . "http://elpa.gnu.org/packages/"))

;(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
 ;                        ("melpa" . "http://elpa.emacs-china.org/melpa/")))

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


