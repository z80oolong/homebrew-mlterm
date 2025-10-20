# z80oolong/mlterm に含まれる Formula 一覧

## 概要

本書では、[Homebrew for Linux][BREW] 向け Tap リポジトリ ```z80oolong/mlterm``` に含まれる Formula を紹介します。詳細は```brew info <formula>```で確認してください。

## Formula 一覧

### z80oolong/mlterm/mlterm

多言語対応端末エミュレータ [MLTerm][MTRM] の最新安定版および HEAD 版を導入する Formula です。

導入される [MLTerm][MTRM] には、fcitx5 による日本語入力対応プラグインが含まれます。

**オプション ```--with-im-scim@1.4.18``` を指定すると、SCIM による日本語入力にも対応しますが、動作未確認です。**

日本語入力を行うには、以下のように起動します：

```
  mlterm --im=fcitx  # fcitx を使用
  mlterm --im=scim   # SCIM を使用
```

### z80oolong/mlterm/mlterm-libvte@3.9.4

[MLTerm][MTRM] が実装した [libvte 互換ライブラリ][MVTE] を導入する Formula です。このライブラリは、[GNOME 純正の libvte][LVTE] とほぼ同等の機能を有します。

**オプション ```--with-im-scim@1.4.18``` を指定すると、SCIM による日本語入力にも対応しますが、動作未確認です。**

端末エミュレータが ```z80oolong/vte/libvte@2.91``` の代わりに ```z80oolong/mlterm/mlterm-libvte@3.9.4``` に依存するよう Formula を記述すると、[MLTerm][MTRM] の機能を利用した端末エミュレータが導入されます：

```
class FooVteTerm < Formula
  ...
  # depends_on "z80oolong/vte/libvte@2.91"              # 標準の libvte
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"     # MLTerm の libvte 互換ライブラリ
  ...
end
```

### z80oolong/mlterm/sakura-mlterm

[GTK][DGTK] および [libvte][LVTE] ベースの端末エミュレータ [sakura][SAKU] を、[MLTerm の libvte 互換ライブラリ][MVTE] で動作させる最新安定版および HEAD 版を導入する Formula です。

使用方法は ```z80oolong/vte``` の ```FormulaList.md``` 内 ```z80oolong/vte/sakura``` を参照してください。

**[MLTerm][MTRM] の設定が [sakura][SAKU] の設定に優先されます。**

**```z80oolong/vte/sakura``` との競合を避けるため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm``` を実行してください。**

### z80oolong/mlterm/roxterm-mlterm

[libvte][LVTE] ベースのタブ式端末エミュレータ [roxterm][ROXT] を、[MLTerm の libvte 互換ライブラリ][MVTE] で動作させる最新安定版および HEAD 版を導入する Formula です。

使用方法は ```z80oolong/vte``` の ```FormulaList.md``` 内 ```z80oolong/vte/roxterm``` を参照してください。

**[MLTerm][MTRM] の設定が [roxterm][ROXT] の設定に優先されます。**

**```z80oolong/vte/roxterm``` との競合を避けるため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm``` を実行してください。**

### z80oolong/mlterm/tilda-mlterm

[libvte][LVTE] ベースのドロップダウン端末エミュレータ [tilda][TILD] を、[MLTerm の libvte 互換ライブラリ][MVTE] で動作させる最新安定版および HEAD 版を導入する Formula です。

使用方法は ```z80oolong/vte``` の ```FormulaList.md``` 内 ```z80oolong/vte/tilda``` を参照してください。

**[MLTerm][MTRM] の設定が [tilda][TILD] の設定に優先されます。**

**```z80oolong/vte/tilda``` との競合を避けるため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm``` を実行してください。**

### z80oolong/mlterm/lxterminal-mlterm

[libvte][LVTE] ベースの [LXDE][LXDE] 用端末エミュレータ [lxterminal][LXTM] を、[MLTerm の libvte 互換ライブラリ][MVTE] で動作させる最新安定版および HEAD 版を導入する Formula です。

使用方法は ```z80oolong/vte``` の ```FormulaList.md``` 内 ```z80oolong/vte/lxterminal``` を参照してください。

**[MLTerm][MTRM] の設定が [lxterminal][LXTM] の設定に優先されます。**

**```z80oolong/vte/lxterminal``` との競合を避けるため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm``` を実行してください。**

### z80oolong/mlterm/mlterm@{version}

（注: ```{version}``` は [MLTerm][MTRM] のバージョン番号を表します。以下同様。）

[MLTerm][MTRM] の安定版を導入する Formula です。

使用方法は ```z80oolong/mlterm/mlterm``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/mlterm@{version}``` を実行してください。**

### z80oolong/mlterm/sakura-mlterm@{version}

（注: ```{version}``` は [sakura][SAKU] のバージョン番号を表します。）

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの [sakura][SAKU] の安定版を導入する Formula です。

使用方法は ```z80oolong/vte/sakura``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm@{version}``` を実行してください。**

