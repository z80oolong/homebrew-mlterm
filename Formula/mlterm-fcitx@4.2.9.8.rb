class MltermFcitxAT4298 < Formula
  desc "Flexible Input Method Framework"
  homepage "https://fcitx-im.org/"
  url "https://github.com/fcitx/fcitx/archive/refs/tags/4.2.9.8.tar.gz"
  version "4.2.9.8"
  sha256 "1b630d278d955b64b20ebcdf8ff4bb78be8af0d6b042383274993a2cb4642d21"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  patch :p1, :DATA

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libxkbcommon"
  depends_on "gobject-introspection"
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "z80oolong/mlterm/fcitx-qt@4"
  depends_on "qt@5"
  depends_on "intltool"
  depends_on "librsvg"
  depends_on "z80oolong/mlterm/fcitx-gconf@3"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "sqlite"
  depends_on "libxml2"
  on_macos do
    depends_on "libiconv"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DENABLE_X11=ON", "-DENABLE_GTK2_IM_MODULE=ON", "-DENABLE_GTK3_IM_MODULE=ON",
             "-DENABLE_QT=ON", "-DENABLE_QT_IM_MODULE=ON", "-DENABLE_QT_GUI=OFF"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Fcitx is an input method framework for Linux. In order to use it, you may need to
      install additional input methods or configure your system to use it.

      For GTK+3 users, make sure to set the following environment variables in your shell startup script:

        export XMODIFIERS=@im=fcitx
        export GTK_IM_MODULE=fcitx
        export QT_IM_MODULE=fcitx
        export DefaultIMModule=fcitx

      To configure Fcitx, run the following command:

        fcitx-config-gtk3
    EOS
  end

  test do
    system "#{bin}/fcitx", "--version"
  end
end

__END__
diff --git a/src/frontend/qt/qtkey.h b/src/frontend/qt/qtkey.h
index 4011ff5..711edaf 100644
--- a/src/frontend/qt/qtkey.h
+++ b/src/frontend/qt/qtkey.h
@@ -22,6 +22,10 @@
 
 #include <QString>
 
+#if 1
+#include <cstdint>
+#endif
+
 int keysymToQtKey(uint32_t keysym, const QString &text);
 
 #endif // _PLATFORMINPUTCONTEXT_QTKEY_H_
