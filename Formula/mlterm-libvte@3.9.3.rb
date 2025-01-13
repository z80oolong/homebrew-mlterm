class MltermLibvteAT393 < Formula
  desc "Multilingual terminal emulator"
  homepage "https://mlterm.sourceforge.io/"
  url "https://github.com/arakiken/mlterm.git",
      revision: "2a9fdbf6f51dce65e4d656fa6d11a4b1df711c04"
  version "3.9.3-git20241222"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
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
  depends_on "z80oolong/dep/fcitx@5.1.10"
  depends_on "z80oolong/dep/ibus@1.5.31"
  depends_on "z80oolong/dep/scim@1.4.18"

  resource("libvte") do
    url "https://github.com/GNOME/vte/archive/refs/tags/0.78.2.tar.gz"
    sha256 "cbeb337d4158abe809200e64ea0d184002bc5cb74e7aa944737bdff6eb0b0a8a"
  end

  patch :p1, :DATA

  def libvte_prefix
    libexec/"libvte"
  end

  def libvte_lib
    libvte_prefix/"lib"
  end

  def install
    resource("libvte").stage do
      args = std_meson_args.dup
      args.map! { |arg| arg.match?(/^--prefix/) ? "--prefix=#{libvte_prefix}" : arg }
      args.map! { |arg| arg.match?(/^--libdir/) ? "--libdir=#{libvte_lib}" : arg }
      args << "--buildtype=release"
      args << "--wrap-mode=nofallback"
      args << "-Ddebug=true"
      args << "-Dgtk3=true"
      args << "-Dgtk4=false"

      system "meson", "setup", "build", *args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", libvte_lib/"pkgconfig"

    args  = std_configure_args
    args << "--disable-silent-rules"
    args << "--with-gui=xlib"
    args << "--with-gtk=3.0"
    args << "--with-type-engine=cairo"
    args << "--with-imagelib=gdk-pixbuf"
    args << "--with-scrollbars"
    args << "--datarootdir=#{share}"
    args << "--sysconfdir=#{prefix}/etc"
    args << "--enable-image"
    args << "--enable-fcitx"
    args << "--enable-scim"
    args << "--enable-ibus"

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "vte"
    system "make", "install-vte"
  end

  def post_install
    libvte_lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      ohai "Remove #{libfile}"
      libfile.unlink
    end

    lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      ohai "Symlink #{libfile} => #{libvte_lib}/#{libfile.basename}"
      libvte_lib.install_symlink libfile
    end

    if (lib/"pkgconfig").exist?
      ohai "Remove #{lib}/pkgconfig"
      (lib/"pkgconfig").unlink
    end

    ohai "Symlink #{libvte_lib}/pkgconfig => #{lib}/pkgconfig"
    lib.install_symlink "#{libvte_lib}/pkgconfig"

    if (lib/"girepository-1.0").exist?
      ohai "Remove #{lib}/girepository-1.0"
      (lib/"girepository-1.0").unlink
    end

    ohai "Symlink #{libvte_lib}/gitrepository-1.0 => #{lib}/girepository-1.0"
    lib.install_symlink "#{libvte_lib}/girepository-1.0"
  end

  test do
    system "#{bin}/mlterm", "--version"
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
