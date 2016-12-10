(message "init-config")

(setq-default indent-tabs-mode t)
(setq tab-width 4)

(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

(setq c-tab-always-indent t)
(line-number-mode 1)

(add-hook 'python-mode-hook
          (lambda ()
           (setq indent-tabs-mode t)
           (setq tab-width 4)))

; (global-set-key (kbd "<tab>") '(lambda () (interactive) (insert-char 9 1)))
(global-set-key (kbd "TAB") 'self-insert-command)

(provide 'init-config)



