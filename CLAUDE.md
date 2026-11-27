# CLAUDE.md

このリポジトリには2つのものがある。

- `kakure_kanji/` … **かくれ漢字**（Flutter アプリ、iOS / Windows）。主な開発対象。
- `index.html` … 英単語の意味を調べる Web ページ（かくれ漢字とは無関係。触らない）。

## ユーザーへの説明・操作案内のルール（最優先・2026-11-26 ユーザー指示）

ユーザーは GitHub もプログラミングも初めて。主に **iPhone の GitHub アプリ（日本語表示）** を使う。

1. **思い込みで進めるのは禁止。** 分からないこと（使っている端末、画面、ボタン名など）は推測せず、先に確認する。
2. **操作を案内する前に「スマホかPCか」を必ず確認する。** 私（Claude）からはユーザーの端末は見えない。
   ユーザーが一度「スマホでやっている」と言ったら、その会話ではスマホ前提で案内する。
3. **ボタン名は、ユーザーの画面に実際に出ている日本語の表記のまま書く。** 英語版や PC 版の名前で書かない。
   例：スマホアプリの PR 画面では「Merge pull request」ではなく、緑色の「**Pull Request をマージ**」。
   日本語アプリでの表記が確かでないときは、スクリーンショットを送ってもらって確認してから案内する。
4. **手順は省略しない。** 「どのアプリ／どの画面を開き、どこにある、何という名前のボタンを押すか」を、
   ホーム画面から順番に1つずつ書く。可能なら目的の画面を直接開くリンクも付ける。
5. GitHub アプリでできない操作（Settings の Pages など）は、そのことと、ブラウザでの開き方を先に伝える。
6. **ユーザーが「禁止」と言ったことは二度としない。** 新しく禁止されたことは、このリストに追記する。
7. **「待ってね」「終わったら知らせる」と言うときは、だいたいの所要時間を必ず添える。**
   目安（2026-11 の実測。GitHub が混んでいると延びる）:
   - PR を出したあとの自動チェック（テスト・Windows・Web のビルド）：約3〜5分
   - マージしてからスマホ用 Web 版が新しくなるまで：約2〜4分
   - iOS ビルド（main へのマージ時のみ）：約5分。Mac 環境が混んでいると15分以上待って中止されることがある
   - 私（Claude）が1つの Phase を作って PR を出すまで：内容によるので、着手時に見込みを伝える

## 仕様

- 正式仕様は `docs/SPEC.md`（Ver.1.2）。実装はこれに従う。
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
  iOS ビルドは main へのマージ時と手動実行時だけ動く（PR では動かない）。
- スマホ確認用の Web 版を GitHub Pages（https://deniro1043-hub.github.io/YUTAKA/）に自動公開している
  （`.github/workflows/kakure_kanji_web.yml`）。Web 版は確認用で、正式な配布先は iOS / Windows のまま。
  Web でも動かないコード（dart:io など）を lib/ に入れない。

## コード構成（kakure_kanji/lib）

- `app/` … ルーティング（GoRouter）
- `features/glyph/` … AnimCJK の読み込み・描画・画のタップ判定
- `features/judge/` … 判定データ（grade_N.json）の読み込みと部品判定エンジン
- `features/puzzle/` … 問題画面、画の選択状態、見つけた部品（Riverpod）
- `features/home/` … ホーム画面
- `features/stage/` … 学年選択・ステージ選択（1ステージ = 1文字）
- `features/dictionary/` … 図鑑（クリアした漢字が載る）
- `features/progress/` … クリア記録の保存。iOS / Windows は Isar、Web 版だけブラウザ保存
  （Isar 3 は Web のビルドが通らないため。`progress_provider.dart` の条件付き import で切り替え）
- 新しい機能は `features/<機能名>/` に追加する。

## メモ

- Flutter 3.50 系では Material は `package:material_ui/material_ui.dart` から import する。
- AnimCJK の SVG は `assets/animcjk/{10進コードポイント}.svg`（取得元: animCJK の `svgsJa/`）。
  部品漢字の SVG も必要（発見リストに描くため）。
- 判定データは `assets/json/grade_N.json`。形式は `lib/features/judge/puzzle_data.dart` のコメント参照。
  `test/judge/grade_data_test.dart` が仕様ルール（11.1〜11.5、17）を自動検査する。
- Isar のモデルを変えたら `dart run build_runner build --delete-conflicting-outputs` で
  `*.g.dart` を作り直してコミットする。
- ゲームの決まり（2026-11-27 決定）：部品漢字を全部見つけたらその字はクリア／図鑑にはクリアした字が載る／
  1ステージ = 1文字。
- ウィジェットテストでは `setUp(rootBundle.clear)` を入れる（テスト間でアセット読み込みが固まるのを防ぐ）。
