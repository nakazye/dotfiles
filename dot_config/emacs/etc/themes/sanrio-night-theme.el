;;; sanrio-night-theme.el --- Dark theme inspired by Sanrio / Little Twin Stars -*- lexical-binding: t -*-

(deftheme sanrio-night
  "Dark theme inspired by Sanrio characters, centered on Little Twin Stars (Kiki & Lara).")

(let* (;; Backgrounds
       (bg      "#1b1118")
       (bg-alt  "#271a22")
       (bg-hl   "#3a2432")
       ;; Foregrounds
       (fg      "#f9e9f2")
       (fg-dim  "#c8a4bc")
       (gray    "#8a7082")
       ;; Accents — character palette
       (red     "#f08080")   ; Hello Kitty
       (orange  "#efa42b")   ; Pompompurin
       (yellow  "#efc128")   ; Kiki & Lara (stars) ★
       (lime    "#bcd60a")   ; Kerokerokeroppi (bright)
       (green   "#91dea9")   ; Kerokerokeroppi (body)
       (cyan    "#8bd0dd")   ; Kiki (Little Twin Stars) ★
       (blue    "#72b8f0")   ; Cinnamoroll
       (purple  "#cda1dc")   ; Kuromi
       (pink    "#e383a8")   ; Lara (Little Twin Stars) ★
       (magenta "#f06aaa"))  ; My Melody

  (custom-theme-set-faces
   'sanrio-night

   ;; ── Core ──────────────────────────────────────────
   `(default                        ((t (:background ,bg :foreground ,fg :weight light))))
   `(cursor                         ((t (:background ,cyan))))
   `(fringe                         ((t (:background ,bg-alt :foreground ,gray))))
   `(vertical-border                ((t (:foreground ,bg-hl))))
   `(highlight                      ((t (:background ,bg-hl))))
   `(region                         ((t (:background ,bg-hl :extend t))))
   `(secondary-selection            ((t (:background ,bg-alt :extend t))))
   `(hl-line                        ((t (:background ,bg-alt :extend t))))
   `(trailing-whitespace            ((t (:background ,red))))

   ;; ── Text decorations ──────────────────────────────
   ;; extralight/light バリアントを持つフォント（PlemolJP Console NF 等）が必要
   `(bold                           ((t (:weight normal))))
   `(italic                         ((t (:weight light :slant italic))))
   `(shadow                         ((t (:foreground ,gray))))
   `(link                           ((t (:foreground ,cyan :underline t))))
   `(link-visited                   ((t (:foreground ,purple :underline t))))
   `(error                          ((t (:foreground ,red :weight normal))))
   `(warning                        ((t (:foreground ,orange :weight normal))))
   `(success                        ((t (:foreground ,lime :weight normal))))

   ;; ── Minibuffer / Prompt ───────────────────────────
   `(minibuffer-prompt              ((t (:foreground ,pink :weight normal))))

   ;; ── Font-lock (syntax highlighting) ───────────────
   `(font-lock-comment-face         ((t (:foreground ,fg-dim))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,fg-dim))))
   `(font-lock-doc-face             ((t (:foreground ,fg-dim))))
   `(font-lock-string-face          ((t (:foreground ,green))))
   `(font-lock-keyword-face         ((t (:foreground ,purple))))
   `(font-lock-builtin-face         ((t (:foreground ,magenta))))
   `(font-lock-function-name-face   ((t (:foreground ,cyan))))
   `(font-lock-variable-name-face   ((t (:foreground ,fg))))
   `(font-lock-type-face            ((t (:foreground ,blue))))
   `(font-lock-constant-face        ((t (:foreground ,orange))))
   `(font-lock-number-face          ((t (:foreground ,yellow))))
   `(font-lock-preprocessor-face    ((t (:foreground ,lime))))
   `(font-lock-warning-face         ((t (:foreground ,red :weight normal))))
   `(font-lock-negation-char-face   ((t (:foreground ,red))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,yellow))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,orange))))
   `(font-lock-escape-face          ((t (:foreground ,yellow))))
   `(font-lock-operator-face        ((t (:foreground ,pink))))

   ;; ── Mode line ─────────────────────────────────────
   `(mode-line                      ((t (:background ,bg-hl :foreground ,fg
                                         :box (:line-width 1 :color ,bg-hl)))))
   `(mode-line-inactive             ((t (:background ,bg-alt :foreground ,gray
                                         :box (:line-width 1 :color ,bg-alt)))))
   `(mode-line-buffer-id            ((t (:foreground ,cyan :weight normal))))
   `(mode-line-highlight            ((t (:foreground ,yellow :weight normal))))
   `(mode-line-emphasis             ((t (:foreground ,pink :weight normal))))
   `(header-line                    ((t (:background ,bg-alt :foreground ,fg-dim
                                         :box (:line-width 1 :color ,bg-hl)))))

   ;; ── Line numbers ──────────────────────────────────
   `(line-number                    ((t (:background ,bg :foreground ,gray))))
   `(line-number-current-line       ((t (:background ,bg-alt :foreground ,pink :weight normal))))

   ;; ── Search ────────────────────────────────────────
   `(isearch                        ((t (:background ,yellow :foreground ,bg :weight normal))))
   `(isearch-fail                   ((t (:background ,red :foreground ,fg))))
   `(lazy-highlight                 ((t (:background ,bg-hl :foreground ,yellow :weight normal))))
   `(match                          ((t (:background ,bg-hl :foreground ,cyan))))

   ;; ── Show paren ────────────────────────────────────
   `(show-paren-match               ((t (:background ,cyan :foreground ,bg :weight normal))))
   `(show-paren-mismatch            ((t (:background ,red :foreground ,fg :weight normal))))

   ;; ── Diff / VC ─────────────────────────────────────
   `(diff-added                     ((t (:foreground ,lime :extend t))))
   `(diff-removed                   ((t (:foreground ,red :extend t))))
   `(diff-changed                   ((t (:foreground ,yellow :extend t))))
   `(diff-header                    ((t (:foreground ,fg-dim :weight normal))))
   `(diff-file-header               ((t (:foreground ,cyan :weight normal))))
   `(diff-hunk-header               ((t (:foreground ,purple))))
   `(diff-refine-added              ((t (:background "#2a4030" :foreground ,lime))))
   `(diff-refine-removed            ((t (:background "#3a1820" :foreground ,red))))

   ;; ── Compilation ───────────────────────────────────
   `(compilation-error              ((t (:foreground ,red :weight normal))))
   `(compilation-warning            ((t (:foreground ,orange :weight normal))))
   `(compilation-info               ((t (:foreground ,cyan))))
   `(compilation-mode-line-exit     ((t (:foreground ,lime :weight normal))))
   `(compilation-mode-line-fail     ((t (:foreground ,red :weight normal))))

   ;; ── Org-mode ──────────────────────────────────────
   `(org-level-1                    ((t (:foreground ,magenta :weight normal :height 1.2))))
   `(org-level-2                    ((t (:foreground ,pink    :weight normal :height 1.1))))
   `(org-level-3                    ((t (:foreground ,cyan    :weight normal))))
   `(org-level-4                    ((t (:foreground ,purple  :weight normal))))
   `(org-level-5                    ((t (:foreground ,yellow))))
   `(org-level-6                    ((t (:foreground ,green))))
   `(org-todo                       ((t (:foreground ,red    :weight normal))))
   `(org-done                       ((t (:foreground ,lime   :weight normal))))
   `(org-date                       ((t (:foreground ,cyan   :underline t))))
   `(org-link                       ((t (:foreground ,cyan   :underline t))))
   `(org-block                      ((t (:background ,bg-alt :extend t))))
   `(org-block-begin-line           ((t (:foreground ,gray   :background ,bg-alt :extend t))))
   `(org-block-end-line             ((t (:foreground ,gray   :background ,bg-alt :extend t))))
   `(org-code                       ((t (:foreground ,green))))
   `(org-verbatim                   ((t (:foreground ,orange))))
   `(org-tag                        ((t (:foreground ,gray))))
   `(org-special-keyword            ((t (:foreground ,purple))))

   ;; ── Markdown ──────────────────────────────────────
   `(markdown-header-face            ((t (:weight normal))))
   `(markdown-header-face-1         ((t (:foreground ,magenta :weight normal :height 1.2))))
   `(markdown-header-face-2         ((t (:foreground ,pink    :weight normal :height 1.1))))
   `(markdown-header-face-3         ((t (:foreground ,cyan    :weight normal))))
   `(markdown-header-face-4         ((t (:foreground ,blue    :weight normal))))
   `(markdown-header-face-5         ((t (:foreground ,purple  :weight normal))))
   `(markdown-header-face-6         ((t (:foreground ,yellow  :weight normal))))
   `(markdown-bold-face             ((t (:weight normal))))
   `(markdown-code-face             ((t (:background ,bg-alt :extend t))))
   `(markdown-inline-code-face      ((t (:foreground ,green))))

   ;; ── Company ───────────────────────────────────────
   `(company-tooltip                ((t (:background ,bg-alt :foreground ,fg))))
   `(company-tooltip-selection      ((t (:background ,bg-hl  :foreground ,fg :weight normal))))
   `(company-tooltip-common         ((t (:foreground ,cyan   :weight normal))))
   `(company-tooltip-annotation     ((t (:foreground ,gray))))
   `(company-scrollbar-bg           ((t (:background ,bg-alt))))
   `(company-scrollbar-fg           ((t (:background ,gray))))
   `(company-preview-common         ((t (:foreground ,fg-dim))))

   ;; ── Vertico / Corfu / Consult ─────────────────────
   `(vertico-current                ((t (:background ,bg-hl :weight normal))))
   `(corfu-current                  ((t (:background ,bg-hl :weight normal))))
   `(corfu-default                  ((t (:background ,bg-alt))))
   `(consult-highlight-match        ((t (:foreground ,yellow :weight normal))))

   ;; ── Which-key ─────────────────────────────────────
   `(which-key-key-face             ((t (:foreground ,cyan))))
   `(which-key-command-face         ((t (:foreground ,fg-dim))))
   `(which-key-group-face           ((t (:foreground ,pink :weight normal))))

   ;; ── Magit ─────────────────────────────────────────
   `(magit-section-heading          ((t (:foreground ,pink   :weight normal))))
   `(magit-section-highlight        ((t (:background ,bg-alt :extend t))))
   `(magit-diff-added               ((t (:foreground ,lime   :background "#1e2e1e" :extend t))))
   `(magit-diff-removed             ((t (:foreground ,red    :background "#2e1818" :extend t))))
   `(magit-diff-added-highlight     ((t (:foreground ,lime   :background "#253525" :extend t))))
   `(magit-diff-removed-highlight   ((t (:foreground ,red    :background "#3a2020" :extend t))))
   `(magit-branch-local             ((t (:foreground ,cyan))))
   `(magit-branch-remote            ((t (:foreground ,green))))
   `(magit-tag                      ((t (:foreground ,yellow))))))

(provide-theme 'sanrio-night)
;;; sanrio-night-theme.el ends here
