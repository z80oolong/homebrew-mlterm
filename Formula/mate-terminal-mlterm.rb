class MateTerminalMlterm < Formula
  desc "Terminal emulator for the MATE desktop environment"
  homepage "https://github.com/mate-desktop/mate-terminal"

  stable do
    url "https://github.com/mate-desktop/mate-terminal/releases/download/v1.28.1/mate-terminal-1.28.1.tar.xz"
    sha256 "f135eb1a9e2ae22798ecb2dc1914fdb4cfd774e6bb65c0152be37cc6c9469e92"

    patch :p1, Formula["z80oolong/vte/mate-terminal@1.28.1"].diff_data
  end

  head do
    url "https://github.com/mate-desktop/mate-terminal.git"

    patch :p1, Formula["z80oolong/vte/mate-terminal"].diff_data
  end

  keg_only "this formula conflicts with 'z80oolong/vte/mate-terminal'"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "itstool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "z80oolong/dep/dconf@0"
  depends_on "z80oolong/dep/mate-desktop@1.28.0"
  depends_on "z80oolong/mlterm/mlterm-libvte@3.9.4"

  def install
    ENV["LC_ALL"] = "C"
    ENV["ACLOCAL_FLAGS"] = "-I #{Formula["z80oolong/dep/mate-desktop@1.28.0"].opt_share}/aclocal"

    args  = std_configure_args
    args << "--disable-schemas-compile"
    args << "--bindir=#{libexec}/bin"

    system "sh", "./autogen.sh", *args
    system "make"
    system "make", "install"

    (pkgshare/"glib-2.0").mkpath
    (pkgshare/"glib-2.0").install share/"glib-2.0/schemas"

    ohai "Create #{bin}/mate-terminal script."
    (bin/"mate-terminal").write(wrapper_script)
    (bin/"mate-terminal").chmod(0755)
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", pkgshare/"glib-2.0/schemas"
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  def gschema_dirs
    dirs = [pkgshare/"glib-2.0/schemas"]
    dirs << (Formula["z80oolong/dep/mate-desktop@1.28.0"].share/"glib-2.0/schemas")
    dirs << (HOMEBREW_PREFIX/"share/glib-2.0/schemas")
    dirs << "${GSETTINGS_SCHEMA_DIR}"
    dirs
  end
  private :gschema_dirs

  def xdg_data_dirs
    dirs = [share]
    dirs << Formula["z80oolong/dep/mate-desktop@1.28.0"].share
    dirs << (HOMEBREW_PREFIX/"share")
    dirs << "/usr/local/share"
    dirs << "/usr/share"
    dirs << "${XDG_DATA_DIRS}"
    dirs
  end
  private :xdg_data_dirs

  def wrapper_script
    <<~EOS
      #!/bin/sh
      export GSETTINGS_SCHEMA_DIR="#{gschema_dirs.join(":")}"
      export XDG_DATA_DIRS="#{xdg_data_dirs.join(":")}"
      exec #{libexec}/bin/mate-terminal $@
    EOS
  end
  private :wrapper_script

  test do
    system bin/"mate-terminal", "--version"
  end
end
