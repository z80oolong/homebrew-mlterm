class ImIbusAT1531 < Formula
  include Language::Python::Virtualenv

  desc "Intelligent Input Bus for Linux / Unix OS"
  homepage "https://github.com/ibus/ibus"
  url "https://github.com/ibus/ibus/archive/refs/tags/1.5.31.tar.gz"
  sha256 "1d93df0bd0d9581decb8f0c85fe3b2d248878140c6e5a7cd8ca459c72f75870c"
  license "GPL-2.0-or-later"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "glib" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "gdk-pixbuf"
  depends_on "glibc"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libnotify"
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxkbcommon"
  depends_on "pango"
  depends_on "python@3.11"
  depends_on "vala"

  resource("unicode-emoji") do
    url "https://github.com/samhocevar/unicode-emoji.git",
      revision: "963e436f8ab08184c36c25032aec22a8eb85e05a"
  end

  resource("emoji-annotation") do
    url "https://github.com/fujiwarat/cldr-emoji-annotation/releases/download/38-alpha1.0_13.0_0_1/cldr-emoji-annotation-38-alpha1.0_13.0_0_1.tar.gz"
    sha256 "c1310d7e3232202007ae43c41695b27ff21ed60d5cf3c3a7293408da6f02c3cf"
  end

  resource("unicode-data") do
    url "https://gitlab.gnome.org/ebassi/unicode-data.git",
        revision: "b4519a4f690b5c57e4a902438c8a990a2f222cf9"
  end

  resource("libdbusmenu") do
    url "https://launchpad.net/libdbusmenu/16.04/16.04.0/+download/libdbusmenu-16.04.0.tar.gz"
    sha256 "b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a"
  end

  def install
    virtualenv_create(libexec, "python3")

    resource("unicode-emoji").stage do
      (share/"unicode/emoji").install "emoji-data.txt"
      (share/"unicode/emoji").install "emoji-sequences.txt"
      (share/"unicode/emoji").install "emoji-test.txt"
      (share/"unicode/emoji").install "emoji-variation-sequences.txt"
      (share/"unicode/emoji").install "emoji-zwj-sequences.txt"
    end

    resource("emoji-annotation").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--sysconfdir=#{etc}"
      system "make"
      system "make", "install"
    end

    resource("unicode-data").stage do
      system "meson", "setup", "build", *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    resource("libdbusmenu").stage do
      args = std_configure_args.dup
      args.map! { |arg| arg.match?(/^--prefix/) ? "--prefix=#{libexec}/libdbusmenu" : arg }
      args.map! { |arg| arg.match?(/^--libdir/) ? "--libdir=#{libexec}/libdbusmenu/lib" : arg }
      args << "--disable-silent-rules"
      args << "--disable-dumper"

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    emoji_dir = share/"unicode/emoji"
    ucd_dir   = share/"unicode-data"
    cldr_dir  = share/"unicode/cldr"
    anno_dir  = cldr_dir/"common/annotations"

    args  = std_configure_args
    args << "--sysconfdir=#{etc}"
    args << "--localstatedir=#{var}"
    args << "--disable-python2"
    args << "--with-python=python3"
    args << "--with-python_prefix=#{libexec}"
    args << "--disable-maintainer-mode"
    args << "--disable-wayland"
    args << "--disable-gtk2"
    args << "--disable-gtk4"
    args << "--disable-schemas-compile"
    args << "--disable-systemd-services"
    args << "--disable-setup"
    args << "--disable-engine"
    args << "--enable-memconf"
    args << "--disable-dconf"
    args << "--with-unicode-emoji-dir=#{emoji_dir}"
    args << "--with-emoji-annotation-dir=#{anno_dir}"
    args << "--with-ucd-dir=#{ucd_dir}"

    xdg_data_dirs = [libexec/"libdbusmenu/share"]
    xdg_data_dirs << "#{HOMEBREW_PREFIX}/share"

    ENV["LC_ALL"] = "C"
    ENV["XDG_DATA_DIRS"] = xdg_data_dirs.join(":")
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"libdbusmenu/lib/pkgconfig"

    system "./autogen.sh", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dbusmenu-jsonloader", "--help"
    system "#{bin}/ibus-daemon", "--version"
  end
end
