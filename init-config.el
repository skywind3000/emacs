(message "init-config")

(setq-default indent-tabs-mode t)
(setq tab-always-indent 'complete)
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

(global-linum-mode t)
(global-set-key [f4] 'compile)
(setq compilation-window-height 8)
(setq compilation-scroll-output t)

(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h compilation-window-height)))))))
(add-hook 'compilation-mode-hook 'my-compilation-hook)

(provide 'init-config)



