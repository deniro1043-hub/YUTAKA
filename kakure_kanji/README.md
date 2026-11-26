# かくれ漢字

漢字の画を1本ずつ選んで、中に隠れている別の漢字を見つける右脳型パズル（iOS / Windows）。
仕様は [`docs/SPEC.md`](../docs/SPEC.md)。

## 進み具合

- [x] Phase1：AnimCJK 描画・画の描画・画のタップ選択
- [x] Phase2：判定エンジン・発見演出（判定データはサンプル15字分）
- [ ] Phase3：ゲームループ・図鑑・クリア判定
- [ ] Phase4〜7：コイン・ヒント・メダル・キャラクター・課金・リリース

## 動かし方

```bash
cd kakure_kanji
flutter pub get
flutter run -d windows   # Windows の場合（iOS は Mac で -d ios）
```

## テスト

```bash
flutter analyze
flutter test
```

## ライセンス

- 字形データ（`assets/animcjk/*.svg`）：[AnimCJK](https://github.com/parsimonhi/animCJK)、
  Arphic Public License（`assets/licenses/ARPHICPL.TXT`）。アプリ内の「ライセンス」画面にも表示する。
