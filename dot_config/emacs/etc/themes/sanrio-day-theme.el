;;; sanrio-day-theme.el --- Light theme inspired by Sanrio / Little Twin Stars -*- lexical-binding: t -*-

(deftheme sanrio-day
  "Light theme inspired by Sanrio characters, centered on Little Twin Stars (Kiki & Lara).")

(let* (;; Backgrounds
       (bg      "#fffaf8")
       (bg-alt  "#fff0f5")
       (bg-hl   "#fce0ed")
       ;; Foregrounds
       (fg      "#2a1820")
       (fg-dim  "#8a5070")
       (gray    "#c09aaa")
       ;; Accents — character palette (darkened for light-bg contrast)
       (red     "#cc3855")   ; Hello Kitty
       (orange  "#b87520")   ; Pompompurin
       (yellow  "#9a8800")   ; Kiki & Lara (stars) ★
       (lime    "#5c8c00")   ; Kerokerokeroppi (bright)
       (green   "#2a9468")   ; Kerokerokeroppi (body)
       (cyan    "#1882a0")   ; Kiki (Little Twin Stars) ★
       (blue    "#2858b8")   ; Cinnamoroll
       (purple  "#7038a0")   ; Kuromi
       (pink    "#c04482")   ; Lara (Little Twin Stars) ★
       (magenta "#b02878"))  ; My Melody

  (custom-theme-set-faces
   'sanrio-day

   ;; ── Core ──────────────────────────────────────────
   `(default                        ((t (:background ,bg :foreground ,fg))))
   `(cursor                         ((t (:background ,cyan))))
   `(fringe                         ((t (:background ,bg-alt :foreground ,gray))))
   `(vertical-border                ((t (:foreground ,bg-hl))))
   `(highlight                      ((t (:background ,bg-hl))))
   `(region                         ((t (:background ,bg-hl :extend t))))
   `(secondary-selection            ((t (:background ,bg-alt :extend t))))
   `(hl-line                        ((t (:background ,bg-alt :extend t))))
   `(trailing-whitespace            ((t (:background ,red))))

   ;; ── Text decorations ──────────────────────────────
   `(bold                           ((t (:weight bold))))
   `(italic                         ((t (:slant italic))))
   `(shadow                         ((t (:foreground ,gray))))
   `(link                           ((t (:foreground ,cyan :underline t))))
   `(link-visited                   ((t (:foreground ,purple :underline t))))
   `(error                          ((t (:foreground ,red :weight bold))))
   `(warning                        ((t (:foreground ,orange :weight bold))))
   `(success                        ((t (:foreground ,lime :weight bold))))

   ;; ── Minibuffer / Prompt ───────────────────────────
   `(minibuffer-prompt              ((t (:foreground ,pink :weight bold))))

   ;; ── Font-lock (syntax highlighting) ───────────────
   `(font-lock-comment-face         ((t (:foreground ,fg-dim :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,fg-dim :slant italic))))
   `(font-lock-doc-face             ((t (:foreground ,fg-dim :slant italic))))
   `(font-lock-string-face          ((t (:foreground ,green))))
   `(font-lock-keyword-face         ((t (:foreground ,purple))))
   `(font-lock-builtin-face         ((t (:foreground ,magenta))))
   `(font-lock-function-name-face   ((t (:foreground ,cyan))))
   `(font-lock-variable-name-face   ((t (:foreground ,fg))))
   `(font-lock-type-face            ((t (:foreground ,blue))))
   `(font-lock-constant-face        ((t (:foreground ,orange))))
   `(font-lock-number-face          ((t (:foreground ,yellow))))
   `(font-lock-preprocessor-face    ((t (:foreground ,lime))))
   `(font-lock-warning-face         ((t (:foreground ,red :weight bold))))
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
   `(mode-line-buffer-id            ((t (:foreground ,cyan :weight bold))))
   `(mode-line-highlight            ((t (:foreground ,yellow :weight bold))))
   `(mode-line-emphasis             ((t (:foreground ,pink :weight bold))))
   `(header-line                    ((t (:background ,bg-alt :foreground ,fg-dim
                                         :box (:line-width 1 :color ,bg-hl)))))

   ;; ── Line numbers ──────────────────────────────────
   `(line-number                    ((t (:background ,bg :foreground ,gray))))
   `(line-number-current-line       ((t (:background ,bg-alt :foreground ,pink :weight bold))))

   ;; ── Search ────────────────────────────────────────
   `(isearch                        ((t (:background ,yellow :foreground ,bg :weight bold))))
   `(isearch-fail                   ((t (:background ,red :foreground ,bg))))
   `(lazy-highlight                 ((t (:background ,bg-hl :foreground ,yellow :weight bold))))
   `(match                          ((t (:background ,bg-hl :foreground ,cyan))))

   ;; ── Show paren ────────────────────────────────────
   `(show-paren-match               ((t (:background ,cyan :foreground ,bg :weight bold))))
   `(show-paren-mismatch            ((t (:background ,red :foreground ,bg :weight bold))))

   ;; ── Diff / VC ─────────────────────────────────────
   `(diff-added                     ((t (:foreground ,lime :extend t))))
   `(diff-removed                   ((t (:foreground ,red :extend t))))
   `(diff-changed                   ((t (:foreground ,yellow :extend t))))
   `(diff-header                    ((t (:foreground ,fg-dim :weight bold))))
   `(diff-file-header               ((t (:foreground ,cyan :weight bold))))
   `(diff-hunk-header               ((t (:foreground ,purple))))
   `(diff-refine-added              ((t (:background "#d8f0e4" :foreground ,green))))
   `(diff-refine-removed            ((t (:background "#f8d8e0" :foreground ,red))))

   ;; ── Compilation ───────────────────────────────────
   `(compilation-error              ((t (:foreground ,red :weight bold))))
   `(compilation-warning            ((t (:foreground ,orange :weight bold))))
   `(compilation-info               ((t (:foreground ,cyan))))
   `(compilation-mode-line-exit     ((t (:foreground ,lime :weight bold))))
   `(compilation-mode-line-fail     ((t (:foreground ,red :weight bold))))

   ;; ── Org-mode ──────────────────────────────────────
   `(org-level-1                    ((t (:foreground ,magenta :weight bold :height 1.2))))
   `(org-level-2                    ((t (:foreground ,pink    :weight bold :height 1.1))))
   `(org-level-3                    ((t (:foreground ,cyan    :weight bold))))
   `(org-level-4                    ((t (:foreground ,purple  :weight bold))))
   `(org-level-5                    ((t (:foreground ,yellow))))
   `(org-level-6                    ((t (:foreground ,green))))
   `(org-todo                       ((t (:foreground ,red    :weight bold))))
   `(org-done                       ((t (:foreground ,lime   :weight bold))))
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
   `(markdown-header-face-1         ((t (:foreground ,magenta :weight bold :height 1.2))))
   `(markdown-header-face-2         ((t (:foreground ,pink    :weight bold :height 1.1))))
   `(markdown-header-face-3         ((t (:foreground ,cyan    :weight bold))))
   `(markdown-code-face             ((t (:background ,bg-alt :extend t))))
   `(markdown-inline-code-face      ((t (:foreground ,green))))

   ;; ── Company ───────────────────────────────────────
   `(company-tooltip                ((t (:background ,bg-alt :foreground ,fg))))
   `(company-tooltip-selection      ((t (:background ,bg-hl  :foreground ,fg :weight bold))))
   `(company-tooltip-common         ((t (:foreground ,cyan   :weight bold))))
   `(company-tooltip-annotation     ((t (:foreground ,gray))))
   `(company-scrollbar-bg           ((t (:background ,bg-alt))))
   `(company-scrollbar-fg           ((t (:background ,gray))))
   `(company-preview-common         ((t (:foreground ,fg-dim))))

   ;; ── Vertico / Corfu / Consult ─────────────────────
   `(vertico-current                ((t (:background ,bg-hl :weight bold))))
   `(corfu-current                  ((t (:background ,bg-hl :weight bold))))
   `(corfu-default                  ((t (:background ,bg-alt))))
   `(consult-highlight-match        ((t (:foreground ,yellow :weight bold))))

   ;; ── Which-key ─────────────────────────────────────
   `(which-key-key-face             ((t (:foreground ,cyan))))
   `(which-key-command-face         ((t (:foreground ,fg-dim))))
   `(which-key-group-face           ((t (:foreground ,pink :weight bold))))

   ;; ── Magit ─────────────────────────────────────────
   `(magit-section-heading          ((t (:foreground ,pink   :weight bold))))
   `(magit-section-highlight        ((t (:background ,bg-alt :extend t))))
   `(magit-diff-added               ((t (:foreground ,green  :background "#e8f8f0" :extend t))))
   `(magit-diff-removed             ((t (:foreground ,red    :background "#fce8ec" :extend t))))
   `(magit-diff-added-highlight     ((t (:foreground ,green  :background "#d0f0e0" :extend t))))
   `(magit-diff-removed-highlight   ((t (:foreground ,red    :background "#f8d0d8" :extend t))))
   `(magit-branch-local             ((t (:foreground ,cyan))))
   `(magit-branch-remote            ((t (:foreground ,green))))
   `(magit-tag                      ((t (:foreground ,yellow))))))

(provide-theme 'sanrio-day)
;;; sanrio-day-theme.el ends here
