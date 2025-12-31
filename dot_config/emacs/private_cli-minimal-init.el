;;; cli-minimal-init.el --- Minimal config for fast CLI startup -*- lexical-binding: t -*-

;;; Commentary:
;; Usage: emacs -nw -Q -l ~/.config/emacs/cli-minimal-init.el
;; Alias: alias em='emacs -nw -Q -l ~/.config/emacs/cli-minimal-init.el'

;;; Code:

;; パッケージシステムを無効化（起動高速化）
(setq package-enable-at-startup nil)

;; GCを抑制（起動時のみ）
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 8 1024 1024))))

;; 基本設定
(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil)

;; エンコーディング
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; UI設定（ターミナル用）
(menu-bar-mode -1)
(setq-default indicate-empty-lines t)

;; 行番号
(global-display-line-numbers-mode 1)

;; 基本的な編集設定
(setq-default indent-tabs-mode nil
              tab-width 4)
(electric-pair-mode 1)
(show-paren-mode 1)

;; 検索・補完
(setq isearch-lazy-count t)
(fido-mode 1)

;; キーバインド
(global-set-key (kbd "C-h") 'delete-backward-char)
;; ターミナルでのDEL/BS対応（日本語入力時の挙動改善）
(define-key function-key-map [?\C-h] [backspace])

;;; cli-minimal-init.el ends here
