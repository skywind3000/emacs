(defun c-set-font (english chinese english-size chinese-size)
  (set-face-attribute 'default nil :font
                      (format   "%s:pixelsize=%d"  english english-size))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))


(when (eq system-type 'windows-nt)
  ; (c-set-font "Courier New" "微软雅黑" 14 16)
  (c-set-font "Inconsolata" "Inconsolata" 15 17)
  (c-set-font "Inconsolata" "新宋体" 15 15)
  ;(c-set-font "Courier New" "新宋体" 13 15)
  )


(provide 'init-font)


