# z80oolong/mlterm -- MLTerm 及び MLTerm の libvte 互換ライブラリを用いた端末エミュレータを導入するための Formula 群

## 概要

[Homebrew for Linux][BREW] とは、Linux の各ディストリビューションにおけるソースコードの取得及びビルドに基づいたパッケージ管理システムです。 [Homebrew for Linux][BREW] の使用により、ソースコードからのビルドに基づいたソフトウェアの導入を単純かつ容易に行うことが出来ます。

また、 [MLTerm][MTRM] とは、高速な多言語対応端末エミュレータであり、可変幅フォント及び多言語フォントのレンダリングと日本語入力システムからの直接入力と [SIXEL 機能][SIXL]に対応しているのが特徴です。

この [Homebrew for Linux][BREW] 向け Tap リポジトリは、多言語対応端末エミュレータ [MLTerm][MTRM] を導入するための Formula 群を含む Tap リポジトリです。

なお、本 Tap リポジトリには、 [MLTerm][MTRM] によって実装された [libvte 互換ライブラリ][MVTE]及び、[純正の libvte ライブラリ][LVTE]に代えて、[MLTerm で実装された libvte 互換ライブラリ][MVTE]を用いてビルドされた [libvte][LVTE] 対応端末エミュレータを導入するための Formula も併せて同梱しています。

なお、本リポジトリで導入される [MLTerm][MTRM] と [MLTerm で実装された libvte 互換ライブラリ][MVTE]及び [MLTerm で実装された libvte 互換ライブラリ][MVTE]を用いてビルドされた [libvte][LVTE] 対応端末エミュレータに関しては、本リポジトリに同梱する  ```FormulaList.md``` を参照してください。

## 使用法

まず最初に、以下に示す Qiita の投稿及び Web ページの記述に基づいて、手元の端末に [Homebrew for Linux][BREW] を構築し、以下のように  ```brew tap``` コマンドを用いて本リポジトリを導入します。

- [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" の投稿
- [Homebrew for Linux の公式ページ][BREW]

そして、本リポジトリに含まれる Formula を以下のようにインストールします。

```
 $ brew tap z80oolong/mlterm
 $ brew install <formula>
```

なお、一時的な手法ですが、以下のようにして URL を直接指定してインストールすることも出来ます。

```
 $ brew install https://raw.githubusercontent.com/z80oolong/homebrew-mlterm/master/Formula/<formula>.rb
```

なお、本リポジトリに含まれる Formula の一覧及びその詳細については、本リポジトリに同梱する ```FormulaList.md``` を参照して下さい。

## その他詳細について

その他、本リポジトリ及び [Homebrew for Linux][BREW] の使用についての詳細は ```brew help``` コマンド及び  ```man brew``` コマンドの内容、若しくは [Homebrew for Linux の公式ページ][BREW]を御覧下さい。

## 謝辞

まず最初に、多言語対応端末エミュレータ [MLTerm][MTRM] の作者である [Araki Ken 氏][ARAK]に心より感謝致します。

また、 [Homebrew for Linux][BREW] の導入に関しては、 [Homebrew for Linux の公式ページ][BREW] の他、 [thermes 氏][THER]による "[Homebrew for Linux のススメ][THBR]" 及び [Homebrew for Linux][BREW] 関連の各種資料を参考にしました。 [Homebrew for Linux の開発コミュニティ][BREW]及び[thermes 氏][THER]を始めとする各氏に心より感謝致します。

そして最後に、 [MLTerm][MTRM] に関わる全ての皆様及び、 [Homebrew for Linux][BREW] に関わる全ての皆様に心より感謝致します。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[MTRM]:https://github.com/arakiken/mlterm
[SIXL]:https://saitoha.github.io/libsixel/
[LVTE]:https://github.com/GNOME/vte
[MVTE]:https://qiita.com/arakiken/items/d6902225751b90063f68
[THER]:https://qiita.com/thermes
[THBR]:https://qiita.com/thermes/items/926b478ff6e3758ecfea
[ARAK]:https://github.com/arakiken
