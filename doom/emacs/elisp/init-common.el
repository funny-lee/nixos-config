;;; init-common.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Environment
(when (eq system-type 'gnu/linux)
  (setq org-directory "~/Documents/Notes")
  (set-face-font 'default "JetBrains Mono-10")
  )

(when (eq system-type 'windows-nt)
  (setq default-directory "C:/Users/zendo/Desktop/" ;主目录
        ;; org-directory "c:/Users/zendo/Documents/org/"
        )
  (set-face-attribute 'default nil :font
                      (format "JetBrains Mono-10"))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset
                      (font-spec :family "Microsoft Yahei" :size 24))))

;; fonts
;; Consolas, Hack, Source Code Pro,
;; Microsoft Yahei, NotoSansSC,
;; (set-face-attribute 'default nil :font "等距更纱黑体 SC-12")
;; (setq default-frame-alist '((font . "JetBrains Mono-10")))

;; Org-table font
(custom-set-faces
 '(org-table ((t (:family "JetBrains Mono")))))


;; Set UTF-8 as the default coding system
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq system-time-locale "C")
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Editor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; interface
(setq confirm-kill-processes nil
      ;; mouse-autoselect-window t
      visible-bell 1                ;关闭错误警示
      system-time-locale "C"        ;使用英文时间格式
      ispell-dictionary "en"        ;使用英文词典
      sentence-end-double-space nil ;Sentences should end in one space
      display-time-24hr-format t
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*" ;识别中文标点符号
      require-final-newline t)

;; Modeline
(column-number-mode t)      ;显示列数
(size-indication-mode t)    ;显示文件大小
;; (display-time-mode 1)       ;显示时间
;; (unless (string-match-p "^Power N/A" (battery))
;;   (display-battery-mode 1))

(show-paren-mode 1)                         ;括号匹配 parens
(electric-pair-mode t)                      ;自动补全括号
(delete-selection-mode t)                   ;overwrite selected text
(global-visual-line-mode 1)                 ;折叠 word wrap
(global-prettify-symbols-mode 1)            ;Show lambda as λ.
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default frame-title-format "%b (%f)") ;标题栏显示正在编辑的文件名

;; Tab and Space
(setq-default tab-width        4
              indent-tabs-mode nil ;indent with spaces, never with TABs
              ompletion-cycle-threshold 3  ;TAB cycle if there are only few candidates
              tab-always-indent 'complete) ;Tab key indent first then completion.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Built-in ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ibuffer
(defalias 'list-buffers 'ibuffer)
(setq ibuffer-expert t) ; 直接操作不询问
(setq ibuffer-use-other-window t)

;; winner C-c ←/→ undo/redo window
(winner-mode 1)

;; whitespace
(setq whitespace-action '(auto-cleanup)  ;automatically clean up bad whitespace
      whitespace-style '(face
                         trailing space-before-tab
                         indentation empty space-after-tab))
(whitespace-mode 1)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ;搜索当前 buffer, expand word "dynamically"
        try-expand-dabbrev-all-buffers     ;搜索所有 buffer
        try-expand-dabbrev-from-kill       ;从 kill-ring 中搜索
        try-complete-file-name-partially   ;文件名部分匹配
        try-complete-file-name             ;文件名匹配
        try-expand-all-abbrevs             ;匹配所有缩写词, according to all abbrev tables
        try-expand-list                    ;补全一个列表
        try-expand-line                    ;补全当前行
        try-complete-lisp-symbol-partially ;部分补全 lisp symbol
        try-complete-lisp-symbol))         ;补全 lisp symbol

;; flyspell
(require 'flyspell)
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))

(unless (and (fboundp 'server-running-p)
             (server-running-p))
  (server-start))

;; kill emacsclient message
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (setq inhibit-message t)
            (run-with-idle-timer 0 nil (lambda () (setq inhibit-message nil)))))

;; disable warnings
(setq warning-minimum-level :emergency
      byte-compile-warnings '(not
                              obsolete
                              free-vars
                              unresolved
                              callargs
                              redefine
                              noruntime
                              cl-functions
                              interactive-only
                              make-local))

;; disable prompt
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'scroll-left 'disabled nil)

(provide 'init-common)
;;; config.el ends here
