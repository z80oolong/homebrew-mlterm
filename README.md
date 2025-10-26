# z80oolong/mlterm -- MLTerm および MLTerm の libvte 互換ライブラリを用いた端末エミュレータの Formula 群

## 概要

[Homebrew for Linux][BREW] は、Linux ディストリビューション向けのソースコードベースのパッケージ管理システムで、ソフトウェアのビルドと導入を簡素化します。

[MLTerm][MTRM] は、高速な多言語対応端末エミュレータで、可変幅フォント、多言語フォントのレンダリング、日本語入力システムからの直接入力、[SIXEL 機能][SIXL] に対応しています。

本 Tap リポジトリ ```z80oolong/mlterm``` は、[MLTerm][MTRM] および [MLTerm の libvte 互換ライブラリ][MVTE] を用いた [libvte][LVTE] 対応端末エミュレータを導入する Formula 群を提供します。

[MLTerm の libvte 互換ライブラリ][MVTE] を [libvte][LVTE] 対応端末エミュレータに適用する詳細は、[Araki Ken 氏][ARAK] の Qiita 投稿 "[libvte互換ライブラリについて][MVTE]" を参照してください。

対応する Formula の詳細は、本リポジトリに同梱の ```FormulaList.md``` を参照してください。

## 使用方法

[Homebrew for Linux][BREW] を以下の参考資料に基づいてインストールします：

- [thermes 氏][THER] の Qiita 投稿 "[Linuxbrew のススメ][THBR]"
- [Homebrew for Linux 公式ページ][BREW]

そして、本リポジトリの Formula を以下のようにインストールします：

```
  brew tap z80oolong/mlterm
  brew install <formula>
```

または、一時的に以下の方法で直接インストールも可能です：

```
  brew install https://raw.githubusercontent.com/z80oolong/homebrew-mlterm/master/Formula/<formula>.rb
```

Formula の一覧と詳細は、本リポジトリに同梱の ```FormulaList.md``` を参照してください。

## 詳細情報

本リポジトリおよび [Homebrew for Linux][BREW] の詳細は、```brew help``` または ```man brew``` コマンド、または [Homebrew for Linux 公式ページ][BREW] を参照してください。

## 謝辞

多言語対応端末エミュレータ [MLTerm][MTRM] の作者である [Araki Ken 氏][ARAK] に深く感謝します。

[MLTerm の libvte 互換ライブラリ][MVTE] を [libvte][LVTE] 対応端末エミュレータに適用する手法は、[Araki Ken 氏][ARAK] の Qiita 投稿 "[libvte互換ライブラリについて][MVTE]" を参考にしました。

[Homebrew for Linux][BREW] の導入については、[Homebrew for Linux 公式ページ][BREW] および [thermes 氏][THER] の Qiita 投稿 "[Linuxbrew のススメ][THBR]" を参考にしました。[Homebrew for Linux 開発コミュニティ][BREW] および [thermes 氏][THER] に感謝します。

[MLTerm][MTRM] および [Homebrew for Linux][BREW] に関わるすべての皆様に深く感謝します。

## 使用条件

本リポジトリは、[Homebrew for Linux][BREW] の Tap リポジトリとして、[Homebrew for Linux 開発コミュニティ][BREW] および [Z.OOL.][ZOOL] が著作権を有し、[BSD 2-Clause License][BSD2] に基づいて配布されます。詳細は本リポジトリの ```LICENSE``` を参照してください。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[MTRM]:https://github.com/arakiken/mlterm
[SIXL]:https://saitoha.github.io/libsixel/
[LVTE]:https://github.com/GNOME/vte
[MVTE]:https://qiita.com/arakiken/items/d6902225751b90063f68
[THER]:https://qiita.com/thermes
[THBR]:https://qiita.com/thermes/items/926b478ff6e3758ecfea
[ARAK]:https://github.com/arakiken
[BSD2]:https://opensource.org/licenses/BSD-2-Clause
[ZOOL]:http://zool.jpn.org/
