;;;
;;; 個人用 Emacs 設定
;;; (emacs-version)
;;; "GNU Emacs 24.5.1 (x86_64-pc-mingw32)
;;;  of 2015-04-14 on NTEMACS64"
;;;
(server-start)

;;;
;;; 外部コマンドパス・拡張パス設定関連
;;;

; 環境変数 PATH にあるもの全て追加
(defun recursive-add-load-path (&rest paths)
  (dolist (path paths path)
    (let ((default-directory path))
      (normal-top-level-add-subdirs-to-load-path))))
(recursive-add-load-path (expand-file-name "~/.emacs.d/"))

; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

; load-pathに追加するフォルダ
(add-to-load-path "elisp")

;;;
;;; el-get
;;;
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(add-to-list 'el-get-recipe-path "~/.emacs.d/my-recipes")
(el-get 'sync)


;;;
;;; 見た目やデフォルトキーバインドとか
;;;

;;; テーマ
(load-theme 'misterioso)

;;; maxframe.el。起動時にウィンドウ最大化
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

;;; 全角とかタブとか改行を見えるようにする
(require 'whitespace)

(setq whitespace-style '(face           ; faceで可視化
                         space-mark
                         tab-mark
;;                         empty          ; 先頭/末尾の空行
                         ))
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])))
(global-whitespace-mode 1)

; 1行ずつスクロール。細かい意味は知らん。
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)

(column-number-mode t)                  ; 列番号表示(下に)
(line-number-mode t)                    ; 行番号表示(下に)
; インデントにタブは使わない
(setq-default tab-width 4
              indent-tabs-mode nil)
; フォント設定。サイズがどういうサイズなのかは謎。
(set-face-attribute 'default nil :family "MeiryoKe_Console" :height 130)
(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "MeiryoKe_Console"))  ;; 日本語

(setq-default line-spacing 1)           ; 行間調整

; 文字エンコーディング指定
;   漢字が化ける場合は utf-8-unix にすると治るかもと言うのをどこかで見たが
;   実際に遭遇するまではこのままにしておく
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq file-name-coding-system 'sjis)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'shift_jis)
(setq process-coding-system 'utf-8)

;;;
;;; UI 表示関連
;;;
(tool-bar-mode -1)                      ; ツールバー非表示
(menu-bar-mode -1)                      ; メニューバーを非表示
(setq inhibit-startup-screen t)         ; スタートアップ非表示
(set-scroll-bar-mode nil)               ; スクロールバー非表示
(setq initial-scratch-message "")       ; scratchの初期メッセージ消去
(setq line-spacing 1)                   ; 整数でpixel指定、小数で行間相対指定に
(line-number-mode t)                    ; モードラインに列数表示
(setq-default fill-column 90)           ; 自動改行文字数(半角基準)
(setq make-backup-files nil)            ; バックアップを残さない
(setq visible-bell t)                   ; beep 音要らん 
(setq truncate-lines t)                         ; 折り返しをしない。
(setq truncate-partial-width-windows t) ; 折り返しをしない。どっちがどう違うのかは知らん
(setq help-window-select 'always)       ; *Help* バッファが出たら常に移動

;;;
;;; キーバインド
;;;

; xyzzy に慣れてたキーバインドに近づける
(global-set-key (kbd "C-0") 'delete-window)
(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-2") 'split-window-vertically)
(global-set-key (kbd "C-5") 'split-window-horizontally)
(global-set-key (kbd "C-t") 'other-window)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-h" 'help-command)
(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-set-key "\C-\\" 'undo)
(global-set-key (kbd "C-/") 'dabbrev-expand)
;(global-set-key (kbd "C-_") (kbd "C-g ")) ; 標準の redo のキーバインドを変える
(setq kill-whole-line t)                      ; 行削除時、改行も削除(kill-line-twice)

; 矩形編集関係。xyzzy と殆ど変わらずにいけた
(defvar *rectangle-map* nil)
(setq *rectangle-map* (make-sparse-keymap))
(setf (symbol-function 'rectangle-prefix) *rectangle-map*)
(define-key ctl-x-map "r" 'rectangle-prefix)
(define-key *rectangle-map* "d" 'delete-rectangle)
(define-key *rectangle-map* "k" 'kill-rectangle)
(define-key *rectangle-map* "o" 'open-rectangle)
(define-key *rectangle-map* "t" 'string-rectangle)
(define-key *rectangle-map* "y" 'yank-rectangle)
(define-key *rectangle-map* "w" 'copy-rectangle-to-register)

;;;
;;; elisp, clojure 他 lisp ファミリー開発
;;;


;;; 共通
(global-company-mode)                   ; Clojure, Rust のみだがこれで大抵上手く行く
(show-paren-mode)                       ; カッコ強調表示
(setq show-paren-delay 0)
(require 'rainbow-delimiters)
(require 'cl)                           ; Common Lisp. 使うかどうか分からんが

;; cider 設定
; eldoc は nREPL 接続後に有効になる
(require 'cider)
(setq eldoc-idle-delay 0)
(add-hook 'cider-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-mode-hook #'eldoc-mode) 
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode) 

(add-hook 'cider-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook #'enable-paredit-mode)

(setq cider-pprint-fn 'puget)           ; leiningen のプラグインとして事前に追加しておく事

(defun play-clj-reload ()
  "REPL へ play-clj への反映コマンドを投げる。
   hello-world-game と mainscreen は適時書き換える事。"
  (interactive)
  (cider-interactive-eval
   "(on-gl (set-screen! pj-tests-game main-screen))"))
(define-key cider-mode-map (kbd "C-c j") 'play-clj-reload)

(defun save->eval->reload ()
  "play-clj での開発用。バッファセーブ→バッファ評価→play-cljのリロードのコンボをまとめて実行する。
   sit-for で wait かましているのはあんまり意味ないかも。"
  (interactive)
  (save-buffer)
  (sit-for 1)
  (cider-load-buffer)
  (sit-for 1)
  (play-clj-reload))
(define-key cider-mode-map (kbd "<f5>") 'save->eval->reload)

;;;
;;; rust 関連
;;;
(electric-indent-mode t)
;; rust-mode。現行recipeでは404エラーになったので
(el-get-bundle rust-lang/rust-mode)
(autoload 'rust-mode "rust-mode" nil t)
(eval-after-load "rust-mode" '(require 'racer))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)