### z80oolong/mlterm/sakura-mlterm@9999-dev

```z80oolong/vte/sakura@9999-dev``` に同梱された EAA 問題を修正する差分ファイルを、対応する [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [sakura][SAKU] の HEAD 版のコミットに適用したものを導入する Formula です。**導入される具体的な commit ID は ```brew info z80oolong/mlterm/sakura-mlterm@9999-dev``` で確認してください。**

使用方法は ```z80oolong/vte/sakura``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm@9999-dev``` を実行してください。**

**```z80oolong/mlterm/sakura-mlterm``` の HEAD 版でパッチ適用に問題が生じた場合の暫定用です。通常は ```z80oolong/mlterm/sakura-mlterm``` を使用してください。**

### z80oolong/mlterm/roxterm-mlterm@{version}

（注: ```{version}``` は [roxterm][ROXT] のバージョン番号を表します。）

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの [roxterm][ROXT] の安定版を導入する Formula です。

使用方法は ```z80oolong/vte/roxterm``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm@{version}``` を実行してください。**

### z80oolong/mlterm/roxterm-mlterm@9999-dev

```z80oolong/vte/roxterm@9999-dev``` に同梱された EAA 問題の修正および日本語化差分ファイルを、対応する [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [roxterm][ROXT] の HEAD 版のコミットに適用したものを導入する Formula です。**導入される具体的な commit ID は ```brew info z80oolong/mlterm/roxterm-mlterm@9999-dev``` で確認してください。**

使用方法は ```z80oolong/vte/roxterm``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm@9999-dev``` を実行してください。**

**```z80oolong/mlterm/roxterm-mlterm``` の HEAD 版でパッチ適用に問題が生じた場合の暫定用です。通常は ```z80oolong/mlterm/roxterm-mlterm``` を使用してください。**

### z80oolong/mlterm/tilda-mlterm@{version}

（注: ```{version}``` は [tilda][TILD] のバージョン番号を表します。）

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの [tilda][TILD] の安定版を導入する Formula です。

使用方法は ```z80oolong/vte/tilda``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm@{version}``` を実行してください。**

### z80oolong/mlterm/tilda-mlterm@9999-dev

```z80oolong/vte/tilda@9999-dev``` に同梱された EAA 問題を修正する差分ファイルを、対応する [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [tilda][TILD] の HEAD 版のコミットに適用したものを導入する Formula です。**導入される具体的な commit ID は ```brew info z80oolong/mlterm/tilda-mlterm@9999-dev``` で確認してください。**

使用方法は ```z80oolong/vte/tilda``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm@9999-dev``` を実行してください。**

**```z80oolong/mlterm/tilda-mlterm``` の HEAD 版でパッチ適用に問題が生じた場合の暫定用です。通常は ```z80oolong/mlterm/tilda-mlterm``` を使用してください。**

### z80oolong/mlterm/lxterminal-mlterm@{version}

（注: ```{version}``` は [lxterminal][LXTM] のバージョン番号を表します。）

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの [lxterminal][LXTM] の安定版を導入する Formula です。

使用方法は ```z80oolong/vte/lxterminal``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm@{version}``` を実行してください。**

### z80oolong/mlterm/lxterminal-mlterm@9999-dev

```z80oolong/vte/lxterminal@9999-dev``` に同梱された EAA 問題を修正する差分ファイルを、対応する [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [lxterminal][LXTM] の HEAD 版のコミットに適用したものを導入する Formula です。**導入される具体的な commit ID は ```brew info z80oolong/mlterm/tilda-mlterm@9999-dev``` で確認してください。**

使用方法は ```z80oolong/vte/lxterminal``` を参照してください。

**本 Formula は versioned formula のため、keg-only でインストールされます。使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm@9999-dev``` を実行してください。**

**```z80oolong/mlterm/lxterminal-mlterm``` の HEAD 版でパッチ適用に問題が生じた場合の暫定用です。通常は ```z80oolong/mlterm/lxterminal-mlterm``` を使用してください。**

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[MTRM]:https://github.com/arakiken/mlterm
[LVTE]:https://github.com/GNOME/vte
[MVTE]:https://qiita.com/arakiken/items/d6902225751b90063f68
[GNME]:https://www.gnome.org/
[LXDE]:http://www.lxde.org/
[LXTM]:https://github.com/lxde/lxterminal
[MATE]:https://mate-desktop.org/ja/
[MTTM]:https://wiki.mate-desktop.org/mate-desktop/applications/mate-terminal/
[XFCE]:https://www.xfce.org/
[XFTM]:https://github.com/xfce-mirror/xfce4-terminal
[DGTK]:https://gtk.org/
[LVTE]:https://github.com/GNOME/vte
[SAKU]:https://github.com/dabisu/sakura
[ROXT]:https://github.com/realh/roxterm
[TILD]:https://github.com/lanoxx/tilda/
[GEAN]:https://www.geany.org/
