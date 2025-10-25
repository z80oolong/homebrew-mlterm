# z80oolong/mlterm に含まれる Formula 一覧

## 概要

本文書では、[Homebrew for Linux][BREW] 向け Tap リポジトリ ```z80oolong/mlterm``` に含まれる Formula 一覧を示します。

この Tap リポジトリは、多言語対応端末エミュレータ [MLTerm][MTRM] 及び [MLTerm][MTRM] によって実装された [libvte 互換ライブラリ][MVTE] を利用した端末エミュレータを提供します。各 Formula の詳細については、```brew info <formula>``` コマンドをご覧ください。

## Formula 一覧

### z80oolong/mlterm/mlterm

多言語対応端末エミュレータ [MLTerm][MTRM] の最新安定版および HEAD 版をインストールする Formula です。

この Formula でインストールされた [MLTerm][MTRM] では、**fcitx5 による日本語入力対応プラグインが含まれます。**

- **オプション**:
    - **```--with-im-scim@1.4.18```: SCIM による日本語入力に対応します。ただし、動作に関しては未検証であることに注意してください。**

日本語入力を行う場合、以下のように ```mlterm``` を起動します。

```
$ mlterm --im=fcitx  # fcitx5 を使用
$ mlterm --im=scim   # SCIM を使用
```

### z80oolong/mlterm/mlterm-libvte@3.9.4

[MLTerm 3.9.4][MTRM] によって実装された [libvte 互換ライブラリ][MVTE] をインストールする Formula です。このライブラリは、[GNOME 純正の libvte][LVTE] とほぼ同等の機能を有し、以下に述べる [libvte][LVTE] ベースの端末エミュレータに依存します。

- **オプション**:
    - **```--with-im-scim@1.4.18```: SCIM による日本語入力に対応します。ただし、動作に関しては未検証であることに注意してください。**

端末エミュレータをインストールする Formula において、依存関係を ```z80oolong/vte/libvte@2.91``` の代わりに ```z80oolong/mlterm/mlterm-libvte@3.9.4``` に変更することで、[MLTerm][MTRM] の機能を利用した [libvte][LVTE] 対応端末エミュレータをインストールできます。以下に例を示します。

```
class FooVteTerm < Formula
  # ...
  # depends_on "z80oolong/vte/libvte@2.91"              # 標準の libvte
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"     # MLTerm の libvte 互換ライブラリ
  # ...
end
```

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。**

### z80oolong/mlterm/sakura-mlterm

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの端末エミュレータ [sakura][SAKU] の最新安定版および HEAD 版をインストールする Formula です。

この Formula でインストールされた [sakura][SAKU] では、**Unicode の [East Asian Ambiguous Character][EAWA]（例: "◎" や "★" 等の記号文字や罫線文字）が日本語環境で適切な文字幅で表示されない問題（[EAWA] 問題）が修正されます。**

なお、この Formula でインストールされた [sakura][SAKU] は、以下の環境変数を参照します。

- **環境変数**: ```VTE_CJK_WIDTH```
    - **```VTE_CJK_WIDTH=1``` の場合**: [EAWA] を全角文字幅で表示します。
    - **それ以外の値（または未設定）の場合**: [EAWA] を半角文字幅で表示します。

[EAWA] を全角文字幅で表示する場合、以下のように ```sakura``` を起動します。

```
$ export VTE_CJK_WIDTH=1  # 環境変数を設定
$ sakura
# または
$ env VTE_CJK_WIDTH=1 sakura
```

