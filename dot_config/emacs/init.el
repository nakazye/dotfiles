;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:
;;; Emacs Startup File

;;; --- キーバインド設定における個人的方針 ---
;;; * モード問わず利用するものは、C-;からのコンビネーションで設定する

;;; code:

;;; ======================================================================================

(leaf *init*
  :config

  (leaf *一般設定=========================================================================
    :config

    (leaf *言語設定-----------------------------------------------------------------------
      :doc "Emacsが扱う文字コードの設定"
      :config
      (set-language-environment "Japanese")
      (prefer-coding-system  'utf-8-unix))

    (leaf *日本語入力設定-----------------------------------------------------------------
      :config
      (leaf mozc
        :ensure t
        :require t
        :doc "mozcとの接続設定（GUIかつLinuxの時）"
        :when window-system
        :when (eq system-type 'gnu/linux)
        :bind (("C-SPC"   . toggle-input-method))
        :custom (default-input-method . "japanese-mozc"))
      )

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

    (leaf *拡張子の大文字小文字を無視------------------------------------------------------
      :doc "auto-mode-alistのマッチングで.PDFと.pdfを同一視する"
      :custom (auto-mode-case-fold . t))

    (leaf *バッファ境界の表示--------------------------------------------------------------
      :doc "fringeにバッファの先頭・末尾を矢印で表示"
      :custom (indicate-buffer-boundaries . 'left))

    (leaf *バックアップファイルをよしなに設定---------------------------------------------
      :url "http://yohshiy.blog.fc2.com/blog-entry-319.html"
      :doc "バックアップファイルにどんな種類があるかについては↑がわかりやすい"
      :doc "ここでは、以下の設定にしている"
      :doc "* バックアップファイル (foo.txt~) → 作る。var/backup/に配置する（no-littering-theme-backups）"
      :doc "* 自動保存ファイル (#foo.txt#) → 作る(正常終了すれば消えるファイル)。var/auto-save/に配置する（no-littering-theme-backups）"
      :doc "* 自動保存リストファイル → var/auto-save/sessions/に配置する（no-littering）"
      :doc "* ロックファイル (.#foo.txt)→作らない"
      :custom
      ;; バックアップファイル設定
      (make-backup-files . t)
      ;; 自動保存ファイル設定
      (auto-save-default . t)
      ;; ロックファイル設定
      (create-lockfiles . nil))

    (leaf *ファイルをデフォルトで読み取り専用で開く---------------------------------------
      :doc "view-modeで開く。編集したい場合はeまたはC-x C-qで切り替え"
      :doc "qでバッファを閉じる"
      :hook (find-file-hook . view-mode))

    (leaf *勝手にできるファイルを散らかさない---------------------------------------------
      :doc "勝手に作られる設定ファイルやキャッシュを良い感じにまとめてくれる"
      :config
      (leaf no-littering
        :url "https://github.com/emacscollective/no-littering"
        :ensure t
        :require t
        :custom
        (no-littering-etc-directory . "~/.config/emacs/etc/")
        (no-littering-var-directory . "~/.config/emacs/var/")
        :config
        ;; バックアップ・自動保存ファイルをvar/配下に配置
        (no-littering-theme-backups)
        ;; カスタムテーマディレクトリをetc/配下に配置
        (setq custom-theme-directory (no-littering-expand-etc-file-name "themes/"))
        (make-directory custom-theme-directory t)))

    (leaf *自動revert設定-----------------------------------------------------------------
      :doc "他でファイル変更があった際の再読み込み"
      :custom (auto-revert-interval . 1)
      :global-minor-mode global-auto-revert-mode)

    (leaf *ファイル削除をゴミ箱移動に-----------------------------------------------------
      :custom (delete-by-moving-to-trash . t))

    (leaf *カレントディレクトリの変更-----------------------------------------------------
      :config (cd "~/"))

    (leaf *MacでGUI起動時に環境変数読んでくれない問題 ------------------------------------
      :doc "MacでGUIな時に環境変数読むよ"
      :when window-system
      :when (eq system-type 'darwin)
      :config
      (leaf exec-path-from-shell
        :ensure t
        :defun (exec-path-from-shell-initialize)
        :custom
        ((exec-path-from-shell-check-startup-files . nil)
         (exec-path-from-shell-arguments . nil)
         (exec-path-from-shell-variables
          . '(
              "PATH"
              "SHELL"
              )))
        :config
        (exec-path-from-shell-initialize)))

    (leaf *direnvを使える様にする -------------------------------------------------------
      :config
      (leaf envrc
        :doc "emacs-direnvの後継"
        :url "https://github.com/purcell/envrc"
        :ensure t
        :hook (after-init-hook . envrc-global-mode))
      )

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
    ;;
    ;; 罫線確認（等幅になっていればOK）
    ;; ----------------------------------------
    ;; |abc|def|
    ;; |---|---|
    ;; |123|456|
    ;; ┌──┬──┐
    ;; │ab│cd│
    ;; └──┴──┘
    :config

    (leaf *罫線文字を半角幅として扱う-----------------------------------------------------
      :doc "Box Drawing文字(U+2500-257F)がGUIで全角幅になる問題を修正"
      :doc "これがないとMarkdownやorg-modeの表がガタガタになる"
      :config
      (dolist (char (number-sequence #x2500 #x257F))
        (aset char-width-table char 1)))

    (leaf *曖昧幅文字を全角として扱う-------------------------------------------------------
      :doc "vterm上でClaude Codeなどの特殊Unicode文字がガタガタになる問題を修正"
      :doc "半角にしても改善しない場合は nil に戻す"
      :custom (cjk-ambiguous-chars-are-wide . t))

    (leaf *日本語の表示に中華フォントが混ざるのを防ぐ-------------------------------------
      :doc "なんかmacで表示がガタガタするなと思ったら、漢字が中華フォントになっていたので設定"
      :config (set-language-environment "Japanese"))

    (leaf *絵文字のサイズを設定-----------------------------------------------------------
      :doc "Noto Emoji（モノクロ版）を使用。サイズ調整が効くので幅・高さが崩れにくい"
      :config
      ;; 絵文字範囲にNoto Emojiを設定（フォールバックとしてApple Color Emoji/Segoe UI Emoji）
      (let ((emoji-font (cond
                         ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
                         ((eq system-type 'darwin) "Apple Color Emoji")
                         ((eq system-type 'windows-nt) "Segoe UI Emoji")
                         (t nil))))
        (when emoji-font
          ;; 絵文字 (Emoji範囲)
          (set-fontset-font t '(#x1F300 . #x1FFFD)
                            (font-spec :family emoji-font :size 18) nil 'prepend)
          ;; Miscellaneous Symbols
          (set-fontset-font t '(#x2600 . #x26FF)
                            (font-spec :family emoji-font :size 18) nil 'prepend)
          ;; Dingbats
          (set-fontset-font t '(#x2700 . #x27BF)
                            (font-spec :family emoji-font :size 18) nil 'prepend)
          ;; Emoticons
          (set-fontset-font t '(#x1F600 . #x1F64F)
                            (font-spec :family emoji-font :size 18) nil 'prepend)
          ;; Miscellaneous Symbols and Pictographs
          (set-fontset-font t '(#x1F300 . #x1F5FF)
                            (font-spec :family emoji-font :size 18) nil 'prepend))))

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
      :config
      (leaf solarized-theme
        :url "https://github.com/bbatsov/solarized-emacs"
        :ensure t
        :require t
        :custom
        ;; テーマファイルをetc/themes/に保存
        (solarized-theme-dir . "~/.config/emacs/etc/themes/")
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

    (leaf *tree-sitter使うよ--------------------------------------------------------------
      :config
      (leaf tree-sitter
        :doc "tree-sitterそのもの"
        :ensure t
        :hook ((typescript-ts-mode . tree-sitter-hl-mode)
               (tsx-ts-mode . tree-sitter-hl-mode))
        :config
        (global-tree-sitter-mode))
      (leaf treesit
        :doc "諸々設定"
        :config
        ;;; ハイライトレベルの設定Max(4)
        (setq treesit-font-lock-level 4)
        :custom
        ;;; 構文定義ファイル
        (treesit-language-source-alist
         . '(
             ;; 公式
             (bash "https://github.com/tree-sitter/tree-sitter-bash")
             (c "https://github.com/tree-sitter/tree-sitter-c")
             (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
             (css "https://github.com/tree-sitter/tree-sitter-css")
             (html "https://github.com/tree-sitter/tree-sitter-html")
             (java "https://github.com/tree-sitter/tree-sitter-java")
             (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
             (json "https://github.com/tree-sitter/tree-sitter-json")
             (nix "https://github.com/nix-community/tree-sitter-nix")
             (python "https://github.com/tree-sitter/tree-sitter-python")
             (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
             (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
             ;; 3rd party
             (make "https://github.com/alemuller/tree-sitter-make")
             (yaml "https://github.com/ikatyang/tree-sitter-yaml")
             ))
        :init
        (mapc (lambda (lang)
                (unless (treesit-language-available-p lang nil)
                  (treesit-install-language-grammar lang)))
              (mapcar #'car treesit-language-source-alist))
        ))

    (leaf *ウィンドウ操作を便利に --------------------------------------------------------
      :config
      (leaf ace-window
        :url "https://github.com/abo-abo/ace-window"
        :ensure t
        :config
        (with-eval-after-load 'ace-window
          (ace-window-posframe-mode t)
          ;; treemacsがaw-ignored-buffersにtreemacs-modeを追加するのを取り消す
          ;; treemacs-compatibilityがace-window読み込み後に追加するので、
          ;; ace-window実行前に毎回削除する
          (defun my/ace-window-include-treemacs (&rest _)
            "Remove treemacs-mode from aw-ignored-buffers."
            (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))
          (advice-add 'ace-window :before #'my/ace-window-include-treemacs)))
      (leaf *ace-window-keybinds
        :bind (("C-; w w" . ace-window))))

      (leaf *ウィンドウサイズ変更-------------------------------------------------------------
        :doc "hydraを使ってウィンドウサイズを簡単に変更する"
        :config
        (leaf hydra
          :ensure t
          :config
          (defhydra hydra-window-resize (:hint nil)
            "
ウィンドウサイズ: _h_:←  _l_:→  _k_:↑  _j_:↓  _=_:均等  _q_:終了
"
            ("h" shrink-window-horizontally)
            ("l" enlarge-window-horizontally)
            ("k" shrink-window)
            ("j" enlarge-window)
            ("=" balance-windows)
            ("q" nil :exit t)))
        (leaf *hydra-keybinds
          :bind (("C-; w r" . hydra-window-resize/body))))

    ) ; end of 一般表示系設定=============================================================

  (leaf *モードライン設定=================================================================
    :config

    (leaf *モードラインを作るぞ！---------------------------------------------------
      :doc "doom-modelineを導入して、自分好みのモードラインを作るぞ"
      :config
      (leaf doom-modeline
        :ensure t
        :hook (after-init-hook . doom-modeline-mode)
        :custom-face
        ;; 下線が引かれるのを消す
        (mode-line . '((t (:underline nil))))
        (mode-line-inactive . '((t (:underline nil))))
        :config
        (column-number-mode t) ;; 列番号表示(doom-modelineの設定ではないけど、ここであわせて設定)
        :custom
        (doom-modeline-height . 20)             ;; モードラインの高さを設定します（ピクセル単位）
        (doom-modeline-minor-modes . nil)       ;; モードラインにマイナーモードを表示するかどうか
        (doom-modeline-vcs-max-length . 12)     ;; バージョン管理システム（VCS）のブランチ名の最大長
        (doom-modeline-indent-info . t)         ;; 現在のインデント情報を表示するかどうか。
        (doom-modeline-total-line-number . t)   ;; 総行数を表示する (例: L:100/250)
        (doom-modeline-position-column-line-format . '("C:%c L:%l")) ;; 列番号＆行番号の表示フォーマット (総行数は行の後ろに追加される)
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

    (leaf *便利機能キーバインド-----------------------------------------------------------
      :doc "Benriカテゴリとしてまとめる"
      :config
      (leaf *benri-keybinds
        :bind (("C-; e w" . delete-trailing-whitespace)  ; 行末空白削除
               ("C-; e t" . untabify))))                 ; タブをスペースに変換



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
        ((vundo-compact-display . t))) ; ツリーをコンパクトに表示
      (leaf *vundo-keybinds
        :bind (("C-; e u" . vundo))))

    (leaf *操作にハイライトを-------------------------------------------------------------
      :doc "yankやundoした際に編集箇所をわかりやすい様にハイライトを入れる"
      :config
      (leaf volatile-highlights
        :url "https://github.com/k-talo/volatile-highlights.el"
        :ensure t
        :config
        (volatile-highlights-mode t))
      )

    (leaf *括弧やS式の構造化編集-----------------------------------------------------------
      :doc "puniで構造を壊さない編集を実現する"
      :doc "構造を壊して強制削除したい場合は C-c DEL (puni-force-delete)"
      :doc "  - リージョン選択中: リージョン全体を強制削除"
      :doc "  - リージョンなし: 後方1文字を強制削除"
      :doc "  - kill-ringには入らないので注意"
      :config
      (leaf puni
        :url "https://github.com/AmaiKinono/puni"
        :doc "=== デフォルトキーマップ（puni-mode有効時に自動設定）==="
        :doc "C-d       : puni-forward-delete-char   (構造を壊さず1文字削除)"
        :doc "DEL       : puni-backward-delete-char  (構造を壊さず後方1文字削除)"
        :doc "M-d       : puni-forward-kill-word     (構造を壊さず単語kill)"
        :doc "M-DEL     : puni-backward-kill-word    (構造を壊さず後方単語kill)"
        :doc "C-k       : puni-kill-line             (構造を壊さず行kill)"
        :doc "C-S-k     : puni-backward-kill-line    (構造を壊さず後方行kill)"
        :doc "C-w       : puni-kill-active-region    (構造を壊さずリージョンkill)"
        :doc "C-c DEL   : puni-force-delete          (強制削除：構造を無視して削除)"
        :doc "C-M-f     : puni-forward-sexp          (次のS式へ移動)"
        :doc "C-M-b     : puni-backward-sexp         (前のS式へ移動)"
        :doc "C-M-a     : puni-beginning-of-sexp     (S式の先頭へ)"
        :doc "C-M-e     : puni-end-of-sexp           (S式の末尾へ)"
        :doc "M-(       : puni-syntactic-forward-punct  (次の括弧へ)"
        :doc "M-)       : puni-syntactic-backward-punct (前の括弧へ)"
        :ensure t
        :global-minor-mode puni-global-mode
        :config
        ;; C-; p でpuni用hydraを起動
        (defhydra hydra-puni (:hint nil)
          "
puni: _m_:S式選択 _l_:括弧内選択 _M_:括弧含め選択 _e_:範囲拡張
      _(_:() _[_:[] _{_:{} _<_:<>
      _p_:括弧削除 _s_:slurp _b_:barf  _q_:終了
"
          ;; 選択
          ("m" puni-mark-sexp-at-point)
          ("l" puni-mark-list-around-point)
          ("M" puni-mark-sexp-around-point)
          ("e" puni-expand-region)
          ;; 括弧制御
          ("(" puni-wrap-round)
          ("[" puni-wrap-square)
          ("{" puni-wrap-curly)
          ("<" puni-wrap-angle)
          ("p" puni-splice)
          ;; Slurp Barf
          ("s" puni-slurp-forward)
          ("b" puni-barf-forward)
          ("q" nil :exit t)))
      ;; C-; p にhydra-puniをバインド
      (leaf *puni-keybind
        :bind (("C-; p" . hydra-puni/body))))

    (leaf *vimライク移動hydra----------------------------------------------------------------
      :doc "C-; v でVimライクな移動に"
      :after hydra
      :config
      (defhydra hydra-vim-motion (:hint nil :foreign-keys run)
        "
 Vim Motion
┌──────────────────┬───────────────────────────┐
│ カーソル移動     │ 単語移動                  │
│     _k_            │                           │
│     ↑            │ _b_ <- word -> _w_            │
│ _h_ <   > _l_        │       |                   │
│     ↓            │      _e_(末尾)              │
│     _j_            │                           │
├──────────────────┴───────────────────────────┤
│ 行内移動                                     │
│ _0_──────────────_^_──────────────────────_$_      │
│ 行頭        非空白先頭                行末   │
├──────────────────┬───────────────────────────┤
│ バッファ         │ ジャンプ                  │
│ _g__g_ : 先頭(gg)    │ _f_ : 文字(avy)             │
│ _G_  : 末尾        │ _/_ : 検索 (consult-line)   │
│ _C-u_: 半画面↑     │                           │
│ _C-d_: 半画面↓     │                           │
└──────────────────┴───────────────────────────┘
                                       _q_: 終了
"
        ;; 基本移動
        ("h" backward-char)
        ("j" next-line)
        ("k" previous-line)
        ("l" forward-char)
        ;; 単語移動
        ("w" forward-word)
        ("e" (progn (forward-word) (backward-char)))
        ("b" backward-word)
        ;; 行内移動
        ("0" move-beginning-of-line)
        ("$" move-end-of-line)
        ("^" back-to-indentation)
        ;; バッファ移動 (gg対応)
        ("g" beginning-of-buffer)
        ("G" end-of-buffer)
        ;; スクロール (半画面)
        ("C-u" (scroll-down (/ (window-height) 2)))
        ("C-d" (scroll-up (/ (window-height) 2)))
        ;; 検索・ジャンプ
        ("f" avy-goto-char)
        ("/" consult-line)
        ("q" nil :exit t))

      :bind (("C-; v" . hydra-vim-motion/body)))

    ) ; end of 括弧やS式の構造化編集

    ) ; end of ファイル編集設定===========================================================


  (leaf *各種便利機能=====================================================================
    :config

    (leaf *キーバインド表示---------------------------------------------------------------
      :config
      (leaf which-key
        :url "https://github.com/justbur/emacs-which-key"
        :ensure t
        :config
        (which-key-mode)
        ;; C-;リーダーキー用
        (which-key-add-key-based-replacements
          "C-; a"   "AI"
          "C-; a c" "Claude Code IDE"
          "C-; e"   "Edit"
          "C-; d"   "Dev"
          "C-; d u" "Dev UI"
          "C-; d d" "DAP"
          "C-; d t" "Tool"
          "C-; j"   "Jump"
          "C-; o"   "Org"
          "C-; o C" "Org Clock"
          "C-; p"   "Puni"
          "C-; P"   "Project"
          "C-; s"   "Search/Navigation"
          "C-; v"   "Vim Motion"
          "C-; w"   "Window"
          "C-; w r" "window resize")))

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
           "~/.config/emacs/var/"
           "~/.config/emacs/etc/"
           "*.png"
           "*.jpeg"
           ".org_archive"
           "COMMIT_EDITMSG\\'")))

    (leaf *diredでバッファが増殖しないようにする------------------------------------------
      :doc "ディレクトリ移動時に新しいバッファを作らず、既存のバッファを再利用する"
      :doc "Emacs 28以降は組み込みの変数で対応可能（dired-singleは廃止された）"
      :config
      (leaf dired
        :custom
        (dired-kill-when-opening-new-dired-buffer . t)))

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
        :bind (;; 標準コマンドの置き換え
               ("C-s" . consult-line)                       ; isearch-forward → バッファ内検索
               ("C-x b" . consult-buffer)                   ; switch-to-buffer → バッファ切替
               ("C-x 4 b" . consult-buffer-other-window)    ; 別ウィンドウでバッファ切替
               ("C-x 5 b" . consult-buffer-other-frame)     ; 別フレームでバッファ切替
               ("C-x p b" . consult-project-buffer)         ; プロジェクト内バッファ切替
               ("C-x r b" . consult-bookmark)               ; bookmark-jump → ブックマーク
               ([remap yank-pop] . consult-yank-pop)        ; M-y: kill-ringをプレビュー選択
               ([remap goto-line] . consult-goto-line)))    ; M-g g: 行番号プレビュー
      (leaf *consult-keybinds
        :bind (;; ナビゲーション
               ("C-; s i" . consult-imenu)              ; 関数・見出し等へジャンプ
               ("C-; s o" . consult-outline)            ; アウトラインへジャンプ
               ("C-; s m" . consult-mark)               ; マーク履歴へジャンプ
               ("C-; s k" . consult-global-mark)        ; グローバルマーク履歴へジャンプ
               ;; 検索
               ("C-; s g" . consult-ripgrep)            ; grepでファイル内容検索
               ("C-; s d" . consult-fd)                 ; fdでファイル名検索
               ;; カスタム
               ("C-; s f" . consult-flymake)            ; flymakeエラー一覧
               ("C-; s y" . consult-yank-from-kill-ring)))) ; killringから選んでyank

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
        :custom
        (projectile-dynamic-mode-line . nil)
        (projectile-switch-project-action . #'projectile-dired)
        :hook
        (after-init-hook . (lambda ()
                             (projectile-mode t))))
      ;; projectile用hydra（厳選コマンド）
      (leaf *projectile-keybinds
        :after hydra
        :config
        (defhydra hydra-projectile (:hint nil :exit t)
          "
 基本操作
   _p_ プロジェクト切り替え   _f_ ファイル検索   _b_ バッファ切り替え
   _D_ dired                  _k_ バッファ全削除 _i_ キャッシュ無効化

 検索系
   _s_ ripgrep検索            _r_ 置換

 テスト/ビルド
   _t_ テスト⇔実装切り替え

 その他
   _v_ バージョン管理(magit等)  _!_ シェルコマンド  _q_ 終了
"
          ("p" projectile-switch-project)
          ("f" projectile-find-file)
          ("b" projectile-switch-to-buffer)
          ("D" projectile-dired)
          ("k" projectile-kill-buffers)
          ("i" projectile-invalidate-cache)
          ("s" projectile-ripgrep)
          ("r" projectile-replace)
          ("t" projectile-toggle-between-implementation-and-test)
          ("v" projectile-vc)
          ("!" projectile-run-shell-command-in-root)
          ("q" nil))
        ;; which-keyで関数名をわかりやすく表示
        (push '((nil . "hydra-projectile/body") . (nil . "Project"))
              which-key-replacement-alist)
        :bind (("C-; P" . hydra-projectile/body))))

    (leaf *ツリービュー設定---------------------------------------------------------------
      :doc "NeoTreeとかもあるけど、他のプラグインと統合しやすそうなTreemacsを選択"
      :config
      (leaf treemacs
        :url "https://github.com/Alexander-Miller/treemacs"
        :ensure t
        :custom
        (treemacs-no-png-images . t)                    ; pngイメージを使わない
                                        ; TODO cliではエラー出るので分岐入れたい
        (treemacs-text-scale . -1)                      ; テキストサイズが大きいのを小さく
        :config
        (treemacs-follow-mode t)                        ; 追従させる
        (treemacs-project-follow-mode t)                ; projectileと連動
        (treemacs-filewatch-mode t)                     ; 外部でファイルが増えたり減ったり名前変わっても反映
        (treemacs-fringe-indicator-mode 'always)        ; 選択されてるインジケーターを常に表示
        (treemacs-hide-gitignored-files-mode nil)       ; gitignore指定されていても表示
        :hook
        (treemacs-mode-hook . (lambda() (display-line-numbers-mode 0)))
        )
      (leaf treemacs-nerd-icons
        :url "https://github.com/rainstormstudio/treemacs-nerd-icons"
        :ensure t
        :after treemacs
        :require t
        :config (treemacs-load-theme "nerd-icons"))
      )

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
               ("C-[" . corfu-quit)        ; C-[で補完キャンセル
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
        :bind (("C-." . embark-act))
               ;; ("C-," . embark-dwim) ; embark-act → RET でデフォルトアクション実行と同じ
               ;; embark-export は C-. → E、embark-bindings は C-h が embark形式になっているので専用キー不要
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

    (leaf *ediff設定----------------------------------------------------------------------
      :doc "ediffを1フレーム内で左右分割表示にする（デフォルトの複数フレーム表示を避ける）"
      :custom (ediff-window-setup-function . 'ediff-setup-windows-plain))

    (leaf *構文チェック-------------------------------------------------------------------
      :doc "flymakeかflycheckか悩んだけど、flymakeでいくことにした。どちらでも良さそうではある"
      :config
      (leaf flymake
        :hook
        ((prog-mode-hook . flymake-mode)) ; プログラミングモードで自動有効化
        :custom
        ((flymake-no-changes-timeout . 3.0)   ; 編集後のチェック開始までの待ち時間
         (flymake-start-on-save-buffer . t)   ; 保存時にもチェックを実行
         (flymake-start-on-flymake-mode . t)) ; flymake-mode 有効化時にすぐチェック
)
      )

    (leaf *git使うための諸々--------------------------------------------------------------
      :config
      (leaf magit
        :doc "git扱う時の定番"
        :doc "magit-statusで?キーを押すとコマンド一覧が出るので「迷ったらまず?」を覚えておくとよい とのこと"
        :url "https://github.com/magit/magit"
        :ensure t
        ;; 以下パフォーマンス改善の設定。see->https://misohena.jp/blog/2022-11-13-improve-magit-commiting-performance-on-windows.html
        :setq-default (magit-auto-revert-mode . nil)
        :preface
        (defun my/magit ()
          "magitを開く。vtermの場合はシェルのカレントディレクトリで開く"
          (interactive)
          (if (and (eq major-mode 'vterm-mode) (bound-and-true-p vterm--process))
              ;; vterm: シェルのカレントディレクトリを取得してmagitを開く
              (let* ((pid (process-id vterm--process))
                     (dir (cond
                           ;; Linux: /procからcwdを取得 (未検証)
                           ((eq system-type 'gnu/linux)
                            (file-truename (format "/proc/%d/cwd" pid)))
                           ;; macOS: lsofでcwd取得し、awkでPIDフィルタリング
                           ((eq system-type 'darwin)
                            (string-trim
                             (shell-command-to-string
                              (format "lsof -d cwd 2>/dev/null | awk -v pid=%d '$2 == pid {print $NF}'" pid)))))))
                (magit-status dir))
            ;; vterm以外: 通常のmagit-status
            (magit-status)))
)
      (leaf *magit-keybinds
        :bind (("C-; d t g" . my/magit)))
      (leaf forge
        :doc "GitHubのプルリクエストやissueの操作。Gitlabとかも対応しているぽい"
        :url "https://github.com/magit/forge"
        :ensure t
        :after magit)
      ;; forge操作自体はmagitで行う(forgeがmagitのサブモジュールなので)
      (leaf *forge-keybinds
        :after forge
        :bind (("C-; d t f" . forge-pull)))
      (leaf git-gutter
        :doc "gitの差分表示"
        :url ""
        :ensure t
        :global-minor-mode global-git-gutter-mode))

    (leaf *Claude Code統合----------------------------------------------------------------
      :doc "EmacsからClaude Codeを使えるようにする"
      :config
      (leaf claude-code-ide
        :url "https://github.com/manzaltu/claude-code-ide.el"
        :doc "Claude Code IDE integration for Emacs with MCP"
        :vc (:url "https://github.com/manzaltu/claude-code-ide.el")
        :commands (claude-code-ide claude-code-ide-menu claude-code-ide-send-region claude-code-ide-fix-error)
        :config
        (claude-code-ide-emacs-tools-setup))
      (leaf *claude-code-keybinds
        :doc ":commandsによる遅延ロードだと:config内が実行されないため、キーバインドは別ブロックで定義"
        :bind (("C-; a c i" . claude-code-ide)
               ("C-; a c m" . claude-code-ide-menu)
               ("C-; a c s" . claude-code-ide-send-region)
               ("C-; a c f" . claude-code-ide-fix-error))))

    (leaf *ジャンプ操作を便利に -----------------------------------------------------------
      :config
      (leaf avy
        :url "https://github.com/abo-abo/avy"
        :ensure t
        :custom (avy-timeout-seconds . 0.5))
      ;; avyジャンプ
      (leaf *avy-keybinds
        :bind (("C-; j w" . avy-goto-word-1)  ; 単語ジャンプ
               ("C-; j f" . avy-goto-char)    ; 文字検索
               ("C-; j j" . avy-goto-line)))) ; 行ジャンプ

    (leaf *バッファとウィンドウを閉じる---------------------------------------------------
      :doc "標準関数だがC-;リーダーに追加"
      :config
      (leaf *kill-buffer-and-window-keybinds
        :bind (("C-; w q" . kill-buffer-and-window))))

    ) ; end of 各種便利機能===============================================================

  (leaf *メジャーモード設定===============================================================
    :config

    (leaf *Emacsでterminalを使うぞ--------------------------------------------------------
      :config
      (leaf vterm
        :doc "wsl上だと日本語が入力できなかったり出力おかしかったりするけど、でも最低限使えるので良いかなと"
        :url "https://github.com/akermu/emacs-libvterm"
        :ensure t
        :custom
        (vterm-max-scrollbacck . 100000)
        (vterm-buffer-name-string . "vterm: %s")
        :hook
        (vterm-mode-hook . (lambda()
                             (display-line-numbers-mode 0)
                             ;; vtermは読み取り専用バッファなので編集系モードを無効化
                             (volatile-highlights-mode -1)
                             (puni-disable-puni-mode)
                             ;; C-hをバックスペースとしてターミナルに送信
                             (define-key vterm-mode-map (kbd "C-h") #'vterm-send-C-h))))
      (leaf vterm-toggle
        :ensure t)
      (leaf *vterm-keybinds
        :bind (("C-; d t v" . vterm-toggle)))
      )


    (leaf *今度こそorg-modeと仲良くなる---------------------------------------------------
      :config
      ;; 新規orgファイル作成時にヘッダを自動挿入
      (leaf *org-auto-insert
        :doc "auto-insert-modeを使って新規orgファイルにヘッダテンプレートを挿入"
        :doc "--- OPTIONS設定 ---"
        :doc "toc:t     → 目次を生成する"
        :doc "num:t     → 見出しに番号を付ける"
        :doc "^:nil     → _ や ^ を上付き・下付き文字として解釈しない（ファイル名等が崩れるのを防ぐ）"
        :doc "--- PROPERTY設定 ---"
        :doc ":exports both    → org-babelでコードと結果の両方をエクスポート"
        :doc ":eval no-export  → エクスポート時はコードを実行しない（安全性のため）"
        :doc "--- STARTUP設定 ---"
        :doc "showall   → ファイルを開いた時にすべて展開"
        :doc "indent    → 見出しレベルに応じてインデント表示"
        :config
        (auto-insert-mode t)
        (setq auto-insert-query nil)  ; 挿入確認を省略
        (define-auto-insert
          '("\\.org\\'" . "Org-mode file")
          '(nil
            "#+TITLE: " (file-name-base (buffer-file-name)) "\n"
            "#+LANGUAGE: ja\n"
            "#+OPTIONS: toc:t num:t ^:nil\n"
            "#+PROPERTY: header-args :exports both :eval no-export\n"
            "#+STARTUP: showall indent\n"
            "\n")))

      (leaf org
        :doc "org-mode設定"
        :url "https://git.savannah.gnu.org/cgit/emacs/org-mode.git/"
        :ensure t
        :preface
        (defun business-journal ()
          "お仕事用(見せちゃだめ)Journalエントリ"
          (interactive)
          (setq org-journal-dir "~/note/business/journal")
          (org-journal-new-entry t))
        (defun private-journal ()
          "プライベート(見せても良い)用Journalエントリ"
          (interactive)
          (setq org-journal-dir "~/note/public/journal")
          (org-journal-new-entry t))
        :preface
        (defun my/org-journal-find-location ()
          "org-captureからbusiness journalの今日のエントリにキャプチャする"
          (setq org-journal-dir "~/note/business/journal")
          (org-journal-new-entry t)
          (goto-char (point-max)))
        :custom ((org-todo-keywords . '((sequence "TODO(t)" "DOING(d)" "WAITING(w)" "|" "DONE(D)" "CANCELED(C)")))
                 (org-todo-keyword-faces . '(("TODO"     . warning)
                                             ("DOING"    . success)
                                             ("WAITING"  . font-lock-constant-face)
                                             ("DONE"     . org-done)
                                             ("CANCELED" . shadow)))
                 (org-agenda-files . '("~/note/business/journal"
                                       "~/note/public/journal"))
                 (org-capture-templates
                  . '(("t" "TODO" plain (function my/org-journal-find-location)
                       "** TODO [#B] %?")
                      ("m" "MEMO" plain (function my/org-journal-find-location)
                       "** MEMO %?")
                      ("M" "MTG" plain (function my/org-journal-find-location)
                       "** MTG %?\n   出席者: %^{出席者}\n   開始: %^T\n   終了: %^T\n   - %a"))))
        :preface
        ;; org-babelの言語設定を一度だけ遅延ロード
        (defvar my/org-babel-loaded nil)
        (defun my/org-babel-load-languages ()
          (unless my/org-babel-loaded
            (org-babel-do-load-languages
             'org-babel-load-languages
             '((shell    . t)
               (plantuml . t)
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
            (setq my/org-babel-loaded t)))
        :hook (org-mode-hook . my/org-babel-load-languages)
        :config
        ;; org-journalを利用する
        (leaf org-journal
          :doc "ジャーナル"
          :doc "org-journal-dirは、org設定のprefaceで実施"
          :url "https://github.com/bastibe/org-journal"
          :doc "--- ヘッダテンプレートの設定内容 ---"
          :doc "show2levels → 日付(L1)と見出し(L2)まで表示、本文は畳む"
          :doc "その他の設定は *org-auto-insert を参照"
          :ensure t
          :custom
          (org-journal-file-type . 'monthly)
          (org-journal-date-format . "%Y-%m-%d, %A")
          (org-journal-time-format . "")
          (org-journal-file-format . "journal-%Y%m.org")
          ;; 新規ジャーナルファイル作成時のヘッダテンプレート
          (org-journal-file-header . "#+TITLE: Journal %Y-%m\n#+LANGUAGE: ja\n#+OPTIONS: toc:t num:t ^:nil\n#+PROPERTY: header-args :exports both :eval no-export\n#+STARTUP: show2levels indent\n\n"))
        )
      (leaf *org-keybinds
        :bind (("C-; o l" . org-store-link)
               ("C-; o L" . org-insert-link)
               ("C-; o i" . org-insert-structure-template)
               ("C-; o s" . org-edit-special)
               ("C-; o o" . org-open-at-point)
               ("C-; o a" . org-agenda)
               ("C-; o c" . org-capture)
               ("C-; o b" . business-journal)
               ("C-; o p" . private-journal)
               ("C-; o C i" . org-clock-in)
               ("C-; o C o" . org-clock-out)
               ("C-; o C d" . org-clock-display)
               ("C-; o C c" . org-clock-cancel)
               ("C-; o C r" . org-clock-report)))
      )

    (leaf *Markdownを扱うよ----------------------------------------------------------------
      :config
      (leaf markdown-mode
        :url "https://github.com/jrblevin/markdown-mode"
        :ensure t
        :mode ("\\.md\\'" "\\.markdown\\'")))

    (leaf *テーブルをピクセル単位で整列-----------------------------------------------------
      :doc "日本語や絵文字を含むテーブルでも綺麗に揃える"
      :config
      (leaf valign
        :url "https://github.com/casouri/valign"
        :ensure t
        :hook ((org-mode-hook . valign-mode)
               (markdown-mode-hook . valign-mode))))

    (leaf *lspモード----------------------------------------------------------------------
      :doc "eglot使いたいなと思いつつ、lsp-javaがlsp-mode前提ぽいのでlsp-modeで作っていく"
      :config
      (leaf lsp-mode
        :doc "LSPクライアント本体"
        :url "https://github.com/emacs-lsp/lsp-mode"
        :ensure t
        :custom (lsp-keymap-prefix . "C-c l")
        :hook (lsp-mode-hook . lsp-enable-which-key-integration))
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
        :after lsp-mode
        :commands (lsp-treemacs-errors-list lsp-treemacs-symbols)
        :hook (lsp-mode-hook . (lambda () (lsp-treemacs-sync-mode 1)))
)
      ;; 開発UI用hydra (ツリー表示、LSP、表示設定をまとめる)
      (leaf *dev-ui-keybinds
        :after lsp-treemacs
        :config
        (defhydra hydra-dev-ui (:hint nil)
          "
─── Dev UI ───────────────────────────────────────────
 Tree     _t_:treemacs
 LSP      _s_:symbols  _e_:errors  _r_:refs  _i_:impl  _c_:call  _y_:type
 Display  _g_:git-gutter  _l_:line-num  _C_:colorful  _R_:rainbow  _f_:flymake
─────────────────────────────────────────── _q_:quit ──
"
          ;; Tree
          ("t" treemacs)
          ;; LSP
          ("s" lsp-treemacs-symbols)
          ("e" lsp-treemacs-errors-list)
          ("r" lsp-treemacs-references)
          ("i" lsp-treemacs-implementations)
          ("c" lsp-treemacs-call-hierarchy)
          ("y" lsp-treemacs-type-hierarchy)
          ;; Display
          ("g" git-gutter-mode)
          ("l" display-line-numbers-mode)
          ("C" colorful-mode)
          ("R" rainbow-delimiters-mode)
          ("f" flymake-mode)
          ("q" nil :exit t))
        :bind (("C-; d u" . hydra-dev-ui/body)))

      (leaf *web開発の諸々 ----------------------------------------------------------------
        :config
        (leaf web-mode
          :doc "HTMLとかその他諸々"
          :url "https://web-mode.org"
          :ensure t
          :mode ("\\.html\\'"
                 "\\.htm\\'"
                 "\\.jsp\\'"
                 "\\.djhtml\\'"))
        (leaf css-ts-mode
          :doc "cssを色付け"
          :mode ("\\.css\\'"))
        (leaf impatient-mode
          :doc "HTTPサーバ立ててのライブプレビュー"
          :url "https://github.com/skeeto/impatient-mode"
          :ensure t))

      (leaf *JSやTS開発の諸々 --------------------------------------------------------------
        :config
        (leaf typescript-ts-mode
          :doc "TypeScriptのビルトインモード"
          :mode (("\\.ts\\'" . typescript-ts-mode)
                 ("\\.tsx\\'" . tsx-ts-mode))
          :hook ((typescript-ts-mode-hook . lsp-deferred)
                 (tsx-ts-mode-hook . lsp-deferred)))
        (leaf js-ts-mode
          :doc "JavaScriptのビルトインモード"
          :mode (("\\.js\\'" . js-ts-mode)
                 ("\\.mjs\\'" . js-ts-mode)
                 ("\\.jsx\\'" . jsx-ts-mode))
          :hook ((js-ts-mode-hook . lsp-deferred)
                 (jsx-ts-mode-hook . lsp-deferred)))
        (leaf json-ts-mode
          :mode ("\\.json\\'"))
        )

      (leaf *yaml ---------------------------------------------------------------------------
        :config
        (leaf yaml-ts-mode
          :mode "\\.yml\\'" "\\.yaml\\'"))

      (leaf *Java開発の諸々 ----------------------------------------------------------------
        :config
        (leaf lsp-java
          :doc "JavaなLSP"
          :url "https://github.com/emacs-lsp/lsp-java"
          :hook ((java-mode-hook . lsp-deferred)
                 (java-mode-hook . java-ts-mode))
          :ensure t)
        (leaf dap-mode
          :doc "デバッグ機能 (Debug Adapter Protocol)"
          :url "https://github.com/emacs-lsp/dap-mode"
          :ensure t
          :after lsp-java
          :config
          (require 'dap-java)
          ;; UIを有効化
          (dap-auto-configure-mode 1)
))
      ;; DAP用hydra
      (leaf *dap-keybinds
        :after dap-mode
        :config
        (defhydra hydra-dap (:hint nil)
          "
DAP: _d_:debug _b_:breakpoint _n_:next _i_:step-in _o_:step-out _c_:continue _r_:repl _q_:quit
"
          ("d" dap-debug)
          ("b" dap-breakpoint-toggle)
          ("n" dap-next)
          ("i" dap-step-in)
          ("o" dap-step-out)
          ("c" dap-continue)
          ("r" dap-ui-repl)
          ("q" dap-disconnect :exit t))
        :bind (("C-; d d" . hydra-dap/body)))

    (leaf *Python開発の諸々 --------------------------------------------------------------
      :config
      (leaf python-mode
        :ensure t
        :hook ((python-mode-hook . python-ts-mode)
               ;;               (python-mode-hook . lsp-deferred)
               )
        :mode ("\\.py\\'")))

    (leaf *Nixをやるぞ--------------------------------------------------------------------
      :config
      (leaf nix-ts-mode
        :ensure t
        :mode "\\.nix\\'"
        ;;        :hook (nix-ts-mode-hook . lsp-defrred)
        ))

    (leaf *nvimの設定をEmacsでやることもあるよね（Lua弄ることもあるよね）-----------------
      :doc "activeなluaのtreesitter見つけられなかったのでlua-ts-modeではなくlua-mode使う"
      :config
      (leaf lua-mode
        :ensure t
        :mode "\\.lua\\'"))

    (leaf *shell(bash) -------------------------------------------------------------------
      :doc "activeなluaのtreesitter見つけられなかったのでlua-ts-modeではなくlua-mode使う"
      :config
      (leaf bash-ts-mode
        :mode "\\.sh\\'"))

    (leaf *cやc++を扱うぞ ----------------------------------------------------------------
      :config
      (leaf c-ts-mode
        :mode ("\\.c\\'" "\\.sqc\\'")
        :hook (c-ts-mode-hook . lsp-deferred))
      (leaf c-or-c++-ts-mode
        :mode ("\\.h\\'"))
      (leaf c++-ts-mode
        :mode ("\\.cpp\\'")
        :hook (c++-ts-mode-hook . lsp-deferred))
      (leaf makefile-mode
        :mode ("\\.make\\'")))

    (leaf *CSVを扱うぞ--------------------------------------------------------------------
      :config
      (leaf csv-mode
        :ensure t
        :mode "\\.csv\\'"))

    ) ; end of 特定言語やメジャーモード設定===============================================
  ) ; end of *init*

(provide 'init)

;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-vc-selected-packages
   '((claude-code-ide :url
                      "https://github.com/manzaltu/claude-code-ide.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:underline nil))) nil "Customized with leaf in `doom-modeline' block at `/Users/yutaka.nakajima/.config/emacs/init.el'")
 '(mode-line-inactive ((t (:underline nil))) nil "Customized with leaf in `doom-modeline' block at `/Users/yutaka.nakajima/.config/emacs/init.el'"))
