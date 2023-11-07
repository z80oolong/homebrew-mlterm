# z80oolong/mlterm に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/mlterm に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/mlterm/mlterm

この Formula は、多言語対応端末エミュレータ [MLTerm][MTRM] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

なお、 ```z80oolong/mlterm/mlterm``` では、 ```mlterm``` 本体の他に、この Formula で導入される [MLTerm][MTRM] においては、 fcitx 及び ibus のインプットメソッドによる日本語入力に対応するプラグインも同時に導入されます。ここで、 [MLTerm][MTRM] から fcitx を用いて日本語入力を行う場合は、以下のようにして [MLTerm][MTRM] を起動します。

```
  ...
  $ mlterm --im=fcitx
  ...
```

### z80oolong/mlterm/mlterm@{version}

(注：上記 ```{version}``` には、 [MLTerm][MTRM] の各バージョン番号が入ります。以下同様。)

この Formula は、多言語対応端末エミュレータ [MLTerm][MTRM] の安定版 [mlterm {version}][MTRM] を導入します。

この Formula で導入した [MLTerm][MTRM]  の詳細については、前述の z80oolong/mlterm/mlterm の Formula についての記述を参照して下さい。

また、 [MLTerm][MTRM] の安定版 [mlterm 3.9.3][MTRM] を導入するための Formula である ```z80oolong/mlterm/mlterm@3.9.3``` では、 ```mlterm``` 本体の他に、 [mlterm 3.9.3][MTRM] を用いて実装された [libvte][LVTE] 互換ライブラリも同時に導入されます。

即ち、 [libvte ライブラリ][LVTE] を用いて実装された端末エミュレータを導入するための Formula を記述する際には、以下のようにして、当該端末エミュレータが依存する Formula である ```z80oolong/vte/vte@2.91``` に代えて、 ```z80oolong/mlterm/mlterm@3.9.3``` に依存するように Formula を記述すると、 [mlterm 3.9.3][MTRM] を用いて実装された [libvte][LVTE] 互換ライブラリによる端末エミュレータが導入されるので、当該端末エミュレータが [MLTerm][MTRM] の機能を用いて動作するようになります。

```
  class FooVteTerm < Formula
    ...
    #depends_on "z80oolong/vte/vte@2.91"        # → 標準の libvte ライブラリに代えて、 
    depends_on "z80oolong/mlterm/mlterm@3.9.3"  # → z80oolong/mlterm/mlterm@3.9.3 に依存させる。
    ...
  end
```

[mlterm 3.9.3][MTRM] による [libvte][LVTE] 互換ライブラリの詳細については、 Tap リポジトリ ```z80oolong/vte``` に含まれる FormulaList.md の ```z80oolong/vte/sakura-mlterm```, ```z80oolong/vte/roxterm-mlterm```, ```z80oolong/vte/lxterminal-mlterm```, ```z80oolong/vte/mate-terminal-mlterm``` 等に関する記述を参照してください。 

**この Formula は、 versioned formula であるため、この Formula によって導入される [MLTerm][MTRM] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [MLTerm][MTRM] を使用するには、 ```brew link --force z80oolong/mlterm/mlterm@{version}``` コマンドを実行する必要があります。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[MTRM]:https://github.com/arakiken/mlterm
[LVTE]:https://github.com/GNOME/vte
