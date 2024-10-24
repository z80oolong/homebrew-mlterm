class MltermLibvteAT393 < Formula
  desc "Multilingual terminal emulator"
  homepage "https://mlterm.sourceforge.io/"
  url "https://github.com/arakiken/mlterm.git",
      :revision => "de4b0f7216aaf53756d0b94b6fb0c448c9c10a83"
  license "GPL-2.0-or-later"
  version "3.9.3-git20241019"

  patch :p1, :DATA

  resource("libvte") do
    url "https://github.com/GNOME/vte/archive/refs/tags/0.71.92.tar.gz"
    sha256 "ea0f9ef37726aa6e6b0b0cfa6006cfb0b694aeae103f677977bc4d10f256c225"
  end

  keg_only :versioned_formula

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cmake" => :build
  depends_on "vala"  => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "vala"  => :build
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "systemd"
  depends_on "gobject-introspection"
  depends_on "gettext"
  depends_on "glib"
  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxt"
  depends_on "libice"
  depends_on "libsm"
  depends_on "pango"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "atk"
  depends_on "librsvg"
  depends_on "fribidi"
  depends_on "gobject-introspection"
  depends_on "harfbuzz"
  depends_on "gnutls"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libsixel"
  depends_on "z80oolong/dep/fcitx@4.2.9.8"


  def libvte_lib
    return (opt_libexec/"libvte/lib")
  end

  def install
    resource("libvte").stage do
      args = []
      args << "--prefix=#{libexec}/libvte"
      args << "--libdir=#{libexec}/libvte/lib"
      args << "--buildtype=release"
      args << "--wrap-mode=nofallback"
      args << "-Ddebug=true"

      system "meson", "setup", "build", *args, "-Ddebug=true"
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    ENV.cxx11
    ENV["PKG_CONFIG_PATH"] = "#{libexec}/libvte/lib/pkgconfig:#{ENV["PKG_CONFIG_PATH"]}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gui=xlib",
                          "--with-gtk=3.0",
                          "--with-type-engine=cairo",
                          "--with-imagelib=gdk-pixbuf",
                          "--with-scrollbars",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--sysconfdir=#{prefix}/etc",
                          "--enable-image",
                          "--enable-fcitx"
    system "make", "install"
    system "make", "vte"
    system "make", "install"
    system "make", "install-vte"
  end

  def post_install
    libvte_lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      system "rm", "-v", "#{libfile}"
    end

    lib.glob("libvte-2.91*{.a,.so}*") do |libfile|
      ohai "Symlink #{libfile} => #{libvte_lib}/#{libfile.basename}"
      libvte_lib.install_symlink "#{libfile}"
    end

    system "rm", "-v", "#{lib}/pkgconfig"
    ohai "Symlink #{libvte_lib}/pkgconfig => #{lib}/pkgconfig"
    lib.install_symlink "#{libvte_lib}/pkgconfig"

    system "rm", "-v", "#{lib}/girepository-1.0"
    ohai "Symlink #{libvte_lib}/gitrepository-1.0 => #{lib}/girepository-1.0"
    lib.install_symlink "#{libvte_lib}/girepository-1.0"
  end

  def caveats
    <<~EOS
      MLTerm is a multilingual terminal emulator. In order to use it, you may need to
      install additional fonts or font packages.

      To launch MLTerm for fcitx users, run the following command:

        mlterm --im=fcitx
    EOS
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
