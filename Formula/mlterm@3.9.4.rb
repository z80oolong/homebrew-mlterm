class MltermAT394 < Formula
  desc "Multilingual terminal emulator"
  homepage "https://mlterm.sourceforge.io/"
  url "https://github.com/arakiken/mlterm/archive/refs/tags/3.9.4.tar.gz"
  sha256 "171de4c4f3443bc1211cc51df5caa0e082ffcdd33ab3ce261bc0a4cfe85d9b5e"
  license "GPL-2.0-or-later"
  revision 2

  keg_only :versioned_formula

  depends_on "gettext" => :build
  depends_on "libtool" => :build
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
  depends_on "z80oolong/mlterm/im-fcitx@5.1.10"
  depends_on "z80oolong/mlterm/im-ibus@1.5.31"
  depends_on "z80oolong/mlterm/im-scim@1.4.18"

  def install
    ENV.cxx11
    ENV.append "CFLAGS", "-Wno-incompatible-pointer-types"
    ENV.append "CFLAGS", "-Wno-int-conversion"
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    args  = std_configure_args
    args << "--disable-silent-rules"
    args << "--with-gui=xlib"
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
  end

  def caveats
    <<~EOS
      MLTerm is a multilingual terminal emulator. In order to use it, you may need to
      install additional fonts or font packages.

      To launch MLTerm for fcitx (or SCIM or IBus) users, run the following command:

        mlterm --im=fcitx
        mlterm --im=scim
        mlterm --im=ibus
    EOS
  end

  test do
    system "#{bin}/mlterm", "--version"
  end
end
