# CLAUDE.md

このリポジトリには2つのものがある。

- `kakure_kanji/` … **かくれ漢字**（Flutter アプリ、iOS / Windows）。主な開発対象。
- `index.html` … 英単語の意味を調べる Web ページ（かくれ漢字とは無関係。触らない）。

## 仕様

- 正式仕様は `docs/SPEC.md`（Ver.1.1）。実装はこれに従う。
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
   KanjiVG を同梱するときは CC BY-SA 3.0 のクレジットとライセンスも表示する（仕様 7.4）。
5. **保存用データベースは Isar**（仕様 3.3、2026-11-24 に変更しないと決定）。

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
- `features/judge/` … 判定データ（grade_N.json）の読み込みと部品判定エンジン
- `features/puzzle/` … 問題画面、画の選択状態、見つけた部品（Riverpod）
- `features/home/` … ホーム画面
- 新しい機能は `features/<機能名>/` に追加する。

## メモ

- Flutter 3.50 系では Material は `package:material_ui/material_ui.dart` から import する。
- AnimCJK の SVG は `assets/animcjk/{10進コードポイント}.svg`（取得元: animCJK の `svgsJa/`）。
  部品漢字の SVG も必要（発見リストに描くため）。
- 判定データは `assets/json/grade_N.json`。形式は `lib/features/judge/puzzle_data.dart` のコメント参照。
  `test/judge/grade_data_test.dart` が仕様ルール（11.1〜11.5、17）を自動検査する。
- ウィジェットテストでは `setUp(rootBundle.clear)` を入れる（テスト間でアセット読み込みが固まるのを防ぐ）。
