# CLAUDE.md

このリポジトリには2つのものがある。

- `kakure_kanji/` … **かくれ漢字**（Flutter アプリ、iOS / Windows）。主な開発対象。
- `index.html` … 英単語の意味を調べる Web ページ（かくれ漢字とは無関係。触らない）。

## 仕様

- 正式仕様は `docs/SPEC.md`（Ver.1.0 承認済み）。実装はこれに従う。
- 仕様と違う実装が必要なら、勝手に変えずユーザーに確認する。決まったら `docs/SPEC.md` の改版履歴に
  変更日・変更内容・変更理由を追記する。

## 絶対に守るルール

1. **ゲーム内の漢字（問題漢字・部品漢字）を `Text` で表示しない**（仕様 6.3）。
   必ず `KanjiStrokeView`（`lib/features/glyph/kanji_stroke_view.dart`）で AnimCJK の画データから描く。
   ボタン名などの UI 文言は `Text` でよい。
2. **選択中の画は最前面に描く**（仕様 6.4）。描画順は 未選択 → 選択。
3. **部品判定は事前登録データだけで行う**（仕様 10.1）。実行時に推論・図形解析で判定しない。
   画番号（strokeIds）は 1 始まりで筆順どおり。
4. **字形データのライセンス**：AnimCJK の SVG は Arphic Public License。
   `assets/licenses/ARPHICPL.TXT` を同梱し、アプリ内ライセンス画面に表示し続ける（仕様 7.2）。
   KanjiVG を同梱するときは CC BY-SA 3.0 の表記も追加する。

## 開発の進め方

- 仕様書 28章の Phase 順に進める。**1 Phase = 1 ブランチ = 1 PR**（ブランチ名 `kakure-kanji/phaseN-...`）。
- PR を出す前に `kakure_kanji/` で次を通す:
  - `flutter analyze`（警告ゼロ）
  - `flutter test`
- ロジック（判定・データ変換）には単体テストを、画面にはウィジェットテストを付ける。
- iOS / Windows のビルド確認は GitHub Actions（`.github/workflows/kakure_kanji.yml`）で行う。

## コード構成（kakure_kanji/lib）

- `app/` … ルーティング（GoRouter）
- `features/glyph/` … AnimCJK の読み込み・描画・画のタップ判定
- `features/puzzle/` … 問題画面と画の選択状態（Riverpod）
- `features/home/` … ホーム画面
- 新しい機能は `features/<機能名>/` に追加する。

## メモ

- Flutter 3.50 系では Material は `package:material_ui/material_ui.dart` から import する。
- AnimCJK の SVG は `assets/animcjk/{10進コードポイント}.svg`（取得元: animCJK の `svgsJa/`）。