- **注意**:
    - **この Formula は ```z80oolong/vte/sakura``` との競合を避けるため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm``` を実行してください。
    - **[sakura][SAKU] の各種設定においては、[MLTerm][MTRM] での設定が [sakura][SAKU] での設定に上書きされます。**

### z80oolong/mlterm/sakura-mlterm@{version}

(注: ```{version}``` には [sakura][SAKU] の各バージョン番号が入ります。)

これは、[EAWA] 問題を修正した [MLTerm の libvte 互換ライブラリ][MVTE] ベースの端末エミュレータ [sakura][SAKU] の安定版をインストールする Formula です。使用法は ```z80oolong/mlterm/sakura-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm@{version}``` を実行してください。
    - **[sakura][SAKU] の各種設定においては、[MLTerm][MTRM] での設定が [sakura][SAKU] での設定に上書きされます。**

### z80oolong/mlterm/sakura-mlterm@9999-dev

これは、```z80oolong/vte/sakura@9999-dev``` に組み込まれた差分ファイルの適用により、[EAWA] 問題を修正した [MLTerm の libvte 互換ライブラリ][MVTE] ベースの端末エミュレータ [sakura][SAKU] の特定の HEAD 版をインストールする Formula です。

たとえば、```z80oolong/vte/sakura@9999-dev``` に組み込まれている差分ファイルが [sakura][SAKU] の HEAD 版のコミット xxxxxxxxx 向けに対応している場合は、この Formula は [sakura][SAKU] の HEAD 版のコミット xxxxxxxxx をインストールします。

具体的なコミットについては、```brew info z80oolong/mlterm/sakura-mlterm@9999-dev``` で確認できます。使用法は ```z80oolong/mlterm/sakura-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/sakura-mlterm@9999-dev``` を実行してください。
    - **この Formula は、```z80oolong/mlterm/sakura-mlterm``` の HEAD 版で差分ファイル適用に不具合が発生する場合に暫定的に使用するものです。** 通常は ```z80oolong/mlterm/sakura-mlterm``` をご使用ください。
    - **[sakura][SAKU] の各種設定においては、[MLTerm][MTRM] での設定が [sakura][SAKU] での設定に上書きされます。**

### z80oolong/mlterm/roxterm-mlterm

[MLTerm の libvte 互換ライブラリ][MVTE] ベースのタブ式端末エミュレータ [roxterm][ROXT] の最新安定版および HEAD 版をインストールする Formula です。

この Formula でインストールされた [roxterm][ROXT] では、**[EAWA] 問題が修正され、メニューや設定画面の一部を除き、機械翻訳による簡易な日本語化が行われます。**

なお、この Formula でインストールされた [roxterm][ROXT] は、以下の環境変数を参照します。

- **環境変数**: ```VTE_CJK_WIDTH```
    - **```VTE_CJK_WIDTH=1``` の場合**: [EAWA] を全角文字幅で表示します。
    - **それ以外の値（または未設定）の場合**: [EAWA] を半角文字幅で表示します。

- **注意**:
    - **この Formula は ```z80oolong/vte/roxterm``` との競合を避けるため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm``` を実行してください。
    - **[roxterm][ROXT] の各種設定においては、[MLTerm][MTRM] での設定が [roxterm][ROXT] での設定に上書きされます。**

### z80oolong/mlterm/roxterm-mlterm@{version}

(注: ```{version}``` には [roxterm][ROXT] の各バージョン番号が入ります。)

これは、[EAWA] 問題の修正及び機械翻訳による簡易な日本語化を行った [MLTerm の libvte 互換ライブラリ][MVTE] ベースのタブ式端末エミュレータ [roxterm][ROXT] の安定版をインストールする Formula です。使用法は ```z80oolong/mlterm/roxterm-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm@{version}``` を実行してください。
    - **[roxterm][ROXT] の各種設定においては、[MLTerm][MTRM] での設定が [roxterm][ROXT] での設定に上書きされます。**

### z80oolong/mlterm/roxterm-mlterm@9999-dev

これは、```z80oolong/vte/roxterm@9999-dev``` に組み込まれた差分ファイルの適用により、[EAWA] 問題の修正及び機械翻訳による簡易な日本語化を行った [MLTerm の libvte 互換ライブラリ][MVTE] ベースのタブ式端末エミュレータ [roxterm][ROXT] の特定の HEAD 版をインストールする Formula です。

