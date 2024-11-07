class MltermAT393 < Formula
  desc "Multilingual terminal emulator"
  homepage "https://mlterm.sourceforge.io/"
  url "https://github.com/arakiken/mlterm/archive/refs/tags/3.9.3.tar.gz"
  sha256 "b5b76721391de134bd64afb7de6b4256805cf2fc883a2bf2e5d29602ac1b50d9"
  license "GPL-2.0-or-later"
  version "3.9.3"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "vala"  => :build
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

  def install
    ENV.cxx11
    ENV.append "CFLAGS", "-Wno-incompatible-pointer-types"
    ENV.append "CFLAGS", "-Wno-int-conversion"
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
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
    system "make", "install"
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
