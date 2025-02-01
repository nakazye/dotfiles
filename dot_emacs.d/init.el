;;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:
;;; Emacs Startup File

;;; 全てをleaf.elで管理するぞ大作戦2025始動
;;;
;;; --- キーバインド設定における個人的方針 ---
;;; * M-xを使ったら負けだと考える
;;; * モード問わず利用するものは、C-;からのコンビネーションで設定する
;;; * モード特有で利用するものは、C-'からのコンビネーションで設定する
;;; * 自分が使うものについては、この中に詰まってる状況を作るのである
;;; と思ってたが、CUIだと<C-;>も<C-'>も効かないので、<C-c ;>と<C-c '>を併用する

;;; code:

;;; ======================================================================================

(leaf *init*
  :config

  (leaf *一般設定=========================================================================
    :config

    (leaf *ショートカット設定-------------------------------------------------------------
      :doc "C-;とC-'をC-c ;、C-c 'で起動できる様にする"
      :doc "terminal操作だとC-;やC-'が効かないので苦肉の策" ;; CUI操作用に今年はVim覚えたい
      :init
      (define-key key-translation-map (kbd "C-c ;") (kbd "C-;"))
      (define-key key-translation-map (kbd "C-c '") (kbd "C-'"))
      )

    (leaf *言語設定-----------------------------------------------------------------------
      :doc "Emacsが扱う文字コードの設定"
      :config
      (prefer-coding-system  'utf-8-unix)
      (set-file-name-coding-system  'utf-8-unix)
      (set-keyboard-coding-system  'utf-8-unix)
      (set-terminal-coding-system  'utf-8-unix)
      (set-default 'buffer-file-coding-system 'utf-8-unix)
      (modify-coding-system-alist 'file "" 'utf-8-unix))

    (leaf *Windowsでの文字化け対策--------------------------------------------------------
      :doc "外部プロセスとのやりとりや外部コマンド実行で文字化けを防ぐ"
      :doc "「windowsネイティブのemacs（wslではない）で外部プロセス連携がうまく行かないときに出てきた話だったはず」とのコメントもらいました"
      :when (memq system-type '(cygwin windows-nt ms-dos))
      :config
      (setq-default default-process-coding-system '(utf-8-unix . japanese-cp932-dos)))

    (leaf *ビープ音を無効化する-----------------------------------------------------------
      :doc "visible-bell設定入れようかとも思ったけど、macだと画像出る様になってて鬱陶しかったので無効に"
      :doc "(この設定だと、visible-bellも無効になる（警告音/画面フラッシュも全部無効）)"
      :custom (ring-bell-function . 'ignore))

    (leaf *yes-or-noをy-or-nに変更--------------------------------------------------------
      :custom (use-short-answers . t))

    (leaf *バックアップファイルをよしなに設定---------------------------------------------
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

    (leaf *勝手にできるファイルを散らかさない---------------------------------------------
      :doc "勝手に作られる設定ファイルやキャッシュを良い感じにまとめてくれる"
      :config
      (leaf no-littering
        :url "https://github.com/emacscollective/no-littering"
        :ensure t
        :require t
        :custom
        (no-littering-etc-directory . "~/.emacs.d/etc/")
        (no-littering-var-directory . "~/.emacs.d/var/")))

    (leaf *自動revert設定-----------------------------------------------------------------
      :doc "他でファイル変更があった際の再読み込み"
      :custom (auto-revert-interval . 1)
      :global-minor-mode global-auto-revert-mode)

    (leaf *ファイル削除をゴミ箱移動に-----------------------------------------------------
      :custom (delete-by-moving-to-trash . t))

    (leaf *カレントディレクトリの変更-----------------------------------------------------
      :config (cd "~/"))

    ) ; end of 一般設定 ==================================================================


  (leaf *GUI表示系設定====================================================================
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

    (leaf *日本語の表示に中華フォントが混ざるのを防ぐ-------------------------------------
      :doc "なんかmacで表示がガタガタするなと思ったら、漢字が中華フォントになっていたので設定"
      :config (set-language-environment "Japanese"))

    (leaf *絵文字のサイズを設定-----------------------------------------------------------
      :doc "簡単に指定するような方法は見つからず、OS標準を使いたいなら、それごとに設定が必要な気がする"
      :config
      (leaf *Macでの設定
        :doc "基本のフォントサイズ14でちょうど良い(高さが大きくズレない)数値を設定"
        :if (eq system-type 'darwin)
        :config (set-fontset-font (frame-parameter nil 'font) '(#x1F004 . #x1FFFD) (font-spec :family "Apple Color Emoji" :size 10)))
      (leaf *Windowsでの設定
        :doc "フォントサイズ設定すると、14でも小さい感じでなんかおかしいので、いったんフォントサイズ指定をやめている"
        :if (eq system-type 'windows-nt)
        :config (set-fontset-font (frame-parameter nil 'font) '(#x1F004 . #x1FFFD) (font-spec :family "Segoe UI Emoji")))
      )

    (leaf *カーソルを自分好みに-----------------------------------------------------------
      :url "https://qiita.com/tadsan/items/f23d6db8efc0fcdcd225"
      :doc "↑の説明がめっちゃわかりやすい"
      :config (add-to-list 'default-frame-alist '(cursor-type . bar)))

    ) ; end of GUI表示系設定==============================================================

  (leaf *一般表示系設定===================================================================
    :config

    (leaf *カラーテーマ設定---------------------------------------------------------------
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

    (leaf *カラーコードに色をつける-------------------------------------------------------
      :config
      (leaf colorful-mode
        :url "https://github.com/DevelopmentCool2449/colorful-mode"
        :ensure t
        :bind (("C-; v c"   . colorful-mode))
        :custom ((colorful-use-prefix . t)
                 (colorful-prefix-string . "󰏘 "))))

    (leaf *NerdFontsアイコンを利用する----------------------------------------------------
      :config
      (leaf nerd-icons
        :url "https://github.com/rainstormstudio/nerd-icons.el"
        :ensure t
        :config (leaf *SymbolsNerdFontMonoが入ってなければHackGenのNerdFontを使う*
                  :doc "HackGenのNerdFontだとアイコンが総じて半角になるので、Symbols Nerd Font Monoを優先"
                  :unless (member "Symbols Nerd Font Mono" (font-family-list))
                  :custom (nerd-icons-font-family . "HackGen Console NF")
                  )
        ))

    (leaf *かっこの表示をわかりやすく-----------------------------------------------------
      :doc "かっこの対応を異なる色付けで表示する"
      :config
      (leaf rainbow-delimiters
        :url "https://github.com/Fanael/rainbow-delimiters"
        :ensure t
        :bind (("C-; R"   . rainbow-delimiters-mode))
        :hook (prog-mode-hook . rainbow-delimiters-mode)))

    (leaf *カーソルを見失わない-----------------------------------------------------------
      :doc "カーソルがジャンプするとピコーンと光る。C-lで便利"
      :config
      (leaf beacon
        :url "https://github.com/Malabarba/beacon"
        :ensure t
        :custom (beacon-color . "pink")
        :config
        (beacon-mode 1)))

    ) ; end of 一般表示系設定=============================================================

  (leaf *モードライン設定=================================================================
    :doc "情報として意味のある設定を入れていきたい（決意）"
    :config

    (leaf *素敵なモードラインを作るぞ！---------------------------------------------------
      :doc "doom-modelineを導入して、自分好みのモードラインを作るぞ"
      :config
      (leaf doom-modeline
        :ensure t
        :init
        (doom-modeline-mode 1)
        :custom-face
        ;; 下線が引かれるのを消す。ChatGPTにやり方聞いてそのままコピペしたら、普通に動いてびっくり
        (mode-line . '((t (:underline nil))))
        (mode-line-inactive . '((t (:underline nil))))
        :config
        (column-number-mode t) ;; 列番号表示(doom-modelineの設定ではないけど、ここであわせて設定)
        :custom
        (doom-modeline-height . 20)             ;; モードラインの高さを設定します（ピクセル単位）
        (doom-modeline-minor-modes . nil)       ;; モードラインにマイナーモードを表示するかどうか
        (doom-modeline-vcs-max-length . 12)     ;; バージョン管理システム（VCS）のブランチ名の最大長
        (doom-modeline-indent-info . t)         ;; 現在のインデント情報を表示するかどうか。
        (doom-modeline-position-column-line-format . '("L:%l C:%c")) ;; 行番号＆列番号の表示フォーマット
        ))

    (leaf *ニャンするぞ-------------------------------------------------------------------
      :config
      (leaf nyan-mode
        :url "https://github.com/TeMPOraL/nyan-mode"
        :ensure t
        :init (nyan-mode t)
        :custom ((nyan-animate-nyancat . t)
                 (nyan-cat-face-number . 4))))

    ) ; end of モードライン設定===========================================================


  (leaf *ファイル編集設定=================================================================
    :config

    (leaf *フォーマット系諸々-------------------------------------------------------------
      :custom
      (truncate-lines        . t)     ; 行を折り返さない
      (require-final-newline . nil)   ; ファイルの末尾に改行を挿入しない
      (tab-width             . 2)     ; タブ幅
      (indent-tabs-mode      . nil)   ; タブをスペースで
      )

    (leaf *リージョン選択中に入力すると、選択範囲を消して入力-----------------------------
      :global-minor-mode delete-selection-mode)

    (leaf *以前開いたファイルを再度開いたときに元のカーソル位置を復元してくれる-----------
      :global-minor-mode save-place-mode)

    (leaf *行末の空白文字（スペースやタブなど）を削除-------------------------------------
      :bind (("C-; e w"   . delete-trailing-whitespace)))

    (leaf *タブをスペースに変換-----------------------------------------------------------
      :bind (("C-; e t"   . untabify)))

    (leaf *全選択-------------------------------------------------------------------------
      :doc "C-x hをよく忘れるので・・・・"
      :bind (("C-; e b"   . mark-whole-buffer)))

    (leaf *コードインデント---------------------------------------------------------------
      :doc "標準でキーバインド設定されているが、いつも忘れるので別で割り当てる"
      :bind (("C-; e i"   . indent-region)))

    (leaf *undoやredoを便利に-------------------------------------------------------------
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
        (("C-; e v"   . vundo))))

    (leaf *操作にハイライトを-------------------------------------------------------------
      :doc "yankやundoした際に編集箇所をわかりやすい様にハイライトを入れる"
      :config
      (leaf volatile-highlights
        :url "https://github.com/k-talo/volatile-highlights.el"
        :ensure t
        :config
        (volatile-highlights-mode t))
      )

    ) ; end of ファイル編集設定===========================================================


  (leaf *各種便利機能=====================================================================
    :config

    (leaf *キーバインド表示---------------------------------------------------------------
      :doc "!!!!今はwhich-keyを使っているけど、emacs30では機能が同梱されるとのこと!!!!"
      :config
      (leaf which-key
        :url "https://github.com/justbur/emacs-which-key"
        :ensure t
        :config
        (which-key-mode)
        (which-key-add-keymap-based-replacements
          global-map
          "C-; o"   "org-command-map"
          "C-; o C" "org-clock-command-map"
          "C-; a"   "affe-command-map"
          "C-; t"   "treemacs-command-map"
          "C-; m"   "minibuffer-command-map"
          "C-; v"   "view-command-map"
          "C-; s"   "search-command-map"
          "C-; e"   "edit-command-map"
          "C-; f"   "file-command-map"
          "C-; g"   "general-programming-map"
          "C-' l"   "lsp-command-map"
          "C-' t"   "lsp-treemacs-command-map")))

    (leaf *最近使ったファイル-------------------------------------------------------------
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

    (leaf *ripgrep使うよ------------------------------------------------------------------
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
        :bind (("C-; s r"   . rg))))

    (leaf *grepやfindを便利に-------------------------------------------------------------
      :config
      (leaf affe
        :doc "ripgrepやfdをfuzzyに利用する(ファイル多すぎるとエラーが出る気もしている)"
        :url "https://github.com/minad/affe"
        :ensure t
        :bind (("C-; a g"   . affe-grep)
               ("C-; a f"   . affe-find))))

    (leaf *ミニバッファで補完UI-----------------------------------------------------------
      :doc "Emacs28から標準添付されるfido-vertical-modeがあったりする"
      :doc "が、Tabでしゅっとしてくれなかったり、そもそも情報少ないのでverticoを用いる"
      :config
      (leaf vertico
        :url "https://github.com/minad/vertico"
        :ensure t
        :config
        ;; https://qiita.com/nobuyuki86/items/4150d5ec433e62757951 より
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

    (leaf *色々な局面で便利な補完を実行---------------------------------------------------
      :doc "consult.elを今まで適当にコピペ設定で使っていたが、ちゃんと設定していく"
      :doc "と、書いたけど、機能の多さに面食らっているので、一気にやらずに育てていくのが良いと思った"
      :config
      (leaf consult
        :url "https://github.com/minad/consult"
        :ensure t
        :bind (("C-s" . consult-line)                       ; 標準の置き換え（検索）
               ("C-x b" . consult-buffer)                   ; 標準の置き換え（バッファ切り替え）
               ("C-; g f" . consult-flymake)                ; flymakeエラー一覧
               ("C-; e p" . consult-yank-from-kill-ring)    ; killringから選んでyank
               )))

    (leaf *補完パネルに追加情報を表示-----------------------------------------------------
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

    (leaf *fuzzyにfindさせる--------------------------------------------------------------
      :doc "設定しているorderless-literalは、hogeを「*hoge*」としてfindしてくれる"
      :config
      (leaf orderless
        :url "https://github.com/oantolin/orderless"
        :ensure t
        :custom
        `((completion-styles . '(orderless))
          (orderless-matching-styles
           . '(orderless-literal)))))

    (leaf *特定ディレクトリ配下をプロジェクトとして扱う-----------------------------------
      :doc "treemacs君と組み合わせると、tree表示を良い感じにしてくれて便利"
      :doc "一方、設定次第ではパフォーマンスに影響があるので注意すること（↓参照）"
      :url "https://blog.tomoyukim.net/post/2022/08/19/084659/"
      :config
      (leaf projectile
        :url "https://github.com/bbatsov/projectile"
        :ensure t
        :custom (projectile-dynamic-mode-line . nil)
        :bind (:projectile-mode-map
               (("C-; p" . projectile-command-map)))
        :hook
        (after-init-hook . (lambda ()
                             (projectile-mode t)))
        ))

    (leaf *ツリービュー設定---------------------------------------------------------------
      :doc "NeoTreeとかもあるけど、他のプラグインと統合しやすそうなTreemacsを選択"
      :config
      (leaf treemacs
        :url "https://github.com/Alexander-Miller/treemacs"
        :ensure t
        :bind (("C-; t 0"   . treemacs-select-window)           ; treemacsのウィンドウにフォーカス
               ("C-; t 1"   . treemacs-delete-other-windows)    ; treemacsのウィンドウを残して全部クローズ
               ("C-; t t"   . treemacs)                         ; treemacsウィンドウをトグル
               ("C-; t d"   . treemacs-select-directory)        ; 特定のディレクトリを選択してルートノードに設定
               ("C-; t b"   . treemacs-bookmark)                ; ブックマークを選択して Treemacs ビュー内で展開
               ;; ("C-; t C-t" . treemacs-find-file)             ; 現在のバッファのファイルを Treemacs ビュー内で選択
               ;; ("C-; t M-t" . treemacs-find-tag)              ; 現在のバッファのファイル内のタグを Treemacs ビューで選択
               )
        :custom
        (treemacs-no-png-images . t)                    ; pngイメージを使わない
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

    (leaf *編集中にぺろんと補完するやつ---------------------------------------------------
      :doc "companyにお世話になっていたけど、令和はcorfu+capeらしいので試す"
      :doc "なお、標準ではCUIで動作しない（corfu-terminalが別途必要）。Emacs 31から動作するとのこと。先は長い・・・"
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
        ;; lsp-java起動したら、lsp-modeかlsp-javaかわからんけどcompany使おうとしているログ出てきたので潰す
        (with-eval-after-load 'lsp-mode (setq lsp-completion-provider :none))
        ))

    (leaf *アクション決めて対象選択ではなく、対象からアクションを実行する-----------------
      :config
      (leaf embark
        :url "https://github.com/oantolin/embark"
        :ensure t
        :bind (("C-; m a" . embark-act)
               ("C-; m e" . embark-export)
               ("C-; m d" . embark-dwim)
               ("C-; m h" . embark-bindings))
        :custom (prefix-help-command . #'embark-prefix-help-command) ;; Embarkを用いたキーバインドヘルプ改善
        :config
        ;; Embark のアクションや変換候補を、which-key を使って視覚的に表示する設定
        (setq embark-action-indicator
              (lambda (map _target)
                (which-key--show-keymap "Embark" map nil nil 'no-paging)
                #'which-key--hide-popup-ignore-command)
              embark-become-indicator embark-action-indicator))
      ;; embark-consultの導入
      (leaf embark-consult
        :ensure t
        :hook
        (embark-collect-mode . consult-preview-at-point-mode))
      )
    

    (leaf *構文チェック----------------------------------------------------------------
      :doc "flymakeかflycheckか悩んだけど、flymakeでいくことにした。どちらでも良さそうではある"
      :config
      (leaf flymake
        :hook
        ((prog-mode-hook . flymake-mode)) ; プログラミングモードで自動有効化
        :custom
        ((flymake-no-changes-timeout . 3.0)   ; 編集後のチェック開始までの待ち時間
         (flymake-start-on-save-buffer . t)   ; 保存時にもチェックを実行
         (flymake-start-on-flymake-mode . t)) ; flymake-mode 有効化時にすぐチェック
        :bind
        ("C-; g F" . flymake-mode)      ; flymake-modeのtoggle
        )
      )

    (leaf *git使うための諸々--------------------------------------------------------------
      :config
      (leaf magit
        :doc "git扱う時の定番"
        :url "https://github.com/magit/magit"
        :ensure t
        ;; 以下パフォーマンス改善の設定。see->https://misohena.jp/blog/2022-11-13-improve-magit-commiting-performance-on-windows.html
        :setq-default (magit-auto-revert-mode . nil)
        :bind ("C-; g g" . magit-status)) ; magit-statusで?キーを押すとコマンド一覧が出るので「迷ったらまず?」を覚えておくとよい とのこと
      (leaf forge
        :doc "GitHubのプルリクエストやissueの操作。Gitlabとかも対応しているぽい"
        :url "https://github.com/magit/forge"
        :ensure t
        :after magit
        :bind ("C-; g p" . forge-pull))) ; 操作自体は、magitで行う(forgeがmagitのサブモジュールなので)
    
    
    ) ; end of 各種便利機能===============================================================

  (leaf *メジャーモード設定===============================================================
    :config

    (leaf *今度こそorg-modeと仲良くなる---------------------------------------------------
      :config
      (leaf org
        :doc "org-mode設定"
        :url "https://git.savannah.gnu.org/cgit/emacs/org-mode.git/"
        :ensure t
        :preface
        (defun business-journal ()
          "お仕事用(見せちゃだめ)Journalエントリ"
          (interactive)
          (setq org-journal-dir "~/org/business/journal")
          (org-journal-new-entry t))
        (defun private-journal ()
          "プライベート(見せても良い)用Journalエントリ"
          (interactive)
          (setq org-journal-dir "~/org/public/journal")
          (org-journal-new-entry t))
        :bind (("C-; o l" . org-store-link)          ; カーソル位置でリンク（dired上などでも使える）
               ("C-; o L" . org-insert-link)         ; リンクの挿入（org-store-linkされたものもここから）
               ("C-; o o" . org-open-at-point)       ; リンクを開く
               ("C-; o a" . org-agenda)
               ("C-; o c" . org-capture)
               ("C-; o b" . business-journal)
               ("C-; o p" . private-journal)
               ("C-; o C i" . org-clock-in)
               ("C-; o C o" . org-clock-out)
               ("C-; o C d" . org-clock-display)
               ("C-; o C c" . org-clock-cancel)
               ("C-; o C r" . org-clock-report)
               )
        :custom ((org-agenda-files . '("~/org/"))
                 (org-capture-templates .'(("e" "Emacs Note" entry
                                            (file+headline "~/org/public/note/tech/emacs.org" "Emacsノート") "* %?\n:PROPERTIES:\n:CREATED:  %T\n:END:\n")
                                           ("v" "Vim Note" entry
                                            (file+headline "~/org/public/note/tech/vim.org" "Vimノート") "* %?\n:PROPERTIES:\n:CREATED:  %T\n:END:\n")
                                           ("t" "Temp Note" entry
                                            (file+headline "~/org/public/note/tech/tmp.org" "新しく思いついちゃった何か") "* %?\n:PROPERTIES:\n:CREATED:  %T\n:END:\n")
                                           ;; 随時追加していく
                                           )))
        :config
        ;; org-babelで使用できる言語を追加
        (org-babel-do-load-languages
         'org-babel-load-languages
         '((plantuml . t)
           (dot      . t)
           (gnuplot  . t)
           (latex    . t)
           (C        . t)
           (java     . t)
           (clojure  . t)
           (python   . t)
           (js       . t)
           (css      . t)
           (sql      . t)))
        ;; org-journalを利用する
        (leaf org-journal
          :doc "ジャーナル"
          :doc "org-journal-dirは、org設定のprefaceで実施"
          :url "https://github.com/bastibe/org-journal"
          :ensure t
          :custom
          (org-journal-file-type . 'monthly)
          (org-journal-date-format . "%Y-%m-%d, %A")
          (org-journal-time-format . "")
          (org-journal-file-format . "journal-%Y%m.org"))
        )
      )

    (leaf *lspモード----------------------------------------------------------------------
      :doc "eglot使いたいなと思いつつ、lsp-javaがlsp-mode前提ぽいのでlsp-modeで作っていく"
      :config
      (leaf lsp-mode
        :doc "LSPクライアント本体"
        :url "https://github.com/emacs-lsp/lsp-mode"
        :ensure t
        :custom (lsp-keymap-prefix . "C-' l")
        :hook ((java-mode-hook . lsp)
               (lsp-mode-hook . lsp-enable-which-key-integration)))
      (leaf lsp-ui
        :doc "ハイレベルなUIを提供してくれるらしい。が、まだちゃんとわかってない"
        :doc "https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf#emacs26の機能をフル活用したモダンなui----lsp-ui を参考にすると良いかもしれない"
        :url "https://github.com/emacs-lsp/lsp-ui"
        :ensure t
        :hook ((lsp-mode-hook . lsp-ui-mode)))
      (leaf lsp-treemacs
        :doc "treemacsを使ってシンボル一覧を出したり階層出したり色々やる"
        :url "https://github.com/emacs-lsp/lsp-treemacs"
        :ensure t
        :config (lsp-treemacs-sync-mode 1)
        :bind (:lsp-mode-map (("C-' t e" . lsp-treemacs-errors-list)        ; エラー一覧
                              ("C-' t s" . lsp-treemacs-symbols)            ; シンボル一覧
                              ("C-' t r" . lsp-treemacs-references)         ; リファレンス一覧
                              ("C-' t i" . lsp-treemacs-implementations)    ; 実装箇所一覧
                              ("C-' t h" . lsp-treemacs-call-hierarchy)     ; 呼び出し階層
                              ("C-' t d" . lsp-treemacs-java-deps-follow)   ; 依存関係の表示
                              ("C-' t d" . lsp-treemacs-java-deps-refresh)  ; 依存関係Viewのリフレッシュ
                              )))
      (leaf lsp-java
        :doc "JavaなLSP"
        :url "https://github.com/emacs-lsp/lsp-java"
        :custom (lsp-java-jdt-download-url . "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz")
        :ensure t)
      )
    
    ) ; end of 特定言語やメジャーモード設定===============================================

  )

(provide 'init)
