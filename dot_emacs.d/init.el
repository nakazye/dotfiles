;;; init.el --- Initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:
;;; Emacs Startup File

;;; code:

(leaf lang-setting
  :doc "言語設定系"
  :config
  (set-language-environment  "Japanese")
  (prefer-coding-system  'utf-8)
  (set-file-name-coding-system  'utf-8)
  (set-keyboard-coding-system  'utf-8)
  (set-terminal-coding-system  'utf-8)
  (set-default 'buffer-file-coding-system 'utf-8))

;;; --------------------------------------

(leaf windows-encoding
  :doc "Windowsでの文字化け対策"
  :when (memq system-type '(cygwin windows-nt ms-dos))
  :config
  (setq-default default-process-coding-system '(utf-8-unix . japanese-cp932-dos)))

;;; --------------------------------------

(leaf font-setting
  :doc "フォント設定"
  :when (member "HackGen Console NF" (font-family-list))
  :config
  (add-to-list 'default-frame-alist '(font . "HackGen Console NF-12")))

;;; --------------------------------------

(leaf files
  :doc "バックアップファイル置き場等の設定"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)
	    (auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;;; --------------------------------------

(leaf autorevert
  :doc "自動revert設定(他でファイル変更があった際の再読み込み)"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

;;; --------------------------------------

(leaf delsel
  :doc "リージョン選択中に入力すると、選択範囲を消して入力"
  :global-minor-mode delete-selection-mode)

;;; --------------------------------------

(leaf which-key
  :doc "キーバインド表示"
  :ensure t
  :config
  (which-key-mode)
  (which-key-add-keymap-based-replacements
    global-map
    "C-c o" "org-command-map"))

;;; --------------------------------------

(leaf rg
  :doc "ripgrepを使う"
  :ensure t)

;;; --------------------------------------

(leaf affe
  :doc "grepやfindを便利に"
  :ensure t
  :custom ((affe-regexp-function . 'orderless-pattern-compiler)
           (affe-highlight-function . 'orderless--highlight)
	   (affe-find-command . "fd --color=never --full-path")))

;;; --------------------------------------

(leaf consult
  :doc "補完リスト作成"
  :ensure t
  :package t
  :bind
  (
   ("C-s" . consult-line)
   ("C-x C-b" . switch-to-buffer))
  :config
  (leaf consult-ghq
    :doc ""
    :ensure t)
  (leaf consult-lsp
    :doc ""
    :ensure t))

;;; --------------------------------------

(leaf orderless
  :doc "順不同のスペース区切り補完スタイルの提供"
  :ensure t
  :custom
  `((completion-styles . '(orderless))
    (orderless-matching-styles
     . '(orderless-literal
	 orderless-initialism))))

;;; --------------------------------------

(leaf marginalia
  :doc "補完項目に追加情報を提供"
  :ensure t)

;;; --------------------------------------

(leaf vertico
  :doc "ミニバッファでの補完UIの提供"
  :ensure t
  :bind
  (:vertico-map
   ("C-r" . vertico-previous)
   ("C-s" . vertico-next))
  :custom (vertico-count . 10)
  :hook
  (after-init-hook . vertico-mode)
  (after-init-hook . marginalia-mode))

;;; --------------------------------------

(leaf company
  :doc "補完パネルの提供"
  :ensure t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode
  :config (leaf company-c-headers
	    :doc "Company mode backend for C/C++ header files"
	    :ensure t
	    :after company
	    :defvar company-backends
	    :config
	    (add-to-list 'company-backends 'company-c-headers)))

;;; --------------------------------------

(leaf nerd-icons
  :doc "Nerd Fontsアイコンの利用"
  :ensure t)

;;; --------------------------------------

(leaf solarized-theme
  :doc ""
  :ensure t
  :require t
  :config
    (solarized-create-theme-file-with-palette 'light 'my-solarized-light
    '("#d688a7" "#f4f0f9"
       "#c1e2f6" "#efc9cd" "#e8c34d" "#e4a747" "#c2d648" "#a2dcad" "#94cbd1" "#c6a3d8"))
    (load-theme 'my-solarized-light t))


;;; --------------------------------------

(leaf nerd-icons-completion
  :doc "補完パッケージでアイコンが表示されるように"
  :ensure t
  :init (nerd-icons-completion-mode))

;;; --------------------------------------

(leaf projectile
  :doc "プロジェクト管理便利ツール"
  :ensure t
  :bind (:projectile-mode-map
	 ("C-c p" . projectile-command-map))
  :config
  (leaf consult-projectile
    :ensure t)
  :init
  (projectile-mode +1))

;;; --------------------------------------

(leaf treemacs
  :doc "ツリービュー設定"
  :ensure t
  :config
  (leaf treemacs-nerd-icons
    :doc "treemacsのアイコンをNerd Fontsで置き換え"
    :ensure t
    :require t)
  (treemacs-load-theme "nerd-icons"))

;;; --------------------------------------

(leaf treemacs-projectile
  :doc "プロジェクト単位でのtreemacs自動更新"
  :ensure t
  :after (treemacs projectile)
  :config
  (treemacs-project-follow-mode))

;;; --------------------------------------

(leaf colorful-mode
  :doc "カラーコードに色つけたり"
  :ensure t
  :custom ((colorful-use-prefix . t)
	   (colorful-prefix-string . "󰏘")))

;;; --------------------------------------

(leaf flycheck
  :doc "いろいろな言語の構文チェック"
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

;;; --------------------------------------

(leaf lsp-java
  :doc "lsp java"
  :ensure t
  :hook (java-mode-hook . (lambda () (lsp))))

;;; --------------------------------------

(leaf org
  :doc "org-mode設定"
  :ensure t
  :bind (("C-c o a" . org-agenda)
	 ("C-c o l" . org-store-link)
	 ("C-c o c" . org-capture)
	 ("C-c o j" . org-journal-new-entry))
  :custom
  (org-agenda-files . '("~/org/"))
  :config
  (leaf org-journal
    :doc "ジャーナル(仕事のメモに利用するぞ)"
    :ensure t
    :custom
    (org-journal-dir . "~/org/journal")
    (org-journal-file-type . 'monthly)
    (org-journal-date-format . "%Y-%m-%d, %A")
    (org-journal-time-format . "")
    (org-journal-file-format . "journal-%Y%m.org"))
  )

(leaf org-roam
  :doc "org-roam"
  :doc "org-roam-dailiesを日記として活用したい"
  :ensure t
  :require t
  :init
  (defvar org-roam-directory) ; config内で未定義警告出るのがいやなので一時的に設定
  :bind (("C-c o d" . org-roam-dailies-capture-today)
	 ("C-c o C" . org-roam-capture))
  :custom
  (org-roam-v2-ack . t)
  (org-roam-directory . "~/org/roam")
  (org-roam-db-location . "~/org/org-roam.db")
  (org-roam-dailies-directory . "~/org/diary")
  (org-roam-dailies-capture-templates . '(("d" "diary" entry
					   "* %?"
					   :target (file+head "diary-%<%Y%m>.org"
							      "#+title: %<%Y-%m-%d>\n"))))
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  (org-roam-db-autosync-mode))

;;; --------------------------------------

(provide 'init)

;;; init.el ends here