たとえば、```z80oolong/vte/roxterm@9999-dev``` に組み込まれている差分ファイルが [roxterm][ROXT] の HEAD 版のコミット xxxxxxxxx 向けに対応している場合は、この Formula は [roxterm][ROXT] の HEAD 版のコミット xxxxxxxxx をインストールします。

具体的なコミットについては、```brew info z80oolong/mlterm/roxterm-mlterm@9999-dev``` で確認できます。使用法は ```z80oolong/mlterm/roxterm-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/roxterm-mlterm@9999-dev``` を実行してください。
    - **この Formula は、```z80oolong/mlterm/roxterm-mlterm``` の HEAD 版で差分ファイル適用に不具合が発生する場合に暫定的に使用するものです。** 通常は ```z80oolong/mlterm/roxterm-mlterm``` をご使用ください。
    - **[roxterm][ROXT] の各種設定においては、[MLTerm][MTRM] での設定が [roxterm][ROXT] での設定に上書きされます。**

### z80oolong/mlterm/tilda-mlterm

[MLTerm の libvte 互換ライブラリ][MVTE] ベースのドロップダウン端末エミュレータ [tilda][TILD] の最新安定版および HEAD 版をインストールする Formula です。

この Formula でインストールされた [tilda][TILD] では、**[EAWA] 問題が修正され、メニューや設定画面の一部を除き、機械翻訳による簡易な日本語化が行われます。**

なお、この Formula でインストールされた [tilda][TILD] は、以下の環境変数を参照します。

- **環境変数**: ```VTE_CJK_WIDTH```
    - **```VTE_CJK_WIDTH=1``` の場合**: [EAWA] を全角文字幅で表示します。
    - **それ以外の値（または未設定）の場合**: [EAWA] を半角文字幅で表示します。

- **注意**:
    - **この Formula は ```z80oolong/vte/tilda``` との競合を避けるため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm``` を実行してください。
    - **[tilda][TILD] の各種設定においては、[MLTerm][MTRM] での設定が [tilda][TILD] での設定に上書きされます。**

### z80oolong/mlterm/tilda-mlterm@{version}

(注: ```{version}``` には [tilda][TILD] の各バージョン番号が入ります。)

これは、[EAWA] 問題の修正及び機械翻訳による簡易な日本語化を行った [MLTerm の libvte 互換ライブラリ][MVTE] ベースのドロップダウン端末エミュレータ [tilda][TILD] の安定版をインストールする Formula です。使用法は ```z80oolong/mlterm/tilda-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm@{version}``` を実行してください。
    - **[tilda][TILD] の各種設定においては、[MLTerm][MTRM] での設定が [tilda][TILD] での設定に上書きされます。**

### z80oolong/mlterm/tilda-mlterm@9999-dev

これは、```z80oolong/vte/tilda@9999-dev``` に組み込まれた差分ファイルの適用により、[EAWA] 問題の修正及び機械翻訳による簡易な日本語化を行った [MLTerm の libvte 互換ライブラリ][MVTE] ベースのドロップダウン端末エミュレータ [tilda][TILD] の特定の HEAD 版をインストールする Formula です。

たとえば、```z80oolong/vte/tilda@9999-dev``` に組み込まれている差分ファイルが [tilda][TILD] の HEAD 版のコミット xxxxxxxxx 向けに対応している場合は、この Formula は [tilda][TILD] の HEAD 版のコミット xxxxxxxxx をインストールします。

具体的なコミットについては、```brew info z80oolong/mlterm/tilda-mlterm@9999-dev``` で確認できます。使用法は ```z80oolong/mlterm/tilda-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/tilda-mlterm@9999-dev``` を実行してください。
    - **この Formula は、```z80oolong/mlterm/tilda-mlterm``` の HEAD 版で差分ファイル適用に不具合が発生する場合に暫定的に使用するものです。** 通常は ```z80oolong/mlterm/tilda-mlterm``` をご使用ください。
    - **[tilda][TILD] の各種設定においては、[MLTerm][MTRM] での設定が [tilda][TILD] での設定に上書きされます。**

### z80oolong/mlterm/lxterminal-mlterm

[MLTerm の libvte 互換ライブラリ][MVTE] ベースの [LXDE][LXDE] 用端末エミュレータ [lxterminal][LXTM] の最新安定版および HEAD 版をインストールする Formula です。

この Formula でインストールされた [lxterminal][LXTM] では、**[EAWA] 問題が修正されます。**

なお、この Formula でインストールされた [lxterminal][LXTM] は、以下の環境変数を参照します。

- **環境変数**: ```VTE_CJK_WIDTH```
    - **```VTE_CJK_WIDTH=1``` の場合**: [EAWA] を全角文字幅で表示します。
    - **それ以外の値（または未設定）の場合**: [EAWA] を半角文字幅で表示します。

- **注意**:
    - **この Formula は ```z80oolong/vte/lxterminal``` との競合を避けるため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm``` を実行してください。
    - **[lxterminal][LXTM] の各種設定においては、[MLTerm][MTRM] での設定が [lxterminal][LXTM] での設定に上書きされます。**

