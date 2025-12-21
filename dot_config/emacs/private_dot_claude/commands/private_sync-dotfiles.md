---
description: chezmoi re-add してgit push (project)
allowed-tools: Bash, AskUserQuestion
---

Emacs設定の変更をchezmoiに登録してGitにpushします。

## 手順

### Phase 1: 未管理ファイルの確認・追加

1. `chezmoi unmanaged ~/.config/emacs` で未管理ファイルを確認
   - 以下は自動生成またはローカル専用のため無視: elpa, eln-cache, var, etc, backup, tree-sitter, themes, settings.local.json
   - .claude 内の commands, skills は対象とする
   - それ以外の未管理ファイルがあればユーザーに報告

2. 追加候補のファイルがあれば:
   - AskUserQuestionツールで追加するか確認
   - 追加する場合は `chezmoi add <ファイルパス>` で登録
   - 追加しない場合はスキップ

### Phase 2: 変更確認

3. `chezmoi diff ~/.config/emacs` で変更内容を確認
   - 変更がなければその旨を報告して終了
   - 変更があれば内容をユーザーに表示

4. AskUserQuestionツールでユーザーに確認
   - 「この変更をコミットしてpushしますか？」
   - ユーザーがOKしたらPhase 3へ進む
   - ユーザーがキャンセルしたら終了

### Phase 3: 同期実行（ユーザー承認後）

5. `chezmoi re-add ~/.config/emacs` で変更をchezmoiに登録

6. chezmoiのsource directory (`chezmoi source-path`) に移動

7. `git status` で変更を確認

8. 変更があれば:
   - 変更内容を要約したコミットメッセージを作成（日本語）
   - `git add`, `git commit`, `git push` を実行

9. 結果を報告
