;;; early-init.el --- Early initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:
;;; Emacs Startup File

;;; ===================================================================================
;;; 全てをleaf.elで管理するぞ大作戦2025始動
;;;
;;; early-init.el は、Emacs の起動プロセスの初期段階（GUIフレームが作成される前）で実行される。
;;; このファイルは init.el の前に読み込まれるため、起動時間の短縮やフレーム全体に関わる設定を記述するのに適している。
;;;
;;; [early-init.el の使いどころ]
;;; • 起動速度の向上: パッケージ初期化や GC 設定を最適化。
;;; • GUI の安定化: フレーム生成前に見た目を設定してちらつきを防ぐ。
;;; • 設定ファイルの整理: early-init.el にはフレームや起動前に必要な設定を記述し、それ以外は init.el に分離。
;;;
;;; 書くべきでは無いものは色々あるが、eary-initに書けるものを詰め込むのではなく、
;;; eary-initに書いて意味あるものを書く という運用が良いと理解している
;;;
;;; ===================================================================================

;;; code:

;;; ===================================================================================
;;  まず最初に
;;; ===================================================================================

;; --------------------------------------
;; パッケージシステムの初期化を抑制
;; これを抑制して、手動で管理することで起動時間を短縮する
;; （この後でleaf.el呼んでるので意味なかったりする？）
;; --------------------------------------
(setq package-enable-at-startup nil)

;; --------------------------------------
;; 全てをleaf.elで管理したいので、どのみち必要となるleaf.elを最初にロードしてしまう
;; --------------------------------------
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"    . "https://orgmode.org/elpa/")
                       ("melpa"  . "https://melpa.org/packages/")
                       ("gnu"    . "https://elpa.gnu.org/packages/")
                       ( "nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (package-initialize)
  (use-package leaf :ensure t))

;;; ===================================================================================
;;  設定諸々
;;; ===================================================================================
(leaf *early-init*
  :config

  (leaf *起動速度の向上================================================================
    :config

    (leaf *起動時のGC抑制--------------------------------------------------------------
      :doc "まずは最大に"
      :custom (gc-cons-threshold . most-positive-fixnum)
      :config
      (leaf *起動後にGCを戻す
        :doc "デフォルトは800000。最後に戻す"
        :doc "hookだとうまく動かなかったので、configで対応する"
        :config (add-hook 'emacs-startup-hook
                          (lambda () (setq gc-cons-threshold 800000))))
      )

    (leaf *メニューバーやツールバーを表示しない----------------------------------------
      :doc "(menu-bar-mode -1)とか(tool-bar-mode -1)だと速度的には意味ないので注意"
      :push ((default-frame-alist . '(menu-bar-lines . 0))
             (default-frame-alist . '(tool-bar-lines . 0))))

    (leaf *スタートアップメッセージの非表示--------------------------------------------
      :doc "このタイミングが良いのか正直自信無いが、early-initでやっている人が多いので僕も習う"
      :custom (inhibit-startup-message . t))
    )

  (leaf *GUI周り設定===================================================================
    :config

    (leaf *新規フレームに対してフォント設定--------------------------------------------
      :url "https://apribase.net/2024/07/06/emacs-default-frame-alist/"
      :doc "↑のURLを参考に設定。early-initなので、再読み込みはしない前提でadd-to-listではなくpushしている"
      :push ((default-frame-alist . '(font . "HackGen Console NF-18"))))

    (leaf *行番号を表示する------------------------------------------------------------
      :url "https://www.grugrut.net/posts/201910202227/"
      :doc "display-line-numbers-width-startは、skk使ってた時の名残（↑URL参照）"
      :custom ((global-display-line-numbers-mode . t)
               (custom-set-variables . '(display-line-numbers-width-start t))))
    )
  (leaf *その他フレーム起動前にやりたい設定============================================
    :config

    (leaf *バイトコンパイルの警告の非表示----------------------------------------------
      :doc "Package xx is deprecated とかを抑制する"
      :doc "解決策なくて鬱陶しくなったらオンにするが、極力潰し込む方向で頑張る"
      :ignored
      :custom (byte-compile-warnings . '(cl-functions)))
    )

  (leaf *その他init.elでエラーが起きても設定されてないと辛い最低限設定================
    :config

    (leaf *C-hでバックスペース--------------------------------------------------------
      :doc "bindで設定できないのでinitとして設定(:configでも良いのでは？と思ったけど、それだと動かなかった)"
      :doc "↑leaf.elのパパから「:bindがあると:configは遅延されますね」とのありがたいお言葉いただきました"
      :doc "また、ヘルプも必要に応じて引ける大人になりたいので、C-?をヘルプに割り当て"
      :init
      (define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
      :bind
      ("C-?" . 'help-for-help)
      )

    (leaf *トラックパッドに手が当たってメニューが暴発するのを防止---------------------
      :doc "普通に書くなら「global-unset-key」なんてのも用意されている"
      :doc "が、leaf.elに集約したいのでbindで設定"
      :bind (([C-mouse-1] . nil)
             ([C-down-mouse-1] . nil)
             ([C-mouse-3] . nil)
             ([C-down-mouse-3] . nil))
      )
    )
  )


(provide 'early-init)


;;; early-init.el ends here
