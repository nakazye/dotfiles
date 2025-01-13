;;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:
;;; Emacs Startup File

;;; 全てをleaf.elで管理するぞ大作戦始動
;;;
;;; --- キーバインド設定における個人的方針 ---
;;; * M-xを使ったら負けだと考える
;;; * モード問わず利用するものは、C-;からのコンビネーションで設定する
;;; * モード特有で利用するものは、C-'からのコンビネーションで設定する
;;; * 自分が使うものについては、この中に詰まってる状況を作るのである
;;; と思ってたが、CUIだと<C-;>も<C-'>も効かないので、<C-c ;>と<C-c '>を併用する

;;; code:

;;; ===================================================================================

(leaf *init*
  :config

  (leaf *一般設定======================================================================
    :config

    (leaf *言語設定--------------------------------------------------------------------
      :doc "Emacsが扱う文字コードの設定"
      :config
      (prefer-coding-system  'utf-8-unix)
      (set-file-name-coding-system  'utf-8-unix)
      (set-keyboard-coding-system  'utf-8-unix)
      (set-terminal-coding-system  'utf-8-unix)
      (set-default 'buffer-file-coding-system 'utf-8-unix))

    (leaf *Windowsでの文字化け対策-----------------------------------------------------
      :doc "外部プロセスとのやりとりや外部コマンド実行で文字化けを防ぐ"
      :doc "「windowsネイティブのemacs（wslではない）で外部プロセス連携がうまく行かないときに出てきた話だったはず」とのコメントもらいました"
      :when (memq system-type '(cygwin windows-nt ms-dos))
      :config
      (setq-default default-process-coding-system '(utf-8-unix . japanese-cp932-dos)))

    (leaf *ビープ音を無効化する--------------------------------------------------------
      :doc "visible-bell設定入れようかとも思ったけど、macだと画像出る様になってて鬱陶しかったので無効に"
      :doc "(この設定だと、visible-bellも無効になる（警告音/画面フラッシュも全部無効）)"
      :custom (ring-bell-function . 'ignore))

    (leaf *yes-or-noをy-or-nに変更-----------------------------------------------------
      :custom (use-short-answers . t))

    (leaf *バックアップファイルをよしなに設定------------------------------------------
      :url "http://yohshiy.blog.fc2.com/blog-entry-319.html"
      :doc "バックアップファイルにどんな種類があるかについては↑がわかりやすい"
      :doc "ここでは、以下の設定にしている"
      :doc "* バックアップファイル (foo.txt~) → 作る。~/.emacs.d/backupに配置する"
      :doc "* 自動保存ファイル (#foo.txt#) → 作る(正常終了すれば消えるファイル)。~/.emacs.d/backupに配置する"
      :doc "* 自動保存リストファイル (~/.emacs.d/auto-save-list/.saves-xxxx)→作らない"
      :doc "* ロックファイル (.#foo.txt)→作らない"
      :custom
      ;; バックアップファイル設定
      (make-backup-files . t)
      (backup-directory-alist . '((".*" . "~/.emacs.d/backup/")))
      ;; 自動保存ファイル設定
      (auto-save-default . t)
      (auto-save-file-name-transforms . '((".*" "~/.emacs.d/backup/" t)))
      ;; 自動保存リストファイル設定
      (auto-save-list-file-prefix . nil)
      ;; ロックファイル設定
      (create-lockfiles . nil))

    (leaf *勝手にできるファイルを散らかさない------------------------------------------
      :doc "勝手に作られる設定ファイルやキャッシュを良い感じにまとめてくれる"
      :config
      (leaf no-littering
	      :url "https://github.com/emacscollective/no-littering"
	      :ensure t
	      :require t
	      :custom
        (no-littering-etc-directory . "~/.emacs.d/etc/")
	      (no-littering-var-directory . "~/.emacs.d/var/")))

    (leaf *自動revert設定-------------------------------------------------------------
      :doc "他でファイル変更があった際の再読み込み"
      :custom (auto-revert-interval . 1)
      :global-minor-mode global-auto-revert-mode)

    (leaf *ファイル削除をゴミ箱移動に--------------------------------------------------
      :custom (delete-by-moving-to-trash . t))

    (leaf *カレントディレクトリの変更--------------------------------------------------
      :config (cd "~/"))

    (leaf *構文チェック----------------------------------------------------------------
      :doc "flycheckかflymakeかどちらもありだけど、flycheck優勢な気がするので（人に聞ける可能性上がるので）flycheckにする"
      :config
      )

    ) ; end of 一般設定 ===============================================================

  
  (leaf *GUI表示系設定=================================================================
    :if (window-system)
    ;; フォントサイズ確認
    ;; ----------------------------------------
    ;; abcdefghijklmnopgrstuvwxyz
    ;; ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ;; 01234567890 !@#$%^&*_=+~
    ;; ()[]{}<>\|/
    ;; 零一二三四五六七八九
    ;;
    ;; Nerdフォント確認
    ;; ----------------------------------------
    ;;    
    ;; 絵文字確認
    ;; ----------------------------------------
    ;; 🥺🍣🍖
    :config

    (leaf *日本語の表示に中華フォントが混ざるのを防ぐ----------------------------------
      :doc "なんかmacで表示がガタガタするなと思ったら、漢字が中華フォントになっていたので設定"
      :config (set-language-environment "Japanese"))

    (leaf *絵文字のサイズを設定--------------------------------------------------------
      :doc "簡単に指定するような方法は見つからず、OS標準を使いたいなら、それごとに設定が必要な気がする"
      :config
      (leaf *Macでの設定
	      :doc "基本のフォントサイズ14でちょうど良い(高さが大きくズレない)数値を設定"
	      :if (eq system-type 'darwin)
	      :config (set-fontset-font (frame-parameter nil 'font) '(#x1F004 . #x1FFFD) (font-spec :family "Apple Color Emoji" :size 10)))
      (leaf *Windowsでの設定
	      :doc "設定サイズは未確認"
	      :if (eq system-type 'windows-nt)
	      :config (set-fontset-font (frame-parameter nil 'font) '(#x1F004 . #x1FFFD) (font-spec :family "Segoe UI Emoji" :size 10)))
      )

    (leaf *カーソルを自分好みに--------------------------------------------------------
      :url "https://qiita.com/tadsan/items/f23d6db8efc0fcdcd225"
      :doc "↑の説明がめっちゃわかりやすい"
      :config (add-to-list 'default-frame-alist '(cursor-type . bar)))

    ) ; end of GUI表示系設定===========================================================

  (leaf *一般表示系設定================================================================
    :config

    (leaf *カラーテーマ設定------------------------------------------------------------
      :doc "可愛い色でテンションぶちあげたい！"
      :url "https://conao3.com/blog/2020-13fc-43ec/"
      :doc "↑を参考に設定"
      :doc ".emacs.d/themesフォルダを別の場所に動かしたいけど、色々試してできなかったので一旦TODOとして寝かせておく"
      :config
      (leaf solarized-theme
	      :url "https://github.com/bbatsov/solarized-emacs"
	      :ensure t
	      :require t
	      :config
	      (solarized-create-theme-file-with-palette
	          'light 'my-solarized-light
	        '("#d688a7" "#f4f0f9"
	          "#c1e2f6" "#efc9cd" "#e8c34d" "#e4a747" "#c2d648" "#a2dcad" "#94cbd1" "#c6a3d8"))
	      (load-theme 'my-solarized-light t)))

    (leaf *カラーコードに色をつける----------------------------------------------------
      :config
      (leaf colorful-mode
	      :url "https://github.com/DevelopmentCool2449/colorful-mode"
	      :ensure t
	      :bind (("C-; c"   . colorful-mode)
               ("C-c ; c" . colorful-mode))
	      :custom ((colorful-use-prefix . t)
		             (colorful-prefix-string . "󰏘 "))))

    (leaf *NerdFontsアイコンを利用する-------------------------------------------------
      :config
      (leaf nerd-icons
	      :url "https://github.com/rainstormstudio/nerd-icons.el"
	      :ensure t))

    (leaf *かっこの表示をわかりやすく--------------------------------------------------
      :doc "かっこの対応を異なる色付けで表示する"
      :config
      (leaf rainbow-delimiters
        :url "https://github.com/Fanael/rainbow-delimiters"
        :ensure t
        :bind (("C-; R"   . rainbow-delimiters-mode)
               ("C-c ; R" . rainbow-delimiters-mode))
        :hook (prog-mode-hook . rainbow-delimiters-mode)))

    (leaf *カーソルを見失わない--------------------------------------------------------
      :doc "カーソルがジャンプするとピコーンと光る。C-lで便利"
      :config
      (leaf beacon
        :url "https://github.com/Malabarba/beacon"
        :ensure t
        :custom (beacon-color . "pink")
        :config
        (beacon-mode 1)))

    ) ; end of 一般表示系設定==========================================================


  (leaf *モードライン設定==============================================================
    :doc "情報として意味のある設定を入れていきたい（決意）"
    :config

    (leaf *文字コードを短縮系じゃない形で表示------------------------------------------
      :doc "chatGPT君に作ってもらったものであり、全ての形式の確認はしていないので注意"
      :init
      (defun my-mode-line-encoding ()
	      (let ((coding (symbol-name buffer-file-coding-system))
              (eol (coding-system-eol-type buffer-file-coding-system)))
	        (concat
	         (cond
	          ;; ASCII ****************************************************
	          ((string-match "^us-ascii" coding) "ASCII")
	          ;; UTF系 (BOM付き/無し) *************************************
	          ((string-match "^utf-8" coding)
	           (if (string-match "with-signature" coding)
		             "UTF-8(BOM)"
               "UTF-8"))
	          ((string-match "^utf-16" coding)
	           (if (string-match "be-with-signature" coding)
		             "UTF-16BE(BOM)"
               (if (string-match "le-with-signature" coding)
		               "UTF-16LE(BOM)"
		             (if (string-match "be" coding)
		                 "UTF-16BE)"
		               "UTF-16LE)"))))
	          ((string-match "^utf-32" coding)
	           (if (string-match "be-with-signature" coding)
		             "UTF-32BE(BOM)"
               (if (string-match "le-with-signature" coding)
		               "UTF-32LE(BOM)"
		             (if (string-match "be" coding)
		                 "UTF-32BE)"
		               "UTF-32LE)"))))
	          ;; 日本語関連 ***********************************************
	          ((string-match "^euc-jp" coding) "EUC-JP")                        ; EUC-JP
	          ((string-match "^iso-2022-jp" coding) "JIS (ISO-2022-JP)")        ; ISO-2022-JP
	          ((string-match "^shift-jis" coding) "Shift-JIS")                  ; Shift_JIS
	          ((string-match "^cp932" coding) "CP932")                          ; Windows Shift_JIS
	          ((string-match "^jisx0201" coding) "JIS X 0201")                  ; JIS X 0201
	          ((string-match "^jisx0213" coding) "JIS X 0213")                  ; JIS X 0213
	          ;; 国際的な文字コード ***************************************
	          ((string-match "^iso-8859-1" coding) "Latin-1 (ISO-8859-1)")      ; ラテン1
	          ((string-match "^iso-8859-2" coding) "Latin-2 (ISO-8859-2)")      ; ラテン2
	          ((string-match "^iso-8859-3" coding) "Latin-3 (ISO-8859-3)")      ; ラテン3
	          ((string-match "^iso-8859-4" coding) "Latin-4 (ISO-8859-4)")      ; ラテン4
	          ((string-match "^iso-8859-5" coding) "Cyrillic (ISO-8859-5)")     ; キリル文字
	          ((string-match "^iso-8859-6" coding) "Arabic (ISO-8859-6)")       ; アラビア語
	          ((string-match "^iso-8859-7" coding) "Greek (ISO-8859-7)")        ; ギリシャ語
	          ((string-match "^iso-8859-8" coding) "Hebrew (ISO-8859-8)")       ; ヘブライ語
	          ((string-match "^iso-8859-9" coding) "Turkish (ISO-8859-9)")      ; トルコ語
	          ((string-match "^iso-8859-10" coding) "Nordic (ISO-8859-10)")     ; 北欧言語
	          ((string-match "^iso-8859-11" coding) "Thai (ISO-8859-11)")       ; タイ語
	          ((string-match "^iso-8859-13" coding) "Baltic (ISO-8859-13)")     ; バルト言語
	          ((string-match "^iso-8859-14" coding) "Celtic (ISO-8859-14)")     ; ケルト言語
	          ((string-match "^iso-8859-15" coding) "Latin-9 (ISO-8859-15)")    ; ラテン1改良版
	          ((string-match "^iso-8859-16" coding) "Latin-10 (ISO-8859-16)")   ; 東南ヨーロッパ
	          ;; 中国語・ロシア語・その他地域 *****************************
	          ((string-match "^big5" coding) "Big5 (Traditional Chinese)")      ; 繁体字中国語
	          ((string-match "^gb2312" coding) "GB2312 (Simplified Chinese)")   ; 簡体字中国語
	          ((string-match "^gbk" coding) "GBK (Simplified Chinese)")         ; 簡体字中国語
	          ((string-match "^gb18030" coding) "GB18030 (Simplified Chinese)") ; 簡体字中国語拡張
	          ((string-match "^koi8-r" coding) "KOI8-R (Cyrillic, Russian)")    ; ロシア語
	          ((string-match "^koi8-u" coding) "KOI8-U (Cyrillic, Ukrainian)")  ; ウクライナ語
	          ;; その他 ***************************************************
	          ((string-match "^ebcdic" coding) "EBCDIC (IBM Mainframe)")        ; IBM文字コード
	          ((string-match "^ibm437" coding) "IBM437 (MS-DOS English)")       ; MS-DOS英語
	          ((string-match "^ibm850" coding) "IBM850 (MS-DOS Western Europ)") ; 西ヨーロッパ
	          (t coding))                                                       ; その他ofその他の文字コードはそのまま表示
	         ;; 改行コードの表示
	         (cond
	          ((eq eol 0) ":LF")    ; UNIX (LF)
	          ((eq eol 1) ":CRLF")  ; DOS/Windows (CRLF)
	          ((eq eol 2) ":CR")    ; Mac (CR)
	          (t "")))))              ; デフォルト（改行コードなし）
      :custom (mode-line-mule-info . '(:eval (format "%s" (my-mode-line-encoding)))))

    (leaf *編集状態をわかりやすく------------------------------------------------------
      :doc "こちらもChatGPTより"
      :doc "mode-line-buffer-identificationに設定しても、元々の---が残ってしまったので、まずは関数定義"
      :init
      (defun my-mode-line-buffer-state ()
	      (cond
	       ((and buffer-read-only (buffer-modified-p)) "読専(けど編集中!)") ; 読み取り専用 + 変更あり
	       (buffer-read-only "読専")                                        ; 読み取り専用 + 未変更
	       ((buffer-modified-p) "未保存")                                   ; 編集可能 + 変更あり
	       (t "未変更")))                                                   ; 編集可能 + 未変更
      )

    (leaf *モードラインを自分好みに並べ替え--------------------------------------------
      :config
      (setq-default mode-line-format
		    '( "%e"                                ; エラー情報
		       mode-line-front-space               ; 余白
		       "%b"                                ; バッファ名
		       " | "
		       mode-line-mule-info                 ; 文字コードおよび改行コード
		       " | "
                       (:eval (my-mode-line-buffer-state)) ; バッファの状態を表示
		       " | "
                       "Line%l/Col%c %p "                  ; 行番号と列番号とバッファの位置（%表示）
		       ;; emacs 30から↓が効く
		       ;; mode-line-format-right-align        ; ここから右寄せ
		       ;; が、バージョンアップ面倒なので一旦普通にセパレーターを配置する
		       " | "
                       (:eval (if mode-name                ; メジャーモード名を表示
				  mode-name
				"no major-mode"))
		       " | "
		       (:eval (if vc-mode                  ; バージョン管理情報を表示
				  (substring vc-mode 1)
				"no VC"))
		       )))

    ) ; end of モードライン設定========================================================


  (leaf *ファイル編集設定==============================================================
    :config

    (leaf *フォーマット系諸々----------------------------------------------------------
      :custom
      (truncate-lines        . t)     ; 行を折り返さない
      (require-final-newline . nil)   ; ファイルの末尾に改行を挿入しない
      (tab-width             . 2)     ; タブ幅
      (indent-tabs-mode      . nil)   ; タブをスペースで
      )

    (leaf *リージョン選択中に入力すると、選択範囲を消して入力--------------------------
      :global-minor-mode delete-selection-mode)

    (leaf *以前開いたファイルを再度開いたときに元のカーソル位置を復元してくれる--------
      :global-minor-mode save-place-mode)

    (leaf *行末の空白文字（スペースやタブなど）を削除----------------------------------
      :bind (("C-; e w"   . delete-trailing-whitespace)
             ("C-c ; e w" . delete-trailing-whitespace)))

    (leaf *コードインデント------------------------------------------------------------
      :doc "標準でキーバインド設定されているが、いつも忘れるので別で割り当てる"
      :bind (("C-; e i"   . indent-region)
             ("C-c ; e i" . indent-region)))

    (leaf *undoやredoを便利に----------------------------------------------------------
      :doc "undo-treeやundo-fuと悩んだけどvundoを利用してみる"
      :config
      (leaf vundo
        :url "https://github.com/casouri/vundo"
        :doc " 操作方法:                                                                      "
        :doc "                                                                                "
        :doc " f   : 前の状態に進む                                                           "
        :doc " b   : 前の状態に戻る                                                           "
        :doc "                                                                                "
        :doc " n   : 分岐点で下のノードに移動                                                 "
        :doc " p   : 上のノードに移動                                                         "
        :doc "                                                                                "
        :doc " a   : 前の分岐点に戻る                                                         "
        :doc " w   : 次の分岐点に進む                                                         "
        :doc " e   : 現在のブランチの末端（最後のノード）に進む                               "
        :doc " l   : 最後に保存されたノードに移動                                             "
        :doc " r   : 次に保存されたノードに移動                                               "
        :doc "                                                                                "
        :doc " m   : 現在のノードを差分表示用にマークする                                     "
        :doc " u   : マークされたノードのマークを解除                                         "
        :doc " d   : マークされたノード（または親ノード）と現在のノードの間で差分を表示する   "
        :doc "                                                                                "
        :doc " q   : 終了する（または C-g で終了）                                            "
        :doc "                                                                                "
        :doc " C-c C-s（または save-buffer に割り当てられたショートカットキー）:              "
        :doc "       現在の undo 状態でバッファを保存する                                     "
        :ensure t
        :custom
        ((vundo-compact-display . t)) ; ツリーをコンパクトに表示
        :bind
        (("C-; e v"   . vundo)
         ("C-c ; e v" . vundo))))

      (leaf *操作にハイライトを--------------------------------------------------------
        :doc "yankやundoした際に編集箇所をわかりやすい様にハイライトを入れる"
        :config
        (leaf volatile-highlights
          :url "https://github.com/k-talo/volatile-highlights.el"
          :ensure t
          :config
          (volatile-highlights-mode t))
        )

    ) ; end of ファイル編集設定========================================================

  
  (leaf *各種便利機能==================================================================
    :config

    (leaf *キーバインド表示------------------------------------------------------------
      :doc "!!!!今はwhich-keyを使っているけど、emacs30では機能が同梱されるとのこと!!!!"
      :config
      (leaf which-key
	      :url "https://github.com/justbur/emacs-which-key"
	      :ensure t
	      :config
	      (which-key-mode)
	      (which-key-add-keymap-based-replacements
	        global-map
	        "C-c ;"   "cui-global-map" ; なぜか効かない。後で調べる（が、仕様な気もする）
	        "C-c '"   "cui-local-map"
	        "C-; o"   "org-command-map"
	        "C-c ; o" "org-command-map"
	        "C-; a"   "affe-command-map"
	        "C-c ; a" "affe-command-map"
	        "C-; t"   "treemacs-command-map"
	        "C-c ; t" "treemacs-command-map"
          "C-; e"   "edit-command-map"
          "C-c ; e" "edit-command-map"
          "C-; f"   "file-command-map"
          "C-c ; f" "file-command-map")))

    (leaf *最近使ったファイル----------------------------------------------------------
      :doc "標準機能(recentf)として具備されている"
      :doc "recentf-open-files使っても良いけど、consult-bufferに表示もされる"
      :global-minor-mode recentf-mode
      :custom
      (recentf-max-saved-items . 20000)
      (recentf-max-menu-items  . 20000)
      (recentf-auto-cleanup    . 'never)
      (recentf-exclude
       . '((expand-file-name package-user-dir)
           "~/.emacs.d/backup"
           "~/.emacs.d/etc"
           "~/.emacs.d/var"
           "*.png"
           "*.jpeg"
           ".org_archive"
           "COMMIT_EDITMSG\\'"))
      :bind
      (("C-; f o"   . recentf-open-files)
       ("C-c ; f o" . recentf-open-files)))

    (leaf *ripgrep使うよ---------------------------------------------------------------
      :doc "検索後にhでヘルプが表示される。以下の追加コマンドが便利"
      :doc "r: 検索ワードを変更"
      :doc "f: 対象ファイル種を変更"
      :doc "d: 検索ディレクトリの変更"
      :doc "c: 大文字小文字の差を無視するかのオンオフ"
      :doc "i: 無視設定のオン・オフ"
      :config
      (leaf rg
	      :url "https://github.com/dajva/rg.el"
	      :ensure t
	      :bind (("C-; r"   . rg)
	             ("C-c ; r" . rg))))

    (leaf *grepやfindを便利に----------------------------------------------------------
      :config
      (leaf affe
	      :doc "ripgrepやfdをfuzzyに利用する(ファイル多すぎるとエラーが出る気もしている)"
	      :url "https://github.com/minad/affe"
	      :ensure t
	      :bind (("C-; a g"   . affe-grep)
	             ("C-c ; a g" . affe-grep)
	             ("C-; a f"   . affe-find)
	             ("C-c ; a f" . affe-find))))

    (leaf *ミニバッファで補完UI--------------------------------------------------------
      :doc "Emacs28から標準添付されるfido-vertical-modeがあったりする"
      :doc "が、Tabでしゅっとしてくれなかったり、そもそも情報少ないのでverticoを用いる"
      :config
      (leaf vertico
	      :url "https://github.com/minad/vertico"
	      :ensure t
	      :config
	      ;; https://qiita.com/nobuyuki86/items/4150d5ec433e62757951
	      (defvar +vertico-current-arrow t)
	      (cl-defmethod vertico--format-candidate :around
	        (cand prefix suffix index start &context ((and +vertico-current-arrow
							                                           (not (bound-and-true-p vertico-flat-mode)))
						                                        (eql t)))
	        (setq cand (cl-call-next-method cand prefix suffix index start))
	        (let ((arrow " "))
	          (if (bound-and-true-p vertico-grid-mode)
		            (if (= vertico--index index)
		                (concat arrow " " cand)
		              (concat #("_" 0 1 (display " ")) cand))
              (if (= vertico--index index)
		              (concat " " arrow " " cand)
		            (concat "    " cand)))))
        :custom
        (vertico-count . 15)   ; 表示数
        (vertico-resize . nil) ; 固定サイズで表示
        (vertico-cycle . t)    ; 循環スクロール
        :hook
        (after-init-hook . vertico-mode)
        (after-init-hook . savehist-mode) ; 順番を保存
        ))

    (leaf *色々な局面で便利な補完を実行------------------------------------------------
      :doc "consult.elを今まで適当にコピペ設定で使っていたが、ちゃんと設定していく"
      :doc "と、書いたけど、機能の多さに面食らっているので、一気にやらずに育てていくのが良いと思った"
      :config
      (leaf consult
	      :url "https://github.com/minad/consult"
	      :ensure t
	      ;; 以下キーバインドについて、fuzzy finderなorderlessが無いと毎度先頭に*を入れる必要があり不便
	      ;; あと、大文字小文字も区別されて使いづらいので、orderlessの必要性を理解した
	      :bind (("C-s" . consult-line)            ; 標準の置き換え（検索）
               ("C-x b" . consult-buffer)        ; 標準の置き換え（バッファ切り替え）
	             )))

    (leaf *補完パネルに追加情報を表示--------------------------------------------------
      :config
      ;; 右側に色々と情報を追加
      (leaf marginalia
	      :url "https://github.com/minad/marginalia"
	      :ensure t
	      :custom (marginalia-align . 'right)
	      :hook (after-init-hook . marginalia-mode))
      ;; nerdアイコンを付与
      (leaf nerd-icons-completion
	      :url "https://github.com/rainstormstudio/nerd-icons-completion"
	      :ensure t
	      :after marginalia
	      :config
	      (nerd-icons-completion-mode)
	      :hook
	      (marginalia-mode-hook . nerd-icons-completion-marginalia-setup)
	      )
      )

    (leaf *fuzzyにfindさせる-----------------------------------------------------------
      :doc "設定しているorderless-literalは、hogeを「*hoge*」としてfindしてくれる"
      :config
      (leaf orderless
	      :url "https://github.com/oantolin/orderless"
	      :ensure t
	      :custom
	      `((completion-styles . '(orderless))
	        (orderless-matching-styles
	         . '(orderless-literal)))))

    (leaf *特定ディレクトリ配下をプロジェクトとして扱う--------------------------------
      :doc "treemacs君と組み合わせると、tree表示を良い感じにしてくれて便利"
      :doc "一方、設定次第ではパフォーマンスに影響があるので注意すること（↓参照）"
      :url "https://blog.tomoyukim.net/post/2022/08/19/084659/"
      :config
      (leaf projectile
	      :url "https://github.com/bbatsov/projectile"
	      :ensure t
	      :custom (projectile-dynamic-mode-line . nil)
	      :bind (:projectile-mode-map
	             (("C-; p" . projectile-command-map)
		            ("C-c ; p" . projectile-command-map)))
	      :hook
	      (after-init-hook . (lambda ()
			                       (projectile-mode t)))
	      ))

    (leaf *ツリービュー設定------------------------------------------------------------
      :doc "NeoTreeとかもあるけど、他のプラグインと統合しやすそうなTreemacsを選択"
      :config
      (leaf treemacs
	      :url "https://github.com/Alexander-Miller/treemacs"
	      :ensure t
	      :bind (("C-; t 0"   . treemacs-select-window)           ; treemacsのウィンドウにフォーカス
	             ("C-c ; t 0" . treemacs-select-window)
	             ("C-; t 1"   . treemacs-delete-other-windows)    ; treemacsのウィンドウを残して全部クローズ
	             ("C-c ; t 1" . treemacs-delete-other-windows)
	             ("C-; t t"   . treemacs)                         ; treemacsウィンドウをトグル
	             ("C-c ; t t" . treemacs)
	             ("C-; t d"   . treemacs-select-directory)        ; 特定のディレクトリを選択してルートノードに設定
	             ("C-c ; t d" . treemacs-select-directory)
	             ("C-; t b"   . treemacs-bookmark)                ; ブックマークを選択して Treemacs ビュー内で展開
	             ("C-c ; t b" . treemacs-bookmark)
	             ;; ("C-; t C-t" . treemacs-find-file)             ; 現在のバッファのファイルを Treemacs ビュー内で選択
	             ;; ("C-; t M-t" . treemacs-find-tag)              ; 現在のバッファのファイル内のタグを Treemacs ビューで選択
	             )
	      :config
	      (treemacs-follow-mode t)                        ; 追従させる
	      (treemacs-project-follow-mode t)                ; projectileと連動
	      (treemacs-filewatch-mode t)                     ; 外部でファイルが増えたり減ったり名前変わっても反映
	      (treemacs-fringe-indicator-mode 'always)        ; 選択されてるインジケーターを常に表示
	      (treemacs-hide-gitignored-files-mode nil)       ; gitignore指定されていても表示
	      ;; 以下、徐々に育てていきたい
	      (treemacs-create-theme "my-treemacs-theme"
			                         :config
			                         (progn
				                         (treemacs-create-icon :icon " " :extensions (root-open) :fallback 'same-as-icon)
				                         (treemacs-create-icon :icon " " :extensions (root-closed) :fallback 'same-as-icon)
				                         (treemacs-create-icon :icon " " :extensions (dir-open) :fallback 'same-as-icon)
				                         (treemacs-create-icon :icon " " :extensions (dir-closed) :fallback 'same-as-icon)
				                         (treemacs-create-icon :icon " " :extensions (fallback) :fallback 'same-as-icon)))
	      (treemacs-load-theme "my-treemacs-theme")
	      :hook (treemacs-mode-hook . (lambda ()
			                                (setq mode-line-format nil)
			                                (display-line-numbers-mode 0)))))

    (leaf *編集中にぺろんと補完するやつ------------------------------------------------
      :doc "companyにお世話になっていたけど、令和はcorfu+capeらしいので試す"
      :doc "なお、CUIでは動作しない。Emacs 31から動作するとのこと。先は長い・・・"
      :config
      (leaf corfu
	      :url "https://github.com/minad/corfu"
	      :ensure t
	      :hook (emacs-startup-hook . global-corfu-mode)
	      :custom ((corfu-auto . t)            ; 入力時に自動的に補完候補を表示
		             (corfu-auto-delay . 0.2)    ; 自動補完の遅延時間
		             (corfu-auto-prefix . 2)     ; 自動補完が有効になる入力文字数
		             (corfu-cycle . t)           ; 候補リストを循環
		             (corfu-quit-no-match . t)   ; 候補がない場合に補完を終了
		             (corfu-preselect . 'first)  ; 最初の候補を事前選択
		             (corfu-scroll-margin . 2))  ; 候補スクロール開始位置が候補ウィンドウの下から何行目か
	      :bind (:corfu-map
	             ("TAB" . corfu-insert)      ; Tab キーで補完を確定
	             ([tab] . corfu-insert)
	             ("RET" . nil)               ; Enter キーで補完を無効化（デフォルトの動作に戻す）
	             )
        :config
        ;; nerd-iconの利用
        (leaf nerd-icons-corfu
          :url "https://github.com/LuigiPiucco/nerd-icons-corfu"
          :ensure t
          :after (nerd-icons corfu)
          :custom 
          :config
          ;;; 利用できる様にするよ
          (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
          :defer-config
          ;; 無理やりスペースの幅を調整する(20241202.2355の元コードから。Ambiguous-width characters絡みの問題と理解している)
          ;; 元コードを上書きしたいので、customは使わない
          (setq nerd-icons-corfu--space  "  "))
        ;; CUIで利用できる様にするよ
        (leaf corfu-terminal
          :url "https://codeberg.org/akib/emacs-corfu-terminal"
          :unless (display-graphic-p) ; GUI 環境ではスキップ
          :ensure t
          :config
          (corfu-terminal-mode 1)))
      ;; 続いてcape
      (leaf cape
	      :doc "Emacsの標準補完機能であるcapfsと統合する。"
	      :doc "よってもってつまりはlsp-modeとか各種言語のメジャーモードとかでそれそのまま使えてしまう という理解"
	      :url "https://github.com/minad/cape"
	      :ensure t
	      :after corfu
	      :config
	      ;; abbrev (略語) の補完
	      (add-to-list 'completion-at-point-functions #'cape-abbrev)
	      ;; バッファ内の単語を補完
	      (add-to-list 'completion-at-point-functions #'cape-dabbrev)
	      ;; 辞書ファイルから単語を補完
	      (add-to-list 'completion-at-point-functions #'cape-dict)
	      ;; Org や Markdown のコードブロック内で Elisp を補完
	      (add-to-list 'completion-at-point-functions #'cape-elisp-block)
	      ;; Elisp シンボルを補完
	      (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
	      ;; 絵文字の補完
	      (add-to-list 'completion-at-point-functions #'cape-emoji)
	      ;; ファイル名の補完
	      (add-to-list 'completion-at-point-functions #'cape-file)
	      ;; Eshell や Comint、ミニバッファの履歴から補完
	      (add-to-list 'completion-at-point-functions #'cape-history)
	      ;; プログラミング言語のキーワードを補完
	      (add-to-list 'completion-at-point-functions #'cape-keyword)
	      ;; 現在のバッファから行全体を補完
	      (add-to-list 'completion-at-point-functions #'cape-line)
	      ;; RFC 1345 に基づく Unicode 補完
	      (add-to-list 'completion-at-point-functions #'cape-rfc1345)
	      ;; SGML エンティティ (例: &alpha;) に基づく補完
	      (add-to-list 'completion-at-point-functions #'cape-sgml)
	      ;; TeX コマンド (例: \hbar) に基づく Unicode 補完
	      (add-to-list 'completion-at-point-functions #'cape-tex)
	      ))

    ) ; end of 各種便利機能============================================================

  (leaf *特定言語やメジャーモード設定==================================================
    :config
    ;;
    ) ; end of 特定言語やメジャーモード設定============================================

  (leaf *org-modeと仲良くなりたい======================================================
    :config
    ;;
    ) ; end of org-modeと仲良くなりたい================================================


  )
(provide 'init)


;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cape nerd-icons-corfu corfu treemacs projectile orderless nerd-icons-completion marginalia consult vertico affe rg which-key volatile-highlights vundo beacon rainbow-delimiters nerd-icons colorful-mode solarized-theme no-littering leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
