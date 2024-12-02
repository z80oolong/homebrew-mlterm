# z80oolong/mlterm に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/mlterm に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/mlterm/mlterm

この Formula は、多言語対応端末エミュレータ [MLTerm][MTRM] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

なお、この Formula で導入される [MLTerm][MTRM] では、 [mlterm][MTRM] 本体の他に、fcitx のインプットメソッドによる日本語入力に対応するプラグインも同時に導入されます。ここで、 [MLTerm][MTRM] から fcitx を用いて日本語入力を行う場合は、以下のようにして [MLTerm][MTRM] を起動します。

```
  ...
  $ mlterm --im=fcitx
  ...
```

### z80oolong/mlterm/mlterm-libvte@3.9.3

この Formula は、多言語対応端末エミュレータ [MLTerm][MTRM] によって実装された [libvte 互換ライブラリ][MVTE]を導入するための Formula です。

この Formula によって導入される互換ライブラリは、 [GNOME 純正の libvte ライブラリ][LVTE]とほぼ同等の機能を有します。

即ち、 [標準の libvte ライブラリ][LVTE] に代えて [MLTerm][MTRM] によって実装された [libvte 互換ライブラリ][MVTE]を用いて実装された端末エミュレータを導入するための Formula を記述する際には、以下のようにして当該端末エミュレータが依存する Formula である ```z80oolong/vte/libvte@2.91``` に代えて、 ```z80oolong/mlterm/mlterm-libvte@3.9.3``` に依存するように Formula を記述すると、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE]による端末エミュレータが導入されるので、当該端末エミュレータが [MLTerm][MTRM] の機能を用いて動作するようになります。

```
  class FooVteTerm < Formula
    ...
    #depends_on "z80oolong/vte/vte@2.91"               # → 標準の libvte ライブラリに代えて、 
    depends_on "z80oolong/mlterm/mlterm-libvte@3.9.3"  # → z80oolong/mlterm/mlterm-libvte@3.9.3 に依存させる。
    ...
  end
```

### z80oolong/mlterm/sakura-mlterm

[GTK][DGTK] と [libvte][LVTE] ベースの端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [sakura][SAKU] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/sakura``` の Formula についての記述を参照して下さい。**

**なお、 [sakura][SAKU] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [sakura][SAKU] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/sakura``` との conflict を防ぐため、この Formula によって導入される [sakura][SAKU] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [sakura][SAKU] を使用するには、 ```brew link --force z80oolong/mlterm/sakura-mlterm``` コマンドを実行する必要があります。

### z80oolong/mlterm/roxterm-mlterm

[libvte][LVTE] ベースであり、場所をとらないタブ式端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [roxterm][ROXT] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/roxterm``` の Formula についての記述を参照して下さい。**

**なお、 [roxterm][ROXT] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [roxterm][ROXT] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/roxterm``` との conflict を防ぐため、この Formula によって導入される [roxterm][ROXT] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [roxterm][ROXT] を使用するには、 ```brew link --force z80oolong/mlterm/roxterm-mlterm``` コマンドを実行する必要があります。

### z80oolong/vte/tilda-mlterm

[libvte][LVTE] ベースであり、設定可能なドロップダウン端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [tilda][TILD] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/tilda``` の Formula についての記述を参照して下さい。**

**なお、 [roxterm][ROXT] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [tilda][TILD] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/tilda``` との conflict を防ぐため、この Formula によって導入される [tilda][TILD] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tilda][TILD] を使用するには、 ```brew link --force z80oolong/mlterm/tilda-mlterm``` コマンドを実行する必要があります。

### z80oolong/mlterm/lxterminal-mlterm

