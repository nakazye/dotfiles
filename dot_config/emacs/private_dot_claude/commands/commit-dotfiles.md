---
description: chezmoi re-add してコミット (pushなし)
allowed-tools: Bash
---

Emacs設定の変更をchezmoiに登録してコミットします（pushはしない）。

## 手順

1. `chezmoi diff ~/.config/emacs` で変更内容を確認
   - 変更がなければその旨を報告して終了

2. 変更があれば:
   - diff出力から変更されたファイルパスを抽出（`diff --git a/...` の行からパスを取得）
   - 各ファイルを個別に `chezmoi re-add <ファイルパス>` で登録

3. chezmoiのsource directory (`chezmoi source-path`) に移動

4. `git status` で変更を確認

5. 変更があれば:
   - 変更内容を要約したコミットメッセージを作成（日本語）
   - `git add` と `git commit` を実行（pushはしない）

6. 結果を報告