### z80oolong/mlterm/lxterminal-mlterm@{version}

(注: ```{version}``` には [lxterminal][LXTM] の各バージョン番号が入ります。)

これは、[EAWA] 問題を修正した [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [LXDE][LXDE] 用端末エミュレータ [lxterminal][LXTM] の安定版をインストールする Formula です。使用法は ```z80oolong/mlterm/lxterminal-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm@{version}``` を実行してください。
    - **[lxterminal][LXTM] の各種設定においては、[MLTerm][MTRM] での設定が [lxterminal][LXTM] での設定に上書きされます。**

### z80oolong/mlterm/lxterminal-mlterm@9999-dev

これは、```z80oolong/vte/lxterminal@9999-dev``` に組み込まれた差分ファイルの適用により、[EAWA] 問題を修正した [MLTerm の libvte 互換ライブラリ][MVTE] ベースの [LXDE][LXDE] 用端末エミュレータ [lxterminal][LXTM] の特定の HEAD 版をインストールする Formula です。

たとえば、```z80oolong/vte/lxterminal@9999-dev``` に組み込まれている差分ファイルが [lxterminal][LXTM] の HEAD 版のコミット xxxxxxxxx 向けに対応している場合は、この Formula は [lxterminal][LXTM] の HEAD 版のコミット xxxxxxxxx をインストールします。

具体的なコミットについては、```brew info z80oolong/mlterm/lxterminal-mlterm@9999-dev``` で確認できます。使用法は ```z80oolong/mlterm/lxterminal-mlterm``` の記述をご覧ください。

- **注意**:
    - **この Formula は versioned formula のため、keg-only でインストールされます。** 使用するには ```brew link --force z80oolong/mlterm/lxterminal-mlterm@9999-dev``` を実行してください。
    - **この Formula は、```z80oolong/mlterm/lxterminal-mlterm``` の HEAD 版で差分ファイル適用に不具合が発生する場合に暫定的に使用するものです。** 通常は ```z80oolong/mlterm/lxterminal-mlterm``` をご使用ください。
    - **[lxterminal][LXTM] の各種設定においては、[MLTerm][MTRM] での設定が [lxterminal][LXTM] での設定に上書きされます。**

<!-- 外部リンク一覧 -->

[BREW]: https://linuxbrew.sh/  
[EAWA]: http://www.unicode.org/reports/tr11/#Ambiguous  
[MTRM]: https://github.com/arakiken/mlterm  
[MVTE]: https://qiita.com/arakiken/items/d6902225751b90063f68  
[LVTE]: https://github.com/GNOME/vte  
[LXDE]: http://www.lxde.org/  
[LXTM]: https://github.com/lxde/lxterminal  
[SAKU]: https://github.com/dabisu/sakura  
[ROXT]: https://github.com/realh/roxterm  
[TILD]: https://github.com/lanoxx/tilda/  