[libvte][LVTE] ベースの [LXDE][LXDE] 用端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [lxterminal][LXTM] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/lxterminal``` の Formula についての記述を参照して下さい。**

**なお、 [lxterminal][LXTM] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [lxterminal][LXTM] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/roxterm``` との conflict を防ぐため、この Formula によって導入される [lxterminal][LXTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [lxterminal][LXTM] を使用するには、 ```brew link --force z80oolong/mlterm/lxterminal-mlterm``` コマンドを実行する必要があります。

### z80oolong/mlterm/mate-terminal-mlterm

[libvte][LVTE] ベースの [MATE][MATE] 用端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [mate-terminal][MTTM] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/mate-terminal``` の Formula についての記述を参照して下さい。**

**なお、 [mate-terminal][MTTM] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [mate-terminal][MTTM] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/mate-terminal``` との conflict を防ぐため、この Formula によって導入される [mate-terminal][MTTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [mate-terminal][MTTM] を使用するには、 ```brew link --force z80oolong/mlterm/mate-terminal-mlterm``` コマンドを実行する必要があります。

### z80oolong/mlterm/xfce4-terminal-mlterm

[libvte][LVTE] ベースの [xfce4][MATE] 用端末エミュレータであり、[MLterm を用いて実装された libvte 互換ライブラリ][MVTE]によって動作する [xfce4-terminal][XFTM] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

使用法の詳細については、 **Tap リポジトリ ```z80oolong/vte``` 内のドキュメント ```FormulaList.md``` の ```z80oolong/vte/xfce4-terminal``` の Formula についての記述を参照して下さい。**

**なお、 [xfce4-terminal][XFTM] における各種設定に関しては、 [libvte 互換ライブラリ][MVTE]によって動作する [MLTerm][MTRM] によって行った各種設定が [xfce4-terminal][XFTM] の各種設定に優先されることに留意する必要があります。**

**また、この Formula は ```z80oolong/vte/xfce4-terminal``` との conflict を防ぐため、この Formula によって導入される [xfce4-terminal][XFTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [xfce4-terminal][XFTM] を使用するには、 ```brew link --force z80oolong/mlterm/xfce4-terminal-mlterm``` コマンドを実行する必要があります。

### z80oolong/mlterm/mlterm@{version}

(注：上記 ```{version}``` には、 [MLTerm][MTRM] の各バージョン番号が入ります。以下同様。)

この Formula は、多言語対応端末エミュレータ [MLTerm][MTRM] の安定版 [mlterm {version}][MTRM] を導入します。

この Formula で導入した [MLTerm][MTRM] の使用法については、前述の ```z80oolong/mlterm/mlterm``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [MLTerm][MTRM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [MLTerm][MTRM] を使用するには、 ```brew link --force z80oolong/mlterm/mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/mlterm/sakura-mlterm@{version}

(注：上記 ```{version}``` には、 [sakura][SAKU] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータである [sakura][SAKU] の安定版 [sakura {version}][SAKU] を導入します。

この Formula で導入した [sakura][SAKU] の使用法については、前述の ```z80oolong/vte/sakura``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [sakura][SAKU] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [sakura][SAKU] を使用するには、 ```brew link --force z80oolong/mlterm/sakura-mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/mlterm/roxterm-mlterm@{version}

(注：上記 ```{version}``` には、 [roxterm][ROXT] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータである [roxterm][ROXT] の安定版 [roxterm {version}][ROXT] を導入します。

この Formula で導入した [roxterm][ROXT] の使用法については、前述の ```z80oolong/vte/roxterm``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [roxterm][ROXT] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [roxterm][ROXT] を使用するには、 ```brew link --force z80oolong/mlterm/roxterm-mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/vte/tilda-mlterm@{version}

(注：上記 ```{version}``` には、 [tilda][TILD] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータである [tilda][TILD] の安定版 [tilda {version}][TILD] を導入します。

この Formula で導入した [roxterm][ROXT] の使用法については、前述の ```z80oolong/vte/tilda``` の Formula についての記述を参照して下さい。

**また、この Formula は versioned formula であるため、この Formula によって導入される [tilda][TILD] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tilda][TILD] を使用するには、 ```brew link --force z80oolong/mlterm/tilda-mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/mlterm/lxterminal-mlterm@{version}

(注：上記 ```{version}``` には、 [lxterminal][LXTM] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータの安定版 [lxterminal {version}][LXTM] を導入します。

なお、この Formula で導入した [lxterminal][LXTM] の使用法については、前述の ```z80oolong/vte/lxterminal``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [lxterminal][LXTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [lxterminal][LXTM] を使用するには、 ```brew link --force z80oolong/mlterm/lxterminal-mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/mlterm/mate-terminal-mlterm@{version}

(注：上記 ```{version}``` には、 [mate-terminal][MTTM] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータの安定版 [mate-terminal {version}][MTTM] を導入するための Formula です。

なお、この Formula で導入した [mate-terminal][MTTM] の使用法については、前述の ```z80oolong/vte/mate-terminal``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [mate-terminal][MTTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [mate-terminal][MTTM] を使用するには、 ```brew link --force z80oolong/mlterm/mate-terminal-mlterm@{version}``` コマンドを実行する必要があります。

### z80oolong/mlterm/xfce4-terminal-mlterm@{version}

(注：上記 ```{version}``` には、 [xfce4-terminal][XFTM] の各バージョン番号が入ります。以下同様。)

この Formula は、 [MLterm を用いて実装された libvte 互換ライブラリ][MVTE] ベースの端末エミュレータの安定版 [xfce4-terminal {version}][MTTM] を導入するための Formula です。

なお、この Formula で導入した [xfce4-terminal][XFTM] の使用法については、前述の ```z80oolong/vte/mate-terminal``` の Formula についての記述を参照して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [xfce4-terminal][MTTM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [xfce4-terminal][XFTM] を使用するには、 ```brew link --force z80oolong/mlterm/xfce4-terminal-mlterm@{version}``` コマンドを実行する必要があります。

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
