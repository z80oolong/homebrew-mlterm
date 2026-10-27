class MltermLibvteAT395 < Formula
  desc "Multilingual terminal emulator"
  homepage "https://mlterm.sourceforge.io/"
  url "https://github.com/GNOME/vte/archive/refs/tags/0.84.1.tar.gz"
  version "3.9.5"
  sha256 "9f73468982a339cd1eb942beb7d348a5564c9ed48473ad1690c791f8474916ec"
  license "GPL-2.0-or-later"
  revision 3

  keg_only "this formula conflicts with `homebrew/core/vte3`"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibc"
  depends_on "gnutls"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libice"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libsixel"
  depends_on "libsm"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxt"
  depends_on "pango"
  depends_on "sdl12-compat"
  depends_on "sdl2"
  depends_on "systemd"
  depends_on "z80oolong/im/im-fcitx@5.1.12"
  depends_on "z80oolong/im/im-scim@1.4.18" => :optional

  resource("mlterm") do
    url "https://github.com/arakiken/mlterm/archive/refs/tags/3.9.5.tar.gz"
    sha256 "7d28678aa90dade72cea4e1e5fffb5e4c343487d60ca36c88dc615134613af39"

    patch :p1, :DATA
  end

  def mlterm_prefix
    libexec/"mlterm"
  end

  def mlterm_lib
    mlterm_prefix/"lib"
  end

  def install
    args = std_meson_args
    args << "--sysconfdir=#{prefix}/etc"
    args << "--buildtype=release"
    args << "--wrap-mode=nofallback"
    args << "-Ddebug=false"
    args << "-Ddocs=false"
    args << "-Dgir=true"
    args << "-Dgtk3=true"
    args << "-Dgtk4=true"

    ENV["XML_CATALOG_FILES"] = prefix/"etc/xml/catalog"

    inreplace("./src/app/vte.desktop.in") do |s|
      s.gsub!(/^SingleMainWindow=false/, "X-SingleMainWindow=false")
    end

    system "meson", "setup", "build", *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("mlterm").stage do
      ENV.cxx11
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"

      args = std_configure_args
      args.map! { |arg| arg.match?(/^--prefix/) ? "--prefix=#{mlterm_prefix}" : arg }
      args.map! { |arg| arg.match?(/^--libdir/) ? "--libdir=#{mlterm_lib}" : arg }
      args << "--disable-silent-rules"
      args << "--with-gui=xlib"
      args << "--with-gtk=3.0"
      args << "--with-type-engine=cairo"
      args << "--with-imagelib=gdk-pixbuf"
      args << "--with-scrollbars"
      args << "--datarootdir=#{mlterm_prefix}/share"
      args << "--sysconfdir=#{mlterm_prefix}/etc"
      args << "--enable-image"
      args << "--enable-fcitx"
      args << "--enable-scim" if build.with? "z80oolong/im/im-scim@1.4.18"

      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "vte"
      system "make", "install-vte"

      Dir.chdir("./gtk") do
        system "make", "gtk4"
        system "make", "install-gtk4"
      end
    end

    # Replace libvte-2.91*{.a,.so}*
    lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      ohai "Remove #{libfile}"
      rm libfile
    end

    mlterm_lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      ohai "Symlink #{libfile} => #{lib}/#{libfile.basename}"
      lib.install_symlink libfile
    end
  end

  test do
    # build test binary, Use for `brew test'.
    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        puts("mlterm-libvte test succeed.");
        return 0;
      }
    C
    flags = `#{formula_opt_bin("pkgconf")}/pkg-config --cflags --libs vte-2.91`
    flags = flags.chomp.split
    flags << "-ldl"
    flags << "-lm"

    system ENV.cc, testpath/"test.c", "-o", testpath/"test", *flags
    output = shell_output("#{testpath}/test").strip
    assert_equal "mlterm-libvte test succeed.", output
  end
end

__END__
diff --git a/gtk/Makefile.in b/gtk/Makefile.in
index 7911e5e..ce71b20 100644
--- a/gtk/Makefile.in
+++ b/gtk/Makefile.in
@@ -58,9 +58,7 @@ $(TARGET).la: $(OBJ) $(UI_DISPLAY_OBJ_@GUI@)
 	`echo ../uitoolkit/*.lo| \
 	sed 's/..\/uitoolkit\/ui_layout.lo//g' | \
 	sed 's/..\/uitoolkit\/ui_scrollbar.lo//g' | \
-	sed 's/..\/uitoolkit\/ui_sb_view_factory.lo//g' | \
 	sed 's/..\/uitoolkit\/ui_connect_dialog.lo//g' | \
-	sed 's/..\/uitoolkit\/ui_simple_sb_view.lo//g' | \
 	sed 's/..\/uitoolkit\/ui_screen_manager.lo//g' | \
 	sed 's/..\/uitoolkit\/ui_event_source.lo//g' | \
 	sed 's/..\/uitoolkit\/xdg-decoration-unstable-v1-client-protocol.lo//g' | \
